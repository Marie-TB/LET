# Librerías ---------------------------------------------------------------

require(tidyverse)
library(readr)
library(dplyr)
library(tidyr)
library(purrr)
library(janitor)
library(stringr)

# Cargar Base de Datos ----------------------------------------------------

datos <- read_csv(here::here("Datos/dataset.csv"))



# Conservar primeros 10.000 en el rank de bestseller y ajuste de nombres ----

datos_finales <- datos  %>% 
  select(authors, `bestsellers-rank`, categories, format, id, lang, `rating-avg`, title) %>% 
  clean_names() %>% 
  filter(bestsellers_rank <= 10000)

write_csv(datos_finales, "Datos/datos_finales.csv")
