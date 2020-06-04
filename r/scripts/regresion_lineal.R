## PROJECT: ANALISIS DE DATOS
## PROGRAM: regresion.r
## PROGRAM TASK: REGRESION LINEAL
## AUTHOR: RODRIGO TABORDA
## AUTHOR: JUAN PABLO MONTENEGRO
## DATE CREATEC: 2020/06/01
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
#    install.packages("ggthems")
#        #PAQUETE PARA GR?FICOS
#
#    install.packages("ggplot2")
#        #PAQUETE PARA GR?FICOS
#
#    install.packages("readstata13")
#        #PAQUETE PARA LECTURA ARCHIVO STATA13
#
## #0.3 ## CALL PACKAGES;
    #ES NECESARIO LLAMARLOS CADA RUTINA

    library(ggthemes)
        #PAQUETE PARA GRAFICA CON ESTILO STATA

    library(ggplot2)
        #PAQUETE PARA GR?FICOS

    library(readstata13)
        #PAQUETE PARA LECTURA ARCHIVO STATA13

####################################################################;
## #10 ## DATOS SIMULADOS;
####################################################################;

## #10.1 ## DATA-IN;

    retornos <- c(3,1,2,1,3,4)
    liquidez <- c(0,0,0,1,1,1)
    id <- c("a","b","c","d","e","f")
        # INGRESAR DATOS MANUALMENTE

    sim <- cbind(retornos,liquidez)
        # AGRUPA COLUMNAS
    sim <- as.data.frame(sim)
        # COLUMNAS A DATA-FRAME

    summary(sim)

## #10.2 ## GRAFICA PRELIMINAR;

    plot(sim$liquidez,sim$retornos)

## #10.3 ## REGRESION;

    model1 <- lm(retornos ~ liquidez, data = sim)
    summary(model1)
        # REGRESION

## #10.4 ## GRAFICA REGRESION;

    ggplot(sim, aes(x=liquidez, y=retornos)) +
        ggtitle("Retorno vs. Liquidez") +
        geom_point(alpha=1, shape=1) +
        geom_smooth(col="red", method="lm") +
        theme_stata() +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle =element_text(hjust = 0.5))

## #10.5 ## PREDICTED & RESIDUALS;

    model1_fitted <- model1$fitted.values
    model1_res <- model1$residuals

####################################################################;
## #20 ## DATOS ENCUESTA ESTUDIANTES;
####################################################################;

## #20.1 ## DATA-IN;

    encuesta <- read.dta13("http://rodrigotaborda.com/ad/data/ee/encuesta_estudiantes_202010_old.dta")
    encuesta <- na.omit(encuesta)
        # REMOVE N.A. OBSERVATIONS

## #20.2 ## GRAFICA PRELIMINAR;

    plot(encuesta$cal_herr_exp,encuesta$cal_prob)

## #20.3 ## REGRESION;

    model2 <- lm(cal_herr_exp ~ cal_prob, data = encuesta)
    summary(model2)
        # REGRESION

## #20.4 ## GRAFICA REGRESION;

    ggplot(encuesta, aes(x=cal_prob, y=cal_herr_exp)) +
        ggtitle("Exp. Herr1 vs. Probabilidad") +
        geom_point(alpha=1, shape=1) +
        geom_smooth(col="red", method="lm") +
        theme_stata() +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle =element_text(hjust = 0.5))

## #20.5 ## PREDICTED & RESIDUALS;

    model2_fitted <- model2$fitted.values
    model2_res <- model2$residuals









####################################################################;
## #99 CLEAN
####################################################################;

    rm(list=ls())
