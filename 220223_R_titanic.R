library(tidyverse) #Tidyverse 패키지
library(ggplot2) #시각화 패키지
library(plotly)  #반응형 시각화 패키지
library(rpart) # 의사결정 나무
library(rpart.plot) # 의사결정 나무 시각화 
library(caret) # 데이터 처리 패키지
library(e1071)   #혼동행렬 패키지
library(randomForest)  #Random Forest 패키지

train<-read.csv("C:/Users/user/Desktop/데이터분석/220203 프로젝트1_titanic/train.csv")
test<-read.csv("C:/Users/user/Desktop/데이터분석/220203 프로젝트1_titanic/test.csv")
str(test)
# Factor데이터셋 character로 변경(Cabin, Ticket, Name)
# Int 데이터셋 Factor로 변경(Pclass)
train$Pclass <- as.factor(train$Pclass)
train$Name <- as.character(train$Name)
train$Ticket <- as.character(train$Ticket)
train$Cabin <- as.character(train$Cabin)
train$Sex <- as.factor(train$Sex)
train$Embarked <- as.factor(train$Embarked)
str(train)
test$Pclass <- as.factor(test$Pclass)
test$Name <- as.character(test$Name)
test$Ticket <- as.character(test$Ticket)
test$Cabin <- as.character(test$Cabin)
test$Sex <- as.factor(test$Sex)
test$Embarked <- as.factor(test$Embarked)
str(test)
summary(test)
summary(train)
#Age has 177 NaN
sum(is.na(train))
# There are 177 NaN in Age dataset
sapply(train, function(x){sum(is.na(x))})
#Delete NaN age data
train<-na.omit(train)
sum(is.na(train))
#Age categorization

train <- train %>% 
  mutate(Ages = case_when(
    Age < 10 ~ "Under 10",
    Age < 20 ~ "10 ~ 20",
    Age < 30 ~ "20 ~ 30",
    Age < 40 ~ "30 ~ 40",
    Age < 50 ~ "40 ~ 50",
    Age < 60 ~ "50 ~ 60",
    TRUE ~ "over 60"
  )) 

train$Ages <- 
  factor(train$Ages,
         levels = c("Under 10", "10 ~ 20", "20 ~ 30", "30 ~ 40", "40 ~ 50", "50 ~ 60", "over 60"))

data_cleanging <- train %>% 
  group_by(Ages) %>% 
  summarise(Ages_count = n())

ggplot(data_cleanging, aes(x = Ages, y = Ages_count, fill=Ages)) +
  geom_col() +
  geom_text(aes(label=(Ages_count)), vjust=3, hjust = 0.5,color="black", size=4) +
  theme(axis.text.x = element_text(size=10)) +
  theme(axis.text.y = element_text(size=10))
#How sex influence survival
sex_survival<-ggplot(train, aes(x=Survived, fill=Sex))+geom_bar()
ggplotly(sex_survival)
#How Pclass influence survival
pclass_survival<-ggplot(train, aes(x=Survived, fill=Pclass))+geom_bar()
ggplotly(pclass_survival)
#How Age influence survival
age_survival<-ggplot(train, aes(x=Survived, fill=Ages))+geom_bar()
ggplotly(age_survival)

#How having Siblings or Spouse influence survival
sibsp_survival<-ggplot(train, aes(x=Survived, fill=factor(SibSp)))+geom_bar()+ggtitle("Survival rate of those who had siblings or spouses")
ggplotly(sibsp_survival, height=500, width=800)

#How having parentes or children influence survival
parch_survival<-train %>% 
  ggplot(aes(x=Survived, fill=factor(Parch)))+geom_bar()+ggtitle("Survival rate of those who had parents or children")
ggplotly(parch_survival, height=500, width=800)

#Change Survived(Int) to Factor
train$Survived<-as.factor(train$Survived)
str(train)

#Decision tree model
decision_tree<-rpart(Survived~Pclass+Age+Sex, data=train)
prp(decision_tree, type=4, extra=2, digits=7)
#Implying Decision tree model to test dataset
decision_tree_test<-predict(decision_tree, newdata=test, type = "class")

#Create Random forest model
random_forest_train<-randomForest(Survived~Pclass+Age+Sex, data=train)
#Establish importance of features'; importance for random forest model
randomfort_importance<-randomForest(Survived ~Sex+Age+Pclass, data = train, importance=TRUE)
importance(randomfort_importance)
varImpPlot(randomfort_importance)
#Implying random forest model to test dataset
random_forest_test=predict(randomfort_importance, newdata=test, type="class")

#Submission(Decision tree)
Titanic_R_Decision_tree_prediction <- data.frame(PassengerID = test$PassengerId, Survived = decision_tree_test)
write.csv(Titanic_R_Decision_tree_prediction, file = "Titanic_R_Decision_tree_prediction.csv", row.names = FALSE)

#Submission(Random forest)
Titanic_R_Random_forest_prediction<-data.frame(PassengerID = test$PassengerId, Survived = random_forest_test)
write.csv(Titanic_R_Random_forest_prediction, file = "Titanic_R_Random_forest_prediction.csv", row.names = FALSE)
