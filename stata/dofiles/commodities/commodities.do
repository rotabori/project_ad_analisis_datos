** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: commodities.do
** PROGRAM TASK: SERIES DE TIEMPO
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 02/02/2017
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
*** #10 ** IMF - COMMODITIES;
*********************************************************************;
*
*********************************************************************;
*** #10.2 ** READ, ORGANIZE DATA;
*********************************************************************;
*
**** #10.2.1 ** IMPORT DATA;

    import delimited
        http://rodrigotaborda.com/ad/data/commodities/commodities_20190426.csv
        ,
        delimiter(";")
        clear
        ;

*** #10.2.2 ** ORGANIZE DATE VARIABLE;

    generate date_num = monthly(date,"YM");
    format %tm date_num;

*** #10.2.3 ** DECLARE TIME SERIES FORMAT;

    tsset date_num;
sss
*********************************************************************;
*** #10.3 ** GRAPHS, TIME SERIES, AUTOCORRELATION, PARTIAL AUTOCORRELATION;
***       ** BEVERAGE PRICE INDEX;
*********************************************************************;

    preserve;
    keep date date_num pbeve;
    order date date_num pbeve;

    /*GRAPHS*/;
    tsline pbeve, name(pbeve, replace);
    ac pbeve, name(pbeve_ac, replace);
    pac pbeve, name(pbeve_pac, replace);

    /*GENERATE LAGED VARIABLE*/;
    foreach lag of numlist 1/15{;
        generate pbeve_`lag' = l`lag'.pbeve;
        label var pbeve_`lag' "pbeve lag(`lag')";
        };

    /*OBTAIN AUTO-CORRELATION*/;
    corr pbeve pbeve_1-pbeve_15;
        /*HERE YOU CAN SEE HOW HEACH CORRELATION TAKES THE VALUE OF THE AUTO-CORRELATION FUNCTION*/

    /*OBTAIN PARTIAL AUTO-CORRELATION*/;
    foreach lag of numlist 1/15{;
        reg pbeve pbeve_1-pbeve_`lag';
        };
        /*HERE YOU CAN SEE HOW HEACH COEFFICIENT TAKES THE VALUE OF THE PARTIAL AUTO-CORRELATION FUNCTION*/
    pause;
    restore;

*********************************************************************;
*** #10.4 ** GRAPHS, TIME SERIES, AUTOCORRELATION, PARTIAL AUTOCORRELATION;
***       ** ANY VARIABLE SET IN THE LOCAL;
*********************************************************************;

    preserve;
    local var pcoco;
    keep date date_num `var';
    order date date_num `var';

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
        /*HERE YOU CAN SEE HOW EACH COEFFICIENT TAKES THE VALUE OF THE PARTIAL AUTO-CORRELATION FUNCTION*/
    restore;

**** #90.9.9 ** GOOD BYE;
*
*    clear;
