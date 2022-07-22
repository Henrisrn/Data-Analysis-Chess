#Initialisation
rm(list = ls()) #Supp l'environement
#install.packages("ggplot2")
getwd()
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)
library(scales)

#On organise notre tab
tab =read.csv2("chess_games.CSV")
Compétition = tab$rated
Nbmouv = tab$turns
couleurgagnant = tab$winner
Classementjoueurnoir = tab$black_rating
Classementjoueurblanc = tab$white_rating
Nbmouvementouverture = tab$opening_moves
Duree = tab$time_increment
TypeOuverture = tab$opening_shortname
Nbcoupouverture = tab$opening_moves
Typevictoire = tab$victory_status
dim(tab)
colnames(tab)
n = 20057
#Camembert
pie(table(couleurgagnant),main = "Couleur gagnante", las = 1)  + geom_text(aes(y = couleurgagnant/3 + c(0, cumsum(couleurgagnant)[-length(couleurgagnant)]), 
                label = percent(couleurgagnant/100)), size=5)
pie(table(Compétition),main = "Proportion de partie en compétition",las = 2,aes(y = couleurgagnant/3 + c(0, cumsum(couleurgagnant)-length(couleurgagnant))))
quantile(Nbmouv,0.25)
quantile(Nbmouv,0.75)




total = sum(valeurs)
pourcentages = valeurs/total*100 ; cat("Les valeurs en % sont de :",pourcentages,"\n")
# Fonction à coller dans R - cette fonction text_pie permet d'ajouter des étiquettes au centre des quartiers
text_pie = function(vector,labels=c(),cex=1) {
  vector = vector/sum(vector)*2*pi
  temp = c()
  j = 0
  l = 0
  for (i in 1:length(vector)) {
    k = vector[i]/2        
    j =  j+l+k
    l = k
    text(cos(j)/2,sin(j)/2,labels[i],cex=cex)
  }
  vector = temp
}
# Ajouter les étiquettes
text_pie(pourcentages,c("17,2%","27,6%","55,2%"),cex=1.1) # Ces valeurs en % sont à remplacer manuellement
#Barplot

df <- data.frame(Nbmouv,
                 Duree)
head(df)
mean(Nbmouv)
mean(Nbcoupouverture)


barplot(table(TypeOuverture))

#Histogramme
barplot(table(Nbmouvementouverture),
     main = "Nombre de mouvement pour une ouverture",
     col = "darkred",xlab = "Nombre de mouvement pour l'ouverture",ylab = "Fréquence")


# Barplot horizontal à 2 variables
df2 <- data.frame(TypeOuverture,
                 Nbcoupouverture)
head(df2)
p<-ggplot(data=df2, aes(x=TypeOuverture, y=Nbcoupouverture),main = "Nombre de coup pour réalisé une ouverture") +
  geom_bar(stat="identity")

p + coord_flip()

#Nuage de point
df3 <- data.frame(TypeOuverture,
                  Nbcoupouverture)
ggplot(df3, aes(y=TypeOuverture, x=Nbcoupouverture),xlab= "Type d'ouverture",ylab = "Nombre coup par ouverture") +
  geom_point(size=3, color = "pink")+ theme(legend.direction = 'horizontal', 
                            legend.position = 'bottom',
                            legend.key = element_rect(size = 50, color = 'white'),
                            legend.key.size = unit(10, 'lines'),
                            legend.title = element_text(color = "blue", size = 14),
                            legend.text = element_text(color = "red", size = 10))+guides(color = guide_legend(nrow = 200))

#cor(Nbcoupouverture,TypeOuverture) Type ouverture n'est pas numérique                          

barplot(table(Nbmouv),main="Nombre de mouvement dans une partie")
bp<- ggplot(df, aes(x="", y=Nbmouv, fill=Group))+
  geom_bar(width = 1, stat = "identity")
pie <- bp + coord_polar("y", start=0)
pie + scale_fill_brewer(palette="Blues")+
  theme_minimal()
X = table(Duree)
Z = prop.table(X) *100

#Nuage de points reliés

boxplot(Nbmouv~Compétition,main="Nombre de coup effectué en fonction du type de partie")
mean(Nbmouv)


#On transforme la colonne Compétition en numérique
for (i in 1:20057)   
{   
  a = ifelse(Compétition[i] == TRUE , 1, 0)
  Compétition[i] <- a
  
}

#Loi du Khi 2 Si j'arrive à le placer on est très bien
Khi2=function(X) {  
  n=sum(X)  
  TotLigne=apply(X,1,sum)  
  TotColonne=apply(X,2,sum)  
  Th=TotLigne%*%t(TotColonne)/sum(X)  
  Distance=(X-Th)^2/Th  
  return(sum(Distance)) 
}  

df4 <- data.frame(Nbmouv,
                  Nbcoupouverture,Compétition)
df4
Khi2(df4)  
chisq.test(df4) 
#Variance du niveau des joueurs blanc et noir
classementtotal = Classementjoueurblanc+Classementjoueurnoir
hist(classementtotal,
     main = "Classement des différents joueur",
     col = "darkred",xlab = "Nombre de mouvement pour l'ouverture",ylab = "Fréquence")
variance=function(X) 
{   
  n=length(X)   
  S=0   
  m=mean(X)   
  for (i in 1:n)   
  {     
    S=S+(X[i]-m)^2   
  }   
  return(S/n)
  } 
variance(Classementjoueurblanc)
variance(Classementjoueurnoir)

#Médiane des différents niveau des joueurs
mediane=function(X = c(10,2,4,5,9)) 
{   
  n=length(X)   
  Y=sort(X)   
  if (n%%2==1)   
  {     
    R=Y[(n+1)/2]   
  }   
  else   
  {     
      R=1/2*(Y[n/2]+Y[n/2+1])   
  }   
  return(R) 
}

#Etude sur les différents niveau

mediane(Classementjoueurblanc)
mediane(Classementjoueurnoir)

#On peut donc en déduire que le niveau des joueurs est grosso modo le même, avec un test du khi 2 qui montre l'indépendance, un variance et une médiane équivalente


"Pour rajouter une colonne <=> Traduction numérique du TRUE ou FALSE"

data.frame = Compétition
data_frame <- transform(
  Compétition, col4= ifelse(Compétition==TRUE,1, 0))

print(data_frame)

#ON RAJOUTE LA COLONNE DIFFERENCE DE NIVEAU

tab <- transform(
  tab, col4 = ifelse(Classementjoueurblanc>Classementjoueurnoir,(Classementjoueurblanc-Classementjoueurnoir),Classementjoueurnoir-Classementjoueurblanc))

DifferenceNiveau = tab[,18]

#On traduit la couleur en binaire
tab <- transform(
  tab, NiveauJustifier = ifelse(couleurgagnant == "White",
                                ifelse(Classementjoueurnoir <= Classementjoueurblanc,"Niveau Justifié","Niveau non justifié"),
                                ifelse(Classementjoueurblanc < Classementjoueurnoir,"Niveau Justifié","Niveau non justifié")))

NiveauJustifier = tab[,19]
print(DifferenceNiveau)
print(NiveauJustifier)
pie(table(NiveauJustifier),main = "La différence de niveau est elle justifié")


#Avec toutes les valeurs

hist(DifferenceNiveau, main = "Représentation des difference de niveau",
     col = "darkred",xlab = "Nombre de mouvement pour l'ouverture",ylab = "Fréquence")

mean(DifferenceNiveau)
variance(DifferenceNiveau)
mediane(DifferenceNiveau)
hist(DifferenceNiveau, main = "Représentation des difference de niveau",
     col = "darkred",xlab = "Nombre de mouvement pour l'ouverture",ylab = "Fréquence")

df4 <- data.frame(DifferenceNiveau,
                  Nbmouv,Compétition)
df4
Khi2(df4)  
chisq.test(df4) 

df3 <- data.frame(DifferenceNiveau,
                  Nbmouv)
ggplot(df3, aes(y=DifferenceNiveau, x=Nbmouv),xlab= "Type d'ouverture",ylab = "Nombre coup par ouverture") +
  geom_point(size=2,color = 'yellow')+ theme(legend.direction = 'horizontal', 
                                             legend.position = 'bottom',
                                             legend.key = element_rect(size = 50, color = 'white'),
                                             legend.key.size = unit(10, 'lines'),
                                             legend.title = element_text(color = "blue", size = 14),
                                             legend.text = element_text(color = "red", size = 10))+guides(color = guide_legend(nrow = 200))




#On  enlève les valeurs extrèmes
for (i in 1:20057)   
{ 
  if(DifferenceNiveau[i] > 100)
  {
    DifferenceNiveau[i] <- 0
  }
}
for (i in 1:20057)   
{ 
  if(Nbmouv[i] > 50)
  {
    Nbmouv[i] <- 0
  }
}
a = table(TypeOuverture)
dim(a)
hist(a)
b = str_split_fixed(a, "  ", 1)
print(b)
df5 <- data.frame(a)
print(df5)
for(i in 1:128)
{
 
  if(b[i] == 1)
  {
    df5[-i,]
  }
  if(b[i] == 2)
  {
    df5[-i,]
  }
  if(b[i] == 3)
  {
    df5[-i,]
  }
  if(b[i] == 4)
  {
    df5[-i,]
  }
  if(b[i] == 6)
  {
    df5[-i,]
  }
  
  
}

print(df5)
print(a)
pie(a)
write.table(a)
for (i in a.lenght(a))   
{ 
  if(a[i] <= 10)
  {
    a[i] <- 0
  }
}
pie(table(TypeOuverture))
hist(DifferenceNiveau, main = "Représentation des difference de niveau",
     col = "darkred",xlab = "Nombre de mouvement pour l'ouverture",ylab = "Fréquence")

mean(DifferenceNiveau)
variance(DifferenceNiveau)
mediane(DifferenceNiveau)
hist(DifferenceNiveau, main = "Représentation des difference de niveau",
      col = "darkred",xlab = "Nombre de mouvement pour l'ouverture",ylab = "Fréquence")

df4 <- data.frame(DifferenceNiveau,
                  Nbmouv,Compétition)
df4


df3 <- data.frame(DifferenceNiveau,
                  Nbmouv)
ggplot(df3, aes(y=DifferenceNiveau, x=Nbmouv),xlab= "Type d'ouverture",ylab = "Nombre coup par ouverture") +
  geom_point(size=2,color = 'yellow')+ theme(legend.direction = 'horizontal', 
                            legend.position = 'bottom',
                            legend.key = element_rect(size = 50, color = 'white'),
                            legend.key.size = unit(10, 'lines'),
                            legend.title = element_text(color = "blue", size = 14),
                            legend.text = element_text(color = "red", size = 10))+guides(color = guide_legend(nrow = 200))
cor(DifferenceNiveau,Nbmouv)
n = 20057
rapcorrel=function(X,Y) {   
  modalites=unique(X)   
  k=length(modalites)   
  n=length(Y)   
  m=mean(Y)   
  VTot=1/n*sum(Y^2)-m^2   
  Vintra=0   
  Vinter=0   
  for (i in modalites)   {     
    mc=mean(Y[X==i])     
    Vintra=Vintra+sum((Y[X==i]-mc)^2)     
    Vinter=Vinter+sum(X==i)*(m-mc)^2   
  }   
  Vintra=Vintra/n   
  Vinter=Vinter/n   
  return(c(Vinter)/VTot) 
  }  

print(R)
for (i in 1:20057)   
{   
  a = ifelse(NiveauJustifier[i] == "Niveau Justifié" , 1, 0)
  NiveauJustifier[i] <- a
  
}
freque = 0
nom = 

pie(table(TypeOuverture),main= "Combien de coup nécessaire pour effectuer une bonne ouverture")
boxplot(Nbcoupouverture~TypeOuverture,main= "Combien de coup nécessaire pour effectuer une bonne ouverture")

boxplot(DifferenceNiveau~tab$winner,main= "Couleur gagnante en fonction de la difference de niveau")
shapiro.test(DifferenceNiveau)