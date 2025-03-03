corpus_clean <- read.csv("bases/corpus_clean.csv")
bd <- read.csv("bases/base_limpia2.csv")

bd_compara <- full_join(bd, corpus_clean, by = "id")

base1 <- bd_compara %>% 
  filter(is.na(texto_limpio.y) == T)


base2 <- bd_compara %>% 
  filter(is.na(texto_limpio.x) == T)
