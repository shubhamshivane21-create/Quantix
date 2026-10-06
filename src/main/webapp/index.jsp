<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.quantix.model.User, com.quantix.util.HtmlUtil" %>
<%
  User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Quantix - Scientific Calculator</title>
  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
  <script defer src="${pageContext.request.contextPath}/js/motion.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="landing">

  <header class="topbar">
    <div class="brand"><span class="logo">Q</span><span class="brand-name">Quantix</span></div>
    <nav class="nav-links">
      <a href="#features">Features</a>
      <a href="#how">How it works</a>
      <a href="#tech">Tech stack</a>
    </nav>
    <div class="topbar-right">
      <% if (user == null) { %>
        <a class="chip" href="login.jsp">Login</a>
        <a class="chip chip-primary" href="signup.jsp">Sign Up</a>
      <% } else { %>
        <span class="user-name"><%= HtmlUtil.escape(user.getName()) %></span>
        <a class="chip" href="dashboard">Dashboard</a>
        <a class="chip chip-primary" href="calculator.jsp">Calculator</a>
        <a class="chip" href="logout">Logout</a>
      <% } %>
    </div>
  </header>

  <section class="hero">
    <div class="hero-text">
      <span class="badge">Full Stack Java Mini Project</span>
      <h1>A scientific calculator that <span class="grad">remembers</span> your work.</h1>
      <p>Quantix is a web-based scientific calculator built with Java Servlets, JSP and MySQL.
         Calculate in Standard or Scientific mode, and every result is saved to your personal history
         so you can reuse it anytime.</p>
      <div class="hero-cta">
        <% if (user == null) { %>
          <a class="btn-primary btn-inline" href="signup.jsp">Get Started</a>
          <a class="btn-ghost" href="login.jsp">I already have an account</a>
        <% } else { %>
          <a class="btn-primary btn-inline" href="calculator.jsp">Open Calculator</a>
          <a class="btn-ghost" href="history">View History</a>
        <% } %>
      </div>
    </div>

    <div class="hero-preview">
      <div class="calc-card preview">
        <div class="display">
          <div class="expr">sin(30) + 2^3 =</div>
          <div class="result">8.5</div>
        </div>
        <div class="pad sci">
          <button type="button">sin</button><button type="button">cos</button>
          <button type="button">tan</button><button type="button">&pi;</button>
          <button type="button">log</button><button type="button">ln</button>
          <button type="button">&radic;</button><button type="button">x<sup>y</sup></button>
        </div>
        <div class="pad main">
          <button type="button" class="fn">AC</button><button type="button">7</button>
          <button type="button">8</button><button type="button" class="op">&divide;</button>
          <button type="button">4</button><button type="button">5</button>
          <button type="button">6</button><button type="button" class="eq">=</button>
        </div>
      </div>
    </div>
  </section>

  <section id="features" class="section">
    <h2>Features</h2>
    <p class="section-sub">Everything you need for quick and accurate calculations.</p>
    <div class="grid">
      <div class="feature"><div class="ico">&#8721;</div><h3>Standard &amp; Scientific modes</h3>
        <p>Switch between basic arithmetic and advanced functions with one click.</p></div>
      <div class="feature"><div class="ico">&pi;</div><h3>Advanced functions</h3>
        <p>sin, cos, tan and inverses, log, ln, square root, powers, factorial, percent and constants &pi; and e.</p></div>
      <div class="feature"><div class="ico">&#176;</div><h3>Degree / Radian toggle</h3>
        <p>Pick the angle unit for trigonometric functions instantly.</p></div>
      <div class="feature"><div class="ico">&#9201;</div><h3>Saved history</h3>
        <p>Every calculation is stored per user. Reuse an old expression, delete one, or clear all.</p></div>
      <div class="feature"><div class="ico">&#128274;</div><h3>Secure accounts</h3>
        <p>Passwords are salted and hashed with PBKDF2, and all database queries are parameterized.</p></div>
      <div class="feature"><div class="ico">&#9728;</div><h3>Themes &amp; keyboard</h3>
        <p>Light and dark themes, plus full keyboard support: digits, operators, Enter, Backspace and Esc.</p></div>
    </div>
  </section>

  <section id="how" class="section alt">
    <h2>How it works</h2>
    <p class="section-sub">Three simple steps.</p>
    <div class="steps">
      <div class="step"><span class="num">1</span><h3>Create an account</h3>
        <p>Sign up with your name, email and a password.</p></div>
      <div class="step"><span class="num">2</span><h3>Calculate</h3>
        <p>Use the calculator. Press = and the result is saved automatically.</p></div>
      <div class="step"><span class="num">3</span><h3>Review &amp; reuse</h3>
        <p>Open History to see past work and load any expression back into the calculator.</p></div>
    </div>
  </section>

  <section id="tech" class="section">
    <h2>Tech stack</h2>
    <p class="section-sub">Built around the Full Stack Java Programming syllabus.</p>
    <div class="tags">
      <span>Java Servlets</span><span>JSP</span><span>JDBC</span><span>MySQL</span>
      <span>Apache Tomcat 10</span><span>HTML5</span><span>CSS3</span><span>JavaScript</span>
    </div>
    <p class="arch">Browser (HTML/CSS/JS) &rarr; Servlets &amp; JSP (Tomcat) &rarr; DAO layer (JDBC) &rarr; MySQL</p>
  </section>

  <footer class="footer">
    <div><strong>Quantix</strong> &middot; FSJP Mini Project &middot; Mumbai University</div>
    <div class="muted">Team: Tirth Radadiya &middot; Shubham Shivane &middot; Sumit Verma</div>
  </footer>

</body>
</html>

