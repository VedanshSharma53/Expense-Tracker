package com.expense;

import java.time.LocalDate;

public class Expense {
    private int expenseId;
    private int userId;
    private String expenseName;
    private double amount;
    private LocalDate expenseDate;
    private String category;
    
    // Constructors
    public Expense() {}
    
    public Expense(int userId, String expenseName, double amount, LocalDate expenseDate, String category) {
        this.userId = userId;
        this.expenseName = expenseName;
        this.amount = amount;
        this.expenseDate = expenseDate;
        this.category = category;
    }
    
    // Getters and Setters
    public int getExpenseId() {
        return expenseId;
    }
    
    public void setExpenseId(int expenseId) {
        this.expenseId = expenseId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getExpenseName() {
        return expenseName;
    }
    
    public void setExpenseName(String expenseName) {
        this.expenseName = expenseName;
    }
    
    public double getAmount() {
        return amount;
    }
    
    public void setAmount(double amount) {
        this.amount = amount;
    }
    
    public LocalDate getExpenseDate() {
        return expenseDate;
    }
    
    public void setExpenseDate(LocalDate expenseDate) {
        this.expenseDate = expenseDate;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
} 