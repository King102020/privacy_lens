# Minimal Rive MCP client: python rive.py <tool> '<json args>'  |  python rive.py --list
import json, sys, urllib.request, os
U = "http://127.0.0.1:9791/mcp"
SF = os.path.join(os.path.dirname(os.path.abspath(__file__)), "rive_session.txt")
def post(body, sid=None):
    h = {"Content-Type": "application/json", "Accept": "application/json, text/event-stream"}
    if sid: h["mcp-session-id"] = sid
    r = urllib.request.urlopen(urllib.request.Request(U, json.dumps(body).encode(), h), timeout=300)
    raw = r.read().decode("utf-8", "replace")
    if raw.lstrip().startswith("event:") or raw.lstrip().startswith("data:"):
        raw = "\n".join(l[5:].strip() for l in raw.splitlines() if l.startswith("data:"))
    return r.headers.get("mcp-session-id"), (json.loads(raw) if raw.strip() else None)
def session():
    if os.path.exists(SF): return open(SF).read().strip()
    sid, _ = post({"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"cc","version":"1"}}})
    post({"jsonrpc":"2.0","method":"notifications/initialized"}, sid)
    open(SF,"w").write(sid); return sid
def call(method, params):
    sid = session()
    try: return post({"jsonrpc":"2.0","id":2,"method":method,"params":params}, sid)[1]
    except Exception as e:
        os.remove(SF); sid = session(); return post({"jsonrpc":"2.0","id":2,"method":method,"params":params}, sid)[1]
if sys.argv[1] == "--list":
    for t in call("tools/list", {})["result"]["tools"]:
        print(t["name"], "::", (t.get("description") or "").split("\n")[0][:140])
elif sys.argv[1] == "--schema":
    for t in call("tools/list", {})["result"]["tools"]:
        if t["name"] == sys.argv[2]: print(json.dumps(t, indent=1))
else:
    args = json.loads(sys.argv[2]) if len(sys.argv) > 2 else {}
    if len(sys.argv) > 2 and os.path.exists(sys.argv[2]): args = json.load(open(sys.argv[2]))
    res = call("tools/call", {"name": sys.argv[1], "arguments": args})
    out = res.get("result", res)
    for c in out.get("content", []) if isinstance(out, dict) else []:
        print(c.get("text", c))
    if not (isinstance(out, dict) and out.get("content")): print(json.dumps(out)[:4000])
