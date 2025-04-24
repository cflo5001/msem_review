library(dplyr)
library(haven)
library(glue)

#Student Achievement Data
load("TIMSS_Data/bsausam8.rdata")
achievement_data <- BSAUSAM8

vars <- c("IDSTUD", "IDCLASS", "IDSCHOOL", "BSMMAT01", "BSMMAT02", "BSMMAT03", "BSMMAT04", "BSMMAT05")

achievement_data <- achievement_data[, vars]

pvs <- c("BSMMAT01", "BSMMAT02", "BSMMAT03", "BSMMAT04", "BSMMAT05")

achievement_data$math_ss_average <- rowMeans(achievement_data[, pvs], na.rm = TRUE)
#achievement_data <- achievement_data[, !names(achievement_data) %in% pvs]

#achievement_data %>%
#	head(10)

#Student Math Attitudes Data
load("TIMSS_Data/bsgusam8.rdata")
attitude_data <- BSGUSAM8

vars <- c("IDSTUD", "IDCLASS", "IDSCHOOL", "BSBM19A", "BSBM19B", "BSBM19C",  "BSBM19D",
	  "BSBM19E", "BSBM19F", "BSBM19G", "BSBM19H", "BSBM19I")

attitude_data <- attitude_data[, vars]

reverse_vars <- c("BSBM19A", "BSBM19D", "BSBM19E",
		  "BSBM19F", "BSBM19G", "BSBM19H", "BSBM19I")

no_change_vars <- c("BSBM19B", "BSBM19C")

attitude_data <- attitude_data %>%
	mutate(across(all_of(reverse_vars),
		      ~ ifelse(as.numeric(zap_labels(.)) == 9, NA, 5 - as.numeric(zap_labels(.)))),
		across(all_of(no_change_vars),
		       ~ ifelse(as.numeric(zap_labels(.)) == 9, NA, as.numeric(zap_labels(.))))
	)

#attitude_data %>%
#	head(10)

#Merge Achievement and Attitude Data
timss_data <- left_join(attitude_data, achievement_data, by = c("IDSTUD", "IDSCHOOL", "IDCLASS"))

standardized_vars <- c("math_ss_average", pvs, reverse_vars, no_change_vars)

timss_data <- timss_data %>%
	mutate(across(all_of(standardized_vars),
		      ~ as.numeric(scale(.))))

#timss_data %>%
#	head(10)

write.csv(timss_data, "timss_data.csv", row.names = FALSE)
glue("### Writing timss_data.csv complete. ###")
