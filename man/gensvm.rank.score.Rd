% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gensvm.grid.R
\name{gensvm.rank.score}
\alias{gensvm.rank.score}
\title{Compute the ranks for the numbers in a given vector}
\usage{
gensvm.rank.score(x)
}
\arguments{
\item{x}{array of numeric values}
}
\value{
array with the ranks of the values in the input array.
}
\description{
This function computes the ranks for the values in an array. 
The highest value gets the smallest rank. Ties are broken by assigning the 
smallest value. The smallest rank is 1.
}
