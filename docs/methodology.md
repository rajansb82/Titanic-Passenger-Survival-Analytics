# Methodology Notes

## Data Preparation

The cleaning strategy follows the principle of preserving valid records while treating missingness according to context.

- Age: median within passenger class and sex
- Embarked: mode imputation
- Cabin: binary `HasCabin` feature
- Fare: IQR-based upper-tail capping

## Statistical Testing

Normality is assessed before comparing continuous variables. Welch's t-test is retained as a robust parametric comparison and Wilcoxon rank-sum testing is used as a non-parametric alternative.

Categorical relationships are evaluated with Pearson's chi-square test.

Age and capped Fare are compared with Spearman's rank correlation.

## Predictive Modeling

The target is binary survival status.

The model includes:

- passenger class
- sex
- age
- siblings/spouses
- parents/children
- capped fare
- embarkation
- cabin-recorded indicator

The model is trained on 70% of the dataset. Ten-fold cross-validation is used within the training data, and the held-out portion is used once for final evaluation.

## Interpretation

The model is intentionally interpretable. Odds ratios are reported so that the direction and relative strength of predictors can be communicated without treating the model as a black box.
