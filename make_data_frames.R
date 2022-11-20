library(tidyverse)
library(openxlsx)
library(here)

data_path <- here("files/baby_names.xlsx")

all_states <- openxlsx::getSheetNames(data_path)

all_names <- lapply(all_states, function(x){
  names_data <- openxlsx::readWorkbook(xlsxFile = data_path,
                                       sheet = x)
  colnames(names_data) <- c(paste0(x, "_rank"),
                            "Male_name",
                            paste0(x, "_number_of_males"),
                            "Female_name",
                            paste0(x, "_number_of_females"))

  return(names_data)
})

names(all_names) <- all_states

boy_names <- lapply(all_names, function(x){
  return(x[ , c(2, 3)])
})

boy_names <- boy_names %>%
  reduce(inner_join, by = "Male_name") %>%
  tibble::column_to_rownames("Male_name")

colnames(boy_names) <- sub("_number_of_males", "", colnames(boy_names))

write.csv(boy_names, here("files/boy_name_counts.csv"))

girl_names <- lapply(all_names, function(x){
  return(x[ , c(4, 5)])
})

girl_names <- girl_names %>%
  reduce(inner_join, by = "Female_name") %>%
  tibble::column_to_rownames("Female_name")

colnames(girl_names) <- sub("_number_of_females", "", colnames(girl_names))

write.csv(girl_names, here("files/girl_name_counts.csv"))

boy_ranks <- lapply(all_names, function(x){
  return(x[ , c(1, 2)])
})

boy_ranks <- boy_ranks %>%
  reduce(inner_join, by = "Male_name") %>%
  tibble::column_to_rownames("Male_name")

write.csv(boy_ranks, here("files/boy_name_ranks.csv"))


girl_ranks <- lapply(all_names, function(x){
  return(x[ , c(1, 4)])
})

girl_ranks <- girl_ranks %>%
  reduce(inner_join, by = "Female_name") %>%
  tibble::column_to_rownames("Female_name")

write.csv(girl_ranks, here("files/girl_name_ranks.csv"))


