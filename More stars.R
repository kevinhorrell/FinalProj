library(tidyverse)
install.packages('ggrepel')
library(ggrepel)


load('stars.RData')

HRstars <- read_csv('HRDiagram.csv')

save(stars_clean, HRstars, colors, labels, file = "app_data.RData")

load('app_data.RData')

HRstars <- HRstars %>%
  filter(!grepl("#VALUE!", radius)) %>%
  filter(!grepl("#VALUE!", luminosity))

HRstars <- HRstars %>%
  mutate(radius = as.numeric(radius)) %>%
  mutate(luminosity = as.numeric(luminosity))

save(stars_clean, HRstars, colors, labels, file = "app_data.RData")


ggplot(HRstars) +
  geom_point(aes(x = temp_K, y = luminosity, fill = star_color, size = radius), shape = 23, alpha = 0.5) +
  scale_fill_manual(values = colors, name = "Star Type") +
  scale_size_continuous(range = c(1, 10)) +
  scale_y_log10() +
  coord_cartesian(
    xlim = c(41000, 1500)) +
  xlab("Temperature (K)") +
  ylab("Luminosity (L/Lsun)") +
  theme_dark() +
  theme(legend.position = "right")



named_stars <- read_csv("named_stars.csv")
named_stars <- named_stars %>%
  rename(bv = 'B-V(Color Index)',
         ub = 'U-B (Color Index)',
         d_ly = 'Distance (ly)',
         zod_sect = 'Zodiac Sector',
         vmag_m = 'Vmag',
         spect_full = 'Sp Type') %>%
  mutate(temp_K = (4600*((1/(0.92*(bv)+1.7) + 1/(0.92*(bv)+0.62)))),
         spectral_class = str_sub(spect_full, 1, 1))
 
  
  
  named_stars <- named_stars %>%
   mutate(star_type = if_else(spectral_class == 'O', 'blue',
         if_else(spectral_class == 'B', 'blue-white',
                 if_else(spectral_class == 'A', 'white',
                         if_else(spectral_class == 'F', 'whitish',
                                 if_else(spectral_class == 'G', 'yellow-white',
                                         if_else(spectral_class == 'K', 'yellow',
                                                 if_else(spectral_class == 'M', 'red', 'unk'))))))))

named_stars <- named_stars %>%
  filter(!grepl("unk", spectral_class)) %>%
  mutate(d_ps = d_ly/3.2616) %>%
  mutate(absmag_M = vmag_m-(5*(log10(d_ps)-1)))

constellations <- read_csv("constellations.csv")

merge_stars <- named_stars %>%
  inner_join(constellations, by = 'const_abr')

write_csv(merge_stars, "named_stars_final.csv")

stars_final <- read_csv('named_stars_final.csv')

stars_final <- stars_final %>%
  filter(!grepl("#VALUE!", radius)) %>%
  filter(!grepl("#VALUE!", luminosity))%>%
  mutate(radius = as.numeric(radius),
         luminosity = as.numeric(luminosity))

stars_final <- stars_final %>%
  filter(!grepl("unk", star_color))


  

#Magnitude Plot
ggplot(stars_final) +
  geom_point(aes(x = temp_K, y = absmag_M, fill = star_color, size = radius), shape = 23, alpha = 0.5) +
  scale_fill_manual(values = colors, name = "Star Type") +
  scale_size_continuous(range = c(1, 10)) +
  coord_cartesian(
    xlim = c(41000, 1500),
    ylim = c(21, -12)) +
  xlab("Temperature (K)") +
  ylab("Absolute Magnitude") +
  theme_black() +
  theme(legend.position = "right")

#Luminosity Plot
ggplot(stars_final) +
  geom_point(aes(x = temp_K, y = luminosity, fill = star_color, size = radius), shape = 23, alpha = 0.5) +
  scale_fill_manual(values = colors, name = "Star Type") +
  scale_size_continuous(range = c(1, 10)) +
  scale_y_log10() +
  coord_cartesian(
    xlim = c(41000, 1500)) +
  xlab("Temperature (K)") +
  ylab("Luminosity (L/Lsun)") +
  theme_dark() +
  theme(legend.position = "right")


colors <- c('#0000ff', '#add8e6', '#ffa500', '#ff4500', '#ffd7ae', '#ff0000', '#ffffff', '#fffdd0', '#fcf5e5', '#ffffe0','#ffff00', '#ffff9f')

labels <- c('blue', 'blue-white', 'white', 'yellowish-white', 'red', 'pale-yellow-orange', 'whitish', 'yellow-white', 'white-yellow', 'yellowish', 'orange-red', 'orange')

save(stars_final, colors, labels, file = "appdata.RData")

#Magnitude 2
ggplot(stars_final) +
  geom_point(aes(x = temp_K, y = absmag_M, fill = star_color, size = radius), shape = 23, alpha = 0.5) +
  scale_fill_manual(values = colors, name = "Star Type") +
  scale_y_reverse() +
  scale_x_reverse() +
  xlab("Temperature (K)") +
  ylab("Absolute Magnitude") +
  theme_dark() +
  theme(legend.position = "right")

#Luminosity 2
ggplot(stars_final) +
  geom_point(aes(x = temp_K, y = luminosity, fill = star_color, size = radius), shape = 23, alpha = 0.5) +
  scale_fill_manual(values = colors, name = "Star Type") +
  scale_y_log10()+
  scale_x_reverse() +
  xlab("Temperature (K)") +
  ylab("Luminosity (L/Lsun)") +
  theme_dark() +
  theme(legend.position = "right")

#Edit star Data again

load("appdata.RData")

stars_final <- stars_final %>%
  mutate(star_type = replace_na(star_type, "unknown"))

save(stars_final, colors, labels, file = "appdata.RData")
write_csv(stars_final, file = "stars_edit.csv")

stars_final <- read_csv("stars_edit.csv")


