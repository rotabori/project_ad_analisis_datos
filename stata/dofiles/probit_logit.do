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
** #10 ** LOGIT / PROBIT FUNCTIONS;
********************************************************************;

    /*NORMAL STANDARD / PROBIT*/;
    twoway function probit_cdf = normal(x), range(-4 4) xline(0) xlabel(#6 0) name(probit_cdf);
    twoway function probit_pdf = normalden(x), range(-4 4) xline(-1 1) xlabel(#6 -1 1) name(probit_pdf);
        graph combine probit_cdf probit_pdf, cols(1) ysize(8) name(probit);

    /*LOGISTIC*/;
    twoway function logit_cdf = exp(x)/(1+exp(x)), range(-4 4) xline(0) xlabel(#6 0);
        twoway function logit_cdf = logistic(x), range(-7 7) xline(0) xlabel(#6 0) name(logit_cdf);
    twoway function logit_pdf = exp(x)/(1+exp(x))^2, range(-4 4) xline(0) xlabel(#6 0);
        twoway function logit_pdf = logisticden(x), range(-7 7) xline(0) xlabel(#6 0) name(logit_pdf);
        graph combine logit_cdf logit_pdf, cols(1) ysize(8) name(logit);

    /*COMPARE*/;
    twoway function probit_cdf = normal(x), range(-4 4) xline(0) xlabel(#6 0) || function logit_cdf = exp(x)/(1+exp(x)), range(-4 4) xline(0) xlabel(#6 0) name(probit_logit_cdf);
    twoway function probit_pdf = normalden(x), range(-4 4) xlabel(#6 -1 1) || function logit_pdf = exp(x)/(1+exp(x))^2, range(-4 4) xline(0) xlabel(#6 0) name(probit_logit_pdf);
        graph combine probit_logit_cdf probit_logit_pdf, cols(1) ysize(8);

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

    margins, dydx(x2) at(x1=(#(#)#))
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
        sum pr
        hist pr
        twoway connect pr x1, sort yline(.5)
        gen pr01 = (pr>.5)
        br y x1 pr pr01
        tabulate y pr01
        estat class, cutoff(.5)

********************************************************************;
** #70 ** EXAMPLE;
********************************************************************;

** #70.1 ** IEFIC / CREDITO HIPOTECARIO;

    use http://www.rodrigotaborda.com/ad/data/iefic/2016/iefic_2016_s13.dta, clear

    tabulate p2466
    drop if p2466 > 1

    replace ingreso = ingreso / 1000000

    sum p2466 ingreso p35 p2480

    reg p2466 ingreso
        predict lpm_xb, xb
        twoway (scatter p2466 ingreso) (connected lpm_xb ingreso, yline(1) sort)

        predict lpm_e, residuals
        gen lpm_var = lpm_e^2
        scatter lpm_var ingreso, sort

    logit   p2466 ingreso
            predict logit_xb, pr
            twoway (scatter p2466 ingreso) (connected logit_xb ingreso, yline(1) sort)

    logit p2466 ingreso i.p35
        margins i.p35, at(ingreso=(0(1)40))
            marginsplot, noci

        margins , at(ingreso=(0(1)40)) over(i.p35)
            marginsplot, noci

        margins , dydx(i.p35) at(ingreso=(0(1)40))
            marginsplot, yline(0)

        margins i.p35 , dydx(ingreso) at(ingreso=(0(1)40))
            marginsplot, noci

    logit p2466 ingreso i.p2480
        margins i.p2480, at(ingreso=(0(1)40))
            marginsplot, noci

        margins , dydx(i.p2480) at(ingreso=(0(1)40))
            marginsplot, yline(0)

        margins i.p2480 , dydx(ingreso) at(ingreso=(0(1)40))
            marginsplot, noci

** #70.2 ** IEFIC / AUTOMOVIL;

    use http://www.rodrigotaborda.com/ad/data/iefic/2016/iefic_2016_s13.dta, clear

    gen vehiculo = p2502
        tab vehiculo
        drop if vehiculo > 1
        tab vehiculo

    rename p35 genero

    gen ingreso_mill = ingreso / 1000000

    gen ahorro = p2584
        tab ahorro
        drop if ahorro > 1
        tab ahorro

    gen familia_tamano = p232
        tab familia_tamano

    sum vehiculo genero ingreso_mill ahorro familia_tamano

    reg vehiculo i.genero ingreso_mill
        predict lpm_xb, xb
        twoway connected lpm_xb ingreso_mill, yline(1) sort

        predict lpm_e, residuals
        gen lpm_var = lpm_e^2
        scatter lpm_var ingreso_mill, sort

    logit vehiculo i.genero ingreso_mill
        predict logit_pr, pr
        twoway connected logit_pr ingreso_mill, yline(1) sort

        margins, at(ingreso_mill=(0(1)40)) over(i.genero)
        marginsplot
        margins, dydx(i.genero) at(ingreso_mill=(0(1)40))
        marginsplot

    logit vehiculo i.genero ingreso_mill familia_tamano
        margins, at(ingreso_mill=(0(1)40)) atmeans over(i.genero)
        marginsplot
        margins, dydx(i.genero) at(ingreso_mill=(0(1)40)) atmeans
        marginsplot, yline(0)

    logit vehiculo ingreso_mill familia_tamano i.ahorro
        margins, at(ingreso_mill=(0(1)40)) atmeans over(i.ahorro)
        marginsplot
        margins, dydx(i.ahorro) at(ingreso_mill=(0(1)40)) atmeans
        marginsplot, yline(0)
        margins, at(ingreso_mill=(0(1)40) familia_tamano=(1 3 5) ahorro=(1))
        marginsplot

        margins, at(ingreso_mill=(0(1)40) familia_tamano=(1 5) ahorro=(1)) saving(C:\rodrigo\project_ad_analisis_datos\data\iefic\pr.dta, replace)
            use "C:\rodrigo\project_ad_analisis_datos\data\iefic\pr.dta", clear
            keep _margin _at1 _at2
                label var _margin "dy/dx 5 a 1 miembro"
                label var _at1 "Fam. 1 miembro"
                label var _at2 "Fam. 1 miembro"
            reshape wide _margin, i(_at1) j(_at2)
            gen dydx51 = _margin5 - _margin1
            twoway connected _margin1 _margin5 dydx51 _at1
