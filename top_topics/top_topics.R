doc_2_topics <- doc_2_topics %>% 
  mutate(id = as.integer(document))

topico_nota <- doc_2_topics %>% 
  group_by(id) %>% 
  slice_max(order_by = gamma, n = 2, with_ties = F) %>% 
  ungroup()

topico_nota <- topico_nota %>% 
  mutate(orden = rep(c(1, 2), 6848))


topico_nota <- pivot_wider(topico_nota, id_cols = c(id), names_from = orden, values_from = c(topic, gamma))

topico_nota <- topico_nota %>% 
  arrange(id)


summary(topico_nota$gamma_1)
summary(topico_nota$gamma_2)

topico_nota <- topico_nota %>% 
  mutate(gamma_1 = round(x = gamma_1*100, digits = 4),
         gamma_2 = round(x = gamma_2*100, digits = 4))


bd_clean <- bd_clean %>% 
  left_join(topico_nota, by = c("id" = "id"))

write.csv(bd_clean, file = "base_top_topics.csv", row.names = F)
