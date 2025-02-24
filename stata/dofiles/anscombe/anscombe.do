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

    set scheme s2color8;

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
    corr x* y*;

    sum x1;
        local x1_m: di%3.2f = r(mean);
        local x1_sd: di%3.2f = r(sd);
    sum y1;
        local y1_m: di%3.2f = r(mean);
        local y1_sd: di%3.2f = r(sd);

    sum x2;
        local x2_m: di%3.2f = r(mean);
        local x2_sd: di%3.2f = r(sd);
    sum y2;
        local y2_m: di%3.2f = r(mean);
        local y2_sd: di%3.2f = r(sd);

    sum x3;
        local x3_m: di%3.2f = r(mean);
        local x3_sd: di%3.2f = r(sd);
    sum y3;
        local y3_m: di%3.2f = r(mean);
        local y3_sd: di%3.2f = r(sd);

    sum x4;
        local x4_m: di%3.2f = r(mean);
        local x4_sd: di%3.2f = r(sd);
    sum y4;
        local y4_m: di%3.2f = r(mean);
        local y4_sd: di%3.2f = r(sd);
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
        text(12 5 "y1 = `y1_cons' + `y1_slope' x1"

             4.5 14 "x1"
             5 16 "M = `x1_m'"
             4 16 "SD = `x1_sd'"

             2.5 14 "y1"
             3 16 "M = `y1_m'"
             2 16 "SD = `y1_sd'"
             , size(small) place(e))
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
        text(12 5 "y2 = `y2_cons' + `y2_slope' x2"

             4.5 14 "x2"
             5 16 " M = `x2_m'"
             4 16 "SD = `x2_sd'"

             2.5 14 "y2"
             3 16 " M = `y2_m'"
             2 16 "SD = `y2_sd'"
             , size(small) place(e))
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
        text(12 5 "y3 = `y3_cons' + `y3_slope' x3"

             4.5 14 "x3"
             5 16 " M = `x3_m'"
             4 16 "SD = `x3_sd'"

             2.5 14 "y3"
             3 16 " M = `y3_m'"
             2 16 "SD = `y3_sd'"
             , size(small) place(e))
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
        text(12 5 "y4 = `y4_cons' + `y4_slope' x4"

             4.5 14 "x4"
             5 16 " M = `x4_m'"
             4 16 "SD = `x4_sd'"

             2.5 14 "y4"
             3 16 " M = `y4_m'"
             2 16 "SD = `y4_sd'"
             , size(small) place(e))
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
        xcommon
        iscale(*.85)
        xsize(4)
        title(El cuarteto de Anscombe)
        note("Nota: Cuatro grupos de datos que tienen la misma media, varianza, correlación y ecuación "
             "de regresión. Pero su dispersión de datos es diferente."
             ,
             size(vsmall))
        name(anscombe)
        ;

    graph close _all;
    graph display anscombe;

**** #90.9.9 ** GOOD BYE;
*
*    clear;
