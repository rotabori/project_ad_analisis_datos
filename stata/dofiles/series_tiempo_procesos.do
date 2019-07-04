** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: series_tiempo_procesos.do
** PROGRAM TASK: SERIES DE TIEMPO SIMULACION PROCESOS
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
        label var e2 "e1 (0,1)";

*********************************************************************;
*** #10 ** CAMINATA ALEATOREA ESTACIONARIA;
*********************************************************************;

    local b1 = 0.3 /*COEFICIENTE PENDIENTE. REEMPLAZAR CON VALOR MENOR A 1*/;
    generate y1 = .;
    replace y1 = e1 in 1;
    replace y1 = `b1' * l.y1 + e1 in 2/l;
        label var y1 "y1 = `b1' * l.y1 + e";

*** #10.1 ** DF UNIT ROOT TEST;
    dfuller y1, regress noconstant;
    dfuller y1, regress noconstant lag(1);
        reg d.y1 l.y1 l.d.y1;

*********************************************************************;
*** #20 ** CAMINATA ALEATOREA NO ESTACIONARIA;
*********************************************************************;

    local b1a = 1 /*COEFICIENTE PENDIENTE. REEMPLAZAR CON VALOR IGUAL A 1 (O MUY CERCANO)*/;
    generate y2 = .;
    replace y2 = e1 in 1;
    replace y2 = `b1a' * l.y2 + e1 in 2/l;
        label var y2 "y2 = `b1a' * l.y2 + e";

*********************************************************************;
*** #30 ** CAMINATA ALEATOREA ESTACIONARIA + CONSTANTE;
*********************************************************************;

    local b0 = 0.5 /*COEFICIENTE CONSTANTE.*/;
    local b1b = .6 /*COEFICIENTE PENDIENTE. REEMPLAZAR CON VALOR MENOR A 1*/;
    generate y3 = .;
    replace y3 = e1 in 1;
    replace y3 = `b0' + `b1b' * l.y3 + e1 in 2/l;
        label var y3 "y3 = `b0' + `b1b' * l.y3 + e";

*********************************************************************;
*** #40 ** CAMINATA ALEATOREA NO ESTACIONARIA + CONSTANTE;
*********************************************************************;

    local b0a = 0.5 /*COEFICIENTE CONSTANTE.*/;
    local b1c = 1 /*COEFICIENTE PENDIENTE. REEMPLAZAR CON VALOR IGUAL A 1 (O MUY CERCANO)*/;
    generate y4 = .;
    replace y4 = e1 in 1;
    replace y4 = `b0a' + `b1c' * l.y4 + e1 in 2/l;
        label var y4 "y4 = `b0a' + `b1c' * l.y4 + e";

*********************************************************************;
*** #50 ** CAMINATA ALEATOREA ESTACIONARIA + CONSTANTE + TENDENCIA;
*********************************************************************;

    local b0b = 0.5 /*COEFICIENTE CONSTANTE.*/;
    local b1c = .6 /*COEFICIENTE PENDIENTE. REEMPLAZAR CON VALOR MENOR A 1*/;
    generate y5 = .;
    replace y5 = e1 in 1;
    replace y5 = `b0b' + `b1c' * l.y5 + time + e1 in 2/l;
        label var y5 "y5 = `b0b' + `b1c' * l.y5 + tiempo + e";

*********************************************************************;
*** #60 ** CAMINATA ALEATOREA NO ESTACIONARIA + CONSTANTE + TENDENCIA;
*********************************************************************;

    local b0c = 0.5 /*COEFICIENTE CONSTANTE.*/;
    local b1d = 1 /*COEFICIENTE PENDIENTE. REEMPLAZAR CON VALOR IGUAL A 1 (O MUY CERCANO)*/;
    generate y6 = .;
    replace y6 = e1 in 1;
    replace y6 = `b0c' + `b1d' * l.y6 + time + e1 in 2/l;
        label var y6 "y6 = `b0a' + `b1d' * l.y6 + tiempo + e";

**** #90.9.9 ** GOOD BYE;
*
*    clear;
