## PROJECT: ANALISIS DE DATOS
## PROGRAM: pca_fa.r
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
#    install.packages("ggplot2")
#        #PAQUETE PARA GR?FICOS

## #0.3 ## CALL PACKAGES;
    #ES NECESARIO LLAMARLOS CADA RUTINA

    library(ggplot2)
        #PAQUETE PARA GR?FICOS

####################################################################;
## #10 ## DATOS AUTO;
####################################################################;

## #30.1 ## DATA-IN;

    auto <- read.table("http://faculty.marshall.usc.edu/gareth-james/ISL/Auto.data",
                        header = TRUE,
                        na.strings = "?")
    auto <- na.omit(auto)
        #REMOVE N.A.

## #10.2 ## GRAFICA PRELIMINAR;

    plot(auto$horsepower, auto$mpg)
    plot(auto$weight, auto$mpg)

## #10.4 ## PCA;

    auto2 <- auto[c("mpg", "horsepower", "weight")]

    pca <- prcomp(auto2, scale = T)
        #CONDUCT PCA

        ev <- NULL
        ev <- pca$sdev^2
        ev
            #EXTRACT EIGEN VALUES

        ev_prop = ev/sum(ev)
        ev_prop
            #EXTRACT EIGEN VALUES SHARE

        pca$rotation
            #LOADINGS

        summary(pca)
            #SD, VARIANCE PROPORTION, VARIANCE CUMMULATIVE PROPORTION

        plot(ev, xlab="Eigen values",
             ylab="Eigen values",type='b')
             #EIGEN VALUES GRAPH

        plot(ev_prop, xlab="Principal Component",
             ylab="Proportion of Variance Explained", ylim=c(0,1), type='b')
             #EIGEN VALUES SHARE GRAPH

## #10.5 ## PCA + REGRESSION;

    pc1 <- pca$rotation[,1]
    pc1 <- as.data.frame(pc1)
        # EXTRACT COMPONENT 1

    apply(pc1, MARGIN = 2, FUN = function(x) (sum(x^2))) #debe ser igual a 1

    model1 <- lm(acceleration ~ pc1, data=auto)
        # REGRESSION










####################################################################;
## #99 CLEAN
####################################################################;

    rm(list=ls())
