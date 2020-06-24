** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: anscombe.do
** PROGRAM TASK: ANSCOMBE DATA EXAMINATION
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2020/06/14
** DATE REVISION 1:
** DATE REVISION #:

********************************************************************;
** #0
********************************************************************;

** PROGRAM SETUP

    pause on
    #delimit ;

** #0.1 ** SET PATH FOR READING/SAVING DATA;

*    cd ../../../;

*********************************************************************;
*** #10 ** READ, ORGANIZE DATA;
*********************************************************************;
*
*** #10.1 ** IMPORT DATA;

    import delimited
        http://rodrigotaborda.com/ad/data/anscombe/anscombe.csv,
        delimiter(",")
        varnames(1)
        clear
    ;

*********************************************************************;
*** #20 ** SUMMARY STATISTICS;
*********************************************************************;
*
*** #20.1 ** SUMMARY STATISTICS;

    sum;

*********************************************************************;
*** #30 ** REGRESSION;
*********************************************************************;
*
*** #30.1 ** REGRESSION;

    reg y1 x1
        ;
        local y1_cons: di%3.2f = _b[_cons];
        local y1_slope: di%3.2f = _b[x1];

    reg y2 x2
        ;
        local y2_cons: di%3.2f = _b[_cons];
        local y2_slope: di%3.2f = _b[x2];

    reg y3 x3
        ;
        local y3_cons: di%3.2f = _b[_cons];
        local y3_slope: di%3.2f = _b[x3];

    reg y4 x4
        ;
        local y4_cons: di%3.2f = _b[_cons];
        local y4_slope: di%3.2f = _b[x4];

*********************************************************************;
*** #30 ** GRAPHS;
*********************************************************************;
*
*** #30.1 ** GRAPHS;

    twoway
        (
        lfit
        y1 x1
        ,
        text(12 5 "y1 = `y1_cons' + `y1_slope' x1", size(small) place(e))
        )
        (
        scatter
        y1 x1
        )
        ,
        legend(off)
        name(y1x1)
        ;

    twoway
        (
        lfit
        y2 x2
        ,
        text(12 5 "y2 = `y2_cons' + `y2_slope' x2", size(small) place(e))
        )
        (
        scatter
        y2 x2
        )
        ,
        legend(off)
        name(y2x2)
        ;

    twoway
        (
        lfit
        y3 x3
        ,
        text(12 5 "y3 = `y3_cons' + `y3_slope' x3", size(small) place(e))
        )
        (
        scatter
        y3 x3
        )
        ,
        legend(off)
        name(y3x3)
        ;

    twoway
        (
        lfit
        y4 x4
        ,
        text(12 5 "y4 = `y4_cons' + `y4_slope' x4", size(small) place(e))
        )
        (
        scatter
        y4 x4
        )
        ,
        legend(off)
        name(y4x4)
        ;

    graph combine
        y1x1
        y2x2
        y3x3
        y4x4
        ,
        ycommon
        xsize(4)
        title(El cuarteto de Anscombe)
        note("Cuatro grupos de datos que tienen la misma media, varianza, correlación"
             "y ecuación de regresión. Pero diferente gráfica.")
        name(anscombe)
        ;

    graph close _all;
    graph display anscombe;

**** #90.9.9 ** GOOD BYE;
*
*    clear;
