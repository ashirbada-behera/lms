package org.example.lms.controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.lms.dao.MemberDAO;
import org.example.lms.dao.IssueDAO;
import org.example.lms.model.IssueRecord;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet ("/issue")

public class IssueServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        String registrationNumber = req.getParameter("registrationNumber");

        MemberDAO memberDAO = new MemberDAO();
        int memberId = memberDAO.getMemberId(registrationNumber);

        if (memberId == -1) {
            resp.getWriter().write("Member not found. Check the registration number.");
            return;
        }

        int bookId = Integer.parseInt(req.getParameter("bookId"));
        LocalDate issueDate = LocalDate.now();
        LocalDate dueDate = LocalDate.parse(req.getParameter("dueDate"));
        LocalDate returnDate = null;
        String status = "ISSUED";
        double fine = 0.0;

        IssueRecord issue = new IssueRecord(
                0,
                memberId,
                bookId,
                issueDate,
                dueDate,
                returnDate,
                status,
                fine
        );
        IssueDAO issueDAO = new IssueDAO();

        boolean success = issueDAO.addIssue(issue);

        if (success) {
            resp.getWriter().write("success");
        } else  {
            resp.getWriter().write("failure");
        }
    }

}
