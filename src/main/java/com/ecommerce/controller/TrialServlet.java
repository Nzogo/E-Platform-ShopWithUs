package com.ecommerce.controller;

import com.ecommerce.service.TrialService;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/trial")
public class TrialServlet extends HttpServlet {

    private TrialService trialService = new TrialService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");
        String name = request.getParameter("name");

        if (email == null || email.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Email is required\"}");
            return;
        }

        boolean success = trialService.requestTrial(email, name);

        if (success) {
            out.print("{\"success\": true, \"message\": \"Trial request submitted! Check your email for details.\"}");
        } else {
            out.print("{\"success\": false, \"message\": \"Email already registered or invalid. Please try again.\"}");
        }
    }
}