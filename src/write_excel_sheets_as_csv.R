library(readxl)
library(readr)

setwd("data-rep-workshop/")

excel_file_path <- "docs/pca_datarepro_manifest.xlsx"

output_dir <- "metadata/"

dir.create(output_dir, showWarnings = FALSE)

sheet_names <- excel_sheets(excel_file_path)

for (sheet in sheet_names) {
  message(paste("Processing sheet:", sheet))
  data_from_sheet <- read_excel(excel_file_path, sheet = sheet)
  csv_file_path <- file.path(output_dir, paste0("sample_metadata_", sheet, ".csv"))
  write_csv(data_from_sheet, csv_file_path)
  message(paste("Successfully saved:", csv_file_path))
}
