library(lme4)
library(dplyr)
library(ggplot2)
library(glue)

#Create the manifest aggregation variables.
data <- read.csv("timss_data.csv")

items <- c("BSBM19A", "BSBM19B", "BSBM19C", "BSBM19D", "BSBM19E",
	   "BSBM19F", "BSBM19G", "BSBM19H", "BSBM19I")

data$math_att <- rowMeans(data[, items], na.rm = TRUE)

data <- data %>%
	group_by(IDSCHOOL) %>%
	mutate(
	       school_math_att = mean(math_att, na.rm = TRUE),
	       centered_math_att = math_att - school_math_att
	       ) %>%
	ungroup()

glue("---------------------------------------------------------------------------")
glue("The first ten rows of the dataset:")

print(data, width = Inf)


#png("timss_achievement_dist.png", width = 800, height = 600)

#ggplot(data, aes(x = math_ss_average)) +
#	geom_histogram(binwidth = 1, fill = "orange", color = "orange") +
#	theme_minimal()

#dev.off()

#png("timss_attitude_dist.png", width = 800, height = 600)

#ggplot(data, aes(x = math_att)) +
#	geom_histogram(binwidth = .1, fill = "orange", color = "orange") +
#	theme_minimal()

#dev.off()

#Define the MMC model.
rand_int <- lmer(math_ss_average ~ centered_math_att + school_math_att + (1 | IDSCHOOL),
		 data = data, REML = FALSE)

glue("---------------------------------------------------------------------------")
glue("Model Parameter Estimates and Fit Indicies")
summary(rand_int)

glue("---------------------------------------------------------------------------")

var_components <- as.data.frame(VarCorr(rand_int))
tau_squared <- var_components$vcov[var_components$grp == "IDSCHOOL"]
sigma_squared <- var_components$vcov[var_components$grp == "Residual"]

#Computing L2 Reliability and Parameter Bias
glue("Statistics for Computing L2 Reliability and Bias")
icc <- tau_squared / (tau_squared + sigma_squared)
glue("ICC: {icc}")

group_size <- data %>%
  	count(IDSCHOOL, name = "n_students")

n_mean <- mean(group_size$n_students)
glue("Average Group Size: {n_mean}")

l2_reliability <- (n_mean * icc)/(1 + ((n_mean - 1)*icc))
glue("L2 Reliability of Group Mean: {l2_reliability}")

beta_between <- summary(rand_int)$coefficients["school_math_att", "Estimate"]
beta_within <- summary(rand_int)$coefficients["centered_math_att", "Estimate"]

ce <- beta_between - beta_within
glue("Estimated Contextual Effect: {ce}")

ce_bias_factor <- if (ce > 0) {
	-(1/n_mean)*(((1-icc))/(icc+((1-icc)/n_mean)))
} else {
	(1/n_mean)*(((1-icc))/(icc+((1-icc)/n_mean)))
}
glue("Contextual Effect Bias Factor: {ce_bias_factor}")

