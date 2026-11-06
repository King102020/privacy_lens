import {Composition} from 'remotion';
import {Intro, FPS, DURATION_FRAMES, WIDTH, HEIGHT} from './Intro';

export const Root: React.FC = () => (
  <>
    {(['light', 'dark'] as const).map((theme) => (
      <Composition
        key={theme}
        id={`Intro-${theme}`}
        component={Intro}
        durationInFrames={DURATION_FRAMES}
        fps={FPS}
        width={WIDTH}
        height={HEIGHT}
        defaultProps={{theme}}
      />
    ))}
  </>
);
