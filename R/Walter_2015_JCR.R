#' Walter_2015_JCR
#'
#'Time-series-cross-sectional (TSCS) dataset extracted from \href{http://t.ly/F7KK}{Walter (2015)}.
#'It has data on duration of civil war as well as information on other relevant economic and political data.
#'Authors of this package later added the following variables: duration, cured, t.0, lastyear, S and A.
#'
#'\describe{
#'    \item{duration}{duration until failure or censoring.}
#'    \item{immune}{binary indicator of immunity.}
#'    \item{fhcompor1}{Freedom House civil liberties index.}
#'    \item{lgdpl}{log of per capita GDP in 2005 dollars.}
#'    \item{comprehensive}{combatants signed comprehensive peace agreement.}
#'    \item{victory}{end of previous war with outright victory.}
#'    \item{instabl}{dummy that indicates whether there was a positive or negative change in the Polity 2 score in the previous country-year.}
#'    \item{intensityln}{deaths per year -- logged.}
#'    \item{ethfrac}{index of ethnic fractionalization.}
#'    \item{unpko}{number of UN peacekeepers on the ground.}
#'    \item{t.0}{duration of peace spell.}
#'    \item{lastyear}{year of last country observation in dataset.}
#'    \item{sp_id}{country unique id.}
#'    \item{A}{time-invariant binary adjacency matrix}
#' }
#' @docType data
#' @keywords datasets
#' @name Walter_2015_JCR
#' @usage data(Walter_2015_JCR)
#' @format A data frame with 1562 rows and 13 variables
#' @source Walter, Barbara F. (2015), Why Bad Governance Leads to Repeat Civil War,  Journal of Conflict Resolution 59(7), 1242 - 1272.
NULL
