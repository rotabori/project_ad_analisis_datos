** PROJECT: ANALISIS DE DATOS
** PROGRAM: series_tiempo_arma.do
** PROGRAM TASK: MANEJO DE FECHA
** AUTHOR: RODRIGO TABORDA
** DATE CREATED: 2020/04/07
** DATE REVISION 1:
** DATE REVISION #:

** #0.1 ** SET PATH FOR READING/SAVING DATA;

    cd ../../;

*********************************************************************;
*** #10 ** TRATAMIENTO DE FECHA;
*********************************************************************;

    display mdy(1,1,1960);
    display hms(0,0,1); /*1 segundo = 1 milisegundo*/;
    display dow(mdy(11,1,2000)); /*0 = Sun, 1 = Mon, 2 = Tues, 3 = Wed, 4 = Thurs, 5 = Fri, 6 = Saturday*/;
    display doy(mdy(11,1,2000)); /*dia del año*/;

*********************************************************************;
*** #20 ** DEFINIR VARIABLE DE TIEMPO;
*********************************************************************;

    /*DEFINIR VARIABLE DE TIEMPO*/;
    generate time=_n;
        tsset time;

    /*DEFINIR VARIABLE DE TIEMPO*/;
    generate date_num = monthly(date,"YM");
        format %tm date_num;
        tsset time;

        /*EXTRAER VARIABLE DE TIEMPO*/;
        generate date_date = dofm(date_num); /*"daily date" is the reference to generate all other*/
            format date_date %d;
        generate date_day = day(date_date);
        generate date_week = week(date_date);
        generate date_month = month(date_date);
        generate date_quarter = quarter(date_date);
        generate date_semester = halfyear(date_date);
        generate date_year = year(date_date);

    /*DEFINIR VARIABLE DE TIEMPO DE DOS VARIABLES*/;
    gen date = yq(year,q);
        format date %tq;
        tsset time;

    gen date = ym(year,month)
        format date %tm;
        tsset time;
