** PROJECT: ANALISIS DE DATOS
** PROGRAM: series_tiempo_cointegracion_oil_maize.do
** PROGRAM TASK: SERIES DE TIEMPO COINTEGRACION / REGRESION ESPUREA
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2020/10/15
** DATE REVISION 1:

********************************************************************;
** #0
********************************************************************;

** PROGRAM SETUP

    pause on
    #delimit ;

** #0.1 ** SET PATH FOR READING/SAVING DATA;

*    cd ../../;

*********************************************************************;
*** #10 ** LOAD DATA;
*********************************************************************;

    use http://rodrigotaborda.com/ad/data/commodities/commodities_20200428.dta;

    keep date_num pmaizmt poilwti;
    rename date_num date;
    rename pmaizmt maize;
        label var maize "Maize";
    rename poilwti oilwti;
        label var oilwti "Oil (WTI)";

*********************************************************************;
*** #20 ** GRAPHS;
*********************************************************************;

    tsline maize, name(maize);
    tsline oilwti, name(oilwti);

    twoway (tsline maize, yaxis(1)) (tsline oilwti, yaxis(2)), tline(1999m12) name(maize_oil);

    tsline maize if tin(1980m1,1999m12), nodraw name(maize8099);
        ac maize if tin(1980m1,1999m12), nodraw name(maize8099ac);
        pac maize if tin(1980m1,1999m12), nodraw name(maize8099pac);
        graph combine maize8099ac maize8099pac, nodraw name(maize8099acpac) cols(2);
        graph combine maize8099 maize8099acpac, nodraw name(maize8099bj) cols(1);

    tsline maize if tin(2000m1,2019m12), nodraw name(maize0019);
        ac maize if tin(2000m1,2019m12), nodraw name(maize0019ac);
        pac maize if tin(2000m1,2019m12), nodraw name(maize0019pac);
        graph combine maize0019ac maize0019pac, nodraw name(maize0019acpac) cols(2);
        graph combine maize0019 maize0019acpac, nodraw name(maize0019bj) cols(1);

    tsline oilwti if tin(1980m1,1999m12), nodraw name(oilwti8099);
        ac oilwti if tin(1980m1,1999m12), nodraw name(oilwti8099ac);
        pac oilwti if tin(1980m1,1999m12), nodraw name(oilwti8099pac);
        graph combine oilwti8099ac oilwti8099pac, nodraw name(oilwti8099acpac) cols(2);
        graph combine oilwti8099 oilwti8099acpac, nodraw name(oilwti8099bj) cols(1);

    tsline oilwti if tin(2000m1,2019m12), nodraw name(oilwti0019);
        ac oilwti if tin(2000m1,2019m12), nodraw name(oilwti0019ac);
        pac oilwti if tin(2000m1,2019m12), nodraw name(oilwti0019pac);
        graph combine oilwti0019ac oilwti0019pac, nodraw name(oilwti0019acpac) cols(2);
        graph combine oilwti0019 oilwti0019acpac, nodraw name(oilwti0019bj) cols(1);

    graph combine maize8099bj maize0019bj oilwti8099bj oilwti0019bj, name(maizeoilbj) cols(2) iscale(*.7);

*********************************************************************;
*** #20 ** UNIT ROOT ANALYSIS;
*********************************************************************;

    dfuller maize if tin(1980m1,1999m12), regress noconstant lag(1);
    dfuller maize if tin(1980m1,1999m12), regress lag(1);

    dfuller maize if tin(2000m1,2019m12), regress noconstant lag(1);
    dfuller maize if tin(2000m1,2019m12), regress lag(1);

    dfuller oilwti if tin(1980m1,1999m12), regress noconstant lag(1);
    dfuller oilwti if tin(1980m1,1999m12), regress lag(1);

    dfuller oilwti if tin(2000m1,2019m12), regress noconstant lag(1);
    dfuller oilwti if tin(2000m1,2019m12), regress lag(1);

*********************************************************************;
*** #20 ** COINTEGRATION;
*********************************************************************;

    twoway (scatter maize oilwti) (lfit maize oilwti) if tin(1980m1,1999m12), nodraw name(scatter8099);
    twoway (scatter maize oilwti) (lfit maize oilwti) if tin(2000m1,2019m12), nodraw name(scatter0019);

    graph combine scatter8099 scatter0019, name(scatter) cols(2);

    reg maize oilwti if tin(1980m1,1999m12);
        predict e8099, residuals;
        tsline e8099 if tin(1980m1,1999m12), nodraw name(e8099);
        ac e8099 if tin(1980m1,1999m12), nodraw name(e8099ac);
        pac e8099 if tin(1980m1,1999m12), nodraw name(e8099pac);
        graph combine e8099ac e8099pac, nodraw name(e8099acpac) cols(2);
        graph combine e8099 e8099acpac, nodraw name(e8099bj) cols(1);

    reg maize oilwti if tin(2000m1,2019m12);
        predict e0019, residuals;
        tsline e0019 if tin(2000m1,2019m12), nodraw name(e0019);
        ac e0019 if tin(2000m1,2019m12), nodraw name(e0019ac);
        pac e0019 if tin(2000m1,2019m12), nodraw name(e0019pac);
        graph combine e0019ac e0019pac, nodraw name(e0019acpac) cols(2);
        graph combine e0019 e0019acpac, nodraw name(e0019bj) cols(1);

    graph combine e8099bj e0019bj, name(ebj) cols(2) iscale(*.7);

    dfuller e8099, regress noconstant lags(0);
    dfuller e8099, regress noconstant lags(1);
    dfuller e8099, regress noconstant lags(2);

    dfuller e0019, regress noconstant lags(0);
    dfuller e0019, regress noconstant lags(1);
    dfuller e0019, regress noconstant lags(2);

    reg maize oilwti if tin(1980m1,1999m12);
    reg maize oilwti if tin(2000m1,2019m12);
