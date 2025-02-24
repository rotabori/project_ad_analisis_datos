** PROJECT: ANALISIS DE DATOS
** PROGRAM: VaR.do
** PROGRAM TASK: Value at risk
** AUTHOR: RODRIGO TABORDA
** DATE CREATED: 2024/03/01
** DATE REVISION 1:
** DATE REVISION #:

*********************************************************************;
*** #0 *** PROGRAM SETUP
*********************************************************************;

    pause on
    #delimit ;
    /*COMMAND LINES WILL ONLY END ONCE SEMICOLON IS FOUND*/;

** #0.1 ** SET PATH FOR READING/SAVING DATA;

*    cd ../../;

********************************************************************;
** #1 ** DATA-IN;
********************************************************************;

*** #1.0 ** SET DIRECTORY;
*    cd ../../../;

*** #1.1 ** LOAD DATA;
*    use https://rodrigotaborda.com/ad/data/sp500/sp500_dgs1_daily.dta
*        ,
*        clear
*        ;

    use date sp500 using https://rodrigotaborda.com/ad/data/sp500/sp500_dgs1_daily.dta
        ,
        clear
        ;
        
    tsset date;

*    /*GENERATE FAKE DATE COUNTER*/;
*    gen date_counter = _n;
*        tsset date_counter;

********************************************************************;
** #2 ** VaR;
********************************************************************;

*** #2.0 ** PARAMETRIC APPROACH;

    /*RETURNS*/;
    gen sp500_rsimple = ((sp500/l.sp500)-1)*100;
        label var sp500_rsimple "S&P 500 return (simple)";

    /*HISTOGRAM RETURNS*/;
    hist sp500_rsimple
        ,
        scheme(s1mono)
        name(sp500_rsimple_hist)
        ;

    hist sp500_rsimple if sp500_rsimple > -5 & sp500_rsimple < 5
        ,
        scheme(s1mono)
        name(sp500_rsimple_hist55)
        ;

    /*RETURNS PARAMETERS*/;
    summarize sp500_rsimple;
        local n = r(N);
        scalar mean = r(mean);
        scalar sd = r(sd);
        scalar var = r(Var);

    gmm (sp500_rsimple - {mean_gmm})
        ((sp500_rsimple - {mean_gmm})^2 - ((`n'-1)/`n')*{var_gmm})
        ,
        onestep
        winitial(identity)
        vce(robust);
qqq    
    /*VaR 1 day - day*/;
    nlcom (var95: (_b[mean_gmm:_cons] + sqrt(_b[var_gmm:_cons])*invnormal(0.05))*sqrt(1))
          (var97: (_b[mean_gmm:_cons] + sqrt(_b[var_gmm:_cons])*invnormal(0.03))*sqrt(1))
          (var99: (_b[mean_gmm:_cons] + sqrt(_b[var_gmm:_cons])*invnormal(0.01))*sqrt(1))
        ;

    /*VaR 5 day - week*/;
    nlcom (var95: (_b[mean_gmm:_cons] + sqrt(_b[var_gmm:_cons])*invnormal(0.05))*sqrt(5))
          (var97: (_b[mean_gmm:_cons] + sqrt(_b[var_gmm:_cons])*invnormal(0.03))*sqrt(5))
          (var99: (_b[mean_gmm:_cons] + sqrt(_b[var_gmm:_cons])*invnormal(0.01))*sqrt(5))
        ;

    /*VaR 20 day - month*/;
    nlcom (var95: (_b[mean_gmm:_cons] + sqrt(_b[var_gmm:_cons])*invnormal(0.05))*sqrt(20))
          (var97: (_b[mean_gmm:_cons] + sqrt(_b[var_gmm:_cons])*invnormal(0.03))*sqrt(20))
          (var99: (_b[mean_gmm:_cons] + sqrt(_b[var_gmm:_cons])*invnormal(0.01))*sqrt(20))
        ;

    /*VaR 1 day - day using t-distribuion*/;
    nlcom (var95: (_b[mean_gmm:_cons] + sqrt(_b[var_gmm:_cons])*invt(5,0.05))*sqrt(1))
          (var97: (_b[mean_gmm:_cons] + sqrt(_b[var_gmm:_cons])*invt(5,0.03))*sqrt(1))
          (var99: (_b[mean_gmm:_cons] + sqrt(_b[var_gmm:_cons])*invt(5,0.01))*sqrt(1))
        ;

    /*VaR 1 day - day ARCH*/;
    arch sp500_rsimple, arch(1) garch(1);
        predict variance, variance;
        predict residuals, residuals;
        
        generate var95garch = mean + variance^0.5 * invnormal(0.05);
        generate var97garch = mean + variance^0.5 * invnormal(0.03);
        generate var99garch = mean + variance^0.5 * invnormal(0.01);

    tsline sp500_rsimple var95garch
        ,
        scheme(s1mono)
        caption(,position(6))
        name(sp500_rsimple_var95garch)
        ;

*** #3.0 ** HISTORICAL SIMULATION;

    centile sp500_rsimple, centile(5,3,1);

*** #4.0 ** MONTE CARLO SIMULATION;

    set obs 10000;
    summarize sp500_rsimple;
    scalar mean = r(mean);
    scalar std = r(sd);
    
    set seed 123;
    generate sp500_rsimple_sim = rnormal(mean, std);

    hist sp500_rsimple_sim
        ,
        scheme(s1mono)
        name(sp500_rsimple_sim_hist)
        ;

    centile sp500_rsimple_sim, centile(5,3,1);

*** #4.0 ** EXPECTED SHORTFALL;

    scalar es95 = normalden(invnormal(1 - .95))/(1 - .95);
    scalar es97 = normalden(invnormal(1 - .97))/(1 - .99);
    scalar es99 = normalden(invnormal(1 - .99))/(1 - .99);
    
    display "Los valores de ES para percentil 95, 97 y 99, son: " es95 " " es97 " " es99;
