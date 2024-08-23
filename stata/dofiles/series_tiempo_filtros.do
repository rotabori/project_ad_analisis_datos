** PROJECT: ANALISIS DE DATOS
** PROGRAM: series_tiempo_filtros.do
** PROGRAM TASK: MANEJO DE FECHA
** AUTHOR: RODRIGO TABORDA
** DATE CREATED: 2021/05/18
** DATE REVISION 1:
** DATE REVISION #:

*********************************************************************;
*** #10 ** SMOOTHING;
*********************************************************************;

*    /*SYMETRIC MOVING AVERAGE (SMA)*/;
*    generate y_sma = -.2*L2.y_ln - .2*L.y_ln + .8*y_ln - .2*F.y_ln - .2*F2.y_ln;
*
*    /*MEDIAN*/;
*    tssmooth nl y_median_# = y, smoother(odd # from 1 to 19);
*        tsline y y_median_#;
*
*    /*HANNING*/;
*    tssmooth nl y_h_# = y, smoother(odd # from 1 to 19 H);
*        tsline y y_h;
*
*        /*OPCIONES*/;
*        *R: repeat filtro hasta que se alcanza convergencia(?)
*        *E: endpoint ajuste a observaciones iniciales, finales, según pendiente y observación de valores extremos
*        *S: split ends cuando encuentra valores repetidos y aplica método diferencial para extensión par/impar Becketti p113
*        *twice: el filtro se aplica una vez a los datos y al residuo. Cualquier resultado encontrado al residuo se agrega al modelo
*
*    /*WMA*/;
*    tssmooth ma y_ma = y, window(l c f);
*        tsline y y_ma;
*
*    tssmooth ma y_wma = y, weights(l c f);
*        tsline y y_wma;
*
*    /*EWMA*/;
*    tssmooth exponential y_ewma = y, parms(\alpha) samp0(muestra para y_0) s0(y_0);
*        tsline y y_ewma;
*
*    /*DEWMA*/;
*    tssmooth dexponential y_dewma = y, parms(\alpha) samp0(muestra para y_0) s0(y_0);
*        tsline y y_ewma;
*
*    /*HOLT-WINTERS*/;
*    /*LINEAR TREND*/;
*    /*NON-SEASONAL*/;
*    tssmooth hwinters y_hw = y, parms(\alpha \beta) samp0(muestra para y_0) s0(cons lt);
*        tsline y y_hw;
*
*    /*HOLT-WINTERS*/;
*    /*LINEAR TREND*/;
*    /*SEASONAL*/;
*    tssmooth shwinters y_hws = y, parms(\alpha \beta \gamma) samp0(muestra para y_0) s0(cons lt) additive;
*        tsline y y_hws;

*********************************************************************;
*** #20 ** EJEMPLO - SIMULACION;
*********************************************************************;

    /*PROGRAM SETUP*/

    pause on
    #delimit ;

    /*PRELIMINAR*/;
    graph drop _all;
    clear;

    /*DEFINIR NUMERO DE OBSERVACIONES*/;
    set obs 365;

    /*DEFINIR VARIABLE DE TIEMPO*/;
    generate time=_n;
    tsset time;

    /*DEFINIR VALOR ALEATOREO INICIAL*/;
    set seed 7890;

    /*GENERAR PROCESO ALEATORIO*/;
    gen e1 = rnormal(0,1);
        label var e1 "e (0,1)";

    /*MODELO AR(1)*/;
    local y1b = 0.99;
    generate y1 = .;
    replace y1 = e1 in 1;
    replace y1 = `y1b' * l.y1 + e1 in 2/l;
        label var y1 "AR(1) (y1 = `y1b' * l.y1 + e1)";

sleep 2000;
        /*MEDIAN & HANNING*/;
        tssmooth nl y1_median3 = y1, smoother(3);
            label var y1_median3 "y1_median3";
            tsline y1 y1_median3, lwidth(thin thick) name(y1_median3, replace);

        tssmooth nl y1_median9 = y1, smoother(9);
            label var y1_median9 "y1_median9";
            tsline y1 y1_median9, lwidth(thin thick) name(y1_median9, replace);

        tssmooth nl y1_9h = y1, smoother(9H);
            label var y1_9h "y1_9h";
            tsline y1 y1_9h, lwidth(thin thick) name(y1_9h, replace);

        /*WMA*/;
        tssmooth ma y1_ma710 = y1, window(7 1 0);
            label var y1_ma710 "y1_ma710";
            tsline y1 y1_ma710, lwidth(thin thick) name(y1_ma710, replace);

        tssmooth ma y1_ma1410 = y1, window(14 1 0);
            label var y1_ma1410 "y1_ma1410";
            tsline y1 y1_ma1410, lwidth(thin thick) name(y1_ma1410);

        tssmooth ma y1_ma28182_we = y1, weights(.2 .8 <1> .8 .2);
            label var y1_ma28182_we "y1_ma28182_we";
            tsline y1 y1_ma28182_we, lwidth(thin thick) name(y1_ma28182_we);

        /*EWMA*/;
        tssmooth exponential y1_ewma08 = y1, parms(.8);
            label var y1_ewma08 "y1_ewma08";
            tsline y1 y1_ewma08, lwidth(thin thick) name(y1_ewma08, replace);

        tssmooth exponential y1_ewma02 = y1, parms(.2);
            label var y1_ewma02 "y1_ewma02";
            tsline y1 y1_ewma02, lwidth(thin thick) name(y1_ewma02);

        /*DEWMA*/;
        tssmooth dexponential y1_dewma02 = y1, parms(.2);
            label var y1_dewma02 "y1_dewma02";
            tsline y1 y1_dewma02, lwidth(thin thick) name(y1_dewma02);

        tssmooth dexponential y1_dewma08 = y1, parms(.8);
            label var y1_dewma08 "y1_dewma08";
            tsline y1 y1_dewma08, lwidth(thin thick) name(y1_dewma08);
            
        /*HOLT-WINTERS*/;
        tssmooth hwinters y1_hw = y1;
            label var y1_hw "y1_hw";
            tsline y1 y1_hw, lwidth(thin thick) name(y1_hw);

        tssmooth shwinters y1_shw = y1;
            label var y1_shw "y1_shw";
            tsline y1 y1_shw, lwidth(thin thick) name(y1_shw);

        tssmooth hwinters y1_hw0501 = y1, parms(.5 .1);
            label var y1_hw0501 "y1_hw0501";
            tsline y1 y1_hw0501, lwidth(thin thick) name(y1_hw0501);

        tssmooth shwinters y1_shw050101 = y1, parms(.5 .1 .1);
            label var y1_shw050101 "y1_shw050101";
            tsline y1 y1_shw050101, lwidth(thin thick) name(y1_shw050101);

aaa

