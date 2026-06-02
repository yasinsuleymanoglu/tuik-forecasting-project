# ==============================================================================
# SCRIPT: data_import.R (Browser-Masked httr::GET Approach - ANNUAL DATA)
# ==============================================================================

suppressPackageStartupMessages({
  library(tuikr)
  library(httr)
  library(readxl)
  library(dplyr)
})

get_annual_poultry_data <- function() {
  message("Katalog taranıyor...")
  katalog <- tuikr::statistical_tables(theme = "13")
  
  # Hedef tabloyu bul
  hedef_tablo <- katalog[grep("Slaughtered and Production Quantity", katalog$table_name, ignore.case = TRUE), ]
  
  # İlk 'istab' (Excel) linkini al (Yıllık Veri)
  hedef_url <- hedef_tablo$table_url[hedef_tablo$node_type == "istab"][1]
  
  temp_file <- tempfile(fileext = ".xls")
  
  message("Tarayıcı kimliğiyle (User-Agent) veri çekiliyor...")
  
  # ÇÖZÜM: Gerçek bir tarayıcı gibi davranıyoruz
  response <- httr::GET(
    url = hedef_url,
    add_headers(`User-Agent` = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"),
    write_disk(temp_file, overwrite = TRUE)
  )
  
  if(status_code(response) != 200) stop("Sunucu erişimi reddetti! (HTTP 401/403)")
  
  raw_excel <- suppressMessages(readxl::read_excel(temp_file, col_names = FALSE))
  
  # Yıllık veri ayrıştırma
  # Tablodaki "Yıl" veya "Year" geçen ilk satırı bul
  start_row <- which(apply(raw_excel, 1, function(x) any(grepl("Yıl|Year", x, ignore.case = TRUE))), arr.ind = TRUE)[1] + 1
  
  # 1. sütun Yıl, 3. sütun Tavuk Eti Üretimi (Ton)
  clean_data <- raw_excel[start_row:nrow(raw_excel), c(1, 3)]
  colnames(clean_data) <- c("Year", "Production")
  
  clean_data <- clean_data %>% 
    filter(!is.na(Year), !is.na(Production)) %>%
    mutate(Year = as.numeric(Year), Production = as.numeric(Production))
  
  # Frekans = 1 (Yıllık)
  poultry_ts <- ts(clean_data$Production, start = min(clean_data$Year), frequency = 1)
  
  message(sprintf("Yıllık veri başarıyla yüklendi! Başlangıç yılı: %d", min(clean_data$Year)))
  return(poultry_ts)
}

poultry_ts <- get_annual_poultry_data()
message("Veri başarıyla yüklendi!")