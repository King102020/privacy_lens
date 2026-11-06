// Mirrors lib/core/theme: warm paper + rust (light), charcoal + amber (dark).
export type ThemeName = 'light' | 'dark';

export type Palette = {
  paper: string;
  ink: string;
  accent: string;
  onAccent: string;
  bezel: string;
  rim: string;
  screen: string;
  tile: string[];
  glyph: string;
  low: string;
  medium: string;
  high: string;
  shadow: string;
};

export const palettes: Record<ThemeName, Palette> = {
  light: {
    paper: '#F6EFE6',
    ink: '#1C1410',
    accent: '#B45309',
    onAccent: '#FFF8F0',
    bezel: '#2A211B',
    rim: '#4A3B31',
    screen: '#FBF7F1',
    tile: ['#EADCCB', '#E4D5C3', '#EFE4D6'],
    glyph: '#B9A58F',
    low: '#78716C',
    medium: '#B7791F',
    high: '#BE4B5B',
    shadow: 'rgba(60,35,15,0.22)',
  },
  dark: {
    paper: '#1A1613',
    ink: '#F3E9DD',
    accent: '#E8955A',
    onAccent: '#1A1613',
    bezel: '#0E0B09',
    rim: '#3A2F27',
    screen: '#241E1A',
    tile: ['#332A24', '#2E2620', '#382E27'],
    glyph: '#5E4F43',
    low: '#A8A29E',
    medium: '#D4A24C',
    high: '#E07A8A',
    shadow: 'rgba(0,0,0,0.5)',
  },
};
