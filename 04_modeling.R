# ============================================================
# 04_modeling.R
# Logistic regression and 10-fold cross-validation
# ============================================================

source("R/00_setup.R")

data <- read.csv(
  "data/processed/titanic_clean.csv",
  stringsAsFactors = FALSE
)

data$Survived_f <- factor(data$Survived_f, levels = c("No", "Yes"))
data$Pclass_f <- factor(data$Pclass)
data$Sex <- factor(data$Sex)
data$Embarked <- factor(data$Embarked)

set.seed(42)

idx <- createDataPartition(
  data$Survived_f,
  p = 0.70,
  list = FALSE
)

train_set <- data[idx, ]
test_set <- data[-idx, ]

log_model <- glm(
  Survived_f ~ Pclass_f + Sex + Age + SibSp + Parch +
    Fare_capped + Embarked + HasCabin,
  data = train_set,
  family = binomial(link = "logit")
)

summary(log_model)

# Odds ratios
odds_ratios <- exp(coef(log_model))
odds_table <- data.frame(
  Predictor = names(odds_ratios),
  Odds_Ratio = as.numeric(odds_ratios)
)

write.csv(
  odds_table,
  "outputs/tables/logistic_odds_ratios.csv",
  row.names = FALSE
)

# 10-fold cross-validation
ctrl <- trainControl(
  method = "cv",
  number = 10,
  classProbs = TRUE,
  summaryFunction = twoClassSummary,
  savePredictions = "final"
)

cv_model <- train(
  Survived_f ~ Pclass_f + Sex + Age + SibSp + Parch +
    Fare_capped + Embarked + HasCabin,
  data = train_set,
  method = "glm",
  family = binomial,
  metric = "ROC",
  trControl = ctrl
)

print(cv_model)

saveRDS(log_model, "outputs/logistic_model.rds")
saveRDS(cv_model, "outputs/cv_model.rds")
saveRDS(test_set, "outputs/test_set.rds")

cat("Model training complete.\n")
