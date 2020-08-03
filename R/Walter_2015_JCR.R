#' Walter_2015_JCR
#'
#'Time-series-cross-sectional (TSCS) dataset extracted from \href{http://t.ly/F7KK}{Walter (2015)}.
#'It has precisely dated duration data of internal conflict as well as geographic data.
#'Variables Y, Y0 and C were later added by \href{http://bit.ly/38eDsnG}{Bagozzi et al. (2019)}.
#'It is used to estimate the Bayesian Misclassified Failure (MF) Weibull model
#'presented in \href{http://bit.ly/38eDsnG}{Bagozzi et al. (2019)}.
#'
#'
#'\describe{
#'    \item{duration}{.}
#'    \item{cured}{.}
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
#'    \item{A}{adjacency matrix}
#' }
#' @docType data
#' @keywords datasets
#' @name Walter_2015_JCR
#' @usage data(Walter_2015_JCR)
#' @format A data frame with 1562 rows and 13 variables
#' @source Walter, Barbara F. (2015), Why Bad Governance Leads to Repeat Civil War,  Journal of Conflict Resolution 59(7), 1242 - 1272.
"Walter_2015_JCR"