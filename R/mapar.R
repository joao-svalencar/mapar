##########################################################################################################
########################## function mapar by:  JP VIEIRA-ALENCAR  ########################################
##########################################################################################################

#' Mapping Biotic Elements in R 
#' @usage mapar(grid, mpa, lsp, plot=FALSE, shp=NULL, prop=FALSE, propcut=0, nsp=1, grp=FALSE)
#' @param grid SpatialPolygonDataFrame object with a system of grid cells that represents a given study area.
#' @param mpa presence-absence matrix with species names in the rows and grid IDs in the columns (Note that grid IDs must match between grid system and presence-absence matrix).
#' @param lsp data.frame with two columns. The first column must have species names, the second column must have BEs codes (Note that species names must match between presence-absence matrix and the data frame).
#' @param plot a logical value indicating whether the user wants to preview BEs in R. FALSE leads directly to the interactive decision on to save or not BEs as .shp files.
#' @param shp SpatialPolygonDataFrame object representing the limits of study area (required if plot = TRUE).
#' @param prop a logical value indicating whether the user wants to preview proportions of species per grid cell. Default settings shows cells with <30% of species, 30%-70% of species and >70% of species. A further version will allow users to decide the proportions they want to visualize.
#' @param propcut a numerical value between zero and one that indicates whether user wants to "cut" BEs preview to a especified proportion of species. Ex.: If user wants to see only cells that contain MORE than 30% of species, propcut value should be 0.3.
#' @param nsp a numerical value that indicates the minimum number of species required to preview a given grid cell. Ex.: If user wants to preview only the BE cells that have AT LEAST two species, nsp value should be 2.
#' @param grp a logical value that indicates whether user wants to export ALL BEs in a unique .shp file. FALSE leads to an interactive question on which specific BE the user would like to export. User may choose between one and the number of total BEs detected. If user wants to save ALL BEs as SEPARATED .shp files please, answer "all" (without quotation marks) to that question.
#' 
#' @details 
#' BEA output preview through '*mapar*' demands user interaction. Questions are associated to the number of BEs detected or are of yes/no type. Note that BEA output usually has species assigned to 'noise component' (identifyed as "0" in the data.frame). If user wants to remove the '*noise component*' species prior to running '*mapar*' please use de code: 
#' ````
#' mpa <- mpa[lsp[,1][lsp[,2]!=0],] #removes noise component species from matrix 'mpa' 
#' lsp <- lsp[lsp[2]!=0,] #removes noise component species from data.frame 'lsp' 
#' ````
#' Note that if you want to change the data frame (Ex.: providing a different clustering output), you will have to also reaload 'mpa', as '*noise component*' species may vary between different clustering results.
#' 
#' @seealso class: SpatialPolygonDataFrame
#' 
#' @return If prop = FALSE, '*mapar*' returns a list with two components:
#' * comp1: List of length N containing individual presence-absence matrices for N BEs.
#' * comp2: List of length N containing individual '_SpatialPolygonsDataFrame_' objects related to N BEs.
#' 
#' If prop = TRUE, '_mapar_' returns a list with three components, the two mentioned above and:
#' * comp3: List of length N containing vectors with '_alpha_' values (`col=rgd(r, g, b, alpha)`) related to individual species proportion per grid cell (0.05 for cells with <30%, 0.3 for cells with 30%-70%, 0.7 for cells with <70%. see '_prop_') for N BEs.
#' 
#' @references 
#' Hausdorf, B. & Hennig, C. (2003) Biotic Element Analysis in Biogeography. *Systematic Biology*, 52(5):717-723 https://doi.org/10.1080/10635150390235584
#' 
#' @export
#'

mapar <- function(grid, mpa, lsp, plot=FALSE, shp=NULL, prop=FALSE, propcut=0, nsp=1, grp=FALSE) #naming function and setting defauts
{
  #modifying essential data for properly functioning
  colnames(mpa) <- sort(as.numeric(as.character(grid@data[["id"]]))) #attributing grid IDs to presence-absence matrix colnames
  lsp[1] <- as.character(lsp[,1]) #attributing "character" class to species column
  
  ###########################################################################################
  ##################################### If tests ############################################
  ###########################################################################################
  
  ##### matrix's if's  #####
  
  if(is.null(row.names(mpa))) #verifying if there are names in matrix rows
  {
    stop("mpa rownmaes absent, fix to continue") #stops function and gives a warning
  }
  if(sum(is.na(mpa))>=1) #veryfing matrix for NA data
  {
    stop("NA's detected within the matrix, fix to continue") #stops function and give a warning
  }
  
  ##### spp list and areas if's #####
  
  if(class(lsp)!= 'data.frame') #verifying species list and areas object class, should be data.frame
  {
    stop("lsp is not a data.frame, fix to continue") #stops function and give a warning
  }
  
  ##### combination if's #####
  if(sum(sort(row.names(mpa)) != sort(lsp[,1]))>=1) #comparing species names within lsp and mpa, should be the same
  {
    stop("Species names differ between mpa and lsp, fix to continue") #stops function and give a warning
  }
  if(sum(as.numeric(colnames(mpa)) %in% grid@data[['id']])<length(colnames(mpa))) #comparing grid IDs between grid system and mpa
  {
    stop("Grid IDs differ between grid system and mpa, fix to continue") #stops function and give a warning
  }
  
  ##########################################################################################
  ################################ function development ####################################
  ##########################################################################################
  
  areas <- list() #creates an empty list named "areas"
  map.ar <- list()#creates an empty list named "map.ar"
  
  if(is.numeric(lsp[,2])) #if for numeric areas codes
  {
    for(i in 1:nrow(unique(lsp[2]))) #fills lists with unique areas names
    {
      areas[[i]] <- mpa[as.character(lsp[,1][lsp[,2] == sort(unique(lsp[,2]))[i]]),] #assign distinct species groups to distinct list areas positions
      map.ar[[i]] <- grid[which(grid@data[["id"]]%in%names(which(apply(areas[[i]], 2, sum)>=nsp))),] #creates individualized grids related to each groups' species occurrences
    }
  }else{
    
    for(i in 1:nrow(unique(lsp[2]))) #else for character areas codes
    {
      areas[[i]] <- mpa[as.character(lsp[,1][lsp[,2] == gtools::mixedsort(unique(lsp[,2]))[i]]),] #assign distinct species groups to distinct list areas positions
      map.ar[[i]] <- grid[which(grid@data[["id"]]%in%names(which(apply(areas[[i]], 2, sum)>=nsp))),] #creates individualized grids related to each groups' species occurrences
    }
  }
  
  per <- list() #creates an empty list to receive species percentages/cell informations
  
  for(i in 1:length(areas)) #createas a looping with length equal to the number of areas
  {
    n <- apply(areas[[i]], 2, sum) #sum species per cell in area "i"
    m <- length(rownames(areas[[i]])) #attributing to "m" the total number of species in area "i"
    per[[i]] <- n[n!=0]/m #fills empty list with percentage values per cell in each group
  }
  
  for(i in 1:length(per)) #looping to adjust percentages to 0, 0.3 and 0.7
  {
    per[[i]][per[[i]]<0.3] <- 0.05 #all values smaller than 0.3 converted to 0.05
    per[[i]][per[[i]]>=0.3 & per[[i]] < 0.7] <- 0.3 #all values between 0.3 and 0.69 converted to 0.3
    per[[i]][per[[i]]>=0.7] <- 0.7 #all values equals to or smaller than 0.7 converted to 0.7
  }
  
  for(i in 1:length(map.ar)) #looping to add "per" values to grid cells
  {
    map.ar[[i]]$per <- per[[i]]
  }
  
  ###########################################################################################################  
  ############################### user interaction: areas plots  ############################################
  ###########################################################################################################    
  if(plot==TRUE) #plot conditional
  {
    if(is.null(shp)) #did user provide study area .shp file?
    {
      stop("study area .shp file not detected, fix to continue") #stops function and gives a warning
    }else{
      
      graphics::par(mar=c(0.1,0.1,1,0.1)) #adjusting plot margins
      
      Q2='y' #defining "while" cycle
      while(Q2 == 'y'| Q2 == 'Y') #Does user want to preview another area?
      {
        Q1 <- readline(prompt=cat('\n', length(map.ar), '\ Areas detected. Which area would you like to preview? ')) #informing number of areas available to plot and asking which one the user would like to preview
        
        if(as.numeric(Q1) %in% 1:length(map.ar)) #checking if area number are provided
        {
          if(prop==FALSE) #conditional to DO NOT plot species percentage
          {
            if(is.character(lsp[,2])==TRUE) #conditional to "character" areas codes
            {
              sp::plot(shp, main=paste('Area', gtools::mixedsort(unique(lsp[,2]))[as.numeric(Q1)], sep=' '), cex.main=1.3) #study area plot
              sp::plot(map.ar[[as.numeric(Q1)]][map.ar[[as.numeric(Q1)]]$per>=propcut,], add=TRUE, col=grDevices::rgb(0,0,1, 0.3)) #plots selected area WITHOUT species percentages/cell; attention to propcut
              cat("\nSpecies composition of Area", gtools::mixedsort(unique(lsp[,2]))[as.numeric(Q1)], ":\n \n")
              print(rownames(areas[[as.numeric(Q1)]])) #preview species composition
            }else{ #contional to "numeric" areas codes
              sp::plot(shp, main=paste('Area', sort(unique(lsp[,2]))[as.numeric(Q1)], sep=' '), cex.main=1.3) #study area plot
              sp::plot(map.ar[[as.numeric(Q1)]][map.ar[[as.numeric(Q1)]]$per>=propcut,], add=TRUE, col=grDevices::rgb(0,0,1, 0.3)) #plots selected area WITHOUT species percentages/cell; attention to propcut
              cat("\nSpecies composition of Area", gtools::mixedsort(unique(lsp[,2]))[as.numeric(Q1)], ":\n \n")
              print(rownames(areas[[as.numeric(Q1)]])) #preview species composition
            }
          }else{ #contitional TO PLOT species percentages
            if(is.character(lsp[,2])==TRUE) #conditional to "character" areas codes
            {  
              sp::plot(shp, main=paste('Area', gtools::mixedsort(unique(lsp[,2]))[as.numeric(Q1)], sep=' '), cex.main=1.3) #study area plot
              sp::plot(map.ar[[as.numeric(Q1)]][map.ar[[as.numeric(Q1)]]$per>=propcut,], add=TRUE, col=grDevices::rgb(0,0,1, alpha=per[[as.numeric(Q1)]][match(map.ar[[as.numeric(Q1)]][map.ar[[as.numeric(Q1)]]$per>=propcut,]@data[["id"]], names(per[[as.numeric(Q1)]]))])) #plots selected area WITH species percentages/cell; attention to propcut
              cat("\nSpecies composition of Area", gtools::mixedsort(unique(lsp[,2]))[as.numeric(Q1)], ":\n \n")
              print(rownames(areas[[as.numeric(Q1)]])) #preview species composition
            }else{ #contional to "numeric" areas codes
              sp::plot(shp, main=paste('Area', sort(unique(lsp[,2]))[as.numeric(Q1)], sep=' '), cex.main=1.3) #study area plot
              sp::plot(map.ar[[as.numeric(Q1)]][map.ar[[as.numeric(Q1)]]$per>=propcut,], add=TRUE, col=grDevices::rgb(0,0,1, alpha=per[[as.numeric(Q1)]][match(map.ar[[as.numeric(Q1)]][map.ar[[as.numeric(Q1)]]$per>=propcut,]@data[["id"]], names(per[[as.numeric(Q1)]]))])) #plots selected area WITH species percentages/cell; attention to propcut
              cat("\nSpecies composition of Area", gtools::mixedsort(unique(lsp[,2]))[as.numeric(Q1)], ":\n \n")
              print(rownames(areas[[as.numeric(Q1)]])) #preview species composition
            }
          } #closes plot == FALSE "else"
        }else{ #conditional to non-avalible area number
          cat('\nArea', as.numeric(Q1), 'not found. Choose areas between 1 e', length(map.ar), '\n') #gives a warning and request for a valid area number
        }
        Q2 <- readline(prompt=cat('\nWould you like to preview another area? y/n ')) #Allows user to preview another area
        if(Q2 != 'y' & Q2 != 'n' & Q2 != 'Y' & Q2 != 'N') #conditional to plot another area
        {
          stop("Invalid entry, mapar finished.") #stops function and gives a warning
        }
      } #closes "while" plots
    } #closes "else" to .shp file detection
  }else{
  } #closes plot == TRUE conditional
  
  ###########################################################################################################  
  #################################### saving areas as .shp files ###########################################
  ###########################################################################################################
  
  if(grp == TRUE) #conditional to group all areas in a unique .shp file
  {
    allar <- map.ar[[1]] #creates object "allar" and attributes map.ar first position allowing to add subsequent areas with 'for'
    for(i in 2:length(map.ar)) #looping from 2 to map.ar's length
    {
      allar <- rbind(allar, map.ar[[i]]) #combines SpatialPoligonsDataFrame keeping class' proprieties using 'cbind'
    }
    
    if(is.character(lsp[,2])==TRUE) #conditional to "character" areas codes
    {
      df.info <- c(rep(paste(gtools::mixedsort(unique(lsp[,2]))[1]), times=length(map.ar[[1]]))) #creates a vector with area 1 code repetitions equivalent to number of grid cells of area 1
      for(i in 2:length(map.ar)) #looping de 2 ao lenght de map.ar
      {
        df.info <- c(df.info, rep(paste(gtools::mixedsort(unique(lsp[,2]))[i], sep=' '), times=length(map.ar[[i]]))) #creates vectors with remaining areas codes equivalent to number of grid cells in each area
      }
    }else{ #conditional to "numeric" areas codes
      df.info <- c(rep(paste(gtools::mixedsort(unique(lsp[,2]))[1]), times=length(map.ar[[1]]))) #creates a vector with area 1 code repetitions equivalent to number of grid cells of area 1
      for(i in 2:length(map.ar)) #looping de 2 ao lenght de map.ar
      {
        df.info <- c(df.info, rep(paste(gtools::mixedsort(unique(lsp[,2]))[i], sep=' '), times=length(map.ar[[i]]))) #creates vectors with remaining areas codes equivalent to number of grid cells in each area
      }
    }
    allar@data$cod.areas <-  df.info #creates a new column to combined areas SpatialPolygonsDataFrame and attributes the data created above to column "cod.areas"
    
    rgdal::writeOGR(allar, dsn=getwd(), layer = 'map.areas', driver="ESRI Shapefile") #saves object as a .shp file with a column to classify and edit areas
    paste(cat('\nAll areas saved in a unique .shp file named map.areas.shp \n\nMapar finished\n\n')) #informs that a .shp file was created and announces the end of user interaction
    
  }else{#conditional to save areas in separated .shp files
    
    Q3 <- readline(prompt=cat('\nWould you like to save any area as a .shp file? y/n ')) #allows to save areas separately
    if(Q3 != 'y' & Q3 != 'n' & Q3 != 'Y' & Q3 != 'N') #conditional to possible Q3 answers
    {
      stop("Invalid entry, mapar finished.") #stops function and gives a warning
    }
    if(Q3 == 'y'| Q3 == 'Y') #conditional to save areas separately 
    {
      Q4 <- readline(prompt=cat('\nWhich area would you like to save as a .shp file?')) #gives option to choose individual area
      if(Q4 == 'all' | Q4 == 'ALL' | Q4 == 'All') #conditional to save all areas separately
      {
        if(is.character(lsp[,2])==TRUE) #conditional to "character" areas codes
          {
            for(i in 1:length(map.ar)) #creates looping of length equals to total areas number
            {
            rgdal::writeOGR(map.ar[[i]], dsn=getwd(), layer = paste('Area', gtools::mixedsort(unique(lsp[,2]))[i], sep=' '), driver="ESRI Shapefile") #creates individual .shp files to each area
            }
          paste(cat('\nAll areas saved as separated .shp files \n\nMapar finished\n\n')) #informs that a .shp file was created to each area separately and announces the end of user interaction
          }else{#conditional to "numeric" areas codes
            for(i in 1:length(map.ar)) #creates looping of length equals to total areas number
            {
              rgdal::writeOGR(map.ar[[i]], dsn=getwd(), layer = paste('Area', gtools::mixedsort(unique(lsp[,2]))[i], sep=' '), driver="ESRI Shapefile") #creates individual .shp files to each area
            }
          paste(cat('\nAll areas saved as separated .shp files \n\nMapar finalizada\n\n')) #informs that a .shp file was created to each area separately and announces the end of user interaction
          }
      }else{#conditional to areas saved individually
        if(is.character(lsp[,2])==TRUE)#conditional to "character" areas codes
          {
          rgdal::writeOGR(map.ar[[as.numeric(Q4)]], dsn=getwd(), layer = paste('Area', gtools::mixedsort(unique(lsp[,2]))[as.numeric(Q4)], sep=' '), driver="ESRI Shapefile") #creates .shp file with area choosen
          paste(cat(paste('\nArea', gtools::mixedsort(unique(lsp[,2]))[as.numeric(Q4)], sep=' '), 'saved as .shp file', '\n\nMapar finished\n\n')) #informs which area was saved individually and announces the end of user interaction
          }else{#conditional to "numeric" areas codes
        rgdal::writeOGR(map.ar[[as.numeric(Q4)]], dsn=getwd(), layer = paste('Area', gtools::mixedsort(unique(lsp[,2]))[as.numeric(Q4)], sep=' '), driver="ESRI Shapefile") #creates .shp file with area choosen
        paste(cat(paste('\nArea', gtools::mixedsort(unique(lsp[,2]))[as.numeric(Q4)], sep=' '), 'saved as .shp file', '\n\nMapar finished\n\n')) #informs which area was saved individually and announces the end of user interaction
        }
      }
    }else{
      cat('\nMapar finished\n\n') #Announces the end of the function
    }
  }
  
  ###########################################################################################################  
  ################### finishing function and determining return #############################################
  ###########################################################################################################
  
  if(is.null(per)) #conditional to return only areas e map.ar objects
  {
    return(list(areas, map.ar)) #finishing function and returning objects areas e map.ar
  }else{ #conditional to return areas, map.ar and per
    return(list(areas, map.ar, per))  #finishing function and returning objects areas, map.ar and per
  }#closes last conditionals
  
}#closes everything

###########################################################################################################
######################################### End of the function #############################################
###########################################################################################################
