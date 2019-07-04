** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: indice_de_confianza_consumidor.do
** PROGRAM TASK: SERIES DE TIEMPO
** AUTHOR: RODRIGO TABORDA
** DATE CREATED: 30/05/2019
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
** #10 ** INDICE CONFIANZA CONSUMIDOR / FEDESARROLLO - COLOMBIA;
*********************************************************************;

*********************************************************************;
** #10.2 ** READ, ORGANIZE DATA;
*********************************************************************;

** #10.2.1 ** IMPORT DATA;

        import excel
        http://rodrigotaborda.com/ad/data/fedesarrollo/indice_de_confianza_consumidor_201905.xlsx
        ,
        sheet("Hoja1")
        firstrow
        clear
        ;

** #10.2.2 ** ORGANIZE DATE VARIABLE;

    gen fecha_num = monthly(fecha,"MY",2050);
    format %tm fecha_num;

** #10.2.3 ** DECLARE TIME SERIES FORMAT;

    tsset fecha_num;

** #10.2.4 ** LABEL VARIABLES;

    label var fecha_num "Fecha";
    label var icc "Índice confianza consumidor";
    label var iec "Índice expectativas consumidor";
    label var ice "Índice condiciones económicas";

*************************************************************************;
** #10.3 ** GRAPHS, TIME SERIES, AUTOCORRELATION, PARTIAL AUTOCORRELATION;
*************************************************************************;

    /*TIME SERIES GRAPH*/;
    tsline icc, tlabel(2002m1(48)2019m4) xtitle("") name(icc_ts, replace);

    /*AUTO-CORRELATION FUNCTION GRAPH*/;
    ac icc, name(icc_ac, replace);

    /*PARTIAL AUTO-CORRELATION FUNCTION GRAPH*/;
    pac icc, name(icc_pac, replace);

    /*COMBINE PREVIOUS GRAPHS*/;
    graph combine icc_ac icc_pac, iscale(*0.8) name(icc_ac_pac);
    graph combine icc_ts icc_ac_pac, cols(1)
        title("Índice confianza consumidor")
        subtitle("Análisis univariado")
        ;

    /*GENERATE LAGED VARIABLE*/;
    foreach lag of numlist 1/15{;
        generate icc_`lag' = l`lag'.icc;
        label var icc_`lag' "icc lag(`lag')";
        };

    /*OBTAIN AUTO-CORRELATION*/;
    corr icc icc_1-icc_15;
        /*HERE YOU CAN SEE HOW HEACH CORRELATION TAKES THE VALUE OF THE AUTO-CORRELATION FUNCTION*/

    /*OBTAIN PARTIAL AUTO-CORRELATION*/;
    foreach lag of numlist 1/15{;
        reg icc icc_1-icc_`lag';
        };
        /*HERE YOU CAN SEE HOW HEACH LAST COEFFICIENT TAKES THE VALUE OF THE PARTIAL AUTO-CORRELATION FUNCTION*/

*************************************************************************;
** #10.4 ** GRAPHS, TIME SERIES, AUTOCORRELATION, PARTIAL AUTOCORRELATION;
**       ** ANY VARIABLE SET IN THE LOCAL;
*************************************************************************;

    preserve;
    local var iec /*icc iec ice*/;
    keep fecha fecha_num `var';
    order fecha fecha_num `var';

    /*TIME SERIES GRAPH*/;
    tsline `var', name(`var', replace);

    /*AUTO-CORRELATION FUNCTION GRAPH*/;
    ac `var', name(`var'_ac, replace);

    /*PARTIAL AUTO-CORRELATION FUNCTION GRAPH*/;
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
        /*HERE YOU CAN SEE HOW HEACH LAST COEFFICIENT TAKES THE VALUE OF THE PARTIAL AUTO-CORRELATION FUNCTION*/
    restore;

**** #90.9.9 ** GOOD BYE;
*
*    clear;
