-- Expense Tracker Database Schema
-- Create database
CREATE DATABASE IF NOT EXISTS expense_tracker;
USE expense_tracker;

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Expenses table
CREATE TABLE expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    expense_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    expense_date DATE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Budgets table
CREATE TABLE budgets (
    budget_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category VARCHAR(50) NOT NULL,
    budget_limit DECIMAL(10, 2) NOT NULL,
    period ENUM('WEEKLY', 'MONTHLY', 'YEARLY', 'CUSTOM') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Categories table (for predefined categories)
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL, -- NULL for system categories, user_id for custom categories
    category_name VARCHAR(50) NOT NULL,
    category_icon VARCHAR(50) DEFAULT 'fa-tag',
    category_color VARCHAR(7) DEFAULT '#667eea',
    is_system BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- User Settings table
CREATE TABLE user_settings (
    setting_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    setting_name VARCHAR(50) NOT NULL,
    setting_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_setting (user_id, setting_name)
);

-- Income table (for tracking income)
CREATE TABLE income (
    income_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    income_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    source VARCHAR(50) NOT NULL,
    income_date DATE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Goals table (for financial goals)
CREATE TABLE goals (
    goal_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    goal_name VARCHAR(100) NOT NULL,
    target_amount DECIMAL(10, 2) NOT NULL,
    current_amount DECIMAL(10, 2) DEFAULT 0,
    target_date DATE,
    goal_type ENUM('SAVINGS', 'EXPENSE_REDUCTION', 'INCOME_INCREASE') NOT NULL,
    status ENUM('ACTIVE', 'COMPLETED', 'PAUSED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Notifications table
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    notification_type ENUM('BUDGET_ALERT', 'GOAL_UPDATE', 'SYSTEM') NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert default system categories
INSERT INTO categories (category_name, category_icon, category_color, is_system) VALUES
('Food', 'fa-utensils', '#ff6b6b', TRUE),
('Transportation', 'fa-car', '#4ecdc4', TRUE),
('Entertainment', 'fa-film', '#45b7d1', TRUE),
('Shopping', 'fa-shopping-cart', '#f9ca24', TRUE),
('Bills', 'fa-file-invoice-dollar', '#f0932b', TRUE),
('Healthcare', 'fa-heartbeat', '#eb4d4b', TRUE),
('Education', 'fa-graduation-cap', '#6c5ce7', TRUE),
('General', 'fa-tag', '#a29bfe', TRUE);

-- Insert demo user (password: demo123)
INSERT INTO users (username, email, password, full_name) VALUES
('demo', 'demo@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Demo User');

-- Get the demo user ID for sample data
SET @demo_user_id = LAST_INSERT_ID();

-- Insert sample expenses for demo user
INSERT INTO expenses (user_id, expense_name, amount, category, expense_date, description) VALUES
(@demo_user_id, 'Lunch at Restaurant', 250.00, 'Food', '2024-12-10', 'Business lunch with client'),
(@demo_user_id, 'Petrol', 1500.00, 'Transportation', '2024-12-09', 'Monthly fuel expense'),
(@demo_user_id, 'Movie Tickets', 500.00, 'Entertainment', '2024-12-08', 'Weekend movie with family'),
(@demo_user_id, 'Grocery Shopping', 2500.00, 'Food', '2024-12-07', 'Weekly grocery shopping'),
(@demo_user_id, 'Internet Bill', 1200.00, 'Bills', '2024-12-06', 'Monthly internet subscription'),
(@demo_user_id, 'Medicine', 800.00, 'Healthcare', '2024-12-05', 'Monthly prescription'),
(@demo_user_id, 'Book Purchase', 450.00, 'Education', '2024-12-04', 'Technical programming book'),
(@demo_user_id, 'Coffee', 150.00, 'Food', '2024-12-03', 'Morning coffee'),
(@demo_user_id, 'Bus Fare', 50.00, 'Transportation', '2024-12-02', 'Daily commute'),
(@demo_user_id, 'Electricity Bill', 2200.00, 'Bills', '2024-12-01', 'Monthly electricity bill');

-- Insert sample budgets for demo user
INSERT INTO budgets (user_id, category, budget_limit, period, start_date, end_date) VALUES
(@demo_user_id, 'Food', 8000.00, 'MONTHLY', '2024-12-01', '2024-12-31'),
(@demo_user_id, 'Transportation', 3000.00, 'MONTHLY', '2024-12-01', '2024-12-31'),
(@demo_user_id, 'Entertainment', 2000.00, 'MONTHLY', '2024-12-01', '2024-12-31'),
(@demo_user_id, 'Bills', 5000.00, 'MONTHLY', '2024-12-01', '2024-12-31');

-- Insert sample income for demo user
INSERT INTO income (user_id, income_name, amount, source, income_date, description) VALUES
(@demo_user_id, 'Salary', 50000.00, 'Job', '2024-12-01', 'Monthly salary'),
(@demo_user_id, 'Freelance Project', 15000.00, 'Freelance', '2024-12-05', 'Web development project'),
(@demo_user_id, 'Investment Returns', 2500.00, 'Investment', '2024-12-10', 'Mutual fund returns');

-- Insert sample goals for demo user
INSERT INTO goals (user_id, goal_name, target_amount, current_amount, target_date, goal_type) VALUES
(@demo_user_id, 'Emergency Fund', 100000.00, 25000.00, '2025-06-30', 'SAVINGS'),
(@demo_user_id, 'Reduce Food Expenses', 6000.00, 3350.00, '2024-12-31', 'EXPENSE_REDUCTION'),
(@demo_user_id, 'Vacation Fund', 50000.00, 12000.00, '2025-03-31', 'SAVINGS');

-- Insert default user settings for demo user
INSERT INTO user_settings (user_id, setting_name, setting_value) VALUES
(@demo_user_id, 'email_notifications', 'true'),
(@demo_user_id, 'budget_alerts', 'true'),
(@demo_user_id, 'currency', 'INR'),
(@demo_user_id, 'date_format', 'DD/MM/YYYY'),
(@demo_user_id, 'theme', 'default');

-- Insert sample notifications for demo user
INSERT INTO notifications (user_id, title, message, notification_type) VALUES
(@demo_user_id, 'Budget Alert', 'You have exceeded 80% of your Food budget for this month.', 'BUDGET_ALERT'),
(@demo_user_id, 'Goal Progress', 'Great job! You are 25% closer to your Emergency Fund goal.', 'GOAL_UPDATE'),
(@demo_user_id, 'Welcome!', 'Welcome to Expense Tracker! Start by adding your first expense.', 'SYSTEM');

-- Create indexes for better performance
CREATE INDEX idx_expenses_user_date ON expenses(user_id, expense_date);
CREATE INDEX idx_expenses_category ON expenses(category);
CREATE INDEX idx_budgets_user_period ON budgets(user_id, start_date, end_date);
CREATE INDEX idx_income_user_date ON income(user_id, income_date);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);

-- Create views for commonly used queries

-- View for user expense summary
CREATE VIEW user_expense_summary AS
SELECT 
    u.user_id,
    u.username,
    u.full_name,
    COUNT(e.expense_id) as total_transactions,
    COALESCE(SUM(e.amount), 0) as total_expenses,
    COALESCE(AVG(e.amount), 0) as average_expense
FROM users u
LEFT JOIN expenses e ON u.user_id = e.user_id
GROUP BY u.user_id, u.username, u.full_name;

-- View for monthly expense breakdown
CREATE VIEW monthly_expense_breakdown AS
SELECT 
    user_id,
    YEAR(expense_date) as expense_year,
    MONTH(expense_date) as expense_month,
    category,
    COUNT(*) as transaction_count,
    SUM(amount) as total_amount
FROM expenses
GROUP BY user_id, YEAR(expense_date), MONTH(expense_date), category;

-- View for budget status
CREATE VIEW budget_status AS
SELECT 
    b.budget_id,
    b.user_id,
    b.category,
    b.budget_limit,
    b.period,
    b.start_date,
    b.end_date,
    COALESCE(SUM(e.amount), 0) as spent_amount,
    (b.budget_limit - COALESCE(SUM(e.amount), 0)) as remaining_amount,
    ROUND((COALESCE(SUM(e.amount), 0) / b.budget_limit) * 100, 2) as usage_percentage
FROM budgets b
LEFT JOIN expenses e ON b.user_id = e.user_id 
    AND b.category = e.category 
    AND e.expense_date BETWEEN b.start_date AND b.end_date
GROUP BY b.budget_id, b.user_id, b.category, b.budget_limit, b.period, b.start_date, b.end_date;

-- Stored procedures for common operations

-- Procedure to get user dashboard data
DELIMITER //
CREATE PROCEDURE GetUserDashboard(IN p_user_id INT)
BEGIN
    -- Get user basic info
    SELECT user_id, username, email, full_name, created_at 
    FROM users 
    WHERE user_id = p_user_id;
    
    -- Get total expenses
    SELECT COALESCE(SUM(amount), 0) as total_expenses
    FROM expenses 
    WHERE user_id = p_user_id;
    
    -- Get recent expenses
    SELECT expense_id, expense_name, amount, category, expense_date
    FROM expenses 
    WHERE user_id = p_user_id 
    ORDER BY expense_date DESC, created_at DESC 
    LIMIT 10;
    
    -- Get active budgets
    SELECT budget_id, category, budget_limit, start_date, end_date
    FROM budgets 
    WHERE user_id = p_user_id 
        AND CURDATE() BETWEEN start_date AND end_date;
END //
DELIMITER ;

-- Procedure to add expense with budget check
DELIMITER //
CREATE PROCEDURE AddExpenseWithBudgetCheck(
    IN p_user_id INT,
    IN p_expense_name VARCHAR(100),
    IN p_amount DECIMAL(10,2),
    IN p_category VARCHAR(50),
    IN p_expense_date DATE,
    IN p_description TEXT
)
BEGIN
    DECLARE v_budget_limit DECIMAL(10,2) DEFAULT 0;
    DECLARE v_current_spent DECIMAL(10,2) DEFAULT 0;
    DECLARE v_new_total DECIMAL(10,2) DEFAULT 0;
    DECLARE v_budget_id INT DEFAULT 0;
    
    -- Insert the expense
    INSERT INTO expenses (user_id, expense_name, amount, category, expense_date, description)
    VALUES (p_user_id, p_expense_name, p_amount, p_category, p_expense_date, p_description);
    
    -- Check if this expense exceeds any active budget
    SELECT b.budget_id, b.budget_limit, COALESCE(SUM(e.amount), 0)
    INTO v_budget_id, v_budget_limit, v_current_spent
    FROM budgets b
    LEFT JOIN expenses e ON b.user_id = e.user_id 
        AND b.category = e.category 
        AND e.expense_date BETWEEN b.start_date AND b.end_date
    WHERE b.user_id = p_user_id 
        AND b.category = p_category
        AND p_expense_date BETWEEN b.start_date AND b.end_date
    GROUP BY b.budget_id, b.budget_limit
    LIMIT 1;
    
    -- If budget exists and is exceeded, create notification
    IF v_budget_id > 0 AND v_current_spent > (v_budget_limit * 0.8) THEN
        INSERT INTO notifications (user_id, title, message, notification_type)
        VALUES (p_user_id, 'Budget Alert', 
                CONCAT('You have spent ₹', v_current_spent, ' out of ₹', v_budget_limit, ' in ', p_category, ' category.'),
                'BUDGET_ALERT');
    END IF;
END //
DELIMITER ;

-- Grant permissions (adjust as needed for your environment)
-- GRANT ALL PRIVILEGES ON expense_tracker.* TO 'expense_user'@'localhost' IDENTIFIED BY 'your_password';
-- FLUSH PRIVILEGES;

-- Display success message
SELECT 'Database schema created successfully!' as status; 