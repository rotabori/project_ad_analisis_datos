** PROJECT: ANALISIS DE DATOS
** PROGRAM: sem.do
** PROGRAM TASK: STRUCTURAL EQUATION MODELING
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2020/03/23
** DATE REVISION 1: 2020/04/07
** DATE REVISION #:

********************************************************************;
** #0
********************************************************************;

** PROGRAM SETUP

    pause on
    #delimit ;
        /*COMMAND LINES WILL ONLY END ONCE SEMICOLON IS FOUND*/;

** #0.1 ** SET PATH FOR READING/SAVING DATA;

********************************************************************;
** #10 ** DATA-IN;
********************************************************************;

********************************************************************;
** #10 ** SEM FACTOR;
********************************************************************;

/*ONE FACTOR CONFIRMATORY FACTOR ANALYSIS*/
    sem (F1 -> y1 y2 y3)

    /*GOODNESS OF FIT*/
        estat gof, stats(all)

    /*STANDARDIZED RESULTS*/
        sem, standardized /*allows checking-contrast with factor analysis using ml*/
                          /*standardized loadings is the correlation between latent and observed variable*/
                          /*standardized error variances are the proportion of variation not explained by lattent*/
                          /*uniqueness*/

/*TWO FACTOR CONFIRMATORY FACTOR ANALYSIS*/
    sem (F1 -> y1 y2 y3) (F2 -> y4 y5 y6)

    /*GOODNESS OF FIT*/
        estat gof, stats(all)

    /*MODIFICATION INDICES*/
        estat mindices

    /*TEST GENERAL SPECIFICATION*/
    sem (F1 -> y1 y2 y3) (F2 -> y4 y5 y6)
        estimates store nocov

    sem (F1 -> y1 y2 y3) (F2 -> y4 y5 y6) cov(e.y1*e.y2*e.y3)
        estimates store covy1y2y3

        lrtest nocov covy1y2y3

    /*TEST COEFFICIENT SPECIFICATION*/
    sem (F1 -> y1 y2 y3) (F2 -> y1 y4 y5 y6)
        estimates store nocov

    test (_b[F1:y1] = _b[F2:r_ses])

********************************************************************;
** #20 ** SEM REGRESSION;
********************************************************************;

/*CALL SEM BUILDER - SEM GRAPHICAL INTERFASE*/
    sembuilder

/*LINEAR REGRESSION MODEL*/
    reg y x1 x2 x3
        reg , beta
    sem (y <- x1 x2 x3)
    sem (x1 x2 x3 -> y)
    sem (x1 -> y) (x2 -> y) (x3 -> y)
        sem , standardized

/*MEDIATION MODEL*/
    sem (x1 -> m) (m -> y) (x1 -> y)
    sem (x1 -> m) (x1 m -> y)

    /*DIRECT AND INDIRECT EFFECTS*/
    /*DIRECT EFFECTS*/
        /*coefficient x1 -> y*/

    /*INDIRECT EFFECTS*/
        /*coefficient x1 -> m * coefficient m -> y*/

    /*TOTAL EFFECT*/ = /*DIRECT EFFECTS + INDIRECT EFFECTS*/
        estat teffects
        estat teffects, nodirect

    /*GOODNESS OF FIT*/
        estat eqgof

    /*WALD TEST ALL COEFFICIENTS ARE = 0*/
        estat eqtest

/*MEDIATION MODEL STANDARDIZED*/
    sem (x1 -> m) (x1 m -> y), standardized

    /*DIRECT AND INDIRECT EFFECTS*/
        estat teffects, standardized

/*TEST COEFFICIENT SPECIFICATION*/
    sem (y1 -> x1 x2 x3) (y2 -> x1 x4 x5 x6)
        estimates store nocov

    test (_b[y1:x1] = _b[y2:x1])

/*PROBIT*/

    gsem (y <- x1 i.x2 x3), logit

    logit y x1 i.x2 x3

/*SUR*/

    sysuse auto

    sem (price <- foreign mpg displacement)  (weight <- foreign length), cov(e.price*e.weight)

    sureg (price foreign mpg displacement) (weight foreign length), isure

********************************************************************;
** #30 ** RESTRICCION;
********************************************************************;

/*RESTRICCION*/
    use http://www.stata-press.com/data/r13/sem_sm1

    sem (r_occasp <- f_occasp r_intel r_ses f_ses) ///
        (f_occasp <- r_occasp f_intel f_ses r_ses), ///
        cov(e.r_occasp*e.f_occasp) standardized

    test (_b[r_occasp:r_ses] = _b[f_occasp:r_ses])

    sem (r_occasp <- f_occasp r_intel r_ses@b1 f_ses) ///
        (f_occasp <- r_occasp f_intel f_ses@b1 r_ses), ///
        cov(e.r_occasp*e.f_occasp)
