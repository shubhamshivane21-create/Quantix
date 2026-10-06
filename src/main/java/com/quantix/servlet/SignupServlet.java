package com.quantix.servlet;

import com.quantix.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name").trim();
        String email = req.getParameter("email").trim().toLowerCase();
        String password = req.getParameter("password");

        if (name.isEmpty() || email.isEmpty() || password.length() < 6) {
            req.setAttribute("error", "Fill all fields. Password must be at least 6 characters.");
            req.getRequestDispatcher("signup.jsp").forward(req, resp);
            return;
        }
        try {
            if (new UserDAO().register(name, email, password)) {
                resp.sendRedirect("login.jsp?registered=1");
            } else {
                req.setAttribute("error", "This email is already registered.");
                req.getRequestDispatcher("signup.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
