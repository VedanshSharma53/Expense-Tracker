package com.expense;

import java.time.LocalDate;

public class Budget {

    private int budgetId;
    private int userId;
    private String category;
    private double budgetLimit;
    private double spent;
    private LocalDate startDate;
    private LocalDate endDate;
    private String period; // MONTHLY, WEEKLY, YEARLY

    // Constructors
    public Budget() {
    }

    public Budget(int userId, String category, double budgetLimit, String period, LocalDate startDate, LocalDate endDate) {
        this.userId = userId;
        this.category = category;
        this.budgetLimit = budgetLimit;
        this.period = period;
        this.startDate = startDate;
        this.endDate = endDate;
        this.spent = 0.0;
    }

    // Getters and Setters
    public int getBudgetId() {
        return budgetId;
    }

    public void setBudgetId(int budgetId) {
        this.budgetId = budgetId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getBudgetLimit() {
        return budgetLimit;
    }

    public void setBudgetLimit(double budgetLimit) {
        this.budgetLimit = budgetLimit;
    }

    public double getSpent() {
        return spent;
    }

    public void setSpent(double spent) {
        this.spent = spent;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    // Helper methods
    public double getRemainingBudget() {
        return budgetLimit - spent;
    }

    public double getBudgetUsagePercentage() {
        if (budgetLimit == 0) {
            return 0;
        }
        return (spent / budgetLimit) * 100;
    }

    public boolean isOverBudget() {
        return spent > budgetLimit;
    }
}
