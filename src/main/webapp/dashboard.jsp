<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.quantix.model.User, com.quantix.model.HistoryEntry, com.quantix.model.DashboardStats, com.quantix.util.HtmlUtil" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
  DashboardStats stats = (DashboardStats) request.getAttribute("stats");
  if (stats == null) { response.sendRedirect("dashboard"); return; }
  List<HistoryEntry> recent = (List<HistoryEntry>) request.getAttribute("recent");

  int maxDay = 0;
  int activeDays = 0;
  for (int c : stats.getPerDay().values()) { if (c > maxDay) maxDay = c; if (c > 0) activeDays++; }
  int maxFeat = 0;
  for (int c : stats.getTopFeatures().values()) { if (c > maxFeat) maxFeat = c; }
  String topFeature = stats.getTopFeatures().isEmpty() ? "-" : stats.getTopFeatures().keySet().iterator().next();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Quantix - Dashboard</title>
  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
  <script defer src="${pageContext.request.contextPath}/js/motion.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <header class="topbar">
    <a class="brand" href="index.jsp" style="text-decoration:none;color:inherit"><span class="logo">Q</span><span class="brand-name">Quantix</span></a>
    <div class="topbar-right">
      <a class="chip" href="calculator.jsp">Calculator</a>
      <a class="chip" href="history">History</a>
      <a class="chip" href="logout">Logout</a>
    </div>
  </header>

  <main class="dash">
    <div class="dash-head">
      <h2>Hello, <%= HtmlUtil.escape(user.getName()) %></h2>
      <p class="muted"><%= HtmlUtil.escape(user.getEmail()) %></p>
    </div>

    <div class="stats">
      <div class="stat-card"><span class="stat-label">Total calculations</span><span class="stat-val"><%= stats.getTotal() %></span></div>
      <div class="stat-card"><span class="stat-label">Today</span><span class="stat-val"><%= stats.getToday() %></span></div>
      <div class="stat-card"><span class="stat-label">Most used function</span><span class="stat-val small"><%= HtmlUtil.escape(topFeature) %></span></div>
      <div class="stat-card"><span class="stat-label">Active days (last 7)</span><span class="stat-val"><%= activeDays %></span></div>
    </div>

    <div class="dash-grid">
      <div class="panel">
        <h3>Activity: last 7 days</h3>
        <div class="bars">
          <% for (Map.Entry<String,Integer> e : stats.getPerDay().entrySet()) {
               int pct = (maxDay == 0) ? 0 : (int) Math.round(100.0 * e.getValue() / maxDay); %>
            <div class="bar-col">
              <span class="bar-num"><%= e.getValue() %></span>
              <div class="bar-track"><div class="bar-fill" style="height:<%= pct %>%"></div></div>
              <span class="bar-label"><%= HtmlUtil.escape(e.getKey()) %></span>
            </div>
          <% } %>
        </div>
      </div>

      <div class="panel">
        <h3>Most used functions</h3>
        <% if (stats.getTopFeatures().isEmpty()) { %>
          <p class="empty">Use functions like sin, log or sqrt and they will show up here.</p>
        <% } else { for (Map.Entry<String,Integer> e : stats.getTopFeatures().entrySet()) {
             int pct = (maxFeat == 0) ? 0 : (int) Math.round(100.0 * e.getValue() / maxFeat); %>
          <div class="feat-row">
            <span class="feat-name"><%= HtmlUtil.escape(e.getKey()) %></span>
            <div class="feat-track"><div class="feat-fill" style="width:<%= pct %>%"></div></div>
            <span class="feat-count"><%= e.getValue() %></span>
          </div>
        <% } } %>
      </div>
    </div>

    <div class="panel">
      <div class="panel-head">
        <h3 style="margin:0">Recent calculations</h3>
        <a class="chip" href="history">View all</a>
      </div>
      <% if (recent == null || recent.isEmpty()) { %>
        <p class="empty">No calculations yet. Open the <a href="calculator.jsp">calculator</a> to get started.</p>
      <% } else { %>
        <table class="hist">
          <tbody>
          <% for (HistoryEntry h : recent) { %>
            <tr>
              <td class="mono"><%= HtmlUtil.escape(h.getExpression()) %></td>
              <td class="mono strong">= <%= HtmlUtil.escape(h.getResult()) %></td>
              <td class="muted"><%= HtmlUtil.escape(h.getCreatedAt()) %></td>
            </tr>
          <% } %>
          </tbody>
        </table>
      <% } %>
    </div>
  </main>
</body>
</html>
