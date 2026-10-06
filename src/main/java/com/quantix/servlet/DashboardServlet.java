package com.quantix.servlet;

import com.quantix.dao.HistoryDAO;
import com.quantix.dao.StatsDAO;
import com.quantix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");
        if (user == null) { resp.sendRedirect("login.jsp"); return; }
        try {
            req.setAttribute("stats", new StatsDAO().get(user.getId()));
            req.setAttribute("recent", new HistoryDAO().list(user.getId(), 5));
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
    }
}
