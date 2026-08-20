# ============================================================
# 01_data_cleaning.R
# Data inspection, missing-value treatment and outlier handling
# ============================================================

source("R/00_setup.R")

titanic <- read.csv(DATA_FILE, stringsAsFactors = FALSE)

cat("\n--- RAW DATA ---\n")
cat("Rows:", nrow(titanic), " Columns:", ncol(titanic), "\n")
print(str(titanic))

# Missing-value summary
na_summary <- data.frame(
  Variable = names(titanic),
  Missing = sapply(titanic, function(x) sum(is.na(x))),
  Missing_Pct = round(
    sapply(titanic, function(x) mean(is.na(x)) * 100), 2
  )
)

write.csv(
  na_summary,
  "outputs/tables/missing_value_summary.csv",
  row.names = FALSE
)

# Standardize column names for the analysis
names(titanic) <- c(
  "PassengerId", "Survived", "Pclass", "Name", "Sex", "Age",
  "SibSp", "Parch", "Ticket", "Fare", "Cabin", "Embarked"
)

# Age: subgroup-aware median imputation
age_medians <- titanic %>%
  group_by(Pclass, Sex) %>%
  summarise(
    Age_Median = median(Age, na.rm = TRUE),
    .groups = "drop"
  )

titanic <- titanic %>%
  left_join(age_medians, by = c("Pclass", "Sex")) %>%
  mutate(
    Age = ifelse(is.na(Age), Age_Median, Age),
    Age_Median = NULL
  )

# Embarked: mode imputation
mode_value <- names(sort(table(titanic$Embarked), decreasing = TRUE))[1]
titanic$Embarked[is.na(titanic$Embarked)] <- mode_value

# Cabin: sparse field -> binary indicator
titanic$HasCabin <- ifelse(is.na(titanic$Cabin), 0, 1)
titanic$Cabin <- NULL

# IQR-based Fare outlier detection
q1 <- quantile(titanic$Fare, 0.25, na.rm = TRUE)
q3 <- quantile(titanic$Fare, 0.75, na.rm = TRUE)
iqr <- q3 - q1
fare_upper <- q3 + 1.5 * iqr

titanic$Fare_capped <- pmin(titanic$Fare, fare_upper)

# Analytical factors
titanic <- titanic %>%
  mutate(
    Survived_f = factor(
      ifelse(Survived == 1, "Yes", "No"),
      levels = c("No", "Yes")
    ),
    Pclass_f = factor(Pclass),
    Sex = factor(Sex),
    Embarked = factor(Embarked)
  )

# Family size
titanic$FamilySize <- titanic$SibSp + titanic$Parch + 1

# Save cleaned data
write.csv(
  titanic,
  "data/processed/titanic_clean.csv",
  row.names = FALSE
)

cat("\n--- CLEANING COMPLETE ---\n")
cat("Rows retained:", nrow(titanic), "\n")
cat("Fare cap:", round(fare_upper, 2), "\n")
cat("Embarked mode:", mode_value, "\n")
cat("Remaining missing values:",
    sum(is.na(titanic)), "\n")
