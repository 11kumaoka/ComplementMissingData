## we need to define mirror (http://www.okadajp.org/RWiki/) to use cran
options(repos="https://cran.ism.ac.jp/")
install.packages("devtools")
devtools::install_github("agnesdeng/mixgb")

# check the lack data visually 1111111111111111111
install.packages("VIM")
library(VIM)
# check the lack data visually 1111111111111111111

# load mixgb
library(mixgb)

## downroad from https://cran.r-project.org/web/packages/addhazard/index.html
install.packages("addhazard", dependencies = TRUE)
library(addhazard)

## COMPLETE DATA
## trel tsur relaps dead study stage histol instit age yr specwgt tumdiam 
data(nwtsco, package="addhazard")
rawdata <- nwtsco
rawdataWNA <- createNA(rawdata)

str(rawdataWNA)
colSums(is.na(rawdataWNA)) ## Count sumed up NA on each colums in data (rawdataWNA)

cv.results <- mixgb_cv(data = rawdataWNA, nfold = 10, nrounds = 100,
    early_stopping_rounds = 1, response = "age", 
    select_features = c("relaps", "study", "stage", "yr", "specwgt", "tumdiam"), verbose = FALSE)
cv.results$best.nrounds ## 4

# Use mixgb with chosen settings
params <- list(max_depth = 6, gamma = 0.1, eta = 0.3, min_child_weight = 1,
    subsample = 1, colsample_bytree = 1, colsample_bylevel = 1,
    colsample_bynode = 1, nthread = 4, tree_method = "auto",
    gpu_id = 0, predictor = "auto")
# Run Mixgb and get result as dataframe
imputed.data <- mixgb(data = rawdataWNA, m = 5, maxit = 1,
    ordinalAsInteger = TRUE, bootstrap = TRUE, pmm.type = "auto",
    pmm.k = 5, pmm.link = "prob", initial.num = "normal", initial.int = "mode",
    initial.fac = "mode", save.models = TRUE, save.vars = NULL,
    xgb.params = params, nrounds = 50, early_stopping_rounds = 10,
    print_every_n = 10L, verbose = 0)

imputed.data <- mixgb(data = rawdataWNA, m = 5, nrounds = 20)

"CheeeeeeeeeeeeecKuma Mixgb run Fin on R"

