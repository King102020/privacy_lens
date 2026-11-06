"""View model `Story.beat` (0-3) drives the Story state machine."""
import sys; sys.path.insert(0, '.')
from rv import *

I = ids()
ae = lambda cmd, data: tool('animation_editor', {'command': cmd, 'data': {cmd: data}})
vm = lambda cmd, data: tool('viewmodel_editor', {'command': cmd, 'data': {cmd: data}})

story = {'id': '5-2172'}
beat_prop = '5-2174'
inst = [{'id': '5-2173'}]
print(json.dumps(vm('bindViewModelToArtboard', {'artboardId': I['artboard'], 'viewModelId': story['id'], 'instanceId': inst[0]['id']}))[:300])

sm = ae('queryStateMachine', {})
layer = sm['layers'][0]
names = {s['name']: s['id'] for s in layer['states'] if s['type'] == 'animation'}
want = [n for n in ('Beat1', 'Beat2', 'Beat3', 'Beat4') if n not in names]
if want:
    ae('createStates', {'layerId': layer['layerId'], 'states': [{'name': n, 'linearAnimationName': n, 'x': 160 + 160 * k, 'y': 160} for k, n in enumerate(want)]})
    layer = ae('queryStateMachine', {})['layers'][0]
    names = {s['name']: s['id'] for s in layer['states'] if s['type'] == 'animation'}
print('states', names)

edges = [('Start', 'Beat2', 1), ('Beat1', 'Beat2', 1), ('Beat2', 'Beat3', 2), ('Beat3', 'Beat4', 3), ('Beat4', 'Beat1', 0),
         # Jumps, for when Flutter changes beat out of order (e.g. reduce motion toggles).
         ('Start', 'Beat3', 2), ('Start', 'Beat4', 3), ('Beat2', 'Beat1', 0), ('Beat3', 'Beat1', 0)]
existing = {(t['fromStateId'], t['toStateId']) for t in layer['transitions']}
todo = [(a, b, v) for a, b, v in edges if (names[a], names[b]) not in existing]
if todo:
    ae('createTransitions', {'states': [{'id': names[a], 'transitions': [{'to': names[b]}]} for a, b, _ in todo]})
layer = ae('queryStateMachine', {})['layers'][0]
by_pair = {(t['fromStateId'], t['toStateId']): t for t in layer['transitions']}
conds = []
for a, b, v in edges:
    t = by_pair[(names[a], names[b])]
    if not t['conditions']:
        conds.append({'id': t['id'], 'conditions': [{'leftComparator': {'viewModelPropertyId': beat_prop}, 'comparationOperation': 'equal',
                                                     'rightComparator': {'valueType': 'constantValueType', 'value': v}}]})
if conds:
    ae('createConditions', {'transitions': conds})
sm = ae('queryStateMachine', {})
for t in sm['layers'][0]['transitions']:
    print(t['fromStateId'], '->', t['toStateId'], [c.get('value', c) for c in t['conditions']][:1])
tool('rename_objects', {'renames': [{'id': sm['stateMachineId'], 'name': 'Story'}]}) if sm['stateMachineName'] != 'Story' else None
I['beatProp'] = beat_prop
save(I)
