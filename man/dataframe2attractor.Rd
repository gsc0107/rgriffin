% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/griffin2boolnet.R
\name{dataframe2attractor}
\alias{dataframe2attractor}
\title{Convert a data frame with nodes displayed in Boolean format to a BoolNet attractor.}
\usage{
dataframe2attractor(df, fixedGenes)
}
\arguments{
\item{fixedGenes}{fixedGenes of network}

\item{Dataframe, }{see\code{\link{attractor2dataframe}} each column corresponds to the number of attractor, state, or node}
}
\value{
attr BoolNet attractor object
}
\description{
Convert a data frame with nodes displayed in Boolean format to a BoolNet attractor. First column is the attractor number, second is the number of state inside the attractor, the rest of the columns correspond to each node.
}
\examples{
> data("cellcycle")
> attr <- getAttractors(cellcycle)
> attr.df <- attractor2dataframe(attr)
> print(dataframe2attractor(attr.df))
}
