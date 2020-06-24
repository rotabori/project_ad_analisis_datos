** PROJECT: ANALISIS DE DATOS
** PROGRAM: regresion_xaleatoria_endogeneidad.do
** PROGRAM TASK: RANDOM X AND ENDOGENEITY
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2020/04/07
** DATE REVISION 1:
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
** #20 ** ENDOGENEITY;
********************************************************************;

    /*OLS*/
        reg y x
        estimates store ls

    /*IV ESTIMATION MANUAL*/
        reg x z1
        predict xhat
        reg y xhat

    /*IV ESTIMATION COMMAND*/
        ivregress 2sls y (x=z1)
        ivregress 2sls y (x=z1), small
        ivregress 2sls y (x=z2), small
        ivregress 2sls y (x=z3), small

    /*MORE INSTRUMENTS*/
        ivregress 2sls y (x=z1 z2), small
        estimates store iv

    /*HAUSMAN TEST REGRESSION BASED*/
        reg x z1 z2
        predict vhat, residuals
        reg y x vhat

    /*HAUSMAN TEST COMMAND*/
        hausman iv ls, constant sigmamore

    /*TESTING FOR WEAK INSTRUMENTS*/
        reg x z1
        reg x z2
        reg x z1 z2
        test z1 z2

    /*TESTING FOR WEAK IV USING ESTAT*/
        ivregress 2sls y (x=z1 z2), first small
        estat firststage

    /*TESTING SURPLUS MOMENT CONDITIONS*/
        predict ehat, residuals
        reg ehat z1 z2
        scalar nr2 = e(N)*e(r2)
        scalar chic = invchi2tail(1,.05)
        scalar pvalue = chi2tail(1,nr2)
        di "NR^2 test of overidentifying restriction  = " nr2
        di "Chi-square critical value 1 df, .05 level = " chic
        di "p value for overidentifying test 1 df, .05 level = " pvalue

    /*TESTING FOR WEAK IV USING ESTAT*/
        ivregress 2sls y (x=z1 z2), small
        estat overid

    /*TESTING SURPLUS MOMENT CONDITIONS*/
        ivregress 2sls y (x=z1 z2 z3), small
        predict ehat2, residuals
        reg ehat2 z1 z2 z3
        scalar nr2 = e(N)*e(r2)
        scalar chic = invchi2tail(2,.05)
        scalar pvalue = chi2tail(2,nr2)

        di "NR^2 test of overidentifying restriction  = " nr2
        di "Chi-square critical value 2 df, .05 level = " chic
        di "p value for overidentifying test 2 df, .05 level = " pvalue

    /*TESTING SURPLUS MOMENTS USING ESTAT*/
        ivregress 2sls y (x=z1 z2 z3)
        estat overid

********************************************************************;
** #20.1 ** ENDOGENEITY EXAMPLE;
********************************************************************;

    /*FULTON FISH MARKET*/
        use http://www.principlesofeconometrics.com/poe3/data/stata/fultonfish, clear

    /*EXAMINE DATA*/
        summarize lquan lprice mon tue wed thu stormy

    /*ESTIMATE REDUCED FORMS*/
        reg lquan mon tue wed thu stormy
        reg lprice mon tue wed thu stormy
        test mon tue wed thu

    /*IV/2SLS*/
        ivregress 2sls lquan (lprice=stormy) mon tue wed thu, small first
        estat firststage

********************************************************************;
** #30 ** SYSTEM OF EQUATIONS;
********************************************************************;

/*TRUFFLE SUPPLY AND DEMAND*/
    use http://www.principlesofeconometrics.com/poe3/data/stata/truffles, clear

    /*reduced form equations*/
        reg q ps di pf
        reg p ps di pf
            predict phat

    /*2SLS OF DEMAND*/
        reg q phat ps di

    /*IV/2SLS OF DEMAND EQUATION*/
        ivregress 2sls q (p=pf)  ps di
        ivregress 2sls q (p=pf)  ps di, small
        ivregress 2sls q (p=pf)  ps di, small first
            estat firststage

    /*2SLS OF SUPPLY*/
        reg q phat pf

    /*IV/2SLS OF SUPPLY EQUATION*/
        ivregress 2sls q (p=ps di) pf, small first
        estat firststage

    /*IV/3SLS OF SUPPLY EQUATION*/
        reg3 (q p ps di) (q p pf), endog(q p) 2sls
