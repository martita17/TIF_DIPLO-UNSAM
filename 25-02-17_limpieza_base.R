library(tidyverse)
library(skimr)
library(tidytext)
library(dplyr)

bd <- read.csv(file = "2024 M5_corpus_medios.csv")

str(bd)

# Para conocer mejor la base y realizar una limpieza sobre las notas, viene bien saber
# la cantidad de caracteres de cada artículo

bd <- bd %>% 
  mutate(caracteres_texto = nchar(texto))

skim_without_charts(bd)


# Apartir del resumen arrojado por la función anterior podemos ver que de los 7.000
# casos que contiene el df, hay algunos que parecen tener duplicado el título (3) y 
# otros el texto (78). Ahondaremos sobre esto para  proceder con la limpieza.

titulo_duplicado <- bd %>% 
  filter(duplicated(titulo))

# A partir del análisis de los títulos duplicados nos encontramos con que, si bien
# hay casos en los que el título duplicado corresponde a una misma noticia, hay otros
# casos en los que no. Por ejemplo, en el caso del diario Página 12 nos encontramos
# con que se repite como título "Pirulo de Tapa", el cual refiere a breves noticias
# de aproximadamente 500 caracteres. Sería conveniente decidir si las dejamos.


texto_duplicado <- bd %>% 
  filter(duplicated(texto), duplicated(medio))
# Gracias al código anterior nos encontramos con que hay 77 entradas en las que
# coincide el texto y el medio de publicación.

texto_duplicado2 <- bd %>% 
  filter(duplicated(texto), duplicated(titulo), duplicated(medio))
# Si agregamos como variable el título, vemos que el número se reduce a 18 observaciones.


# Al hacer una revisión manual de los resultados, vemos que aquellas entradas donde
# se duplica texto y medio (sin necesidad que se duplique el título) son casos
# en los que ha habido algún problema para traer el texto completo de la nota.
# En ocasiones nos encontramos con que se ha scrapeado un aviso de la parte de los
# comentarios (La NAción), mientras que en otros casos se ha traído lo que parece ser
# el título y bajada de otras notas (Página 12) o aparecen como NA.
# Teniendo en cuenta lo anterior, lo recomendable parece ser eliminar todos los artículos
# que figuran como duplicado.
# Pero, además, deberíamos rastrear los originales, dado que revisten la misma situación.


clean_duplicados <- which(duplicated(bd$texto) == TRUE)
# Crear un vector lógico para todas las filas duplicadas (incluyendo primeras apariciones)
duplicados_logico <- duplicated(bd$texto) | duplicated(bd$texto, fromLast = TRUE)
# Crear el data frame con solo las filas duplicadas, incluyendo la primera ocurrencia
duplicados <- bd[duplicados_logico, ]

# Al revisar el set de observeciones "duplicados" confirmamos lo apuntado anteriormente. En muchos
# casos, las observaciones que se encuentran duplicadas son aquellas en las que ha sucedido
# algún problema al momento de realizar el scraping sobre la nota. Por ejemplo, vemos que la observación
# ID = 52264, con fecha 2019-07-01, con título: "Más felices si solo cumplen tareas domésticas",
# en el campo "texto" tiene una referencia a un discurso de Alberto Fernández durante la pandemia. Esto
# puede deberse al hecho de que al momento de hacer el scraping el código tomó algo que " no correspondía".

# Para poder diferenciar a estos casos de aquellos que efectivamente contienen notas, se me ocurre que se
# podría hacer una primer limpieza de NAs y aquellas notas que tienen duplicado el texto y el título.

dupli_tit_text <- bd %>% 
  filter((duplicated(texto) & duplicated(titulo)) | (duplicated(texto, fromLast = T) & duplicated(titulo, fromLast = T)))
# A partir del explorar el set resultante podemos sospechar que todas las observaciones
# contenidas en el mismo efectivamente son noticias duplicadas, más allá de que el
# url no coincida exactamente.

dupli_tit_text2 <- bd %>% 
  filter(duplicated(texto) & duplicated(titulo))
# El número de observaciones no es exactamente la mitad del número de observaciones
# del set anterior debido a que hay una nota que se repite dos veces.

text_NA <- bd %>% 
  filter(is.na(texto))
# Nos encontramos con 5 observaciones en la que no hay texto del artículo.

#Realizamos una primer limpieza de NAs y observaciones en que se duplica texto y título
bd_clean1 <- bd %>% 
  filter(is.na(texto) == F & (duplicated(texto) & duplicated(titulo)) == F)


# Volvemos a la carga para revisar los duplicados que quedan

clean_duplicados <- which(duplicated(bd_clean1$texto) == TRUE)
# Crear un vector lógico para todas las filas duplicadas (incluyendo primeras apariciones)
duplicados_logico <- duplicated(bd_clean1$texto) | duplicated(bd_clean1$texto, fromLast = TRUE)
# Crear el data frame con solo las filas duplicadas, incluyendo la primera ocurrencia
duplicados <- bd_clean1[duplicados_logico, ]
 

# Podemos proceder a eliminarlos todos.

bd_clean2 <- bd_clean1 %>% 
  filter((duplicated(bd_clean1$texto) | duplicated(bd_clean1$texto, fromLast = TRUE)) == F)

bd_clean2 <- read.csv(file = "bases/base_limpia.csv")

# Cargar stopwords en español
stopwords_es <- get_stopwords(language = "es")
stopwords_propias <- data_frame(word = "jpg", lexicon = "propio")
stopwords_es <- bind_rows(stopwords_es, stopwords_propias)

# Necesario revisar la importancia de la palabra estado, que se encuentra eliminada
# a partir del set de stopwords que estamos usando.

# Limpieza del texto
bd_clean_3 <- bd_clean2 %>%
  mutate(
    texto_limpio = texto %>%
      str_replace_all("[^\\w\\s]", " ") %>%  # 1) Eliminar caracteres especiales. Reemplazarlos por un espacio.
      str_replace_all("\\d+", "") %>%      # 2) Eliminar números
      str_replace_all("\\s+", " ") %>%     # 3) Reemplazar múltiples espacios y saltos de línea por un espacio
      str_to_lower()                       # 5) Convertir todo a minúscula
  ) %>%
  rowwise() %>%
  mutate(
    texto_limpio = str_c(
      setdiff(unlist(str_split(texto_limpio, " ")), stopwords_es$word),
      collapse = " "
    )  # 4) Remover stopwords
  )


bd_clean_3 <- bd_clean_3 %>% 
  mutate(caracteres_texto_limpio = nchar(texto_limpio))

#Revisamos la mediana y la media de la cantidad de caracteres de las notas
# POR ALGÚN EXTRAÑO MOTIVO NO FUNCIONA
bd_clean_3 %>% summarise(mediana = median(caracteres_texto_limpio))

summary(bd_clean_3$caracteres_texto_limpio)

# Exploramos un poco más
short_art <- bd_clean_3 %>% 
  filter(caracteres_texto_limpio <= 250)

# A partir de una revisión manual del set de 63 observaciones conseguido a partir
# del código anterior, podemos asegurar que las entradas con menos de 250 caracteres
# en la columna caracteres_texto_limpio pertenecen a alguno de los siguientes casos:
# - hubo algún error en el scrapeo del contenido de la nota
# - contienen textos de caracter publicitario o no vinculado con el título y la fecha real de la entrada
# - se trata de pequeños artículos sin desarrollo de noticias que comentan otro tipo de contenido (videos, publicaciones redes sociales)
# Por este motivo, nos vemos en condiciones de proceder a eliminar dichas entredas de la base.

short_art_500 <- bd_clean_3 %>% 
  filter(caracteres_texto_limpio >= 250 & caracteres_texto_limpio <=500)

short_art_300 <- bd_clean_3 %>% 
  filter(caracteres_texto_limpio >= 250 & caracteres_texto_limpio <=300)

# Revisando un poco más, nos encontramos que se nos filtra una observación con errores
# al momento de scrapear la nota. A fin de no recortar de más, eliminamos por separado.
# Al momento de hacer TF, IDF, TF-IDF, podremos detectar si hay algo más que se nos esté escapando.

# Realizamos el filtrado final para quedarnos con aquellos casos que no comienzan con
# "article download failed " y que tienen más de 250 caracteres en su texto limpio.
bd_clean <- bd_clean_3 %>% 
  filter(str_starts(texto_limpio, "article download failed") == F & caracteres_texto_limpio > 250)

#Exportamos la base
write.csv(bd_clean, "bases/base_limpia.csv", row.names = F)


