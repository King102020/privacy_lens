import sys; sys.path.insert(0, '.')
from rv import *

INK = '#1C1410'; RUST = '#B45309'; CARD = '#FBF7F1'; TILE = '#EADCCB'; TILE2 = '#E4D5C3'; SOFT = '#F1E7DA'
GLYPH = '#B9A58F'; ROSE = '#BE4B5B'; ROSEBG = '#F8E1E4'; WHITE = '#FFF8F0'; BEZEL = '#2A211B'

for a in tool('list_artboards', {})['artboards']:
    tool('delete_objects', {'objectIds': [a['id']]})
ab = tool('open_file_editor', {'command': 'createArtboard', 'data': {'createArtboard': [{'name': 'Story', 'width': 360, 'height': 450}]}})
ab = (ab.get('artboards') or ab.get('created'))[0]['id']
I = {'artboard': ab}
for o in tool('query_objects', {'objectIds': [ab], 'depth': 1})['objects']:
    if 'Fill' in o.get('types', []):
        tool('path_editor', {'command': 'setPaints', 'data': {'setPaints': {'paintIds': [o['id']], 'color': '#00000000'}}})


def rect(name, parent, x, y, w, h, r, paints):
    return prim([{'primitive': 'rectangle', 'name': name, 'parentId': parent, 'x': x, 'y': y, 'width': w, 'height': h, 'cornerRadius': r, 'paints': paints}])[0]['id']


def oval(name, parent, x, y, d, paints, h=None):
    return prim([{'primitive': 'ellipse', 'name': name, 'parentId': parent, 'x': x, 'y': y, 'width': d, 'height': h or d, 'paints': paints}])[0]['id']


def path(name, parent, x, y, cmds, paints):
    free([{'name': name, 'parentId': parent, 'x': x, 'y': y, 'paints': paints, 'paths': [{'name': name, 'commands': cmds}]}])
    kids = tool('query_objects', {'objectIds': [parent], 'depth': 1})['objects']
    hits = [o['id'] for o in kids if o.get('name') == name and 'Shape' in o.get('types', [])]
    return hits[-1] if hits else None


def M(x, y): return {'commandType': 'moveTo', 'x': x, 'y': y}
def L(x, y): return {'commandType': 'lineTo', 'x': x, 'y': y}
def C(a, b, c, d, e, f): return {'commandType': 'cubicTo', 'control1X': a, 'control1Y': b, 'control2X': c, 'control2Y': d, 'endX': e, 'endY': f}
Z = {'commandType': 'close'}


def glyph(kind, parent, x, y, color, s=1.0):
    g = group('Glyph_' + kind, parent, x, y)
    def k(v): return v * s
    if kind == 'clock':
        oval('Face', g, 0, 0, k(13), [stroke(color, 2.2 * s)])
        path('Hands', g, 0, 0, [M(0, k(-3.5)), L(0, 0), L(k(3), k(2))], [stroke(color, 2 * s)])
    elif kind == 'pin':
        path('Pin', g, 0, 0, [M(0, k(8)), C(k(-3), k(4), k(-6.5), k(1), k(-6.5), k(-2.5)), C(k(-6.5), k(-6), k(-3.6), k(-8.5), 0, k(-8.5)),
                              C(k(3.6), k(-8.5), k(6.5), k(-6), k(6.5), k(-2.5)), C(k(6.5), k(1), k(3), k(4), 0, k(8)), Z], [fill(color)])
        oval('Hole', g, 0, k(-2.6), k(4.4), [fill(WHITE)])
    elif kind == 'shoe':
        path('Shoe', g, 0, 0, [M(k(-9), k(4)), L(k(-9), k(-5)), L(k(-3.5), k(-5)), C(k(-2.5), k(-1.5), k(1), k(-0.5), k(4.5), 0),
                               C(k(8), k(0.5), k(9), k(2), k(9), k(4)), Z], [fill(color)])
    return g


# Your phone, left side.
ph = I['Phone'] = group('Phone', ab, 118, 240)
rect('Shadow', ph, 0, 10, 150, 300, 28, [fill('#40281406', {'strength': 22})])
rect('Body', ph, 0, 0, 150, 300, 28, [fill(BEZEL), stroke('#5A4A3E', 1.5)])
rect('Screen', ph, 0, 0, 136, 286, 20, [fill(CARD)])
rect('Speaker', ph, 0, -133, 32, 5, 2.5, [fill(BEZEL)])

# App A: a running app with a hidden ad SDK passenger.
ra = I['RunApp'] = group('RunApp', ph, 0, 0)
rect('Header', ra, 0, -104, 118, 34, 10, [fill(TILE)])
oval('Icon', ra, -42, -104, 18, [fill(RUST)])
rect('Title', ra, -2, -108, 52, 6, 3, [fill(GLYPH)])
rect('Sub', ra, -10, -98, 36, 5, 2.5, [fill(TILE2)])
rect('Map', ra, 0, -32, 118, 92, 12, [fill(SOFT)])
path('Route', ra, 0, -32, [M(-44, 30), C(-30, 10, -18, 28, -6, 8), C(4, -8, 18, 12, 28, -6), C(34, -16, 40, -22, 44, -30)], [stroke(RUST, 3)])
oval('RouteEnd', ra, 44, -62, 9, [fill(RUST)])
for i, x in enumerate([-41, 0, 41]):
    rect('Stat%d' % i, ra, x, 42, 34, 34, 9, [fill(TILE)])
    rect('StatBar%d' % i, ra, x, 42, 18, 5, 2.5, [fill(GLYPH)])
pa = I['Passenger'] = group('Passenger', ra, 30, 100)
rect('Body', pa, 0, 0, 46, 26, 13, [fill(ROSE)])
for sx in (-8, 8):
    oval('Eye%d' % sx, pa, sx, -1, 9, [fill(WHITE)])
I['Pupils'] = group('Pupils', pa, 0, 0)
for sx in (-8, 8):
    oval('Pupil%d' % sx, I['Pupils'], sx + 1.5, -1, 4.2, [fill(INK)])
I['BottomCard'] = rect('BottomCard', ra, 0, 104, 118, 46, 12, [fill(TILE)])
rect('BottomBar', ra, -18, 104, 56, 6, 3, [fill(GLYPH)])

# App B: a different app that later shows the targeted shoe ad.
na = I['NewsApp'] = group('NewsApp', ph, 0, 0)
rect('Header', na, 0, -104, 118, 34, 10, [fill(TILE2)])
rect('Icon', na, -42, -104, 18, 18, 5, [fill(INK)])
rect('Title', na, -2, -106, 52, 6, 3, [fill(GLYPH)])
for i, y in enumerate([-62, -38, -14]):
    rect('Row%d' % i, na, 0, y, 118, 18, 6, [fill(SOFT)])
ad = I['ShoeAd'] = group('ShoeAd', na, 0, 52)
rect('Card', ad, 0, 0, 118, 80, 14, [fill('#FFFFFF'), stroke(ROSE, 2.5)])
glyph('shoe', ad, -14, 4, ROSE, 2.6)
rect('AdBadge', ad, 40, -26, 22, 12, 4, [fill(ROSE)])
rect('Cta', ad, 28, 26, 36, 10, 5, [fill(INK)])

# Permission row: Privacy Lens helps you take a permission back.
pr = I['PermRow'] = group('PermRow', ph, 0, 104)
rect('Row', pr, 0, 0, 118, 46, 12, [fill(WHITE), stroke(TILE2, 1.5)])
glyph('pin', pr, -40, 0, INK, 1.1)
rect('Label', pr, -12, 0, 30, 6, 3, [fill(GLYPH)])
I['Track'] = rect('Track', pr, 34, 0, 34, 18, 9, [fill(RUST)])
I['Knob'] = oval('Knob', pr, 42, 0, 13, [fill(WHITE)])

# Them: the ad network, right side.
an = I['AdNetwork'] = group('AdNetwork', ab, 292, 88)
rect('Back2', an, 12, -12, 76, 64, 14, [fill('#5A2E36')])
rect('Back1', an, 6, -6, 76, 64, 14, [fill('#7A3A44')])
rect('Card', an, 0, 0, 76, 64, 14, [fill('#3A1F24'), stroke(ROSE, 2)])
rect('Tower', an, 0, 4, 18, 34, 3, [fill(WHITE)])
rect('WingL', an, -15, 10, 12, 22, 3, [fill('#E9D6D9')])
rect('WingR', an, 15, 10, 12, 22, 3, [fill('#E9D6D9')])
oval('Signal', an, 0, -19, 8, [fill(ROSE)])

# Activity bubbles: what the passenger sends out.
for i, kind in enumerate(['clock', 'pin', 'shoe']):
    b = I['Bubble%d' % i] = group('Bubble%d' % i, ab, 148, 310)
    oval('Disc', b, 0, 0, 30, [fill(WHITE), stroke(ROSE, 2.5)])
    glyph(kind, b, 0, 0, ROSE, 1.0)

# The profile they build about you.
pf = I['Profile'] = group('Profile', ab, 292, 268)
rect('Shadow', pf, 0, 8, 104, 150, 16, [fill('#40281406', {'strength': 18})])
rect('Card', pf, 0, 0, 104, 150, 16, [fill(WHITE), stroke(TILE2, 1.5)])
oval('Avatar', pf, 0, -44, 38, [fill(TILE)])
oval('Head', pf, 0, -49, 13, [fill(GLYPH)])
rect('Shoulders', pf, 0, -35, 20, 9, 4.5, [fill(GLYPH)])
for i, kind in enumerate(['clock', 'pin', 'shoe']):
    t = I['Tag%d' % i] = group('Tag%d' % i, pf, 0, 2 + i * 24)
    rect('Pill', t, 0, 0, 80, 18, 9, [fill(ROSEBG)])
    glyph(kind, t, -28, 0, ROSE, 0.62)
    rect('Bar', t, 6, 0, 40, 5, 2.5, [fill(ROSE)])

# Privacy Lens: the lens and the shield, only in the last beat.
ln = I['Lens'] = group('Lens', ab, 150, 312)
oval('Glass', ln, 0, 0, 56, [fill('#1AB45309'), stroke(RUST, 4)])
path('Handle', ln, 0, 0, [M(20, 20), L(34, 34)], [stroke(RUST, 6)])
sh = I['Shield'] = group('Shield', ab, 226, 176)
SHIELD = [M(0, -26), L(22, -18), L(22, 0), C(22, 14, 12, 22, 0, 28), C(-12, 22, -22, 14, -22, 0), L(-22, -18), Z]
path('Glow', sh, 0, 2, SHIELD, [fill('#55B45309', {'strength': 16})])
path('Plate', sh, 0, 0, SHIELD, [fill(RUST)])
I['Check'] = path('Check', sh, 0, 0, [M(-9, 1), L(-2, 8), L(10, -7)], [stroke(WHITE, 4)])
save(I)
print(json.dumps(I))
