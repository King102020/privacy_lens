# Shared helpers for building the Rive story.
import json, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import importlib.util
spec = importlib.util.spec_from_file_location("rivec", os.path.join(os.path.dirname(os.path.abspath(__file__)), "rive.py"))
IDS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "story_ids.json")

def _call():
    import urllib.request
    src = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "rive.py")).read()
    ns = {"__name__": "rivec", "sys": sys, "__file__": os.path.join(os.path.dirname(os.path.abspath(__file__)), "rive.py")}
    code = src.split("if sys.argv[1] ==")[0]
    exec(code, ns)
    return ns["call"]
call = _call()

def tool(name, args):
    res = call("tools/call", {"name": name, "arguments": args})
    out = res.get("result", res)
    txt = "".join(c.get("text", "") for c in out.get("content", []))
    try: d = json.loads(txt)
    except Exception: raise RuntimeError(f"{name}: {txt[:600]}")
    if isinstance(d, dict) and d.get("success") is False: raise RuntimeError(f"{name}: {txt[:600]}")
    return d

def ids():
    return json.load(open(IDS)) if os.path.exists(IDS) else {}
def save(d): json.dump(d, open(IDS, "w"), indent=1)

def group(name, parent, x, y):
    d = tool("group_editor", {"name": name, "parentId": parent, "x": x, "y": y})
    gid = d.get("id") or d.get("groupId") or d["group"]["id"]
    tool("set_property_values", {"propertyValues": {gid: {"13": x, "14": y}}})
    return gid

def fill(c, feather=None):
    p = {"paintType": "fill", "color": c}
    if feather: p["feather"] = feather
    return p
def stroke(c, w): return {"paintType": "stroke", "color": c, "width": w}

def prim(shapes):
    return tool("path_editor", {"command": "createParametricShapes", "data": {"createParametricShapes": {"shapes": shapes}}})["shapes"]
def free(shapes):
    return tool("path_editor", {"command": "createShapes", "data": {"createShapes": {"shapes": shapes}}})
