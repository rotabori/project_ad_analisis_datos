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
#    install.packages("ggplot2")
#        #PAQUETE PARA GR?FICOS
#
#    install.packages("readstata13")
#        #PAQUETE PARA LECTURA ARCHIVO STATA13
#
## #0.3 ## CALL PACKAGES;
    #ES NECESARIO LLAMARLOS CADA RUTINA
    
    library(ggplot2)
        #PAQUETE PARA GR?FICOS

    library(readstata13)
        #PAQUETE PARA LECTURA ARCHIVO STATA13
    
####################################################################;
## #10 ## DATOS SIMULADOS;
####################################################################;

## #10.1 ## DATA-IN;

    x1 <- c(1,5,1,4,1)
    x2 <- c(1,1,2,2,4)
    id <- c("a","b","c","d","e")
        # INGRESAR DATOS MANUALMENTE

    x <- cbind(x1,x2,id)
        # AGRUPA COLUMNAS
    x <- as.data.frame(x)
        # COLUMNAS A DATA-FRAME

## #10.2 ## GRAFICA PRELIMINAR;

    plot(x1,x2)
        # DISPERSION DE DATOS

    ggplot(x, aes(x1, x2, fill=id, color=id)) + geom_point()
        # DISPERSION DE DATOS

## #10.3 ## CLUSTER;

## #10.3.1 ## SINGLE LINKAGE;
    cluster_sl <- hclust(dist(x[,1:2]), method = "single")
        # SINGLE LINKAGE

    plot(cluster_sl, labels = x$id, main = "Single linkage")
        # DENDROGRAM

## #10.3.2 ## COMPLETE LINKAGE;
    cluster_cl <- hclust(dist(x[,1:2]), method = "complete")
        # COMPLETE LINKAGE

    plot(cluster_cl, labels = x$id, main = "Complete linkage")
        # DENDROGRAM

## #10.3.3 ## AVERAGE LINKAGE;
    cluster_al <- hclust(dist(x[,1:2]), method = "average")
        # AVERAGE LINKAGE

    plot(cluster_al, labels = x$id, main = "Average linkage")
        # DENDROGRAM

## #10.3.4 ## WARD LINKAGE;
    cluster_wl <- hclust(dist(x[,1:2]), method = "ward.D")
        # WARD LINKAGE

    plot(cluster_wl, labels = x$id, main = "Ward linkage")
        # DENDROGRAM

## #10.3.5 ## CENTROID LINKAGE;
    cluster_centl <- hclust(dist(x[,1:2]), method = "centroid")
        # CENTROID LINKAGE

    plot(cluster_centl, labels = x$id, main = "Centroid linkage")
        # DENDROGRAM

####################################################################;
## #20 ## DATOS CLASE;
####################################################################;

## #20.1 ## DATA-IN;

    estatura <- c(170,180,170,168,164,175,180,178,170,178,168,168)
    nombre <- c("Nico1","Nico2","Ana","Nohora","MaAle","JuanF1","JuanP","Laura","Diana","Esteban","Sebas","JuanF2")
        # INGRESAR DATOS MANUALMENTE

    y <- cbind(estatura,nombre)
        # AGRUPA COLUMNAS
    y <- as.data.frame(y)
        # COLUMNAS A DATA-FRAME

## #20.2 ## GRAFICA PRELIMINAR;

## #20.3 ## CLUSTER;

## #20.3.1 ## SINGLE LINKAGE;
    cluster_sl <- hclust(dist(y$estatura, method = "euclidean"), method = "single")
        # SINGLE LINKAGE

    plot(cluster_sl, labels = y$nombre, main = "Single linkage")
        # DENDROGRAM

####################################################################;
## #30 ## DATOS ENCUESTA ESTUDIANTES;
####################################################################;

## #30.1 ## DATA-IN;

    encuesta <- read.dta13("http://rodrigotaborda.com/ad/data/ee/encuesta_estudiantes_202010_old.dta")

## #20.2 ## GRAFICA PRELIMINAR;

## #20.3 ## CLUSTER;

## #20.3.1 ## SINGLE LINKAGE;
    encuesta <- na.omit(encuesta)
        # REMOVE N.A. OBSERVATIONS

    cluster_al <- hclust(dist(encuesta$estatura, method = "euclidean"), method = "average")
        # SINGLE LINKAGE
    
    plot(cluster_al, main = "average linkage")
        # DENDROGRAM

## #20.3.1.1 ## CUT DENDROGRAM;
    cluster_al_dend <- as.dendrogram(cluster_al)
        # SEND RESULTS TO DENDROGRAM
    cluster_al_dend_cut <- cut(cluster_al_dend, h = 5)
        # DEFINE CUT POINT
    plot(cluster_al_dend_cut$upper)
        # DENDROGRAM

