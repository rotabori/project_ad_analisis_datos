** PROJECT: ANALISIS DE DATOS
** PROGRAM: probit_logit.do
** PROGRAM TASK: PROBIT LOGIT MODEL
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
** #10 ** EXECUTE DATA-IN ROUTINE;
********************************************************************;



********************************************************************;
** #20 ** LOGIT / PROBIT;
********************************************************************;

** #20.0 ** CREATE A DUMMY VARIABLES;

    gen z_d = (z>0)

** #20.1 ** CONTINUOS EXPLANATORY VARIABLE;

    sum y x1

    reg y x1

    logit y x1

    predict y_pred01
        twoway (connected y_pred01 x1, sort(x)) (lfit y x1)

    margins, at(x1=(#(#)#))
        marginsplot
        marginsplot, addplot(lfit y x1)
        marginsplot, addplot(connected y_pred01 x1, sort(x1))

    margins, predict(xb) at(x1=(#(#)#))
        marginsplot

    margins, predict(pr) at(x1=(#(#)#))
        marginsplot

    margins, dydx(x1) at(x1=(#(#)#))
        marginsplot

    margins, dydx(x1) at((min)x1) at((max)x1)
        marginsplot

** #20.2 ** CONTINUOS EXPLANATORY + BINARY VARIABLE;

    sum y x1 i.x2

    reg y x1 i.x2

    logit y x1 i.x2

    margins, at(x1=(#(#)#) x2=(0 1))
        marginsplot

    margins, at(x1=(#(#)#)) over(x2)
        marginsplot

    margins i.x2, at(x1=(#(#)#))
        marginsplot

    margins, dydx(x1) at(x1=(#(#)#) x2=(0 1))
        marginsplot

** #20.3 ** CONTINUOS EXPLANATORY + BINARY VARIABLE + CONTINUOS EXPLANATORY;

    sum y x1 i.x2 x3

    reg y x1 i.x2 x3

    logit y x1 i.x2 x3

    margins, at(x1=(#(#)#) x2=(0 1)) atmeans
        marginsplot

** #20.4 ** CLASSIFICATION TABLE;

    logit y x1 i.x2 x3
        predict pr, pr
        gen pr01 = (pr>.5)
        tabulate y pr01
        estat class

********************************************************************;
** #70 ** EXAMPLE;
********************************************************************;

** #70.1 ** IEFIC;

    use http://www.rodrigotaborda.com/ad/data/iefic/2016/iefic_2016_s13.dta, clear

    tabulate p2466
    drop if p2466 > 1

    sum p2466 ingreso p35 p2480

    logit p2466 ingreso i.p35
        margins i.p35, at(ingreso=(0(1000000)40000000))
            marginsplot, noci

        margins , at(ingreso=(0(1000000)40000000)) over(i.p35)
            marginsplot, noci

        margins , dydx(i.p35) at(ingreso=(0(1000000)40000000))
            marginsplot, yline(0)

        margins i.p35 , dydx(ingreso) at(ingreso=(0(1000000)40000000))
            marginsplot, noci

    logit p2466 ingreso i.p2480
        margins i.p2480, at(ingreso=(0(1000000)40000000))
            marginsplot, noci

        margins , dydx(i.p2480) at(ingreso=(0(1000000)40000000))
            marginsplot, yline(0)

        margins i.p2480 , dydx(ingreso) at(ingreso=(0(1000000)40000000))
            marginsplot, noci
