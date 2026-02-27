#!/usr/bin/env Rscript

library(readxl)
library(tidyverse)

# Get sheet names
excel_file <- "docs/pca_datarepro_manifest.xlsx"
sheet_names <- excel_sheets(excel_file)

print(sheet_names)

# Read and combine all sheets
all_data <- list()

for (sheet_name in sheet_names) {
  cat("\nReading sheet:", sheet_name, "\n")
  df <- read_excel(excel_file, sheet = sheet_name)
  cat("Columns:", paste(colnames(df), collapse=", "), "\n")
  cat("Rows:", nrow(df), "\n")
  all_data[[sheet_name]] <- df
}

# Create output CSV
output_rows <- list()

# Add header
output_rows[[1]] <- c("Sheet", "Column/Term", "Description", "Example")
row_idx <- 2

for (sheet_name in sheet_names) {
  df <- all_data[[sheet_name]]
  
  # Add sheet name as section header
  output_rows[[row_idx]] <- c(sheet_name, "", "", "")
  row_idx <- row_idx + 1
  
  # For each column in the sheet (skip the first one which is usually study_id)
  cols_to_process <- colnames(df)
  if ("study_id" %in% cols_to_process) {
    cols_to_process <- cols_to_process[cols_to_process != "study_id"]
  }
  
  for (col_name in cols_to_process) {
    # Column name is the term
    term <- col_name
    
    # Get description and example from the data rows
    description <- ""
    example <- ""
    
    if (nrow(df) > 0) {
      # First row often contains description
      if (!is.na(df[[1, col_name]])) {
        description <- as.character(df[[1, col_name]])
      }
      
      # Second row often contains example
      if (nrow(df) > 1 && !is.na(df[[2, col_name]])) {
        example <- as.character(df[[2, col_name]])
      }
    }
    
    # Clean up NA values
    term <- ifelse(is.na(term) || term == "NA", "", term)
    description <- ifelse(is.na(description) || description == "NA", "", description)
    example <- ifelse(is.na(example) || example == "NA", "", example)
    
    output_rows[[row_idx]] <- c("", term, description, example)
    row_idx <- row_idx + 1
  }
}

# Convert to data frame and write CSV
output_df <- do.call(rbind, output_rows)
colnames(output_df) <- NULL
write.csv(output_df, "extracted_manifest_terms.csv", row.names = FALSE, quote = TRUE)

cat("\nWritten to: extracted_manifest_terms.csv\n")
