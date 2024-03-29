% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cor.R
\name{cortest}
\alias{cortest}
\alias{row_cor_pearson}
\alias{col_cor_pearson}
\title{Correlation}
\usage{
row_cor_pearson(x, y, alternative = "two.sided", conf.level = 0.95)

col_cor_pearson(x, y, alternative = "two.sided", conf.level = 0.95)
}
\arguments{
\item{x}{numeric matrix.}

\item{y}{numeric matrix for the second group of observations.}

\item{alternative}{alternative hypothesis to use for each row/column of x.
A single string or a vector with value for each observation.
Must be one of "two.sided" (default), "greater" or "less".}

\item{conf.level}{confidence levels used for the confidence intervals.
A single number or a numeric vector with value for each observation.
All values must be in the range of [0;1] or NA.}
}
\value{
a data.frame where each row contains the results of a correlation
test performed on the corresponding row/column of x.\cr\cr
Each row contains the following information (in order):\cr
1. obs.paired - number of paired observations (present in x and y)\cr
2. cor - estimated correlation coefficient\cr
3. df - degrees of freedom\cr
4. statistic - t statistic\cr
5. pvalue - p-value\cr
6. conf.low - lower confidence interval\cr
7. conf.high - higher confidence interval\cr
8. alternative - chosen alternative hypothesis\cr
9. cor.null - correlation of the null hypothesis (=0)\cr
10. conf.level - chosen confidence level
}
\description{
Performs a correlation test on each row/column of a the input matrix.
}
\details{
Functions to perform various correlation tests for rows/columns of matrices.
Main arguments and results were intentionally matched to the \code{cor.test()}
function from default stats package.

\code{row_cor_pearson(x, y)} - test for Pearson correlation on rows.
\code{col_cor_pearson(x, y)} - test for Pearson correlation on columns.

Results should be the same as running \code{cor.test(x, y, method="pearson")}
on every row (or column) of \code{x} and \code{y}.
}
\note{
For a marked increase in computation speed turn off the calculation of
confidence interval by setting \code{conf.level} to NA.
}
\examples{
X <- iris[iris$Species=="setosa",1:4]
Y <- iris[iris$Species=="virginica",1:4]
col_cor_pearson(X, Y)
row_cor_pearson(t(X), t(Y))

}
\seealso{
\code{cor.test()}
}
\author{
Karolis Koncevičius
}
