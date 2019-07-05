** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: datos_panel.do
** PROGRAM TASK: EXECUTE CLUSTER ANALYSIS
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 24/10/2018
** DATE REVISION 1:
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

    use http://www.principlesofeconometrics.com/poe3/data/stata/nls_panel, clear;

* declare cross section and time series identifiers;
    iis id;
    tis year;

* random effects;
    xtreg  lwage educ exper exper2 tenure tenure2 black south union, re;
    estimates store re;

* Breusch-Pagan test;
    xttest0;

* fixed effects estimation;
    xtreg lwage educ exper exper2 tenure tenure2 black south union, fe;
    estimates store fe;

* Hausman test;
    hausman fe re;
