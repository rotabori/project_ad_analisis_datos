** PROJECT: ANALISIS DE DATOS
** PROGRAM: mv.do
** PROGRAM TASK: MAXIMA VEROSIMILITUD / MAXIMUM LIKELYHOOD
** AUTHOR: RODRIGO TABORDA
** AUTHOR: LAURA PARDO
** DATE CREATEC: 2021/09/06
** DATE REVISION 1:
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
** #10 ** DATA SIMULATION;
********************************************************************;

    local win = 2;
    local draws = 3;
    local ratio = `win' / `draws';

    range p 0 1 100;
        /*CREATES A SEQUENCE ON X FROM 0 TO 1 WITH OBS = 100*/;

    gen l = p^`win' * (1-p)^(`draws'-`win');
        /*LIKELYHOOD BINOMIAL PROCESS*/;
        /*WIN - WIN - LOSE SEQUENCE*/;

        local l = `ratio'^`win'*(1 - `ratio')^(`draws'-`win');

    gen ll = ln(l);
        /*NATURAL LOG LIKELYHOOD BINOMIAL PROCESS*/;
        /*WIN - WIN - LOSE SEQUENCE*/;

        local ll = ln(`l');

********************************************************************;
** #20 ** GRAPHS;
********************************************************************;

/*LIKELYHOOD*/;
    twoway connected l p
        ,
        msize(tiny) title(Likelyhood) xline(`ratio') yline(`l') xlabel(0(.2)1) xmlabel(`ratio',format(%9.3f) angle(0)) name(l);

/*LOG LIKELYHOOD*/;
    twoway connected ll p
        ,
        msize(tiny) title(Nat. Log. Likelyhood) xline(`ratio') yline(`ll') xlabel(0(.2)1) xmlabel(`ratio',format(%9.3f) angle(0)) name(ll);

/*COMBINE*/;
    graph combine l ll, cols(1) ysize(6) note("Binomial process." "Wins: `win'. Draws: `draws'.");
