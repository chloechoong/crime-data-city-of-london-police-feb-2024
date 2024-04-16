# Load necessary library (if not already installed)

# Create a contingency table
contingency_table <- table(factor(crime1$`LSOA name` == "City of London 100F", levels = c(TRUE, FALSE)))

# Perform chi-squared test
result <- chisq.test(contingency_table)

# Display the result
print(result)

