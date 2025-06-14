document.addEventListener("DOMContentLoaded", function () {
    if (document.getElementById("expense-body")) {
        loadExpenses();
    }
    if (document.getElementById("total-expenses")) {
        updateDashboard();
    }
    if (document.getElementById("expenseChart")) {
        loadReports();
    }
});

let expenses = [];
let totalAmount = 0;

const categorySelect = document.getElementById("category-select");
const amountInput = document.getElementById("amount-input");
const dateInput = document.getElementById("date-input");
const addBtn = document.getElementById("add-btn");
const expensesTableBody = document.getElementById("expense-body");
const totalAmountCell = document.getElementById("total-amount");

function addExpense() {
    let name = document.getElementById("expense-name").value.trim();
    let amount = parseFloat(document.getElementById("expense-amount").value);
    let date = document.getElementById("expense-date").value;

    if (!name || isNaN(amount) || amount <= 0 || !date) {
        alert("Please fill all fields correctly!");
        return;
    }

    let expenses = JSON.parse(localStorage.getItem("expenses")) || [];

    let existingExpense = expenses.find(e => e.name === name && e.date === date);

    if (existingExpense) {
        existingExpense.amount = Number(existingExpense.amount) + amount; // 🔥 FIX: Convert to number before addition
    } else {
        expenses.push({ name, amount, date });
    }

    localStorage.setItem("expenses", JSON.stringify(expenses));

    loadExpenses();
    updateDashboard();
    loadReports();

    document.getElementById("expense-name").value = "";
    document.getElementById("expense-amount").value = "";
    document.getElementById("expense-date").value = "";
}

function loadExpenses() {
    let expenses = JSON.parse(localStorage.getItem("expenses")) || [];
    let tbody = document.getElementById("expense-body");
    
    if (!tbody) return;

    tbody.innerHTML = "";

    expenses.forEach((expense, index) => {
        let row = `<tr>
            <td>${expense.name}</td>
            <td>₹${expense.amount}</td>
            <td>${expense.date}</td>
            <td><button class="delete-btn" onclick="deleteExpense(${index})">Delete</button></td>
        </tr>`;
        tbody.innerHTML += row;
    });
}

function deleteExpense(index) {
    let expenses = JSON.parse(localStorage.getItem("expenses"));
    expenses.splice(index, 1);
    localStorage.setItem("expenses", JSON.stringify(expenses));
    loadExpenses();
    updateDashboard();
    loadReports();
}

function updateDashboard() {
    let expenses = JSON.parse(localStorage.getItem("expenses")) || [];
    let total = expenses.reduce((sum, expense) => sum + Number(expense.amount), 0);
    let totalElement = document.getElementById("total-expenses");

    if (totalElement) {
        totalElement.innerText = `₹${total}`;
    }

    let recentList = document.getElementById("recent-transactions");
    
    if (!recentList) return;

    recentList.innerHTML = "";

    if (expenses.length === 0) {
        recentList.innerHTML = "<li>No transactions available.</li>";
        return;
    }

    expenses.slice(-5).forEach((expense) => {
        let item = document.createElement("li");
        item.innerText = `${expense.name}: ₹${expense.amount}`;
        recentList.appendChild(item);
    });
}

function loadReports() {
    let expenses = JSON.parse(localStorage.getItem("expenses")) || [];
    let chartElement = document.getElementById("expenseChart");

    if (!chartElement) return;

    if (expenses.length === 0) {
        chartElement.style.display = "none";
        return;
    }

    chartElement.style.display = "block";

    let expenseMap = {};
    expenses.forEach(e => {
        if (expenseMap[e.name]) {
            expenseMap[e.name] += Number(e.amount);
        } else {
            expenseMap[e.name] = Number(e.amount);
        }
    });

    let labels = Object.keys(expenseMap);
    let data = Object.values(expenseMap);

    let ctx = chartElement.getContext("2d");

    if (window.expenseChartInstance) {
        window.expenseChartInstance.destroy();
    }

    window.expenseChartInstance = new Chart(ctx, {
        type: "bar",
        data: {
            labels: labels,
            datasets: [{
                label: "Expenses",
                data: data,
                backgroundColor: "#4CAF50",
            }]
        }
    });
}

function logout() {
    localStorage.removeItem("loggedInUser");
    alert("Logged out successfully!");
    window.location.href = "login.html";
}
