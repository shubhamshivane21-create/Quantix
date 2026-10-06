<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Quantix - Login</title>
  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
  <script defer src="${pageContext.request.contextPath}/js/motion.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <div class="auth-wrap">
    <div class="auth-card">
      <div class="auth-brand"><span class="logo">Q</span><span class="brand-name">Quantix</span></div>
      <h2>Welcome back</h2>
      <p class="auth-sub">Log in to continue to your calculator</p>

      <% if (request.getParameter("registered") != null) { %>
        <div class="alert success">Account created. Please log in.</div>
      <% } %>
      <% if (request.getAttribute("error") != null) { %>
        <div class="alert error">${error}</div>
      <% } %>

      <form action="login" method="post">
        <div class="field">
          <label for="email">Email</label>
          <input type="email" id="email" name="email" placeholder="you@example.com" required>
        </div>
        <div class="field">
          <label for="password">Password</label>
          <input type="password" id="password" name="password" placeholder="Your password" required>
        </div>
        <button type="submit" class="btn-primary">Login</button>
      </form>

      <p class="auth-switch">New to Quantix? <a href="signup.jsp">Create an account</a></p>
    </div>
  </div>
</body>
</html>
