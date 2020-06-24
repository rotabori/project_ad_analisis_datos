** PROJECT: ANALISIS DE DATOS
** PROGRAM: regresion_lineal_supuestos.do
** PROGRAM TASK: LINEAR REGRESSION ASSUMPTION
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2020/04/07
** DATE REVISION 1:
** DATE REVISION #:

/*HETEROSKEDASTICITY*/
    /*ROBUST*/
    reg y x1 x2, vce(robust)

    /*GLS*/
    /*ANALYTIC WEIGTH*/
    reg y x1 [aweight = 1/x1]

    /*DETECTING / TEST*/
    reg y x1 x2
        predict ehat, residual

        scatter ehat x1
        scatter ehat x2

    /*GOLDFELD - QUANDT TEST*/
    regress y x1 in 1/20
    scalar s_small = e(rmse)^2
    scalar df_small = e(df_r)

    regress y x1 in 21/40
    scalar s_large = e(rmse)^2
    scalar df_large = e(df_r)

    scalar GQ = s_large/s_small
    scalar crit = invFtail(df_large,df_small,.05)
    scalar pvalue = Ftail(df_large,df_small,GQ)
    scalar list GQ pvalue crit

    /*BREUSCH - PAGAN / GODFREY TEST*/
    regress y x1
    predict ehat, residual
    gen ehat2 = ehat*ehat

        /*LM TEST MANUALLY*/
        regress ehat2 income
        scalar LM = e(N)*e(r2)
        scalar pvalue = chi2tail(1,LM)
        scalar list LM pvalue

        /*LM TEST USING THE BUILT IN FUNCTIONS*/
        regress y x1
        estat hettest x1, iid

        /*WHITE*/
        regress y x1
        gen x12 = x1^2
        regress ehat2 x1 x12
        scalar LM = e(N)*e(r2)
        scalar pvalue = chi2tail(2,LM)
        scalar list LM pvalue

        /*WHITE'S TEST USING BUILT IN FUNCTIONS*/
        regress y x1
        estat imtest, white

/*AUTO-CORRELATION*/
    gen time = _n
    tsset time, yearly

    gen y_ln = ln(y)
    gen x1_ln = ln(x1)

    regress y_ln x1_ln
    predict ehat, residual

    twoway (scatter ehat time)

    gen ehat_1 = ehat[_n-1]
    correlate ehat ehat_1

    corrgram ehat
    ac ehat

    /*BREUSCH-GODFREY*/
    regress y_ln x1_ln
    estat bgodfrey

        predict ehat, residual
        replace ehat_1 = 0 in 1
        regress ehat x1_ln ehat_1
        di (e(N))*e(r2)

    /*DURBIN WATSON STATISTIC*/
        regress la lp
        estat dwatson
