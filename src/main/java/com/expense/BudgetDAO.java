package com.expense;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BudgetDAO {

    public boolean addBudget(Budget budget) {
        String sql = "INSERT INTO budgets (user_id, category, budget_limit, period, start_date, end_date) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, budget.getUserId());
            stmt.setString(2, budget.getCategory());
            stmt.setDouble(3, budget.getBudgetLimit());
            stmt.setString(4, budget.getPeriod());
            stmt.setDate(5, Date.valueOf(budget.getStartDate()));
            stmt.setDate(6, Date.valueOf(budget.getEndDate()));

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Budget> getBudgetsByUserId(int userId) {
        List<Budget> budgets = new ArrayList<>();
        String sql = "SELECT * FROM budgets WHERE user_id = ? ORDER BY start_date DESC";

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Budget budget = new Budget();
                budget.setBudgetId(rs.getInt("budget_id"));
                budget.setUserId(rs.getInt("user_id"));
                budget.setCategory(rs.getString("category"));
                budget.setBudgetLimit(rs.getDouble("budget_limit"));
                budget.setPeriod(rs.getString("period"));
                budget.setStartDate(rs.getDate("start_date").toLocalDate());
                budget.setEndDate(rs.getDate("end_date").toLocalDate());

                // Calculate spent amount for this budget
                double spent = calculateSpentAmount(userId, budget.getCategory(),
                        budget.getStartDate(), budget.getEndDate());
                budget.setSpent(spent);

                budgets.add(budget);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return budgets;
    }

    public boolean updateBudget(Budget budget) {
        String sql = "UPDATE budgets SET category = ?, budget_limit = ?, period = ?, start_date = ?, end_date = ? WHERE budget_id = ? AND user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, budget.getCategory());
            stmt.setDouble(2, budget.getBudgetLimit());
            stmt.setString(3, budget.getPeriod());
            stmt.setDate(4, Date.valueOf(budget.getStartDate()));
            stmt.setDate(5, Date.valueOf(budget.getEndDate()));
            stmt.setInt(6, budget.getBudgetId());
            stmt.setInt(7, budget.getUserId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteBudget(int budgetId, int userId) {
        String sql = "DELETE FROM budgets WHERE budget_id = ? AND user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, budgetId);
            stmt.setInt(2, userId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Budget getBudgetByCategory(int userId, String category) {
        String sql = "SELECT * FROM budgets WHERE user_id = ? AND category = ? AND start_date <= CURDATE() AND end_date >= CURDATE() ORDER BY start_date DESC LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setString(2, category);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Budget budget = new Budget();
                budget.setBudgetId(rs.getInt("budget_id"));
                budget.setUserId(rs.getInt("user_id"));
                budget.setCategory(rs.getString("category"));
                budget.setBudgetLimit(rs.getDouble("budget_limit"));
                budget.setPeriod(rs.getString("period"));
                budget.setStartDate(rs.getDate("start_date").toLocalDate());
                budget.setEndDate(rs.getDate("end_date").toLocalDate());

                // Calculate spent amount
                double spent = calculateSpentAmount(userId, budget.getCategory(),
                        budget.getStartDate(), budget.getEndDate());
                budget.setSpent(spent);

                return budget;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    private double calculateSpentAmount(int userId, String category, LocalDate startDate, LocalDate endDate) {
        String sql = "SELECT SUM(amount) as total FROM expenses WHERE user_id = ? AND category = ? AND expense_date BETWEEN ? AND ?";

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setString(2, category);
            stmt.setDate(3, Date.valueOf(startDate));
            stmt.setDate(4, Date.valueOf(endDate));

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    public List<Budget> getActiveBudgets(int userId) {
        List<Budget> budgets = new ArrayList<>();
        String sql = "SELECT * FROM budgets WHERE user_id = ? AND start_date <= CURDATE() AND end_date >= CURDATE()";

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Budget budget = new Budget();
                budget.setBudgetId(rs.getInt("budget_id"));
                budget.setUserId(rs.getInt("user_id"));
                budget.setCategory(rs.getString("category"));
                budget.setBudgetLimit(rs.getDouble("budget_limit"));
                budget.setPeriod(rs.getString("period"));
                budget.setStartDate(rs.getDate("start_date").toLocalDate());
                budget.setEndDate(rs.getDate("end_date").toLocalDate());

                // Calculate spent amount
                double spent = calculateSpentAmount(userId, budget.getCategory(),
                        budget.getStartDate(), budget.getEndDate());
                budget.setSpent(spent);

                budgets.add(budget);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return budgets;
    }
}
