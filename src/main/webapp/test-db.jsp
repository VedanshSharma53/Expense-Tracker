<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.expense.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .success { color: green; }
        .error { color: red; }
        .info { color: blue; }
    </style>
</head>
<body>
    <h1>Database Connection Test</h1>
    
    <%
        try {
            // Test database connection
            Connection conn = DatabaseConnection.getConnection();
            
            if (conn != null) {
                out.println("<p class='success'>✅ Database connection successful!</p>");
                out.println("<p class='info'>Database URL: " + conn.getMetaData().getURL() + "</p>");
                out.println("<p class='info'>Database Product: " + conn.getMetaData().getDatabaseProductName() + "</p>");
                out.println("<p class='info'>Driver Version: " + conn.getMetaData().getDriverVersion() + "</p>");
                
                // Test if tables exist
                DatabaseMetaData metaData = conn.getMetaData();
                ResultSet tables = metaData.getTables(null, null, "users", null);
                
                if (tables.next()) {
                    out.println("<p class='success'>✅ 'users' table exists!</p>");
                    
                    // Count users
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM users");
                    if (rs.next()) {
                        out.println("<p class='info'>Total users in database: " + rs.getInt("count") + "</p>");
                    }
                    rs.close();
                    stmt.close();
                } else {
                    out.println("<p class='error'>❌ 'users' table does not exist!</p>");
                    out.println("<p class='info'>Please run the database_schema.sql file to create tables.</p>");
                }
                
                tables.close();
                conn.close();
            } else {
                out.println("<p class='error'>❌ Database connection failed!</p>");
            }
            
        } catch (SQLException e) {
            out.println("<p class='error'>❌ Database error: " + e.getMessage() + "</p>");
            out.println("<p class='info'>Error details: " + e.toString() + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ General error: " + e.getMessage() + "</p>");
        }
    %>
    
    <hr>
    <h3>Quick Actions:</h3>
    <a href="login.jsp">Go to Login</a> | 
    <a href="register.jsp">Go to Register</a>
    
    <hr>
    <h3>Database Configuration:</h3>
    <p><strong>Expected Database:</strong> expense_tracker</p>
    <p><strong>Expected Username:</strong> vedansh</p>
    <p><strong>Expected Password:</strong> vedansh</p>
    <p><strong>Expected Host:</strong> localhost:3306</p>
    
    <h3>Setup Instructions:</h3>
    <ol>
        <li>Make sure MySQL is running on localhost:3306</li>
        <li>Create database: <code>CREATE DATABASE expense_tracker;</code></li>
        <li>Create user: <code>CREATE USER 'vedansh'@'localhost' IDENTIFIED BY 'vedansh';</code></li>
        <li>Grant permissions: <code>GRANT ALL PRIVILEGES ON expense_tracker.* TO 'vedansh'@'localhost';</code></li>
        <li>Run the database_schema.sql file to create tables</li>
    </ol>
</body>
</html> 