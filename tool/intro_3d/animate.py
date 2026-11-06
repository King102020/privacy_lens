"""Bakes the 14 s onboarding loop into the PrivacyLensIntro scene.

Run inside Blender (dev-only; the app never runs this):
    exec(open(r"tool/intro_3d/animate.py").read())

Timings mirror the beat windows in onboarding_screen.dart:
(0.15, 3.5) find ad code, (3.35, 6.9) data leaves, (6.7, 10.3) scan,
(10.05, 13.85) shield. Everything but the phone is gone by 13.95 s so the
loop is seamless. Motion is critically damped: no bounce, no flash.
"""

import math

import bpy

sc = bpy.data.scenes["PrivacyLensIntro"]
O = bpy.data.objects
FPS = 30
N = 14 * FPS
TINY = 1e-4


def bez(x1, y1, x2, y2):
    def f(x):
        lo, hi = 0.0, 1.0
        for _ in range(30):
            m = (lo + hi) / 2
            bx = 3 * (1 - m) ** 2 * m * x1 + 3 * (1 - m) * m * m * x2 + m**3
            lo, hi = (m, hi) if bx < x else (lo, m)
        m = (lo + hi) / 2
        return 3 * (1 - m) ** 2 * m * y1 + 3 * (1 - m) * m * m * y2 + m**3

    return f


travel = bez(0.2, 0, 0, 1)


def reveal(k):
    return 1 - (1 - k) ** 3


def sweep(k):
    return 4 * k**3 if k < 0.5 else 1 - (-2 * k + 2) ** 3 / 2


def ein(k):
    return k**3


def linear(k):
    return k


def ramp(t, a, b, e=reveal):
    return e(min(1, max(0, (t - a) / (b - a))))


def win(t, a, b, c, d):
    return min(ramp(t, a, b), 1 - ramp(t, c, d, ein))


def lerp(a, b, k):
    return a + (b - a) * k


def quad(p0, c, p1, k):
    return tuple((1 - k) ** 2 * a + 2 * (1 - k) * k * b + k * k * d for a, b, d in zip(p0, c, p1))


def S(v):
    return max(TINY, v)


for o in sc.objects:
    if "base_loc" not in o:
        o["base_loc"] = list(o.location)
        o["base_rot"] = list(o.rotation_euler)


def B(n):
    return tuple(O[n]["base_loc"])


ROWS = [0.30, 0.11, -0.08, -0.27]
COLS = [-0.148, 0, 0.148]
FZ = -0.035
FRONT = FZ - 0.07
FOCUS = 4
BLOCKED = [0, 2, 6, 8, 9, 11, 3, 5]
CHIPS = [B(f"PL_Chip{j}") for j in range(3)]
# Remote endpoints, kept inside the frame so the data visibly arrives.
SERVERS = [(-0.40, -0.12, 0.62), (0.40, -0.12, 0.66), (0.43, -0.12, -0.02)]
SHIELD = B("PL_Shield")
CAM = B("PL_Cam")


def tile(i):
    return COLS[i % 3], ROWS[i // 3]


rec = {}


def put(idb, path, idx, f, v):
    rec.setdefault((idb, path, idx), []).append((f, v))


def loc(o, f, v):
    for i in range(3):
        put(o, "location", i, f, v[i])


def scl(o, f, s):
    for i in range(3):
        put(o, "scale", i, f, s)


def rot(o, f, v):
    for i in range(3):
        put(o, "rotation_euler", i, f, v[i])


for f in range(N):
    t = f / FPS
    outro = 1 - ramp(t, 13.35, 13.95, ein)

    # Slow idle sway, one full period per loop so it wraps cleanly.
    r = O["PL_PhoneRoot"]
    br = r["base_rot"]
    phase = 2 * math.pi * t / 14
    rot(r, f, (br[0] + math.radians(0.8) * math.sin(phase + 1), br[1], br[2] + math.radians(1.5) * math.sin(phase)))

    fac = 1 + 0.09 * ramp(t, 6.8, 7.6, sweep) - 0.09 * ramp(t, 10.0, 10.8, sweep)
    loc(O["PL_Cam"], f, tuple(c * fac for c in CAM))

    # Beat 1: apps rise in, the lens finds ad code in one of them.
    focus = win(t, 1.95, 2.35, 3.3, 3.7)
    for i in range(12):
        o = O[f"PL_App{i:02d}"]
        bl = o["base_loc"]
        st = 0.2 + ((i // 3) + (i % 3)) * 0.08
        k = ramp(t, st, st + 0.55)
        lift = focus if i == FOCUS else 0
        loc(o, f, (bl[0], bl[1] - 0.05 * lift, bl[2] - 0.035 * (1 - k)))
        scl(o, f, S(k * outro * (1 + 0.1 * lift)))

    fx, fz = tile(FOCUS)
    lk = ramp(t, 1.0, 1.95, travel)
    loc(O["PL_Lens"], f, (lerp(0.5, fx, lk), lerp(FRONT - 0.08, FRONT - 0.03, lk), lerp(0.48, fz, lk)))
    scl(O["PL_Lens"], f, S(win(t, 0.95, 1.3, 3.1, 3.5)))

    for j in range(3):
        k = ramp(t, 2.45 + j * 0.12, 3.05 + j * 0.12, travel)
        hand = 1 - ramp(t, 3.55, 3.75, linear)
        c = CHIPS[j]
        loc(O[f"PL_Chip{j}"], f, (lerp(fx, c[0], k), lerp(FZ, c[1], k), lerp(fz, c[2], k)))
        scl(O[f"PL_Chip{j}"], f, S(k * hand))

    # Beat 2: that code sends data to remote endpoints, in three waves.
    for j in range(3):
        sv = O[f"PL_Server{j}"]
        k = win(t, 3.4 + j * 0.1, 3.9 + j * 0.1, 6.6, 7.0)
        pulse = 1 + 0.06 * max(0, math.sin((t - 4.0 - j * 0.3) * 2 * math.pi / 0.95)) * (t > 4.0)
        loc(sv, f, SERVERS[j])
        scl(sv, f, S(k * pulse))
    for p in range(9):
        lane, wave = p % 3, p // 3
        s = 3.6 + lane * 0.18 + wave * 0.95
        k = ramp(t, s, s + 1.25, travel)
        p0, p1 = CHIPS[lane], SERVERS[lane]
        ctrl = (lerp(p0[0], p1[0], 0.5), -0.25, max(p0[2], p1[2]) + 0.12)
        vis = 0 if k <= 0 or k >= 1 else min(1, k * 6) * (1 - ramp(k, 0.85, 1, linear))
        loc(O[f"PL_Pkt{p}"], f, quad(p0, ctrl, p1, k))
        scl(O[f"PL_Pkt{p}"], f, S(vis * lerp(1, 0.6, k)))

    # Beat 3: a scan sweeps every app and marks it low / medium / high.
    bz = lerp(0.56, -0.56, ramp(t, 7.0, 9.1, sweep))
    bb = O["PL_ScanBar"]["base_loc"]
    loc(O["PL_ScanBar"], f, (bb[0], bb[1], bz))
    scl(O["PL_ScanBar"], f, S(win(t, 6.95, 7.15, 8.9, 9.2)))
    for i in range(12):
        passed = ramp(ROWS[i // 3] + 0.05 - bz, 0, 0.06)
        scl(O[f"PL_Dot{i:02d}"], f, S(passed * win(t, 6.9, 7.0, 13.2, 13.8)))

    # Beat 4: Tracker Shield docks and stops tracker lookups.
    d = ramp(t, 10.15, 10.85, travel)
    sh = O["PL_Shield"]
    loc(sh, f, (SHIELD[0], SHIELD[1] - 0.08 * (1 - d), SHIELD[2] + 0.32 * (1 - d)))
    rot(sh, f, (0, 0, math.radians(28) * (1 - d)))
    settle = 1 + 0.04 * ramp(t, 12.0, 12.5) - 0.04 * ramp(t, 12.5, 13.0)
    scl(sh, f, S(d * outro * settle))
    put(O["PL_Check"].data, "bevel_factor_end", 0, f, ramp(t, 12.45, 12.95, travel))
    scl(O["PL_Check"], f, S(1.0 if t >= 12.45 else 0))
    for j, i in enumerate(BLOCKED):
        s = 10.7 + j * 0.16
        k = ramp(t, s, s + 0.7, travel)
        tx, tz = tile(i)
        to = (SHIELD[0] + (tx - SHIELD[0]) * 0.35, SHIELD[1] - 0.02, SHIELD[2] + (tz - SHIELD[2]) * 0.35)
        hit = ramp(k, 0.75, 1, linear)
        vis = 0 if k <= 0 or k >= 1 else min(1, k * 5) * (1 - hit)
        loc(O[f"PL_Blk{j}"], f, (lerp(tx, to[0], k), lerp(FZ - 0.03, to[1], k), lerp(tz, to[2], k)))
        scl(O[f"PL_Blk{j}"], f, S(vis * (1 - 0.35 * hit)))

cleared = set()
for (idb, path, idx), vals in rec.items():
    if idb not in cleared:
        if idb.animation_data and idb.animation_data.action:
            bpy.data.actions.remove(idb.animation_data.action)
        cleared.add(idb)
    ad = idb.animation_data or idb.animation_data_create()
    if not ad.action:
        ad.action = bpy.data.actions.new("PL_" + idb.name)
    fc = ad.action.fcurve_ensure_for_datablock(idb, path, index=idx)
    fc.keyframe_points.clear()
    fc.keyframe_points.add(len(vals))
    fc.keyframe_points.foreach_set("co", [x for fv in vals for x in fv])
    for kp in fc.keyframe_points:
        kp.interpolation = "LINEAR"
    fc.update()

sc.frame_start = 0
sc.frame_end = N - 1
