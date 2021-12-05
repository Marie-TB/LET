# Librerías ---------------------------------------------------------------

library(tidyverse)
library(gt)
library(utils)


# Tabla dataset -----------------------------------------------------------
Variable <- c("authors:", "bestsellers-rank:", "categories:", "description:",
            "dimension-x:", "dimension-y:", "dimension-z:", "edition:",
            "edition-statement:", "for-ages:", "format:", "id:", 
            "illustrations-note:", "image-checksum:", "image-path:", 
            "image-url:", "imprint:", "index-date:", "isbn10:", "isbn13:",
            "lang:", "publication-date:", "publication-place:", "rating-avg:",
            "rating-count:", "title:", "url:", "weight:")

Contenido <- c("ID-Autor(es) (lista de str)", "ID-Ranking de los artículos más vendidos (int)",
               "ID-Categorías. (lista de str)", "Descripción (str)",
               "Dimensión X (float en cm)", "Dimensión Y (float en cm)",
               "Dimensión Z (float en cm)", "Edición (str)",
               "Declaración de edición (str)", "Rango de edades (str)",
               "ID-Formato. (int)", "Identificador único (int)",
               "Sin información registrada","Suma de comprobación de la imagen de portada",
               "Ruta del archivo de la imagen de portada", "URL de la imagen de portada",
               "No hay información registrada", "Fecha de rastreo (date)",
               "ISBN-10 (str)", "ISBN-13 (str)", "Idioma del artículo de la página",
               "Fecha de publicación (date)", "ID-Lugar de publicación (int)",
               "Calificación promedio 0-5", "Número de calificaciones", "Título del libro (str)",
               "URL relativa ( https://bookdepository.com + url)", "Peso (en kg)")

Resumen_Dataset <- as.data.frame(cbind(Variable, Contenido))
is.data.frame(`Resumen_Dataset`)

write_csv(
  Resumen_Dataset,
  "Datos/Resumen Dataset.csv",
  na = "NA",
  append = FALSE,
  eol = "\n" )


##Autores
Variable <- c("author_id:", "author_name:")
Contenido <- c("ID-Autor (int)", "Nombre del autor correspondiente al ID (str)")
Resumen_Autores <- as.data.frame(cbind(Variable, Contenido))
is.data.frame(`Resumen_Autores`)
write_csv(
  Resumen_Autores,
  "Datos/Resumen Autores.csv",
  na = "NA",
  append = FALSE,
  eol = "\n" )

##Categorías
Variable <- c("category_id:", "category_name:")
Contenido <- c("ID-Categoría (int)", "Nombre de la categoría correspondiente al ID (str)")
Resumen_Categorias <- as.data.frame(cbind(Variable, Contenido))
is.data.frame(`Resumen_Categorias`)
write_csv(
  Resumen_Categorias,
  "Datos/Resumen Categorias.csv",
  na = "NA",
  append = FALSE,
  eol = "\n" )

##Formatos
Variable <- c("format_id:", "format_name:")
Contenido <- c("ID-Formato (int)", "Nombre del formato correspondiente al ID (str)")
Resumen_Formatos <- as.data.frame(cbind(Variable, Contenido))
is.data.frame(`Resumen_Formatos`)
write_csv(
  Resumen_Formatos,
  "Datos/Resumen Formatos.csv",
  na = "NA",
  append = FALSE,
  eol = "\n" )

##Places
Variable <- c("place_id:", "place_name:")
Contenido <- c("Sin información", "Sin información")
Resumen_Places <- as.data.frame(cbind(Variable, Contenido))
is.data.frame(`Resumen_Places`)
write_csv(
  Resumen_Places,
  "Datos/Resumen Places.csv",
  na = "NA",
  append = FALSE,
  eol = "\n" )

##Datos Finales
Variable <- c("authors:", "bestsellers_rank:", "categories", "format", "id",
              "lang", "rating_avg", "title")
Contenido <- c("ID-Autor(es) (lista de str)", "ID-Ranking de los artículos más vendidos (int)",
               "ID-Categorías. (lista de str)", "ID-Formato. (int)", "Identificador único (int)",
               "Idioma del artículo", "Calificación promedio 0-5", "Título del libro (str)")
Resumen_Datos_Finales <- as.data.frame(cbind(Variable, Contenido))
is.data.frame(`Resumen_Datos_Finales`)
write_csv(
  Resumen_Datos_Finales,
  "Datos/Resumen Datos Finales.csv",
  na = "NA",
  append = FALSE,
  eol = "\n" )

