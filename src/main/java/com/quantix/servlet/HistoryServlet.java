package com.quantix.servlet;

import com.quantix.dao.HistoryDAO;
import com.quantix.model.User;
import com.quantix.util.CsrfUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/history")
public class HistoryServlet extends HttpServlet {

    private User currentUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return (session == null) ? null : (User) session.getAttribute("user");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = currentUser(req);
        if (user == null) { resp.sendRedirect("login.jsp"); return; }
        try {
            req.setAttribute("history", new HistoryDAO().list(user.getId(), 100));
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("history.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = currentUser(req);
        if (user == null) { resp.sendRedirect("login.jsp"); return; }
        if (!CsrfUtil.isValid(req)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
        String action = req.getParameter("action");
        try {
            HistoryDAO dao = new HistoryDAO();
            if ("delete".equals(action)) {
                dao.delete(Integer.parseInt(req.getParameter("id")), user.getId());
            } else if ("clear".equals(action)) {
                dao.clearAll(user.getId());
            }
        } catch (SQLException | NumberFormatException e) {
            throw new ServletException(e);
        }
        resp.sendRedirect("history");
    }
}
