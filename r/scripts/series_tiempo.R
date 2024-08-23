## PROJECT: ANALISIS DE DATOS
## PROGRAM: series_tiempo.r
## PROGRAM TASK: REGRESION LINEAL
## AUTHOR: RODRIGO TABORDA
## AUTHOR: JUAN PABLO MONTENEGRO
## DATE CREATEC: 2020/06/03
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



## #0.3 ## CALL PACKAGES;
    #ES NECESARIO LLAMARLOS CADA RUTINA



####################################################################;
## #10 ## DATOS SIMULADOS;
####################################################################;

## #10.1 ## DATA-IN;

    set.seed(12345)

    e1 <- rnorm(1, mean = 0, sd = 3)

    y1 <- c(1:180)
    y2 <- c(1:180)
    y3 <- c(1:180)

    y1[1] <- e1[1]
    y2[1] <- e1[1]
    y3[1] <- e1[1]

## #10.1.1 ## ESTACIONARIO + SIN CONSTANTE;

    for (i in 1:179) {
        y1[i+1] <- 0.4*y1[i] + e1
    }
        #SIMULAR SERIE DE TIEMPO

    y1_ts <- ts(y1)
        #DEFINIR COMO SERIE DE TIEMPO

    plot.ts(y1_ts)
        #GRAFICA SERIE DE TIEMPO

    y1_acf <- acf(y1_ts,
                  lag.max = 30, 
                  type = c("correlation"), 
                  plot = TRUE, 
                  main = "Autocorrelation function y1")
        #ACF

    pacf <- pacf(y1_ts, 
                 lag.max = 30, 
                 plot = TRUE, 
                 main = "Partial Autocorrelation function y1")
        #PACF

    arima_y1_ts <- arima(y1_ts,c(1,0,0))
    summary(arima_y1_ts)
        #ARIMA MODEL

    arima_y1_ic <- c(arima_y1_ts$aic)
    names(arima_y1_ic) <- c("aic")
    arima_y1_ic
        #CRITERIO DE INFORMACIÓN AIC

## #10.1.2 ## ESTACIONARIO + SIN CONSTANTE;

    for (i in 1:179) {
        y2[i+1] <- 0.9*y2[i] + e1
    }

    y2_ts <- ts(y2)
        #DEFINIR COMO SERIE DE TIEMPO

    plot.ts(y2_ts)
        #GRAFICA SERIE DE TIEMPO

    y2_acf <- acf(y2_ts,
                  lag.max = 30, 
                  type = c("correlation"), 
                  plot = TRUE, 
                  main = "Autocorrelation function y2")
        #ACF

    pacf <- pacf(y2_ts, 
                 lag.max = 30, 
                 plot = TRUE, 
                 main = "Partial Autocorrelation function y2")
        #PACF

    arima_y2_ts <- arima(y2_ts,c(1,0,0))
    summary(arima_y2_ts)
        #ARIMA MODEL

    arima_y2_ic <- c(arima_y2_ts$aic)
    names(arima_y2_ic) <- c("aic")
    arima_y2_ic
        #CRITERIO DE INFORMACIÓN AIC

## #10.1.3 ## NO ESTACIONARIO + SIN CONSTANTE;

    for (i in 1:179) {
        y3[i+1] <- 1*y3[i] + e1
    }

    y3_ts <- ts(y3)
        #DEFINIR COMO SERIE DE TIEMPO

    plot.ts(y3_ts)
        #GRAFICA SERIE DE TIEMPO

    y3_acf <- acf(y3_ts,
                  lag.max = 30, 
                  type = c("correlation"), 
                  plot = TRUE, 
                  main = "Autocorrelation function y3")
        #ACF

    pacf <- pacf(y3_ts, 
                 lag.max = 30, 
                 plot = TRUE, 
                 main = "Partial Autocorrelation function y3")
        #PACF

    arima_y3_ts <- arima(y3_ts,c(1,0,0))
    summary(arima_y3_ts)
        #ARIMA MODEL

    arima_y3_ic <- c(arima_y3_ts$aic)
    names(arima_y3_ic) <- c("aic")
    arima_y3_ic
        #CRITERIO DE INFORMACIÓN AIC






####################################################################;
## #99 CLEAN
####################################################################;

    rm(list=ls())





## Estimación de la serie --------------------------------------------------
#
##Dickey-Fuller test
#library(fUnitRoots)
#
#adfTest(y1_t,lags=0,type=c("c"))
#adfTest(y2_t,lags=0,type=c("c"))
#adfTest(y3_t,lags=0,type=c("c"))
##Ho: La serie es no estacionaria/Tiene raíz unitaria
##Ha: La serie es estacionaria/No Tiene raíz unitaria

##VIDEO PRUEBA RAIZ UNITARIA https://youtu.be/fMqwBJrxJ8s
