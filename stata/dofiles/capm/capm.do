** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: capm.do
** PROGRAM TASK: SERIES DE TIEMPO
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 07/06/2019
** DATE REVISION 1:
** DATE REVISION #:

********************************************************************;
** #0
********************************************************************;

** PROGRAM SETUP

    pause on
    #delimit ;

** #0.1 ** SET PATH FOR READING/SAVING DATA;

    cd ../../../;

*********************************************************************;
*** #10 ** DTF;
*********************************************************************;
*
*********************************************************************;
*** #10.1 ** READ, ORGANIZE DATA;
*********************************************************************;
*
**** #10.1.1 ** IMPORT DATA;

        import delimited
        data/capm/dtf_198601-201905.csv
        ,
        clear
        ;

*** #10.1.2 ** ORGANIZE DATE VARIABLE;

    rename fecha date;
    gen date_num = monthly(date,"YM",2050);
        label var date_num "Fecha";
        format %tm date_num;

    generate date_date = dofm(date_num);
        label var date_num "Fecha (DMY)";
        format date_date %d;
    generate date_day = day(date_date);
        label var date_day "Día";
    generate date_week = week(date_date);
        label var date_week "Semana";
    generate date_month = month(date_date);
        label var date_month "Mes";
    generate date_quarter = quarter(date_date);
        label var date_quarter "Trimestre";
    generate date_semester = halfyear(date_date);
        label var date_semester "Semestre";
    generate date_year = year(date_date);
        label var date_year "Año";

    generate dtf_m = (1 + dtf)^(1/12) - 1;
        label var dtf_m "DTF (Efectivo mensual)";

*** #10.1.3 ** DECLARE TIME SERIES FORMAT;

    tsset date_num;

*** #10.1.4 ** LABEL VARIABLES;

    label var date_num "Fecha";
    label var dtf "DTF (Efectivo anual)";

*********************************************************************;
*** #10.2 ** SAVE;
*********************************************************************;

    order _all, alphabetic;
    order date*, alphabetic;
    saveold data\capm\dtf_198601-201905.dta, replace;

*********************************************************************;
*** #20 ** COLCAP & ACCIONES;
*********************************************************************;
*
*********************************************************************;
*** #20.1 ** READ, ORGANIZE DATA;
*********************************************************************;
*
**** #20.1.1 ** IMPORT DATA;

        import delimited
        data/capm/colcap_acciones_200109-201904.csv
        ,
        clear
        ;

*** #20.1.2 ** ORGANIZE DATE VARIABLE;

    rename fecha date;
    gen date_date = date(date,"DMY",2050);
        format date_date %d;

    generate date_day = day(date_date);
        label var date_day "Día";
    generate date_week = week(date_date);
        label var date_week "Semana";
    generate date_month = month(date_date);
        label var date_month "Mes";
    generate date_quarter = quarter(date_date);
        label var date_quarter "Trimestre";
    generate date_semester = halfyear(date_date);
        label var date_semester "Semestre";
    generate date_year = year(date_date);
        label var date_year "Año";

*** #20.1.3 ** DECLARE TIME SERIES FORMAT;

    gen date_num = mofd(date_date);
        format date_num %tm;
    tsset date_num;

*** #20.1.4 ** LABEL VARIABLES;

    label var date_num "Fecha";
    label var colcap "COLCAP";
    label var bancolombia_pf "BANCOLOMBIA (Pref.)";
    label var ecopetrol "ECOPETROL";
    label var sura "Suramericana";
    label var aval_pf "AVAL (Pref.)";
    label var davivienda_pf "DAVIVIENDA (Pref.)";
    label var banco_bogota "Banco Bogotá";
    label var isa "ISA";
    label var isagen "ISAGEN";
    label var eeb "EEB";
    label var celsia "CELSIA";
    label var nutresa "NUTRESA";
    label var argos "ARGOS";
    label var exito "Éxito";
    label var avianca_pf "Avianca (Pref.)";

*********************************************************************;
*** #20.2 ** SAVE;
*********************************************************************;

    order _all, alphabetic;
    order date*, alphabetic;
    saveold data\capm\colcap_acciones_200109-201904.dta, replace;

*********************************************************************;
*** #30 ** DATA MANIPULATION;
*********************************************************************;

*********************************************************************;
*** #30.1 ** READ, MERGE, ORGANIZE DATA;
*********************************************************************;

*** #30.1.1 ** READ;

    use
    data/capm/dtf_198601-201905.dta
    ,
    clear
    ;

*** #30.1.2 ** MERGE;

    merge 1:1 date_num using data/capm/colcap_acciones_200109-201904.dta;
        drop _merge;

*** #30.1.3 ** ORGANIZE AND KEEP;

    order date date_date date_num, first;
    keep if tin(2001m9,);

*********************************************************************;
*** #30.2 ** GENERATE ANUAL RETURN - DTF;
*********************************************************************;

    local assets
        "argos aval_pf avianca_pf banco_bogota bancolombia_pf celsia
        colcap
        davivienda_pf ecopetrol eeb exito isa isagen nutresa sura"
        ;

    foreach asset of local assets {;
        gen `asset'_ret_dtf_m = (((`asset' / l1.`asset') - 1) * 100) - dtf_m;
        };

*********************************************************************;
*** #40 ** CAPM ESTIMATION;
*********************************************************************;

    local assets
        "argos aval_pf avianca_pf banco_bogota bancolombia_pf celsia
        davivienda_pf ecopetrol eeb exito isa isagen nutresa sura"
        ;

	local replace replace;
    foreach asset of local assets {;
        reg `asset'_ret_dtf_m colcap_ret_dtf_m;
    		outreg2 using data\capm\capm
                ,
                label
                excel
                symbol(a, b, c)
                addnote("-", "Fecha $S_DATE")
                `replace'
                ;
        predict `asset'_res, residuals;
			local replace ;

        scatter `asset'_ret_dtf_m colcap_ret_dtf_m || lfit `asset'_ret_dtf_m colcap_ret_dtf_m
            ,
            name(`asset'_capm);
        };



**** #90.9.9 ** GOOD BYE;
*
*    clear;
