** PROJECT: ANALISIS DE DATOS
** PROGRAM: probit_logit_ordenado.do
** PROGRAM TASK: ORDERED PROBIT
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2017/04/03
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
** #10 ** DATA IN;
********************************************************************;

** #10.1 ** DATA IN;

    use http://stats.idre.ucla.edu/stat/data/ologit.dta, clear;
    /*SIMULATED DATA ON COLLEGE EDUCATION*/;

********************************************************************;
** #20 ** DATA VISUALIZATION;
********************************************************************;

*** #20.1 ** DATA EXAM;

    tab apply;
    tab apply, nolabel;

    sum apply pared public gpa;

    reg apply pared;
    reg apply public;
    reg apply gpa;
        scatter apply gpa;

********************************************************************;
** #30 ** ORDERED PROBIT LOGIT REGRESSION;
********************************************************************;

*** #30.1 ** ORDERED LOGIT AND PROBIT;

    ologit apply gpa pared public;
        estimates store ologit;

    oprobit apply gpa pared public;
        estimates store oprobit;

    estimates table oprobit ologit;

*** #30.2 ** ORDERED PROBIT - STANDARD DEVIATION;

    oprobit apply gpa pared public;

*** #30.3 ** ORDERED LOGIT - ODDS RATIO;

    ologit apply gpa pared public;

*** #30.4 ** ORDERED PROBIT - MARGINAL EFFECT;

    oprobit apply gpa i.pared i.public;

        margins, at(pared=1 public=1) atmeans predict(outcome(0));
        margins, at(pared=1 public=1) atmeans predict(outcome(1));
        margins, at(pared=1 public=1) atmeans predict(outcome(2));
        margins, at(pared=1 public=1) atmeans;

        margins i.pared, at(public=1 gpa=(2(.2)4)) predict(outcome(0));
            marginsplot, noci name(pr0pub1);

        margins i.pared, at(public=1 gpa=(2(.2)4)) predict(outcome(1));
            marginsplot, noci name(pr1pub1);

        margins i.pared, at(public=1 gpa=(2(.2)4)) predict(outcome(2));
            marginsplot, noci name(pr2pub1);

            graph combine pr0pub1 pr1pub1 pr2pub1, cols(1) ysize(12) name(pr);

        margins, at(public=1 pared=1 gpa=(2(.2)4)) predict(outcome(0)) predict(outcome(1)) predict(outcome(2));
            marginsplot, noci name(pr012pub1pared1);

        margins, dydx(gpa) at(pared=1 public=1 gpa=(2(.2)4)) predict(outcome(0));
            marginsplot, noci name(dydxgpa0pub1par1);
        margins, dydx(gpa) at(pared=1 public=1 gpa=(2(.2)4)) predict(outcome(1));
            marginsplot, noci name(dydxgpa1pub1par1);
        margins, dydx(gpa) at(pared=1 public=1 gpa=(2(.2)4)) predict(outcome(2));
            marginsplot, noci name(dydxgpa2pub1par1);

            graph combine dydxgpa0pub1par1 dydxgpa1pub1par1 dydxgpa2pub1par1, cols(1) ysize(12) name(dydx);

            graph combine pr dydx, cols(2) ysize(12) xsize(11) name(pr_dydx, replace);

**** #90.9.9 ** GOOD BYE;
*
*    clear;
