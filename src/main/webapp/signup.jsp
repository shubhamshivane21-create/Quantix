<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Quantix - Sign Up</title>
  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
  <script defer src="${pageContext.request.contextPath}/js/motion.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <div class="auth-wrap">
    <div class="auth-card">
      <div class="auth-brand"><span class="logo">Q</span><span class="brand-name">Quantix</span></div>
      <h2>Create your account</h2>
      <p class="auth-sub">Save your calculation history across sessions</p>

      <% if (request.getAttribute("error") != null) { %>
        <div class="alert error">${error}</div>
      <% } %>

      <form action="signup" method="post">
        <div class="field">
          <label for="name">Full name</label>
          <input type="text" id="name" name="name" placeholder="Your name" required>
        </div>
        <div class="field">
          <label for="email">Email</label>
          <input type="email" id="email" name="email" placeholder="you@example.com" required>
        </div>
        <div class="field">
          <label for="password">Password</label>
          <input type="password" id="password" name="password" placeholder="At least 6 characters" required minlength="6">
        </div>
        <button type="submit" class="btn-primary">Sign Up</button>
      </form>

      <p class="auth-switch">Already have an account? <a href="login.jsp">Log in</a></p>
    </div>
  </div>
</body>
</html>
