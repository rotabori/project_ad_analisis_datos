## PROJECT: ANALISIS DE DATOS
## PROGRAM: anova.r
## PROGRAM TASK: ANOVA ANALYSIS
## AUTHOR: RODRIGO TABORDA
## AUTHOR: JUAN PABLO MONTENEGRO
## DATE CREATEC: 2020/05/20
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
#    install.packages("rapportools")
#        #PAQUETE PARA GR?FICO BOX-PLOT
#
#    install.packages("readstata13")
#        #PAQUETE PARA LECTURA ARCHIVO STATA13
#
#    install.packages("ggplot2")
#        #PAQUETE PARA GR?FICOS
#
## #0.3 ## CALL PACKAGES;
    #ES NECESARIO LLAMARLOS CADA RUTINA

    library(rapportools)
        #PAQUETE PARA GR?FICO BOX-PLOT

    library(readstata13)
        #PAQUETE PARA LECTURA ARCHIVO STATA13

    library(ggplot2)
        #PAQUETE PARA GR?FICOS

####################################################################;
## #10 ## DATOS SIMULADOS;
####################################################################;

## #10.1 ## DATA-IN;

    estatura <- c(170,180,170,168,164,175,180,178,170,178,168,168)
        # INGRESAR DATOS MANUALMENTE
    tratamiento <- c(0,1,0,0,0,1,1,1,0,1,0,0)
        # INGRESAR DATOS MANUALMENTE

    sim <- cbind(estatura, tratamiento)
        # AGRUPA COLUMNAS
    sim <- as.data.frame(sim)
        # COLUMNAS A DATA-FRAME

    summary(sim)

## #10.2 ## GRAFICA PRELIMINAR;

    boxplot(estatura ~ tratamiento, data = sim)

## #10.3 ## PRUEBA T;

    t.test(estatura ~ tratamiento, data = sim)
        # PRUEBA T

## #10.4 ## ANOVA;

    anova1 <- aov(estatura ~ tratamiento, data = sim)
        summary(anova1)
		#TukeyHSD(anova1)

####################################################################;
## #20 ## DATOS ENCUESTA ESTUDIANTES;
####################################################################;

## #20.1 ## DATA-IN;

    encuesta <- read.dta13("http://rodrigotaborda.com/ad/data/ee/encuesta_estudiantes_202010_old.dta")
    encuesta <- na.omit(encuesta)
        # REMOVE N.A. OBSERVATIONS

## #20.2 ## GRAFICA PRELIMINAR;

    boxplot(encuesta$estatura ~ encuesta$genero)
    ggplot(encuesta, aes(y=estatura, x=factor(genero))) + geom_boxplot()

    hist(encuesta$estatura, main="Histogram")
    ggplot(encuesta, aes(x=estatura)) + geom_histogram(aes(y = ..density.., color = genero, fill = genero), bins = 30)

    plot(density(encuesta$estatura, kernel = c("gaussian"), na.rm = TRUE))
    plot(density(encuesta[encuesta$genero=="hombre",]$estatura, kernel = c("gaussian"), na.rm = TRUE), main="Hombre")
    plot(density(encuesta[encuesta$genero=="mujer",]$estatura, kernel = c("gaussian"), na.rm = TRUE), main="Mujer")

## #20.3 ## PRUEBA T;

    t.test(encuesta$estatura ~ encuesta$genero)
        # PRUEBA T

## #20.4 ## ANOVA;

    anova2 <- aov(encuesta$estatura ~ encuesta$genero)
        summary(anova2)
        TukeyHSD(anova2)










####################################################################;
## #99 CLEAN
####################################################################;

    rm(list=ls())
