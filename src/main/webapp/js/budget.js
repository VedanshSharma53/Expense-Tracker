// Budget Management JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Set today's date as default start date
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    
    if (startDateInput) {
        startDateInput.valueAsDate = new Date();
    }
    
    // Initialize form validation
    initializeFormValidation();
});

// Modal Functions
function openAddBudgetModal() {
    const modal = document.getElementById('addBudgetModal');
    if (modal) {
        modal.style.display = 'block';
        document.body.style.overflow = 'hidden';
    }
}

function closeAddBudgetModal() {
    const modal = document.getElementById('addBudgetModal');
    if (modal) {
        modal.style.display = 'none';
        document.body.style.overflow = 'auto';
        
        // Reset form
        const form = modal.querySelector('form');
        if (form) {
            form.reset();
            document.getElementById('startDate').valueAsDate = new Date();
        }
    }
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('addBudgetModal');
    if (event.target === modal) {
        closeAddBudgetModal();
    }
}

// Update date range based on period selection
function updateDateRange() {
    const period = document.getElementById('period').value;
    const startDate = document.getElementById('startDate');
    const endDate = document.getElementById('endDate');
    
    if (!period || period === 'CUSTOM') {
        return;
    }
    
    const today = new Date();
    let start = new Date(today);
    let end = new Date(today);
    
    switch (period) {
        case 'WEEKLY':
            // Set to start of current week (Monday)
            const dayOfWeek = today.getDay();
            const daysToMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
            start.setDate(today.getDate() - daysToMonday);
            end.setDate(start.getDate() + 6);
            break;
            
        case 'MONTHLY':
            // Set to start of current month
            start.setDate(1);
            end.setMonth(start.getMonth() + 1);
            end.setDate(0); // Last day of current month
            break;
            
        case 'YEARLY':
            // Set to start of current year
            start.setMonth(0, 1);
            end.setMonth(11, 31);
            break;
    }
    
    startDate.valueAsDate = start;
    endDate.valueAsDate = end;
}

// Delete Budget Function
function deleteBudget(budgetId) {
    if (confirm('Are you sure you want to delete this budget? This action cannot be undone.')) {
        showLoading();
        
        // Create form and submit
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'budget';
        form.style.display = 'none';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete';
        
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'budgetId';
        idInput.value = budgetId;
        
        form.appendChild(actionInput);
        form.appendChild(idInput);
        document.body.appendChild(form);
        form.submit();
    }
}

// Edit Budget Function (placeholder for future implementation)
function editBudget(budgetId) {
    alert('Edit functionality will be implemented soon. Budget ID: ' + budgetId);
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
function initializeFormValidation() {
    const form = document.querySelector('#addBudgetModal form');
    if (!form) return;
    
    const inputs = form.querySelectorAll('input, select');
    
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
    
    // Custom validation for date range
    const startDate = document.getElementById('startDate');
    const endDate = document.getElementById('endDate');
    
    if (startDate && endDate) {
        startDate.addEventListener('change', validateDateRange);
        endDate.addEventListener('change', validateDateRange);
    }
}

// Validate Date Range
function validateDateRange() {
    const startDate = document.getElementById('startDate');
    const endDate = document.getElementById('endDate');
    
    if (!startDate.value || !endDate.value) return;
    
    const start = new Date(startDate.value);
    const end = new Date(endDate.value);
    
    if (start >= end) {
        showFieldError(endDate, 'End date must be after start date');
        return false;
    } else {
        clearFieldError(endDate);
        return true;
    }
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
    // Number validation
    else if (field.type === 'number' && value && (isNaN(value) || parseFloat(value) <= 0)) {
        showFieldError(field, 'Please enter a valid positive number');
        isValid = false;
    }
    // Date validation
    else if (field.type === 'date' && value && new Date(value) < new Date().setHours(0,0,0,0)) {
        showFieldError(field, 'Date cannot be in the past');
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

// Budget Progress Animation
function animateBudgetProgress() {
    const progressBars = document.querySelectorAll('.progress-fill');
    
    progressBars.forEach((bar, index) => {
        const width = bar.style.width;
        bar.style.width = '0%';
        
        setTimeout(() => {
            bar.style.transition = 'width 1s ease-in-out';
            bar.style.width = width;
        }, index * 200);
    });
}

// Check for budget alerts
function checkBudgetAlerts() {
    const budgetCards = document.querySelectorAll('.budget-card');
    let alertCount = 0;
    
    budgetCards.forEach(card => {
        const statusIcon = card.querySelector('.budget-status i');
        const progressFill = card.querySelector('.progress-fill');
        
        if (statusIcon && statusIcon.classList.contains('fa-exclamation-triangle')) {
            alertCount++;
        }
    });
    
    if (alertCount > 0) {
        showBudgetAlert(alertCount);
    }
}

// Show budget alert notification
function showBudgetAlert(count) {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'budget-alert';
    alertDiv.innerHTML = `
        <div class="alert-content">
            <i class="fas fa-exclamation-triangle"></i>
            <span>You have ${count} budget(s) that are over 90% used!</span>
            <button onclick="this.parentElement.parentElement.remove()">×</button>
        </div>
    `;
    
    alertDiv.style.cssText = `
        position: fixed;
        top: 80px;
        right: 20px;
        background: #ff6b6b;
        color: white;
        padding: 15px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        z-index: 1001;
        animation: slideIn 0.3s ease;
    `;
    
    document.body.appendChild(alertDiv);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (alertDiv.parentElement) {
            alertDiv.remove();
        }
    }, 5000);
}

// Keyboard Shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + B to create new budget
    if ((e.ctrlKey || e.metaKey) && e.key === 'b') {
        e.preventDefault();
        openAddBudgetModal();
    }
    
    // Escape to close modal
    if (e.key === 'Escape') {
        closeAddBudgetModal();
    }
});

// Initialize animations on page load
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(() => {
        animateBudgetProgress();
        checkBudgetAlerts();
    }, 500);
});

// Export functions for global use
window.openAddBudgetModal = openAddBudgetModal;
window.closeAddBudgetModal = closeAddBudgetModal;
window.updateDateRange = updateDateRange;
window.deleteBudget = deleteBudget;
window.editBudget = editBudget; 