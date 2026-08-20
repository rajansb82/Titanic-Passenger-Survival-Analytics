# ============================================================
# run_all.R
# Execute the complete project pipeline
# ============================================================

cat("\n========================================\n")
cat(" TITANIC DATA ANALYSIS — FULL PIPELINE\n")
cat("========================================\n\n")

source("R/01_data_cleaning.R")
source("R/02_eda.R")
source("R/03_statistical_analysis.R")
source("R/04_modeling.R")
source("R/05_evaluation.R")

cat("\n========================================\n")
cat(" PIPELINE COMPLETED\n")
cat(" Check outputs/ for plots, tables and models.\n")
cat("========================================\n")
