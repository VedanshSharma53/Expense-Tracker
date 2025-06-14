// Dashboard JavaScript Functionality

document.addEventListener('DOMContentLoaded', function() {
    // Set today's date as default
    const dateInput = document.getElementById('expenseDate');
    if (dateInput) {
        dateInput.valueAsDate = new Date();
    }
    
    // Initialize tooltips and other UI components
    initializeUI();
});

// Modal Functions
function openAddExpenseModal() {
    const modal = document.getElementById('addExpenseModal');
    if (modal) {
        modal.style.display = 'block';
        document.body.style.overflow = 'hidden';
    }
}

function closeAddExpenseModal() {
    const modal = document.getElementById('addExpenseModal');
    if (modal) {
        modal.style.display = 'none';
        document.body.style.overflow = 'auto';
        
        // Reset form
        const form = modal.querySelector('form');
        if (form) {
            form.reset();
            document.getElementById('expenseDate').valueAsDate = new Date();
        }
    }
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('addExpenseModal');
    if (event.target === modal) {
        closeAddExpenseModal();
    }
}

// Delete Expense Function
function deleteExpense(expenseId) {
    if (confirm('Are you sure you want to delete this expense?')) {
        showLoading();
        
        // Create form and submit
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'expense';
        form.style.display = 'none';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete';
        
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'expenseId';
        idInput.value = expenseId;
        
        form.appendChild(actionInput);
        form.appendChild(idInput);
        document.body.appendChild(form);
        form.submit();
    }
}

// Show Loading Animation
function showLoading() {
    const buttons = document.querySelectorAll('button[type="submit"]');
    buttons.forEach(button => {
        button.innerHTML = '<span class="loading"></span> Processing...';
        button.disabled = true;
    });
}

// Form Validation
function validateExpenseForm() {
    const form = document.querySelector('#addExpenseModal form');
    const inputs = form.querySelectorAll('input[required], select[required]');
    let isValid = true;
    
    inputs.forEach(input => {
        if (!input.value.trim()) {
            input.style.borderColor = '#e74c3c';
            isValid = false;
        } else {
            input.style.borderColor = '#e1e5e9';
        }
    });
    
    return isValid;
}

// Number Formatting
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-IN', {
        style: 'currency',
        currency: 'INR'
    }).format(amount);
}

// Date Formatting
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-IN', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
}

// Initialize UI Components
function initializeUI() {
    // Add smooth scrolling to navigation links
    const navLinks = document.querySelectorAll('.nav-menu a');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            if (this.getAttribute('href').startsWith('#')) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth' });
                }
            }
        });
    });
    
    // Add real-time form validation
    const inputs = document.querySelectorAll('input, select, textarea');
    inputs.forEach(input => {
        input.addEventListener('blur', function() {
            validateField(this);
        });
        
        input.addEventListener('input', function() {
            if (this.type === 'number' && this.value < 0) {
                this.value = 0;
            }
        });
    });
    
    // Auto-hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            setTimeout(() => {
                alert.remove();
            }, 300);
        }, 5000);
    });
}

// Validate Individual Field
function validateField(field) {
    const value = field.value.trim();
    let isValid = true;
    
    // Required field validation
    if (field.required && !value) {
        showFieldError(field, 'This field is required');
        isValid = false;
    }
    // Email validation
    else if (field.type === 'email' && value && !isValidEmail(value)) {
        showFieldError(field, 'Please enter a valid email address');
        isValid = false;
    }
    // Number validation
    else if (field.type === 'number' && value && (isNaN(value) || parseFloat(value) < 0)) {
        showFieldError(field, 'Please enter a valid positive number');
        isValid = false;
    }
    // Date validation
    else if (field.type === 'date' && value && new Date(value) > new Date()) {
        showFieldError(field, 'Date cannot be in the future');
        isValid = false;
    }
    else {
        clearFieldError(field);
    }
    
    return isValid;
}

// Show Field Error
function showFieldError(field, message) {
    clearFieldError(field);
    
    field.style.borderColor = '#e74c3c';
    
    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.style.color = '#e74c3c';
    errorDiv.style.fontSize = '12px';
    errorDiv.style.marginTop = '5px';
    errorDiv.textContent = message;
    
    field.parentNode.appendChild(errorDiv);
}

// Clear Field Error
function clearFieldError(field) {
    field.style.borderColor = '#e1e5e9';
    
    const errorDiv = field.parentNode.querySelector('.field-error');
    if (errorDiv) {
        errorDiv.remove();
    }
}

// Email Validation
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Search and Filter Functions
function searchExpenses(searchTerm) {
    const expenseCards = document.querySelectorAll('.expense-card');
    
    expenseCards.forEach(card => {
        const expenseName = card.querySelector('.expense-info h4').textContent.toLowerCase();
        const category = card.querySelector('.expense-info .category').textContent.toLowerCase();
        
        if (expenseName.includes(searchTerm.toLowerCase()) || 
            category.includes(searchTerm.toLowerCase())) {
            card.style.display = 'flex';
        } else {
            card.style.display = 'none';
        }
    });
}

function filterByCategory(category) {
    const expenseCards = document.querySelectorAll('.expense-card');
    
    expenseCards.forEach(card => {
        const cardCategory = card.querySelector('.expense-info .category').textContent.toLowerCase();
        
        if (category === 'all' || cardCategory === category.toLowerCase()) {
            card.style.display = 'flex';
        } else {
            card.style.display = 'none';
        }
    });
}

// Statistics Update
function updateStatistics() {
    const expenseCards = document.querySelectorAll('.expense-card:not([style*="display: none"])');
    let total = 0;
    let count = expenseCards.length;
    
    expenseCards.forEach(card => {
        const amountText = card.querySelector('.expense-amount').textContent;
        const amount = parseFloat(amountText.replace('₹', '').replace(',', ''));
        total += amount;
    });
    
    const average = count > 0 ? total / count : 0;
    
    // Update stat cards if they exist
    const statCards = document.querySelectorAll('.stat-card .value');
    if (statCards.length >= 3) {
        statCards[0].textContent = formatCurrency(total);
        statCards[1].textContent = count;
        statCards[2].textContent = formatCurrency(average);
    }
}

// Keyboard Shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + N to add new expense
    if ((e.ctrlKey || e.metaKey) && e.key === 'n') {
        e.preventDefault();
        openAddExpenseModal();
    }
    
    // Escape to close modal
    if (e.key === 'Escape') {
        closeAddExpenseModal();
    }
});

// Touch/Swipe Support for Mobile
let touchStartX = 0;
let touchStartY = 0;

document.addEventListener('touchstart', function(e) {
    touchStartX = e.touches[0].clientX;
    touchStartY = e.touches[0].clientY;
});

document.addEventListener('touchend', function(e) {
    const touchEndX = e.changedTouches[0].clientX;
    const touchEndY = e.changedTouches[0].clientY;
    
    const deltaX = touchEndX - touchStartX;
    const deltaY = touchEndY - touchStartY;
    
    // Horizontal swipe (more than 50px)
    if (Math.abs(deltaX) > Math.abs(deltaY) && Math.abs(deltaX) > 50) {
        if (deltaX > 0) {
            // Swipe right
            console.log('Swipe right detected');
        } else {
            // Swipe left
            console.log('Swipe left detected');
        }
    }
});

// Progressive Web App Support
if ('serviceWorker' in navigator) {
    window.addEventListener('load', function() {
        navigator.serviceWorker.register('/sw.js')
        .then(function(registration) {
            console.log('ServiceWorker registration successful');
        })
        .catch(function(err) {
            console.log('ServiceWorker registration failed');
        });
    });
}

// Export functions for global use
window.openAddExpenseModal = openAddExpenseModal;
window.closeAddExpenseModal = closeAddExpenseModal;
window.deleteExpense = deleteExpense;
window.searchExpenses = searchExpenses;
window.filterByCategory = filterByCategory; 