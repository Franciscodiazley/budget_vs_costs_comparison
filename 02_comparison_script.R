# Setting up the environment
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("readxl")

library(tidyverse)
library(ggplot2)
library(readxl)

# Set the file paths to the Excel files
excel_file_path_01 <- "C:\\Users\\DiazLeFJ\\OneDrive - BASF\\Desktop\\H4CHEM\\02_AVISOR TEST_2\\01_bestellabruf_leffer.xlsx"
excel_file_path_02 <- "C:\\Users\\DiazLeFJ\\OneDrive - BASF\\Desktop\\H4CHEM\\02_AVISOR TEST_2\\02_ausmassen_alle.xlsx"

# Load the Excel files into data frames
bestellabruf_leffer <- read_excel(excel_file_path_01)
ausmass_leffer <- read_excel(excel_file_path_02)

ausmass_summary <- ausmass_leffer %>%
  group_by(Bestellabruf, Status) %>%
  summarize(Total_Gesamtwert = sum(`Gesamtwert`, na.rm = TRUE))

# Merge summarized data with the first table to compare with Erwarteter Wert
comparison_df <- bestellabruf_leffer %>%
  left_join(ausmass_summary, by = "Bestellabruf")


# Remove specified columns from the comparison data frame using select and the - operator
comparison_df <- comparison_df %>%
  select(-`Freigegeben am`, -`Gesamtlimit`, -`Währung`, -`Gültig bis`, -`Kontrakt-Typ`)

# Create a unique data frame for Erwarteter Wert
erwarteter_wert_unique <- bestellabruf_leffer %>%
  select(Bestellabruf, `Kurztext Bestellabruf`, `Erwarteter Wert`) %>%
  distinct()

# Merge summarized data with the first table to compare with Erwarteter Wert
comparison_df <- bestellabruf_leffer %>%
  left_join(ausmass_summary, by = "Bestellabruf")


# Convert Kurztext Bestellabruf to a factor
erwarteter_wert_unique$`Kurztext Bestellabruf` <- factor(erwarteter_wert_unique$`Kurztext Bestellabruf`)
comparison_df$`Kurztext Bestellabruf` <- factor(comparison_df$`Kurztext Bestellabruf`)

ggplot() +
  # Background bars for unique Erwarteter Wert
  geom_col(data = erwarteter_wert_unique, aes(x = `Kurztext Bestellabruf`, y = `Erwarteter Wert`), fill = "lightgray", width = 0.8, position = "stack") +
  # Overlapping bars for Total_Gesamtwert categorized by Status
  geom_col(data = comparison_df, aes(x = `Kurztext Bestellabruf`, y = Total_Gesamtwert, fill = Status.y), width = 0.5, position = "stack") +
  # Rotate X axis labels 45 degrees
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  labs(
    title = "Comparison of Erwarteter Wert and Gesamtwert by Status",
    x = "Kurztext Bestellabruf",
    y = "Betrag (€)",
    fill = "Status"
  ) +
  scale_fill_manual(values = c(
    "Alt-Transfer" = "lightgreen",
    "Bearbeitung" = "red",
    "Frei techn." = "green",
    "Korrektur v. KT" = "blue",
    "Wiedervorl. v. KT" = "pink",
    "NA" = "grey"
  ))

########
getwd()
# Load the openxlsx library
library(openxlsx)

# Specify the file path where you want to save the Excel file
excel_file_path <- "comparison_df.xlsx"

# Write comparison_df to an Excel file
write.xlsx(comparison_df, excel_file_path, rowNames = FALSE)

# Print a message confirming the file creation
cat("Excel file saved successfully:", excel_file_path, "\n")
