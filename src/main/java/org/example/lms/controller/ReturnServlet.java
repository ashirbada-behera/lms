package org.example.lms.controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.lms.dao.IssueDAO;

import java.io.IOException;

@WebServlet ("/return")
public class ReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.getRequestDispatcher("/return.jsp").forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String issueIdText = req.getParameter("issueId");
        IssueDAO issueDAO = new IssueDAO();
        int issueId = Integer.parseInt(issueIdText);
        boolean success = issueDAO.returnBook(issueId);
        if (success) {
            resp.getWriter().write("success");
        } else  {
            resp.getWriter().write("failure");
        }
    }

}
