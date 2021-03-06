#Regress�o Linear M�ltipla Trabalho ----

#OBS:Put more trust in your script than in your memory,
#    and don't save your workspace.

# Projeto de ML em R Template Basico ----

# 1. Crie um projeto em R ----
# a) Crie e organize o diret�rios
# b) Use esse script como base

# 2. Prepare o Problema ----
# a) Carregue os pacotes necess�rios ----
library(readr)
library(ggplot2)
#Pacote para mapear "missing values"
library(Amelia)
#Pacote para visualizar correla��es
library(corrplot)


# b) Carregue os dados ----

##Importando os dados no R ----

housing <- read_csv("../Dados/BostonHousing_Trabalho.csv")

View(housing)
hr <- housing
str(hr)

# c) Separe os dados para a sua valida��o ----
#Separa��o simples (ing�nua - n�o estratificada)

#Fixando a semente
set.seed(1)
corte = 0.80
train_index <- sample(1:nrow(hr),corte*nrow(hr))
hr_train <- hr[train_index,]
hr_test <- hr[-train_index,]


# 3. Vis�o Geral Preliminar dos Dados ----
# a) Estat�sticas descritivas 
# b) Visualiza��o dos dados 

# 4. Avalia��o do Modelos/Algoritmos ----
# a) Defina as op��es validar e testar seu modelo
# b) M�trica de avalia��o do modelo

# 5. Refinamento do modelo ----

