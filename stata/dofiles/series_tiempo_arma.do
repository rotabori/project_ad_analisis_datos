** PROJECT: ANALISIS DE DATOS
** PROGRAM: series_tiempo_arma.do
** PROGRAM TASK: SERIES DE TIEMPO SIMULACION ARMA / IDENTIFICACION BOX-JENKINS
** AUTHOR: RODRIGO TABORDA
** DATE CREATED: 2018/10/26
** DATE REVISION 1: 2020/04/07
** DATE REVISION #:

********************************************************************;
** #0
********************************************************************;

** PROGRAM SETUP

    pause on
    #delimit ;

** #0.1 ** SET PATH FOR READING/SAVING DATA;

*    cd ../../;

*********************************************************************;
*** #00 ** PRELIMINAR;
*********************************************************************;

    graph drop _all;
    clear;

    /*DEFINIR NUMERO DE OBSERVACIONES*/;
    set obs 180;

    /*DEFINIR VARIABLE DE TIEMPO*/;
    generate time=_n;
    tsset time;

    /*DEFINIR VALOR ALEATOREO INICIAL*/;
    set seed 123456789;

    /*GENERAR PROCESO ALEATORIO*/;
    gen e1 = rnormal(0,1);
        label var e1 "e (0,1)";

*********************************************************************;
*** #10 ** MODELO AR(1);
*********************************************************************;

    local y1b = 0.8;
    generate y1 = .;
    replace y1 = e1 in 1;
    replace y1 = `y1b' * l.y1 + e1 in 2/l;
        label var y1 "AR(1) (y1 = `y1b' * l.y1 + e1)";

*** #10.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y1, ytitle("") name(y1);
    ac y1, title(AC) name(y1ac);
        corr l1.y1 l2.y1 l3.y1 l4.y1 l5.y1;
    pac y1, title(PAC) name(y1pac);
        reg y1 l1.y1;
        reg y1 l1.y1 l2.y1;
        reg y1 l1.y1 l2.y1 l3.y1;
        reg y1 l1.y1 l2.y1 l3.y1 l4.y1;
        reg y1 l1.y1 l2.y1 l3.y1 l4.y1 l5.y1;

    graph combine y1ac y1pac, rows(1) name(y1acpac);
    graph combine y1 y1acpac, cols(1) name(y1y1acpac) title(AR(1)) subtitle(y1 = `y1b' * l.y1 + e1);

    graph close _all;
    graph display y1y1acpac;

*** #10.2 ** ESTIMACIÓN;

    arima y1, arima(2,0,1);
        estat ic;
    arima y1, arima(2,0,0);
        estat ic;
    arima y1, arima(1,0,0);
        estat ic;
    arima y1, arima(0,0,1);
        estat ic;

*********************************************************************;
*** #20 ** MODELO AR(1) + CONSTANTE;
*********************************************************************;

    local y2a = 1.9;
    local y2b = 0.8;
    generate y2 = .;
    replace y2 = e1 in 1;
    replace y2 = `y2a' + `y2b' * l.y2 + e1 in 2/l;
        label var y2 "AR(1) + constante (y2 = `y2a' + `y2b' * l.y2 + e1)";

*** #20.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y2, ytitle("") name(y2);
    ac y2, title(AC) name(y2ac);
        corr l1.y2 l2.y2 l3.y2 l4.y2 l5.y2;
    pac y2, title(PAC) name(y2pac);
        reg y2 l1.y2;
        reg y2 l1.y2 l2.y2;
        reg y2 l1.y2 l2.y2 l3.y2;
        reg y2 l1.y2 l2.y2 l3.y2 l4.y2;
        reg y2 l1.y2 l2.y2 l3.y2 l4.y2 l5.y2;

    graph combine y2ac y2pac, rows(1) name(y2acpac);
    graph combine y2 y2acpac, cols(1) name(y2y2acpac) title(AR(1) + constante) subtitle(y2 = `y2a' + `y2b' * l.y2 + e1);

    graph close _all;
    graph display y2y2acpac;

*** #20.2 ** ESTIMACIÓN;

    arima y2, arima(2,0,1);
        estat ic;
    arima y2, arima(2,0,0);
        estat ic;
    arima y2, arima(1,0,0);
        estat ic;
    arima y2, arima(0,0,1);
        estat ic;

*********************************************************************;
*** #30 ** MODELO MA(1);
*********************************************************************;

    local y3b = 0.8;
    generate y3 = .;
    replace y3 = e1 in 1;
    replace y3 = e1 + `y3b' * l.e1 in 2/l;
        label var y3 "MA(1) (y3 = e1 + `y3b' * l.e1)";

*** #30.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y3, ytitle("") name(y3);
    ac y3, title(AC) name(y3ac);
        corr l1.y3 l2.y3 l3.y3 l4.y3 l5.y3;
    pac y3, title(PAC) name(y3pac);
        reg y3 l1.y3;
        reg y3 l1.y3 l2.y3;
        reg y3 l1.y3 l2.y3 l3.y3;
        reg y3 l1.y3 l2.y3 l3.y3 l4.y3;
        reg y3 l1.y3 l2.y3 l3.y3 l4.y3 l5.y3;

    graph combine y3ac y3pac, rows(1) name(y3acpac);
    graph combine y3 y3acpac, cols(1) name(y3y3acpac) title(MA(1)) subtitle(y3 = e1 + `y3b' * l.e1);

    graph close _all;
    graph display y3y3acpac;

*** #30.2 ** ESTIMACIÓN;

    arima y3, arima(2,0,2);
        estat ic;
    arima y3, arima(1,0,2);
        estat ic;
    arima y3, arima(0,0,2);
        estat ic;
    arima y3, arima(0,0,1);
        estat ic;
    arima y3, arima(0,0,0);
        estat ic;

*********************************************************************;
*** #40 ** MODELO ARMA(1,1);
*********************************************************************;

    local y4b = 0.8;
    generate y4 = .;
    replace y4 = e1 in 1;
    replace y4 = `y4b' * l.y4 + e1 + `y4b' * l.e1 in 2/l;
        label var y4 "ARMA(1,1) (y4 = `y4b' * l.y4 + e1 + `y4b' * l.e1)";

*** #40.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y4, ytitle("") name(y4);
    ac y4, title(AC)  name(y4ac);
        corr l1.y4 l2.y4 l3.y4 l4.y4 l5.y4;
    pac y4, title(PAC) name(y4pac);
        reg y4 l1.y4;
        reg y4 l1.y4 l2.y4;
        reg y4 l1.y4 l2.y4 l3.y4;
        reg y4 l1.y4 l2.y4 l3.y4 l4.y4;
        reg y4 l1.y4 l2.y4 l3.y4 l4.y4 l5.y4;

    graph combine y4ac y4pac, rows(1) name(y4acpac);
    graph combine y4 y4acpac, cols(1) name(y4y4acpac) title(ARMA(1,1)) subtitle(y4 = `y4b' * l.y4 + e1 + `y4b' * l.e1);

    graph close _all;
    graph display y4y4acpac;

*** #40.2 ** ESTIMACIÓN;

    arima y4, arima(2,0,1);
        estat ic;
    arima y4, arima(1,0,1);
        estat ic;
    arima y4, arima(1,0,0);
        estat ic;
    arima y4, arima(0,0,1);
        estat ic;

*********************************************************************;
*** #50 ** MODELO AR(2);
*********************************************************************;

    local y5b = 0.5;
    local y5bb = 0.3;
    generate y5 = .;
    replace y5 = e1 in 1;
    replace y5 = e1 in 2;
    replace y5 = `y5b' * l.y5 + `y5bb' * l2.y5 + e1 in 3/l;
        label var y5 "AR(2) (y5 = `y5b' * l.y5 + `y5bb' * l2.y5 + e)";

*** #50.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y5, ytitle("") name(y5);
    ac y5, title(AC) name(y5ac);
        corr l1.y5 l2.y5 l3.y5 l4.y5 l5.y5;
    pac y5, title(PAC) name(y5pac);
        reg y5 l1.y5;
        reg y5 l1.y5 l2.y5;
        reg y5 l1.y5 l2.y5 l3.y5;
        reg y5 l1.y5 l2.y5 l3.y5 l4.y5;
        reg y5 l1.y5 l2.y5 l3.y5 l4.y5 l5.y5;

    graph combine y5ac y5pac, rows(1) name(y5acpac) xsize(10);
    graph combine y5 y5acpac, cols(1) name(y5y5acpac) title(AR(2)) subtitle(y5 = `y5b' * l.y5 + `y5bb' * l2.y5 + e);

    graph close _all;
    graph display y5y5acpac;

*** #50.2 ** ESTIMACIÓN;

    arima y5, arima(2,0,2);
        estat ic;
    arima y5, arima(2,0,1);
        estat ic;
    arima y5, arima(1,0,1);
        estat ic;
    arima y5, arima(2,0,0);
        estat ic;
    arima y5, arima(1,0,0);
        estat ic;

*********************************************************************;
*** #60 ** MODELO AR(2) + CONSTANT;
*********************************************************************;

    local y6a = 1.9;
    local y6b = 0.5;
    local y6bb = 0.3;
    generate y6 = .;
    replace y6 = e1 in 1;
    replace y6 = e1 in 2;
    replace y6 = `y6a' + `y6b' * l.y6 + `y6bb' * l2.y6 + e1 in 3/l;
        label var y6 "AR(2) + constante (y6 = `y6a' + `y6b' * l.y6 + `y6bb' * l2.y6 + e)";

*** #60.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y6, ytitle("") name(y6);
    ac y6, title(AC) name(y6ac);
        corr l1.y6 l2.y6 l3.y6 l4.y6 l5.y6;
    pac y6, title(PAC) name(y6pac);
        reg y6 l1.y6;
        reg y6 l1.y6 l2.y6;
        reg y6 l1.y6 l2.y6 l3.y6;
        reg y6 l1.y6 l2.y6 l3.y6 l4.y6;
        reg y6 l1.y6 l2.y6 l3.y6 l4.y6 l5.y6;

    graph combine y6ac y6pac, rows(1) name(y6acpac) xsize(10);
    graph combine y6 y6acpac, cols(1) name(y6y6acpac) title(AR(2) + constante) subtitle(y6 = `y6a' + `y6b' * l.y6 + `y6bb' * l2.y6 + e);

    graph close _all;
    graph display y6y6acpac;

*** #60.2 ** ESTIMACIÓN;

    arima y6, arima(2,0,2);
        estat ic;
    arima y6, arima(2,0,1);
        estat ic;
    arima y6, arima(1,0,1);
        estat ic;
    arima y6, arima(2,0,0);
        estat ic;
    arima y6, arima(1,0,0);
        estat ic;

*********************************************************************;
*** #70 ** MODELO MA(2);
*********************************************************************;

    local y7b = 1.2;
    local y7bb = 0.7;
    generate y7 = .;
    replace y7 = e1 in 1;
    replace y7 = e1 in 2;
    replace y7 = e1 + `y7b' * l.e1 + `y7bb' * l2.e1 in 2/l;
        label var y7 "MA(2) (y7 = e + `y7b' * l.e1 + `y7bb' * l2.e1)";

*** #70.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y7, ytitle("") name(y7);
    ac y7, title(AC) name(y7ac);
        corr l1.y7 l2.y7 l3.y7 l4.y7 l5.y7;
    pac y7, title(PAC) name(y7pac);
        reg y7 l1.y7;
        reg y7 l1.y7 l2.y7;
        reg y7 l1.y7 l2.y7 l3.y7;
        reg y7 l1.y7 l2.y7 l3.y7 l4.y7;
        reg y7 l1.y7 l2.y7 l3.y7 l4.y7 l5.y7;

    graph combine y7ac y7pac, rows(1) name(y7acpac) xsize(10);
    graph combine y7 y7acpac, cols(1) name(y7y7acpac) title(MA(2)) subtitle(y7 = e + `y7b' * l.e1 + `y7bb' * l2.e1);

    graph close _all;
    graph display y7y7acpac;

*** #70.2 ** ESTIMACIÓN;

    arima y7, arima(3,0,3);
        estat ic;
    arima y7, arima(2,0,2);
        estat ic;
    arima y7, arima(1,0,2);
        estat ic;
    arima y7, arima(0,0,2);
        estat ic;
    arima y7, arima(0,0,1);
        estat ic;

********************************************************************;
** #80 ** MODELO ARMA(2,2);
********************************************************************;

    local y8b = 0.5;
    local y8bb = 0.3;
    local y8c = 1.5;
    local y8cc = 0.9;
    generate y8 = .;
    replace y8 = e1 in 1;
    replace y8 = e1 in 2;
    replace y8 = `y8b' * l.y8 + `y8bb' * l2.y8 + e1 + `y8c' * l.e1 + `y8cc' * l2.e1 in 3/l;
        label var y8 "ARMA(2,2) (y8 = `y8b' * l.y8 + `y8bb' * l2.y8 + e + `y8c' * l.e1 + `y8cc' * l2.e1)";

*** #80.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y8, ytitle("") name(y8);
    ac y8, title(AC) name(y8ac);
        corr l1.y8 l2.y8 l3.y8 l4.y8 l5.y8;
    pac y8, title(PAC) name(y8pac);
        reg y8 l1.y8;
        reg y8 l1.y8 l2.y8;
        reg y8 l1.y8 l2.y8 l3.y8;
        reg y8 l1.y8 l2.y8 l3.y8 l4.y8;
        reg y8 l1.y8 l2.y8 l3.y8 l4.y8 l5.y8;

    graph combine y8ac y8pac, rows(1) name(y8acpac) xsize(10);
    graph combine y8 y8acpac, cols(1) name(y8y8acpac) title(ARMA(2,2)) subtitle(y8 = `y8b' * l.y8 + `y8bb' * l2.y8 + e + `y8c' * l.e1 + `y8cc' * l2.e1);

    graph close _all;
    graph display y8y8acpac;

*** #80.2 ** ESTIMACIÓN;

    arima y8, arima(3,0,3);
        estat ic;
    arima y8, arima(3,0,2);
        estat ic;
    arima y8, arima(2,0,2);
        estat ic;
    arima y8, arima(2,0,1);
        estat ic;
    arima y8, arima(1,0,2);
        estat ic;

********************************************************************;
** #80 ** DISPLAY ALL GRAPHS;
********************************************************************;

    graph display y1y1acpac;
    graph display y2y2acpac;
    graph display y3y3acpac;
    graph display y4y4acpac;
    graph display y5y5acpac;
    graph display y6y6acpac;
    graph display y7y7acpac;
    graph display y8y8acpac;

**** #90.9.9 ** GOOD BYE;
*
*    clear;
