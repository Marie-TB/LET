# Cargar Librerías --------------------------------------------------------
library(tidyverse)
library(readr)
library(dplyr)
library(tidyr)
library(purrr)
library(janitor)
library(stringr)
library(ggplot2)
library(gt)
library(forcats)

# Cargar Datos ------------------------------------------------------------

Datos <- read_csv(here::here("Datos/datos_finales.csv"))
Autores <- read_csv(here::here("datos/authors.csv"))
Categorias <- read_csv(here::here("datos/categories.csv"))
Formatos <- read_csv(here::here("datos/formats.csv"))

# cambiar ID formatos -----------------------------------------------------
datos <- Datos %>% 
  left_join(Formatos, by = c("format" = "format_id")) %>% 
  select(-format)
datos$format_name[is.na(datos$format_name)] <- "NA" 

# contar formatos
formatos_crudo <- count(datos, format_name, sort = TRUE)
df_formatos <- as.data.frame(formatos_crudo)


# Cambiar ID autores ------------------------------------------------------

por_autor <- datos %>% 
  separate_rows(authors, sep = ", ") %>% 
  mutate(authors = as.numeric(str_remove_all(authors, "\\[|\\]"))) %>% 
  left_join(Autores, by = c("authors" = "author_id"))
por_autor$author_name[is.na(por_autor$author_name)] <- "NA" 


#contar autores
autores_crudo <- count(por_autor, author_name, sort = TRUE)
df_autores <- as.data.frame(autores_crudo)

# Cambiar ID categorías --------------------------------------------------------------
por_categoria <- datos %>% 
  separate_rows(categories, sep = ", ") %>% 
  mutate(categories = as.numeric(str_remove_all(categories, "\\[|\\]"))) %>% 
  left_join(Categorias, by = c("categories" = "category_id"))
por_categoria$categories[is.na(por_categoria$category_name)] <- "NA" 
por_categoria$category_name[por_categoria$category_name == "Thriller Books"] <- "Thriller"

# Unir las categorías de Mangas
anime_mangas <- por_categoria
anime_mangas$category_name[anime_mangas$category_name == "Graphic Novels: Manga"] <- "Graphic Novels, Anime & Manga"
por_categoria$category_name[por_categoria$category_name == "Thriller Books"] <- "Thriller"

# contar categorías (normal)

categorias_crudo <- count(por_categoria, category_name, sort = TRUE)
df_categorias <- as.data.frame(categorias_crudo)

# contar categorías (fusión mangas)
mangas_crudo <- count(anime_mangas, category_name, sort = TRUE)
df_mangas <- as.data.frame(mangas_crudo)


# Evaluación promedio por categoría ---------------------------------------

aux_categ=c()
for (i in 1:10) {
  anime_mangas %>%
    filter(category_name == df_mangas$category_name[i])  
  for (j in 1:9722){
    posicion=which(anime_mangas$category_name == df_mangas$category_name[i])
    eval_categoria= anime_mangas$rating_avg[posicion]
  }
  eval_categoria <- eval_categoria[!is.na(eval_categoria)]
  aux_categ = c(aux_categ, round(mean(eval_categoria), 1))
}
titulos1 = df_mangas$category_name[1:10]
eval_media_categ <- as.data.frame(as.matrix(cbind(titulos1, aux_categ), ncol=2) )
names(eval_media_categ) <- c("Categorias", "Calificacion")

eval_media_categ <- eval_media_categ[order(eval_media_categ$Calificacion, eval_media_categ$Categorias, decreasing = T), ]


# Evaluación promedio por Autor -------------------------------------------

aux_autor=c()
for (i in 1:10) {
  por_autor %>%
    filter(author_name == df_autores$author_name[i])  
  for (j in 1:9722){
    posicion=which(por_autor$author_name == df_autores$author_name[i])
    eval_autores= por_autor$rating_avg[posicion]
  }
  eval_autores <- eval_autores[!is.na(eval_autores)]
  aux_autor = c(aux_autor, round(mean(eval_autores), 1))
}
titulos2 = df_autores$author_name[1:10]

eval_media_autores <- as.data.frame(as.matrix(cbind(titulos2, aux_autor), ncol=2) )
names(eval_media_autores) <- c("Autores", "Calificacion")
eval_media_autores <- eval_media_autores[order(eval_media_autores$Calificacion, eval_media_autores$Autores, decreasing = T), ]



# Histogramas -------------------------------------------------------------

#Autores
df_autores %>%
  filter(n > 31) %>%
  ggplot(aes(x=reorder(author_name, -n), y=n)) +
  geom_col(fill="turquoise1", col = "gray40" ) +
  labs(x = "Autores", y = "Frecuencia", title = "10 Autores con más títulos entre los 10.000 Top-Seller") +
  ggthemes::theme_base() +
  theme(plot.subtitle = element_text(hjust = 0.5), 
        axis.title.x = element_text(size = 48),
        axis.title.y = element_text(size = 48),
        axis.text.x = element_text(size = 22),
        axis.text.y = element_text(size = 22),
        plot.title = element_text(size=60))+
  ggx::gg_("Center the title please")


#Categorías
df_categorias %>%
  filter(n > 360) %>%
  ggplot(aes(x=reorder(category_name, n), y=n)) +
  geom_col(fill="turquoise1", col = "gray40" ) +
  labs(x = "Categorías", y = "Frecuencia", title = "10 Categorías con más títulos entre los 10.000 Top-Seller") +
  ggthemes::theme_base()+
  theme(plot.subtitle = element_text(hjust = 0.5), 
        axis.title.x = element_text(size = 48),
        axis.title.y = element_text(size = 48),
        axis.text.x = element_text(size = 22),
        axis.text.y = element_text(size = 22),
        plot.title = element_text(size=54))+
  ggx::gg_("Center the title please")+
  coord_flip()

#Categorias (fusion mangas)
df_mangas %>%
  filter(n > 353) %>%
  ggplot(aes(x=reorder(category_name, n), y=n)) +
  geom_col(fill="turquoise1", col = "gray40" ) +
  labs(x = "Categorías", y = "Frecuencia", title = "10 Categorías con más títulos entre los 10.000 Top-Seller",
       subtitle = "Con una sóla categoría de anime y manga",) +
  ggthemes::theme_base()+
  theme(plot.subtitle = element_text(hjust = 0.5), 
        axis.title.x = element_text(size = 48),
        axis.title.y = element_text(size = 48),
        axis.text.x = element_text(size = 22),
        axis.text.y = element_text(size = 22),
        plot.title = element_text(size=54))+
  ggx::gg_("Center the title please")+
  coord_flip()

#Formatos
df_formatos %>%
  filter(n > 30) %>%
  ggplot(aes(x=reorder(format_name, -n), y=n)) +
  geom_col(fill="turquoise1", col = "gray40" ) +
  labs(x = "Formatos", y = "Frecuencia", title = "5 Formatos con más títulos entre los 10.000 Top-Seller") +
  ggthemes::theme_base()+
  theme(plot.subtitle = element_text(hjust = 0.5), 
        axis.title.x = element_text(size = 48),
        axis.title.y = element_text(size = 48),
        axis.text.x = element_text(size = 22),
        axis.text.y = element_text(size = 22),
        plot.title = element_text(size=60))+
  ggx::gg_("Center the title please")


#Promedio puntuaciones por Categorías

eval_media_categ %>%
  ggplot(aes(x=reorder(Categorias, -as.numeric(Calificacion)), y=Calificacion)) +
  geom_col(fill="turquoise1", col = "gray40" ) +
  labs(x = "Categorias", y = "Puntuación promedio", title = "Puntuación promedio con respecto a las categorías") +
  ggthemes::theme_base()+
  theme(plot.subtitle = element_text(hjust = 0.5), 
        axis.title.x = element_text(size = 48),
        axis.title.y = element_text(size = 48),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 22),
        plot.title = element_text(size=60))+
  ggx::gg_("Center the title please")

#Promedio puntuaciones por Autores

eval_media_autores %>%
  ggplot(aes(x=reorder(Autores, -as.numeric(Calificacion)), y=Calificacion)) +
  geom_col(fill="turquoise1", col = "gray40" ) +
  labs(x = "Autores", y = "Puntuación promedio", title = "Puntuación promedio con respecto a los autores") +
  ggthemes::theme_base() +
  theme(plot.subtitle = element_text(hjust = 0.5), 
        axis.title.x = element_text(size = 48),
        axis.title.y = element_text(size = 48),
        axis.text.x = element_text(size = 22),
        axis.text.y = element_text(size = 22),
        plot.title = element_text(size=60))+
  ggx::gg_("Center the title please")


# Tablas ------------------------------------------------------------------

#Autores
eval_media_autores %>% 
  gt() 
  
#Categorias
eval_media_categ %>% 
  gt()

emojis <- emo::jis


####CATEGORIAS Y AUTORES MAS POPULARES
#Categorias
a <- anime_mangas %>% 
  filter(category_name %in% categorias_crudo$category_name[1:10]) %>% 
  select(title, category_name, authors, rating_avg) %>% 
  separate_rows(authors, sep = ", ") %>% 
  mutate(authors = as.numeric(str_remove_all(authors, "\\[|\\]"))) %>% 
  left_join(Autores, by = c("authors" = "author_id")) %>% 
  select(title, category_name, author_name, rating_avg) %>% 
  filter(author_name %in% autores_crudo$author_name[1:10])
a$rating_avg[is.na(a$rating_avg)] <- "NA" 
a %>% gt()

#Gráfico categorías Según Autor
as.data.frame(a) %>% 
  ggplot() +
  aes(fct_rev(fct_infreq(a$category_name)), fill = author_name) +
  geom_bar() +
  labs(title = "Categorías con más títulos entre los 10.000 Top-Seller",
       subtitle = "Separado por los 10 autores más populares",
       y = "Frecuencia", x = "Categoría") +
  ggthemes::theme_base() +
  theme(plot.subtitle = element_text(hjust = 0.5), 
        axis.title.x = element_text(size = 24),
        axis.title.y = element_text(size = 24),
        axis.text.x = element_text(size = 22),
        axis.text.y = element_text(size = 22),
        plot.title = element_text(size=28)) + 
  guides(fill = guide_legend(title = "Top Autores")) +
  ggx::gg_("Center the title please")+
  coord_flip()


  

# Filtrando por idioma: Español

#Autores
por_autor %>% 
  filter(lang == "es") %>% 
  filter(author_name %in% autores_crudo$author_name[1:10]) %>% 
  select(title, author_name, rating_avg) %>%
  as.data.frame() %>% 
  gt()

#Categorias
cat_esp <- anime_mangas %>% 
  filter(lang == "es") %>% 
  filter(category_name %in% categorias_crudo$category_name[1:10]) %>% 
  select(title, category_name, rating_avg) %>% 
  as.data.frame() 
cat_esp <- cat_esp[order(cat_esp$title), ]
distinct(cat_esp, title, .keep_all = TRUE) %>% 
  gt()

puntuacion_perfecta <- por_autor %>% 
  filter(rating_avg == 5) %>% 
  filter(author_name %in% autores_crudo$author_name[1:10]) %>% 
  separate_rows(categories, sep = ", ") %>% 
  mutate(categories = as.numeric(str_remove_all(categories, "\\[|\\]"))) %>% 
  left_join(Categorias, by = c("categories" = "category_id")) %>% 
  select(title, category_name, author_name, rating_avg) %>% 
  filter(category_name %in% categorias_crudo$category_name[1:10]) 
distinct(puntuacion_perfecta, title, .keep_all = TRUE) %>% 
  gt()

