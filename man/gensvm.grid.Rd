% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gensvm.grid.R
\name{gensvm.grid}
\alias{gensvm.grid}
\title{Cross-validated grid search for GenSVM}
\usage{
gensvm.grid(
  x,
  y,
  param.grid = "tiny",
  refit = TRUE,
  scoring = NULL,
  cv = 3,
  verbose = 0,
  return.train.score = TRUE
)
}
\arguments{
\item{x}{training data matrix. We denote the size of this matrix by 
n_samples x n_features.}

\item{y}{training vector of class labels of length n_samples. The number of 
unique labels in this vector is denoted by n_classes.}

\item{param.grid}{String (\code{'tiny'}, \code{'small'}, or \code{'full'}) 
or data frame with parameter configurations to evaluate.  Typically this is 
the output of \code{expand.grid}. For more details, see "Using a Parameter 
Grid" below.}

\item{refit}{boolean variable. If true, the best model from cross validation 
is fitted again on the entire dataset.}

\item{scoring}{metric to use to evaluate the classifier performance during 
cross validation. The metric should be an R function that takes two 
arguments: y_true and y_pred and that returns a float such that higher 
values are better. If it is NULL, the accuracy score will be used.}

\item{cv}{the number of cross-validation folds to use or a vector with the 
same length as \code{y} where each unique value denotes a test split.}

\item{verbose}{integer to indicate the level of verbosity (higher is more 
verbose)}

\item{return.train.score}{whether or not to return the scores on the 
training splits}
}
\value{
A "gensvm.grid" S3 object with the following items:
\item{call}{Call that produced this object}
\item{param.grid}{Sorted version of the parameter grid used in training}
\item{cv.results}{A data frame with the cross validation results}
\item{best.estimator}{If refit=TRUE, this is the GenSVM model fitted with 
the best hyperparameter configuration, otherwise it is NULL}
\item{best.score}{Mean cross-validated test score for the model with the 
best hyperparameter configuration}
\item{best.params}{Parameter configuration that provided the highest mean 
cross-validated test score}
\item{best.index}{Row index of the cv.results data frame that corresponds to 
the best hyperparameter configuration}
\item{n.splits}{The number of cross-validation splits}
\item{n.objects}{The number of instances in the data}
\item{n.features}{The number of features of the data}
\item{n.classes}{The number of classes in the data}
\item{classes}{Array with the unique classes in the data}
\item{total.time}{Training time for the grid search}
\item{cv.idx}{Array with cross validation indices used to split the data}
}
\description{
This function performs a cross-validated grid search of the 
model parameters to find the best hyperparameter configuration for a given 
dataset. This function takes advantage of GenSVM's ability to use warm 
starts to speed up computation. The function uses the GenSVM C library for 
speed.
}
\note{
1. This function returns partial results when the computation is interrupted 
by the user.
2. The score.time reported in the results only covers the time needed to 
compute the score from the predictions and true class labels. It does not 
include the time to compute the predictions themselves.
}
\section{Using a Parameter Grid}{

To evaluate certain parameter configurations, a data frame can be supplied 
to the \code{param.grid} argument of the function. Such a data frame can 
easily be generated using the R function \code{expand.grid}, or could be 
created through other ways to test specific parameter configurations.

Three parameter grids are predefined:
\describe{
\item{\code{'tiny'}}{This parameter grid is generated by the function 
\code{\link{gensvm.load.tiny.grid}} and is the default parameter grid. It 
consists of parameter configurations that are likely to perform well on 
various datasets.}
\item{\code{'small'}}{This grid is generated by 
\code{\link{gensvm.load.small.grid}} and generates a data frame with 90 
configurations. It is typically fast to train but contains some 
configurations that are unlikely to perform well. It is included for 
educational purposes.}
\item{\code{'full'}}{This grid loads the parameter grid as used in the 
GenSVM paper. It consists of 342 configurations and is generated by the 
\code{\link{gensvm.load.full.grid}} function. Note that in the GenSVM paper 
cross validation was done with this parameter grid, but the final training 
step used \code{epsilon=1e-8}. The \code{\link{gensvm.refit}} function is 
useful in this scenario.}
}

When you provide your own parameter grid, beware that only certain column 
names are allowed in the data frame corresponding to parameters for the 
GenSVM model. These names are:

\describe{
\item{p}{Parameter for the lp norm. Must be in [1.0, 2.0].}
\item{kappa}{Parameter for the Huber hinge function. Must be larger than 
-1.}
\item{lambda}{Parameter for the regularization term. Must be larger than 0.}
\item{weights}{Instance weights specification. Allowed values are "unit" for 
unit weights and "group" for group-size correction weights}
\item{epsilon}{Stopping parameter for the algorithm. Must be larger than 0.}
\item{max.iter}{Maximum number of iterations of the algorithm. Must be 
larger than 0.}
\item{kernel}{The kernel to used, allowed values are "linear", "poly", 
"rbf", and "sigmoid". The default is "linear"}
\item{coef}{Parameter for the "poly" and "sigmoid" kernels. See the section 
"Kernels in GenSVM" in the code{ink{gensvm-package}} page for more info.}
\item{degree}{Parameter for the "poly" kernel. See the section "Kernels in 
GenSVM" in the code{ink{gensvm-package}} page for more info.}
\item{gamma}{Parameter for the "poly", "rbf", and "sigmoid" kernels. See the 
section "Kernels in GenSVM" in the code{ink{gensvm-package}} page for more 
info.}
}

For variables that are not present in the \code{param.grid} data frame the 
default parameter values in the \code{\link{gensvm}} function will be used.

Note that this function reorders the parameter grid to make the warm starts 
as efficient as possible, which is why the param.grid in the result will not 
be the same as the param.grid in the input.
}

\examples{
x <- iris[, -5]
y <- iris[, 5]

\donttest{
# use the default parameter grid
grid <- gensvm.grid(x, y, verbose=TRUE)
}

# use a smaller parameter grid
pg <- expand.grid(p=c(1.0, 1.5, 2.0), kappa=c(-0.9, 1.0), epsilon=c(1e-3))
grid <- gensvm.grid(x, y, param.grid=pg)

# print the result
print(grid)

\donttest{
# Using a custom scoring function (accuracy as percentage)
acc.pct <- function(yt, yp) { return (100 * sum(yt == yp) / length(yt)) }
grid <- gensvm.grid(x, y, scoring=acc.pct)

# With RBF kernel and very verbose progress printing
pg <- expand.grid(kernel=c('rbf'), gamma=c(1e-2, 1e-1, 1, 1e1, 1e2),
                  lambda=c(1e-8, 1e-6), max.iter=c(5000))
grid <- gensvm.grid(x, y, param.grid=pg, verbose=2)
}

}
\references{
Van den Burg, G.J.J. and Groenen, P.J.F. (2016). \emph{GenSVM: A Generalized 
Multiclass Support Vector Machine}, Journal of Machine Learning Research, 
17(225):1--42. URL \url{https://jmlr.org/papers/v17/14-526.html}.
}
\seealso{
\code{\link{predict.gensvm.grid}}, \code{\link{print.gensvm.grid}}, 
\code{\link{plot.gensvm.grid}}, \code{\link{gensvm}}, 
\code{\link{gensvm-package}}
}
\author{
Gerrit J.J. van den Burg, Patrick J.F. Groenen \cr
Maintainer: Gerrit J.J. van den Burg <gertjanvandenburg@gmail.com>
}
