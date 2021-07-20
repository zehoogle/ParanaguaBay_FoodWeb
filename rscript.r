## Novo Script para analisar Doutorado

#Estimativa de grupós

#carcinofauna appa
pacman:: p_load(rgdal,gstat,raster,sp,sf, ggspatial, rgeos, mapview, mapdata, maptools, tmap,  tidyverse, ggmap, kableExtra, ggforce, cowplot)
carcino <- read_csv("Documentos/GitHub/ParanaguaBay_FoodWeb/carcino.csv")
carcino

mass_ind<-carcino%>%group_by(Ano, Estacao) %>%
  summarise(Peso = mean(Peso, na.rm=T))
