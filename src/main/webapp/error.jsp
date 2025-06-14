<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Expense Tracker</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container" style="text-align: center; padding: 50px;">
        <div class="error-content" style="background: white; border-radius: 15px; padding: 40px; box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);">
            <i class="fas fa-exclamation-triangle" style="font-size: 64px; color: #ff6b6b; margin-bottom: 20px;"></i>
            <h1 style="color: #333; margin-bottom: 20px;">Oops! Something went wrong</h1>
            
            <% if (exception != null) { %>
                <div class="error-details" style="background: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0;">
                    <h3 style="color: #666;">Error Details:</h3>
                    <p style="color: #e74c3c; font-weight: bold;"><%= exception.getMessage() %></p>
                    <% if (request.getAttribute("javax.servlet.error.status_code") != null) { %>
                        <p><strong>Status Code:</strong> <%= request.getAttribute("javax.servlet.error.status_code") %></p>
                    <% } %>
                </div>
            <% } %>
            
            <div class="error-actions" style="margin-top: 30px;">
                <a href="login.jsp" class="btn-primary" style="display: inline-block; padding: 12px 25px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-decoration: none; border-radius: 8px; margin: 0 10px;">
                    <i class="fas fa-home"></i> Go to Login
                </a>
                <button onclick="history.back()" class="btn-secondary" style="padding: 12px 25px; background: #6c757d; color: white; border: none; border-radius: 8px; margin: 0 10px; cursor: pointer;">
                    <i class="fas fa-arrow-left"></i> Go Back
                </button>
            </div>
            
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                <p style="color: #666; font-size: 14px;">
                    If this problem persists, please contact the administrator.
                </p>
            </div>
        </div>
    </div>
</body>
</html> 