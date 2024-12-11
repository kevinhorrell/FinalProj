library(tidyverse)

named_stars <- read_csv("named_stars.csv")
constellations <- read_csv("constellations.csv")
load('stars.RData')

merge_stars <- named_stars %>%
  inner_join(constellations, by = 'const_abr') %>%
  rename(bv = 'B-V(Color Index)',
         ub = 'U-B (Color Index)',
         d_ly = 'Distance (ly)',
         zod_sect = 'Zodiac Sector',
         vmag_m = 'Vmag',
         spect_full = 'Sp Type') %>%
  mutate(temp_K = (4600*((1/(0.92*(bv)+1.7) + 1/(0.92*(bv)+0.62)))),
         spectral_class = str_sub(spect_full, 1, 1))

HRstar <- merge_stars %>%
  mutate(d_ps = d_ly/3.2616) %>%
  mutate(absmag_M = vmag_m-(5*(log10(d_ps)-1)))

HRstar <- HRstar %>%
  select(-c(bv, ub, const_abr, bright_star, d_ps))

write_csv(HRstar, "HRDiagram.csv")

star_range <- stars_clean %>%
  group_by(star_type) %>%
  mutate(min_t = min(temp_K),
         max_t = max(temp_K))
  
