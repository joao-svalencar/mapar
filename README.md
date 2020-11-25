# 'mapar'

*First published version released on November 25th of 2020.*

This function allows users to preview in R environment the Biotic Element Analysis (BEA - Hausdorf & Hennig, 2003) output in a easy interactive way. Additionally, users may save the output as a .shp file for further edition in GIS softwares.

Biotic Element Analysis is performed in R environment through package '*prabclus*'. It is based on the comparison of species ranges in order to determine if species ranges are clustered forming distinct biotas. The analysis departs from a presence-absence matrix obtained from the intersection of species ranges and a grid system that represents a given study area. The result of the clustering methods available in the '*prabclus*' package is a data frame with two columns: a) a column with species names; and b) the number that represents the group that a given species compose.

The challenge imposed was related to the mapping process that relied on users: a) to go into a GIS software; b) to plot species ranges of all species assigned to a given biota; c) to intercect these ranges with the original grid system; d) to export the intersected grid cells as a independent .shp file in order to be able to edit them; e) finally, to map the results. Additionally, in some cases users also wanted to highlight specific grid cells with distinct proportions of species within. To do so, users needed: a) to go to a GIS software; b) to plot species ranges of all species assigned to a given biota; c) to manually count the number of species per grid cell and to divide by the total number of species within a given biota to finally obtain a proportion of species per grid cell; d) to edit grid cells individually making differences visible; e) finally, to map the results.

All of these could be time-consuming steps, especially for users who are analysing big datasets in large study areas. Additionally, users who choose to cluster their data with the '*hpraclust*' function usually test alternative parametres within the analysis (usually '*cutdist*' and '*nnout*'), and often relies the decision about the parametres on the "preserving of spatial contiguity of the clusters" that could only be precisely accessed if the steps above were followed. If clusters did not preserved "spatial contiguity", users would need to reanalyse their data with different parametres and would need to follow the above mapping steps again!

With the '*mapar*' function, users need to provide: a) the grid system from which the presence-absence matrix was obtained; b) the presence-absence matrix, with species names in rows and grid IDs in columns (Note that grid IDs must match between grid system and presence-absence matrix); c) the data frame obtained with the clustering analysis available in '*prabclus*', with species names in the first column and the group code in the second column (Note that species names must match between presence-absence matrix and the data frame); and d) the .shp file that represents the study area. 

Besides the data frame, all other objects are needed to the BEA itself and are usually available to use within '*mapar*' (Note that .shp files must be loaded in R as objects of '*sp*' class. A further version of the function will allow '*sf*' class objects as well). On the other hand, different data frames can be loaded to the function and the users can easily access their output without leaving R environment.

A brief description of how to use the function is described below:

### ***Usage:***

mapar(grid, mpa, lsp, plot=FALSE, shp=NULL, prop=FALSE, propcut=0, nsp=1, grp=FALSE)

### ***Arguments:***

**grid**      *SpatialPolygonDataFrame* object with a system of grid cells that represents a given study area.

**mpa**       presence-absence matrix with species names in the rows and grid IDs in the columns (Note that grid IDs must match between grid system and presence-absence matrix).

**lsp**       *data.frame* with two columns. The first column must have species names, the second column must have BEs codes (Note that species names must match between presence-absence matrix and the data frame). 

**plot**      a logical value indicating whether the user wants to preview BEs in R. FALSE leads directly to the interactive decision on to save or not BEs as .shp files.

**shp**       *SpatialPolygonDataFrame* object representing the limits of study area (required if plot = TRUE).

**prop**      a logical value indicating whether the user wants to preview proportions of species per grid cell. Default settings shows cells with <30% of species, 30%-70% of species and >70% of species. A further version will allow users to decide the proportions they want to visualize.

**propcut**   a numerical value between zero and one that indicates whether user wants to "cut" BEs preview to a        especified proportion of species. Ex.: If user wants to see only cells that contain MORE than 30% of species, propcut value should be 0.3.

**nsp**       a numerical value that indicates the minimum number of species required to preview a given grid cell. Ex.: If user wants to preview only the BE cells that have AT LEAST two species, nsp value should be 2

**grp**       a logical value that indicates whether user wants to export ALL BEs in a unique .shp file. FALSE leads to an interactive question on which specific BE the user would like to export. User may choose between one and the number of total BEs detected. If user wants to save ALL BEs as SEPARATED .shp files please, answer "all"  (without quotation marks) to that question.

### ***Details:***

BEA output preview through '*mapar*' demands user interaction. Questions are associated to the number of BEs detected or are of yes/no type. Note that BEA output usually has species assigned to '*noise component*' (identifyed as "0" in the data.frame). If user wants to remove the noise component species prior to running '*mapar*' please use de code:

```
mpa <- mpa[lsp[,1][lsp[,2]!=0],] #removes noise component species from matrix 'mpa'
lsp <- lsp[lsp[2]!=0,] #removes noise component species from data.frame 'lsp'
```

Note that if you want to change the data frame (Ex.: providing a different clustering output), you will have to also reaload 'mpa', as '*noise component*' species may vary between different clustering results.

### ***Value:***

If prop = FALSE, '*mapar*' returns a list with two components:

* **comp1:** List of length N containing individual presence-absence matrices for N BEs.
* **com2:** List of length N containing individual '*SpatialPolygonsDataFrame*' objects related to N BEs.

If prop = TRUE, '*mapar*' returns a list with three components, the two mentioned above and:

* **comp3:** List of length N containing vectors with '*alpha*' values (*col=rgd(r, g, b, alpha)*) related to individual species proportion per grid cell (0.05 for cells with <30%, 0.3 for cells with 30%-70%, 0.7 for cells with <70%. see '*prop*') for N BEs.

### ***Warning:***

* '*mapar*' attributes to *colnames(mpa)* the IDs found in the grid system provided. It is the user's responsability to assure that the presence-abscence matrix was created based on the grid system provided or results might not represent the actual outcome. 

* '*mapar*' uses a standard nomenclature based on BEs codes (provided in '*lsp*') to save .shp files. If the working directory already has a file with the same name (Ex.: after a previous '*mapar*' run) the new outcome will not be saved and the fuction will deliver an error message. The same happens if grp = TRUE and there are multiple runs.

### ***See also:***
* class: *SpatialPolygonDataFrame*

### ***Examples***

Files and codes will be provided further

### ***Aknowledgements***

The author thanks Professor Alexandre Adalardo de Oliveira for high quality classes in R programming. Bruno Travassos de Britto, Filipe Alexandre Cabreirinha Serrano and Juan Camilo Diaz-Ricaurte provided insightful comments and valuable suggestions that improved the function. The author is funded by the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brasil (CAPES) - Finance Code 001.

### ***Author:***

Vieira-Alencar, João Paulo dos Santos (joaopaulo.valencar@usp.br) [Orcid](https://orcid.org/0000-0001-6894-6773)

Ph.D Student at Programa de Pós-graduação em Ecologia

Laboratório de Ecologia, Evolução e Conservação de Vertebrados, Departamento de Ecologia, Universidade de São Paulo, São Paulo/SP - Brasil


