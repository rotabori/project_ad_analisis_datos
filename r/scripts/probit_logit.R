## PROJECT: ANALISIS DE DATOS
## PROGRAM: probit_logit.r
## PROGRAM TASK: REGRESION LINEAL
## AUTHOR: RODRIGO TABORDA
## AUTHOR: JUAN PABLO MONTENEGRO
## DATE CREATEC: 2020/06/02
## DATE REVISION 1:
## DATE REVISION #:

####################################################################;
## #0 PROGRAM SETUP
####################################################################;

    rm(list=ls())
    
## #0.1 ## SET PATH FOR READING/SAVING DATA;

#    setwd()

### #0.2 ## INSTALL PACKAGES;
#    #SOLO ES NECESARIO INSTALARLOS UNA VEZ
#
#    install.packages("margins")
#        #PAQUETE PARA EFECTOS MARGINALES
#
#    install.packages("ggplot2")
#        #PAQUETE PARA GRAFICOS
#
#    install.packages("readstata13")
#        #PAQUETE PARA LECTURA ARCHIVO STATA13
#
## #0.3 ## CALL PACKAGES;
    #ES NECESARIO LLAMARLOS CADA RUTINA

    library(margins)
        #PAQUETE PARA EFECTOS MARGINALES

    library(ggplot2)
        #PAQUETE PARA GR?FICOS

    library(readstata13)
        #PAQUETE PARA LECTURA ARCHIVO STATA13

####################################################################;
## #20 ## DATOS IEFIC;
####################################################################;

## #20.1 ## DATA-IN;

    iefic <- read.dta13("http://www.rodrigotaborda.com/ad/data/iefic/2016/iefic_2016_s13.dta")
#    iefic <- na.omit(iefic)
        # REMOVE N.A. OBSERVATIONS

    iefic01 <- iefic[c("p2540", "ingreso")]
    iefic01 <- na.omit(iefic01)

## #20.2 ## REGRESION LINEAL;




## #20.3 ## REGRESION LOGIT;

    logit01 <- glm(data = iefic01,
                   formula = p2540 ~ ingreso,
                   family = "binomial")

    summary(logit01)

## #20.3.1 ## VALORES PREDICHOS;

    logit01_b <- logit01$coefficients

    ingreso_pred <- c(seq(from = 0, to = 20000000, by = 500000))

    logit01_xb <- matrix(data = 0, ncol = 1, nrow = length(ingreso_pred))

    for (i in 1:length(ingreso_pred)) {
        logit01_xb[i,] <- logit01_b[1] + logit01_b[2]*ingreso_pred[i]
    }

    logit01_pred <- exp(logit01_xb)/(1+exp(logit01_xb))

    plot(logit01_pred, type = "l")

## #20.3.2 ## EFECTO MARGINAL;

    logit01_mgeff <- (exp(logit01_xb)/(1+exp(logit01_xb))^2) * logit01_b[2]

    plot(logit01_mgeff, type = "l")

## #20.3.4 ## EFECTO MARGINAL + MARGINS;

    summary(margins(logit01, variables = "ingreso"))

    logit01_mgeff01 <- margins(logit01, at = list(ingreso = seq(from = 0, to = 20000000, by = 500000)))

    cplot(logit01, "ingreso", what = "prediction", main = "Probabilidad predicha")
        #PROBABILIDAD PREDICHA

    cplot(logit01, "ingreso", what = "effect", main = "Efecto marginal", draw = T)
        #EFECTO MARGINAL






####################################################################;
## #99 CLEAN
####################################################################;

    rm(list=ls())
