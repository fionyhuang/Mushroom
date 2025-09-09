#####################
#Logistic Regression#
#####################

load(file = "/Users/fionhuang/Desktop/Pstat 131/Final Project/RDA/Model_Setup.rda") 

set.seed(2002)
# Setting up the model
log_reg <- logistic_reg() %>% 
  set_engine("glm") %>% # Specify the engine
  set_mode("classification")

# Workflow
log_wkflow <- workflow() %>% 
  add_model(log_reg) %>% 
  add_recipe(mushroom_recipe)

# Fitting model to the training data
log_fit <- fit(log_wkflow, train)
predict(log_fit, new_data = train, type="prob")

# No need to create a tuning grid because there is no tuning parameters

# Fitting the model to our folded data
log_kfold_fit <- fit_resamples(log_wkflow, folds) 
# Usually we would need to tune the model but Logistic Regression does not need to be tune

# Collecting the metrics of the model
collect_metrics(log_kfold_fit)
#roc_auc 0.788 Model 1

save(log_fit, log_kfold_fit, 
     file = "/Users/fionhuang/Desktop/Pstat 131/Final Project/RDA/Logistic Regression.rda")
