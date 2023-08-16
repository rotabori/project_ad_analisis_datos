** PROJECT: ANALISIS DE DATOS
** PROGRAM: regresion_lineal_otros1.do
** PROGRAM TASK: RESET TEST, COLINEARITY AND DUMMY EXPLANATORY VARIABLES
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2018/09/24
** DATE REVISION 1: 2020/04/07
** DATE REVISION #:

********************************************************************;
** #0
********************************************************************;

** PROGRAM SETUP

    pause on
    #delimit ;
        /*COMMAND LINES WILL ONLY END ONCE SEMICOLON IS FOUND*/

** #0.1 ** SET PATH FOR READING/SAVING DATA;

********************************************************************;
** #10 ** MODEL SELECTION;
********************************************************************;

** #10.1 ** R2;

    /*R2*/
    scalar r2 = e(mss)/(e(mss)+e(rss))

** #10.2 ** INFORMATION CRITERIA;

    /*INFORMATION CRITERIA*/
    estat ic;
    estimates store model_0;

    estat ic;
    estimates store model_1;

    estimates stat _all;

    fitstat, saving(model_0);
    fitstat, using(model_0);

********************************************************************;
** #20 ** TESTs;
********************************************************************;

********************************************************************;
** #20.1 ** RESET TEST;
********************************************************************;

    regress y x1 x2
    predict y_hat, xb
    gen y_hat2 = y_hat^2
    gen y_hat3 = y_hat^3

    regress y x1 x2 y_hat2
        test y_hat2

    regress y x1 x2 y_hat2 y_hat3
        test y_hat2 y_hat3

********************************************************************;
** #20.2 ** COLINEARITY TEST / VIF;
********************************************************************;

    regress y x1 x2
        scalar r1 = e(r2)
    regress y x1 x3
        scalar r2 = e(r2)
    regress y x2 x3
        scalar r3 = e(r2)

    regress y x1 x2
        estat vif

********************************************************************;
** #20.3 ** RESIDUAL Vs. FITTED;
********************************************************************;

    rvfplot, yline(0)

********************************************************************;
** #20.4 ** LEVERAGE / DFBETA;
********************************************************************;

    lvr2plot
        /*MODIFY DATA AND PLOT UNUSUAL OBSERVATIONS*/
    dfbeta

********************************************************************;
** #20.5 ** FITTED Vs. ADDED VARIABLE;
********************************************************************;

    avplot x2

********************************************************************;
** #40 ** DUMMY / CATHEGORICAL VARIABLES / INTERACTION;
********************************************************************;

** #40.1 ** INTERACTION BASICS;

    /*OPERATOR APPLIED TO SEVERAL VARIABLES AT ONCE*/
    i.(x1 x2)

    /*SHOW BASE CATHEGORY ON RESULTS*/
    set showbaselevels on

    /*BASE CATHEGORY MANIPULATION. DEFAULT, SMALLEST/FIRST VALUE BECOMES BASE*/
    b#.x1 /*# BECOMES BASE*/
    b(##).x1 /*#-TH ORDERED BECOMES BASE*/
    b(first).x1 /*SMALLES VALUE BECOMES BASE*/
    b(last).x1 /*LARGEST VALUE BECOMES BASE*/
    b(freq).x1 /*MOST FREQUENT VALUE BECOMES BASE*/
    bn. /*NO VALUE BECOMES BASE*/
    #.x1 /*TERM (COEFFICIENT0 ONLY FOR #*/

** #40.2 ** INTERACTION MANUAL;
    tabulate x1, gen(x1_d)
    gen x2_x1 = x2*x1_d1

    reg y x1 x2 x2_x1
        test x2_x1

        lincom _const + x1
        lincom x2 + x2_x1

** #40.3 ** INTERACTION;
** #40.3.1 ** NO INTERACTION;
    reg y c.x1

    margins, over(x1)
        marginsplot, noci addplot(scatter y x) name(m0, replace)

    margins, at(x1=(#(#)#))
        marginsplot, noci addplot(scatter y x) name(m0, replace)

** #40.3.2 ** CONSTANT;
    reg y i.x2
    reg y c.x1 i.x2

    margins, over(x1 i.x2)
        marginsplot
    margins, over(i.x2) at(x1=(#(#)#))
        marginsplot, noci addplot(scatter y x) name(m1, replace)
    margins i.x2, at(x1=(#(#)#))
        marginsplot, noci addplot(scatter y x) name(m1, replace)

** #40.3.3 ** SLOPE;
    reg y c.x1 c.x1#i.x2

    margins, over(x1 i.x2)
        marginsplot;
    margins, over(i.x2) at(x1=(#(#)#))
        marginsplot, noci addplot(scatter y x) name(m2, replace)
    margins i.x2, at(x1=(#(#)#))
        marginsplot, noci addplot(scatter y x) name(m2, replace)

** #40.3.4 ** CONSTANT & SLOPE;
    reg y c.x1##i.x2

    margins i.x2, at(x1=(#(#)#))
        marginsplot, noci addplot(scatter y x) name(m3, replace)

** #40.3.5 ** SQUARED;
    reg y c.x1##c.x1

    margins , at(x1=(#(#)#))
        marginsplot

    margins , dydx(x1) at(x1=(#(#)#))
        marginsplot

********************************************************************;
** #50 ** FUNCTIONAL FORM;
********************************************************************;

    reg y x
        predict y_hat0, xb

    gen x_inv = 1/x
    reg y x_inv
        predict y_hat1, xb

    gen x_ln = ln(x)
    gen y_ln = ln(y)
    reg y_ln x_ln
        predict y_hat2, xb

    twoway scatter y x || connected y_hat0 x || connected y_hat1 x || connected y_hat2 x, yaxis(2)

********************************************************************;
** #60 ** MARGINAL EFFECT;
********************************************************************;

    reg y c.x1 i.x2

        margins, dydx(x2) at(x1=0)
        margins, dydx(x2) at(x1=1)
        margins, dydx(i.x2) at(x1=(#(#)#))
            marginsplot

********************************************************************;
** #70 ** PAIRWISE - CONTRAST;
********************************************************************;

    /*PAIRWISE*/
    reg y c.x1 i.x2
        margins i.x2, pwcompare
        margins i.x2, pwcompare(groups)

    /*CONTRAST*/
    reg y c.x1
        margins r.x1

    reg y c.x1 i.x2
        margins r.x1@x2

    /*CONTRAST OPTIONS*/
    r.x1 /*DIFFERENCE W.R.T. BASE LEVEL*/
    a.x1 /*DIFFERENCE W.R.T. NEXT ADJACENT LEVEL*/
    ar.x1 /*DIFFERENCE W.R.T. PREVIOUS ADJACENT LEVEL*/
    g.x1 /*DIFFERENCE W.R.T. BALANCED GRAND MEAN*/
    gw.x1 /*DIFFERENCE W.R.T. OBSERVATION-WEIGHTED GRAND MEAN*/

    margins, at(continuous=(20(10)70)) contrast(atcontrast(a) effects)

********************************************************************;
** #90 ** EXAMPLE;
********************************************************************;

    use "http://www.rodrigotaborda.com/ad/data/iefic/2016/iefic_2016_s13.dta"
monto ahorrado p2962
ingreso
genero
