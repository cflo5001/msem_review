library(lavaan)
library(glue)
library(dplyr)

data <- read.csv("timss_data.csv")

data <- data %>%
	group_by(IDSCHOOL) %>%
	mutate(
	       sBSBM19A = mean(BSBM19A, na.rm = TRUE),
	       sBSBM19B = mean(BSBM19B, na.rm = TRUE),
	       sBSBM19C = mean(BSBM19C, na.rm = TRUE),
	       sBSBM19D = mean(BSBM19D, na.rm = TRUE),
	       sBSBM19E = mean(BSBM19E, na.rm = TRUE),
	       sBSBM19F = mean(BSBM19F, na.rm = TRUE),
	       sBSBM19G = mean(BSBM19G, na.rm = TRUE),
	       sBSBM19H = mean(BSBM19H, na.rm = TRUE),
	       sBSBM19I = mean(BSBM19I, na.rm = TRUE),
	       cBSBM19A = BSBM19A - sBSBM19A,
	       cBSBM19B = BSBM19B - sBSBM19B,
	       cBSBM19C = BSBM19C - sBSBM19C,
	       cBSBM19D = BSBM19D - sBSBM19D,
	       cBSBM19E = BSBM19E - sBSBM19E,
               cBSBM19F = BSBM19F - sBSBM19F,
	       cBSBM19G = BSBM19G - sBSBM19G,
	       cBSBM19H = BSBM19H - sBSBM19H,
	       cBSBM19I = BSBM19I - sBSBM19I
	       ) %>%
	ungroup()

print(data, width = Inf)

model_lm <- '
level: 1
ATT_W =~ NA*cBSBM19A + c1*cBSBM19A + c2*cBSBM19B + c3*cBSBM19C + c4*cBSBM19D + c5*cBSBM19E + c6*cBSBM19F + c7*cBSBM19G + c8*cBSBM19H + c9*cBSBM19I
ATT_W ~~ ATT_W

math_ss_average ~ b_w*ATT_W

level: 2

ATT_B =~ NA*sBSBM19A + c1*sBSBM19A + c2*sBSBM19B + c3*sBSBM19C + c4*sBSBM19D + c5*sBSBM19E + c6*sBSBM19F + c7*sBSBM19G + c8*sBSBM19H + c9*sBSBM19I
ATT_B ~~ ATT_B

math_ss_average ~ b_b*ATT_B
'

fit_lm <- sem(model = model_lm, data = data, cluster = "IDSCHOOL",
	      estimator = "ml", se = "robust.huber.white")

sink("reports/latentMeas_manifestAgg_results.txt")

glue("--------------------------------------------------------------------------------")
glue("Latent-Measurement/Manifest-Aggregation Model Paremeter Estimates with Fit Indicies")
fitMeasures(fit_lm, fit_lm.measures = "all")
summary(fit_lm, standardized=TRUE)

sink()



