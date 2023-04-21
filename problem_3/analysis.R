library(ggplot2)

read_binary_integers <- function(filepath = "problem_3/count.bin"){
  file <- file(filepath, "rb")
  bytes_per_int = 4
  fsize = file.size(filepath)
  n = fsize / bytes_per_int
  integers <- readBin(file, "integer", size=NA_integer_, endian="big", n=n)
  close(file)
  return(integers)
}

impulses_per_ten_microseconds = read_binary_integers()
df_counts <- as.data.frame(impulses_per_ten_microseconds) 
ggplot(df_counts, aes(x=1:nrow(df_counts), y=impulses_per_ten_microseconds)) +
  geom_point() + labs(x = "Kolejne chwile", y = "Liczba impulsów w 1/100 sekundy") +
  theme(aspect.ratio=1/1)
ggsave("impulses.png")

distances_between_impulses = read_binary_integers('problem_3/distances.bin')
df_distances <- as.data.frame(distances_between_impulses) 
ggplot(df_distances, aes(x=1:nrow(df_distances), y=distances_between_impulses)) +
  geom_point() + labs(x = "Kolejne impulsy", y = "Czas impulsu od poprzedniego impulsu (razy 1/50MHz; 20 nanosekund)") 
ggsave("distances.png")

ggplot(df_distances, aes(x=distances_between_impulses)) +
  geom_histogram() + labs(x = "Czas pomiędzy impulsami") 
ggsave("distances_hist.png")

ggplot(df_counts, aes(x=impulses_per_ten_microseconds)) +
  geom_histogram() + labs(x = "Liczba impulsów w 1/100 sekundy") 
ggsave("count_hist.png")

print(mean(df_counts[, 1]))
print(mean(df_distances[, 1]))


ggplot(df_distances, aes(y=distances_between_impulses)) +
  geom_boxplot() + labs(y = "Czas impulsu od poprzedniego impulsu (razy 1/50MHz; 20 nanosekund)") 
ggsave("distances_box.png")