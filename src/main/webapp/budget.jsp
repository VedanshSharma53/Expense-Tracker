<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.expense.*" %>
<%@ page import="java.time.LocalDate" %>
<%
    // Check if user is logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get user information
    User user = (User) session.getAttribute("user");
    int userId = (Integer) session.getAttribute("userId");
    
    // Get budgets
    BudgetDAO budgetDAO = new BudgetDAO();
    List<Budget> budgets = budgetDAO.getBudgetsByUserId(userId);
    List<Budget> activeBudgets = budgetDAO.getActiveBudgets(userId);
    
    // Calculate budget overview
    double totalBudgetLimit = budgets.stream().mapToDouble(Budget::getBudgetLimit).sum();
    double totalSpent = budgets.stream().mapToDouble(Budget::getSpent).sum();
    double totalRemaining = totalBudgetLimit - totalSpent;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Budget Management - Expense Tracker</title>
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
            <li><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
            <li><a href="categories.jsp"><i class="fas fa-tags"></i> Categories</a></li>
            <li><a href="budget.jsp" class="active"><i class="fas fa-piggy-bank"></i> Budget</a></li>
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
        
        <!-- Budget Overview -->
        <div class="budget-section">
            <div class="section-header">
                <h2><i class="fas fa-piggy-bank"></i> Budget Management</h2>
                <button onclick="openAddBudgetModal()" class="action-btn">
                    <i class="fas fa-plus"></i>
                    Create Budget
                </button>
            </div>
            
            <!-- Budget Summary Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #2ed573, #7bed9f);">
                        <i class="fas fa-wallet"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Budget</h3>
                        <div class="value">₹<%= String.format("%.2f", totalBudgetLimit) %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #ff6b6b, #ff8e8e);">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Spent</h3>
                        <div class="value">₹<%= String.format("%.2f", totalSpent) %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe, #00f2fe);">
                        <i class="fas fa-coins"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Remaining</h3>
                        <div class="value" style="color: <%= totalRemaining >= 0 ? "#2ed573" : "#ff6b6b" %>">
                            ₹<%= String.format("%.2f", totalRemaining) %>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #a8edea, #fed6e3);">
                        <i class="fas fa-chart-pie"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Active Budgets</h3>
                        <div class="value"><%= activeBudgets.size() %></div>
                    </div>
                </div>
            </div>
            
            <!-- Active Budgets -->
            <div style="margin: 30px 0;">
                <h3 style="color: #333; margin-bottom: 20px;">
                    <i class="fas fa-calendar-check"></i> Active Budgets
                </h3>
                
                <% if (activeBudgets.isEmpty()) { %>
                    <div class="no-data">
                        <i class="fas fa-piggy-bank"></i>
                        <p>No active budgets found. Create your first budget to start tracking your spending!</p>
                    </div>
                <% } else { %>
                    <div class="budget-grid">
                        <% for (Budget budget : activeBudgets) { 
                            double percentage = budget.getBudgetUsagePercentage();
                            String statusColor = percentage > 90 ? "#ff6b6b" : percentage > 70 ? "#ffb84d" : "#2ed573";
                            String statusIcon = percentage > 90 ? "exclamation-triangle" : percentage > 70 ? "exclamation-circle" : "check-circle";
                        %>
                            <div class="budget-card">
                                <div class="budget-header">
                                    <div class="budget-category">
                                        <i class="fas fa-tag"></i>
                                        <span><%= budget.getCategory() %></span>
                                    </div>
                                    <div class="budget-status" style="color: <%= statusColor %>;">
                                        <i class="fas fa-<%= statusIcon %>"></i>
                                    </div>
                                </div>
                                
                                <div class="budget-amounts">
                                    <div class="amount-item">
                                        <span class="label">Budget Limit</span>
                                        <span class="value">₹<%= String.format("%.2f", budget.getBudgetLimit()) %></span>
                                    </div>
                                    <div class="amount-item">
                                        <span class="label">Spent</span>
                                        <span class="value spent">₹<%= String.format("%.2f", budget.getSpent()) %></span>
                                    </div>
                                    <div class="amount-item">
                                        <span class="label">Remaining</span>
                                        <span class="value remaining" style="color: <%= budget.getRemainingBudget() >= 0 ? "#2ed573" : "#ff6b6b" %>">
                                            ₹<%= String.format("%.2f", budget.getRemainingBudget()) %>
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="budget-progress">
                                    <div class="progress-info">
                                        <span><%= String.format("%.1f", percentage) %>% used</span>
                                        <span class="period"><%= budget.getPeriod() %></span>
                                    </div>
                                    <div class="progress-bar">
                                        <div class="progress-fill" style="width: <%= Math.min(percentage, 100) %>%; background-color: <%= statusColor %>;"></div>
                                    </div>
                                    <div class="progress-dates">
                                        <span><%= budget.getStartDate() %></span>
                                        <span><%= budget.getEndDate() %></span>
                                    </div>
                                </div>
                                
                                <div class="budget-actions">
                                    <button onclick="editBudget(<%= budget.getBudgetId() %>)" class="btn-edit">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button onclick="deleteBudget(<%= budget.getBudgetId() %>)" class="btn-delete">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
            
            <!-- Budget History -->
            <% if (!budgets.isEmpty()) { %>
                <div style="margin: 30px 0;">
                    <h3 style="color: #333; margin-bottom: 20px;">
                        <i class="fas fa-history"></i> Budget History
                    </h3>
                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Category</th>
                                    <th>Period</th>
                                    <th>Budget Limit</th>
                                    <th>Spent</th>
                                    <th>Status</th>
                                    <th>Duration</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Budget budget : budgets) { 
                                    double percentage = budget.getBudgetUsagePercentage();
                                    String status = percentage > 100 ? "Over Budget" : percentage > 90 ? "Near Limit" : "On Track";
                                    String statusClass = percentage > 100 ? "status-over" : percentage > 90 ? "status-warning" : "status-good";
                                %>
                                    <tr>
                                        <td>
                                            <span class="category-tag">
                                                <i class="fas fa-tag"></i>
                                                <%= budget.getCategory() %>
                                            </span>
                                        </td>
                                        <td><%= budget.getPeriod() %></td>
                                        <td>₹<%= String.format("%.2f", budget.getBudgetLimit()) %></td>
                                        <td>₹<%= String.format("%.2f", budget.getSpent()) %></td>
                                        <td>
                                            <span class="status-badge <%= statusClass %>">
                                                <%= status %>
                                            </span>
                                        </td>
                                        <td><%= budget.getStartDate() %> to <%= budget.getEndDate() %></td>
                                        <td>
                                            <div class="table-actions">
                                                <button onclick="editBudget(<%= budget.getBudgetId() %>)" class="btn-icon">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button onclick="deleteBudget(<%= budget.getBudgetId() %>)" class="btn-icon btn-danger">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
    
    <!-- Add Budget Modal -->
    <div id="addBudgetModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-plus"></i> Create New Budget</h3>
                <span class="close" onclick="closeAddBudgetModal()">&times;</span>
            </div>
            <form action="budget" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="category"><i class="fas fa-tag"></i> Category</label>
                        <select id="category" name="category" required>
                            <option value="">Select Category</option>
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
                    <div class="form-group">
                        <label for="budgetLimit"><i class="fas fa-rupee-sign"></i> Budget Limit</label>
                        <input type="number" id="budgetLimit" name="budgetLimit" step="0.01" min="0" required>
                    </div>
                    <div class="form-group">
                        <label for="period"><i class="fas fa-calendar"></i> Period</label>
                        <select id="period" name="period" required onchange="updateDateRange()">
                            <option value="">Select Period</option>
                            <option value="MONTHLY">Monthly</option>
                            <option value="WEEKLY">Weekly</option>
                            <option value="YEARLY">Yearly</option>
                            <option value="CUSTOM">Custom</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="startDate"><i class="fas fa-calendar-alt"></i> Start Date</label>
                        <input type="date" id="startDate" name="startDate" required>
                    </div>
                    <div class="form-group">
                        <label for="endDate"><i class="fas fa-calendar-alt"></i> End Date</label>
                        <input type="date" id="endDate" name="endDate" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="closeAddBudgetModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-primary">Create Budget</button>
                </div>
            </form>
        </div>
    </div>
    
    <script src="js/budget.js"></script>
    
    <style>
        .budget-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
        }
        
        .budget-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            position: relative;
        }
        
        .budget-card:hover {
            transform: translateY(-5px);
        }
        
        .budget-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .budget-category {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            font-size: 18px;
            color: #333;
        }
        
        .budget-status {
            font-size: 20px;
        }
        
        .budget-amounts {
            margin-bottom: 20px;
        }
        
        .amount-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .amount-item .label {
            color: #666;
            font-size: 14px;
        }
        
        .amount-item .value {
            font-weight: 600;
            color: #333;
        }
        
        .budget-progress {
            margin-bottom: 20px;
        }
        
        .progress-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .progress-info .period {
            background: #f8f9fa;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
            color: #666;
        }
        
        .progress-dates {
            display: flex;
            justify-content: space-between;
            margin-top: 8px;
            font-size: 12px;
            color: #999;
        }
        
        .budget-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        
        .btn-edit, .btn-delete {
            width: 35px;
            height: 35px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        
        .btn-edit {
            background: #4facfe;
            color: white;
        }
        
        .btn-edit:hover {
            background: #3498db;
        }
        
        .btn-delete {
            background: #ff6b6b;
            color: white;
        }
        
        .btn-delete:hover {
            background: #e74c3c;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-good {
            background: #d4edda;
            color: #155724;
        }
        
        .status-warning {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-over {
            background: #f8d7da;
            color: #721c24;
        }
        
        .category-tag {
            display: flex;
            align-items: center;
            gap: 8px;
            background: #f8f9fa;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 14px;
        }
        
        .table-actions {
            display: flex;
            gap: 8px;
        }
        
        .btn-icon {
            width: 30px;
            height: 30px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8f9fa;
            color: #666;
            transition: all 0.3s ease;
        }
        
        .btn-icon:hover {
            background: #667eea;
            color: white;
        }
        
        .btn-icon.btn-danger:hover {
            background: #e74c3c;
            color: white;
        }
        
        @media (max-width: 768px) {
            .budget-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</body>
</html> 