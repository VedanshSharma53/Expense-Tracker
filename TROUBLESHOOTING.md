# 🔧 Expense Tracker - Troubleshooting Guide

## 🚨 **Current Issues & Solutions**

### **Issue 1: Cannot Access Pages After Login/Register**

**Problem**: Servlets are not working, getting error pages after login attempts.

**Root Cause**: Missing servlet API in classpath and potential database connectivity issues.

---

## 🛠️ **Step-by-Step Solutions**

### **Solution 1: Fix Eclipse Project Configuration**

1. **Right-click on project** → **Properties**
2. Go to **Project Facets**
3. Ensure these facets are enabled:
   - ✅ **Java** (version 17)
   - ✅ **Dynamic Web Module** (version 4.0)
   - ✅ **JavaScript** (version 1.0)

4. Go to **Java Build Path** → **Libraries**
5. Add **Server Runtime**:
   - Click **Add Library** → **Server Runtime**
   - Select **Apache Tomcat v9.0** (or your server)
   - Click **Finish**

### **Solution 2: Database Setup**

1. **Start MySQL Server** (XAMPP/WAMP/standalone MySQL)

2. **Create Database & User**:
   ```sql
   CREATE DATABASE expense_tracker;
   CREATE USER 'vedansh'@'localhost' IDENTIFIED BY 'vedansh';
   GRANT ALL PRIVILEGES ON expense_tracker.* TO 'vedansh'@'localhost';
   FLUSH PRIVILEGES;
   ```

3. **Import Database Schema**:
   - Open MySQL Workbench or phpMyAdmin
   - Select `expense_tracker` database
   - Import the `database_schema.sql` file

4. **Test Database Connection**:
   - Visit: `http://localhost:8080/ExpenseTrackerApp/test-db.jsp`
   - Should show green checkmarks if working

### **Solution 3: Server Configuration**

1. **Add Server to Eclipse**:
   - Window → Show View → Servers
   - Right-click in Servers view → New → Server
   - Select **Apache Tomcat v9.0**
   - Point to your Tomcat installation directory

2. **Deploy Project**:
   - Right-click on server → **Add and Remove**
   - Move your project to **Configured** side
   - Click **Finish**

3. **Start Server**:
   - Right-click server → **Start**

---

## 🧪 **Testing Steps**

### **Test 1: Database Connectivity**
```
URL: http://localhost:8080/ExpenseTrackerApp/test-db.jsp
Expected: Green checkmarks for database connection and tables
```

### **Test 2: Login Page**
```
URL: http://localhost:8080/ExpenseTrackerApp/login.jsp
Expected: Login form displays correctly
```

### **Test 3: Registration**
```
1. Go to register.jsp
2. Fill form with test data
3. Submit
Expected: User created successfully or error message displayed
```

### **Test 4: Login Process**
```
1. Use demo credentials: username=demo, password=demo123
2. Submit login form
Expected: Redirect to dashboard.jsp
```

---

## 🔍 **Common Error Messages & Fixes**

### **Error: "HTTP Status 404 - Not Found"**
**Fix**: 
- Check if server is running
- Verify project is deployed to server
- Check URL spelling

### **Error: "HTTP Status 500 - Internal Server Error"**
**Fix**: 
- Check server logs (Console view in Eclipse)
- Verify database connection
- Check servlet mappings in web.xml

### **Error: "ClassNotFoundException: com.mysql.cj.jdbc.Driver"**
**Fix**: 
- Ensure `mysql-connector-j-8.0.31.jar` is in `WEB-INF/lib/`
- Refresh project (F5)
- Clean and rebuild project

### **Error: "Access denied for user 'vedansh'@'localhost'"**
**Fix**: 
- Recreate MySQL user with correct permissions
- Check MySQL server is running
- Verify credentials in `DatabaseConnection.java`

---

## 📁 **File Structure Verification**

Ensure your project has this structure:
```
ExpenseTrackerApp/
├── src/main/java/com/expense/
│   ├── DatabaseConnection.java
│   ├── LoginServlet.java
│   ├── RegisterServlet.java
│   ├── ExpenseServlet.java
│   ├── UserDAO.java
│   ├── ExpenseDAO.java
│   ├── BudgetDAO.java
│   ├── User.java
│   ├── Expense.java
│   └── Budget.java
├── src/main/webapp/
│   ├── WEB-INF/
│   │   ├── web.xml
│   │   └── lib/
│   │       └── mysql-connector-j-8.0.31.jar
│   ├── css/
│   │   └── style.css
│   ├── js/
│   │   ├── dashboard.js
│   │   └── budget.js
│   ├── login.jsp
│   ├── register.jsp
│   ├── dashboard.jsp
│   ├── reports.jsp
│   ├── budget.jsp
│   ├── profile.jsp
│   ├── logout.jsp
│   ├── error.jsp
│   ├── test-db.jsp
│   └── index.jsp
└── database_schema.sql
```

---

## 🚀 **Quick Start Commands**

### **For MySQL Setup**:
```sql
-- Run these in MySQL command line or Workbench
CREATE DATABASE expense_tracker;
CREATE USER 'vedansh'@'localhost' IDENTIFIED BY 'vedansh';
GRANT ALL PRIVILEGES ON expense_tracker.* TO 'vedansh'@'localhost';
FLUSH PRIVILEGES;
USE expense_tracker;
SOURCE /path/to/database_schema.sql;
```

### **For Eclipse**:
1. **Clean Project**: Project → Clean → Select your project
2. **Refresh**: Right-click project → Refresh (F5)
3. **Rebuild**: Project → Build Project

---

## 📞 **Still Having Issues?**

1. **Check Eclipse Error Log**: 
   - Window → Show View → Error Log

2. **Check Server Console**: 
   - Look for red error messages in Console view

3. **Verify URLs**:
   - Login: `http://localhost:8080/ExpenseTrackerApp/login.jsp`
   - Register: `http://localhost:8080/ExpenseTrackerApp/register.jsp`
   - Test DB: `http://localhost:8080/ExpenseTrackerApp/test-db.jsp`

4. **Check Port**: 
   - Default Tomcat port is 8080
   - If different, update URLs accordingly

---

## ✅ **Success Indicators**

When everything is working correctly:
- ✅ `test-db.jsp` shows green database connection
- ✅ Login page loads without errors
- ✅ Registration creates new users
- ✅ Login redirects to dashboard
- ✅ All navigation links work
- ✅ No 404 or 500 errors

---

**Need more help?** Check the Eclipse console for specific error messages and refer to the corresponding section above. 