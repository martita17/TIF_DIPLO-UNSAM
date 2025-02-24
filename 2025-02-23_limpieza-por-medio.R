# EXPLORACIÓN DE TEXTOS BASURA DENTRO DE LAS NOTAS, POR MEDIO DE COMUNICACIÓN

# A raíz del ejercicio de TF, TF-IDF, hemos detectado que las notas contenían ciertos
# estractos de la página web que no resultan relevantes para el análisis. También
# se detectan palabras vacías que tienen altas frecuencias de aparición.
# Por este motivo, exploramos por medio y generamos códigos para poder profundizar la limpieza.

bd_clean_inicio <- read.csv(file = "bases/base_limpia.csv")

list2env(split(bd_clean_inicio, bd_clean_inicio$medio), envir = .GlobalEnv)

# LA NACIÓN

palabras_lanacion <- lanacion %>%
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup()


lanacion <- lanacion %>% 
  mutate(texto_limpio = case_when(
    medio == "lanacion" ~ str_replace_all(texto_limpio,
                                          " credito .*? comentar gusta compartir mail twitter facebook whatsapp guardar \\S+|comentar gusta compartir mail twitter facebook whatsapp guardar \\S+",
                                          ""),
    TRUE ~ texto_limpio
  ))

palabras_lanacion2 <- lanacion %>%
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup()

rm(palabras_lanacion, palabras_lanacion2)


# CLARIN

palabras_clarin <- clarin %>%
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup()

# En principio no se detecta presencia de "texto basura". Se registra fuerte presencia
# de palabras poco relevantes como ano, anos. También se registra una presencia considerable
# del nombre del medio.

rm(palabras_clarin)

# CRONICA

palabras_cronica <- cronica %>%
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup()

# Se repiten las mismas observaciones que para Clarín. A su vez, se detecta la aparición
# repetida de "cronica com ar"

cronica <- cronica %>% 
  mutate(texto_limpio = str_replace_all(texto_limpio,
                                          "cronica com ar ",
                                          "")
  )

palabras_cronica2 <- cronica %>%
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup()

rm(palabras_cronica, palabras_cronica2)

# INFOBAE

palabras_infobae <- infobae %>%
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup()

# Se repiten las mismas observaciones que para Clarín

rm(palabras_infobae)

# MINUTO UNO

palabras_minutouno <- minutouno %>%
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup()

# Se repiten las mismas observaciones que para Clarín y se detectan como
# palabras vacías: embed y jpg

rm(palabras_minutouno)

# PÁGINA 12

palabras_pagina12 <- pagina12 %>%
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup()

# Se repiten las mismas observaciones que para Clarín.

rm(palabras_pagina12)

# PERFIL

palabras_perfil <- perfil %>%
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup()

# Se repiten las mismas observaciones que para Clarín.

rm(palabras_perfil)

# TELAM

palabras_telam <- telam %>%
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup()

# Se repiten las mismas observaciones que para Clarín.

rm(palabras_telam)

bd_clean <- bind_rows(clarin, cronica, infobae, lanacion, minutouno, pagina12, perfil, telam)

rm(clarin, cronica, infobae, lanacion, minutouno, pagina12, perfil, telam)

# Limpieza de nuevas stopwords

stop_words2 <- tibble(word = c("ano", "anos", "embed", "lunes", "martes",
                               "miercoles", "jueves", "viernes", "sabado",
                               "domingo", "otrx", "otrxs", "lxs",
                               # Imágenes
                               "jpg", "jpeg", "jpe", "png", "gif", "bmp", "tiff", "tif", "webp", "svg", "ico", "heic", "avif",
                               # Videos
                               "mp4", "mkv", "mov", "avi", "wmv", "flv", "webm", "mpeg", "mpg", "3gp", "m4v", "ogv",
                               # Audios
                               "mp3", "wav", "flac", "aac", "ogg", "wma", "m4a", "opus", "aiff", "amr"))

bd_clean <- bd_clean %>% 
  rowwise() %>%
  mutate(
    texto_limpio = str_c(
      setdiff(unlist(str_split(texto_limpio, " ")), stop_words2$word),
      collapse = " "
      )
    ) # 4) Remover stopwords


#Exportamos la base
write.csv(bd_clean, "bases/base_limpia2.csv", row.names = F)

# Tras una nueva prueba, continuamos teniendo problemas con pequeños términos, de
# entre 2 y 3 letras, que no tienen sentido. Exploramos y limpiamos.

palabras2 <- bd_clean %>%
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup()


short_words2 <- palabras2 %>% 
  filter(str_count(word) == 2)

short_words3 <- palabras2 %>% 
  filter(str_count(word)==3)
