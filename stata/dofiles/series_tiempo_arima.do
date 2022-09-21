** PROJECT: ANALISIS DE DATOS
** PROGRAM: series_tiempo_procesos.do
** PROGRAM TASK: SERIES DE TIEMPO SIMULACION PROCESOS
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
        set obs 1800;

    /*DEFINIR VARIABLE DE TIEMPO*/;
        generate time=_n;
        tsset time;

    /*DEFINIR VALOR ALEATOREO INICIAL*/;
        set seed 12345;

    /*GENERAR PROCESO ALEATORIO*/;
        gen e1 = rnormal(0,5);
            label var e1 "e1 N(0,5)";

    /*DEFINIR VALOR ALEATOREO INICIAL*/;
        set seed 98765;

    /*GENERAR PROCESO ALEATORIO*/;
        gen e2 = rnormal(0,5);
        label var e2 "e2 N(0,5)";

*********************************************************************;
*** #10 ** CAMINATA ALEATOREA ESTACIONARIA;
*********************************************************************;

    local b1 = 0.6 /*COEFICIENTE PENDIENTE. REEMPLAZAR CON VALOR MENOR A 1*/;

    generate y1 = .;
    replace y1 = e1 in 1;
    replace y1 = `b1' * l.y1 + e1 in 2/l;
        label var y1 "y1 = `b1' * l.y1 + e1";

    generate y1a = .;
    replace y1a = e2 in 1;
    replace y1a = `b1' * l.y1a + e2 in 2/l;
        label var y1a "y1a = `b1' * l.y1a + e2";

*** #10.1 ** DF UNIT ROOT TEST;
    dfuller y1, regress noconstant;
    dfuller y1, regress noconstant lag(1);
        reg d.y1 l.y1 l.d.y1, noconstant;
    dfgls y1;
    pperron y1;

*** #10.2 ** DF UNIT ROOT TEST;
    dfuller y1a, regress noconstant;
    dfuller y1a, regress noconstant lag(1);
        reg d.y1a l.y1a l.d.y1a, noconstant;
    dfgls y1;
    pperron y1;

*********************************************************************;
*** #20 ** CAMINATA ALEATOREA NO ESTACIONARIA;
*********************************************************************;

    local b1a = 1 /*COEFICIENTE PENDIENTE. REEMPLAZAR CON VALOR IGUAL A 1 (O MUY CERCANO)*/;

    generate y2 = .;
    replace y2 = e1 in 1;
    replace y2 = `b1a' * l.y2 + e1 in 2/l;
        label var y2 "y2 = `b1a' * l.y2 + e1";

    generate y2a = .;
    replace y2a = e2 in 1;
    replace y2a = `b1a' * l.y2a + e2 in 2/l;
        label var y2a "y2a = `b1a' * l.y2a + e2";

*** #20.1 ** DF UNIT ROOT TEST;
    dfuller y2, regress noconstant;
    dfuller y2, regress noconstant lag(1);
        reg d.y2 l.y2 l.d.y2, noconstant;

*** #20.2 ** DF UNIT ROOT TEST;
    dfuller y2a, regress noconstant;
    dfuller y2a, regress noconstant lag(1);
        reg d.y2a l.y2a l.d.y2a, noconstant;

*********************************************************************;
*** #29 ** GRAFICAS;
*********************************************************************;

    tsline y1*, name(y1_tsline, replace);
    tsline y2*, name(y2_tsline, replace);

    graph twoway (scatter y1 y1a) (lfit y1 y1a), ytitle(y1) xtitle(y1a) title(y1 y1a) legend(cols(1)) name(y1_scatter, replace);
    graph twoway (scatter y2 y2a) (lfit y2 y2a), ytitle(y2) xtitle(y2a) title(y2 y2a) legend(cols(1)) name(y2_scatter, replace);

    graph combine y1_tsline y1_scatter, title(y1 y1a) cols(1) name(y1, replace);
    graph combine y2_tsline y2_scatter, title(y2 y2a) cols(1) name(y2, replace);

    graph combine y1 y2, cols(2) name(y1y2, replace);

    graph close y*_tsline y*_scatter;

*********************************************************************;
*** #30 ** CAMINATA ALEATOREA ESTACIONARIA + CONSTANTE;
*********************************************************************;

    local b0 = 0.5 /*COEFICIENTE CONSTANTE.*/;
    local b1b = .6 /*COEFICIENTE PENDIENTE. REEMPLAZAR CON VALOR MENOR A 1*/;

    generate y3 = .;
    replace y3 = e1 in 1;
    replace y3 = `b0' + `b1b' * l.y3 + e1 in 2/l;
        label var y3 "y3 = `b0' + `b1b' * l.y3 + e1";

    generate y3a = .;
    replace y3a = e2 in 1;
    replace y3a = `b0' + `b1b' * l.y3a + e2 in 2/l;
        label var y3a "y3a = `b0' + `b1b' * l.y3a + e2";

*********************************************************************;
*** #40 ** CAMINATA ALEATOREA NO ESTACIONARIA + CONSTANTE;
*********************************************************************;

    local b0a = 0.5 /*COEFICIENTE CONSTANTE.*/;
    local b1c = 1 /*COEFICIENTE PENDIENTE. REEMPLAZAR CON VALOR IGUAL A 1 (O MUY CERCANO)*/;

    generate y4 = .;
    replace y4 = e1 in 1;
    replace y4 = `b0a' + `b1c' * l.y4 + e1 in 2/l;
        label var y4 "y4 = `b0a' + `b1c' * l.y4 + e1";

    generate y4a = .;
    replace y4a = e2 in 1;
    replace y4a = `b0a' + `b1c' * l.y4a + e2 in 2/l;
        label var y4a "y4a = `b0a' + `b1c' * l.y4a + e2";

    *********************************************************************;
    *** #49 ** GRAFICAS;
    *********************************************************************;

        tsline y3* y4*, name(y3y4_tsline, replace) xsize(10);
        graph twoway (scatter y3 y3a) (lfit y3 y3a), ytitle(y3) xtitle(y3a) title(y3 y3a) legend(cols(1)) name(y3_scatter, replace);
        graph twoway (scatter y4 y4a) (lfit y4 y4a), ytitle(y4) xtitle(y4a) title(y4 y4a) legend(cols(1)) name(y4_scatter, replace);
            graph combine y3_scatter y4_scatter, name(y3y4_scatter, replace) rows(1);
            graph combine y3y4_tsline y3y4_scatter, title(y3 y3a / y4 y4a) cols(1) ysize(6) iscale(*.7) name(y3y4, replace);
                graph close y3y4_tsline y3_scatter y4_scatter y3y4_scatter;

*********************************************************************;
*** #50 ** CAMINATA ALEATOREA ESTACIONARIA + CONSTANTE + TENDENCIA;
*********************************************************************;

    local b0b = 0.5 /*COEFICIENTE CONSTANTE.*/;
    local b1c = .6 /*COEFICIENTE PENDIENTE. REEMPLAZAR CON VALOR MENOR A 1*/;
    local b2a = .1 /*COEFICIENTE TENDENCIA*/;

    generate y5 = .;
    replace y5 = e1 in 1;
    replace y5 = `b0b' + `b1c' * l.y5 + `b2a' * time + e1 in 2/l;
        label var y5 "y5 = `b0b' + `b1c' * l.y5 + `b2a' * tiempo + e1";

    generate y5a = .;
    replace y5a = e2 in 1;
    replace y5a = `b0b' + `b1c' * l.y5a + `b2a' * time + e2 in 2/l;
        label var y5a "y5a = `b0b' + `b1c' * l.y5a + `b2a' * tiempo + e2";

*********************************************************************;
*** #60 ** CAMINATA ALEATOREA NO ESTACIONARIA + CONSTANTE + TENDENCIA;
*********************************************************************;

    local b0c = 0.5 /*COEFICIENTE CONSTANTE.*/;
    local b1d = 1 /*COEFICIENTE PENDIENTE. REEMPLAZAR CON VALOR IGUAL A 1 (O MUY CERCANO)*/;
    local b2b = .1 /*COEFICIENTE TENDENCIA*/;

    generate y6 = .;
    replace y6 = e1 in 1;
    replace y6 = `b0c' + `b1d' * l.y6 + `b2b' * time + e1 in 2/l;
        label var y6 "y6 = `b0c' + `b1d' * l.y6 + `b2b' * tiempo + e1";

    generate y6a = .;
    replace y6a = e2 in 1;
    replace y6a = `b0c' + `b1d' * l.y6a + `b2b' * time + e2 in 2/l;
        label var y6a "y6a = `b0c' + `b1d' * l.y6a + `b2b' * tiempo + e2";

    *********************************************************************;
    *** #59 ** GRAFICAS;
    *********************************************************************;

        tsline y5* y6*, name(y5y6_tsline, replace) xsize(10);
        graph twoway (scatter y5 y5a) (lfit y5 y5a), ytitle(y5) xtitle(y5a) title(y5 y5a) legend(cols(1)) name(y5_scatter, replace);
        graph twoway (scatter y6 y6a) (lfit y6 y6a), ytitle(y6) xtitle(y6a) title(y6 y6a) legend(cols(1)) name(y6_scatter, replace);
            graph combine y5_scatter y6_scatter, name(y5y6_scatter, replace) rows(1);
            graph combine y5y6_tsline y5y6_scatter, title(y5 y5a / y6 y6a) cols(1) ysize(6) iscale(*.7) name(y5y6, replace);
                graph close y5y6_tsline y5_scatter y6_scatter y5y6_scatter;

**** #90.9.9 ** GOOD BYE;
*
*    clear;
