#####
#KNN#
#####

load(file = "/Users/fionhuang/Desktop/Pstat 131/Final Project/RDA/Model_Setup.rda") 

set.seed(2002)

# Setting up the model
knn_model <- nearest_neighbor(neighbors = tune()) %>%
  set_engine("kknn") %>%
  set_mode("classification")

# Workflow
knn_wkflow <- workflow() %>% 
  add_model(knn_model) %>% 
  add_recipe(mushroom_recipe)

# Creating parameter grid to tune ranges of hyper parameters
knn_grid <- grid_regular(neighbors(range = c(1,10)), levels = 5)

# Fitting the models to the folded data using `tune_grid()`
knn_tune <- tune_grid(knn_wkflow, resamples = folds, grid = knn_grid)

# Collecting the metrics of the model
collect_metrics(knn_tune)
# Use `show_best()` to choose the model that has the optimal `roc_auc`.
show_best(knn_tune, metric = "roc_auc")
# roc_auc 0.998, Model 5, Neighbors 10

# Use `finalize_workflow()` and `fit()` to fit the model to the training set
knn_final <- finalize_workflow(knn_wkflow, select_best(knn_tune))
knn_final
knn_final_fit <- fit(knn_final, train)
knn_final_fit

save(knn_tune, knn_final_fit,
     file = "/Users/fionhuang/Desktop/Pstat 131/Final Project/RDA/knn.rda")

