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

    display mdy(1,1,1960); /*Enero 1 de 1960*/;
    display hms(0,0,1); /*1 segundo = 1 milisegundo*/;
    display mdyhms(1,1,1960,0,0,1); /*Segundo 1 de Enero 1 de 1960*/;
    display mdyhms(1,1,1960,12,0,0); /*Hora 12 de Enero 1 de 1960*/;
    display dow(mdy(11,1,2000)); /*0 = Sun, 1 = Mon, 2 = Tues, 3 = Wed, 4 = Thurs, 5 = Fri, 6 = Saturday*/;
    display doy(mdy(11,1,2000)); /*dia del año*/;

*********************************************************************;
*** #20 ** DEFINIR VARIABLE DE TIEMPO;
*********************************************************************;

    /*DEFINIR VARIABLE DE TIEMPO*/;
    set obs 100;
    generate time=_n;
        tsset time;

    /*DEFINIR VARIABLE DE TIEMPO INICIANDO CON FECHA MENSUAL*/;
    generate date_num = monthly(date,"YM");
        format %tm date_num;
        tsset time;

        /*EXTRAER VARIABLE DE TIEMPO*/;
        /*GENERAR VARIABLE FECHA DE REFERENCIA*/;
        /*A PARTIR DE ESTA FECHA SE DEFINE EL RESTO DE VARIABLES DE TIEMPO*/;
        generate date_date = dofm(date_num);
            format %d date_date;

        generate ss = ss(date_date);
            /*generate ss = ss(dofm(date_num))*/;
        generate mm = mm(date_date);
            /*generate mm = mm(dofm(date_num))*/;
        generate hh = hh(date_date);
            /*generate hh = hh(dofm(date_num))*/;
        generate day = day(date_date);
            /*generate day = day(dofm(date_num))*/;
        generate week = week(date_date);
            /*generate week = week(dofm(date_num))*/;
        generate month = month(date_date);
            /*generate month = month(dofm(date_num))*/;
        generate quarter = quarter(date_date);
            /*generate quarter = quarter(dofm(date_num))*/;
        generate semester = halfyear(date_date);
            /*generate semester = halfyear(dofm(date_num))*/;
        generate year = year(date_date);
            /*generate year = year(dofm(date_num))*/;

    /*DEFINIR VARIABLE DE TIEMPO DE VARIABLES SEPARADAS*/;
    gen date = yh(year,semester);
        format date %th;

    gen date = yq(year,quarter);
        format date %tq;

    gen date = ym(year,month);
        format date %tm;

    gen date = yw(year,week);
        format date %tw;

    gen date_mdy = mdy(month,day,year);
        format date %td;

    gen date_mdyhms = mdyhms(month,day,year,hh,mm,ss);
        format date %tc;

    /*LAG, FORWARD, DIFFERENCE*/;

        generate y_l1 = l.y;
        generate y_l2 = l2.y;
        generate y_f1 = f.y;
        generate y_f2 = f2.y;
        generate y_d1 = d.y;
        generate y_g12 = (y - l12.y) / l12.y;

    /*GRAPH TIME WITHIN*/;
        tsline y;
        tsline y if tin(1990m1,1995m12);
