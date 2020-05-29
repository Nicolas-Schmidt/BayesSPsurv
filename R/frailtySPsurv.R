#' @title frailtySPsurv
#' @description Markov Chain Monte Carlo (MCMC) to run Bayesian non-spatial frailty split population survival model
#'
#' @param Y0 the elapsed time since inception until the beginning of time period (t-1)
#' @param LY last observation year
#' @param duration ...
#' @param immune ...
#' @param data ...
#' @param prop.var ...
#' @param S spatial information (e.g. district ID) for each observation that matches the spatial matrix row/column information
#' @param N number of MCMC iterations
#' @param burn burn-in to be discarded
#' @param thin thinning to prevent from autocorrelation
#' @param w size of the slice in the slice sampling for (betas, gammas, rho). Write it as a vector. E.g. c(1,1,1)
#' @param m limit on steps in the slice sampling. A vector of values for beta, gamma, rho.
#' @param form type of parametric model (Exponential or Weibull)
#'
#' @return chain of the variables of interest
#'
#' @export


frailtySPsurv <- function(duration,
                          immune,
                          Y0,
                          LY,
                          S,
                          data,
                          N,
                          burn,
                          thin,
                          w = c(1, 1, 1),
                          m = 10,
                          form,
                          prop.var) {

    cll <- match.call() # return print and summary
    #dis <- match.arg(form) # distribution, add value argument (se puede omitir esta linea si pasa a la documemtacion la descripcion!)

    formula1 <- as.formula(duration) # duration
    formula2 <- as.formula(immune)   # immune
    variable <- unique(c(all.vars(formula1), all.vars(formula2))) #combine ~

    mf1 <- model.frame(formula = duration, data = data)
    mf2 <- model.frame(formula = immune,   data = data)

    X <- model.matrix(attr(mf1, "terms"), data = mf1)
    Z <- model.matrix(attr(mf2, "terms"), data = mf2)

    Y <- as.matrix(model.response(mf1))
    C <- as.matrix(model.response(mf2))

    Y0 <- data[,Y0]
    LY <- data[,LY]
    S  <- data[, S]

    burn <-  burn
    if (is.null(w)) w <- c(1,1,1) else w <- w
    if (is.null(m)) m <- 10 else m <- m
    form <-  form
    prop.var <-  prop.var

    dataset <- data.frame(cbind(Y, Y0, C, LY, S, X, Z))
    dataset <- na.omit(dataset) # check other options!
    col <- ncol(dataset)

    Y  <- as.matrix(dataset[,1])
    Y0 <- as.matrix(dataset[,2])
    C  <- as.matrix(dataset[,3])
    LY <- as.matrix(dataset[,4])
    S  <- as.matrix(dataset[,5])
    X  <- as.matrix(dataset[,6:(5+ncol(X))]) # fatal error!!!
    Z  <- as.matrix(dataset[,(6+ncol(X)):ncol(dataset)])

    results <- mcmcfrailtySP(Y, Y0, C, LY, X, Z, S, N, burn, thin, w, m, form, prop.var)
    results

}
