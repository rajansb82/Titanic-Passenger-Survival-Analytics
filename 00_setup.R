# ============================================================
# Titanic Survival Analytics
# 00_setup.R - Package setup and project configuration
# ============================================================

required_packages <- c(
  "ggplot2", "dplyr", "tidyr", "caret",
  "pROC", "car", "scales"
)

missing <- required_packages[
  !required_packages %in% rownames(installed.packages())
]

if (length(missing) > 0) {
  install.packages(missing, repos = "https://cloud.r-project.org")
}

invisible(lapply(required_packages, library, character.only = TRUE))

dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/plots", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

DATA_URL <- "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
DATA_FILE <- "data/raw/titanic.csv"

if (!file.exists(DATA_FILE)) {
  download.file(DATA_URL, DATA_FILE, mode = "wb")
}

cat("Environment ready.\n")
cat("Data file:", DATA_FILE, "\n")
