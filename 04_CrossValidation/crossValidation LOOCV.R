#Cross Validation LOOCV

#Carregando LIBRARIES (Pacotes)

##lib para gr�ficos
library(ggplot2)

##lib para ML + Cross validation
library(caret)

#carregando os dados
#Usando Rdata ao inves do script
#source("CarregamentoDados/loadHousingSmall.R")
load("Dados_RData/housingSmall.Rdata")

source("multPlotFunction.R")


# Visualizando os dados LOOCV N=1
hr_train <- hr[-1,]
hr_test <- hr[1,]
g <- ggplot(data = hr_train,aes(x = area,y = preco))
#pontos de treinamento
g <- g +  geom_point(colour = "Blue",size = 3) +
  # Pontos de test
  geom_point(data = hr_test,
             aes(x = area,y = preco),
             colour = "red", size = 3) +
  #Labels 
  labs( title = "Pre�os de Venda de im�veis",
        y = "Pre�o (x R$1000,00)",
        x = "�rea (x 100m2)" )
g

#' Regressao_Simples
hr_lm <- lm(data = hr_train, preco ~ area)

###Alternativa 2 (Usando ggplot e geom_abline() )

g <-  g + geom_abline(intercept = hr_lm$coef[1], slope = hr_lm$coef[2],
                       color = "Blue", size = 1)

#Plotando segmentos
prev <- predict(hr_lm,hr_test)
prev
df <- hr_test
df["prev"] = prev

g + geom_segment(aes(x = area, y = prev,xend = area, yend = preco ),
                  color = "Red",
                  data = df)


#'------------------------------------------------LOOCV N=1

#Imprimindo gr�ficos em grid
nr <- nrow(hr)
lg <- vector("list", nr)

for(i in 1:nr){
  hr_train <- hr[-i,]
  hr_test <- hr[i,]
  g <- ggplot(data = hr_train,aes(x = area,y = preco))
  g <- g +  geom_point(colour = "Blue",size = 3) +
    # Pontos de TEST
    geom_point(data = hr_test,
               aes(x = area,y = preco),
               colour = "red", size = 3) +
    #Labels 
    labs( title = "Pre�os de Venda de im�veis",
          y = "Pre�o (x R$1000,00)",
          x = "�rea (x 100m2)" ) +
    
    stat_smooth(method = lm, se = FALSE, formula = y ~ x,
              colour = "Black",linetype = "solid")
  lg[[i]] <- g
}

multiplot(plotlist = lg,cols = 4)



#' M�todo LOOCV
#Usando CARET ####
# define training control
train_control <- trainControl(method = "LOOCV")

# train the model
model <- train(preco~area, data=hr, trControl=train_control, method="lm")
# summarize results
print(model)

mse <- model$results$RMSE^2
mse


## Regress�o polinimial (2 e 17)

#Imprimindo gr�ficos em grid
nr <- nrow(hr)
lg <- vector("list", nr)
for(pot in c(2,17)){
  
  for(i in 1:nr){
    hr_train <- hr[-i,]
    hr_test <- hr[i,]
    g <- ggplot(data = hr_train,aes(x = area,y = preco))
    g <- g +  geom_point(colour = "Blue",size = 3) +
      # Pontos de TEST
      geom_point(data = hr_test,
                 aes(x = area,y = preco),
                 colour = "red", size = 3) +
      #Labels 
      labs( title = "Pre�os de Venda de im�veis",
            y = "Pre�o (x R$1000,00)",
            x = "�rea (x 100m2)" ) +
      
      stat_smooth(method = lm, se = FALSE, formula = y ~ poly(x,degree = pot,raw=TRUE),
                  colour = "Black",linetype = "solid")
    lg[[i]] <- g
  }
  
  multiplot(plotlist = lg,cols = 4)
}
  
#' M�todo LOOCV
#' N�o funcionou no loop for (train ...ploy)
#Usando CARET ####
# define training control
train_control <- trainControl(method = "LOOCV")

# train the model
model <- train(preco ~ poly(area,2,raw=TRUE), data = hr, trControl=train_control, method="lm")
# summarize results
print(model)

mse <- model$results$RMSE^2
mse

# train the model
model <- train(preco ~ poly(area,17,raw=TRUE), data = hr, trControl=train_control, method="lm")
# summarize results
print(model)

mse <- model$results$RMSE^2
mse

#Retirando os extremos ...
dd <- model$pred
dd <- dd[c(-1,-14),]
mse_dd <- mean((dd$pred-dd$obs)^2)
mse_dd
sqrt(mse_dd)




#Obs
#Usando CARET ####
# define training control

library(gridExtra)

#make two separate ggplot2 objects
#Now use grid.arrange to put them all into one figure.
#Note the use of ncol to specify two columns.  Things are nicely flexible here.

#N�o aceita uma lista de gr�ficos
#grid.arrange(g1,g2,g3,g4, ncol = 2))
