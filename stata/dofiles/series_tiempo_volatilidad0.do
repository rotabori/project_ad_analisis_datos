** PROJECT: ANALISIS DE DATOS
** PROGRAM: series_tiempo_volatilidad0.do
** PROGRAM TASK: SERIES DE TIEMPO VOLATILIDAD Y ARCH
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2020/04/07
** DATE REVISION 1:
** DATE REVISION 2:

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

    use http://www.principlesofeconometrics.com/poe3/data/stata/returns, clear

    /*CREATE DECLARE DATE*/
        gen month = mod(_n-1,12) + 1
        egen year = seq(), f(1988) t(2004) b(12)
        gen date = ym(year,month)
        format %tm date
        tsset date

    /*CREATE DECLARE DATE*/
        drop date
        gen date = m(1988m1) + _n - 1
        format date %tm
        tsset date

    /*FIGURES*/
        twoway(tsline RUS)

        twoway(tsline ROZ)

        twoway(tsline RJAP)

        twoway(tsline RHK)

        histogram RUS, normal

        histogram ROZ, normal

        histogram RJAP, normal

        histogram RHK, normal

*********************************************************************;
*** #20 ** PRINCIPLES OF ECONOMETRICS;
*********************************************************************;

    use http://www.principlesofeconometrics.com/poe3/data/stata/byd, clear

    gen time = _n
    tsset time

    tsline r

    /*ARCH(1) TEST*/

    regress r
        predict ehat, residual
        gen ehat2 = ehat * ehat
        regress ehat2 L.ehat2
        scalar NR2 = e(N)*e(r2)
        scalar pvalue = chi2tail(1,NR2)
        scalar list NR2 pvalue

    /*ARCH(1) TEST*/

    regress r
        estat archlm, lags(1)

    /*ARCH(1) REGRESSION*/

    arch r, arch(1)
        predict htarch, variance
        tsline htarch

    /*GARCH(1,1) TEST*/

    arch r, arch(1) garch(1)
        predict htgarch, variance
        tsline htgarch
