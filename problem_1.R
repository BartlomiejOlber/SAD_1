require("ggplot2")
require("dplyr")

library(ggplot2)
library(dplyr)

source("data_utils.R")

# useful for problem 2
# download_data_since_2001()
# locations = c("STUPOSIANY", "BOGATYNIA", "SZCZYTNO")
# df <- load_csv_files(locations)
# print(nrow(df))

download_data_latest("data_latest")
locations_latest = c("BABIMOST", "RADZIECHOWY", "SZEPIETOWO")
df2 <- load_csv_files(locations_latest, data_dir="data_latest")
print(nrow(df2))

# Basic box plot
p <- ggplot(df2, aes(x=location_name, y=max_t), color=location_name) + 
  geom_boxplot() + labs(x = "Miejsc.", y = "Maks. dobowa temp.")

print(p)
ggsave("box_plot.pdf")

df2 %>%
  group_by(location_name) %>%
  summarise(mean=mean(max_t), std=sd(max_t))