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

data(nwtsco, package="addhazard")

rawdata <- nwtsco
# vim.aggr <- aggr(rawdata, col = c('white','red'), numbers = TRUE, sortVars = FALSE,
#     prop = TRUE, labels = names(rawdata), cex.axis = .8, gap = 3)
# vim.aggr
rawdataWNA <- createNA(rawdata)
# vim.aggr <- aggr(rawdataWNA, col = c('white','red'), numbers = TRUE, sortVars = FALSE,
#     prop = TRUE, labels = names(rawdataWNA), cex.axis = .8, gap = 3)
# vim.aggr
# cleanWithNA.df <- data_clean(rawdata)
# vim.aggr <- aggr(cleanWithNA.df, col = c('white','red'), numbers = TRUE, sortVars = FALSE,
#     prop = TRUE, labels = names(cleanWithNA.df), cex.axis = .8, gap = 3)
# vim.aggr

"CheeeeeeeeeeeeecKuma1"
## https://rdrr.io/cran/mixgb/src/R/nhanes3_newborn.R
str(nhanes3_newborn)

"CheeeeeeeeeeeeecKuma2"

originalTuto.data <- nhanes3_newborn

# str(originalTuto)

# nhanes3_newborn
# head(nhanes3_newborn, 1000)
"CheeeeeeeeeeeeecKuma3"
colSums(is.na(nhanes3_newborn)) ## Count sumed up NA on each colums in data (nhanes3_newborn)

# check the lack data visually 1111111111111111111
vim.aggr <- aggr(nhanes3_newborn, col = c('white','red'), numbers = TRUE, sortVars = FALSE,
    prop = TRUE, labels = names(nhanes3_newborn), cex.axis = .8, gap = 3)
vim.aggr
# check the lack data visually 1111111111111111111

"CheeeeeeeeeeeeecKuma4"
# use mixgb with default settings
# imputed.data <- mixgb(data = nhanes3_newborn, m = 5)

# Use mixgb with chosen settings
params <- list(max_depth = 6, gamma = 0.1, eta = 0.3, min_child_weight = 1,
    subsample = 1, colsample_bytree = 1, colsample_bylevel = 1,
    colsample_bynode = 1, nthread = 4, tree_method = "auto",
    gpu_id = 0, predictor = "auto")

imputed.data <- mixgb(data = nhanes3_newborn, m = 5, maxit = 1,
    ordinalAsInteger = TRUE, bootstrap = TRUE, pmm.type = "auto",
    pmm.k = 5, pmm.link = "prob", initial.num = "normal", initial.int = "mode",
    initial.fac = "mode", save.models = TRUE, save.vars = NULL,
    xgb.params = params, nrounds = 50, early_stopping_rounds = 10,
    print_every_n = 10L, verbose = 0)
mixgb_1 <- imputed.data


## Use cross-validation to find the optimal nrounds for an Mixgb imputer. 
cv.results <- mixgb_cv(data = nhanes3_newborn, verbose = FALSE)
names(cv.results) ## "best.nrounds"   "evaluation.log" "response"
## show value(response) in cv.results
cv.results$response ## "DMPPIR"
## show value(nrounds) in cv.results
cv.results$best.nrounds ## 10


"CheeeeeeeeeeeeecKuma5"
cv.results <- mixgb_cv(data = nhanes3_newborn, nfold = 10, nrounds = 100,
    early_stopping_rounds = 1, response = "BMPHEAD", select_features = c("HSAGEIR",
        "HSSEX", "DMARETHN", "BMPRECUM", "BMPSB1", "BMPSB2",
        "BMPTR1", "BMPTR2", "BMPWT"), verbose = FALSE)

cv.results$best.nrounds ## 18
"CheeeeeeeeeeeeecKuma6"

imputed.data <- mixgb(data = nhanes3_newborn, m = 5, nrounds = 20)

withNA.df <- createNA(data = nhanes3_newborn, var.names = c("HSHSIZER",
    "HSAGEIR", "HSSEX", "DMARETHN", "HYD1"), p = 0.1)
colSums(is.na(withNA.df))

imputed.data <- mixgb(data = withNA.df, m = 5)

plot_hist(imputation.list = imputed.data, var.name = "BMPHEAD", original.data = withNA.df)
# plot_hist(imputation.list = imputed.data, var.name = "HSSEX", original.data = withNA.df)
plot_hist(imputation.list = imputed.data, var.name = "HSHSIZER", original.data = withNA.df)

plot_2num(imputation.list = imputed.data, var.x = "BMPHEAD", var.y = "BMPRECUM",
    original.data = withNA.df)

plot_2num(imputation.list = imputed.data, var.x = "HSAGEIR", var.y = "BMPHEAD",
    original.data = withNA.df)

plot_1num1fac(imputation.list = imputed.data, var.num = "BMPHEAD",
    var.fac = "HSSEX", original.data = withNA.df)

"CheeeeeeeeeeeeecKumaFin"


