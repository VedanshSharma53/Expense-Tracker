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
    
    // Get user statistics
    ExpenseDAO expenseDAO = new ExpenseDAO();
    List<Expense> expenses = expenseDAO.getExpensesByUserId(userId);
    double totalExpenses = expenseDAO.getTotalExpensesByUserId(userId);
    
    // Calculate user statistics
    int totalTransactions = expenses.size();
    double averageExpense = totalTransactions > 0 ? totalExpenses / totalTransactions : 0;
    
    // Calculate join date (assuming it's available)
    LocalDate joinDate = LocalDate.now().minusMonths(6); // Example join date
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Expense Tracker</title>
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
            <li><a href="budget.jsp"><i class="fas fa-piggy-bank"></i> Budget</a></li>
            <li><a href="profile.jsp" class="active"><i class="fas fa-user"></i> Profile</a></li>
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
        
        <!-- Profile Section -->
        <div class="profile-section">
            <div class="section-header">
                <h2><i class="fas fa-user-circle"></i> Profile & Settings</h2>
                <button onclick="openEditProfileModal()" class="action-btn">
                    <i class="fas fa-edit"></i>
                    Edit Profile
                </button>
            </div>
            
            <!-- Profile Information -->
            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="profile-info">
                        <h2><%= user.getFullName() %></h2>
                        <p><i class="fas fa-envelope"></i> <%= user.getEmail() %></p>
                        <p><i class="fas fa-user-tag"></i> @<%= user.getUsername() %></p>
                        <p><i class="fas fa-calendar-alt"></i> Member since <%= joinDate %></p>
                    </div>
                </div>
                
                <!-- User Statistics -->
                <div class="stats-section">
                    <h3><i class="fas fa-chart-line"></i> Your Statistics</h3>
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-icon">
                                <i class="fas fa-rupee-sign"></i>
                            </div>
                            <div class="stat-details">
                                <span class="stat-label">Total Spent</span>
                                <span class="stat-value">₹<%= String.format("%.2f", totalExpenses) %></span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">
                                <i class="fas fa-receipt"></i>
                            </div>
                            <div class="stat-details">
                                <span class="stat-label">Total Transactions</span>
                                <span class="stat-value"><%= totalTransactions %></span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">
                                <i class="fas fa-calculator"></i>
                            </div>
                            <div class="stat-details">
                                <span class="stat-label">Average Expense</span>
                                <span class="stat-value">₹<%= String.format("%.2f", averageExpense) %></span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">
                                <i class="fas fa-calendar-day"></i>
                            </div>
                            <div class="stat-details">
                                <span class="stat-label">Days Active</span>
                                <span class="stat-value">180</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Account Settings -->
                <!-- <div class="settings-section">
                    <h3><i class="fas fa-cogs"></i> Account Settings</h3>
                    <div class="settings-grid">
                        <div class="setting-item">
                            <div class="setting-info">
                                <h4><i class="fas fa-bell"></i> Email Notifications</h4>
                                <p>Receive email notifications for budget alerts and reports</p>
                            </div>
                            <div class="setting-control">
                                <label class="switch">
                                    <input type="checkbox" checked>
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>
                        
                        <div class="setting-item">
                            <div class="setting-info">
                                <h4><i class="fas fa-shield-alt"></i> Two-Factor Authentication</h4>
                                <p>Add an extra layer of security to your account</p>
                            </div>
                            <div class="setting-control">
                                <button class="btn-secondary">Enable 2FA</button>
                            </div>
                        </div>
                        
                        <div class="setting-item">
                            <div class="setting-info">
                                <h4><i class="fas fa-download"></i> Export Data</h4>
                                <p>Download all your expense data in CSV format</p>
                            </div>
                            <div class="setting-control">
                                <button onclick="exportUserData()" class="btn-secondary">Export</button>
                            </div>
                        </div>
                        
                        <div class="setting-item">
                            <div class="setting-info">
                                <h4><i class="fas fa-key"></i> Change Password</h4>
                                <p>Update your account password for better security</p>
                            </div>
                            <div class="setting-control">
                                <button onclick="openChangePasswordModal()" class="btn-secondary">Change</button>
                            </div>
                        </div>
                    </div>
                </div> -->
                
                <!-- Danger Zone -->
                <!-- <div class="danger-section">
                    <h3><i class="fas fa-exclamation-triangle"></i> Danger Zone</h3>
                    <div class="danger-content">
                        <div class="danger-item">
                            <div class="danger-info">
                                <h4>Delete Account</h4>
                                <p>Permanently delete your account and all associated data. This action cannot be undone.</p>
                            </div>
                            <button onclick="confirmDeleteAccount()" class="btn-danger">Delete Account</button>
                        </div>
                    </div>
                </div> -->
            </div>
        </div>
    </div>
    
    <!-- Edit Profile Modal -->
    <div id="editProfileModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-edit"></i> Edit Profile</h3>
                <span class="close" onclick="closeEditProfileModal()">&times;</span>
            </div>
            <form action="profile" method="post">
                <input type="hidden" name="action" value="update">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="fullName"><i class="fas fa-user"></i> Full Name</label>
                        <input type="text" id="fullName" name="fullName" value="<%= user.getFullName() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="email"><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="username"><i class="fas fa-user-tag"></i> Username</label>
                        <input type="text" id="username" name="username" value="<%= user.getUsername() %>" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="closeEditProfileModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-primary">Update Profile</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Change Password Modal -->
    <div id="changePasswordModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-key"></i> Change Password</h3>
                <span class="close" onclick="closeChangePasswordModal()">&times;</span>
            </div>
            <form action="profile" method="post">
                <input type="hidden" name="action" value="changePassword">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="currentPassword"><i class="fas fa-lock"></i> Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" required>
                    </div>
                    <div class="form-group">
                        <label for="newPassword"><i class="fas fa-key"></i> New Password</label>
                        <input type="password" id="newPassword" name="newPassword" required minlength="6">
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword"><i class="fas fa-check"></i> Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="closeChangePasswordModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-primary">Change Password</button>
                </div>
            </form>
        </div>
    </div>
    
    <script src="js/profile.js"></script>
    
    <style>
        .stats-section, .settings-section, .danger-section {
            margin: 30px 0;
            padding-top: 30px;
            border-top: 1px solid #eee;
        }
        
        .stats-section h3, .settings-section h3, .danger-section h3 {
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 15px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            transition: transform 0.3s ease;
        }
        
        .stat-item:hover {
            transform: translateY(-2px);
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }
        
        .stat-details {
            display: flex;
            flex-direction: column;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }
        
        .settings-grid {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .setting-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .setting-info h4 {
            color: #333;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .setting-info p {
            color: #666;
            font-size: 14px;
        }
        
        /* Toggle Switch */
        .switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
        }
        
        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
        }
        
        .slider:before {
            position: absolute;
            content: "";
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        input:checked + .slider {
            background-color: #667eea;
        }
        
        input:checked + .slider:before {
            transform: translateX(26px);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .danger-section {
            border-top: 2px solid #ff6b6b;
        }
        
        .danger-section h3 {
            color: #ff6b6b;
        }
        
        .danger-content {
            background: #fff5f5;
            border-radius: 12px;
            padding: 20px;
            border: 1px solid #ffebee;
        }
        
        .danger-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .danger-info h4 {
            color: #ff6b6b;
            margin-bottom: 5px;
        }
        
        .danger-info p {
            color: #666;
            font-size: 14px;
        }
        
        .btn-danger {
            background: #ff6b6b;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-danger:hover {
            background: #e74c3c;
            transform: translateY(-2px);
        }
        
        @media (max-width: 768px) {
            .setting-item, .danger-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .setting-control {
                width: 100%;
                display: flex;
                justify-content: flex-end;
            }
        }
    </style>
</body>
</html> 