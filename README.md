
# Employee Attrition Predictor

**Predict employee attrition using machine learning techniques and help businesses retain talent effectively.**

## Project Overview

In the business world, retaining talented employees is a significant challenge. This project analyzes and predicts employee attrition using IBM's HR Analytics Employee Attrition dataset. The Employee Attrition Predictor helps organizations identify employees likely to leave by analyzing historical data. Built using Random Forest and Recursive Feature Elimination, it highlights key factors influencing attrition. An interactive Shiny App interface allows users to upload data, view predictions, and explore contributing factors easily.


![image](https://github.com/user-attachments/assets/25bb5c23-138b-4355-94b9-f13dfb08ed56)
---

## Table of Contents

- [Dataset](#dataset)
- [Objective](#objective)
- [Data Preprocessing](#data-preprocessing)
- [Feature Selection](#feature-selection)
- [Implemented Models](#implemented-models)
- [How to Use](#how-to-use)

---

## Dataset

- **Source:** [Kaggle: IBM HR Analytics Employee Attrition & Performance](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)
- **Description:** This dataset contains 35 features related to employee performance, demographics, and workplace factors, aiming to predict attrition effectively.

---

## Objective

To analyze employee turnover factors and predict attrition using machine learning, enabling companies to devise effective retention strategies while reducing costs associated with turnover.

---

## Data Preprocessing

1. **Missing Values:** No missing values detected in the dataset.
2. **Data Conversion:** All categorical variables were transformed into factors; numeric standardization was applied using Z-score scaling.
3. **Class Imbalance Handling:**
   - SMOTE was initially used but resulted in synthetic data challenges.
   - The `ovun.sample()` function was finalized to achieve a balanced dataset through oversampling and undersampling.

---

## Feature Selection

Four feature selection methods were explored to optimize model performance:
- **LASSO:** Selected 26 features.
- **Boruta:** Selected 16 features.
- **RFE:** Selected 8 features (e.g., Monthly Income, Age, Over Time).
- **Full Dataset:** All 35 features used.

---

## Implemented Models

1. **Logistic Regression**
2. **Support Vector Machine (SVM)**
3. **Random Forest**
4. **Naive Bayes**
5. **k-Nearest Neighbors (KNN)**
6. **XGBoost**

### Key Techniques
- **Dataset Shuffling:** Mitigates bias due to data ordering.
- **k-Fold Cross-Validation (k=12):** Ensures reliable performance evaluation.

---

The **Random Forest** model was chosen as it provided reliable accuracy without overfitting with lesser number of features, making it the preferred model for practical use. While XGBoost achieved the highest accuracy, its overfitting limits generalizability. The **Recursive Feature Elimination (RFE)** method narrowed the features to 8, improving efficiency while retaining predictive power.

---

## How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/employee-attrition-predictor.git
   cd employee-attrition-predictor
   ```
2. Install required packages:
   ```R
   install.packages(c("e1071", "caret", "randomForest", "xgboost", "class", "dplyr"))
   ```
3. Run the models:
   ```R
   source("predictor_script.R") # Replace with actual script name
   ```
4. Visualize results and confusion matrices to evaluate model performance.

---

## License

This project is licensed under the MIT License.

---

