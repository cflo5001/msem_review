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

The code that creates the analytic dataset can be found [here](create_timss_data.R). The outcome variable in these models is student mathematics achievement: `math_ss_average`. 
