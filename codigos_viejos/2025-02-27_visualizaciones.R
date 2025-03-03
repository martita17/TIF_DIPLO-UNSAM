bd_clean<-read.csv("../bases/base_limpia2.csv")

library(tidyverse)
library(tidytext)


palabras <- bd_clean %>%
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup() #%>% 

notas_tf_idf <- palabras %>%
  bind_tf_idf(word,medio, n)

tf_idf_ord<-notas_tf_idf %>%
  arrange(desc(tf_idf))

tf_idf_ord %>%
  group_by(medio) %>%
  slice_max(tf_idf, n = 10) %>%
  ungroup() %>%
  ggplot(aes(tf_idf, fct_reorder(word, tf_idf), fill = medio)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~medio, ncol = 2, scales = "free") +
  labs(x = "tf-idf", y = NULL) +
  theme (axis.text.y = element_text(size=6))+
  theme_minimal()


nombres_medios<-c("clarin","cronishop","loading","shared","email","minutouno",
                  "infobae","paginai","eltrece","adami","tesone","spillman","reuters",
                  "telam","ayerdi","oloixarac","merle","stracuzzi","getty","foglia")

palabras_ultra_clean <- bd_clean %>% 
  unnest_tokens(output = word, 
                input = texto_limpio) %>%
  group_by(medio, word) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  ungroup() %>% 
  filter(nchar(word) > 3) %>%
  filter(!word %in% nombres_medios)

notas_tf_idf_ultra <- palabras_ultra_clean %>%
    bind_tf_idf(word,medio, n)
  
tf_idf_ord_ultra <-notas_tf_idf_ultra %>%
    arrange(desc(tf_idf))  

tf_idf_ord_ultra %>%
  group_by(medio) %>%
  slice_max(tf_idf, n = 10) %>%
  ungroup() %>%
  ggplot(aes(tf_idf, fct_reorder(word, tf_idf), fill = medio)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~medio, ncol = 2, scales = "free") +
  labs(x = "tf-idf", y = NULL) +
  theme (axis.text.y = element_text(size=6))+
  theme_minimal()

tf_idf_top10 <- tf_idf_ord_ultra %>%
  group_by(medio) %>%
  slice_max(tf_idf, n = 10) %>%
  ungroup()

tf_idf_ord_filtrada <- tf_idf_ord_ultra %>% 
  filter(n >= 5)

tf_idf_ord_filtrada %>%
  group_by(medio) %>%
  slice_max(tf_idf, n = 10) %>%
  ungroup() %>%
  ggplot(aes(tf_idf, fct_reorder(word, tf_idf), fill = medio)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~medio, ncol = 2, scales = "free") +
  labs(x = "tf-idf", y = NULL) +
  theme (axis.text.y = element_text(size=6))+
  theme_minimal()
