##########################################################################################################
########################### function cdn by:  JP VIEIRA-ALENCAR  #########################################
##########################################################################################################

#' cutdist/nnout table for hierarchical clustering method `prabclus::hprabclust`
#'
#' @description `cdn()` has been developed to improve the process of analysing different combinations of _cutdist_ and _nnout_ values passed to `prabclus::hprabclust()`, the hierarchical clustering method applied in Biotic Element Analyses
#' @usage cdn(x= NULL, cd=c(0.1, 0.5, 0.05), n=c(1, 5), spp_list=NULL, 
#' cutout=1, method="average", mdsmethod="classical")
#' @param x A _prab_ object obtained from `prabclus::prabinit`.
#' @param cd A vector containing three numerical objects to be passed to `seq(from, to, by)` as: 1. (from) smaller cutdist value, 2. (to) larger cutdist value, and 3. increment of the sequence.
#' @param n A vector containing two numerical objects to be passed to `seq(from,to)` as: 1. (from) smaller nnout value, 2. (to) larger nnout value.
#' @param spp_list A data frame with one column containg the species names present in the _prab_ object.
#' @param cutout See _cutout_ in `?prabclus::hprabclust`.
#' @param method See _method_ in `?prabclus::hprabclust`.
#' @param mdsmethod See _mdsmethod_ in `?prabclus::hprabclust`.
#'
#' @return Returns a data.frame with the number of Biotic Elements and number of species assigned to the noise component for every cutdist/nnout combination given by the sequences created from the values provided in _cd_ and _n_.
#' @export
#'

cdn <- function(x= NULL, cd=c(0.1, 0.5, 0.05), n=c(1, 5), spp_list=NULL, cutout=1, method="average", mdsmethod="classical")
{
  ################################################ IFs ERRORS SECTION ####################################################
  if(is.null(x))
  {
    stop("Prab object not found")
  }
  
  if(is.null(spp_list)) #verifying if there are names in matrix rows
  {
    stop("No species list found, can't combine with hprabclust result") #stops function and gives a warning
  }
  ########################################################################################################################

  ############################################## IFs PARAMETERS SECTION ##################################################
  if(length(cd)>1)
  {
    cdist <- seq(from=cd[1], to=cd[2], by=cd[3])
  }else{
    cdist <- cd
  }
  
  if(length(n)>1)
  {
    nnout <- seq(from=n[1], to=n[2])
  }else{
    nnout <- n
  }
  #######################################################################################################################
  
  #############################################################################################################################
  ################################################### FUNCTION DEVELOPMENT ###################################################
  #############################################################################################################################
  
    Noise <- c()
    BEs <- c()
    Prop <- c()
    null <- rep("", times = length(cdist))
    cdn_table_l <- list()
    cdn_table_df <- data.frame()
    for(a in 1:length(nnout))
      {
          for(i in cdist)
          {
            hier <- prabclus::hprabclust(x, cutdist = i, cutout=cutout, method=method, nnout=nnout[a], mdsplot=FALSE, mdsmethod=mdsmethod)
            hier.l <- cbind(spp_list, hier$rclustering)
            for(j in 1:length(cdist))
            {
              Noise[which(dplyr::near(cdist, i))] <- table(hier.l[2])[1]
              BEs[which(dplyr::near(cdist, i))] <- max(hier.l[2])
              Prop[which(dplyr::near(cdist, i))] <- round(table(hier.l[2])[1]/max(hier.l[2]), digits=2)
            }
          }
          cdist_table <- data.frame(Noise, BEs, Prop, null)
          cdist_table <- t(cdist_table)
          colnames(cdist_table) <- cdist
          
          ### list to print ###
          cdn_table_l[[a]] <- cdist_table[-4,]
          names(cdn_table_l)[[a]] <- paste("NNOUT=", nnout[a], sep='')
          
          ### df to return ###
          row.names(cdist_table) <- c(paste("Noise", "[", a, "]"), 
                                      paste("BEs", "[", a, "]"), 
                                      paste("Prop", "[", a, "]"), 
                                      paste("NNOUT", a, "#######"))
          cdn_table_df <- rbind(cdn_table_df, cdist_table)
    }
    print(cdn_table_l)
    return(cdn_table_l)
}

#############################################################################################################################
###################################################### END OF FUNCTION ######################################################
#############################################################################################################################