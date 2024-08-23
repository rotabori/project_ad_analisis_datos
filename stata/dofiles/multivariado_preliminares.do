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

    twoway function y = ln(x), range(-1 7) yline(0) xline(0)
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

/*DISTRIBUCIÓN BINOMIAL*/

    clear*
    set obs 61
    gen binomial_prob025 = binomialp(_N-1, _n-1, 0.25)
    gen binomial_prob05 = binomialp(_N-1, _n-1, 0.5)
    gen binomial_prob075 = binomialp(_N-1, _n-1, 0.75)

    gen binomial_cum025 = 1 - binomialtail(_N-1, _n-1, 0.25)
    gen binomial_cum05 = 1 - binomialtail(_N-1, _n-1, 0.5)
    gen binomial_cum075 = 1 - binomialtail(_N-1, _n-1, 0.75)

    gen k = _n-1
    graph twoway connected binomial_prob* k, name(binomial_prob) xline(25 50 75)
    graph twoway connected binomial_cum* k, name(binomial_cum) yline(.25 .5 .75)

/*DISTRIBUCIÓN UNIFORME*/

    clear
    set obs 100
    gen x_d = 1
    gen x = _n
        twoway connected x_d x, sort msize(tiny) name(a, replace)
    gen p_cum = sum(x_d)/_N
        twoway connected p_cum x, sort msize(tiny) name(b, replace)

    graph combine b a, cols(1) ysize(8)

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

/*DESCRIPCIÓN FINAL*/
    label data "Datos simulados distribución uniforme y normal"

    sum
    describe

/*********************************************/
/*DISTRIBUCIÓN T*/

# delimit ;
    twoway  (function t_pdf = tden(1,x), range(-4 4))
            (function t_pdf = tden(2,x), range(-4 4))
            (function t_pdf = tden(3,x), range(-4 4))
    ;

/*********************************************/
/*DISTRIBUCIÓN CHI2*/

# delimit ;
    twoway  (function chi2_pdf = chi2den(1,x), range(-0 50))
            (function chi2_pdf = chi2den(2,x), range(-0 50))
            (function chi2_pdf = chi2den(3,x), range(-0 50))
    ;

/*********************************************/
/*DISTRIBUCIÓN F*/

# delimit ;
    twoway  (function f_pdf = Fden(1,1,x), range(-0 15))
            (function f_pdf = Fden(2,5,x), range(-0 15))
            (function f_pdf = Fden(5,10,x), range(-0 15))
            (function f_pdf = Fden(10,20,x), range(-0 15))
    ;

/*********************************************/
/*DISTRIBUCION MUESTRAL*/

/*NORMAL*/
/*MUESTREO SIN REMPLAZO*/
    net install dm44
    clear
    set obs 1000000
    set seed 71772

    gen x_1 = rnormal(500,150)
        tabstat x_1, statistics(mean sd)
        histogram x_1, title(Población) name(pop_hist, replace)

    tempvar sortorder
    gen `sortorder' = runiform()
    sort `sortorder'

    seq sample_id, from(1) to(5000) block(1)

    egen sample_mean = mean(x_1), by(sample_id)

    collapse (mean)sample_mean, by(sample_id)

    histogram sample_mean, title(Muestra) name(muestra_hist, replace)

    tabstat sample_mean, statistics(mean sd)

/*UNIFORM*/
/*MUESTREO SIN REMPLAZO*/
    net install dm44
    clear
    set obs 1000000
    set seed 71772

    gen x_1 = runiform()
        tabstat x_1, statistics(mean sd)
        histogram x_1, title(Población) name(pop_hist, replace)

    tempvar sortorder
    gen `sortorder' = runiform()
    sort `sortorder'

    seq sample_id, from(1) to(5000) block(1)

    egen sample_mean = mean(x_1), by(sample_id)

    collapse (mean)sample_mean, by(sample_id)

    histogram sample_mean, title(Muestra) name(muestra_hist, replace)

    tabstat sample_mean, statistics(mean sd)

/*REAL DATA*/
/*MUESTREO SIN REMPLAZO*/
    net install dm44
    clear
    use http://rodrigotaborda.com/ad/data/ee/encuesta_estudiantes_202yxx_old.dta

    keep estatura genero_num
        tabstat estatura, statistics(mean sd n) by(genero_num)
        histogram estatura, title(Estatura) name(pop_hist, replace)
        twoway (kdensity estatura if genero_num == 0)(kdensity estatura if genero_num == 1), name(pop_kd, replace)

    tempvar sortorder
    gen `sortorder' = runiform()
    sort genero_num `sortorder'

    seq sample_id, from(1) to(125) block(1)

    egen estatura_sample_mu = mean(estatura), by(sample_id genero_num)

    collapse (mean)estatura_sample_mu, by(sample_id genero_num)

        tabstat estatura_sample_mu, statistics(mean sd n) by(genero_num)
        histogram estatura_sample_mu, title(Muestra) name(muestra_hist, replace)
        twoway (kdensity estatura_sample_mu if genero_num == 0)(kdensity estatura_sample_mu if genero_num == 1), name(muestra_kd, replace)

/*BETA LEFT SKEWED*/
/*MUESTREO CON REMPLAZO*/
    net install dm44
    clear
    set obs 100000
    set seed 71772

    gen x_1 = rbeta(10,1) * 100 /*left skewed variable*/
        tabstat x_1, statistics(mean sd n)
        sum x_1
            local x_1_mean = r(mean)
        histogram x_1, title(Población) name(pop_hist, replace)

    foreach i of num 1/9{
        gen sortorder_`i' = runiform()
        sort sortorder_`i'
        gen sample_`i' = x_1 in 1/200
        }

    drop sortorder_*

    foreach i of num 1/9{
        mean sample_`i'
        estimates store samplemean_`i'
        }

    coefplot (samplemean_1, label(Random Sample 1)) (samplemean_2, label(Random Sample 2)) (samplemean_3, label(Random Sample 3)) ///
             (samplemean_4, label(Random Sample 4)) (samplemean_5, label(Random Sample 5)) (samplemean_6, label(Random Sample 6)) ///
             (samplemean_7, label(Random Sample 7)) (samplemean_8, label(Random Sample 8)) (samplemean_9, label(Random Sample 9)) ///
             , ///
             xline(`x_1_mean')

/*BETA LEFT SKEWED*/
/*MUESTREO CON REMPLAZO*/
    net install dm44
    clear
    set obs 10000
    gen case_id =_n

    set seed 71772

    gen x_1 = rbeta(10,1) * 100 /*left skewed variable*/
        tabstat x_1, statistics(mean sd n)
        sum x_1
            local x_1_mean = r(mean)
        histogram x_1, title(Población) name(pop_hist, replace)

    quietly foreach i of num 1/200 {
    	gen sortorder_`i' = runiform()
    	sort sortorder_`i'
    	gen sample`i' = x_1 in 1/300
    }

    drop sortorder_*

    quietly reshape long sample`i', i(case_id) j(samplegroup)

    egen x_1_samplemean = mean(sample) if sample !=. , by(samplegroup)

    collapse x_1_samplemean, by(samplegroup)

        tabstat x_1_samplemean, statistics(mean sd n)
        histogram x_1_samplemean, title(Muestra) xline(`x_1_mean') name(muestra_hist, replace)
