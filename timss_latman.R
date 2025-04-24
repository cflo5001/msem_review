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
	       sBSBM19I = mean(BSBM19I, na.rm = TRUE)
	       ) %>%
	ungroup()

print(data, width = Inf)

model_lm <- '
level: 1
ATT_W =~ NA*BSBM19A + c1*BSBM19A + c2*BSBM19B + c3*BSBM19C + c4*BSBM19D + c5*BSBM19E + c6*BSBM19F + c7*BSBM19G + c8*BSBM19H + c9*BSBM19I
ATT_W ~~ ATT_W

math_ss_average ~ b_w*ATT_W

level: 2

ATT_B =~ NA*sBSBM19A + c1*sBSBM19A + c2*sBSBM19B + c3*sBSBM19C + c4*sBSBM19D + c5*sBSBM19E + c6*sBSBM19F + c7*sBSBM19G + c8*sBSBM19H + c9*sBSBM19I
ATT_B ~~ ATT_B

math_ss_average ~ b_b*ATT_B
'

fit_lm <- sem(model = model_lm, data = data, cluster = "IDSCHOOL",
	      estimator = "ml", se = "robust.huber.white")

summary(fit_lm, standardized=TRUE)


