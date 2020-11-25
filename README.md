# mapar

First published version released on November 25th of 2020.

'mapar' is a R function developed by the Ecology Ph.D. student at Universidade de São Paulo (USP) João Paulo dos Santos Vieira de Alencar.

This function allows users to preview in R environment the Biotic Element Analysis (BEA - Hausdorf & Hennig, 2003) output in a easy interactive way. Additionally, users may save the output as a .shp file for further edition in GIS softwares.

Biotic Element Analysis is performed in R environment through package 'prabclus'. It is based on the comparison of species ranges in order to determine if species ranges are clustered forming distinct biotas. The analysis departs from a presence-absence matrix obtained from the intersection of species ranges and a grid system that represents a given study area. The result of the clustering methods available in the 'prabclus' package is a data frame with two columns: a) a column with species names; and b) the number that represents the group that a given species compose.

The challenge imposed were related to the mapping process that relied on users: a) to go into a GIS software; b) to plot species ranges of all species assigned to a given biota; c) to intercept these ranges with the original grid system; d) to export the intersected grid cells as a independent .shp file in order to be able to edit them; e) finally, to map the results. Additionally, in some cases users also wanted to highlight specific grid cells with distinct proportions of species within. To do so, users needed: a) to go to a GIS software; b) to plot species ranges of all species assigned to a given biota; c) to manually count the number of species per grid cell and to divide by the total number of species within a given biota to finally obtain a proportion of species per grid cell; d) to edit grid cells individually making differences visible; e) finally, to map the results.

All of these could be time-consuming steps, especially for users who are analysing big datasets in large study areas. Additionally, users who choose to cluster their data with the 'hpraclust' function usually test alternative parametres within the analysis (usually 'cutdist' and 'nnout'), and often relies the decision about the parametres on the "preserving of spatial contiguity of the clusters" that could only be precisely accessed if the steps above were followed. If clusters did not preserved "spatial contiguity", users would need to reanalyse their data with different parametres and would need to follow the mapping steps above again!

With the 'mapar' function, users need to provide: a) the grid system from which the presence-absence matrix was obtained; b) the presence-absence matrix, with species names in rows and grid IDs in columns (Note that grid IDs must match between grid system and presence-absence matrix); c) the data frame obtained with the clustering analysis available in 'prabclus', with species names in the first column and the group code in the second column (Note that species names must match between presence-absence matrix and the data frame); and d) the .shp file that represents the study area. 

Besides the data frame, all other objects are needed to the BEA itself and are usually available to use within 'mapar' (Note that .shp files must be loaded in R as objects of 'sp' class. A further version of the function will allow 'sf' class objects as well). On the other hand, different data frames can be loaded to the function and the users can easily access their output without leaving R environment.

A brief description of how to use the function is described below:


