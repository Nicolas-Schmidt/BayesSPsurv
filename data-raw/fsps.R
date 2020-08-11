
# example frailitySPsurv

walter2015v2     <- read.csv("data-raw/walterhotdeck.csv")
walter2015v2     <- spduration::add_duration(walter2015v2,"renewed_war", unitID = "id", tID = "year", freq = "year", ongoing = FALSE)
capdist          <- read.csv("data-raw/capdist.csv")
ccodes           <- levels(as.factor(walter2015v2$ccode))
capdistiv        <- dplyr::distinct(capdist, numa, numb, kmdist, midist)
capdistiv$adj.km <- ifelse(capdistiv$kmdist > 800, 0, 1)
capdistiva       <- capdistiv[which(capdistiv$numa %in% ccodes),]
capdistivb       <- capdistiva[which(capdistiva$numb %in% ccodes),]
adj.mat.tiv      <- reshape2::acast(capdistivb, capdistivb$numa ~ capdistivb$numb, value.var = "adj.km")
diag(adj.mat.tiv)<- 0L
namesTIV         <- data.frame(ccode = rownames(adj.mat.tiv), sp_id = 1:nrow(adj.mat.tiv))
walter2015       <- merge(walter2015v2, namesTIV, by = "ccode")
A                <- adj.mat.tiv





Walter_2015_JCR  <- read.csv("data-raw/walterhotdeck.csv")
capdist          <- read.csv("data-raw/capdist.csv")


save(Walter_2015_JCR, file = "Walter_2015_JCR.rda")
save(capdist, file = "capdist.rda")






