** PROJECT: ANALISIS DE DATOS
** PROGRAM: series_tiempo_finanzas.do
** PROGRAM TASK: MANEJO DE FECHA
** AUTHOR: RODRIGO TABORDA
** DATE CREATED: 2021/06/28
** DATE REVISION 1:
** DATE REVISION #:

********************************************************************;
** #0
********************************************************************;

** PROGRAM SETUP

** INSALL

* freduse       /*FEDERAL RESERVE DATA*/
* getsymbols    /*STATA STOCK DATA*/
* mvport        /*STATA STOCK DATA*/

    pause on
    #delimit ;

*********************************************************************;
*** #10 ** GETSYMBOLS;
*********************************************************************;

*    /*DAILY*/;
*    capture getsymbols
*        BA        /*BOEING*/
*        RCL	   /*ROYAL CARIBBEAN GROUP*/
*        ZM	       /*ZOOM VIDEO COMMUNICATIONS, INC.*/
*        "GC=F"    /*GOLD=FUTURE 2M*/
*        ,
*        yahoo
*        fy(2017)
*        frequency(d)
*        clear
*        ;

*    /*MONTHLY*/;
*    capture getsymbols
*        BA        /*BOEING*/
*        RCL	   /*ROYAL CARIBBEAN GROUP*/
*        ZM	       /*ZOOM VIDEO COMMUNICATIONS, INC.*/
*        "GC=F"    /*GOLD=FUTURE 2M*/
*        ,
*        yahoo
*        fy(2017)
*        frequency(m)
*        ld(28)
*        clear
*        ;

*********************************************************************;
*** #20 ** FREDUSE;
*********************************************************************;

    freduse DTB1YR, clear;

*********************************************************************;
*** #50 ** PORTFOLIO;
*********************************************************************;

    /*DAILY*/;
    capture getsymbols
        BA        /*BOEING*/
        RCL	      /*ROYAL CARIBBEAN GROUP*/
        ZM	      /*ZOOM VIDEO COMMUNICATIONS, INC.*/
        "GC=F"    /*GOLD=FUTURE 2M*/
        ,
        yahoo
        fy(2017)
        frequency(d)
        price(adjclose)
        clear
        ;

        efrontier r_*;

        qui cmline r_*;


*********************************************************************;
*** #20 ** EJEMPLO - SIMULACION;
*********************************************************************;
