#' Random Forest of Max Margin Interval Tree
#'
#' Learning a random forest of Max Margin Interval Tree.
#' 
#' 
#' @param feature.mat a data frame containing the feature variables in the model.
#' @param target.mat The response variable of the model
#' @param margin margin hyperparameter
#' @param loss The type of loss; (\code{"hinge"}, \code{"square"})
#' @param max_depth The maximum depth of each tree
#' @param min_sample The minimum number of samples required to partition a leaf in a tree
#' @param n_trees The number of trees in the ensemble (forest)
#' @param n_features The number of features to be used to train each tree
#' @param future.seed A logical or an integer (of length one or seven), or a list of length(X) with pre-generated random seeds. 
#' 
#' @return List of trees containing each tree in the random forest.
#' 
#' @author Toby Dylan Hocking, Alexandre Drouin, Torsten Hothorn, Parismita Das
#' 
#' @examples
#' library(mmit)
#'
#' target.mat <- rbind(
#'   c(0,1), c(0,1), c(0,1),
#'   c(2,3), c(2,3), c(2,3))
#' 
#' feature.mat <- rbind(
#'   c(1,0,0), c(1,1,0), c(1,2,0),
#'   c(1,3,0), c(1,4,0), c(1,5,0))
#' 
#' colnames(feature.mat) <- c("a", "b", "c")
#' feature.mat <- data.frame(feature.mat)
#' 
#' set.seed(1)
#' trees <- mmif(feature.mat, target.mat, margin = 2.0, future.seed = TRUE)
#' 
mmif <- function(feature.mat, target.mat, 
                           max_depth = Inf, margin=0.0, loss="hinge",
                           min_sample = 1, n_trees = 10,
                           n_features =  ceiling(ncol(feature.mat)**0.5), future.seed = FALSE){
  
  #lapply parallel or sequencial
  Lapply <- if(requireNamespace("future.apply")){ 
    future.apply::future_lapply 
  }
  else{ lapply }
  
  all_trees <- list()
    
  ### create n_trees
  all_trees <- Lapply(1 : n_trees, function(x) .random_tree(target.mat, feature.mat, 
                  max_depth = max_depth, margin = margin, loss = loss,
                  min_sample = min_sample, n_trees = n_trees,
                  n_features = n_features), future.seed = future.seed)
    
  class(all_trees) <- "mmif"
  return(all_trees)
  
}


.random_tree <- function(target.mat, feature.mat, 
                        max_depth, margin, loss,
                        min_sample, n_trees ,
                        n_features){
  
  ### sample n_examlple elements of dataset
  x <- sample(nrow(feature.mat), nrow(feature.mat), replace = TRUE)
  new_feature.mat <- feature.mat[x, ]
  new_target.mat <- target.mat[x,]
  new_target.mat <- data.matrix(new_target.mat)
  
  ### if user assigned n_feature value is one
  assert_that(n_features > 1)
  assert_that(ncol(feature.mat) >= n_features)
  
  ### sample features
  y <- sample(ncol(feature.mat), n_features)
  new_feature.mat <- new_feature.mat[, y]
  colnames(new_feature.mat) <- c(names(feature.mat)[y])
  new_feature.mat <- data.frame(new_feature.mat)
  
  ### tree
  tree <- mmit(new_feature.mat, new_target.mat, margin = margin, loss = loss, 
               min_sample = min_sample, max_depth = max_depth)

  return(tree)
}
