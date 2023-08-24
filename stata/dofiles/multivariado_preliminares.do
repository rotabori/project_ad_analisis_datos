** PROJECT: ANALISIS DE DATOS
** PROGRAM: multivariado_preliminares.do
** PROGRAM TASK: PRELIMINARY BASIC STATA COMMANDS
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2019/05/26
** DATE REVISION 1: 2020/04/07
** DATE REVISION #:

********************************************************************;
** #0
********************************************************************;

    clear all

/*********************************************/
/*FUNCIÓN*/
    twoway function y = x, range(-7 7) yline(0) xline(0) xsize(5) ysize(5)
    twoway function y = .5*x, range(-5 5) yline(0) xline(0) xsize(5) ysize(5)

    twoway function y = ln(x), range(-1 7) yline(0) xline(0) label("Ln")
    twoway function y = log10(x), range(-1 7) yline(0) xline(0)

    twoway (function y = ln(x), range(-1 7) yline(0) xline(0)) (function y = log10(x), range(-1 7) yline(0) xline(0)), legend(order(1 "Ln" 2 "Log 10") position(6) rows(1))

/*********************************************/
/*GRAPHS*/

/*BAR*/
    graph bar (mean) var1 , over(id, sort(1) descending label(angle(25))) blabel(bar, position(outside) format(%5.1f)) subtitle(Celular) ytitle(Mbps) name(celular_mean)

    graph bar (mean) wifi
        ,
        over(wifi_celular, sort(1) descending label(angle(25)))
        blabel(bar, position(outside) format(%5.1f))
        subtitle(Celular)
        ytitle(Mbps)
        name(celular_mean)
        ;

/*BOX PLOT*/
    graph box var1, over(id)

    graph box ad_price_mill, over(car_fuel_num)

    hist ad_price_mill, percent width(5) xsize(5) ytitle("") name(hist, replace)
    graph hbox ad_price_mill, ysize(2) xsize(5) name(hbox, replace)
        graph combine hist hbox, cols(1)

/*********************************************/
/*DISTRIBUCIÓN UNIFORME*/

    clear
    set obs 1000

    /*u1*/
    set seed 123456
    generate u1 = runiform()
        label variable u1 "u1 = U(0,1)"
    sum u1
    hist u1

    /*u2*/
    set seed 123456
    generate u2 = runiform(0,1)
        label variable u2 "u2 = U(0,1)"
    sum u2
    hist u2

    scatter u1 u2

    generate u2a = round(u2)
        label variable u2a "u2a = U(0,1) discreta"
    sum u2a
    hist u2a
    hist u2a, discrete

    label define genero 0 "Hombre" 1 "Mujer"
        label values u2a genero

    hist u1, by(u2a)

    /*u3*/
    set seed 123456
    generate u3 = runiform(1,5)
        label variable u3 "u3 = U(1,5)"
    sum u3
    hist u3

    set seed 123456
    *generate double u3a = (b–a)*runiform() + a
    *generate double u3a = (5–1)*runiform() + 1
    generate double u3a = (4)*runiform() + 1
        label variable u3a "u3a = U(1,5)"
    sum u3a
    hist u3a

    generate u3b = round(u3)
        label variable u3b "u3b = U(1,5) discreta"
    sum u3b
    hist u3b
    hist u3b, discrete

    set seed 123456
    generate u3c = floor((5-1+1)*runiform() + 1)
        label variable u3c "u3c = (1,5) discreta"
    sum u3c
    hist u3c

/*********************************************/
/*DISTRIBUCIÓN NORMAL*/

    set seed 123456
    generate n1 = rnormal()
        label variable n1 "n1 = N(0,1)"
    sum n1
    hist n1

    set seed 123456
    generate n2 = rnormal(0,1)
        label variable n2 "n2 = N(0,1), igual a n1"
    sum n2
    hist n2

    scatter n1 n2

    set seed 654321
    generate n3 = rnormal(0,1)
        label variable n3 "n3 = N(0,1)"
    sum n3
    hist n3

    scatter n1 n3

    generate n4 = n2 + n3
        label variable n4 "n4 = n2 + n3"
    sum n3
    hist n3

    scatter n1 n4

    scatter n1 n4, by(u2a)

    graph matrix n*, half

/*********************************************/
/*DESCRIPCIÓN FINAL*/

    label data "Datos simulados distribución uniforme y normal"

    sum
    describe
