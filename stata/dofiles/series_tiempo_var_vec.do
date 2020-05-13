** PROJECT: ANALISIS DE DATOS
** PROGRAM: series_tiempo_var_vec.do
** PROGRAM TASK: SERIES DE TIEMPO COINTEGRACION / REGRESION ESPUREA
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2020/04/07
** DATE REVISION 1:
** DATE REVISION 2:

    use gdp, clear
    gen date = q(1970q1) + _n - 1
    format %tq date
    tsset date

    /*FIGURES*/
        tsline aus usa
        tsline D.aus D.usa, scheme(sj)

    /*DICKEY-FULLER TESTS FOR STATIONARITY*/

        dfuller usa, regress trend lags(2)
        dfuller aus, regress trend lags(4)

        dfuller D.usa, lags(2)
        estat bgodfrey
        dfuller D.usa, lags(3)
        estat bgodfrey

        dfuller D.aus, lags(1)
        estat bgodfrey
        dfuller D.aus, lags(2)
        estat bgodfrey

    /*ESTIMATE A COINTEGRATING RELATIONSHIP*/

        regress aus usa, noconstant
        predict ehat, residual

    /*ENGLE GRANGER TEST*/
        regress D.ehat L1.ehat, noconstant

    /*VECM*/

        regress D.aus L1.ehat
        regress D.usa L1.ehat

    /*VAR ESTIMATION*/

        use growth, clear
        gen date = q(1960q1) + _n - 1
        format %tq date
        tsset date

    /*FIGURES*/

        tsline G P, scheme(sj)
        tsline D.G D.P, scheme(sj)

    /*A SERIES OF ADF REGRESSIONS TO SELECT LAG. THEN, USE DFULLER TO GET STATISTIC AND CRITICAL VALUES*/

        regress D.G L1.G date
            estat bgodfrey
        regress D.G L1.G L1.D.G date
            estat bgodfrey
        regress D.G L1.G L1.D.G L2.D.G date
            estat bgodfrey
        dfuller G, trend lags(2)

    /*A SERIES OF ADF REGRESSIONS TO SELECT LAG. THEN, USE DFULLER TO GET STATISTIC AND CRITICAL VALUES*/

        regress D.P L1.P date
            estat bgodfrey
        regress D.P L1.P L1.D.P date
            estat bgodfrey
        regress D.P L1.P L1.D.P L2.D.P date
            estat bgodfrey
        regress D.P L1.P L1.D.P L2.D.P L3.D.P date
            estat bgodfrey
        dfuller P, trend lags(3)

    /*A SERIES OF ADF REGRESSIONS TO SELECT LAG. THEN, USE DFULLER TO GET STATISTIC AND CRITICAL VALUES*/

        dfuller D.G, lags(1)
            estat bgodfrey
        dfuller D.P, lags(2)
            estat bgodfrey

    /*COINTEGRATION REGRESSION + CONSTANT*/

    regress G P
        predict ehat, residual
        regress D.ehat L.ehat

    /*VAR*/

        varbasic D.G D.P, lags(1/1) step(12)

    /*TEST RESIDUALS FOR AUTOCORRELATION*/

        varlmar

    /*IRF*/

        irf table irf
        irf table fevd

        irf graph irf

        irf graph fevd

        irf table irf fevd, title("Combined IRF/FEVD for G and P")
