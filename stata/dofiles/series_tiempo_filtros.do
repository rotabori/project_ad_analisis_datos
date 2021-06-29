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

*    /*MEDIAN*/;
*    tssmooth nl y_median3 = y, smoother(3);
*        tsline y y_median3;
*
*    tssmooth nl y_median9 = y, smoother(9);
*        tsline y y_median9;
*
*    /*HANNING*/;
*    tssmooth nl y_h = y, smoother(h);
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
*    tssmooth hwinters y_ewma = y, parms(\alpha \beta) samp0(muestra para y_0) s0(cons lt);
*        tsline y y_ewma;
*
*    /*HOLT-WINTERS*/;
*    /*LINEAR TREND*/;
*    /*SEASONAL*/;
*    tssmooth shwinters y_ewma = y, parms(\alpha \beta \gamma) samp0(muestra para y_0) s0(cons lt) additive;
*        tsline y y_ewma;

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
        /*MEDIAN*/;
        tssmooth nl y1_median3 = y1, smoother(3);
            label var y1_median3 "y1_median3";
            tsline y1 y1_median3, lwidth(thin thick) name(y1_median3);

        tssmooth nl y1_median9 = y1, smoother(9);
            label var y1_median9 "y1_median9";
            tsline y1 y1_median9, lwidth(thin thick) name(y1_median9);

        /*WMA*/;
        tssmooth ma y1_ma710 = y1, window(7 1 0);
            label var y1_ma710 "y1_ma710";
            tsline y1 y1_ma710, lwidth(thin thick) name(y1_ma710);

        tssmooth ma y1_ma1410 = y1, window(14 1 0);
            label var y1_ma1410 "y1_ma1410";
            tsline y1 y1_ma1410, lwidth(thin thick) name(y1_ma1410);

        /*EWMA*/;
        tssmooth exponential y1_ewma08 = y1, parms(.8);
            label var y1_ewma08 "y1_ewma08";
            tsline y1 y1_ewma08, lwidth(thin thick) name(y1_ewma08);

        tssmooth exponential y1_ewma02 = y1, parms(.2);
            label var y1_ewma02 "y1_ewma02";
            tsline y1 y1_ewma02, lwidth(thin thick) name(y1_ewma02);

        /*DEWMA*/;
        tssmooth dexponential y1_dewma08 = y1, parms(.8);
            label var y1_dewma08 "y1_dewma08";
            tsline y1 y1_dewma08, lwidth(thin thick) name(y1_dewma08);

        tssmooth dexponential y1_dewma02 = y1, parms(.2);
            label var y1_dewma02 "y1_dewma02";
            tsline y1 y1_dewma02, lwidth(thin thick) name(y1_dewma02);

        graph close _all;
        graph combine
            y1_median3
            y1_median9
            y1_ma710
            y1_ma1410
            y1_ewma08
            y1_ewma02
            y1_dewma08
            y1_dewma02
            ,
            cols(2)
            ysize(16)
            xsize(16)
            iscale(*.5)
            ;
