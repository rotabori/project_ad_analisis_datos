** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: google_trends.do
** PROGRAM TASK: SERIES DE TIEMPO
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2020/02/02
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

*https://twitter.com/LuisFerMejia/status/1331259335348015105?s=09

*********************************************************************;
*** #10 ** GOOGLE TRENDS;
*********************************************************************;

*********************************************************************;
*** #10.1 ** INFLUENZA;
*********************************************************************;
*
**** #10.1.1 ** IMPORT DATA;

    import delimited
        http://rodrigotaborda.com/ad/data/google_trends/influenza200401_202005.csv
        ,
        colrange(1:2)
        clear
        ;

*** #10.1.2 ** ORGANIZE DATE VARIABLE;

    generate fecha_num = monthly(fecha,"YM");
        label var fecha_num "Fecha";
    format %tm fecha_num;

*** #10.1.3 ** DECLARE TIME SERIES FORMAT;

    tsset fecha_num;

*** #10.1.4 ** LABEL VARIABLE;

    rename influenza_us_google_search influenza;
    label var influenza "Influenza";

*** #10.2 ** GRAPHS, TIME SERIES, AUTOCORRELATION, PARTIAL AUTOCORRELATION;

    /*GRAPHS*/;
    tsline influenza
        ,
        ytitle(Interés)
        ylabel(,angle(0))
        name(influenza_tsline, replace)
        ;

    ac influenza
        ,
        title(AC)
        ytitle("")
        ylabel(,angle(0))
        name(influenza_ac, replace)
        ;

    pac influenza
        ,
        title(PAC)
        ylabel(,angle(0))
        ytitle("")
        name(influenza_pac, replace)
        ;

    graph combine influenza_ac influenza_pac
        ,
        cols(2)
        name(influenza_ac_pac, replace)
        ;

    graph combine influenza_tsline influenza_ac_pac
        ,
        title(Influenza)
        cols(1)
        /*note("Interés: ")*/
        note("Interés: Los números reflejan el interés de búsqueda en relación con el valor máximo de un gráfico "
             "en una región y un periodo determinados. Un valor de 100 indica la popularidad máxima de un término, "
             "mientras que 50 y 0 indican que un término es la mitad de popular en relación con el valor máximo o "
             "que no había suficientes datos del término, respectivamente.")
        name(influenza, replace)
        ;

    graph close _all;
    graph display influenza;

*** #10.3 ** ESTIMACIÓN;

    arima influenza, arima(3,0,1);
        estat ic;
    arima influenza, arima(3,0,0);
        estat ic;
    arima influenza, arima(2,0,1);
        estat ic;
    arima influenza, arima(2,0,0);
        estat ic;

    tsappend, add(24);

    arima influenza, arima(2,0,0) sarima(0,1,1,12);
        estat ic;
    	predict influenza_200_01112, y dynamic(tm(2020m5));
            label var influenza_200_01112 "ARIMA(2,0,0)SARIMA(0,1,1,12)";

    tsline influenza influenza_200_01112
        ,
        ytitle(Interés - pronóstico)
        ylabel(,angle(0))
        xlabel(,angle(90))
        name(influenza_pronostico, replace)
        ;

**********************************************************************;
**** #20.2 ** FORRESTGUMP;
**********************************************************************;
**
***** #20.2.1 ** IMPORT DATA;
*
*    import delimited data\google_trends\forrestgump200401_202005.csv
*        ,
*        colrange(1:2)
*        clear
*        ;
*
**** #20.2.2 ** ORGANIZE DATE VARIABLE;
*
*    generate fecha_num = monthly(fecha,"YM");
*        label var fecha_num "Fecha";
*    format %tm fecha_num;
*
**** #20.2.3 ** DECLARE TIME SERIES FORMAT;
*
*    tsset fecha_num;
*
**** #20.2.4 ** LABEL VARIABLE;
*
*    label var forrestgump "Forrestgump";
*
**** #20.3 ** GRAPHS, TIME SERIES, AUTOCORRELATION, PARTIAL AUTOCORRELATION;
*
*    /*GRAPHS*/;
*    tsline forrestgump
*        ,
*        ytitle(Interés)
*        ylabel(,angle(0))
*        name(forrestgump_tsline, replace)
*        ;
*
*    ac forrestgump
*        ,
*        title(AC)
*        ylabel(,angle(0))
*        ytitle("")
*        name(forrestgump_ac, replace)
*        ;
*
*    pac forrestgump
*        ,
*        title(PAC)
*        ylabel(,angle(0))
*        ytitle("")
*        name(forrestgump_pac, replace)
*        ;
*
*    graph combine forrestgump_ac forrestgump_pac
*        ,
*        cols(2)
*        name(forrestgump_ac_pac, replace)
*        ;
*
*    graph combine forrestgump_tsline forrestgump_ac_pac
*        ,
*        title(Forrestgump)
*        cols(1)
*        /*note("Interés: ")*/
*        note("Interés: Los números reflejan el interés de búsqueda en relación con el valor máximo de un gráfico "
*             "en una región y un periodo determinados. Un valor de 100 indica la popularidad máxima de un término, "
*             "mientras que 50 y 0 indican que un término es la mitad de popular en relación con el valor máximo o "
*             "que no había suficientes datos del término, respectivamente.")
*        name(forrestgump, replace)
*        ;
*
*    graph close _all;
*    graph display forrestgump;

*********************************************************************;
*** #30.2 ** IPHONE;
*********************************************************************;
*
**** #30.2.1 ** IMPORT DATA;

    import delimited data\google_trends\iphone20080101_20200514.csv
        ,
        colrange(1:2)
        clear
        ;

*** #30.2.2 ** ORGANIZE DATE VARIABLE;

    generate fecha_num = monthly(fecha,"YM");
        label var fecha_num "Fecha";
    format %tm fecha_num;

*** #30.2.3 ** DECLARE TIME SERIES FORMAT;

    tsset fecha_num;

*** #30.2.4 ** LABEL VARIABLE;

    label var iphone "Iphone";

*** #30.3 ** GRAPHS, TIME SERIES, AUTOCORRELATION, PARTIAL AUTOCORRELATION;

    /*GRAPHS*/;
    tsline iphone
        ,
        ytitle(Interés)
        ylabel(,angle(0))
        name(iphone_tsline, replace)
        ;

    ac iphone
        ,
        title(AC)
        ylabel(,angle(0))
        ytitle("")
        name(iphone_ac, replace)
        ;

    pac iphone
        ,
        title(PAC)
        ylabel(,angle(0))
        ytitle("")
        name(iphone_pac, replace)
        ;

    graph combine iphone_ac iphone_pac
        ,
        cols(2)
        name(iphone_ac_pac, replace)
        ;

    graph combine iphone_tsline iphone_ac_pac
        ,
        title(Iphone)
        cols(1)
        /*note("Interés: ")*/
        note("Interés: Los números reflejan el interés de búsqueda en relación con el valor máximo de un gráfico "
             "en una región y un periodo determinados. Un valor de 100 indica la popularidad máxima de un término, "
             "mientras que 50 y 0 indican que un término es la mitad de popular en relación con el valor máximo o "
             "que no había suficientes datos del término, respectivamente.")
        name(iphone, replace)
        ;

*tsline ip, xsize(7) tline(2008m7) tline(2009m7) tline(2010m7) tline(2011m9) tline(2012m9) tline(2013m9) tline(2014m9) tline(2015m9) tline(2016m9) tline(2017m9) tline(2018m9) tline(2019m9);

    graph close _all;
    graph display iphone;






**********************************************************************;
**** #40.2 ** CHOCOLATE;
**********************************************************************;
**
***** #40.2.1 ** IMPORT DATA;
*
*    import delimited data\google_trends\chocolate20200515.csv
*        ,
*        colrange(1:2)
*        clear
*        ;
*
**** #40.2.2 ** ORGANIZE DATE VARIABLE;
*
*    generate fecha_num = monthly(fecha,"YM");
*        label var fecha_num "Fecha";
*    format %tm fecha_num;
*
**** #40.2.3 ** DECLARE TIME SERIES FORMAT;
*
*    tsset fecha_num;
*
**** #40.2.4 ** LABEL VARIABLE;
*
*    label var chocolate "Chocolate";
*
**** #40.3 ** GRAPHS, TIME SERIES, AUTOCORRELATION, PARTIAL AUTOCORRELATION;
*
*    /*GRAPHS*/;
*    tsline chocolate
*        ,
*        ytitle(Interés)
*        ylabel(,angle(0))
*        name(chocolate_tsline, replace)
*        ;
*
*    ac chocolate
*        ,
*        title(AC)
*        ylabel(,angle(0))
*        ytitle("")
*        name(chocolate_ac, replace)
*        ;
*
*    pac chocolate
*        ,
*        title(PAC)
*        ylabel(,angle(0))
*        ytitle("")
*        name(chocolate_pac, replace)
*        ;
*
*    graph combine chocolate_ac chocolate_pac
*        ,
*        cols(2)
*        name(chocolate_ac_pac, replace)
*        ;
*
*    graph combine chocolate_tsline chocolate_ac_pac
*        ,
*        title(Chocolate)
*        cols(1)
*        /*note("Interés: ")*/
*        note("Interés: Los números reflejan el interés de búsqueda en relación con el valor máximo de un gráfico "
*             "en una región y un periodo determinados. Un valor de 100 indica la popularidad máxima de un término, "
*             "mientras que 50 y 0 indican que un término es la mitad de popular en relación con el valor máximo o "
*             "que no había suficientes datos del término, respectivamente.")
*        name(chocolate, replace)
*        ;
*
**tsline ip, xsize(7) tline(2008m7) tline(2009m7) tline(2010m7) tline(2011m9) tline(2012m9) tline(2013m9) tline(2014m9) tline(2015m9) tline(2016m9) tline(2017m9) tline(2018m9) tline(2019m9);
*
*    graph close _all;
*    graph display chocolate;

**********************************************************************;
**** #50.2 ** ENTREPRENEURSHIP;
**********************************************************************;
**
***** #50.2.1 ** IMPORT DATA;
*
*    import delimited data\google_trends\entrepreneurship20200515.csv
*        ,
*        colrange(1:2)
*        clear
*        ;
*
**** #50.2.2 ** ORGANIZE DATE VARIABLE;
*
*    generate fecha_num = monthly(fecha,"YM");
*        label var fecha_num "Fecha";
*    format %tm fecha_num;
*
**** #50.2.3 ** DECLARE TIME SERIES FORMAT;
*
*    tsset fecha_num;
*
**** #50.2.4 ** LABEL VARIABLE;
*
*    label var entrepreneurship "Entrepreneurship";
*
**** #50.3 ** GRAPHS, TIME SERIES, AUTOCORRELATION, PARTIAL AUTOCORRELATION;
*
*    /*GRAPHS*/;
*    tsline entrepreneurship
*        ,
*        ytitle(Interés)
*        ylabel(,angle(0))
*        name(entrepreneurship_tsline, replace)
*        ;
*
*    ac entrepreneurship
*        ,
*        title(AC)
*        ylabel(,angle(0))
*        ytitle("")
*        name(entrepreneurship_ac, replace)
*        ;
*
*    pac entrepreneurship
*        ,
*        title(PAC)
*        ylabel(,angle(0))
*        ytitle("")
*        name(entrepreneurship_pac, replace)
*        ;
*
*    graph combine entrepreneurship_ac entrepreneurship_pac
*        ,
*        cols(2)
*        name(entrepreneurship_ac_pac, replace)
*        ;
*
*    graph combine entrepreneurship_tsline entrepreneurship_ac_pac
*        ,
*        title(Entrepreneurship)
*        cols(1)
*        /*note("Interés: ")*/
*        note("Interés: Los números reflejan el interés de búsqueda en relación con el valor máximo de un gráfico "
*             "en una región y un periodo determinados. Un valor de 100 indica la popularidad máxima de un término, "
*             "mientras que 50 y 0 indican que un término es la mitad de popular en relación con el valor máximo o "
*             "que no había suficientes datos del término, respectivamente.")
*        name(entrepreneurship, replace)
*        ;
*
**tsline ip, xsize(7) tline(2008m7) tline(2009m7) tline(2010m7) tline(2011m9) tline(2012m9) tline(2013m9) tline(2014m9) tline(2015m9) tline(2016m9) tline(2017m9) tline(2018m9) tline(2019m9);
*
*    graph close _all;
*    graph display entrepreneurship;
*
*
**********************************************************************;
**** #60.2 ** PLAYSTATION;
**********************************************************************;
**
***** #60.2.1 ** IMPORT DATA;
*
*    import delimited data\google_trends\playstation20200515.csv
*        ,
*        colrange(1:2)
*        clear
*        ;

**** #60.2.2 ** ORGANIZE DATE VARIABLE;
*
*    generate fecha_num = monthly(fecha,"YM");
*        label var fecha_num "Fecha";
*    format %tm fecha_num;
*
**** #60.2.3 ** DECLARE TIME SERIES FORMAT;
*
*    tsset fecha_num;
*
**** #60.2.4 ** LABEL VARIABLE;
*
*    label var playstation "Playstation";
*
**** #60.3 ** GRAPHS, TIME SERIES, AUTOCORRELATION, PARTIAL AUTOCORRELATION;
*
*    /*GRAPHS*/;
*    tsline playstation
*        ,
*        ytitle(Interés)
*        ylabel(,angle(0))
*        name(playstation_tsline, replace)
*        ;
*
*    ac playstation
*        ,
*        title(AC)
*        ylabel(,angle(0))
*        ytitle("")
*        name(playstation_ac, replace)
*        ;
*
*    pac playstation
*        ,
*        title(PAC)
*        ylabel(,angle(0))
*        ytitle("")
*        name(playstation_pac, replace)
*        ;
*
*    graph combine playstation_ac playstation_pac
*        ,
*        cols(2)
*        name(playstation_ac_pac, replace)
*        ;
*
*    graph combine playstation_tsline playstation_ac_pac
*        ,
*        title(Playstation)
*        cols(1)
*        /*note("Interés: ")*/
*        note("Interés: Los números reflejan el interés de búsqueda en relación con el valor máximo de un gráfico "
*             "en una región y un periodo determinados. Un valor de 100 indica la popularidad máxima de un término, "
*             "mientras que 50 y 0 indican que un término es la mitad de popular en relación con el valor máximo o "
*             "que no había suficientes datos del término, respectivamente.")
*        name(playstation, replace)
*        ;
*
**tsline ip, xsize(7) tline(2008m7) tline(2009m7) tline(2010m7) tline(2011m9) tline(2012m9) tline(2013m9) tline(2014m9) tline(2015m9) tline(2016m9) tline(2017m9) tline(2018m9) tline(2019m9);
*
*    graph close _all;
*    graph display playstation;

**** #90.9.9 ** GOOD BYE;
*
*    clear;
