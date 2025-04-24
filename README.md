# Multilevel Structural Equation Modeling: Illustrative Examples of Different Modeling Approaches

This repository illustrates different types of models that have been used in the Multilevel Structural Equation Modeling (MSEM) literature. Specifically, this repository covers:
- Two-Level Contextual Models
  - [Doubly Manifest Models](timss_manifest.R)
  - [Manifest-Measurement/Latent-Aggregation Models](timss_manlat.R)
  - [Latent-Measurement/Manifest-Aggregation Models](timss_latman.R)
  - [Doubly Latent Models](timss_doublylatent.R)

## Dataset
To illustrate the various MSEM models in this repository, I use data from the 2023 Grade 8 Trends in International Mathematics and Science Study (TIMSS). If you would like to access the entire TIMSS 2023 Grade 8 R database, click [here](https://www.iea.nl/data-tools/repository/timss). For the models here, I only used the student achievement data file [BSAUSAM8](TIMSS_Data/bsausam8.rdata) and the student context data file [BSGUSAM8](TIMSS_Data/bsgusam8.rdata).

The TIMSS dataset has a heirarchical structure in which students are nested within classrooms that are nested within schools. For the models in this repository, I treat the student as Level 1 and the school as Level 2. 

The code that creates the analytic dataset can be found [here](create_timss_data.R). The outcome variable in these models is student mathematics achievement: `math_ss_average`. TIMSS creates five imputations of overall mathematics achievement for each student represented by the variables `BSMMAT01`, `BSMMAT02`, `BSMMAT03`, `BSMMAT04`, and `BSMMAT05`. `math_ss_average` is the mean of the math achievement imputations for each student. 

In this illustration, math achievement is explained by a student-level math attitude construct. This construct is measured by the following variables:
- `BSBM19A`: "I enjoy learning mathematics." 
- `BSBM19B`: "I wish I did not have to study math."
- `BSBM19C`: "Math is boring"
- `BSBM19D`: "I like to learn interesting things."
- `BSBM19E`: "I like mathematics."
- `BSBM19F`: "I like numbers."
- `BSBM19G`: "I like math problems."
- `BSBM19H`: "I look forward to math class."
- `BSBM19I`: "Math is my favorite subject."
  
Each item was a four point Likert scale: 1-"Agree a lot", 2-"Agree a little", 3-"Disagree a little", 4-"Disagree a lot". All items except `BSBM19B` and `BSBM19C` were reverse coded such that higher scores on the item represent a higher position on the math attitude construct. (Since `BSBM19B` and `BSBM19C` were negatively worded, I did not reverse code these items.)

## Contextual Models and Sources of Error

A contextual model asks the question: Does the L2 aggregate of a given covariate influence the L1 outcome above and beyond the influence of the L1 value of that covariate? In the words of the models in this repositor: Does the average math attitude of school affect a student's math achievement once their own math attitude has been accounted for?

To answer this question, the first model typically introduced in the literature is the following:

![MMC](https://latex.codecogs.com/svg.image?y_{ij}=\gamma_{00}&plus;\gamma_{10}(X_{ij}-\overline{X}_.j)&plus;\gamma_{10}\overline{X}_{.j}&plus;r_{ij}&plus;u_{.j}) 

