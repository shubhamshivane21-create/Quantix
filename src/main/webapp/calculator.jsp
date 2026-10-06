<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.quantix.model.User, com.quantix.util.HtmlUtil" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Quantix - Calculator</title>
  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
  <script defer src="${pageContext.request.contextPath}/js/motion.js"></script>
  <meta name="csrf-token" content="<%= HtmlUtil.escape((String) session.getAttribute("csrf")) %>">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <header class="topbar">
    <div class="brand"><span class="logo">Q</span><span class="brand-name">Quantix</span></div>
    <div class="topbar-right">
      <span class="user-name"><%= HtmlUtil.escape(user.getName()) %></span>
      <button id="themeBtn" class="chip" type="button">Light</button>
      <a class="chip" href="dashboard">Dashboard</a>
      <a class="chip" href="history">History</a>
      <a class="chip" href="logout">Logout</a>
    </div>
  </header>

  <main class="calc-wrap">
    <section class="calculator-layout">
    <div class="calc-card">
      <div class="calc-tools">
        <div class="seg">
          <button id="modeStd" class="seg-btn" type="button">Standard</button>
          <button id="modeSci" class="seg-btn active" type="button">Scientific</button>
        </div>
        <button id="angleBtn" class="chip" type="button">DEG</button>
      </div>

      <div class="display">
        <div id="expr" class="expr"></div>
        <div id="result" class="result">0</div>
        <div id="preview" class="live-preview" aria-live="polite"></div>
      </div>

      <div class="keypad-layout">
        <div id="sciPad" class="pad sci">
          <button class="sci-key" data-val="sin(">sin</button>
          <button class="sci-key" data-val="cos(">cos</button>
          <button class="sci-key" data-val="tan(">tan</button>
          <button class="sci-key" data-val="&pi;">&pi;</button>
          <button class="sci-key" data-val="asin(">asin</button>
          <button class="sci-key" data-val="acos(">acos</button>
          <button class="sci-key" data-val="atan(">atan</button>
          <button class="sci-key" data-val="e">e</button>
          <button class="sci-key" data-val="log(">log</button>
          <button class="sci-key" data-val="ln(">ln</button>
          <button class="sci-key" data-val="&radic;(">&radic;</button>
          <button class="sci-key" data-val="^">x<sup>y</sup></button>
          <button class="sci-key" data-val="(">(</button>
          <button class="sci-key" data-val=")">)</button>
          <button class="sci-key" data-val="!">x!</button>
          <button class="sci-key" data-val="Ans">Ans</button>
        </div>

        <div class="pad main">
        <button class="utility danger-key" data-action="clear" aria-label="Clear calculation">AC</button>
        <button class="utility" data-action="back" aria-label="Backspace">&#9003;</button>
        <button class="utility" data-val="%">%</button>
        <button class="op" data-val="&divide;">&divide;</button>
        <button data-val="7">7</button>
        <button data-val="8">8</button>
        <button data-val="9">9</button>
        <button class="op" data-val="&times;">&times;</button>
        <button data-val="4">4</button>
        <button data-val="5">5</button>
        <button data-val="6">6</button>
        <button class="op" data-val="&minus;">&minus;</button>
        <button data-val="1">1</button>
        <button data-val="2">2</button>
        <button data-val="3">3</button>
        <button class="op" data-val="+">+</button>
        <button class="wide" data-val="0">0</button>
        <button data-val=".">.</button>
        <button class="eq" data-action="equals">=</button>
        </div>
      </div>
    </div>
    <aside class="calc-history-placeholder" aria-label="History placeholder">
      <div class="placeholder-head"><h2>History</h2><span class="history-count">Phase 3</span></div>
      <p>No calculations yet.</p>
    </aside>
    </section>
  </main>

  <script src="${pageContext.request.contextPath}/js/history-save.js"></script>
  <script src="${pageContext.request.contextPath}/js/calculator.js"></script>
</body>
</html>


