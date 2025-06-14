-- Database Verification Script for Expense Tracker
-- Run this in MySQL Workbench or command line to verify setup

-- 1. Check if database exists
SHOW DATABASES LIKE 'expense_tracker';

-- 2. Use the database
USE expense_tracker;

-- 3. Check if all required tables exist
SHOW TABLES;

-- 4. Verify users table structure
DESCRIBE users;

-- 5. Check if demo user exists
SELECT user_id, username, full_name, email, created_at 
FROM users 
WHERE username = 'demo';

-- 6. Count total users
SELECT COUNT(*) as total_users FROM users;

-- 7. Check expenses table
SELECT COUNT(*) as total_expenses FROM expenses;

-- 8. Check categories table
SELECT * FROM categories ORDER BY category_id;

-- 9. Verify database user permissions
SHOW GRANTS FOR 'vedansh'@'localhost';

-- 10. Test a simple join query
SELECT u.username, COUNT(e.expense_id) as expense_count
FROM users u
LEFT JOIN expenses e ON u.user_id = e.user_id
GROUP BY u.user_id, u.username;

-- Expected Results:
-- - Database 'expense_tracker' should exist
-- - Tables: users, expenses, categories, budgets, etc.
-- - Demo user should exist with username 'demo'
-- - At least some sample data should be present
-- - User 'vedansh' should have ALL PRIVILEGES on expense_tracker.* 