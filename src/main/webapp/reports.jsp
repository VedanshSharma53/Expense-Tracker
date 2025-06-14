<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.expense.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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
    
    // Calculate category-wise expenses
    Map<String, Double> categoryTotals = new HashMap<>();
    Map<String, Integer> categoryCounts = new HashMap<>();
    
    for (Expense expense : expenses) {
        String category = expense.getCategory();
        categoryTotals.put(category, categoryTotals.getOrDefault(category, 0.0) + expense.getAmount());
        categoryCounts.put(category, categoryCounts.getOrDefault(category, 0) + 1);
    }
    
    // Get current month expenses
    LocalDate now = LocalDate.now();
    String currentMonth = now.format(DateTimeFormatter.ofPattern("yyyy-MM"));
    double currentMonthTotal = expenses.stream()
        .filter(e -> e.getExpenseDate().format(DateTimeFormatter.ofPattern("yyyy-MM")).equals(currentMonth))
        .mapToDouble(Expense::getAmount)
        .sum();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Expense Tracker</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            <li><a href="reports.jsp" class="active"><i class="fas fa-chart-bar"></i> Reports</a></li>
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
        <!-- Reports Header -->
        <div class="reports-section">
            <div class="section-header">
                <h2><i class="fas fa-chart-line"></i> Expense Analytics & Reports</h2>
                <div class="filter-controls">
                    <select id="timeFilter" onchange="filterByTime()">
                        <option value="all">All Time</option>
                        <option value="thisMonth">This Month</option>
                        <option value="lastMonth">Last Month</option>
                        <option value="last3Months">Last 3 Months</option>
                        <option value="thisYear">This Year</option>
                    </select>
                </div>
            </div>
            
            <!-- Summary Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-rupee-sign"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Expenses</h3>
                        <div class="value" id="totalExpenses">₹<%= String.format("%.2f", totalExpenses) %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <div class="stat-info">
                        <h3>This Month</h3>
                        <div class="value" id="monthlyExpenses">₹<%= String.format("%.2f", currentMonthTotal) %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-chart-pie"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Categories</h3>
                        <div class="value" id="categoryCount"><%= categoryTotals.size() %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-trending-up"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Average/Day</h3>
                        <div class="value" id="dailyAverage">₹<%= String.format("%.2f", totalExpenses / 30) %></div>
                    </div>
                </div>
            </div>
            
            <!-- Charts Section -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin: 30px 0;">
                <div class="chart-container">
                    <h3 style="text-align: center; margin-bottom: 20px; color: #333;">
                        <i class="fas fa-chart-pie"></i> Expenses by Category
                    </h3>
                    <canvas id="categoryChart"></canvas>
                </div>
                <div class="chart-container">
                    <h3 style="text-align: center; margin-bottom: 20px; color: #333;">
                        <i class="fas fa-chart-line"></i> Monthly Trend
                    </h3>
                    <canvas id="trendChart"></canvas>
                </div>
            </div>
            
            <!-- Detailed Category Analysis -->
            <div style="margin: 30px 0;">
                <h3 style="color: #333; margin-bottom: 20px;">
                    <i class="fas fa-list-alt"></i> Category-wise Analysis
                </h3>
                <div class="category-analysis">
                    <% for (Map.Entry<String, Double> entry : categoryTotals.entrySet()) { 
                        String category = entry.getKey();
                        Double amount = entry.getValue();
                        int count = categoryCounts.get(category);
                        double percentage = (amount / totalExpenses) * 100;
                    %>
                        <div class="analysis-item">
                            <div class="analysis-header">
                                <div class="category-info">
                                    <span class="category-name"><%= category %></span>
                                    <span class="category-count"><%= count %> transactions</span>
                                </div>
                                <div class="category-amount">₹<%= String.format("%.2f", amount) %></div>
                            </div>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: <%= String.format("%.1f", percentage) %>%"></div>
                            </div>
                            <div class="analysis-details">
                                <span><%= String.format("%.1f", percentage) %>% of total</span>
                                <span>Avg: ₹<%= String.format("%.2f", amount / count) %></span>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Export Options -->
            <div style="margin: 30px 0; text-align: center;">
                <h3 style="color: #333; margin-bottom: 20px;">
                    <i class="fas fa-download"></i> Export Reports
                </h3>
                <div class="quick-actions">
                    <button onclick="exportToPDF()" class="action-btn">
                        <i class="fas fa-file-pdf"></i>
                        Export PDF
                    </button>
                    <button onclick="exportToCSV()" class="action-btn">
                        <i class="fas fa-file-csv"></i>
                        Export CSV
                    </button>
                    <button onclick="printReport()" class="action-btn">
                        <i class="fas fa-print"></i>
                        Print Report
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Chart data from JSP
        const categoryData = {
            <% 
            int i = 0;
            for (Map.Entry<String, Double> entry : categoryTotals.entrySet()) { 
                if (i > 0) out.print(",");
                out.print("'" + entry.getKey() + "': " + entry.getValue());
                i++;
            }
            %>
        };
        
        // Initialize charts
        document.addEventListener('DOMContentLoaded', function() {
            initializeCategoryChart();
            initializeTrendChart();
        });
        
        function initializeCategoryChart() {
            const ctx = document.getElementById('categoryChart').getContext('2d');
            const labels = Object.keys(categoryData);
            const data = Object.values(categoryData);
            
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        data: data,
                        backgroundColor: [
                            '#667eea', '#764ba2', '#f093fb', '#f5576c',
                            '#4facfe', '#00f2fe', '#a8edea', '#fed6e3',
                            '#ffecd2', '#fcb69f'
                        ],
                        borderWidth: 2,
                        borderColor: '#fff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = ((context.raw / total) * 100).toFixed(1);
                                    return context.label + ': ₹' + context.raw.toFixed(2) + ' (' + percentage + '%)';
                                }
                            }
                        }
                    }
                }
            });
        }
        
        function initializeTrendChart() {
            const ctx = document.getElementById('trendChart').getContext('2d');
            
            // Sample monthly data (you can make this dynamic with real data)
            const monthlyData = [
                <% 
                // Generate last 6 months data
                for (int month = 5; month >= 0; month--) {
                    LocalDate date = now.minusMonths(month);
                    String monthKey = date.format(DateTimeFormatter.ofPattern("yyyy-MM"));
                    double monthTotal = expenses.stream()
                        .filter(e -> e.getExpenseDate().format(DateTimeFormatter.ofPattern("yyyy-MM")).equals(monthKey))
                        .mapToDouble(Expense::getAmount)
                        .sum();
                    if (month < 5) out.print(",");
                    out.print(monthTotal);
                }
                %>
            ];
            
            const monthLabels = [
                <% 
                for (int month = 5; month >= 0; month--) {
                    LocalDate date = now.minusMonths(month);
                    String monthLabel = date.format(DateTimeFormatter.ofPattern("MMM yyyy"));
                    if (month < 5) out.print(",");
                    out.print("'" + monthLabel + "'");
                }
                %>
            ];
            
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: monthLabels,
                    datasets: [{
                        label: 'Monthly Expenses',
                        data: monthlyData,
                        borderColor: '#667eea',
                        backgroundColor: 'rgba(102, 126, 234, 0.1)',
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#667eea',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2,
                        pointRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'Expenses: ₹' + context.raw.toFixed(2);
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return '₹' + value.toFixed(0);
                                }
                            }
                        }
                    }
                }
            });
        }
        
        function filterByTime() {
            const filter = document.getElementById('timeFilter').value;
            // Implement time-based filtering
            console.log('Filtering by:', filter);
        }
        
        function exportToPDF() {
            alert('PDF export functionality will be implemented.');
        }
        
        function exportToCSV() {
            alert('CSV export functionality will be implemented.');
        }
        
        function printReport() {
            window.print();
        }
    </script>
    
    <style>
        .category-analysis {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .analysis-item {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }
        
        .analysis-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .category-info {
            display: flex;
            flex-direction: column;
        }
        
        .category-name {
            font-weight: 600;
            color: #333;
            font-size: 16px;
        }
        
        .category-count {
            color: #666;
            font-size: 12px;
        }
        
        .category-amount {
            font-size: 18px;
            font-weight: bold;
            color: #667eea;
        }
        
        .analysis-details {
            display: flex;
            justify-content: space-between;
            margin-top: 10px;
            font-size: 12px;
            color: #666;
        }
        
        .filter-controls select {
            padding: 8px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            background: white;
            color: #333;
            font-weight: 500;
        }
        
        @media (max-width: 768px) {
            div[style*="grid-template-columns: 1fr 1fr"] {
                grid-template-columns: 1fr !important;
            }
        }
    </style>
</body>
</html> 