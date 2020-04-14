** PROJECT: ANALISIS DE DATOS
** PROGRAM: series_tiempo_cointegracion.do
** PROGRAM TASK: SERIES DE TIEMPO COINTEGRACION / REGRESION ESPUREA
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2017/02/02
** DATE REVISION 1: 2019/07/03
** DATE REVISION 2: 2020/04/07

********************************************************************;
** #0
********************************************************************;

** PROGRAM SETUP

    pause on
    #delimit ;

** #0.1 ** SET PATH FOR READING/SAVING DATA;

*    cd ../../;

*********************************************************************;
*** #10 ** PRINCIPLES OF ECONOMETRICS;
*********************************************************************;

    use http://www.principlesofeconometrics.com/poe3/data/stata/usa, clear

*********************************************************************;
*** #20 ** SPURIOUS REGRESSION;
*********************************************************************;

    /*definir numero de observaciones*/
    set obs 180

    /*definir variable de tiempo*/
    generate time=_n
    tsset time

    /*generar proceso aleatorio*/
    set seed 123456
    generate e1 = invnorm(uniform())
    generate y1 = .
    replace y1 = e1 in 1
    replace y1 = 0.8 + 0.95*l.y1 + e1 if time > 1

    /*GENERAR PROCESO ALEATORIO*/
        set seed 654321
        generate e2 = invnorm(uniform())
        generate y2 = .
        replace y2 = e2 in 1
        replace y2 = 0.4 + 0.99*l.y2 + e1 if time > 1

    /*CONTRASTE DOS PROCESO ALEATORIOS INDEPENDIENTES*/

        scatter y1 y2
        tsline rw1 rw2
        reg y1 y2

*********************************************************************;
*** #30 ** SPURIOUS REGRESSION;
*********************************************************************;

    use use http://www.principlesofeconometrics.com/poe3/data/stata/spurious, clear
    gen time = _n
    tsset time

    regress rw1 rw2
    tsline rw1 rw2
    more
    scatter rw1 rw2
    more

/*UNIT ROOT TESTS AND COINTEGRATION*/

    use http://www.principlesofeconometrics.com/poe3/data/stata/usa, clear

    gen date = q(1985q1) + _n - 1
    format %tq date
    tsset date

    /*AUGMENTED DICKEY FULLER REGRESSIONS*/
        regress D.F L1.F L1.D.F
        regress D.B L1.B L1.D.B

    /*AUGMENTED DICKEY FULLER REGRESSIONS WITH BUILT IN FUNCTIONS*/
        dfuller F, regress lags(1)
        dfuller B, regress lags(1)

    /*ADF ON DIFFERENCES*/
        dfuller D.F, noconstant lags(0)
        dfuller D.B, noconstant lags(0)

    /*ENGLE GRANGER COINTEGRATIONS TEST*/
        regress B F
        predict ehat, residual
        regress D.ehat L.ehat L.D.ehat, noconstant

    /*USING THE BUILT-IN STATA COMMANDS*/
        dfuller ehat, noconstant lags(1)

*********************************************************************;
*** #40 ** COINEGRACION;
*********************************************************************;

    /*CREATE DATES AND DECLARE TIME-SERIES*/
        gen qtr = mod(_n-1,4) + 1
        egen year = seq(), from(1985) to(2005) block(4)
        gen date = yq(year,qtr)
        format %tq date
        tsset date

    /*CREATE DATES AND DECLARE TIME-SERIES*/
        drop date
        gen date = q(1985q1) + _n - 1
        format %tq date
        tsset date

    /*FIGURES*/
        twoway(tsline gdp), saving(gdp)
        twoway(tsline D.gdp), saving(dgdp)

        graph combine gdp.gph dgdp.gph

        tsline inf, saving(inf)
        tsline D.inf, saving(dinf)
        tsline F, saving(f)
        tsline D.F, saving(df)
        tsline B, saving(b)
        tsline D.B, saving(db)

        graph combine gdp.gph dgdp.gph inf.gph dinf.gph, saving(graph1)
        graph combine f.gph df.gph b.gph db.gph, saving(graph2)

    /*SUMMARY STATISTICS FOR SUBSAMPLES*/

        summarize if date<=q(1994q4)
        summarize if date>=q(1995q1) & date<=q(2004q4)
