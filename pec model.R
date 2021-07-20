
library(Rpath)

#Get Data. data from export EwE 6.6 PEC Model

setwd("~/Documentos/GitHub/ParanaguaBay_FoodWeb/data")
BasicInput <- read.csv("PEC Annual-Basic input.csv", h=T)
Diet<- read.csv("PEC Annual-Diet composition.csv")
Fleet<-read.csv("PEC Annual-Definition of fleets.csv")
Discards<-read.csv("PEC Annual-Discards.csv")
Landings<-read.csv("PEC Annual-Landings.csv")

#Create groups name vector from Basic Input data
group_name<-c(BasicInput$Group.name, Fleet$Fleet.name)

Type<-c(rep(0,35), rep(1,3), 2, rep(3,5)) #

#Create Rpath object
PecModel<-create.rpath.params(group_name, Type, stgroup = NA)

#Fill basic
{
PecModel$model$Biomass<-c(BasicInput$Biomass.in.habitat.area..t.km.., rep("NA", 5))
PecModel$model$PB<-c(BasicInput$Production...biomass...year., rep("NA", 5))
PecModel$model$QB<-c(BasicInput$Consumption...biomass...year., rep("NA", 5))
PecModel$model$EE<-c(BasicInput$Ecotrophic.Efficiency,  rep("NA", 5))
PecModel$model$ProdCons<-c(BasicInput$Production...consumption, rep("NA", 5))
PecModel$model$Unassim<-c(BasicInput$Unassim..consumption,rep("NA", 5))
PecModel$model$DetInput<-c(BasicInput$Detritus.import..t.km..year.,rep("NA", 5))
}
#Fishery data
# Landings and Discards comes from EwE with Sum in last line - REMOVE 
#Landings. The suffix ".l" = landings
{
Landings<-Landings[1:39,]
Discards<-Discards[1:39,]
mussel.l<-c(Landings$Mussel.extraction..t.km..year.,rep("NA", 5))
trap.l<-c(Landings$Estuarine.Trap..t.km..year.,rep("NA", 5))
shrimp.l<-c(Landings$Estuarine.Shrimp.Fishery..t.km..year.,rep("NA", 5))
gillnet.l<-c(Landings$Gillnet..t.km..year.,rep("NA", 5))
longline.l<-c(Landings$Longline..t.km..year.,rep("NA", 5))

#Discards. Suffix .d = discards
mussel.d<-c(Discards$Mussel.extraction..t.km..year., rep("NA", 5))
trap.d<-c(Discards$Estuarine.Trap..t.km..year., rep("NA", 5))
shrimp.d<-c(Discards$Estuarine.Shrimp.Fishery..t.km..year., rep("NA", 5))
gillnet.d<-c(Discards$Gillnet..t.km..year., rep("NA", 5))
longline.d<-c(Discards$Longline..t.km..year., rep("NA", 5))
}
# insert landings data from five fisheries in PecModel (rpath object)
PecModel$model[,MusselExtraction := mussel.l]
PecModel$model[,EstuarineTrap := trap.l]
PecModel$model[,EstuarineShrimp := shrimp.l]
PecModel$model[,Gillnet := gillnet.l]
PecModel$model[,Longline := longline.l]

# insert discards data from five fisheries into PecModel (rpath object)
PecModel$model[,MusselExtraction.disc := mussel.d]
PecModel$model[,EstuarineTrap.disc := trap.d]
PecModel$model[,EstuarineShrimp.disc := shrimp.d]
PecModel$model[,Gillnet.disc := gillnet.d]
PecModel$model[,Longline.disc := longline.d]


#Diet


pec<-PecModel # so para nao ter q fica rodando o modelo toda hora no ajuste da dieta
tail(Diet, 10)
tail(pec$diet, 10)

#Remove last two lines (Sum , and (1-Sum));the first and the detritus and primary production columns (X.1). The data from EwE comes like this
dieta<-Diet[1:40,2:37] # remove partes idesejadas da matriz de dieta proveniente do Ewe.

names(dieta)<-c("Group",t(dieta$Prey...predator[1:35])) # arruma o nome da matriz de dieta


diet
View(diet)

pec$diet=dieta
View(pec$diet)
