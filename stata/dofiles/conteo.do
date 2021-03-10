** PROJECT: ANALISIS DE DATOS
** PROGRAM: conteo.do
** PROGRAM TASK: COUNT REGRESSION
** AUTHOR: RODRIGO TABORDA
** DATE CREATED: 2017/03/29
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
** #10 ** EXECUTE DATA-IN ROUTINE;
********************************************************************;

** #10.1 ** EXECUTE DATA IN;

    use http://rodrigotaborda.com/ad/data/ee/encuesta_estudiantes_202010_old.dta;

********************************************************************;
** #20 ** DATA VISUALIZATION;
********************************************************************;

*** #20.1 ** HISTOGRAM - KERNEL DENSITY DATA;

    foreach n in avion deporte pelicula zapatos{;
        hist `n', name(`n'_hist) nodraw;
        kdensity `n', name(`n'_kdensity)  title("") nodraw;
        graph combine `n'_hist `n'_kdensity, name(`n') ycommon title(`n');
        };

*** #20.2 ** SIMULATE POISSON DATA;

    preserve;
    set obs 155;
    gen k = _n -1;
        label var k "y = # de eventos";
    drop if _n > 24;
    foreach n in 1 3 6 9 12{;
        gen p_`n' = poissonp(`n',k);
        graph twoway connected p_`n' k,
            ytitle("Probability")
            ylabel(0(.2)0.5)
            xlabel(0(3)25)
            title({&mu} = `n')
            name(p_`n')
            nodraw
            ;
        };
    graph combine p_1 p_3 p_6 p_9 p_12, title(Poisson con diferentes parámetros);
    graph export texto\figuras\poisson_varias_medias.eps, replace;
    restore;

*** #20.3 ** TABLE;

    tabulate avion;
    tabulate deporte;
    tabulate pelicula;
    tabulate zapatos;

********************************************************************;
** #30 ** POISSON REGRESSION;
********************************************************************;

*** #30.1 ** NO EXPLANATORY VARIABLES AVION;

*** AVION;
    sum avion, detail;
    hist avion;

    poisson avion;
        display exp(_b[_cons]);
        margins;

        margins , predict(pr(0)) predict(pr(1)) predict(pr(2)) predict(pr(3)) predict(pr(4));
            marginsplot;

*** PELICULA;
    sum pelicula, detail;

    poisson pelicula;
        display exp(_b[_cons]);
        margins;

        margins , predict(pr(0)) predict(pr(1)) predict(pr(2)) predict(pr(3)) predict(pr(4));
            marginsplot;

*** ZAPATOS;
    sum zapatos, detail;

    poisson zapatos;
        display exp(_b[_cons]);
        margins;

        margins , predict(pr(0)) predict(pr(1)) predict(pr(2)) predict(pr(3)) predict(pr(4));
        marginsplot;

    poisson zapatos i.genero_num;
        margins i.genero_num;
            marginsplot;

        margins, dydx(i.genero_num);
            marginsplot;

        margins i.genero_num, predict(pr(0)) predict(pr(1)) predict(pr(2)) predict(pr(3)) predict(pr(4))
                              predict(pr(5)) predict(pr(6)) predict(pr(7)) predict(pr(8)) predict(pr(9));

        margins , dydx(i.genero_num) predict(pr(0)) predict(pr(1)) predict(pr(2)) predict(pr(3)) predict(pr(4))
                                     predict(pr(5)) predict(pr(6)) predict(pr(7)) predict(pr(8)) predict(pr(9));
            marginsplot, xlabel(,angle(90));

    poisson zapatos i.genero_num edad;
        margins i.genero_num, at(edad=(17(1)27));
            marginsplot, yline(3 3.89);

        margins i.genero_num, predict(pr(0)) predict(pr(1)) predict(pr(2)) predict(pr(3)) predict(pr(4)) atmeans;

        margins , dydx(i.genero_num) predict(pr(0)) predict(pr(1)) predict(pr(2)) predict(pr(3)) predict(pr(4)) atmeans;

    poisson zapatos i.genero_num estatura;

        margins i.genero_num, at(estatura=(150(2)180));
            marginsplot;

        margins i.genero_num, predict(pr(0)) predict(pr(1)) predict(pr(2)) predict(pr(3)) predict(pr(4)) atmeans;

    poisson zapatos i.genero_num estatura edad;

        margins i.genero_num, at(estatura=(150(2)180)) atmeans;
            marginsplot;

        margins i.genero_num, predict(pr(0)) predict(pr(1)) predict(pr(2)) predict(pr(3)) predict(pr(4)) atmeans;

********************************************************************;
** #40 ** OTHER MARGINS;
********************************************************************;

    margins, predict(n) /*NUMBER OF EVENTS*/
    margins, predict(ir) /*INCIDENCE RATE exp(xb)*/
    margins, predict(pr(n)) /*PROBABILITY THAT y=n exp(xb)*/
    margins, predict(pr(a,b)) /*PROBABILITY THAT a<y<b*/
    margins, predict(xb) /*LINEAR PREDICTION*/


**** #90.9.9 ** GOOD BYE;
*
*    clear;
