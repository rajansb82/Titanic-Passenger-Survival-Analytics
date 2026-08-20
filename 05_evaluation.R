# ============================================================
# 05_evaluation.R
# Held-out evaluation, ROC/AUC and baseline comparison
# ============================================================

source("R/00_setup.R")

log_model <- readRDS("outputs/logistic_model.rds")
test_set <- readRDS("outputs/test_set.rds")

test_probs <- predict(
  log_model,
  newdata = test_set,
  type = "response"
)

test_pred <- factor(
  ifelse(test_probs > 0.5, "Yes", "No"),
  levels = c("No", "Yes")
)

cm <- confusionMatrix(
  test_pred,
  test_set$Survived_f,
  positive = "Yes"
)

cat("\n--- TEST SET PERFORMANCE ---\n")
print(cm)

# ROC / AUC
roc_obj <- roc(
  response = test_set$Survived_f,
  predictor = test_probs,
  levels = c("No", "Yes"),
  direction = "<"
)

auc_value <- as.numeric(auc(roc_obj))

png(
  "outputs/plots/10_roc_curve.png",
  width = 1000,
  height = 700,
  res = 120
)
plot(
  roc_obj,
  main = paste0("ROC Curve — AUC = ", round(auc_value, 4)),
  col = "steelblue",
  lwd = 3
)
abline(a = 0, b = 1, lty = 2)
dev.off()

# Sex-only baseline
baseline_model <- glm(
  Survived_f ~ Sex,
  data = train_set,
  family = binomial
)

baseline_probs <- predict(
  baseline_model,
  newdata = test_set,
  type = "response"
)

baseline_pred <- factor(
  ifelse(baseline_probs > 0.5, "Yes", "No"),
  levels = c("No", "Yes")
)

baseline_cm <- confusionMatrix(
  baseline_pred,
  test_set$Survived_f,
  positive = "Yes"
)

comparison <- data.frame(
  Model = c("Sex-only baseline", "Full logistic model"),
  Accuracy = c(
    unname(baseline_cm$overall["Accuracy"]),
    unname(cm$overall["Accuracy"])
  ),
  AIC = c(
    AIC(baseline_model),
    AIC(log_model)
  )
)

write.csv(
  comparison,
  "outputs/tables/model_comparison.csv",
  row.names = FALSE
)

cat("\n--- MODEL COMPARISON ---\n")
print(comparison)
