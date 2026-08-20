# Titanic Passenger Survival Analytics & Predictive Modeling

An end-to-end **R data analytics and machine learning project** that transforms the classic Titanic passenger dataset into a reproducible analytical pipeline covering:

**Data Cleaning → Exploratory Data Analysis → Statistical Testing → Logistic Regression → Model Evaluation → Insights**

---

## Project Overview

This project investigates the factors associated with passenger survival on the Titanic and builds an interpretable logistic regression model to predict survival.

The implementation is organized as a reproducible R workflow rather than a single notebook. Each stage produces reusable outputs for the next stage.

### Key Questions

1. How should missing and extreme values be treated?
2. Which passenger characteristics are most strongly associated with survival?
3. Are the observed differences statistically significant?
4. Can survival be predicted using passenger characteristics?
5. How does the full model compare with a simple sex-only baseline?

---

## Dataset

The project uses the Titanic passenger dataset with **891 passenger records and 12 original fields**.

Important variables include:

| Variable | Description |
|---|---|
| `Survived` | Survival outcome |
| `Pclass` | Passenger class |
| `Sex` | Passenger sex |
| `Age` | Passenger age |
| `SibSp` | Siblings/spouses aboard |
| `Parch` | Parents/children aboard |
| `Fare` | Passenger fare |
| `Cabin` | Cabin information |
| `Embarked` | Port of embarkation |

The pipeline downloads the CSV automatically if it is not already present in `data/raw/`.

---

## Technical Stack

- **R**
- **ggplot2** — visualization
- **dplyr** — data manipulation
- **tidyr** — data reshaping
- **caret** — model evaluation and cross-validation
- **pROC** — ROC/AUC analysis
- **car** — multicollinearity diagnostics
- **scales** — chart formatting

---

## Repository Structure

```text
Titanic_Data_Analysis_R_Project/
│
├── data/
│   ├── raw/
│   │   └── titanic.csv
│   └── processed/
│       └── titanic_clean.csv
│
├── R/
│   ├── 00_setup.R
│   ├── 01_data_cleaning.R
│   ├── 02_eda.R
│   ├── 03_statistical_analysis.R
│   ├── 04_modeling.R
│   ├── 05_evaluation.R
│   └── run_all.R
│
├── outputs/
│   ├── plots/
│   └── tables/
│
├── reports/
│   └── Week4_Titanic_Comprehensive_Data_Analysis_Report.docx
│
├── docs/
│   └── methodology.md
│
├── .gitignore
├── README.md
└── LICENSE
```

---

## Methodology

### 1. Data Cleaning

The cleaning stage:

- inspects structure and missingness
- imputes `Age` using the median within `Pclass × Sex`
- imputes missing `Embarked` using the mode
- converts sparse `Cabin` information into `HasCabin`
- detects outliers using the IQR rule
- caps extreme `Fare` values
- prepares categorical variables for modeling

This approach keeps all passenger records while avoiding fabricated cabin values.

### 2. Exploratory Data Analysis

The visualization stage produces:

- passenger class distribution
- survival distribution
- survival by sex
- survival by passenger class
- class × sex survival heatmap
- age distribution
- fare distribution
- survival by family size
- age/fare relationships
- additional comparison plots

### 3. Statistical Analysis

The project applies:

- Shapiro-Wilk normality testing
- Welch two-sample t-tests
- Wilcoxon rank-sum tests
- Chi-square tests of independence
- Spearman correlation

### 4. Predictive Modeling

The main model is:

```text
Survived ~ Pclass + Sex + Age + SibSp + Parch +
           Fare + Embarked + HasCabin
```

A 70/30 train-test split is used, followed by 10-fold cross-validation on the training set.

### 5. Evaluation

The model is evaluated using:

- Accuracy
- Sensitivity / Recall
- Specificity
- Precision
- Balanced Accuracy
- ROC Curve
- AUC
- Confusion Matrix
- Multicollinearity diagnostics
- Baseline comparison

---

## Reported Results

The consolidated analysis reported:

| Metric | Result |
|---|---:|
| Test Accuracy | **78.57%** |
| Test AUC | **0.8303** |
| 10-Fold CV AUC | **0.8645** |
| Sensitivity | **59.80%** |
| Specificity | **90.24%** |
| Precision | **79.22%** |
| Balanced Accuracy | **75.02%** |
| Sex-only baseline accuracy | **77.44%** |
| Full-model accuracy | **78.57%** |
| Female odds ratio | **16.678** |
| Third-class odds ratio | **0.304** |

### Main Finding

`Sex` is the strongest predictor in the final logistic regression, followed by passenger class and other demographic/family/economic variables.

The full model improves test accuracy only modestly over the sex-only baseline, but it provides substantially better model fit and additional explanatory information.

---

## How to Run

### Step 1 — Install R

Install R and RStudio.

### Step 2 — Open the project

Open the project folder in RStudio.

### Step 3 — Install packages

```r
source("R/00_setup.R")
```

### Step 4 — Run the complete pipeline

```r
source("R/run_all.R")
```

The scripts will:

1. download/load the data
2. clean the data
3. create visualizations
4. run statistical tests
5. train the logistic regression
6. evaluate the model
7. save plots and tables under `outputs/`

---

## Reproducibility

The project separates:

- raw data
- processed data
- source code
- visual outputs
- analytical tables
- final documentation

This makes the analysis easier to reproduce, audit and extend.

---

## Future Improvements

- Compare logistic regression with Random Forest and Gradient Boosting
- Add model calibration plots
- Test non-linear Age effects
- Add class weighting
- Perform multiple imputation
- Explore feature engineering using passenger titles and ticket groups
- Add an interactive Shiny dashboard
- Add automated report generation with Quarto/R Markdown

---

## Project Type

**Domain:** Data Analytics + Statistical Modeling + Machine Learning

**Primary Language:** R

**Output:** Reproducible analytical project with visualizations, statistical evidence and predictive modeling.
