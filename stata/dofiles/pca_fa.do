** PROJECT: ANALISIS DE DATOS
** PROGRAM: pca_fa.do
** PROGRAM TASK: EXECUTE PRINCIPAL COMPONENTS ANALYSIS & FACTOR ANALYSIS
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2017/08/17
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
** #10 ** EXECUTE DATA-IN ROUTINE;
********************************************************************;



********************************************************************;
** #20 ** PCA;
********************************************************************;

*** #20.1 ** PCA;

    corr var1 var2 var3 ... var#;
    pca var1 var2 var3 ... var#;

*** #20.2 ** SCREEPLOT;

    screeplot;

*** #20.3 ** LOADING PLOT;

    loadingplot, yline(0) xline(0);

*** #20.4 ** SCORE PLOT;

    scoreplot;

*** #20.4 ** PREDICT;

    predict c1-c#;
    /*PREDICT # DE COMPONENTES*/
    /*c1 IS JUST A NAME, YOU CAN USE ANY NAME*/

*** #20.5 ** CHECK ASSUMPTIONS;

    summarize c1-c#

*   display a11^2 + ... + a1k^2 /*MUST BE EQUAL TO 1*/
*   display  corr(x1,c1) = c1_eigenvalue^.5 * a11

    corr x1 x# c1 c#

********************************************************************;
** #30 ** FACTOR ANALYSIS;
********************************************************************;

*** #30.1 ** FACTOR ANALYSIS;

    corr var1 var2 var3 ... var#;
    factor var1 var2 var3 ... var#, pcf;
    factor var1 var2 var3 ... var#, pcf mineigen(.9);

*** #30.2 ** SCREEPLOT;

    screeplot;

*** #30.3 ** LOADING PLOT;

    loadingplot;

*** #30.4 ** SCORE PLOT;

    scoreplot;

*** #30.4 ** PREDICT;

    predict f1-f#;
    /*PREDICT # DE FACTORES*/
    /*f1 IS JUST A NAME, YOU CAN USE ANY NAME*/

    corr f1-f# var1 var2 var3 ... var#;

*** #30.5 ** ROTATE;

    rotate;

********************************************************************;
** #31 ** FACTOR & PCA ANALYSIS COUNTRY VALUE ADDED SHARES EXAMPLE;
********************************************************************;

    import delimited http://rodrigotaborda.com/ad/data/wb/va_shares_2015.txt, delimiter(tab) clear;

    graph matrix manufacturing agriculture services, half;
    corr manufacturing agriculture services;
    graph twoway (scatter m a) (scatter m a if country_code == "COL");
    graph twoway (scatter m a, msize(vsmall)) (scatter m a if country_code == "COL", mlabel(country_code));

*** #31.1 ** FACTOR ANALYSIS;

    pca manufacturing agriculture services;
    factor manufacturing agriculture services, pcf;

*** #31.2 ** SCREEPLOT;

    screeplot;

*** #31.3 ** LOADING PLOT;

    loadingplot, yline(0) xline(0) title(Loadings original) name(f0);
    loadingplot, components(3) combined yline(0) xline(0) title(Loadings original) name(f0);

*** #31.4 ** SCORE PLOT;

    scoreplot, yline(0) xline(0);

*** #31.4 ** PREDICT;

    predict factor1 factor2;
    corr factor1 factor2 manufacturing agriculture services;

*** #31.5 ** ROTATE;

    rotate, varimax
    loadingplot, xline(0) yline(0) title(varimax) name(varimax)
    predict varimax1 varimax2

    rotate , oblique oblimin
    loadingplot, xline(0) yline(0) title(oblique) name(oblimin)
    predict oblique1 oblique2

    rotate , oblique oblimax
    loadingplot, xline(0) yline(0) title(oblimax) name(oblimax)
    predict oblimax1 oblimax2

    corr factor* varimax* oblique* oblimax*

********************************************************************;
** #32 ** FACTOR & PCA BIENESTAR EN EL TRABAJO;
********************************************************************;

    use http://www.rodrigotaborda.com/ad/data/bt/bt.dta, clear;

*** #32.1 ** FACTOR ANALYSIS;

    factor msq_i* msq_e*, pcf;

    factor mhc_*, pcf;

*** #32.2 ** SCREEPLOT;



*** #32.3 ** LOADING PLOT;



*** #32.4 ** SCORE PLOT;



*** #32.4 ** PREDICT;



*** #32.5 ** ROTATE;



*** #32.6 ** EXAMINE;



********************************************************************;
** #33 ** FACTOR & PCA ENCUESTA ESTUDIANTES;
********************************************************************;

    use http://rodrigotaborda.com/ad/data/ee/encuesta_estudiantes_20xxyy_old.dta, clear;

*** #33.1 ** PCA & FACTOR ANALYSIS;

    pca peso estatura;

    factor pelicula relacion zapatos cal_1s cal_us cal_cal cal_prob, pcf;

    /*SCATTER AND HISTOGRAM GRAPH*/
    graph twoway
        (scatter peso estatura, msize(vsmall))
        ,
        ysca(alt)
        xsca(alt)
        xlabel(145(10)195, grid gmax)
        ylabel(50(10)110, grid gmax)
        plotregion(lwidth(none))
        legend(off)
        scheme(s1mono)
        name(peso_estatura_scatter, replace);

    twoway histogram peso, fraction
        width(2)
        xsca(alt reverse) horiz
        xlabel(, gmax)
        ylabel(50(10)110, grid gmax)
        lcolor(gs12)
        plotregion(lwidth(none))
        scheme(s1mono)
        name(peso_hist, replace);

    twoway histogram estatura, fraction
        width(2)
        ysca(alt reverse)
        ylabel(, gmax)
        xlabel(145(10)195, grid gmax)
        lcolor(gs12)
        plotregion(lwidth(none))
        scheme(s1mono)
        name(estatura_hist, replace);

    graph combine
                    peso_hist
                    peso_estatura_scatter
                    estatura_hist,
        imargin(0 0 0 0)
        hole(3)
        scheme(s1mono)
        name(peso_estatura_hist_scatter, replace)
        ;


*** #33.2 ** SCREEPLOT;



*** #33.3 ** LOADING PLOT;



*** #33.4 ** SCORE PLOT;



*** #33.4 ** PREDICT;



*** #33.5 ** ROTATE;



*** #33.6 ** EXAMINE;



**** #90.9.9 ** GOOD BYE;
*
*    clear;
