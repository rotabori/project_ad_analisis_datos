** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: probit_logit.do
** PROGRAM TASK: PROBIT LOGIT MODEL
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 24/09/2018
** DATE REVISION 1:
** DATE REVISION #:

********************************************************************;
** #0
********************************************************************;

** PROGRAM SETUP

    pause on
    #delimit ;
        /*COMMAND LINES WILL ONLY END ONCE SEMICOLON IS FOUND*/

** #0.1 ** SET PATH FOR READING/SAVING DATA;

********************************************************************;
** #10 ** EXECUTE DATA-IN ROUTINE;
********************************************************************;

    include ee\ee_data_in;

********************************************************************;
** #20 ** ORGANIZAR DATOS PARA ANALISIS;
********************************************************************;

*** #20.1 ** MADRE ESTUDIOS SUPERIORES;

    gen madre_estudio_post = madre_estudio_num>=5 & madre_estudio_num<=6;

*** #20.2 ** PADRE ESTUDIOS SUPERIORES;

    gen padre_estudio_post = padre_estudio_num>=5 & padre_estudio_num<=6;

*** #20.3 ** NUMERO DE HIJOS;

    gen hijos_num = hermanos_nro + 1;

********************************************************************;
** #30 ** DEPORTE;
********************************************************************;

    gen deporte_10 = deporte >= 10;

    gen deporte_8 = deporte >= 8;

********************************************************************;
** #50 ** LPM;
********************************************************************;

*** #50.1 ** ESTUDIOS;

    reg madre_estudio_post hijos_num;

    reg madre_estudio_post hijos_num genero_num;

    reg padre_estudio_post hijos_num;
    reg padre_estudio_post hijos_num genero_num;

*** #50.2 ** DEPORTE 10;

    reg deporte_10 estatura;
    reg deporte_10 estatura genero_num;

    reg deporte_8 estatura;
    reg deporte_8 estatura genero_num;

********************************************************************;
** #60 ** LOGIT;
********************************************************************;

*** #60.1 ** ESTUDIOS = HIJOS;
*** #60.1.1 ** MADRE;

    logit madre_estudio_post hijos_num;
        sum madre_estudio_post hijos_num;

        margins, at(hijos_num=(0(1)10)) atmeans;
            marginsplot;

        mtable, at(hijos_num=(0(1)10)) atmeans;
        mtable, at(hijos_num=(0(1)10)) atmeans estname(P post) statistics(ci);

        mgen, at(hijos_num=(0(1)10)) atmeans stub(madre_p_);
            twoway connected madre_p_pr1 madre_p_hijos_num;

        margins, dydx(hijos_num) at(hijos_num=(0(1)10)) atmeans;
            marginsplot;

*** #60.1.2 ** PADRE;

    logit padre_estudio_post hijos_num;
        sum padre_estudio_post hijos_num;

        margins, at(hijos_num=(0(1)10)) atmeans;
            marginsplot;

        mtable, at(hijos_num=(0(1)10)) atmeans;
        mtable, at(hijos_num=(0(1)10)) atmeans estname(P post) statistics(ci);

        mgen, at(hijos_num=(0(1)10)) atmeans stub(padre_p_);
            twoway connected padre_p_pr1 padre_p_hijos_num;

        margins, dydx(hijos_num) at(hijos_num=(0(1)10)) atmeans;
            marginsplot;

            twoway
                    (rarea madre_p_ul1 madre_p_ll1 padre_p_hijos_num, sort color(gs14))
                    (rarea padre_p_ul1 padre_p_ll1 padre_p_hijos_num, sort color(gs10))
                    (connected madre_p_pr1 padre_p_pr1 padre_p_hijos_num)
                ;

*** #60.2 ** ESTUDIOS = HIJOS GENERO;
*** #60.2.1 ** MADRE;

    logit madre_estudio_post hijos_num i.genero_num;
        sum madre_estudio_post hijos_num genero_num;

        margins, at(hijos_num=(0(1)10) genero_num=(0 1)) atmeans;
            marginsplot;

        mtable, at(hijos_num=(0(1)10) genero_num=(0 1)) atmeans;
        mtable, at(hijos_num=(0(1)10) genero_num=(0 1)) atmeans estname(P post) statistics(ci);

        margins, dydx(hijos_num) at(hijos_num=(0(1)10) genero_num=(0 1)) atmeans;
            marginsplot;

        margins, dydx(*);

*** #60.1.2 ** PADRE;

    logit padre_estudio_post hijos_num genero_num;
        sum padre_estudio_post hijos_num genero_num;

        margins, at(hijos_num=(0(1)10) genero_num=(0 1)) atmeans;
            marginsplot;

        mtable, at(hijos_num=(0(1)10) genero_num=(0 1)) atmeans;
        mtable, at(hijos_num=(0(1)10) genero_num=(0 1)) atmeans estname(P post) statistics(ci);

        margins, dydx(hijos_num) at(hijos_num=(0(1)10) genero_num=(0 1)) atmeans;
            marginsplot;

            twoway
                    (rarea madre_p_ul1 madre_p_ll1 padre_p_hijos_num, sort color(gs14))
                    (rarea padre_p_ul1 padre_p_ll1 padre_p_hijos_num, sort color(gs10))
                    (connected madre_p_pr1 padre_p_pr1 padre_p_hijos_num)
                ;

        margins, dydx(*);

*** #60.3 ** DEPORTE 10;

    logit deporte_10 estatura;
    logit deporte_10 estatura genero_num;

    logit deporte_8 estatura;
    logit deporte_8 estatura genero_num;

********************************************************************;
** #70 ** EXAMPLE USING CREDIT DATA;
********************************************************************;

*https://onlinecourses.science.psu.edu/stat857/node/215;
*probit creditability i.sexmaritalstatus ageyears;
*margins sexm, at(ageyears=(20(5)70)) atmeans noatlegend;
*marginsplot, noci
