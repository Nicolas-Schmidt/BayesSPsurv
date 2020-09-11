'.onAttach' <- function(lib, pkg) {
    title   <- packageDescription(pkg, lib.loc = lib)["Title"]
    version <- packageDescription(pkg, lib.loc = lib)["Version"]
    packageStartupMessage("\n", pkg, ": ", title, "\nVersion: ", version, "\nAuthors:", paste0("\n  ", Authors()), "\n")
}



