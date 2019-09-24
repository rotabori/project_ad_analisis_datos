/*INSTRUMENTAL VARIABLES*/
    use http://www.principlesofeconometrics.com/poe3/data/stata/ch10, clear
    summarize

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

**---------------------------------
** Mroz data example
**---------------------------------
*
*use mroz, clear
*
*summarize
*
*drop if lfp==0
*gen lwage = log(wage)
*gen exper2 = exper^2
*
** Least squares estimation
*reg lwage educ exper exper2
*estimates store ls
*
** IV estimation
*reg educ exper exper2 mothereduc
*predict educ_hat
*reg lwage educ_hat exper exper2
*
** IV estimation using automatic command
*ivregress 2sls lwage (educ=mothereduc) exper exper2
*ivregress 2sls lwage (educ=mothereduc) exper exper2, small
*ivregress 2sls lwage (educ=mothereduc) exper exper2, vce(robust) small
*
** IV estimation with surplus instruments
*ivregress 2sls lwage (educ=mothereduc fathereduc) exper exper2, small
*estimates store iv
*
** Hausman test regression based
*reg educ exper exper2 mothereduc fathereduc
*predict vhat, residuals
*reg lwage educ exper exper2 vhat
*reg lwage educ exper exper2 vhat, vce(robust)
*
** Hausman test automatic
*hausman iv ls, constant sigmamore
*
** Testing for weak instruments
*reg educ exper exper2 mothereduc
*reg educ exper exper2 fathereduc
*reg educ exper exper2 mothereduc fathereduc
*test mothereduc fathereduc
*
** Testing for weak instruments using estat
*ivregress 2sls lwage (educ=mothereduc fathereduc) exper exper2, small
*estat firststage
*
** Robust tests
*reg educ exper exper2 mothereduc fathereduc, vce(robust)
*test mothereduc fathereduc
*
** Robust tests using ivregress
*ivregress 2sls lwage (educ=mothereduc fathereduc) exper exper2, small vce(robust)
*estat firststage
*
** Testing surplus moment conditions
*ivregress 2sls lwage (educ=mothereduc fathereduc) exper exper2, small
*predict ehat, residuals
*quietly reg ehat mothereduc fathereduc exper exper2
*scalar nr2 = e(N)*e(r2)
*scalar chic = invchi2tail(1,.05)
*scalar pvalue = chi2tail(1,nr2)
*di "NR^2 test of overidentifying restriction  = " nr2
*di "Chi-square critical value 1 df, .05 level = " chic
*di "p value for overidentifying test 1 df, .05 level = " pvalue
*
** Using estat
*quietly ivregress 2sls lwage (educ=mothereduc fathereduc) exper exper2, small
*estat overid

/*TRUFFLE SUPPLY AND DEMAND*/
    use http://www.principlesofeconometrics.com/poe3/data/stata/truffles, clear

/*reduced form equations*/
    reg q ps di pf
    reg p ps di pf
    predict phat

/*2SLS OF DEMAND*/
    reg q phat ps di

/*IV/2SLS OF DEMAND EQUATION*/
    ivregress 2sls  q (p=pf)  ps di
    ivregress 2sls  q (p=pf)  ps di, small
    ivregress 2sls  q (p=pf)  ps di, small first
    estat firststage

/*2SLS OF SUPPLY*/
    reg q phat pf

/*IV/2SLS OF SUPPLY EQUATION*/
    ivregress 2sls  q (p=ps di)  pf, small first
    estat firststage

**--------------------------------------
** 2sls using REG3
** This is not discussed in the chapter.
** Enter help reg3
**--------------------------------------
*
*reg3 (q p ps di) (q p pf), endog(q p) 2sls

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
