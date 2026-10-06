<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.net.URLEncoder, com.quantix.model.User, com.quantix.model.HistoryEntry, com.quantix.util.HtmlUtil" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
  List<HistoryEntry> items = (List<HistoryEntry>) request.getAttribute("history");
  if (items == null) { response.sendRedirect("history"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Quantix - History</title>
  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
  <script defer src="${pageContext.request.contextPath}/js/motion.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <header class="topbar">
    <div class="brand"><span class="logo">Q</span><span class="brand-name">Quantix</span></div>
    <div class="topbar-right">
      <span class="user-name"><%= HtmlUtil.escape(user.getName()) %></span>
      <a class="chip" href="dashboard">Dashboard</a>
      <a class="chip" href="calculator.jsp">Calculator</a>
      <a class="chip" href="logout">Logout</a>
    </div>
  </header>

  <main class="page-wrap">
    <div class="panel">
      <div class="panel-head">
        <h2>Calculation History</h2>
        <% if (!items.isEmpty()) { %>
        <form action="history" method="post" onsubmit="return confirm('Clear all history?');">
          <input type="hidden" name="action" value="clear">
          <input type="hidden" name="_csrf" value="<%= HtmlUtil.escape((String) session.getAttribute("csrf")) %>">
          <button type="submit" class="chip danger">Clear all</button>
        </form>
        <% } %>
      </div>

      <% if (items.isEmpty()) { %>
        <p class="empty">No calculations yet. Go to the <a href="calculator.jsp">calculator</a> and press = to save one.</p>
      <% } else { %>
      <div class="table-scroll">
      <table class="hist">
        <thead><tr><th>Expression</th><th>Result</th><th>Angle</th><th>Time</th><th></th></tr></thead>
        <tbody>
        <% for (HistoryEntry h : items) { %>
          <tr>
            <td class="mono"><%= HtmlUtil.escape(h.getExpression()) %></td>
            <td class="mono strong"><%= HtmlUtil.escape(h.getResult()) %></td>
            <td><span class="chip"><%= HtmlUtil.escape(h.getAngleMode()) %></span></td>
            <td class="muted"><%= HtmlUtil.escape(h.getCreatedAt()) %></td>
            <td class="actions">
              <a class="chip" href="calculator.jsp?expr=<%= URLEncoder.encode(h.getExpression(), "UTF-8") %>&amp;angle=<%= h.getAngleMode() %>">Use</a>
              <form action="history" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= h.getId() %>">
                <input type="hidden" name="_csrf" value="<%= HtmlUtil.escape((String) session.getAttribute("csrf")) %>">
                <button type="submit" class="chip danger">Delete</button>
              </form>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>
      </div>
      <% } %>
    </div>
  </main>
</body>
</html>

