** PROJECT: ANALISIS DE DATOS
** PROGRAM: nasdaq.do
** PROGRAM TASK: FINANCIAL TIME SERIES
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2020/09/03
** DATE REVISION 1:
** DATE REVISION 2:

********************************************************************;
** #0
********************************************************************;

** #0 ** PROGRAM SETUP

    pause on
    #delimit ;

** #0.1 ** SET PATH FOR READING/SAVING DATA;

    cd ../../../;

** #1 ** READ AND SET UP DATA;

** #1.1 ** LOAD DATA;
** THIS DATA COMES FROM YAHOO FINANCE WEBSITE, DAILY, RETRIEVED 20200903;

    import delimited
        /*data/nasdaq/nasdaq5y_20200903.csv*/
        http://rodrigotaborda.com/ad/data/nasdaq/nasdaq5y_20200903.csv
        ,
    	delimiter(",")
        clear
        ;

    rename open nasdaq_open;
    rename high nasdaq_high;
    rename low nasdaq_low;
    rename close nasdaq_close;
    rename volume nasdaq_volume;

    drop adjclose;

** #1.2 ** DECLARE TIME SERIES;

    gen date_stata = date(date,"YMD");
        format date_stata %td;
        label var date_stata "Date (Stata)";

    bcal create data/nasdaq/nasdaq_cal, from(date_stata) generate(date_nasdaq) dateformat(dmy) replace;
        label var date_nasdaq "Date (NASDAQ)";

    tsset date_nasdaq;

    order date*, first;

** #2 ** NEW VARIABLES;

** #2.1 ** DAILY RETURNS;

    gen nasdaq_ret_s = ((nasdaq_close/l.nasdaq_close)-1)*100;
        label var nasdaq_ret_s "NASDAQ (Ret. simple)";

    gen nasdaq_ret_l = ln(nasdaq_close/l.nasdaq_close)*100;
        label var nasdaq_ret_l "NASDAQ (Ret. ln)";

    gen nasdaq_ret_l2 = nasdaq_ret_l^2;
        label var nasdaq_ret_l2 "NASDAQ (Ret. ln - Sq)";

*** #2.1 ** MONTHLY RETURNS;
*
*    gen nasdaq_ret_s = ((nasdaq_close/l30.nasdaq_close)-1)*100;
*        label var nasdaq_ret_s "NASDAQ (Ret. simple)";
*
*    gen nasdaq_ret_l = ln(nasdaq_close/l30.nasdaq_close)*100;
*        label var nasdaq_ret_l "NASDAQ (Ret. ln)";

** #3 ** DATA ANALYSIS;

** #3.1 ** DESCRIPTIVE MEASURES;

    /*Mean, Variance, Skewness, Kurtosis*/;
    sum nasdaq_ret_l, detail;

** #3.2 ** NORMALITY;

    /*HISTOGRAM*/;
    hist nasdaq_ret_l
        ,
        scheme(s1mono)
        name(nasdaq_ret_l_h)
        ;

    hist nasdaq_ret_l
        ,
        kdensity
        scheme(s1mono)
        name(nasdaq_ret_l_h_k)
        ;

    /*Q-Q quantile quantile plot*/;
    qnorm nasdaq_ret_l
        ,
        grid
        scheme(s1mono)
        name(nasdaq_ret_l_qnorm)
        ;

    /*P-P probability plot*/;
    pnorm nasdaq_ret_l
        ,
        grid
        scheme(s1mono)
        name(nasdaq_ret_l_pnorm)
        ;

    /*Jarque - Bera test*/;
    sktest nasdaq_ret_l;
    sktest nasdaq_ret_l, noadjust;

    /*Shapiro - Wilk test*/;
    swilk nasdaq_ret_l;

    /*Shapiro - Francia test*/;
    sfrancia nasdaq_ret_l;

** #4 ** ARCH;

** #4.1 ** FIGURES;

    /*LEVEL*/;
        tsset date_stata;
        tsline nasdaq_close,
            title(NASDAQ)
            ytitle("")
            note("Note: Closing price")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(03sep2015(120)02sep2020, tpos(out))
            tlabel(#4, format(%tdCCYY) angle(90))
            name(nasdaq_tsline)
            ;

    /*RETURNS*/;
        tsset date_stata;
        tsline nasdaq_ret_l,
            title(NASDAQ)
            subtitle(Returns)
            ytitle("")
            note("Note: Closing price")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(03sep2015(120)02sep2020, tpos(out))
            tlabel(#4, format(%tdCCYY) angle(90))
            name(nasdaq_ret_l)
            ;

    /*RETURNS*/;
        tsset date_stata;
        tsline nasdaq_ret_l2,
            title(NASDAQ)
            subtitle(Returns (Sq))
            ytitle("")
            note("Note: Closing price")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(03sep2015(120)02sep2020, tpos(out))
            tlabel(#4, format(%tdCCYY) angle(90))
            name(nasdaq_ret_l2)
            ;

    /*LEVEL SCATTER*/;
        tsset date_nasdaq;
        scatter nasdaq_close l1.nasdaq_close,
            title(NASDAQ)
            msize(vsmall)
            connect(l)
            lcolor(gs0)
            lwidth(thin)
            note("Note: Closing price")
            ytitle("t")
            xtitle("t-1")
            scheme(s1mono)
            name(nasdaq_scatter)
            ;

    /*RETURNS SCATTER*/;
        tsset date_nasdaq;
        scatter nasdaq_ret_l l1.nasdaq_ret_l,
            title(NASDAQ)
            subtitle(Returns)
            msize(vsmall)
            connect(l)
            yline(0, lwidth(thin) lcolor(red))
            xline(0, lwidth(thin) lcolor(red))
            lcolor(gs0)
            lwidth(thin)
            note("Note: Closing price")
            ytitle("t")
            xtitle("t-1")
            scheme(s1mono)
            name(nasdaq_ret_l_scatter)
            ;

** #5 ** ARMA;

** #5.1 ** FIGURES;



** #5.1 ** MODELS;

    arima nasdaq_ret_l, arima(2,0,2);
        estat ic;
        estimates store arima202;

    arima nasdaq_ret_l, arima(2,0,1);
        estat ic;
        estimates store arima201;

    arima nasdaq_ret_l, arima(1,0,2);
        estat ic;
        estimates store arima102;

    arima nasdaq_ret_l, arima(1,0,1);
        estat ic;
        estimates store arima101;

    arima nasdaq_ret_l, arima(1,0,0);
        estat ic;
        estimates store arima100;

    arima nasdaq_ret_l, arima(0,0,1);
        estat ic;
        estimates store arima001;

    arima nasdaq_ret_l, arima(0,0,0);
        estat ic;
        estimates store arima000;

    estimates stat _all;

    estimates table _all, stats(aic bic);

** #6 ** ARCH;

** #6.1 ** MODELS;

    /*ARCH(1) TEST*/;
    regress nasdaq_ret_l;
        predict ehat, residual;
        gen ehat2 = ehat^2;
        regress ehat2 l.ehat2;
        scalar NR2 = e(N)*e(r2);
        scalar pvalue = chi2tail(1,NR2);
        scalar list NR2 pvalue;

    /*ARCH(1) TEST*/;
    regress nasdaq_ret_l;
        estat archlm, lags(1);

    /*ARCH(1) REGRESSION*/;
    arch nasdaq_ret_l, arch(1);
        /*arch pre_can_rcomp, arch(1) arima(1,0,0)*/;
        predict nasdaq_ret_l_arch, variance;
        tsline nasdaq_ret_l_arch, name(arch);

    /*GARCH(1,1) TEST*/;
    arch nasdaq_ret_l, arch(1) garch(1);
        predict nasdaq_ret_l_garch, variance;
        tsline nasdaq_ret_l_garch, name(garch);

    /*REGRESIÓN ASYMMETRIC-GARCH*/;
    arch nasdaq_ret_l, arch(1) garch(1) saarch(1);
        predict nasdaq_ret_l_saarch, variance;
        tsline nasdaq_ret_l_saarch, name(saarch);

    /*REGRESIÓN T-GARCH*/;
    arch nasdaq_ret_l, arch(1) garch(1) tarch(1);
        predict nasdaq_ret_l_tarch, variance;
        tsline nasdaq_ret_l_tarch, name(tarch);


**** #90.9.9 ** GOOD BYE;
*
*    clear;
