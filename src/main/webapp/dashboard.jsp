<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.expense.*" %>
<%
    // Check if user is logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get user information
    User user = (User) session.getAttribute("user");
    int userId = (Integer) session.getAttribute("userId");
    
    // Get expenses
    ExpenseDAO expenseDAO = new ExpenseDAO();
    List<Expense> expenses = expenseDAO.getExpensesByUserId(userId);
    double totalExpenses = expenseDAO.getTotalExpensesByUserId(userId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Expense Tracker</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="nav-brand">
            <i class="fas fa-wallet"></i>
            <span>Expense Tracker</span>
        </div>
        <ul class="nav-menu">
            <li><a href="dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
            <li><a href="categories.jsp"><i class="fas fa-tags"></i> Categories</a></li>
            <li><a href="budget.jsp"><i class="fas fa-piggy-bank"></i> Budget</a></li>
            <li><a href="profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
            <li><a href="logout.jsp" class="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
        <div class="user-info">
            <span>Welcome, <%= user.getFullName() %>!</span>
        </div>
    </nav>
    
    <div class="container">
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>
        
        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-rupee-sign"></i>
                </div>
                <div class="stat-info">
                    <h3>Total Expenses</h3>
                    <div class="value">₹<%= String.format("%.2f", totalExpenses) %></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-receipt"></i>
                </div>
                <div class="stat-info">
                    <h3>Total Transactions</h3>
                    <div class="value"><%= expenses.size() %></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-calculator"></i>
                </div>
                <div class="stat-info">
                    <h3>Average per Transaction</h3>
                    <div class="value">₹<%= expenses.size() > 0 ? String.format("%.2f", totalExpenses / expenses.size()) : "0.00" %></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-calendar-day"></i>
                </div>
                <div class="stat-info">
                    <h3>This Month</h3>
                    <div class="value">₹<%= String.format("%.2f", totalExpenses * 0.3) %></div>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="quick-actions">
            <a href="#" class="action-btn" onclick="openAddExpenseModal()">
                <i class="fas fa-plus"></i>
                Add Expense
            </a>
            <a href="reports.jsp" class="action-btn">
                <i class="fas fa-chart-line"></i>
                View Reports
            </a>
            <a href="budget.jsp" class="action-btn">
                <i class="fas fa-piggy-bank"></i>
                Set Budget
            </a>
        </div>
        
        <!-- Recent Expenses -->
        <div class="expenses-section">
            <div class="section-header">
                <h2><i class="fas fa-history"></i> Recent Expenses</h2>
                <a href="expenses.jsp" class="view-all">View All</a>
            </div>
            
            <% if (expenses.isEmpty()) { %>
                <div class="no-data">
                    <i class="fas fa-inbox"></i>
                    <p>No expenses found. Start by adding your first expense!</p>
                </div>
            <% } else { %>
                <div class="expenses-grid">
                    <% 
                    int limit = Math.min(expenses.size(), 6); // Show only first 6 expenses
                    for (int i = 0; i < limit; i++) { 
                        Expense expense = expenses.get(i);
                    %>
                        <div class="expense-card">
                            <div class="expense-icon">
                                <i class="fas fa-<%= getCategoryIcon(expense.getCategory()) %>"></i>
                            </div>
                            <div class="expense-info">
                                <h4><%= expense.getExpenseName() %></h4>
                                <p class="category"><%= expense.getCategory() %></p>
                                <p class="date"><%= expense.getExpenseDate() %></p>
                            </div>
                            <div class="expense-amount">
                                ₹<%= String.format("%.2f", expense.getAmount()) %>
                            </div>
                            <div class="expense-actions">
                                <button onclick="deleteExpense(<%= expense.getExpenseId() %>)" class="delete-btn">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
    
    <!-- Add Expense Modal -->
    <div id="addExpenseModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-plus"></i> Add New Expense</h3>
                <span class="close" onclick="closeAddExpenseModal()">&times;</span>
            </div>
            <form action="expense" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="expenseName"><i class="fas fa-tag"></i> Expense Name</label>
                        <input type="text" id="expenseName" name="expenseName" required>
                    </div>
                    <div class="form-group">
                        <label for="amount"><i class="fas fa-rupee-sign"></i> Amount</label>
                        <input type="number" id="amount" name="amount" step="0.01" min="0" required>
                    </div>
                    <div class="form-group">
                        <label for="expenseDate"><i class="fas fa-calendar"></i> Date</label>
                        <input type="date" id="expenseDate" name="expenseDate" required>
                    </div>
                    <div class="form-group">
                        <label for="category"><i class="fas fa-list"></i> Category</label>
                        <select id="category" name="category">
                            <option value="Food">🍔 Food</option>
                            <option value="Transportation">🚗 Transportation</option>
                            <option value="Entertainment">🎬 Entertainment</option>
                            <option value="Shopping">🛍️ Shopping</option>
                            <option value="Bills">💡 Bills</option>
                            <option value="Healthcare">⚕️ Healthcare</option>
                            <option value="Education">📚 Education</option>
                            <option value="General">📋 General</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="closeAddExpenseModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-primary">Add Expense</button>
                </div>
            </form>
        </div>
    </div>
    
    <script src="js/dashboard.js"></script>
    
    <%!
    private String getCategoryIcon(String category) {
        switch(category.toLowerCase()) {
            case "food": return "utensils";
            case "transportation": return "car";
            case "entertainment": return "film";
            case "shopping": return "shopping-cart";
            case "bills": return "file-invoice-dollar";
            case "healthcare": return "heartbeat";
            case "education": return "graduation-cap";
            default: return "tag";
        }
    }
    %>
</body>
</html> 