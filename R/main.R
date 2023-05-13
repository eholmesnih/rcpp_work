library(Rcpp)
library(tidyverse)
sourceCpp('R//cpp_fns.cpp')


titanic <- read_csv('DATA//titanic.csv')  ##Import data
cleaned_df <- titanic %>% ## clean data by adding an ID column, making class and sex cols s factors and dropping a few cols
  drop_na()  %>%  
  mutate(travelerID = row_number(), .before=1, PClass = factor(PClass, ordered = T),
                                   Sex = factor(Sex, ordered = F),Survived = recode(Survived,'0' = 'Died', '1' = 'Lived')) %>%  
  select(-Name, - SexCode)

#use 70% of dataset as training set and 30% as test set 
set.seed(1)
train <- cleaned_df %>% dplyr::sample_frac(0.70)
test  <- dplyr::anti_join(cleaned_df, train, by = 'travelerID')

cleaned_df %>% ggplot(aes( x = PClass)) + geom_bar(aes(fill = Survived))
train %>% ggplot(aes( x = PClass)) + geom_bar(aes(fill = Survived))
test %>% ggplot(aes( x = PClass)) + geom_bar(aes(fill = Survived))
