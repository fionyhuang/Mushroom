#####################
#Random Forest Model#
#####################

load(file = "/Users/fionhuang/Desktop/Pstat 131/Final Project/RDA/Model_Setup.rda")

set.seed(2002)

# Setup a random forest model. Use the `ranger` engine and set 
#`importance = "impurity"`. Let's also tune `mtry`, `trees`, and `min_n`.
rf_model <- rand_forest(mtry = tune(), 
                             trees = tune(), 
                             min_n = tune()) %>%
  set_engine("ranger", importance = "impurity") %>% 
  set_mode("classification")

# Workflow
rf_wkflow <- workflow() %>% 
  add_model(rf_model) %>% 
  add_recipe(mushroom_recipe)

# Creating parameter grid to tune ranges of hyper parameters
rf_grid <- grid_regular(mtry(range = c(2, 7)), trees(range = c(2, 5)), 
                                     min_n(range = c(2, 4)), levels = 4)

# We'll do the below steps for both `roc_auc` and `accuracy` in order to use both in our project report
# ROC AUC

# Next, let's fit the models to our folded data using `tune_grid()`
rf_tune_auc <- tune_grid(rf_wkflow, resamples = folds, grid = rf_grid, metrics = metric_set(yardstick::roc_auc)) 

# find the `roc_auc` of best-performing random forest tree on the folds
# use `collect_metrics()` and `arrange()`
best_rf_auc <- dplyr::arrange(collect_metrics(rf_tune_auc), desc(mean))
head(best_rf_auc)


# select the random forest with the best `roc_auc`
best_rf_complexity_auc <- select_best(rf_tune_auc)

# use `finalize_workflow()` and `fit()` to fit the model to the training set
rf_final_auc <- finalize_workflow(rf_wkflow, best_rf_complexity_auc)
rf_final_fit_auc <- fit(rf_final_auc, data = train)


# Accuracy 

# fitting the models to our folded data using `tune_grid()`
rf_tune_acc <- tune_grid(rf_wkflow, resamples = folds, grid = rf_grid, metrics = metric_set(accuracy)) 

# find the `accuracy` of best-performing random forest tree on the folds
# use `collect_metrics()` and `arrange()`
best_rf_acc <- dplyr::arrange(collect_metrics(rf_tune_acc), desc(mean))
head(best_rf_acc)

# select the random forest with the best `accuracy`
best_rf_complexity_acc <- select_best(rf_tune_acc)

#use `finalize_workflow()` and `fit()` to fit the model to the training set
rf_final_acc <- finalize_workflow(rf_wkflow, best_rf_complexity_acc)
rf_final_fit_acc <- fit(rf_final_acc, data = train)

save(rf_tune_auc, rf_final_fit_auc, best_rf_auc,
     rf_tune_acc, rf_final_fit_acc, best_rf_acc, 
     file = "/Users/fionhuang/Desktop/Pstat 131/Final Project/RDA/Random Forest.rda")


