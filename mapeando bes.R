x###################################################################################
########## Mapeamento automatico de BEs; por JP Vieira-Alencar; Jun/2019 ##########
###################################################################################

#Esse script e' parte de uma funcao que esta' em construcao no momento, mas e' suficiente para agilizar o mapeamento de BEs 

library(rgdal) #Unico pacote que precisa ser carregado

setwd()#importante que seja o wd com .shp da area, do grid, a matriz de presenca e ausencia e a lista de SPP x BEs
getwd()

#Carregando o shape da area/ecorregiao#
shp <- readOGR(dsn=getwd(), layer="nome.do.shape") #colocar entre aspas o nome do ARQUIVO .shp da area/ecorregiao
plot(shp) #confira no display se esta' tudo certo

#Carregando o grid usado na analise#
grid <- readOGR(dsn=getwd(), layer="grid") #colocar entre aspas o nome do ARQUIVO .shp do grid usado na analise
plot(grid, add=TRUE) #confira no display se est'a tudo certo

#Carregando a matriz de presenca e ausencia (mpa). E' importante que seja a matriz ainda com nome das SPP e com os IDs do GRID
mpa <- read.table("mpa.csv", sep=",", head=TRUE, row.names=1)
#Confira se o numero de 'variables' bate com o numero de 'elements' do grid >>>>>

#Adicionando classe 'numeric' ao nome das colunas da matriz (e atribuido novamente os IDs do GRID ao nome das colunas, uma vez que o read.table desconfigura isso)
colnames(mpa) <- as.numeric(grid@data[["id"]])
View(mpa) #Importante para verificar se a matriz esta' com os nomes das spp e com os IDs dos grids devidamente reconhecidos como nomes das linhas e colunas respsctivamente

#Carregando a lista de SPP x BEs: E' importante que tenha apenas essas duas colunas, nessa mesma sequencia | SPP | BEs |, nao necessariamente com esses nomes.
lsp <- read.table("lsp.csv", sep=",", head=TRUE) #colocar entre aspas o nome do ARQUIVO .csv da lista de SPP x BEs
lsp[1] <- as.character(lsp[,1]) #Atribuindo classe 'character' aos nomes das SPP 

#Para verificar o numero de 'Noise' e de BEs na lsp carregada:
cat('\nNoise:', table(lsp[2])[1], '\nNumber of BEs:', max(lsp[2]))

               ########## #Aqui e' onde o mapeamento e' automatizado: ##########

areas <- list() #Criando uma lista vazia que vai conter as matrizes de presenca e ausencia por BE
map.ar <- list() #Criando uma lista vazia que vai conter os grids de cada BE

######################################################################################################
#########Looping de mapeamento: So' rodar! Teoricamente nao precisa mexer em nada aqui dentro ########
######################################################################################################

for(i in 1:nrow(unique(lsp[2])))
{
  areas[[i]] <- mpa[lsp[,1][lsp[,2]==i],]
  map.ar[[i]] <- grid[which(apply(areas[[i]], 2, sum)!=0),]
}

######################################################################################################

######################################################################################################
###### Pronto, temos duas listas preenchidas. Uma com as matrizes de presenca e ausencia por BE ######
###### e uma com os grids de cada BE.                                                           ######
######################################################################################################


##########################################################
###### Plotando o shp da area com um BE(i) por cima: #####
##########################################################

par(mar=c(0.1,0.1,0.1,0.1)) #reduzindo as margens para a figura aparecer maior
plot(shp) #plot da area de estudo
plot(map.ar[[i]], add=TRUE, col=rgb(0,0,1, 0.3)) #entre os colchetes de map.ar[[i]] troque i pelo numero do BE que quer plotar.

#'col' altera a cor do plot, rgb representa 'red, green, blue', respectivamente.
#Acima deixei azul, mas da pra combinar as cores alterando os zeros que aparecem antes do 1.
#O valor 0.3 diz respeito a transparencia do plot e vai de zero a 1, veja qual lhe agrada mais.

#Para saber as spp que compoem o BE escolhido, troque i pelo numero do BE:
row.names(areas[[i]])

######################################################
###### Plotando QUATRO BEs e uma unica 'prancha' #####
######################################################

#Para isso basta rodar a linha abaixo e repetir os comandos 'plot' acima escolhendo os BEs que quer na prancha
par(mar=c(0.1,0.1,0.1,0.1), mfrow=c(2,2))
#Se quiser MAIS DE UM BE em cima do mapa da area basta ignorar o comando 'plot(shp)' do segundo BE em diante

#Se quiser plotar TODOS os BEs em uma unica prancha:

#par altera parametros de plotagem
#mar determina tamanho de margem
#mfrow determina o numero de linhas e colunas da prancha respectivamente:

par(mar=c(1,1,1,1), mfrow=c(6,4))

## E' importante escolher numeros que multiplicados dao o numero total de BEs ou mais ##
#Em seguida rode o looping que segue:

#Looping para plotar todos os BEs de em uma unica prancha#
for(i in 1:length(map.ar))
{
  plot(shp)
  plot(map.ar[[i]], add=TRUE, col=rgb(0,0,1, per[[i]]))
}

#Por fim, para salvar o .shp de algum BE('i'), coloque o numero do BE entre os colchetes, e escolha o 'nome.para.salvar' o ARQUIVO:
writeOGR(map.ar[[i]], dsn=getwd(), layer = 'nome.para.salvar', driver="ESRI Shapefile")

#Para plotar os BEs com as celulas com porcetagem diferente de especies:

per <- list() #criando lista vazia para colocar os vetores de transparenci

#Looping criando os vetores de transparencia
for(i in 1:length(areas))
{
  n <- apply(areas[[i]], 2, sum)
  n[n!=0]
  m <- length(rownames(areas[[i]]))
  per[[i]] <- n[n!=0]/m
}

for(i in 1:length(per))
{
  per[[i]][per[[i]]<0.3] <- 0
  per[[i]][per[[i]]>=0.3 & per[[i]] < 0.7] <- 0.3
  per[[i]][per[[i]]>=0.7] <- 0.7
}

#Para plotar individualmente um BE com as devidas ctransparencias por celulas do grid:
plot(shp)
plot(map.ar[[17]], add=TRUE, col=rgb(0,0,1, per[[17]])) #trocar i pelo numero do BE desejado
row.names(areas[[19]])

#Para plotar TODOS os BEs de uma vez com as devidas transparencias por celula do grid:
for(i in 1:length(map.ar))
{
  plot(shp)
  plot(map.ar[[i]], add=TRUE, col=rgb(0,0,1, per[[i]]))
}

#Qualquer duvida ou problema com o script me escreva:
joaopaulo.valencar@hotmail.com

#Abreijos e bom mapeamento!