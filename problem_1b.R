download_data <- function(data_dir = "data"){
  dir.create(data_dir, showWarnings = TRUE)
  for (year in 2022:2023) {
    for (month in 1:2){
      url = sprintf("https://danepubliczne.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/klimat/%s/%s_0%s_k.zip", year, year, month)
      fpath = sprintf("%s/%s_0%s_k.zip", data_dir, year, month)
      fpath_redundant = sprintf("%s/k_d_t_0%s_%s.csv", data_dir, month, year)
      if (!file.exists(fpath))
        try(download.file(url, fpath), silent=TRUE)
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

load_data <- function(){
	download_data("zadanie_1b")
	df <- load_csv_files("zadanie_1b")
	return(df)
}

zad_1b <- function(){
	df <- load_data()
  df <- df[df$location_name == "BABIMOST",]
	df22 <- df[df$year == 2022,]
	df22 <- df22[order(df22$month, df22$day),]
	df23 <- df[df$year == 2023,]
	df23 <- df23[order(df23$month, df23$day),]
	change_temp <- c()
	for(i in 2:nrow(df22)){
		change_temp <- c(change_temp, df22[i,10]-df22[i-1,10])
	}
	for(i in 2:nrow(df23)){
		change_temp <- c(change_temp, df23[i,10]-df23[i-1,10])
	}
	return(change_temp)
}

temp <- zad_1b()
jpeg(file="zad_1b_hist_babimost.jpeg")
temp_hist = hist(temp, xlim=c(-10, 10), ylim=c(0, 50), col="darkgreen", ann=FALSE)
title("Histogram różnic temperatury z dobę na dobę w BABIMOST")
dev.off()

mean_temp <- mean(temp)
sd_temp <- sd(temp)
x <- seq(-10, 10, by=0.1)
jpeg(file="zad_1b_plot_norm_babimost.jpeg")
plot(x, dnorm(x, mean=mean_temp, sd=sd_temp), xlim=c(-10, 10), ylim=c(0, 0.2), type="l", ann=FALSE)
title(paste("Funkcja gęstości rozkładu N (", mean_temp, ",", sd_temp, ")"))
dev.off()

jpeg(file="zad_1b_plot_babimost.jpeg")
plot(x, dnorm(x, mean=mean_temp, sd=sd_temp), xlim=c(-10, 10), ylim=c(0, 0.2), type="l", ann=FALSE)
points(temp_hist$mids, temp_hist$density, col="red", ann=FALSE)
title(paste("Funkcja gęstości rozkładu N (", mean_temp, ",", sd_temp, ")"))
dev.off()

print(paste("Wartość oczekiwana:", mean_temp))
print(paste("Prawdopodobieństwo dla (-1; 1):", pnorm(1, mean=mean_temp, sd=sd_temp) - pnorm(-1, mean=mean_temp, sd=sd_temp)))
print(paste("Prawdopodobieństwo dla (-2; 2):",pnorm(2, mean=mean_temp, sd=sd_temp) - pnorm(-2, mean=mean_temp, sd=sd_temp)))
print(paste("Prawdopodobieństwo dla (-3; 3):",pnorm(3, mean=mean_temp, sd=sd_temp) - pnorm(-3, mean=mean_temp, sd=sd_temp)))
print(paste("Prawdopodobieństwo dla (-4; 4):",pnorm(4, mean=mean_temp, sd=sd_temp) - pnorm(-4, mean=mean_temp, sd=sd_temp)))


