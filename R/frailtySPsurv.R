#' @title frailtySPsurv
#' @description Markov Chain Monte Carlo (MCMC) to run Bayesian non-spatial frailty split population survival model
#'
#' @param Y0 the elapsed time since inception until the beginning of time period (t-1)
#' @param formula ...
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

frailtySPsurv <- function(formula,duration, immune, Y0, LY, S, data = list(), N, burn, thin, w = c(1, 1, 1), m = 10, form,  prop.var) {

    data <- data

    equation1 <- as.character(duration)
    equation2<-as.character(immune)
    formula1<-paste(equation1[2],equation1[1],equation1[3],sep="")
    formula2<-paste(equation2[2],equation2[1],equation2[3],sep="")
    mf1 <- model.frame(formula=as.formula(formula1), data=data)
    mf2 <- model.frame(formula=as.formula(formula2), data=data)
    X <- model.matrix(attr(mf1, "terms"), data=mf1)
    Z <- model.matrix(attr(mf2, "terms"), data=mf2)
    Y <- as.matrix(model.response(mf1))
    C <- as.matrix(model.response(mf2))

    Y0 <- as.character(Y0)
    LY <- as.character(LY)
    S <- as.character(S)

    dat <- subset(data, select=c(Y0, LY, S))

    Y0 <- dat[,1]
    LY <- dat[,2]
    S <- dat[,3]

    burn = burn
    if(is.null(w)){
        w = c(1,1,1)
    } else{
        w=w
    }
    if(is.null(m)){
        m = 10
    } else{
        m=m
    }
    form = form
    prop.var = prop.var

    dataset <- data.frame(cbind(Y, Y0, C, LY, S, X, Z))
    dataset  <- na.omit(dataset)
    col <- ncol(dataset)

    Y  <- as.matrix(dataset[,1])
    Y0 <- as.matrix(dataset[,2])
    C  <- as.matrix(dataset[,3])
    LY <- as.matrix(dataset[,4])
    S  <- as.matrix(dataset[,5])
    X  <- as.matrix(dataset[,6:5+ncol(X)])
    Z  <- as.matrix(dataset[,(6+ncol(X)):ncol(dataset)])

    results <- mcmcfrailtySP(Y, Y0,C, LY, X, Z, S, N, burn, thin, w, m , form, prop.var)
    return(results)

}
