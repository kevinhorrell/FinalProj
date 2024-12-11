packageLoad <-
  function(x) {
    for (i in 1:length(x)) {
      if (!x[i] %in% installed.packages()) {
        install.packages(x[i])
      }
      library(x[i], character.only=TRUE)
    }
  }

#create a string of package names
packages <- c('tidyverse',
              'rmarkdown',
              'ggthemes',
              'RColorBrewer',
              'viridis',
              'lterdatasampler',
              'rstatix',
              'plotly',
              'lubridate',
              'dataRetrieval',
              'httr',
              'jsonlite')

# use the packageLoad function we created on those packages
packageLoad(packages)
packageLoad <-
  function(x) {
    for (i in 1:length(x)) {
      if (!x[i] %in% installed.packages()) {
        install.packages(x[i])
      }
      library(x[i], character.only = TRUE)
    }
  }
# create a string of package names
packages <- c('tidyverse',
              'palmerpenguins',
              'rmarkdown',
              'ggthemes',
              'RColorBrewer',
              'viridis',
              'lterdatasampler',
              'rstatix',
              'plotly',
              'lubridate',
              'dataRetrieval',
              'httr',
              'jsonlite')
# use the packageLoad function we created on those packages
packageLoad(packages)
packageLoad(packages)
