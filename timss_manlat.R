library(lme4)
library(dplyr)
library(lavaan)
library(glue)

#Create the manifest aggregation variables.
data <- read.csv("timss_data.csv")

items <- c("BSBM19A", "BSBM19B", "BSBM19C", "BSBM19D", "BSBM19E",
	   "BSBM19F", "BSBM19G", "BSBM19H", "BSBM19I")

data$math_att <- rowMeans(data[, items], na.rm = TRUE)

head(data)

ml_model <- '
level: 1
ATT_W =~ NA*math_att + c1*math_att
math_ss_average ~ b1*ATT_W

ATT_W ~~ ATT_W

level: 2
ATT_B =~ NA*math_att + c1*math_att
math_ss_average ~ b2*ATT_B

ATT_B ~~ ATT_B
'

fit_ml <- sem(model = ml_model, data = data, cluster = "IDSCHOOL",
	     estimator = "ml", se = "robust.huber.white")

glue("--------------------------------------------------------------------------------")
glue("Model Paremeter Estimates with Fit Indicies")
fitMeasures(fit_ml, fit_ml.measures = "all")
summary(fit_ml)
