source('setup.R')

stars <- read_csv("6 class csv.csv")
unique(stars$star_color)

stars_clean <- stars %>%
  mutate(star_color = gsub("([A-Za-z])\\s([A-Za-z])", "\\1-\\2", star_color)) %>%
  mutate(star_color = str_trim(star_color)) %>%
  mutate(star_color = tolower(star_color))

stars_clean <- stars_clean %>%
  rename(star_class = "star_type") %>%
  mutate(star_type = if_else(star_class == 0, "Brown Dwarf",
                             if_else(star_class == 1, "Red Dwarf",
                                     if_else(star_class == 2, "White Dwarf",
                                             if_else(star_class == 3, "Main Sequence",
                                                     if_else(star_class ==4, "Supergiant",
                                                             if_else(star_class == 5, "Hypergiant", "NA")))))))


colors <- c('#0000ff', '#add8e6', '#ffa500', '#ff4500', '#ffd7ae', '#ff0000', '#ffffff', '#fffdd0', '#fcf5e5', '#ffffe0','#ffff00', '#ffff9f')

labels <- c('blue', 'blue-white', 'white', 'yellowish-white', 'red', 'pale-yellow-orange', 'whitish', 'yellow-white', 'white-yellow', 'yellowish', 'orange-red', 'orange')



ggplotly(
  ggplot(data = stars_clean) +
  geom_point(aes(x = temp_K, y = absmag_M, fill = star_color, size = radius), shape = 23, alpha = 0.5) +
  scale_fill_manual(labels = labels, values = colors) +
  scale_size_continuous(range = c(2,10)) +
  scale_y_reverse() +
  scale_x_reverse() +
  xlab("Temperature (K)") +
  ylab("Absolute Magnitude") +
  theme_dark()
)


save(stars_clean, colors, labels, file = "stars.RData")

write_csv(stars_clean, "stars_clean.csv")
