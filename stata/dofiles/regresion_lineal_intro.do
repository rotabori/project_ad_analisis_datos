** PROJECT: ANALISIS DE DATOS
** PROGRAM: regresion_lineal_intro.do
** PROGRAM TASK: LINEAR REGRESSION COMMANDS
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2018/09/04
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

********************************************************************;
** #20 ** LINEAR REGRESSION;
********************************************************************;

** #20.1 ** REGRESSION;

    regress var_y var_x1 var_x#, coeflegend;
    regress, coeflegend

    /*PREDICTED VALUES - RESIDUALS*/
    gen y_hat = _b[_cons] + _b[coef];
    margins , over(var_x1);
    predict y_hat, xb; /*y_hat IS JUST A NAME, CHOSE AN INDICATIVE NAME*/
    predict y_res, residuals; /*y_res IS JUST A NAME, CHOSE AN INDICATIVE NAME*/
        gen y_res02 = y - y_hat; /*y_res IS JUST A NAME, CHOSE AN INDICATIVE NAME*/
                                 /*THIS IS AN ALTERNATIVE WAY TO EXTRACT RESIDUALS*/

** #20.2 ** SCATTER - LINEAR FIT;

    twoway (scatter var_y var_x1) (lfit var_y var_x1) /*PLOT Y AND X VARIABLES + LINEAR FIT OF THE RELATIONSHIP*/
        ,
        ylabel(0(10)100)    /*Y AXIS BEGINS AT 0, ENDS AT 100 AND LABELS EVERY 10*/
        xlabel(0(10)100)    /*Y AXIS BEGINS AT 0, ENDS AT 100 AND LABELS EVERY 10*/
        title(A title of your choice)
        name(scatter_fit)
        ;

    scatter y_res var_x1
        ,
        name(res)
        ;

    graph combine scatter_fit res;

********************************************************************;
** #30 ** LINEAR REGRESSION WITH NON LINEAR EFFECT;
********************************************************************;

** #30.1 ** VARIABLE SQUARED;

    var_x1_sq = var_x1 * var_x1    /*var_1 SQUARED*/

    regress var_y var_x1 var_x1_sq;

********************************************************************;
** #40 ** PREDICTED VALUES;
********************************************************************;

** #40.1 ** FIXED POINT;

    scalar y_hat_# = _b[_cons] + _b[var_x1] * number + _b[var_x2] * number;     /*CHOOSE A SENSIBLE NUMBER*/
    display y_hat_#;

** #40.2 ** VECTOR / VARIABLE;

    gen y_hat = _b[_cons] + _b[var_x1] * var_x1 + _b[var_x2] * var_x2;      /*SAME AS ABOVE USING PREDICT*/

********************************************************************;
** #50 ** OLS ESTIMATION - MATRIX;
********************************************************************;

    clear
    set obs 40

    generate y = rnormal()
    generate x1 = rnormal() + 2 * y
    generate x2 = rnormal() - 1 * y
    gen cons = 1

    graph matrix y x1 x2, half

    mkmat cons x1 x2, matrix(x)
    mkmat y, matrix(y)
    matrix b = inv(x'*x)*(x'*y)
    matrix list b

    reg y x1 x2

    scalar b_cons = b[1,1]
    scalar b_x1 = b[2,1]
    scalar b_x2 = b[3,1]

    gen b_cons = b_cons
    mkmat b_cons, matrix(b_cons)
    mkmat x1, matrix(x1)
    mkmat x2, matrix(x2)

    matrix y_pred = b_cons + b_x1*x1 + b_x2*x2
        svmat y_pred, names(y_pred)

    matrix e_pred = y - y_pred
        svmat e_pred, names(e_pred)
