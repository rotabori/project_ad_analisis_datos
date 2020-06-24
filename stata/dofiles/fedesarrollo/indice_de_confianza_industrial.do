** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: indice_de_confianza_industrial.do
** PROGRAM TASK: SERIES DE TIEMPO
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 30/05/2019
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
*** #10 ** INDICE CONFIANZA CONSUMIDOR / FEDESARROLLO;
*********************************************************************;
*
*********************************************************************;
*** #10.2 ** READ, ORGANIZE DATA;
*********************************************************************;
*
**** #10.2.1 ** IMPORT DATA;

        import excel
        http://rodrigotaborda.com/ad/data/fedesarrollo/indice_de_confianza_industrial_201905.xlsx
        ,
        sheet("Hoja1")
        firstrow
        clear
        ;

*** #10.2.2 ** ORGANIZE DATE VARIABLE;

    gen fecha_num = monthly(fecha,"MY",2050);
    format %tm fecha_num;

*** #10.2.3 ** DECLARE TIME SERIES FORMAT;

    tsset fecha_num;

*** #10.2.4 ** LABEL VARIABLES;

    label var fecha_num "Fecha";
    label var ici "Índice confianza industrial";
    label var vol_ped "Volumen actual pedidos";
    label var existencias "Nivel de existencias";
    label var exp_prod_trim "Expectativas producción trimestre";

*********************************************************************;
*** #10.3 ** GRAPHS, TIME SERIES, AUTOCORRELATION, PARTIAL AUTOCORRELATION;
*********************************************************************;

    /*GRAPHS*/;
    tsline ici, name(ici, replace);
    ac ici, name(ici_ac, replace);
    pac ici, name(ici_pac, replace);
    pause;

    /*GENERATE LAGED VARIABLE*/;
    foreach lag of numlist 1/15{;
        generate ici_`lag' = l`lag'.ici;
        label var ici_`lag' "ici lag(`lag')";
        };

    /*OBTAIN AUTO-CORRELATION*/;
    corr ici ici_1-ici_15;
        /*HERE YOU CAN SEE HOW HEACH CORRELATION TAKES THE VALUE OF THE AUTO-CORRELATION FUNCTION*/

    /*OBTAIN PARTIAL AUTO-CORRELATION*/;
    foreach lag of numlist 1/15{;
        reg ici ici_1-ici_`lag';
        };
        /*HERE YOU CAN SEE HOW HEACH COEFFICIENT TAKES THE VALUE OF THE PARTIAL AUTO-CORRELATION FUNCTION*/
    pause;

*********************************************************************;
*** #10.4 ** GRAPHS, TIME SERIES, AUTOCORRELATION, PARTIAL AUTOCORRELATION;
***       ** ANY VARIABLE SET IN THE LOCAL;
*********************************************************************;

    preserve;
    local var ici /*ici vol_ped existencias exp_prod_trim*/;
    keep fecha fecha_num `var';
    order fecha fecha_num `var';

    /*GRAPHS*/;
    tsline `var', name(`var', replace);
    ac `var', name(`var'_ac, replace);
    pac `var', name(`var'_pac, replace);

    /*GENERATE LAGED VARIABLE*/;
    foreach lag of numlist 1/15{;
        generate `var'_`lag' = l`lag'.`var';
        label var `var'_`lag' "`var' lag(`lag')";
        };

    /*OBTAIN AUTO-CORRELATION*/;
    corr `var' `var'_1-`var'_15;
        /*HERE YOU CAN SEE HOW HEACH CORRELATION TAKES THE VALUE OF THE AUTO-CORRELATION FUNCTION*/

    /*OBTAIN PARTIAL AUTO-CORRELATION*/;
    foreach lag of numlist 1/15{;
        reg `var' `var'_1-`var'_`lag';
        };
        /*HERE YOU CAN SEE HOW HEACH COEFFICIENT TAKES THE VALUE OF THE PARTIAL AUTO-CORRELATION FUNCTION*/
    restore;

**** #90.9.9 ** GOOD BYE;
*
*    clear;
