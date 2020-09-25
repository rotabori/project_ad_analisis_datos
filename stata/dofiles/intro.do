** PROJECT: ANALISIS DE DATOS
** PROGRAM: intro.do
** PROGRAM TASK: PRELIMINARY BASIC STATA COMMANDS
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2017/08/17
** DATE REVISION 1: 2020/04/07
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

    sysuse filename.dta; /*USE A STATA READY FILE STORED WITHIN STATA*/

    use filename.dta; /*USE A STATA READY FILE STORED SOMEWHERE*/

    import delimited data/covid19_world_`date'.txt /*USE A STATA READY FILE STORED SOMEWHERE*/
        ,
        delimiter(comma)
        encoding(utf8)
        clear
        ;

********************************************************************;
** #20 ** RANDOM USEFUL COMMANDS TO BEGIN;
********************************************************************;

** #20.1 ** FILES;

    cd ../../;
    cd <SOMEWHERE IN YOUR COMPUTER>;
        /*CHANGE DIRECTORY OR WHERE STUFF IS STORED*/

** #20.2 ** EXAMINE / TIDY UP YOUR DATA;

    browse; /*EXPLORE YOUR DATA AS A SPREAD SHEET*/

    edit;   /*EDIT YOUR DATA AS A SPREAD SHEET*/
            /*WARNING: DO NOT CHANGE YOUR DATA USING STATA AS A SPREAD SHEET*/

    describe;   /*SHOWS HOW DATA IS BEING HANDLED BY STATA*/

    list var1;   /*REQUEST var1 DATA TO BE LISTED IN THE OUTPUT WINDOW*/

    list var1 in 1/10;  /*REQUEST YOUR DATA TO BE LISTED IN THE OUTPUT WINDOW*/
                        /*THIS TIME ONLY SHOW OBSERVATIOS 1 TO 10*/

    rename var1 new_var1;  /*RENAME VARIABLE var1 TO sales*/

    label variable var1 "variable label";   /*ATTACH LABEL TO YOUR VARIABLE*/

    drop var1;  /*DELETES var1 AND KEEPS THE REST*/

    keep var1;  /*KEEPS var1 AND DELETES THE REST*/

    generate var10 = var1 + var2;   /*ADDS var1 AND var2 INTO var10*/

    generate var1_sq = var1^2;  /*var1 SQUARED*/
                                /*I SUGGEST YOU NAME VARIABLES KEEPING SOME SORT OF PREFIX SO THEY CAN BE EASILY SORTED, MANIPULATED AND IDENTIFIED*/

    generate var1_ln = ln(var1);    /*var1 NATURAL LOG*/
                                    /*I SUGGEST YOU NAME VARIABLES KEEPING SOME SORT OF PREFIX SO THEY CAN BE EASILY SORTED, MANIPULATED AND IDENTIFIED*/

** #20.3 ** EXPLORE YOUR DATA;

    summarize var1 var2 ... var#;   /*BASIC DESCRIPTIVE STATISTICS*/
    summarize var1 var2 ... var#, detail;   /*DETAILED DESCRIPTIVE STATISTICS*/
    summarize var1 var2 ... var# if var1 == condition, detail;   /*DETAILED DESCRIPTIVE STATISTICS IF var1 MEETS A CONDITON*/

    histogram var1; /*var1 HISTOGRAM*/
    histogram var1, title(Add a title); /*var1 HISTOGRAM + TITLE*/

    twoway scatter var1 var2;   /*var1 (Y AXIS) var2 (X AXIS) SCATTER PLOT*/
    twoway scatter var1 var2, ylabel(0(10)100);     /*var1 (Y AXIS) var2 (X AXIS) SCATTER PLOT* + Y AXIS BEGINS AT 0, ENDS AT 100 AND LABELS EVERY 10*/
    twoway scatter var1 var2, ylabel(0(10)100) xlabel(0(10)100);    /*var1 (Y AXIS) var2 (X AXIS) SCATTER PLOT* + Y AND X AXIS BEGIN AT 0, ENDS AT 100 AND LABELS EVERY 10*/
    twoway scatter var1 var2,
        ylabel(0(10)100) xlabel(0(10)100)
        title(Add a title)
        ;
        /*var1 (Y AXIS) var2 (X AXIS) SCATTER PLOT + Y AND X AXIS BEGIN AT 0, ENDS AT 100 AND LABELS EVERY 10 + */
        /*NOTE WE ARE USING SEVERAL LINES THE COMMAND WILL ONLY END ONCE SEMI-COLON IS FOUND*/
    twoway scatter var1 var2,
        ylabel(0(10)100) xlabel(0(10)100)
        title(Add a title)
        by(var_cat)
        ;
        /*var1 (Y AXIS) var2 (X AXIS) SCATTER PLOT + Y AND X AXIS BEGIN AT 0, ENDS AT 100 AND LABELS EVERY 10 + */
        /*WILL PRODUCE A SCATTER FOR EACH VALUE IN THE CATHEGORICAL VARIABLE var_cat*/
        /*NOTE WE ARE USING SEVERAL LINES THE COMMAND WILL ONLY END ONCE SEMI-COLON IS FOUND*/

** #20.4 ** STATA AS A CALCULATOR;

    display 1 + 1;  /*REQUEST STATA DISPLAY SOMETHING*/
    display "La suma de 1 + 1 es: " 1 + 1;  /*REQUEST STATA DISPLAY SOMETHING*/

    scalar a = 1;    /*STORE IN a THE NUMBER 1*/
    scalar b = 1;    /*STORE IN b THE NUMBER 1*/

    display "La suma de a + b es: " a + b ;  /*REQUEST STATA DISPLAY SOMETHING*/

**** #90.9.9 ** GOOD BYE;
*
*    clear;
