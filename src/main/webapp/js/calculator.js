(function () {
  var expr = "";
  var angle = "DEG";
  var lastAns = "0";
  var justEvaluated = false;

  var exprEl = document.getElementById("expr");
  var resEl = document.getElementById("result");
  var previewEl = document.getElementById("preview");

  function readSetting(key, fallback) {
    try { return localStorage.getItem(key) || fallback; } catch (e) { return fallback; }
  }
  function writeSetting(key, value) {
    try { localStorage.setItem(key, value); } catch (e) { }
  }
  function toRad(x) { return angle === "DEG" ? x * Math.PI / 180 : x; }
  function fromRad(x) { return angle === "DEG" ? x * 180 / Math.PI : x; }
  function cleanTrig(value) { return Math.abs(value) < 1e-12 ? 0 : value; }
  function fact(n) {
    if (n < 0 || Math.floor(n) !== n || n > 170) throw new Error("Math error");
    var r = 1;
    for (var i = 2; i <= n; i++) r *= i;
    return r;
  }

  var FUNCS = {
    sin: function (x) { return cleanTrig(Math.sin(toRad(x))); },
    cos: function (x) { return cleanTrig(Math.cos(toRad(x))); },
    tan: function (x) {
      var radians = toRad(x);
      if (Math.abs(Math.cos(radians)) < 1e-12) throw new Error("Undefined");
      return cleanTrig(Math.tan(radians));
    },
    asin: function (x) { return fromRad(Math.asin(x)); },
    acos: function (x) { return fromRad(Math.acos(x)); },
    atan: function (x) { return fromRad(Math.atan(x)); },
    log: Math.log10,
    ln: Math.log,
    sqrt: Math.sqrt
  };

  // Recursive descent parser: no eval().
  function evaluate(input) {
    var s = input.toLowerCase()
      .replace(/\s+/g, "")
      .replace(/\u00d7/g, "*").replace(/\u00f7/g, "/").replace(/\u2212/g, "-")
      .replace(/\u03c0/g, "pi").replace(/\u221a/g, "sqrt");
    var i = 0;

    function peek() { return s.charAt(i); }
    function parseExpr() {
      var v = parseTerm();
      while (peek() === "+" || peek() === "-") {
        var op = s.charAt(i++);
        var r = parseTerm();
        v = op === "+" ? v + r : v - r;
      }
      return v;
    }
    function parseTerm() {
      var v = parseUnary();
      while (true) {
        var c = peek();
        if (c === "*" || c === "/") {
          i++;
          var r = parseUnary();
          if (c === "/" && r === 0) throw new Error("Cannot divide by zero");
          v = c === "*" ? v * r : v / r;
        } else if (c === "(" || /[a-z]/.test(c)) {
          v = v * parseUnary();
        } else break;
      }
      return v;
    }
    function parseUnary() {
      if (peek() === "-") { i++; return -parseUnary(); }
      if (peek() === "+") { i++; return parseUnary(); }
      return parsePower();
    }
    function parsePower() {
      var base = parsePostfix();
      if (peek() === "^") { i++; return Math.pow(base, parseUnary()); }
      return base;
    }
    function parsePostfix() {
      var v = parsePrimary();
      while (peek() === "!" || peek() === "%") {
        if (s.charAt(i++) === "!") v = fact(v); else v = v / 100;
      }
      return v;
    }
    function parsePrimary() {
      var c = peek();
      if (c === "(") {
        i++;
        var v = parseExpr();
        if (peek() === ")") i++;
        return v;
      }
      if (/[0-9.]/.test(c)) {
        var start = i;
        while (/[0-9.]/.test(peek())) i++;
        var token = s.substring(start, i);
        if (!/^\d*\.?\d*$/.test(token) || token === ".") throw new Error("Invalid input");
        return parseFloat(token);
      }
      if (/[a-z]/.test(c)) {
        var st = i;
        while (/[a-z]/.test(peek())) i++;
        var name = s.substring(st, i);
        if (name === "pi") return Math.PI;
        if (name === "e") return Math.E;
        if (name === "ans") return parseFloat(lastAns) || 0;
        if (FUNCS[name]) {
          if (peek() !== "(") throw new Error("Invalid input");
          i++;
          var arg = parseExpr();
          if (peek() === ")") i++;
          return FUNCS[name](arg);
        }
        throw new Error("Unknown: " + name);
      }
      throw new Error("Invalid input");
    }

    var out = parseExpr();
    if (i < s.length) throw new Error("Invalid input");
    return out;
  }

  function fmt(v) {
    if (!isFinite(v)) throw new Error("Math error");
    return String(parseFloat(v.toPrecision(12)));
  }
  function updatePreview() {
    var showsCalculation = /[+\u2212\u00d7\u00f7*/^%!()]|(?:sin|cos|tan|asin|acos|atan|log|ln|\u221a)/i.test(expr);
    if (!showsCalculation || expr === "") { previewEl.textContent = ""; return; }
    try { previewEl.textContent = "= " + fmt(evaluate(expr)); }
    catch (e) { previewEl.textContent = ""; }
  }
  function render() {
    var text = expr === "" ? "0" : expr;
    resEl.textContent = text;
    resEl.classList.remove("display-error");
    resEl.classList.toggle("result-compact", text.length > 16);
    resEl.classList.toggle("result-small", text.length > 28);
    updatePreview();
  }
  function currentNumberHasDot() {
    var i = expr.length - 1;
    while (i >= 0 && /[0-9.]/.test(expr.charAt(i))) i--;
    return expr.substring(i + 1).indexOf(".") !== -1;
  }
  function press(val) {
    var isOperator = /^[\u00f7\u00d7\u2212+^%!]$/.test(val);
    if (justEvaluated) {
      expr = isOperator ? lastAns : "";
      justEvaluated = false;
      exprEl.textContent = "";
    }
    if (val === "." && currentNumberHasDot()) return;
    expr += val;
    render();
  }
  function clearAll() { expr = ""; exprEl.textContent = ""; previewEl.textContent = ""; justEvaluated = false; render(); }
  function back() {
    if (justEvaluated) { clearAll(); return; }
    var shorter = expr.replace(/([a-z]+|\u221a)\($/, "");
    expr = shorter !== expr ? shorter : expr.slice(0, -1);
    render();
  }
  function equals() {
    if (expr === "") return;
    try {
      var answer = fmt(evaluate(expr));
      exprEl.textContent = expr + " =";
      resEl.textContent = answer;
      resEl.classList.remove("display-error");
      previewEl.textContent = "";
      if (typeof window.saveCalculation === "function") window.saveCalculation(expr, answer, angle);
      lastAns = answer;
      expr = answer;
      justEvaluated = true;
    } catch (err) {
      exprEl.textContent = expr;
      resEl.textContent = err.message;
      previewEl.textContent = "";
      resEl.classList.remove("display-error");
      void resEl.offsetWidth;
      resEl.classList.add("display-error");
      expr = "";
      justEvaluated = false;
    }
  }
  function setAngle(value, save) {
    angle = value === "RAD" ? "RAD" : "DEG";
    document.getElementById("angleBtn").textContent = angle;
    if (save) writeSetting("quantix.angle", angle);
  }
  function setMode(value, save) {
    var scientific = value !== "standard";
    document.getElementById("sciPad").classList.toggle("hidden", !scientific);
    document.getElementById("modeStd").classList.toggle("active", !scientific);
    document.getElementById("modeSci").classList.toggle("active", scientific);
    document.querySelector(".calc-card").classList.toggle("standard-mode", !scientific);
    if (save) writeSetting("quantix.mode", scientific ? "scientific" : "standard");
  }

  var params = new URLSearchParams(window.location.search);
  var requestedAngle = params.get("angle");
  var requestedExpr = params.get("expr");
  setAngle(requestedAngle === "RAD" || requestedAngle === "DEG" ? requestedAngle : readSetting("quantix.angle", "DEG"), false);
  setMode(readSetting("quantix.mode", "scientific"), false);
  if (requestedExpr) { expr = requestedExpr; render(); }

  document.querySelectorAll(".pad button").forEach(function (b) {
    b.addEventListener("click", function () {
      b.classList.add("press-feedback");
      setTimeout(function () { b.classList.remove("press-feedback"); }, 80);
      var action = b.getAttribute("data-action");
      if (action === "clear") clearAll();
      else if (action === "back") back();
      else if (action === "equals") equals();
      else press(b.getAttribute("data-val"));
    });
  });
  function flashKey(value, action) {
    document.querySelectorAll(".pad button").forEach(function (button) {
      if (button.getAttribute("data-val") === value || button.getAttribute("data-action") === action) {
        button.classList.add("key-highlight");
        setTimeout(function () { button.classList.remove("key-highlight"); }, 100);
      }
    });
  }
  function toggleTheme() {
    var next = document.documentElement.getAttribute("data-theme") === "dark" ? "light" : "dark";
    document.documentElement.setAttribute("data-theme", next);
    writeSetting("quantix.theme", next);
    document.getElementById("themeBtn").textContent = next === "dark" ? "Light" : "Dark";
  }
  document.addEventListener("keydown", function (e) {
    var k = e.key;
    if (e.ctrlKey && k.toLowerCase() === "d") { e.preventDefault(); toggleTheme(); }
    else if (e.ctrlKey && k.toLowerCase() === "c" && !window.getSelection().toString()) {
      if (navigator.clipboard) navigator.clipboard.writeText(resEl.textContent).catch(function () { });
    } else if (/^[0-9.()+^%!]$/.test(k)) { press(k); flashKey(k); }
    else if (k === "*") { press("\u00d7"); flashKey("\u00d7"); }
    else if (k === "/") { e.preventDefault(); press("\u00f7"); flashKey("\u00f7"); }
    else if (k === "-") { press("\u2212"); flashKey("\u2212"); }
    else if (k === "Enter" || k === "=") { e.preventDefault(); equals(); flashKey(null, "equals"); }
    else if (k === "Backspace") { back(); flashKey(null, "back"); }
    else if (k === "Escape") { clearAll(); flashKey(null, "clear"); }
  });
  document.getElementById("modeStd").addEventListener("click", function () { setMode("standard", true); });
  document.getElementById("modeSci").addEventListener("click", function () { setMode("scientific", true); });
  document.getElementById("angleBtn").addEventListener("click", function () {
    setAngle(angle === "DEG" ? "RAD" : "DEG", true);
  });
  document.getElementById("themeBtn").addEventListener("click", function () {
    toggleTheme();
  });
  document.getElementById("themeBtn").textContent = document.documentElement.getAttribute("data-theme") === "dark" ? "Light" : "Dark";
})();
