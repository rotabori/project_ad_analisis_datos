** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: anscombe.do
** PROGRAM TASK: ANSCOMBE DATA EXAMINATION
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2020/06/14
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

*********************************************************************;
*** #10 ** READ, ORGANIZE DATA;
*********************************************************************;
*
*** #10.1 ** IMPORT DATA;

    import delimited
        data\anscombe\anscombe.csv,
        delimiter(",")
        varnames(1)
        clear
    ;


	
**** #90.9.9 ** GOOD BYE;
*
*    clear;
