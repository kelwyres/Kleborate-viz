# Packages
library(shiny)
require(shinyjs)
# Misc
library(tidyverse)
require(reshape2)
library(vegan)  # diversity measurements
# Plotting
library(heatmaply)
library(plotly)

# Set maximum upload file size
options(shiny.maxRequestSize=20*1024^2)

# Default dataset
kleborate_data_default <- read.csv("data/kleborate_output.tsv", sep="\t", stringsAsFactors=FALSE)
metadata_default <- read.csv("data/kleborate_metadata.csv", stringsAsFactors=FALSE)
mic_data_default <- NULL

# Colours and variables names
v.kpsc_names <- c(
  "Klebsiella pneumoniae",
  "Klebsiella quasipneumoniae subsp. quasipneumoniae",
  "Klebsiella quasipneumoniae subsp. similipneumoniae",
  "Klebsiella variicola subsp. variicola",
  "Klebsiella variicola subsp. tropica",
  "Klebsiella quasivariicola",
  "Klebsiella africana"
)
v.kpsc_colours <- c(
  "Klebsiella pneumoniae"="#875F9A",
  "Klebsiella quasipneumoniae subsp. quasipneumoniae"="#EDA483",
  "Klebsiella quasipneumoniae subsp. similipneumoniae"="#56c8f5",
  "Klebsiella variicola subsp. variicola"="#8CBDB2",
  "Klebsiella variicola subsp. tropica"="#205c38",
  "Klebsiella quasivariicola"="#F0B663",
  "Klebsiella africana"="#ED6060"
)
v.other_species_colour_palette <- colorRampPalette(
  c(
    "#e85a5a",
    "#ffffbf",
    "#5B6894",
    "#5B6899",
    "#fdae61",
    "#66bd63",
    "#fee08b",
    "#5B6896",
    "#875F9A",
    "#5B6893",
    "#876738",
    "#c2bebe",
    "#a6d96a",
    "#f6fa7d"
  )
)
v.virulence_loci <- list(
  'Yersiniabactin'='Yersiniabactin',
  'Colibactin'='Colibactin',
  'Aerobactin'='Aerobactin',
  'Salmochelin'='Salmochelin',
  'RmpADC'='RmpADC',
  'rmpA2'='rmpA2'
)
v.resistance_classes <- list(
  'AGly'='AGly_acquired',
  'Col'='Col_acquired',
  'Fcyn'='Fcyn_acquired',
  'Flq'='Flq_acquired',
  'Gly'='Gly_acquired',
  'MLS'='MLS_acquired',
  'Phe'='Phe_acquired',
  'Rif'='Rif_acquired',
  'Sul'='Sul_acquired',
  'Tet'='Tet_acquired',
  'Tmt'='Tmt_acquired',
  'Tgc'='Tgc_acquired',
  'Bla'='Bla_acquired',
  'Bla inhR'='Bla_inhR_acquired',
  'Bla ESBL'='Bla_ESBL_acquired',
  'Bla Carb'='Bla_Carb_acquired',
  'Bla ESBL inhR'='Bla_ESBL_inhR_acquired'
)
v.genotype_st_var_choices <- list(
  'Summary'=list('Resistance score'='resistance_score', 'Virulence score'='virulence_score'),
  'Virulence'=v.virulence_loci,
  'Resistance'=v.resistance_classes
)
v.virulence_score_names <- list(
  '0'="None",
  '1'="ybt",
  '2'="ybt + clb",
  '3'="iuc (VP)",
  '4'="ybt + iuc (VP)",
  '5'="ybt + clb + iuc (VP)"
)
v.virulence_score_colours <- c(
  '0'="grey", 
  '1'="#79BEA8", 
  '2'="#448D76", 
  '3'="#798EF6",
  '4'="#183BF0", 
  '5'="#091534"
)
v.resistance_score_names <- c(
  '0'='ESBL-, Carb-',
  '1'='ESBL+, Carb-',
  '2'='Carb+',
  '3'='Carb+, Col+'
)
v.resistance_score_colours <- c(
  '0'='grey',
  '1'='#f7cac9',
  '2'='#f7786b',
  '3'='#c94c4c'
)


# Precomputed data, delete asap
sample_vir_res <- read.csv("testing/precomp/mean_vir_res_scores_sampletype.csv")
year_vir_res <- read.csv("testing/precomp/mean_vir_res_by_year.csv")
cumulative_K_data <- read.csv("testing/precomp/K_region_prevalence_by_region_cumulativeplot.csv")
cumulative_O_data <- read.csv("testing/precomp/O_types_prevalence_by_region_cumulativeplot.csv")
data_AMRSimpli <- read.csv("testing/precomp/EuSCAPE-Kleborate-AMR_comparison_forR_simpli.csv", stringsAsFactors=FALSE)