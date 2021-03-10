** PROJECT: ANALISIS DE DATOS
** PROGRAM: datos_panel.do
** PROGRAM TASK: PANEL DATA ANALYSIS
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2018/10/24
** DATE REVISION 1: 2020/04/07
** DATE REVISION #:

********************************************************************;
** #0
********************************************************************;

** PROGRAM SETUP

    pause on
    #delimit ;

** #0.1 ** SET PATH FOR READING/SAVING DATA;

    cd ../../;

********************************************************************;
** #10 ** PANEL DATA ROUTINE;
********************************************************************;

** #10.1 ** EXECUTE DATA IN;

* declare cross section and time series identifiers;

    xtset panel_var time_var;

* random effects;

    xtreg  y x1 x2, re;
    estimates store re;

* Breusch-Pagan test;
    xttest0;

* fixed effects estimation;
    xtreg y x1 x2, fe;
    estimates store fe;

* Hausman test;
    hausman fe re;

********************************************************************;
** #20 ** PANEL DATA ADVERTISING - SALES EXAMPLE;
********************************************************************;

* DATA IN;

    #delimit ;
    use http://www.rodrigotaborda.com/ad/data/pv/pv8387.dta, clear;

* EXAMINE DATA;

    tab ciiu3;
    tab y;
    tab am;

    sort y am ciiu3;

    tostring ciiu3, generate(ciiu3_str);
    tostring am, generate(am_str);

    generate ciiu3_am_str = ciiu3_str + "_" + am_str;
    egen ciiu3_am_str01 = group(ciiu3_str am_str);

    generate kw_ln = ln(kw);
    generate ventas_ln = ln(ventas);

* DECLARE CROSS SECTION AND TIME SERIES IDENTIFIERS;

    xtset ciiu3_am_str01 y;

* OLS;
* NO ACKNOWLEDGEMENT OF SOURCES OF VARIATION;

    reg ventas_ln kw_ln;
		estimates store ols;
        margins , at(kw_ln=(0 9 18));
        marginsplot
			,
			noci
			legend(off)
			title(ols)
			name(ols, replace)
			;

* OLS;
* INDUSTRY FIXED EFFECT;

	reg ventas_ln kw_ln i.ciiu3;
		estimates store ciiu3;
        margins i.ciiu3, at(kw_ln=(0 9 18));
        marginsplot
			,
			noci
			legend(off)
			title(ciiu3)
			name(ciiu3, replace)
			;
		
* OLS;
* CITY FIXED EFFECT;

    reg ventas_ln kw_ln i.am;
		estimates store am;
        margins i.am, at(kw_ln=(0 9 18));
        marginsplot
			,
			noci
			legend(off)
			title(am)
			name(am, replace)
			;

* OLS;
* YEAR FIXED EFFECT;

    reg ventas_ln kw_ln i.y;
		estimates store y;
        margins i.y, at(kw_ln=(0 9 18));
        marginsplot
			,
			noci
			legend(off)
			title(y)
			name(y, replace)
			;

* OLS;
* INDUSTRY-CITY FIXED EFFECT;

    reg ventas_ln kw_ln i.ciiu3_am_str01;
		estimates store ciiu3am;
        margins i.ciiu3_am_str01, at(kw_ln=(0 9 18));
        marginsplot
			,
			noci
			legend(off)
			title(ciiu3am)
			name(ciiu3am, replace)
			;

* FIXED EFFECTS ESTIMATION;
* INDUSTRY-CITY FIXED EFFECT;

    xtreg ventas_ln kw_ln, fe;
        estimates store fe;
        margins , at(kw_ln=(0 9 18));
        marginsplot
			,
			noci
			legend(off)
			title(fe)
			name(fe, replace)
			;

    xtreg ventas_ln kw_ln i.y, fe;
        estimates store fe_y;
*        margins , at(kw_ln=(0 9 18));
*        marginsplot
*			,
*			noci
*			legend(off)
*			title(fe)
*			name(fe, replace)
*			;

* RANDOM EFFECTS ESTIMATION;
* INDUSTRY-CITY RANDOM EFFECT;

    xtreg ventas_ln kw_ln, re;
        estimates store re;
        margins , at(kw_ln=(0 9 18));
        marginsplot
			,
			noci
			legend(off)
			title(re)
			name(re, replace)
			;

    xtreg ventas_ln kw_ln i.y, re;
        estimates store re_y;
*        margins , at(kw_ln=(0 9 18));
*        marginsplot
*			,
*			noci
*			legend(off)
*			title(re)
*			name(re, replace)
*			;

* RANDOM EFFECTS ESTIMATION AS OF MULTILEVEL MODEL;
    xtreg ventas_ln kw_ln, mle;
        estimates store re_mle;

    mixed ventas_ln kw_ln || ciiu3_am_str01: ;
        estimates store mixed;

* ESTIMATION RESULTS;
	estimates table ols ciiu3 am ciiu3am y fe fe_y re re_y re_mle mixed, keep(_cons kw_ln);

* HAUSMAN TEST;
    hausman fe re;

* GRAPH COMBINE;
	graph combine ols ciiu3 am ciiu3am y fe re
        ,
        cols(2)
		ysize(16)
		xsize(10)
        ;
