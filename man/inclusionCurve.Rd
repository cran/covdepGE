% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots.R
\name{inclusionCurve}
\alias{inclusionCurve}
\title{Plot PIP as a Function of Index}
\usage{
inclusionCurve(
  out,
  col_idx1,
  col_idx2,
  line_type = "solid",
  line_size = 0.5,
  line_color = "black",
  point_shape = 21,
  point_size = 1.5,
  point_color = "#500000",
  point_fill = "white"
)
}
\arguments{
\item{out}{object of class \code{covdepGE}; return of \code{covdepGE} function}

\item{col_idx1}{integer in \eqn{[1, p]}; column index of the first variable}

\item{col_idx2}{integer in \eqn{[1, p]}; column index of the second variable}

\item{line_type}{linetype; \code{ggplot2} line type to interpolate the
probabilities. \code{"solid"} by default}

\item{line_size}{positive numeric; thickness of the interpolating line.
\code{0.5} by default}

\item{line_color}{color; color of interpolating line. \code{"black"} by default}

\item{point_shape}{shape; shape of the points denoting observation-specific
inclusion probabilities; \code{21} by default}

\item{point_size}{positive numeric; size of probability points. \code{1.5} by
default}

\item{point_color}{color; color of probability points. \code{"#500000"} by default}

\item{point_fill}{color; fill of probability points. Only applies to select
shapes. \code{"white"} by default}
}
\value{
Returns \code{ggplot2} visualization of inclusion probability curve
}
\description{
Plot the posterior inclusion probability of an edge between two
variables as a function of observation index
}
\examples{
\dontrun{
library(ggplot2)

# get the data
set.seed(12)
data <- generateData()
X <- data$X
Z <- data$Z
interval <- data$interval
prec <- data$true_precision

# get overall and within interval sample sizes
n <- nrow(X)
n1 <- sum(interval == 1)
n2 <- sum(interval == 2)
n3 <- sum(interval == 3)

# visualize the distribution of the extraneous covariate
ggplot(data.frame(Z = Z, interval = as.factor(interval))) +
  geom_histogram(aes(Z, fill = interval), color = "black", bins = n \%/\% 5)

# visualize the true precision matrices in each of the intervals

# interval 1
matViz(prec[[1]], incl_val = TRUE) +
  ggtitle(paste0("True precision matrix, interval 1, observations 1,...,", n1))

# interval 2 (varies continuously with Z)
cat("\nInterval 2, observations ", n1 + 1, ",...,", n1 + n2, sep = "")
int2_mats <- prec[interval == 2]
int2_inds <- c(5, n2 \%/\% 2, n2 - 5)
lapply(int2_inds, function(j) matViz(int2_mats[[j]], incl_val = TRUE) +
         ggtitle(paste("True precision matrix, interval 2, observation", j + n1)))

# interval 3
matViz(prec[[length(prec)]], incl_val = TRUE) +
  ggtitle(paste0("True precision matrix, interval 3, observations ",
                 n1 + n2 + 1, ",...,", n1 + n2 + n3))

# fit the model and visualize the estimated graphs
(out <- covdepGE(X, Z))
plot(out)

# visualize the posterior inclusion probabilities for variables (1, 3) and (1, 2)
inclusionCurve(out, 1, 2)
inclusionCurve(out, 1, 3)
}
}
