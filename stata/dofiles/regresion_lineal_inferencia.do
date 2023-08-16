** PROJECT: ANALISIS DE DATOS
** PROGRAM: regresion_lineal_inferencia.do
** PROGRAM TASK: INFERENCE ON LINEAR REGRESSION
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
** #10 ** INFERENCE Z-DISTRIBUTION;
********************************************************************;

# delimit ;
    twoway  function z = normalden(x), range(-4 4) xline(0) xlabel(-2.57 -1.96 -1.64 -1.43 -1.28 2.57 1.96 1.64 1.43 1.28, angle(70) labsize(small)) ytitle("") xtitle("z") ||
            function z128n = normalden(x), range(-4 -1.28) recast(area) legend(off) color(pink) ||
            function z128 = normalden(x), range(1.28 4) recast(area) legend(off) color(pink) ||

            function z143n = normalden(x), range(-4 -1.43) recast(area) legend(off) color(blue)||
            function z143 = normalden(x), range(1.43 4) recast(area) legend(off) color(blue)||

            function z164n = normalden(x), range(-4 -1.64) recast(area) legend(off) color(black)||
            function z164 = normalden(x), range(1.64 4) recast(area) legend(off) color(black)||

            function z196n = normalden(x), range(-4 -1.96) recast(area) legend(off) color(yellow)||
            function z196 = normalden(x), range(1.96 4) recast(area) legend(off) color(yellow)||

            function z257n = normalden(x), range(-4 -2.57) recast(area) legend(off) color(orange) ||
            function z257 = normalden(x), range(2.57 4) recast(area) legend(off) color(orange)
        ;
sss
********************************************************************;
** #20 ** INFERENCE AFTER LINEAR REGRESSION;
********************************************************************;

** #20.1 ** REGRESSION;

    regress var_y var_x1 var_x#;

    /*RETURN ERETURN*/
    ereturn list /*ESTIMATION RESULTS AFTER REGRESSION OR OTHER COMMAND*/
    return list

** #20.2 ** CRITICAL VALUE, CONFIDENCE INTERVAL, T-STAT AND P-VALUE;

    /*T-STAT*/
    scalar tstat = (_b[expl var] - 0) / _se[expl var]
    local tstat = (_b[expl var] - 0) / _se[expl var]

    /*CRITICAL VALUE*/
    scalar tc975 = invttail(e(N)-(e(df_m)+1),0.05/2)
    local tc975 = invttail(e(N)-(e(df_m)+1),0.05/2)

    /*CONFIDENCE INTERVALS*/
    scalar ulb = _b[expl var] +- tc975*_se[expl var]

    /*P-VALUE*/
    scalar pvalue = ttail(e(N)-(e(df_m)+1),abs(tstat))*2

    /*GRAPH*/
    twoway function y = tden(e(N)-(e(df_m)+1),x), range(-4 4) xline(`tstat') xlabel(-`tc975' `tc975' `tstat', format(%9.2f)) ||
        function y = tden(e(N)-(e(df_m)+1),x), range(-4 -`tc975') recast(area) color(dknavy) ||
        function y = tden(e(N)-(e(df_m)+1),x), range(`tc975' 4) recast(area) color(dknavy) legend(off) ytitle(Densidad) xtitle(t)

    /*EXAMPLE AUTO DATASET*/;
    sysuse auto
    reg price mpg weight
    scalar t_mpg = (_b[mpg] - 0) / _se[mpg]
    local t_mpg = (_b[mpg] - 0) / _se[mpg]
    scalar tc975 = invttail(e(N)-(e(df_m)+1),0.05/2)
    local tc975 =  invttail(e(N)-(e(df_m)+1),0.05/2)
    scalar ub_mpg = _b[mpg] + tc975*_se[mpg]
    scalar lb_mpg = _b[mpg] - tc975*_se[mpg]
    display lb_mpg " " ub_mpg
    scalar pvalue_mpg = ttail(e(N)-(e(df_m)+1),abs(t_mpg))*2
    display t_mpg " " pvalue_mpg
    twoway (function y = tden(e(N)-(e(df_m)+1),x), range(-4 4) xline(`t_mpg') xlabel(-`tc975' `tc975' `t_mpg', format(%9.2f))) (function y = tden(e(N)-(e(df_m)+1),x), range(-4 -`tc975') recast(area) color(dknavy)) (function y = tden(e(N)-(e(df_m)+1),x), range(`tc975' 4) recast(area) color(dknavy) legend(off) ytitle(Densidad) xtitle(t))

    /*HIPOTHESIS TEST*/
    test var
    test (var=0)
    test (_b[var]=0)
    test (var=0) (var=0)
    test 2.x1 3.x1 /*TEST FOR INDICATOR VARIABLES EQUAL TO ZERO*/
    test (2.x1=0) (3.x1=1) /*TEST FOR INDICATOR VARIABLES EQUAL TO ZERO AND ONE*/
    testparm i.x1 /*TEST FOR INDICATOR VARIABLES ALL AT ONCE*/
    test 2.x1 = 3.x1 /*TEST IF 2 AND 3 ARE EQUAL*/
    lincom 2.x1 - 3.x1 /*TEST IF 2 MINUS 3 ARE ZERO*/

    /*EXAMPLE AUTO DATASET CONT.*/;
    test (mpg = 0) (weight = 0)

    local fc95 = invFtail(e(df_m),e(N)-e(df_m),0.05)
    matrix b_k = e(b)[1,1 .. 2]'
    matrix v_k = e(V)[1..2,1 .. 2]
    matrix f_k = (b_k'*inv(v_k)*b_k)/e(df_m)
    scalar f_k = f_k[1,1]
    local f_k = f_k

    twoway (function y = Fden(e(df_m),e(N)-e(df_m),x), range(0 20) xline(`fc95' `f_k') xlabel(#3 `fc95' `f_k', format(%9.2f))) (function y = Fden(e(df_m),e(N)-e(df_m),x), range(`fc95' 20) recast(area) color(dknavy))

    test (mpg = -50) (weight = 0)
    test (mpg = -50) (weight = 2)
    test (mpg = 0) (weight = 2)

    /*HIPOTHESIS TEST OF LINEAR COMBINATION*/
    lincom x1 + x2

    /*NONLINEAR MODEL*/
    reg y x2 x2^2
        /*PREDICTED*/
        gen y_hat = _[_cons] + _b[x1]*x1 + _b[x2]*x2 + _b[x2^2]*x2^2
        twoway (connected y_hat x2, sort)
        /*OPTIMUM X2*/
        scalar x2_opt = -_b[x2]/2*_b[x2^2]
        nlcom -_b[x2]/2*_b[x2^2]

    /*MAXIMUM LIKELIHOOD TEST*/
    reg y x2 x2^2
        estimates store m1
    reg y x2
        estimats store m2 if e(sample)

    lrtest m1 m2
