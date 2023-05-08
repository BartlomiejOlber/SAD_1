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

zad_2_data <- function(){
  locations = c("NIEDZICA", "PORONIN")
	download_data_since_2001("zadanie_2a")
	dfa <- load_csv_files("zadanie_2a")
	download_data_until_2001("zadanie_2b")
	dfb <- load_csv_files("zadanie_2b")
	df <- rbind(dfb, dfa)
  df = df[df$location_name %in% locations,]
	return(df[order(df$year, df$month, df$day),])
}

df_all <- zad_2_data()
df_niedzica = df_all[df_all$location_name == "NIEDZICA",]
df_poronin = df_all[df_all$location_name == "PORONIN",]

x <- seq(1999, 2019, by = 4)
temp_niedzica <- c()
temp_poronin <- c()
for(i in x){
  temp_niedzica <- c(temp_niedzica, mean(df_niedzica[df_niedzica$year %in% c(i, i+1, i+2, i+3) & df_niedzica$month %in% c(6, 7, 8),]$avg_t))
  temp_poronin <- c(temp_poronin, mean(df_poronin[df_poronin$year %in% c(i, i+1, i+2, i+3) & df_poronin$month %in% c(6, 7, 8),]$avg_t))
}

jpeg(file="zad_2_lato.jpeg")
plot(x, temp_poronin, type="b", col="green", ann=FALSE, xaxt="n", ylim=c(min(c(temp_niedzica, temp_poronin), na.rm = TRUE), max(c(temp_niedzica, temp_poronin), na.rm = TRUE)))
lines(x, temp_niedzica, type="b", col="red")
axis(1, at=x, las=2, labels=c("1999-2002", "2003-2006", "2007-2010", "2011-2014", "2015-2018", "2019-2022"))
legend(x="topleft", legend=c("PORONIN", "NIEDZICA"), fill=c("green", "red"))
title("Średnia temperatura od czerwca do sierpnia")
dev.off()

x <- seq(2000, 2020, by = 4)
temp_niedzica <- c()
temp_poronin <- c()
for(i in x){
  temp_niedzica <- c(temp_niedzica, mean(df_niedzica[df_niedzica$year %in% c(i, i+1, i+2, i+3) & df_niedzica$month %in% c(1, 2),]$avg_t))
  temp_poronin <- c(temp_poronin, mean(df_poronin[df_poronin$year %in% c(i, i+1, i+2, i+3) & df_poronin$month %in% c(1, 2),]$avg_t))
}

jpeg(file="zad_2_zima.jpeg")
plot(x, temp_poronin, type="b", col="green", ann=FALSE, xaxt="n", ylim=c(min(c(temp_niedzica, temp_poronin), na.rm = TRUE), max(c(temp_niedzica, temp_poronin), na.rm = TRUE)))
lines(x, temp_niedzica, type="b", col="red")
axis(1, at=x, las=2, labels=c("2000-2003", "2004-2007", "2008-2011", "2012-2015", "2016-2019", "2020-2023"))
legend(x="topleft", legend=c("PORONIN", "NIEDZICA"), fill=c("green", "red"))
title("Średnia temperatura w styczniu i lutym")
dev.off()
