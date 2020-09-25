** PROJECT: ANALISIS DE DATOS
** PROGRAM: series_tiempo_volatilidad1.do
** PROGRAM TASK: SERIES DE TIEMPO VOLATILIDAD Y ARCH
** AUTHOR: RODRIGO TABORDA
** DATE CREATED: 2014/02/26
** DATE REVISION 1: 2019/09/09
** DATE REVISION 1: 2020/04/07

** #0 ** PROGRAM SETUP

    pause on
    #delimit ;

** #0.1 ** SET PATH FOR READING/SAVING DATA;

    cd ../../;

** #1 ** READ AND SET UP DATA;

** #1.2 ** P.RUBIALES CANADA;

** #1.2.1 ** LOAD DATA;

    import delimited
        data/arch/acciones_pre_can.csv
        /*http://rodrigotaborda.com/ad/data/arch/acciones_pre_can.csv*/
        ,
    	delimiter(",")
        clear
        ;

** #1.2.2 ** DECLARE TIME SERIES;

    gen date_stata = date(date,"DMY");
    format date_stata %td;

    bcal create canada, from(date_stata) generate(date_canada) dateformat(dmy) replace;

    tsset date_canada;

** #1.2.3 ** LABEL VARIABLES;

    label var date_stata "Date";
    label var pre_can "P.Rubiales (Can dolars)";

** #1.2.4 ** GENERATE NEW VARIABLES;

    gen pre_can_rsimple = ((pre_can/l.pre_can)-1)*100;
        label var pre_can_rsimple "P.Rubiales return (simple)";

    gen pre_can_rcomp = (ln(pre_can/l.pre_can))*100;
        label var pre_can_rcomp "P.Rubiales return (comp)";

    generate date_d = day(date_stata);
        label var date_d "Day";

    generate date_w = week(date_stata);
        label var date_w "Week";

    generate date_m = month(date_stata);
        label var date_m "Month";

    generate date_y = year(date_stata);
        label var date_y "Year";

    tsset date_canada;

** #1.2.5 ** SAVE DATA;

    save data/arch/acciones_pre_can, replace;

** 1.3 ** P.RUBIALES BANCOLOMBIA COLOMBIA;

** #1.3.1 ** LOAD DATA;

    import delimited
        data/arch/acciones_bcol_pre.csv
        /*http://rodrigotaborda.com/ad/data/arch/acciones_bcol_pre.csv*/
        ,
    	delimiter(",")
        clear
        ;

** #1.3.2 ** DECLARE TIME SERIES;

    gen date_stata = date(date,"DMY");
    format date_stata %td;

    bcal create colombia, from(date_stata) generate(date_colombia) dateformat(dmy) replace;

    tsset date_colombia;

** #1.3.3 ** LABEL VARIABLES;

    label var date_stata "Date";
    label var bcol "Bancolombia (Col pesos)";
    label var bcol_pref "Bancolombia preferencial (Col pesos)";
    label var pre_col "P.Rubiales (Col pesos)";

** #1.3.4 ** GENERATE NEW VARIABLES;

    gen pre_col_rsimple = ((pre_col/l.pre_col)-1)*100;
        label var pre_col_rsimple "P.Rubiales return (simple) (Col)";

    gen pre_col_rcomp = (ln(pre_col/l.pre_col))*100;
        label var pre_col_rcomp "P.Rubiales return (comp) (Col)";

    gen bcol_rsimple = ((bcol/l.bcol)-1)*100;
        label var bcol_rsimple "Bancolombia return (simple) (Col)";

    gen bcol_rcomp = (ln(bcol/l.bcol))*100;
        label var bcol_rcomp "Bancolombia return (comp) (Col)";

    gen bcol_pref_rsimple = ((bcol_pref/l.bcol_pref)-1)*100;
        label var bcol_pref_rsimple "Bancolombia preferencial return (simple) (Col)";

    gen bcol_pref_rcomp = (ln(bcol_pref/l.bcol_pref))*100;
        label var bcol_pref_rcomp "Bancolombia preferencial return (comp) (Col)";

    generate date_d = day(date_stata);
        label var date_d "Day";

    generate date_w = week(date_stata);
        label var date_w "Week";

    generate date_m = month(date_stata);
        label var date_m "Month";

    generate date_y = year(date_stata);
        label var date_y "Year";

    tsset date_colombia;

** #1.3.5 ** SAVE DATA;

    save data/arch/acciones_bcol_pre, replace;

** 1.4 ** JOIN DATA;

    use data/arch/acciones_pre_can, clear;
    merge 1:1 date_stata using data/arch/acciones_bcol_pre;

    drop _merge;
    drop if pre_col == . | date_y < 2010;
    order _all, alphabetic;
    order date* bcol* pre* ;
    tsset date_colombia;

    save data/arch/acciones_arch, replace;

*** #3 ** GRÁFICAS;

    use data\arch\acciones_arch, clear;
    tsset date_stata;

*** #3.1 ** NIVEL;
        tsline pre_can,
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(04jan2010(120)25feb2014, tpos(out))
            tlabel(#4, format(%tdCCYY) angle(90))
            ;
            sleep 3000;
            graph export text\figures\pre_can.eps, replace;

        tsline pre_col,
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(01jan2010(120)25feb2014, tpos(out))
            tlabel(#4, format(%tdCCYY) angle(90))
            ;
            sleep 3000;
            graph export text\figures\pre_col.eps, replace;

        tsline bcol,
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(01jan2010(120)25feb2014, tpos(out))
            tlabel(#4, format(%tdCCYY) angle(90))
            /*saving(stata\figures\a`comm'_1980to1985, replace)*/
            ;
            sleep 3000;
            graph export text\figures\bcol.eps, replace;

        tsline bcol_pref,
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(01jan2010(120)25feb2014, tpos(out))
            tlabel(#4, format(%tdCCYY) angle(90))
            ;
            sleep 3000;
            graph export text\figures\bcol_pref.eps, replace;

** #3.2 ** SIMPLE RETURN;
        tsline pre_can_rsimple,
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(01jan2010(120)25feb2014, tpos(out))
            tlabel(01jan2010(365)25feb2014, format(%tdCCYY) angle(90))
            ;
            sleep 3000;
            graph export text\figures\pre_can_rsimple.eps, replace;

        tsline pre_col_rsimple,
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(01jan2010(120)25feb2014, tpos(out))
            tlabel(01jan2010(365)25feb2014, format(%tdCCYY) angle(90))
            ;
            sleep 3000;
            graph export text\figures\pre_col_rsimple.eps, replace;

        tsline bcol_rsimple,
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(01jan2010(120)25feb2014, tpos(out))
            tlabel(01jan2010(365)25feb2014, format(%tdCCYY) angle(90))
            ;
            sleep 3000;
            graph export text\figures\bcol_rsimple.eps, replace;

        tsline bcol_pref_rsimple,
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(01jan2010(120)25feb2014, tpos(out))
            tlabel(01jan2010(365)25feb2014, format(%tdCCYY) angle(90))
            ;
            sleep 3000;
            graph export text\figures\bcol_pref_rsimple.eps, replace;

** #3.3 ** COMPOUND RETURN;
        tsline pre_can_rcomp,
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(01jan2010(120)25feb2014, tpos(out))
            tlabel(01jan2010(365)25feb2014, format(%tdCCYY) angle(90))
            /*saving(stata\figures\a`comm'_1980to1985, replace)*/
            ;
            sleep 3000;
            graph export text\figures\pre_can_rcomp.eps, replace;

        tsline pre_col_rcomp,
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(01jan2010(120)25feb2014, tpos(out))
            tlabel(01jan2010(365)25feb2014, format(%tdCCYY) angle(90))
            ;
            sleep 3000;
            graph export text\figures\pre_col_rcomp.eps, replace;

        tsline bcol_rcomp,
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(01jan2010(120)25feb2014, tpos(out))
            tlabel(01jan2010(365)25feb2014, format(%tdCCYY) angle(90))
            ;
            sleep 3000;
            graph export text\figures\bcol_rcomp.eps, replace;

        tsline bcol_pref_rcomp,
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ttick(01jan2010(120)25feb2014, tpos(out))
            tlabel(01jan2010(365)25feb2014, format(%tdCCYY) angle(90))
            ;
            sleep 3000;
            graph export text\figures\bcol_pref_rcomp.eps, replace;

** #3.3 ** HISTOGRAMA;
        hist pre_can_rcomp,
            normal
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ;
            sleep 3000;
            graph export text\figures\pre_can_rcomp_hist.eps, replace;

        hist pre_col_rcomp,
            normal
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ;
            sleep 3000;
            graph export text\figures\pre_col_rcomp_hist.eps, replace;

        hist bcol_rcomp,
            normal
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ;
            sleep 3000;
            graph export text\figures\bcol_rcomp_hist.eps, replace;

        hist bcol_pref_rcomp,
            normal
            note("Note:")
            xtitle("")
            lcolor(gs0)
            scheme(s1mono)
            ;
            sleep 3000;
            graph export text\figures\bcol_pref_rcomp_hist.eps, replace;

*** #3.4 ** SCATTER;
        scatter pre_can l.pre_can,
            msize(vsmall)
            connect(l)
            lwidth(thin)
            note("Note:")
            xtitle("Lag")
            lcolor(gs0)
            scheme(s1mono)
            ;
            sleep 3000;
            graph export text\figures\pre_can_scatter.eps, replace;

        scatter pre_can_rcomp l.pre_can_rcomp,
            msize(vsmall)
            connect(l)
            lwidth(thin)
            yline(0, lwidth(thin) lcolor(red))
            xline(0, lwidth(thin) lcolor(red))
            note("Note:")
            xtitle("Lag")
            lcolor(gs0)
            scheme(s1mono)
            ;
            sleep 3000;
            graph export text\figures\pre_can_rcomp_scatter.eps, replace;

        scatter pre_col_rcomp l.pre_col_rcomp,
            msize(vsmall)
            connect(l)
            lwidth(thin)
            yline(0, lwidth(thin) lcolor(red))
            xline(0, lwidth(thin) lcolor(red))
            note("Note:")
            xtitle("Lag")
            lcolor(gs0)
            scheme(s1mono)
            ;
            sleep 3000;
            graph export text\figures\pre_col_rcomp_scatter.eps, replace;

        scatter bcol l.bcol,
            msize(vsmall)
            connect(l)
            lwidth(thin)
            note("Note:")
            xtitle("Lag")
            lcolor(gs0)
            scheme(s1mono)
            ;
            sleep 3000;
            graph export text\figures\bcol_scatter.eps, replace;

        scatter bcol_rcomp l.bcol_rcomp,
            msize(vsmall)
            connect(l)
            lwidth(thin)
            yline(0, lwidth(thin) lcolor(red))
            xline(0, lwidth(thin) lcolor(red))
            note("Note:")
            xtitle("Lag")
            lcolor(gs0)
            scheme(s1mono)
            ;
            sleep 3000;
            graph export text\figures\bcol_rcomp_scatter.eps, replace;

        scatter bcol_pref_rcomp l.bcol_pref_rcomp,
            msize(vsmall)
            connect(l)
            lwidth(thin)
            yline(0, lwidth(thin) lcolor(red))
            xline(0, lwidth(thin) lcolor(red))
            note("Note:")
            xtitle("Lag")
            lcolor(gs0)
            scheme(s1mono)
            ;
            sleep 3000;
            graph export text\figures\bcol_pref_rcomp_scatter.eps, replace;

* #6 ** ARCH;

    use data/arch/acciones_arch, clear;
    tsset date_colombia;

** #6.1 ** PACIFIC RUBIALES CANADA;

    /*REGRESIÓN VARIABLE INTERÉS*/;
        reg pre_can_rcomp;
        predict pre_can_rcomp_res, residuals;
            label var pre_can_rcomp_res "Residuals";

    /*REGRESIÓN RESIDUOS*/;
        gen pre_can_rcomp_res2 = pre_can_rcomp_res^2;
        reg pre_can_rcomp_res2 l.pre_can_rcomp_res2;

    /*REGRESIÓN ARCH*/;
        arch pre_can_rcomp, arch(1);

        arch pre_can_rcomp, arch(1) arima(1,0,0);

    /*REGRESIÓN GARCH*/;
        arch pre_can_rcomp, arch(1) garch(1);

    /*REGRESIÓN ASYMMETRIC-GARCH*/;
        arch pre_can_rcomp, arch(1) garch(1) saarch(1);

    /*REGRESIÓN T-GARCH*/;
        arch pre_can_rcomp, arch(1) garch(1) tarch(1);
