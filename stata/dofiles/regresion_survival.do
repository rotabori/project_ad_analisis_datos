** PROJECT: ANALISIS DE DATOS
** PROGRAM: regresion_survival.do
** PROGRAM TASK: SUVIVAL ANALYSIS
** AUTHOR: RODRIGO TABORDA
** DATE CREATED: 2017/03/29
** DATE REVISION 1: 2020/04/07
** DATE REVISION #:

********************************************************************;
** #0
********************************************************************;

** PROGRAM SETUP

    pause on
    #delimit ;

** #0.1 ** SET PATH FOR READING/SAVING DATA;

    cd ../../;

********************************************************************;
** #10 ** EXECUTE DATA-IN ROUTINE;
********************************************************************;

** #10.1 ** EXECUTE DATA IN;

    use http://rodrigotaborda.com/ad/data/ee/encuesta_estudiantes_202010_old.dta;

********************************************************************;
** #20 ** DATA VISUALIZATION;
********************************************************************;

*** #20.1 ** HISTOGRAM - KERNEL DENSITY DATA;

    sum relacion_sent;

    stset relacion_sent;
    stsum;

    hist relacion_sent;
    hist relacion_sent, width(1);

    kdensity relacion_sent;

********************************************************************;
** #30 ** TABLES;
********************************************************************;

*** #30.1 ** SURVIVAL;

    sts list, survival;
    sts graph, survival;
    sts graph, survival xline(6 12 18 24);
    sts graph, survival by(genero_num) xline(6 12);

*** #30.2 ** FAILURE;

    sts list, failure;
    sts graph, failure;
    sts graph, failure by(genero_num);

*** #30.3 ** CUMMULATIVE HAZARD;

    sts graph, cumhaz;
    sts generate relacion_sent_cumhaz = na;
    sts graph, cumhaz by(genero_num);

*** #30.4 ** GENERATE VARIABLES;
    sts generate relacion_sent_survival = s relacion_sent_atrisk = n relacion_sent_failing = d relacion_sent_hazard = h;

********************************************************************;
** #40 ** REGRESSION;
********************************************************************;

*** #40.1 ** COX REGRESSION;

    stcox i.genero_num;
    stcox i.genero_num, nohr;

    stcox edad;
    stcox edad, nohr;

    stcox i.genero_num edad;
    stcox i.genero_num edad, nohr;
        margins i.genero_num , at(edad=(18(1)24));
        marginsplot, noci;

*** #40.2 ** LOG REGRESSION;

    generate relacion_sent_ln = ln(relacion_sent);
    reg relacion_sent_ln i.genero_num edad;
        margins i.genero_num , at(edad=(18(1)24)) expression(exp(predict(xb)));
        marginsplot, noci;
