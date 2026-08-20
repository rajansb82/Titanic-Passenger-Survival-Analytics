# ============================================================
# 03_statistical_analysis.R
# Formal statistical testing
# ============================================================

source("R/00_setup.R")

data <- read.csv(
  "data/processed/titanic_clean.csv",
  stringsAsFactors = FALSE
)

data$Survived_f <- factor(data$Survived_f, levels = c("No", "Yes"))

# Normality tests
age_shapiro <- shapiro.test(data$Age)
fare_shapiro <- shapiro.test(data$Fare_capped)

# Group comparisons
age_t <- t.test(Age ~ Survived_f, data = data)
age_w <- wilcox.test(Age ~ Survived_f, data = data)

fare_t <- t.test(Fare_capped ~ Survived_f, data = data)
fare_w <- wilcox.test(Fare_capped ~ Survived_f, data = data)

# Chi-square tests
sex_chi <- chisq.test(table(data$Sex, data$Survived_f))
class_chi <- chisq.test(table(data$Pclass, data$Survived_f))
embarked_chi <- chisq.test(table(data$Embarked, data$Survived_f))

# Spearman correlation
age_fare_cor <- cor.test(
  data$Age,
  data$Fare_capped,
  method = "spearman"
)

results <- data.frame(
  Test = c(
    "Age Shapiro-Wilk",
    "Fare Shapiro-Wilk",
    "Age Welch t-test",
    "Age Wilcoxon",
    "Fare Welch t-test",
    "Fare Wilcoxon",
    "Sex x Survival Chi-square",
    "Class x Survival Chi-square",
    "Embarked x Survival Chi-square",
    "Age x Fare Spearman"
  ),
  Statistic = c(
    unname(age_shapiro$statistic),
    unname(fare_shapiro$statistic),
    unname(age_t$statistic),
    unname(age_w$statistic),
    unname(fare_t$statistic),
    unname(fare_w$statistic),
    unname(sex_chi$statistic),
    unname(class_chi$statistic),
    unname(embarked_chi$statistic),
    unname(age_fare_cor$estimate)
  ),
  P_Value = c(
    age_shapiro$p.value,
    fare_shapiro$p.value,
    age_t$p.value,
    age_w$p.value,
    fare_t$p.value,
    fare_w$p.value,
    sex_chi$p.value,
    class_chi$p.value,
    embarked_chi$p.value,
    age_fare_cor$p.value
  )
)

write.csv(
  results,
  "outputs/tables/statistical_tests.csv",
  row.names = FALSE
)

print(results)
