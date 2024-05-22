# Setting up the environment
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("readxl")
install.packages("openxlsx")

library(tidyverse)
library(ggplot2)
library(readxl)
library(openxlsx)

# Set the file paths to the Excel files
excel_file_path_01 <- "path/to/your_budget_file.xlsx"
excel_file_path_02 <- "path/to/your_actual_costs_file.xlsx"

# Load the Excel files into data frames
budget_data <- read_excel(excel_file_path_01)
actual_costs_data <- read_excel(excel_file_path_02)

# Summarize the actual costs data
actual_costs_summary <- actual_costs_data %>%
  group_by(ProjectID, Status) %>%
  summarize(Total_Cost = sum(Cost, na.rm = TRUE))

# Merge summarized data with the budget data
comparison_df <- budget_data %>%
  left_join(actual_costs_summary, by = "ProjectID")

# Create a unique data frame for Budget values
budget_unique <- budget_data %>%
  select(ProjectID, Description, Budget) %>%
  distinct()

# Convert Description to a factor
budget_unique$Description <- factor(budget_unique$Description)
comparison_df$Description <- factor(comparison_df$Description)

# Plot the data
ggplot() +
  # Background bars for unique Budget
  geom_col(data = budget_unique, aes(x = Description, y = Budget), fill = "lightgray", width = 0.8, position = "stack") +
  # Overlapping bars for Total_Cost categorized by Status
  geom_col(data = comparison_df, aes(x = Description, y = Total_Cost, fill = Status), width = 0.5, position = "stack") +
  # Rotate X axis labels 45 degrees
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  labs(
    title = "Comparison of Budget and Actual Costs by Status",
    x = "Description",
    y = "Amount",
    fill = "Status"
  ) +
  scale_fill_manual(values = c(
    "Status1" = "lightgreen",
    "Status2" = "red",
    "Status3" = "green",
    "Status4" = "blue",
    "Status5" = "pink",
    "NA" = "grey"
  )) +
  theme_minimal()

# Save the comparison_df to an Excel file
output_file_path <- "path/to/comparison_df.xlsx"
write.xlsx(comparison_df, output_file_path, rowNames = FALSE)

# Print a message confirming the file creation
cat("Excel file saved successfully:", output_file_path, "\n")


# Print a message confirming the file creation
cat("Excel file saved successfully:", excel_file_path, "\n")
