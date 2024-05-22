# Budget vs. Actual Costs Comparison

This repository contains an R script for comparing budgeted costs and actual costs from two different Excel files. The script performs data processing and visualization using ggplot2.

## Files

- `comparison_script.R`: The R script for data processing and visualization.
- `your_budget_file.xlsx`: Excel file containing budget data.
- `your_actual_costs_file.xlsx`: Excel file containing actual costs data.

## Excel Files Format

### your_budget_file.xlsx

This file should contain the following columns:
- `Budgetary item ID`: Unique identifier for each budgetary item.
- `Short description`: Brief description of the budgetary item.
- `Budget ($)`: Budgeted amount for the item.

### your_actual_costs_file.xlsx

This file should contain the following columns:
- `Budgetary item ID`: Unique identifier for each budgetary item (should match the IDs in the budget file).
- `Budgetary item_imputed cost ID`: Unique identifier for each imputed cost.
- `Cost ($)`: Actual cost incurred.
- `Status`: Status of the cost. The possible statuses are:
  - `1 = booked`
  - `2 = in progress`
  - `3 = free to book`
  - `4 = rejected`
  - `5 = NA`

## Usage

1. Clone the repository or download the files.
2. Ensure you have the necessary R packages installed (`tidyverse`, `ggplot2`, `readxl`, `openxlsx`).
3. Update the file paths in `comparison_script.R` to point to your local Excel files.
4. Run the `comparison_script.R` script to generate the comparison plot and save the results to an Excel file.

## Example

```r
# Load necessary libraries
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

# Process and visualize the data
source("comparison_script.R")
