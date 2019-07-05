** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: pca_fa.do
** PROGRAM TASK: EXECUTE PRINCIPAL COMPONENTS ANALYSIS & FACTOR ANALYSIS
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 17/08/2017
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
** #20 ** PCA;
********************************************************************;

*** #20.1 ** PCA;

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

********************************************************************;
** #30 ** FACTOR ANALYSIS;
********************************************************************;

*** #30.1 ** FACTOR ANALYSIS;

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

*** #30.5 ** ROTATE;

    rotate;

********************************************************************;
** #31 ** FACTOR & PCA ANALYSIS COUNTRY VALUE ADDED SHARES;
********************************************************************;

    import delimited http://rodrigotaborda.com/ads/data/wb/va_shares_2015.txt, delimiter(tab) clear;

    graph matrix manufacturing agriculture services;

*** #31.1 ** FACTOR ANALYSIS;

    pca manufacturing agriculture services;
    factor manufacturing agriculture services, pcf;

*** #31.2 ** SCREEPLOT;

    screeplot;

*** #31.3 ** LOADING PLOT;

    loadingplot, yline(0) xline(0) title(Loadings) name(factor);

*** #31.4 ** SCORE PLOT;

    scoreplot;

*** #31.4 ** PREDICT;

    predict f1-f2;

*** #31.5 ** ROTATE;

    rotate;
*    rotate , oblique oblimin;
    loadingplot, yline(0) xline(0) title(Loadings rotated) name(factor_rot);

*** #31.6 ** EXAMINE;

    list (idvar) (factors);

    graph twoway (scatter f2 f1) (scatter f2 f1 if country_code == "COL" | country_code=="TCD", mlabel(country_code));

********************************************************************;
** #32 ** FACTOR & PCA PLANETS DATA TAKEN FROM HAMILTON(2013);
********************************************************************;

    use http://rodrigotaborda.com/ad/data/hamilton_2013/planets.dta, clear;

*** #32.1 ** FACTOR ANALYSIS;



*** #32.2 ** SCREEPLOT;



*** #32.3 ** LOADING PLOT;



*** #32.4 ** SCORE PLOT;



*** #32.4 ** PREDICT;



*** #32.5 ** ROTATE;



*** #32.6 ** EXAMINE;







**** #90.9.9 ** GOOD BYE;
*
*    clear;
