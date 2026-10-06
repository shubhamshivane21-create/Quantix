package com.quantix.servlet;

import com.quantix.dao.HistoryDAO;
import com.quantix.model.User;
import com.quantix.util.CsrfUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/saveCalculation")
public class SaveCalculationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");
        if (user == null) { resp.sendError(HttpServletResponse.SC_UNAUTHORIZED); return; }
        if (!CsrfUtil.isValid(req)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

        String expression = req.getParameter("expression");
        String result = req.getParameter("result");
        String angleMode = req.getParameter("angle");
        if (!"RAD".equals(angleMode)) angleMode = "DEG";
        if (expression == null || result == null || expression.isEmpty()
                || expression.length() > 255 || result.length() > 100) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        try {
            new HistoryDAO().save(user.getId(), expression, result, angleMode);
            resp.setStatus(HttpServletResponse.SC_OK);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
