package com.expense;

import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ExpenseServlet extends HttpServlet {

    private ExpenseDAO expenseDAO = new ExpenseDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addExpense(request, response, userId);
        } else if ("delete".equals(action)) {
            deleteExpense(request, response, userId);
        }
    }

    private void addExpense(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        String expenseName = request.getParameter("expenseName");
        String amountStr = request.getParameter("amount");
        String dateStr = request.getParameter("expenseDate");
        String category = request.getParameter("category");

        // Validation
        if (expenseName == null || expenseName.trim().isEmpty()
                || amountStr == null || amountStr.trim().isEmpty()
                || dateStr == null || dateStr.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            return;
        }

        try {
            double amount = Double.parseDouble(amountStr);
            LocalDate expenseDate = LocalDate.parse(dateStr);

            if (category == null || category.trim().isEmpty()) {
                category = "General";
            }

            Expense expense = new Expense(userId, expenseName, amount, expenseDate, category);

            if (expenseDAO.addExpense(expense)) {
                request.setAttribute("successMessage", "Expense added successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to add expense!");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid amount format!");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Invalid date format!");
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    private void deleteExpense(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        String expenseIdStr = request.getParameter("expenseId");

        try {
            int expenseId = Integer.parseInt(expenseIdStr);

            if (expenseDAO.deleteExpense(expenseId, userId)) {
                request.setAttribute("successMessage", "Expense deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to delete expense!");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid expense ID!");
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
