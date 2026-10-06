package com.quantix.servlet;

import com.quantix.dao.UserDAO;
import com.quantix.model.User;
import com.quantix.util.CsrfUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email").trim().toLowerCase();
        String password = req.getParameter("password");
        try {
            User user = new UserDAO().login(email, password);
            if (user != null) {
                HttpSession oldSession = req.getSession(false);
                if (oldSession != null) oldSession.invalidate();
                HttpSession newSession = req.getSession(true);
                newSession.setAttribute("user", user);
                newSession.setAttribute("csrf", CsrfUtil.createToken());
                resp.sendRedirect("calculator.jsp");
            } else {
                req.setAttribute("error", "Invalid email or password.");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
