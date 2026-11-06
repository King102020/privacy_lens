"""Keys the onboarding beats into the Rive Story artboard.

Each beat is a one-shot timeline that starts from a complete state, so the
state machine can enter it from the previous beat without a jump.
"""
import sys; sys.path.insert(0, '.')
from rv import *

I = ids()
FPS = 60
DUR = 3.4
X, Y, SX, SY, OP = 13, 14, 16, 17, 18
COLOR, TRIM_END = 37, 115
TRIM = '5-1345'
TRACK_COLOR = '5-1125'

EASE = {
    'out': {'interpolationType': 'cubic', 'cubicParams': {'x1': 0.16, 'y1': 1, 'x2': 0.3, 'y2': 1}},
    'io': {'interpolationType': 'cubic', 'cubicParams': {'x1': 0.65, 'y1': 0, 'x2': 0.35, 'y2': 1}},
    'lin': {'interpolationType': 'linear'},
    'hold': {'interpolationType': 'hold'},
}

GROUPS = ['RunApp', 'NewsApp', 'ShoeAd', 'Passenger', 'PermRow', 'AdNetwork', 'Bubble0', 'Bubble1', 'Bubble2',
          'Profile', 'Tag0', 'Tag1', 'Tag2', 'Lens', 'Shield']
PEEK = (148, 314)       # passenger, world space, when it peeks out
NET = (292, 88)         # ad network
SHIELD = (226, 176)


class Beat:
    def __init__(self, base):
        self.tracks = {}
        for g, op in base.items():
            self.key(g, OP, 0, op)

    def key(self, obj, prop, t, v, ease='out'):
        oid = I.get(obj, obj)
        self.tracks.setdefault((oid, prop), []).append((t, v, ease))
        return self

    def tween(self, obj, prop, t0, v0, t1, v1, ease='out'):
        self.key(obj, prop, t0, v0, ease)
        self.key(obj, prop, t1, v1, 'hold')
        return self

    def keyframes(self):
        out = []
        for (oid, prop), keys in self.tracks.items():
            seen = {}
            for t, v, e in sorted(keys, key=lambda k: k[0]):
                seen[round(t * FPS)] = (v, e)
            for f, (v, e) in sorted(seen.items()):
                kf = {'objectId': oid, 'propertyKey': prop, 'frame': f, 'value': v}
                kf.update(EASE[e])
                out.append(kf)
        return out


def hidden(**visible):
    base = {g: 0 for g in GROUPS}
    base.update(visible)
    return base


def bubble_trip(b, i, start, end, t0, travel=1.1, fade_at=0.85):
    """A data bubble leaves the passenger and travels toward `end`."""
    name = 'Bubble%d' % i
    mid = ((start[0] + end[0]) / 2 + 26, (start[1] + end[1]) / 2 + 18)
    b.key(name, X, t0, start[0], 'io').key(name, Y, t0, start[1], 'io')
    b.key(name, X, t0 + travel * 0.5, mid[0], 'io').key(name, Y, t0 + travel * 0.5, mid[1], 'io')
    b.key(name, X, t0 + travel, end[0], 'hold').key(name, Y, t0 + travel, end[1], 'hold')
    b.tween(name, OP, t0, 0, t0 + 0.15, 100)
    b.tween(name, OP, t0 + travel * fade_at, 100, t0 + travel, 0, 'lin')
    for s in (SX, SY):
        b.tween(name, s, t0, 50, t0 + 0.2, 100)
        b.tween(name, s, t0 + travel * 0.6, 100, t0 + travel, 55, 'io')


def reset_positions(b):
    for i in range(3):
        b.key('Bubble%d' % i, X, 0, PEEK[0], 'hold').key('Bubble%d' % i, Y, 0, PEEK[1], 'hold')
    b.key('Passenger', Y, 0, 74, 'hold')
    b.key('ShoeAd', Y, 0, 52, 'hold')
    b.key('PermRow', Y, 0, 104, 'hold')
    b.key('Profile', Y, 0, 268, 'hold')
    b.key('Knob', X, 0, 42, 'hold')
    b.key(TRACK_COLOR, COLOR, 0, '#FFB45309', 'hold')
    b.key(TRIM, TRIM_END, 0, 100, 'hold')
    b.key('Lens', X, 0, 300, 'hold').key('Lens', Y, 0, 420, 'hold')
    for g in ('Shield', 'AdNetwork', 'Lens'):
        for s in (SX, SY):
            b.key(g, s, 0, 100, 'hold')


def beat1(clean):
    """Your apps hide ad and tracking code."""
    if clean:
        b = Beat(hidden(Passenger=100))
        b.tween('RunApp', OP, 0, 0, 0.4, 100)
    else:
        # Arriving from beat 4: clear its pieces first.
        b = Beat(hidden(RunApp=100, Passenger=100, Profile=35, AdNetwork=60, Shield=100, PermRow=100))
        for g, v in (('Profile', 35), ('AdNetwork', 60), ('Shield', 100), ('PermRow', 100)):
            b.tween(g, OP, 0, v, 0.35, 0)
    reset_positions(b)
    b.key('Knob', X, 0, 26, 'hold')
    b.key(TRACK_COLOR, COLOR, 0, '#FFC9BBAA', 'hold')
    b.tween('Passenger', Y, 0.9, 100, 1.5, 74)
    b.key('Passenger', Y, 0, 100, 'hold')
    b.tween('Pupils', X, 1.9, 0, 2.2, -3, 'io')
    b.tween('Pupils', X, 2.6, -3, 2.95, 3, 'io')
    return b


def beat2():
    """It sends your activity to ad companies."""
    b = Beat(hidden(RunApp=100, Passenger=100))
    reset_positions(b)
    b.tween('AdNetwork', OP, 0, 0, 0.4, 100)
    for s in (SX, SY):
        b.tween('AdNetwork', s, 0, 88, 0.55, 100)
    for i in range(3):
        bubble_trip(b, i, PEEK, NET, 0.45 + i * 0.75)
    b.tween('Pupils', X, 0.3, 0, 0.6, 3, 'io')
    return b


def beat3():
    """They build a profile to target you."""
    b = Beat(hidden(RunApp=100, Passenger=100, AdNetwork=100))
    reset_positions(b)
    b.tween('Profile', OP, 0, 0, 0.4, 100)
    b.tween('Profile', Y, 0, 282, 0.5, 268)
    for i in range(3):
        t = 0.5 + i * 0.25
        b.tween('Tag%d' % i, OP, t, 0, t + 0.3, 100)
        b.tween('Tag%d' % i, SX, t, 60, t + 0.35, 100)
        b.key('Tag%d' % i, OP, 0, 0, 'hold')
    b.tween('RunApp', OP, 1.5, 100, 1.8, 0)
    b.tween('NewsApp', OP, 1.6, 0, 2.0, 100)
    b.tween('ShoeAd', OP, 2.1, 0, 2.45, 100)
    b.tween('ShoeAd', Y, 2.1, 84, 2.6, 52)
    b.key('ShoeAd', OP, 0, 0, 'hold')
    return b


def beat4():
    """See it, block it, take back permissions."""
    b = Beat(hidden(NewsApp=100, ShoeAd=100, AdNetwork=100, Profile=100, Tag0=100, Tag1=100, Tag2=100, Passenger=100))
    reset_positions(b)
    b.tween('NewsApp', OP, 0, 100, 0.3, 0)
    b.tween('RunApp', OP, 0.15, 0, 0.5, 100)
    b.tween('Profile', OP, 0.2, 100, 0.6, 35)
    b.tween('AdNetwork', OP, 0.2, 100, 0.6, 60)
    # The lens finds the hidden passenger.
    b.tween('Lens', OP, 0.4, 0, 0.7, 100)
    b.tween('Lens', X, 0.4, 300, 1.15, PEEK[0] + 2, 'io')
    b.tween('Lens', Y, 0.4, 420, 1.15, PEEK[1] - 2, 'io')
    b.tween('Lens', OP, 2.2, 100, 2.5, 0)
    b.tween('Pupils', X, 1.1, 0, 1.25, -3, 'io')
    # The shield blocks what it tries to send.
    b.tween('Shield', OP, 1.0, 0, 1.3, 100)
    for s in (SX, SY):
        b.tween('Shield', s, 1.0, 70, 1.45, 100)
    b.tween(TRIM, TRIM_END, 1.4, 0, 1.85, 100, 'io')
    b.key(TRIM, TRIM_END, 0, 0, 'hold')
    stop = (SHIELD[0] - 24, SHIELD[1] + 22)
    for i in range(3):
        bubble_trip(b, i, PEEK, stop, 1.35 + i * 0.35, travel=0.75, fade_at=0.7)
    # You take a permission back.
    b.tween('PermRow', OP, 2.2, 0, 2.55, 100)
    b.tween('PermRow', Y, 2.2, 118, 2.6, 104)
    b.key('PermRow', OP, 0, 0, 'hold')
    b.tween('Knob', X, 2.8, 42, 3.1, 26, 'io')
    b.tween(TRACK_COLOR, COLOR, 2.8, '#FFB45309', 3.1, '#FFC9BBAA', 'io')
    return b


def ensure_animations():
    anims = {a['name']: a['id'] for a in tool('animation_editor', {'command': 'listLinearAnimations', 'data': {}})['linearAnimations']}
    if 'Timeline 1' in anims and 'Start' not in anims:
        tool('animation_editor', {'command': 'renameAnimations', 'data': {'renameAnimations': {'animations': [{'animationId': anims.pop('Timeline 1'), 'name': 'Start'}]}}})
        anims = {a['name']: a['id'] for a in tool('animation_editor', {'command': 'listLinearAnimations', 'data': {}})['linearAnimations']}
    missing = [n for n in ('Beat1', 'Beat2', 'Beat3', 'Beat4') if n not in anims]
    if missing:
        tool('animation_editor', {'command': 'createLinearAnimations', 'data': {'createLinearAnimations': {'linearAnimations': [{'name': n, 'duration': DUR} for n in missing]}}})
        anims = {a['name']: a['id'] for a in tool('animation_editor', {'command': 'listLinearAnimations', 'data': {}})['linearAnimations']}
    tool('set_property_values', {'propertyValues': {aid: {'56': FPS, '57': round(DUR * FPS), '59': 0} for aid in anims.values()}})
    return anims


def clear(aid):
    kfs = tool('animation_editor', {'command': 'queryKeyFrames', 'data': {'queryKeyFrames': {'animationIds': [aid]}}})
    found = []
    def walk(x):
        if isinstance(x, dict):
            if 'keyframeId' in x: found.append(x['keyframeId'])
            elif 'id' in x and 'frame' in x: found.append(x['id'])
            for v in x.values(): walk(v)
        elif isinstance(x, list):
            for v in x: walk(v)
    walk(kfs)
    if found:
        tool('animation_editor', {'command': 'modifyKeyFrames', 'data': {'modifyKeyFrames': {'animationId': aid, 'delete': found}}})


anims = ensure_animations()
for name, b in (('Start', beat1(True)), ('Beat1', beat1(False)), ('Beat2', beat2()), ('Beat3', beat3()), ('Beat4', beat4())):
    clear(anims[name])
    kfs = b.keyframes()
    for i in range(0, len(kfs), 120):
        tool('animation_editor', {'command': 'modifyKeyFrames', 'data': {'modifyKeyFrames': {'animationId': anims[name], 'add': kfs[i:i + 120]}}})
    print(name, len(kfs))
I['anims'] = anims
save(I)
