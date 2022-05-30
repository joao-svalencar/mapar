# mapar
### ***Mapping Biotic Elements in R***

[![DOI](https://zenodo.org/badge/316021065.svg)](https://zenodo.org/badge/latestdoi/316021065)

This package is currently composed of two functions: '*mapar*' and '*cdn*'.

The function '*mapar*' allows users to preview in R environment the Biotic Element Analysis (BEA - [Hausdorf & Hennig, 2003](https://doi.org/10.1080/10635150390235584)) output in a easy interactive way. Additionally, users may save the output as a .shp file for further edition in GIS softwares.

The function '*cdn*' provides a table with all possible combinations of *cutdist* and *nnout* regarding the resulting number of Biotic Elements and the number of species assigned to the noise component from the hierarchical clustering analysis performed by `prabclus::hprabclust`. 

Biotic Element Analysis is performed in R environment through package '*prabclus*'. It is based on the comparison of species ranges in order to determine if species ranges are clustered forming distinct biotas. The analysis departs from a presence-absence matrix obtained from the intersection of species ranges and a grid system that represents a given study area. The result of the clustering methods available in the '*prabclus*' package is a data frame with two columns: a) a column with species names; and b) the number that represents the group that a given species compose.

The challenge imposed was related to the mapping process that relied on users: a) to go into a GIS software; b) to plot species ranges of all species assigned to a given biota; c) to intercect these ranges with the original grid system; d) to export the intersected grid cells as a independent .shp file in order to be able to edit them; e) finally, to map the results. Additionally, in some cases users also wanted to highlight specific grid cells with distinct proportions of species within. To do so, users needed: a) to go into a GIS software; b) to plot species ranges of all species assigned to a given biota; c) to manually count the number of species per grid cell and to divide it by the total number of species within a given biota to finally obtain a proportion of species per grid cell; d) to edit grid cells individually making differences visible; e) finally, to map the results.

All of these are time-consuming steps, especially for users who are analysing big datasets in large study areas. Additionally, users who choose to cluster their data with the '*hpraclust*' function usually test alternative parametres within the analysis (usually '*cutdist*' and '*nnout*'), and often relies the decision about the parametres on the number of BEs detected *versus* the number of species assigned to the noise component of the analysis. Additionlly, the final decision about those parametres also rely on the units "preserving of spatial contiguity of the clusters". It could only be precisely accessed if the mapping steps above were followed. If clusters did not preserved "spatial contiguity", users would need to reanalyse their data with different parametres and would need to follow the above mapping steps again!

With the '*mapar*' function, users need to provide: a) the grid system from which the presence-absence matrix was obtained; b) the presence-absence matrix, with species names in rows and grid IDs in columns (Note that grid IDs must match between grid system and presence-absence matrix); c) the data frame obtained with the clustering analysis available in '*prabclus*', with species names in the first column and the group code in the second column (Note that species names must match between presence-absence matrix and the data frame); and d) the .shp file that represents the study area. 

Besides the data frame, all other objects are needed to perform BEA and are usually available to use within '*mapar*' (Note that .shp files must be loaded in R as objects of *sp* class. A further version of the function will allow *sf* class objects as well). On the other hand, different data frames can be loaded to the function and the users can easily access their output without leaving R environment.

For the '*cdn*' function, users just have to provide the *prab* object originated from `prabclus::prabinit` and the parametres that should be passed to `prabclus::hprabclust` in order to preview the number of BEs and species assigned to the noise component for every combination of *cutdist* and *nnout* provided to the fuction (see *Usage*).

A brief description of how to use the functions are described in their `help()` section.

### ***Download***

To install the stable version of this package the user must run:

```{.r}
# install.packages("devtools")
devtools::install_github("joao-svalencar/mapar", ref="main")
```

### ***Next steps***

- [ ] CRAN release
- [ ] Implement compatibility with *sf* objects
- [ ] Implement plot fuction for the object obtained from '*mapar*'
- [ ] Implement the possibility to choose the proportion of species that should be visualised if `prop ==TRUE`

### ***Aknowledgements***

I would like to thank Professor Alexandre Adalardo de Oliveira for high quality classes in R programming. Bruno Travassos de Britto, Filipe Alexandre Cabreirinha Serrano and Juan Camilo Diaz-Ricaurte provided insightful comments and valuable suggestions that improved the function. Finally, I would like to thank Professor Ricardo Jannini Sawaya for exposing the problem and highlighting the importance of this package. The author is funded by the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brasil (CAPES) - Finance Code 001.

### ***Author:***

Vieira-Alencar, João Paulo dos Santos (joaopaulo.valencar@usp.br) [Orcid](https://orcid.org/0000-0001-6894-6773)

Ph.D Candidate at Programa de Pós-graduação em Ecologia

Laboratório de Ecologia, Evolução e Conservação de Vertebrados, Departamento de Ecologia, Universidade de São Paulo, São Paulo/SP - Brasil


