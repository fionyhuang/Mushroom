###############
#Decision Tree#
###############

load(file = "/Users/fionhuang/Desktop/Pstat 131/Final Project/RDA/Model_Setup.rda") 

set.seed(2002)

# Setting up the model, tune the `cost_complexity` hyper parameter
tree_model <- decision_tree(cost_complexity = tune()) %>%
  set_engine("rpart") %>% 
  set_mode("classification")

# Workflow
tree_wkflow <- workflow() %>% 
  add_model(tree_model) %>% 
  add_recipe(mushroom_recipe)

# Creating parameter grid to tune ranges of hyper parameters
tree_grid <- grid_regular(cost_complexity(range = c(-3, -1)), levels = 5)

# Fitting the models to the folded data using `tune_grid()`
tree_tune <- tune_grid(tree_wkflow, resamples = folds, grid = tree_grid)

# Collecting the metrics of the model
collect_metrics(tree_tune)
# Use `show_best()` to choose the model that has the optimal `roc_auc`.
show_best(tree_tune, metric = "roc_auc")
# roc_auc 0.971 Model 1

# Use `finalize_workflow()` and `fit()` to fit the model to the training set
dt_final <- finalize_workflow(tree_wkflow, select_best(tree_tune))
dt_final
dt_final_fit <- fit(dt_final, data = train)
dt_final_fit

save(tree_tune, dt_final_fit,
     file = "/Users/fionhuang/Desktop/Pstat 131/Final Project/RDA/Decision Tree.rda")
