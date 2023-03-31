
download_data_since_2001 <- function(data_dir = "data"){
  dir.create(data_dir, showWarnings = FALSE)
  for (year in 2001:2022) {
    for (month in 1:2){
      url = sprintf("https://danepubliczne.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/klimat/%s/%s_0%s_k.zip", year, year, month)
      fpath = sprintf("%s/%s_0%s_k.zip", data_dir, year, month)
      fpath_redundant = sprintf("%s/k_d_t_0%s_%s.csv", data_dir, month, year)
      if (file.exists(fpath))
        download.file(url, fpath)
      unzip(fpath, exdir=data_dir)
      file.remove(fpath)
      file.remove(fpath_redundant)
    }
  } 
}

download_data_latest <- function(data_dir = "data"){
  dir.create(data_dir, showWarnings = FALSE)
  for (year in 2022:2023) {
    for (month in 1:2){
      url = sprintf("https://danepubliczne.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/klimat/%s/%s_0%s_k.zip", year, year, month)
      fpath = sprintf("%s/%s_0%s_k.zip", data_dir, year, month)
      fpath_redundant = sprintf("%s/k_d_t_0%s_%s.csv", data_dir, month, year)
      if (file.exists(fpath))
        try(download.file(url, fpath), silent=TRUE)
      unzip(fpath, exdir=data_dir)
      file.remove(fpath)
      file.remove(fpath_redundant)
    }
  } 
}

download_data_until_2001 <- function(data_dir = "data"){
  dir.create(data_dir, showWarnings = FALSE)
  for (year in seq(1951, 1996, 5)) {
    for (year2 in 0:4){
      url = sprintf("https://danepubliczne.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/klimat/%s_%s/%s_k.zip", year, year + 4, year + year2)
      fpath = sprintf("%s/%s_k.zip", data_dir, year + year2)
      fpath_redundant = sprintf("%s/k_d_t_%s.csv", data_dir, year + year2)
      if (file.exists(fpath))
        download.file(url, fpath)
      unzip(fpath, exdir=data_dir)
      file.remove(fpath)
      file.remove(fpath_redundant)
    }
  } 
}

load_csv_files <- function(locations, data_dir = "data"){
  file_names <- dir(data_dir, full.names = TRUE)
  print(file_names)
  print(data_dir)
  df <- do.call(rbind,lapply(file_names,read.csv, header=FALSE, fileEncoding="latin1"))
  print(nrow(df))
  drop_cols = c("dummy1", "dummy2", "dummy3", "dummy4", "dummy5", "dummy6", "dummy7")
  names(df) <- c('location_id','location_name','year', 'month', 'day', 'max_t', 'max_t_status', 'min_t', 'min_t_status', 'avg_t', 'avg_t_status', 'dummy1', 'dummy2', 'dummy3', 'dummy4', 'dummy5', 'dummy6', 'dummy7')
  df = df[ , !(names(df) %in% drop_cols)]
  df = df[df$location_name %in% locations,]
  print(nrow(df))
  return(df)
}
  
# download_data_until_2001()
# download_data_since_2001()
# df = load_csv_files()

# df = read.csv("data/k_d_1951.csv", header=FALSE, fileEncoding="latin1")
# names(df) <- c('location_id','location_name','year', 'month', 'day', 'max_t', 'max_t_status', 'min_t', 'min_t_status', 'avg_t', 'avg_t_status', 'dummy1', 'dummy2', 'dummy3', 'dummy4', 'dummy5', 'dummy6', 'dummy7')
# df2 = read.csv("data/k_d_02_2020.csv", header=FALSE, fileEncoding="latin1")
# names(df2) <- c('location_id','location_name','year', 'month', 'day', 'max_t', 'max_t_status', 'min_t', 'min_t_status', 'avg_t', 'avg_t_status', 'dummy1', 'dummy2', 'dummy3', 'dummy4', 'dummy5', 'dummy6', 'dummy7')
# print(intersect(unique(df2[c("location_name")]), unique(df[c("location_name")])))  # czyli można użyć tylko 2001-2022


