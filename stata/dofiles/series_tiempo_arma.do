** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: series_tiempo_arma.do
** PROGRAM TASK: SERIES DE TIEMPO SIMULACION ARMA / IDENTIFICACION BOX-JENKINS
** AUTHOR: RODRIGO TABORDA
** DATE CREATED: 26/10/2018
** DATE REVISION 1:
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

    /*DEFINIR VALOR ALEATOREO INICIAL*/;
    set seed 987654321;
    /*GENERAR PROCESO ALEATORIO*/;
    gen e2 = rnormal(0,1);
        label var e2 "e2 (0,1)";

*********************************************************************;
*** #10 ** MODELO ARMA(1,0);
*********************************************************************;

    local y1b = 0.8;
    generate y1 = .;
    replace y1 = e1 in 1;
    replace y1 = `y1b' * l.y1 + e1 in 2/l;
        label var y1 "y1 = `y1b' * l.y1 + e";

*** #10.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y1, name(y1);
    ac y1, name(y1ac);
    pac y1, name(y1pac);

    graph combine y1ac y1pac, rows(1) name(y1acpac) xsize(10);
    graph combine y1 y1acpac, cols(1) name(y1y1acpac) title(AR(1)) subtitle(y1 = `y1b' * l.y1 + e);

    graph close _all;
    graph display y1y1acpac;

*********************************************************************;
*** #20 ** MODELO ARMA(1,0) + CONSTANT;
*********************************************************************;

    local y2a = 1.9;
    local y2b = 0.8;
    generate y2 = .;
    replace y2 = e1 in 1;
    replace y2 = `y2a' + `y2b' * l.y2 + e1 in 2/l;
        label var y2 "y2 = `y2a' + `y2b' * l.y2 + e";

*** #20.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y2, name(y2);
    ac y2, name(y2ac);
    pac y2, name(y2pac);

    graph combine y2ac y2pac, rows(1) name(y2acpac) xsize(10);
    graph combine y2 y2acpac, cols(1) name(y2y2acpac) title(AR(1) + constante) subtitle(y2 = `y2a' + `y2b' * l.y2 + e);

    graph close _all;
    graph display y2y2acpac;

*********************************************************************;
*** #30 ** MODELO ARMA(0,1);
*********************************************************************;

    local y3b = 0.8;
    generate y3 = .;
    replace y3 = e1 in 1;
    replace y3 = e1 + `y3b' * l.e1 in 2/l;
        label var y3 "y3 = e + `y3b' * l.e1";

*** #30.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y3, name(y3);
    ac y3, name(y3ac);
    pac y3, name(y3pac);

    graph combine y3ac y3pac, rows(1) name(y3acpac) xsize(10);
    graph combine y3 y3acpac, cols(1) name(y3y3acpac) title(MA(1)) subtitle(y3 = e + `y3b' * l.e1);

    graph close _all;
    graph display y3y3acpac;

*********************************************************************;
*** #40 ** MODELO ARMA(2,0);
*********************************************************************;

    local y4b = 0.5;
    local y4bb = 0.3;
    generate y4 = .;
    replace y4 = e1 in 1;
    replace y4 = e1 in 2;
    replace y4 = `y4b' * l.y4 + `y4bb' * l2.y4 + e1 in 3/l;
        label var y4 "y4 = `y4b' * l.y4 + `y4bb' * l2.y4 + e";

*** #40.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y4, name(y4);
    ac y4, name(y4ac);
    pac y4, name(y4pac);

    graph combine y4ac y4pac, rows(1) name(y4acpac) xsize(10);
    graph combine y4 y4acpac, cols(1) name(y4y4acpac) title(AR(2)) subtitle(y4 = `y4b' * l.y4 + `y4bb' * l2.y4 + e);

    graph close _all;
    graph display y4y4acpac;

*********************************************************************;
*** #50 ** MODELO ARMA(2,0) + CONSTANT;
*********************************************************************;

    local y5a = 1.9;
    local y5b = 0.5;
    local y5bb = 0.3;
    generate y5 = .;
    replace y5 = e1 in 1;
    replace y5 = e1 in 2;
    replace y5 = `y5a' + `y5b' * l.y5 + `y5bb' * l2.y5 + e1 in 3/l;
        label var y5 "y5 = `y5a' + `y5b' * l.y5 + `y5bb' * l2.y5 + e";

*** #50.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y5, name(y5);
    ac y5, name(y5ac);
    pac y5, name(y5pac);

    graph combine y5ac y5pac, rows(1) name(y5acpac) xsize(10);
    graph combine y5 y5acpac, cols(1) name(y5y5acpac) title(AR(2)) subtitle(y5 = `y5a' + `y5b' * l.y5 + `y5bb' * l2.y5 + e);

    graph close _all;
    graph display y5y5acpac;

*********************************************************************;
*** #60 ** MODELO ARMA(0,2);
*********************************************************************;

    local y6b = 1.2;
    local y6bb = 0.7;
    generate y6 = .;
    replace y6 = e1 in 1;
    replace y6 = e1 in 2;
    replace y6 = e1 + `y6b' * l.e1 + `y6bb' * l2.e1 in 2/l;
        label var y6 "y6 = e + `y6b' * l.e1 + `y6bb' * l2.e1";

*** #60.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y6, name(y6);
    ac y6, name(y6ac);
    pac y6, name(y6pac);

    graph combine y6ac y6pac, rows(1) name(y6acpac) xsize(10);
    graph combine y6 y6acpac, cols(1) name(y6y6acpac) title(MA(2)) subtitle(y6 = e + `y6b' * l.e1 + `y6bb' * l2.e1);

    graph close _all;
    graph display y6y6acpac;

********************************************************************;
** #70 ** MODELO ARMA(2,2);
********************************************************************;

    local y7b = 0.5;
    local y7bb = 0.3;
    local y7c = 1.5;
    local y7cc = 0.9;
    generate y7 = .;
    replace y7 = e1 in 1;
    replace y7 = e1 in 2;
    replace y7 = `y7b' * l.y7 + `y7bb' * l2.y7 + e1 + `y7c' * l.e1 + `y7cc' * l2.e1 in 3/l;
        label var y7 "y7 = `y7b' * l.y7 + `y7bb' * l2.y7 + e + `y7c' * l.e1 + `y7cc' * l2.e1";

*** #70.1 ** AUTOCORRELACION / AUTOCORRELACION PARCIAL;
    tsline y7, name(y7);
    ac y7, name(y7ac);
    pac y7, name(y7pac);

    graph combine y7ac y7pac, rows(1) name(y7acpac) xsize(10);
    graph combine y7 y7acpac, cols(1) name(y7y7acpac) title(ARMA(2,2)) subtitle(y7 = `y7b' * l.y7 + `y7bb' * l2.y7 + e + `y7c' * l.e1 + `y7cc' * l2.e1);

    graph close _all;
    graph display y7y7acpac;

    graph display y1y1acpac;
    graph display y2y2acpac;
    graph display y3y3acpac;
    graph display y4y4acpac;
    graph display y5y5acpac;
    graph display y6y6acpac;


**** #90.9.9 ** GOOD BYE;
*
*    clear;
