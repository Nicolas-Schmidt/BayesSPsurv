#' @title spatialSPsurv
#' @description Markov Chain Monte Carlo (MCMC) to run Bayesian spatial split population survival model
#'
#' @param Y0 the elapsed time since inception until the beginning of time period (t-1)
#' @param duration ...
#' @param LY last observation year
#' @param immune ...
#' @param data ...
#' @param S spatial information (e.g. district ID) for each observation that matches the spatial matrix row/column information
#' @param A Spatial Matrix (load separate spatial weights matrix file)
#' @param N number of MCMC iterations
#' @param burn burn-in to be discarded
#' @param thin thinning to prevent from autocorrelation
#' @param w size of the slice in the slice sampling for (betas, gammas, rho). Write it as a vector. E.g. c(1,1,1)
#' @param m limit on steps in the slice sampling. A vector of values for beta, gamma, rho.
#' @param form type of parametric model (Exponential or Weibull)
#' @param prop.var proposal variance for Metropolis-Hastings
#'
#' @return chain of the variables of interest
#'
#' @export
#'

spatialSPsurv<- function(duration,
                         immune,
                         Y0,
                         LY,
                         S,
                         A,
                         data,
                         N,
                         burn,
                         thin,
                         w = c(1, 1, 1),
                         m = 10,
                         form = c('Weibull', 'exponential', 'loglog'),
                         prop.var)
{

    cll <- match.call()
    dis <- match.arg(form)
    r   <- formcall(duration = duration, immune = immune, data = data, Y0 = Y0,
                    LY = LY, S = S, N = N, burn = burn, thin = thin, w = w, m = m,
                    form = dis, prop.var = prop.var, A = A, model = 'spatialSPsurv')

    results <- mcmcspatialSP(Y = r$Y, Y0 = r$Y0, C = r$C, LY = r$LY, X = r$X, Z = r$Z,
                             S = r$S, N = r$N, burn = r$burn, thin = r$thin, w = r$w,
                             m = r$m, form = r$form, prop.var = r$prop.var, A = r$A)

    results

}
