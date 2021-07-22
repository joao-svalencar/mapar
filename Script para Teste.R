library(rgdal)
setwd()
g <- readOGR(getwd(), layer = "grid_1grau")
m <- read.csv("mpa.csv", row.names=1)
l <- read.csv("lsp.csv")
s <- readOGR(getwd(), layer = "MA")

m <- m[l[,1][l[,2]!=0],] #tirando noise component
l <- l[l[2]!=0,]

for(i in 1:length(unique(l[,2]))) #mudando o nome das aras na lista de spp
{
l[2][l[2]==unique(l[,2])[i]] <- paste('BE', i, sep=' ')
}


BEs_custdist_0.5 <- mapar(grid=g, mpa=m, lsp=l, plot=TRUE, shp=s, prop=TRUE, grp=FALSE)
3

plot(s)
plot(BEs_custdist_0.5[[2]][[3]], add=TRUE, col=rgb(1,0,0, alpha=BEs_custdist_0.5[[3]][[3]])) #plotando BE3 com o objeto resultante da funcao

rownames(BEs_custdist_0.5[[1]][[1]]) #verificando spp que compoe BE1
rownames(BEs_custdist_0.5[[1]][[2]]) #verificando spp que compoe BE2
rownames(BEs_custdist_0.5[[1]][[3]]) #verificando spp que compoe BE3

#A indexacao eh de lista dentro de lista. A lista 1 contem as matrizes de presenca e ausencia por BE; lista 2 contem os grids de cada BE e lista 3 contem as proporcoes de spp por celula em cada BE (caso use prop=TRUE, se n usar o resultado tera apenas as duas primeiras listas).
