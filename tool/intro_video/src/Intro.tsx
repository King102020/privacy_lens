import {AbsoluteFill, Easing, interpolate, useCurrentFrame} from 'remotion';
import {palettes, type Palette, type ThemeName} from './theme';

// Must match _story (14 s) and the beat windows in onboarding_screen.dart.
export const FPS = 30;
export const DURATION_FRAMES = 14 * FPS;
export const WIDTH = 1080;
export const HEIGHT = 1350;

// Formal motion: no overshoot, no bounce.
const travel = Easing.bezier(0.2, 0, 0, 1);
const reveal = Easing.out(Easing.cubic);
const sweep = Easing.inOut(Easing.cubic);

const ramp = (t: number, a: number, b: number, easing = reveal) =>
  interpolate(t, [a, b], [0, 1], {
    easing,
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

// Fade in over [a, b], out over [c, d].
const window4 = (t: number, a: number, b: number, c: number, d: number) =>
  Math.min(ramp(t, a, b), 1 - ramp(t, c, d, Easing.in(Easing.cubic)));

const lerp = (a: number, b: number, k: number) => a + (b - a) * k;

const quad = (
  p0: [number, number],
  c: [number, number],
  p1: [number, number],
  k: number,
): [number, number] => [
  (1 - k) ** 2 * p0[0] + 2 * (1 - k) * k * c[0] + k ** 2 * p1[0],
  (1 - k) ** 2 * p0[1] + 2 * (1 - k) * k * c[1] + k ** 2 * p1[1],
];

// Phone and grid geometry (composition px).
const PHONE = {x: 280, y: 150, w: 520, h: 1050, r: 76};
const SCREEN = {x: 300, y: 170, w: 480, h: 1010, r: 58};
const TILE = 112;
const COLS = [336, 484, 632];
const ROWS = [320, 492, 664, 836];
const tiles = ROWS.flatMap((y, row) =>
  COLS.map((x, col) => ({x, y, i: row * 3 + col, row, col})),
);
const centerOf = (i: number): [number, number] => [
  tiles[i].x + TILE / 2,
  tiles[i].y + TILE / 2,
];

const FOCUS = 4; // middle tile, row 1
// 0 low, 1 medium, 2 high.
const SEVERITY = [0, 1, 2, 0, 2, 0, 1, 0, 0, 1, 0, 2];

const SHIELD_C: [number, number] = [540, 640];
const SERVERS: [number, number][] = [
  [110, 190],
  [975, 250],
  [985, 760],
];

export const Intro: React.FC<{theme: ThemeName}> = ({theme}) => {
  const p = palettes[theme];
  const t = useCurrentFrame() / FPS;

  // Everything except the phone fades out before 14 s so the loop is seamless.
  const outro = 1 - ramp(t, 13.35, 13.95, Easing.in(Easing.cubic));

  // Scene 3 pulls the camera back a touch.
  const zoom =
    lerp(1, 0.93, ramp(t, 6.8, 7.6, sweep)) +
    lerp(0, 0.07, ramp(t, 10.0, 10.8, sweep));
  const camY = lerp(0, -18, ramp(t, 6.8, 7.6, sweep)) * (1 - ramp(t, 10.0, 10.8, sweep));

  return (
    <AbsoluteFill style={{backgroundColor: p.paper}}>
      <svg viewBox={`0 0 ${WIDTH} ${HEIGHT}`} width={WIDTH} height={HEIGHT}>
        <defs>
          <radialGradient id="glow" cx="50%" cy="48%" r="55%">
            <stop offset="0%" stopColor={p.accent} stopOpacity={0.1} />
            <stop offset="100%" stopColor={p.accent} stopOpacity={0} />
          </radialGradient>
          <linearGradient id="band" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor={p.accent} stopOpacity={0} />
            <stop offset="85%" stopColor={p.accent} stopOpacity={0.16} />
            <stop offset="100%" stopColor={p.accent} stopOpacity={0.9} />
          </linearGradient>
          <filter id="lift" x="-30%" y="-30%" width="160%" height="160%">
            <feDropShadow dx="0" dy="14" stdDeviation="18" floodColor={p.shadow} />
          </filter>
          <filter id="soft" x="-30%" y="-30%" width="160%" height="160%">
            <feDropShadow dx="0" dy="6" stdDeviation="8" floodColor={p.shadow} />
          </filter>
          <clipPath id="screen">
            <rect x={SCREEN.x} y={SCREEN.y} width={SCREEN.w} height={SCREEN.h} rx={SCREEN.r} />
          </clipPath>
        </defs>

        <rect width={WIDTH} height={HEIGHT} fill="url(#glow)" />

        <g transform={`translate(540 ${675 + camY}) scale(${zoom}) translate(-540 -675)`}>
          <Servers p={p} t={t} />
          <Phone p={p} />
          <g clipPath="url(#screen)">
            <StatusBar p={p} t={t} outro={outro} />
            <Tiles p={p} t={t} outro={outro} />
            <ScanBand t={t} />
          </g>
          <Lens p={p} t={t} />
          <CodeLayers p={p} t={t} />
          <Exfil p={p} t={t} />
          <Score p={p} t={t} outro={outro} />
          <Shield p={p} t={t} outro={outro} />
        </g>
      </svg>
    </AbsoluteFill>
  );
};

const Phone: React.FC<{p: Palette}> = ({p}) => (
  <g filter="url(#lift)">
    <rect x={PHONE.x} y={PHONE.y} width={PHONE.w} height={PHONE.h} rx={PHONE.r} fill={p.bezel} />
    <rect
      x={PHONE.x + 3}
      y={PHONE.y + 3}
      width={PHONE.w - 6}
      height={PHONE.h - 6}
      rx={PHONE.r - 3}
      fill="none"
      stroke={p.rim}
      strokeWidth={2}
    />
    <rect x={SCREEN.x} y={SCREEN.y} width={SCREEN.w} height={SCREEN.h} rx={SCREEN.r} fill={p.screen} />
    <rect x={500} y={186} width={80} height={14} rx={7} fill={p.bezel} />
  </g>
);

const StatusBar: React.FC<{p: Palette; t: number; outro: number}> = ({p, t, outro}) => {
  const k = ramp(t, 0.1, 0.7) * outro;
  return (
    <g opacity={k}>
      <rect x={336} y={236} width={150} height={18} rx={9} fill={p.glyph} opacity={0.7} />
      <rect x={336 + 160} y={236} width={60} height={18} rx={9} fill={p.glyph} opacity={0.35} />
    </g>
  );
};

const Tiles: React.FC<{p: Palette; t: number; outro: number}> = ({p, t, outro}) => {
  const bandY = scanY(t);
  const dim = 1 - 0.55 * window4(t, 10.1, 10.6, 13.0, 13.5);
  return (
    <g>
      {tiles.map(({x, y, i, row, col}) => {
        const start = 0.2 + (row + col) * 0.08;
        const k = ramp(t, start, start + 0.55) * outro;
        const focus = i === FOCUS ? window4(t, 1.95, 2.35, 3.3, 3.7) : 0;
        const lift = 1 + 0.08 * focus;
        const otherDim = i === FOCUS ? 1 : 1 - 0.45 * window4(t, 1.95, 2.35, 3.3, 3.7);
        const cx = x + TILE / 2;
        const cy = y + TILE / 2;
        // Severity dot appears once the scan band has passed this row.
        const passed = ramp(bandY, y + TILE * 0.6, y + TILE * 0.6 + 60, Easing.linear);
        const sev = passed * window4(t, 6.9, 7.0, 13.2, 13.8);
        const sevColor = [p.low, p.medium, p.high][SEVERITY[i]];
        return (
          <g
            key={i}
            opacity={k * otherDim * dim}
            transform={`translate(0 ${lerp(26, 0, k)}) translate(${cx} ${cy}) scale(${lift}) translate(${-cx} ${-cy})`}
          >
            <rect
              x={x}
              y={y}
              width={TILE}
              height={TILE}
              rx={30}
              fill={p.tile[i % 3]}
              filter={focus > 0.01 ? 'url(#soft)' : undefined}
            />
            <Glyph x={cx} y={cy} kind={i % 4} color={p.glyph} />
            <rect x={x + 14} y={y + TILE + 14} width={TILE - 28} height={10} rx={5} fill={p.glyph} opacity={0.45} />
            {sev > 0.01 && (
              <circle
                cx={x + TILE - 6}
                cy={y + 6}
                r={13 * sev}
                fill={sevColor}
                stroke={p.screen}
                strokeWidth={4}
              />
            )}
          </g>
        );
      })}
    </g>
  );
};

const Glyph: React.FC<{x: number; y: number; kind: number; color: string}> = ({x, y, kind, color}) => {
  switch (kind) {
    case 0:
      return <circle cx={x} cy={y} r={22} fill="none" stroke={color} strokeWidth={8} />;
    case 1:
      return <rect x={x - 20} y={y - 20} width={40} height={40} rx={10} fill={color} />;
    case 2:
      return <path d={`M${x - 24} ${y + 18} L${x} ${y - 22} L${x + 24} ${y + 18} Z`} fill={color} />;
    default:
      return (
        <g fill={color}>
          <rect x={x - 22} y={y - 16} width={44} height={9} rx={4.5} />
          <rect x={x - 22} y={y + 6} width={30} height={9} rx={4.5} />
        </g>
      );
  }
};

// Scene 1: a rust lens finds ad code in one app.
const Lens: React.FC<{p: Palette; t: number}> = ({p, t}) => {
  const [tx, ty] = centerOf(FOCUS);
  const k = ramp(t, 1.0, 1.95, travel);
  const x = lerp(860, tx, k);
  const y = lerp(260, ty, k);
  const o = window4(t, 0.95, 1.3, 3.1, 3.5);
  const r = lerp(96, 86, ramp(t, 1.8, 2.2));
  return (
    <g opacity={o}>
      <circle cx={x} cy={y} r={r} fill={p.accent} fillOpacity={0.06} stroke={p.accent} strokeWidth={8} />
      <line
        x1={x + r * 0.71}
        y1={y + r * 0.71}
        x2={x + r * 0.71 + 54 * (1 - k * 0.3)}
        y2={y + r * 0.71 + 54 * (1 - k * 0.3)}
        stroke={p.accent}
        strokeWidth={14}
        strokeLinecap="round"
      />
    </g>
  );
};

// The SDK chips that lift out of the focused app and later leave the phone.
const CHIPS = [
  {dx: -96, dy: -150, sev: 2},
  {dx: 0, dy: -176, sev: 1},
  {dx: 96, dy: -150, sev: 2},
];

const chipFill = (p: Palette, sev: number) => [p.low, p.medium, p.high][sev];

const CodeLayers: React.FC<{p: Palette; t: number}> = ({p, t}) => {
  const [cx, cy] = centerOf(FOCUS);
  // Thin code rows unfold under the lens.
  const rows = [0, 1, 2].map((j) => ramp(t, 2.1 + j * 0.08, 2.5 + j * 0.08));
  const rowsOut = 1 - ramp(t, 3.2, 3.55);
  return (
    <g>
      <g opacity={rowsOut}>
        {rows.map((k, j) => (
          <rect
            key={j}
            x={cx - 46}
            y={cy - 26 + j * 22}
            width={92 * k * [1, 0.7, 0.85][j]}
            height={10}
            rx={5}
            fill={j === 1 ? p.accent : p.ink}
            opacity={0.75 * k}
          />
        ))}
      </g>
      {CHIPS.map((c, j) => {
        const k = ramp(t, 2.45 + j * 0.12, 3.05 + j * 0.12, travel);
        const hand = 1 - ramp(t, 3.55, 3.75, Easing.linear);
        if (k <= 0 || hand <= 0) return null;
        return (
          <Capsule
            key={j}
            x={lerp(cx, cx + c.dx, k)}
            y={lerp(cy, cy + c.dy, k)}
            color={chipFill(p, c.sev)}
            opacity={k * hand}
            screen={p.screen}
          />
        );
      })}
    </g>
  );
};

const Capsule: React.FC<{x: number; y: number; color: string; opacity: number; screen: string; scale?: number}> = ({
  x,
  y,
  color,
  opacity,
  screen,
  scale = 1,
}) => (
  <g opacity={opacity} transform={`translate(${x} ${y}) scale(${scale})`} filter="url(#soft)">
    <rect x={-34} y={-17} width={68} height={34} rx={17} fill={color} />
    <circle cx={-14} cy={0} r={6} fill={screen} />
    <rect x={-2} y={-4} width={22} height={8} rx={4} fill={screen} opacity={0.85} />
  </g>
);

// Scene 2: those chips carry data off the phone to remote endpoints.
const LANES = CHIPS.map((c, j) => {
  const [cx, cy] = centerOf(FOCUS);
  const from: [number, number] = [cx + c.dx, cy + c.dy];
  const to = SERVERS[j];
  const ctrl: [number, number] = [lerp(from[0], to[0], 0.5), Math.min(from[1], to[1]) - 140];
  return {from, to, ctrl, sev: c.sev};
});

const Servers: React.FC<{p: Palette; t: number}> = ({p, t}) => (
  <g>
    {SERVERS.map(([x, y], j) => {
      const o = window4(t, 3.4 + j * 0.1, 3.9 + j * 0.1, 6.6, 7.0);
      const pulse = ramp((t - 3.9 - j * 0.35) % 1.2, 0, 1.2, Easing.out(Easing.quad));
      return (
        <g key={j} opacity={o}>
          <circle cx={x} cy={y} r={lerp(30, 64, pulse)} fill="none" stroke={p.ink} strokeOpacity={0.18 * (1 - pulse)} strokeWidth={3} />
          <circle cx={x} cy={y} r={30} fill={p.screen} stroke={p.ink} strokeOpacity={0.35} strokeWidth={3} />
          <rect x={x - 13} y={y - 11} width={26} height={7} rx={3.5} fill={p.ink} opacity={0.45} />
          <rect x={x - 13} y={y + 3} width={26} height={7} rx={3.5} fill={p.ink} opacity={0.3} />
        </g>
      );
    })}
  </g>
);

const Exfil: React.FC<{p: Palette; t: number}> = ({p, t}) => {
  const trail = window4(t, 3.5, 4.2, 6.6, 7.0);
  return (
    <g>
      {LANES.map((l, j) => {
        const d = `M${l.from[0]} ${l.from[1]} Q${l.ctrl[0]} ${l.ctrl[1]} ${l.to[0]} ${l.to[1]}`;
        const draw = ramp(t, 3.5 + j * 0.1, 4.3 + j * 0.1, travel);
        return (
          <g key={j}>
            <path
              d={d}
              fill="none"
              stroke={chipFill(p, l.sev)}
              strokeOpacity={0.5 * trail}
              strokeWidth={4}
              strokeLinecap="round"
              strokeDasharray="2 16"
              opacity={draw}
            />
            {[0, 1, 2].map((w) => {
              // Each lane sends three packets, staggered.
              const s = 3.6 + j * 0.18 + w * 0.95;
              const k = ramp(t, s, s + 1.25, travel);
              if (k <= 0 || k >= 1) return null;
              const [x, y] = quad(l.from, l.ctrl, l.to, k);
              const o = Math.min(1, k * 6) * (1 - ramp(k, 0.8, 1, Easing.linear));
              return (
                <Capsule
                  key={w}
                  x={x}
                  y={y}
                  color={chipFill(p, l.sev)}
                  opacity={o}
                  screen={p.screen}
                  scale={lerp(1, 0.7, k)}
                />
              );
            })}
          </g>
        );
      })}
    </g>
  );
};

// Scene 3: a scan band sweeps every app.
const scanY = (t: number) => lerp(SCREEN.y - 120, SCREEN.y + SCREEN.h + 40, ramp(t, 7.0, 9.1, sweep));

const ScanBand: React.FC<{t: number}> = ({t}) => {
  const y = scanY(t);
  const o = window4(t, 6.95, 7.15, 8.9, 9.2);
  return <rect x={SCREEN.x} y={y - 120} width={SCREEN.w} height={124} fill="url(#band)" opacity={o} />;
};

const Score: React.FC<{p: Palette; t: number; outro: number}> = ({p, t, outro}) => {
  const o = window4(t, 8.95, 9.35, 10.3, 10.65) * outro;
  if (o <= 0) return null;
  const fill = 0.64 * ramp(t, 9.1, 10.05, sweep);
  const r = 58;
  const c = 2 * Math.PI * r;
  const x = 540;
  const y = 1065;
  return (
    <g opacity={o} transform={`translate(0 ${lerp(20, 0, o)})`}>
      <rect x={x - 200} y={y - 82} width={400} height={164} rx={44} fill={p.screen} filter="url(#soft)" />
      <circle cx={x - 110} cy={y} r={r} fill="none" stroke={p.glyph} strokeOpacity={0.4} strokeWidth={14} />
      <circle
        cx={x - 110}
        cy={y}
        r={r}
        fill="none"
        stroke={p.accent}
        strokeWidth={14}
        strokeLinecap="round"
        strokeDasharray={`${c * fill} ${c}`}
        transform={`rotate(-90 ${x - 110} ${y})`}
      />
      {[p.high, p.medium, p.low].map((col, j) => (
        <g key={j}>
          <circle cx={x + 2} cy={y - 40 + j * 40} r={10} fill={col} />
          <rect
            x={x + 22}
            y={y - 45 + j * 40}
            width={[120, 90, 140][j] * ramp(t, 9.3 + j * 0.12, 9.8 + j * 0.12)}
            height={10}
            rx={5}
            fill={p.ink}
            opacity={0.35}
          />
        </g>
      ))}
    </g>
  );
};

// Scene 4: Tracker Shield docks and stops tracker lookups.
const SHIELD_PATH = 'M0 -120 L100 -82 L100 6 C100 70 56 112 0 136 C-56 112 -100 70 -100 6 L-100 -82 Z';
const CHECK_PATH = 'M-44 6 L-12 38 L48 -30';
const BLOCKED = [0, 2, 6, 8, 9, 11, 3, 5];

const Shield: React.FC<{p: Palette; t: number; outro: number}> = ({p, t, outro}) => {
  const dock = ramp(t, 10.15, 10.85, travel);
  if (dock <= 0) return null;
  const [sx, sy] = SHIELD_C;
  const y = lerp(sy - 220, sy, dock);
  const stroke = ramp(t, 10.25, 11.0, reveal);
  const fill = ramp(t, 12.0, 12.55, reveal);
  const check = ramp(t, 12.45, 12.95, travel);
  return (
    <g opacity={outro}>
      {BLOCKED.map((i, j) => {
        const s = 10.7 + j * 0.16;
        const k = ramp(t, s, s + 0.7, travel);
        if (k <= 0 || k >= 1) return null;
        const from = centerOf(i);
        const to: [number, number] = [sx + (from[0] - sx) * 0.35, sy + (from[1] - sy) * 0.35];
        const x = lerp(from[0], to[0], k);
        const yy = lerp(from[1], to[1], k);
        const hit = ramp(k, 0.75, 1, Easing.linear);
        return (
          <Capsule
            key={i}
            x={x}
            y={yy}
            color={chipFill(p, SEVERITY[i] === 0 ? 1 : SEVERITY[i])}
            opacity={Math.min(1, k * 5) * (1 - hit)}
            screen={p.screen}
            scale={1 - 0.35 * hit}
          />
        );
      })}
      <g transform={`translate(${sx} ${y})`} opacity={dock}>
        <circle r={lerp(150, 190, stroke)} fill={p.accent} fillOpacity={0.08 * stroke} />
        <path d={SHIELD_PATH} fill={p.screen} filter="url(#lift)" />
        <path d={SHIELD_PATH} fill={p.accent} opacity={fill} />
        <path
          d={SHIELD_PATH}
          fill="none"
          stroke={p.accent}
          strokeWidth={12}
          strokeLinejoin="round"
          pathLength={1}
          strokeDasharray="1 1"
          strokeDashoffset={1 - stroke}
        />
        <path
          d={CHECK_PATH}
          fill="none"
          stroke={p.onAccent}
          strokeWidth={18}
          strokeLinecap="round"
          strokeLinejoin="round"
          pathLength={1}
          strokeDasharray="1 1"
          strokeDashoffset={1 - check}
        />
      </g>
    </g>
  );
};
