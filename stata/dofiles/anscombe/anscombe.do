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

    reg y2 x2
        ;

    reg y3 x3
        ;

    reg y4 x4
        ;

	
*********************************************************************;
*** #30 ** GRAPHS;
*********************************************************************;
*
*** #30.1 ** GRAPHS;

    twoway
    (lfit
        y1 x1)
    (scatter
        y1 x1)
        ,
        name(y1x1)
        ;

    twoway
    (lfit
        y2 x2)
    (scatter
        y2 x2)
        ,
        name(y2x2)
        ;

    twoway
    (lfit
        y3 x3)
    (scatter
        y3 x3)
        ,
        name(y3x3)
        ;

    twoway
    (lfit
        y4 x4)
    (scatter
        y4 x4)
        ,
        name(y4x4)
        ;

    graph combine
        y1x1
        y2x2
        y3x3
        y4x4
        ,
        title(El cuarteto de Anscombe)
        name(anscombe)
        ;

    graph close _all;
    graph display anscombe;

**** #90.9.9 ** GOOD BYE;
*
*    clear;
