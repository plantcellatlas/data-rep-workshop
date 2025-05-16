library(tidyverse)

manifest_tabs <- readxl::excel_sheets("docs/pca_datarepro_manifest.xlsx") %>% 
  setdiff(c("README", "HiddenDropdowns", "person", "data_availability_checklist", "downstream_processing", "analysis_derived_data"))

manifest <- map(manifest_tabs, function(tab) {
  data <- readxl::read_excel("docs/pca_datarepro_manifest.xlsx", sheet = tab)
  data <- data[4:dim(data)[1],]
  n_rows <- nrow(data)
  n_na <- colSums(is.na(data))
  cols_with_content <- names(n_na[n_na < n_rows])
  data <- data[,cols_with_content]
  if("lib_prep_id" %in% colnames(data)) {
    data <- dplyr::rename(data, library_prep_id = lib_prep_id)
  }
  return(data)
})
