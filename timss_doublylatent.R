library(lme4)
library(dplyr)
library(lavaan)
library(glue)

#Create the manifest aggregation variables.
data <- read.csv("timss_data.csv")

glue("---------------------------------------------------------------------------")
glue("Frist ten rows of the dataset")
data %>%
	head(10)

dl_model <- '
level: 1
Factor_w =~ NA*BSBM19A + c1*BSBM19A + c2*BSBM19B + c3*BSBM19C + c4*BSBM19D + c5*BSBM19E + c6*BSBM19F + c7*BSBM19G + c8*BSBM19H + c9*BSBM19I

BSBM19A ~~ BSBM19A
BSBM19B ~~ BSBM19B
BSBM19C ~~ BSBM19C
BSBM19D ~~ BSBM19D
BSBM19E ~~ BSBM19E
BSBM19F ~~ BSBM19F
BSBM19G ~~ BSBM19G
BSBM19H ~~ BSBM19H
BSBM19I ~~ BSBM19I

Factor_w ~~ Factor_w

math_ss_average ~ b1*Factor_w

level: 2
Factor_b =~ NA*BSBM19A + c1*BSBM19A + c2*BSBM19B + c3*BSBM19C + c4*BSBM19D + c5*BSBM19E + c6*BSBM19F + c7*BSBM19G + c8*BSBM19H + c9*BSBM19I

BSBM19A ~~ BSBM19A
BSBM19B ~~ BSBM19B
BSBM19C ~~ BSBM19C
BSBM19D ~~ BSBM19D
BSBM19E ~~ BSBM19E
BSBM19F ~~ BSBM19F
BSBM19G ~~ BSBM19G
BSBM19H ~~ BSBM19H
BSBM19I ~~ BSBM19I

Factor_b ~~ Factor_b

math_ss_average ~ b2*Factor_b
'

fit_dl <- sem(model = dl_model, data = data, cluster = "IDSCHOOL",
	     estimator = "ml", se = "robust.huber.white")

glue("---------------------------------------------------------------------------")
glue("Model Paremeter Estimates with Fit Indicies")
fitMeasures(fit_dl, fit_dl.measures = "all")
summary(fit_dl)



