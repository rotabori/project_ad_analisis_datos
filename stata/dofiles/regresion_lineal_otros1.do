** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: regresion_lineal_otros1.do
** PROGRAM TASK: RESET TEST, COLINEARITY AND DUMMY EXPLANATORY VARIABLES
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



********************************************************************;
** #20 ** RESET TEST;
********************************************************************;

    regress y x1 x2
    predict y_hat, xb
    gen y_hat2 = y_hat^2
    gen y_hat3 = y_hat^3
    regress y x1 x2 y_hat2
        test y_hat2
    regress y x1 x2 y_hat2 y_hat3
        test y_hat2 y_hat3

********************************************************************;
** #30 ** COLINEARITY TEST / VIF;
********************************************************************;

    regress y x1 x2
        scalar r1 = e(r2)
    regress y x1 x3
        scalar r2 = e(r2)
    regress y x2 x3
        scalar r3 = e(r2)
    regress y x1 x2
        estat vif

********************************************************************;
** #40 ** DUMMY / CATHEGORICAL VARIABLES / INTERACTION;
********************************************************************;

    tabulate x1, gen(x1_d)
    gen x2_x1 = x2*x1_d1

    reg y x1 x2 x2_x1
        test x2_x1

        lincom _const + x1
        lincom x2 + x2_x1

** #40.3 ** MARGINS;

    reg y x1;
    margins, over(x1);
        marginsplot;
    margins, at(x1=(#(#)#))
        marginsplot;

    reg y x1 i.x2;
    margins, over(x1 i.x2);
        marginsplot;
    margins, over(i.x2) at(x1=(#(#)#));
        marginsplot;
    margins i.x2, at(x1=(#(#)#));
        marginsplot;

    reg y i.x1

    reg y x1 x2 i.x1#c.x2

    reg y i.x1##c.x2
        margins, dydx(x2) at(x1=0)
        margins, dydx(x2) at(x1=1)
        margins, dydx(i.x1) at(x2=(#(#)#))
            marginsplot

    reg y i.x1##c.x2
        margins, over(x2)

    reg y i.x1#c.x2
        margins, over(x2)

    reg y i.x1 c.x2
        margins, over(x2)
        margins x1, at(x2=(#(#)#))

********************************************************************;
** #50 ** UNITS / LOGS;
********************************************************************;
