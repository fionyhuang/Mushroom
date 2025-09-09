#####################
#Linear Discriminate#
#####################

load(file = "/Users/fionhuang/Desktop/Pstat 131/Final Project/RDA/Model_Setup.rda") 

set.seed(2002)

# Setting up the model
lda_mod <- discrim_linear() %>% 
  set_mode("classification") %>% 
  set_engine("MASS")

# Workflow
lda_wkflow <- workflow() %>% 
  add_model(lda_mod) %>% 
  add_recipe(mushroom_recipe) 

# Fitting model to the training data
lda_fit <- fit(lda_wkflow, train)
predict(lda_fit, new_data = train, type="prob")

# No need to create a tuning grid because there is no tuning parameters

# Fitting the model to our folded data
lda_kfold_fit <- fit_resamples(lda_wkflow, folds)
# Usually we would need to tune the model but Logistic Regression does not need to be tune

# Collecting the metrics of the model
collect_metrics(lda_kfold_fit)
#roc_auc 0.787 Model 1

save(lda_fit, lda_kfold_fit,
     file = "/Users/fionhuang/Desktop/Pstat 131/Final Project/RDA/Linear Discriminate.rda")