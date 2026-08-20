# ============================================================
# 02_eda.R
# Exploratory Data Analysis and visualization
# ============================================================

source("R/00_setup.R")

data <- read.csv(
  "data/processed/titanic_clean.csv",
  stringsAsFactors = FALSE
)

data$Survived_f <- factor(data$Survived_f, levels = c("No", "Yes"))

save_plot <- function(plot_object, filename) {
  ggsave(
    filename = file.path("outputs/plots", filename),
    plot = plot_object,
    width = 8,
    height = 5,
    dpi = 300
  )
}

# 1. Passenger class distribution
p1 <- ggplot(data, aes(x = factor(Pclass))) +
  geom_bar() +
  labs(
    title = "Passenger Distribution by Class",
    x = "Passenger Class",
    y = "Passenger Count"
  ) +
  theme_minimal()

save_plot(p1, "01_passenger_class_distribution.png")

# 2. Survival distribution
p2 <- ggplot(data, aes(x = Survived_f)) +
  geom_bar() +
  labs(
    title = "Overall Survival Distribution",
    x = "Survival",
    y = "Passenger Count"
  ) +
  theme_minimal()

save_plot(p2, "02_survival_distribution.png")

# 3. Survival by sex
p3 <- ggplot(data, aes(x = Sex, fill = Survived_f)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Survival Rate by Sex",
    x = "Sex",
    y = "Survival Rate"
  ) +
  theme_minimal()

save_plot(p3, "03_survival_by_sex.png")

# 4. Survival by class
p4 <- ggplot(data, aes(x = factor(Pclass), fill = Survived_f)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Survival Rate by Passenger Class",
    x = "Passenger Class",
    y = "Survival Rate"
  ) +
  theme_minimal()

save_plot(p4, "04_survival_by_class.png")

# 5. Age distribution
p5 <- ggplot(data, aes(x = Age)) +
  geom_histogram(bins = 30) +
  labs(
    title = "Age Distribution",
    x = "Age",
    y = "Count"
  ) +
  theme_minimal()

save_plot(p5, "05_age_distribution.png")

# 6. Fare distribution
p6 <- ggplot(data, aes(x = Fare_capped)) +
  geom_histogram(bins = 30) +
  labs(
    title = "Capped Fare Distribution",
    x = "Fare",
    y = "Count"
  ) +
  theme_minimal()

save_plot(p6, "06_fare_distribution.png")

# 7. Class x sex heatmap
heat <- data %>%
  group_by(Pclass, Sex) %>%
  summarise(
    Survival_Rate = mean(Survived),
    .groups = "drop"
  )

p7 <- ggplot(heat, aes(
  x = Sex, y = factor(Pclass), fill = Survival_Rate
)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "steelblue") +
  labs(
    title = "Survival Rate: Class × Sex",
    x = "Sex",
    y = "Passenger Class",
    fill = "Survival Rate"
  ) +
  theme_minimal()

save_plot(p7, "07_class_sex_heatmap.png")

# 8. Family size
p8 <- ggplot(data, aes(x = FamilySize, fill = Survived_f)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Survival Rate by Family Size",
    x = "Family Size",
    y = "Survival Rate"
  ) +
  theme_minimal()

save_plot(p8, "08_family_size_survival.png")

# 9. Fare vs age
p9 <- ggplot(data, aes(x = Age, y = Fare_capped, color = Survived_f)) +
  geom_point(alpha = 0.45) +
  labs(
    title = "Age vs Capped Fare",
    x = "Age",
    y = "Capped Fare",
    color = "Survival"
  ) +
  theme_minimal()

save_plot(p9, "09_age_fare_scatter.png")

cat("EDA plots saved to outputs/plots/\n")
