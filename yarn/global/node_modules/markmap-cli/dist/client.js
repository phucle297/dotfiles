const { mm, markmap } = window;
const { cliOptions } = markmap;
const key = new URLSearchParams(window.location.search).get("key") || "";
const state = {
  content: {
    ts: 0,
    value: void 0
  },
  line: {
    ts: 0,
    value: 0
  }
};
const activeNodeOptions = {};
const highlightEl = document.createElement("div");
highlightEl.className = "markmap-highlight-area";
checkData();
async function checkData() {
  var _a;
  try {
    const query = new URLSearchParams(
      [
        ["key", key],
        ["content", state.content.ts],
        ["line", state.line.ts]
      ].map((pair) => pair.map((s) => `${s}`))
    );
    const resp = await fetch(`/~data?${query}`);
    if (!resp.ok)
      throw {
        status: resp.status
      };
    const res = await resp.json();
    if (res.content) {
      const value = res.content.value;
      mm.setOptions(markmap.deriveOptions((_a = value.frontmatter) == null ? void 0 : _a.markmap));
      await mm.setData(value.root);
      if (!state.content.ts) await mm.fit();
    }
    Object.assign(state, res);
    if (res.line && state.content.value) {
      await setCursor({ line: res.line.value });
    }
    setTimeout(checkData);
  } catch (err) {
    if (err.status !== 404) {
      setTimeout(checkData, 1e3);
    }
  }
}
function findActiveNode({
  line,
  autoExpand = true
}) {
  function dfs(node, ancestors = []) {
    var _a, _b, _c;
    const [start, end] = ((_b = (_a = node.payload) == null ? void 0 : _a.lines) == null ? void 0 : _b.split(",").map((s) => +s)) || [];
    if (start >= 0 && start <= line && line < end) {
      best = node;
      bestAncestors = ancestors;
    }
    ancestors = [...ancestors, node];
    (_c = node.children) == null ? void 0 : _c.forEach((child) => {
      dfs(child, ancestors);
    });
  }
  let best;
  let bestAncestors = [];
  dfs(state.content.value.root);
  if (autoExpand) {
    bestAncestors.forEach((node) => {
      var _a;
      if ((_a = node.payload) == null ? void 0 : _a.fold) {
        node.payload.fold = 0;
      }
    });
  }
  return best;
}
async function setCursor(options) {
  if (!state.content.value) return;
  const node = findActiveNode(options);
  await highlightNode(node);
}
async function highlightNode(node) {
  await mm.setHighlight(node);
  if (!node) return;
  await mm[activeNodeOptions.placement === "center" ? "centerNode" : "ensureVisible"](node, {
    bottom: cliOptions.toolbar ? 80 : 0
  });
}
