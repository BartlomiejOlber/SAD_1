download_data_since_2001 <- function(data_dir = "data"){
  dir.create(data_dir, showWarnings = TRUE)
  for (year in 2001:2023) {
    for (month in 1:9){
      url = sprintf("https://danepubliczne.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/klimat/%s/%s_0%s_k.zip", year, year, month)
      fpath = sprintf("%s/%s_0%s_k.zip", data_dir, year, month)
      fpath_redundant = sprintf("%s/k_d_t_0%s_%s.csv", data_dir, month, year)
      if (!file.exists(fpath))
        try(download.file(url, fpath), silent=TRUE)
      unzip(fpath, exdir=data_dir)
      file.remove(fpath)
      file.remove(fpath_redundant)
    }

		for (month in 10:12){
      url = sprintf("https://danepubliczne.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/klimat/%s/%s_%s_k.zip", year, year, month)
      fpath = sprintf("%s/%s_0%s_k.zip", data_dir, year, month)
      fpath_redundant = sprintf("%s/k_d_t_%s_%s.csv", data_dir, month, year)
      if (!file.exists(fpath))
        try(download.file(url, fpath), silent=TRUE)
      unzip(fpath, exdir=data_dir)
      file.remove(fpath)
      file.remove(fpath_redundant)
    }
  } 
}

download_data_until_2001 <- function(data_dir = "data"){
  dir.create(data_dir, showWarnings = TRUE)
  for (year in seq(1951, 1996, 5)) {
    for (year2 in 0:4){
      url = sprintf("https://danepubliczne.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/klimat/%s_%s/%s_k.zip", year, year + 4, year + year2)
      fpath = sprintf("%s/%s_k.zip", data_dir, year + year2)
      fpath_redundant = sprintf("%s/k_d_t_%s.csv", data_dir, year + year2)
      if (!file.exists(fpath))
        download.file(url, fpath)
      unzip(fpath, exdir=data_dir)
      file.remove(fpath)
      file.remove(fpath_redundant)
    }
  } 
}

load_csv_files <- function(data_dir = "data"){
  file_names <- dir(data_dir, full.names = TRUE)
  df <- do.call(rbind,lapply(file_names,read.csv, header=FALSE, fileEncoding="latin1"))
  drop_cols = c("dummy1", "dummy2", "dummy3", "dummy4", "dummy5", "dummy6", "dummy7")
  names(df) <- c('location_id','location_name','year', 'month', 'day', 'max_t', 'max_t_status', 'min_t', 'min_t_status', 'avg_t', 'avg_t_status', 'dummy1', 'dummy2', 'dummy3', 'dummy4', 'dummy5', 'dummy6', 'dummy7')
  df = df[ , !(names(df) %in% drop_cols)]
  return(df)
}

zad_2 <- function(){
	download_data_since_2001("zadanie_2a")
	dfa <- load_csv_files("zadanie_2a")
	dfa <- dfa[dfa$location_name == "PORONIN",]
	download_data_until_2001("zadanie_2b")
	dfb <- load_csv_files("zadanie_2b")
	dfb <- dfb[dfb$location_name == "PORONIN",]
	df <- rbind(dfb, dfa)
	return(df[order(df$year, df$month, df$day),])
}

df <- zad_2()
jpeg(file="zad_2_wszystkie_dni.jpeg")
plot(1:nrow(df), df$avg_t, type="l", ann=FALSE)
dev.off()

avg_year_temp <- c()
for(i in 1991:2023){
	avg_year_temp <- c(avg_year_temp, mean(df[df$year == i,]$avg_t))
}
jpeg(file="zad_2_srednia_lata.jpeg")
plot(1:length(avg_year_temp), avg_year_temp, type="l", ann=FALSE)
dev.off()

#avg_month_change_temp <- c()
#for(i in 1992:2022){
#	for(j in 1:12){
#		mean_1 <- mean(df[df$year == i && df$month == j,]$avg_t)
#		mean_2 <- mean(df[df$year == i-1 && df$month == j,]$avg_t)
#		avg_month_change_temp <- c(avg_month_change_temp, mean_1 - mean_2)
#	}
#}
#jpeg(file="zad_2_srednia_miesiace_zmiana.jpeg")
#plot(1:length(avg_month_change_temp), avg_month_change_temp, type="l", ann=FALSE)
#dev.off()
