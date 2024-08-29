** PROJECT: ANALISIS DE DATOS
** PROGRAM: muestreo.do
** PROGRAM TASK: muestreo
** AUTHOR: RODRIGO TABORDA
** AUTHOR:
** DATE CREATED: 2024/08/28

*********************************************************************;
*** #0 *** PROGRAM SETUP
*********************************************************************;

    pause on
    #delimit ;
    /*COMMAND LINES WILL ONLY END ONCE SEMICOLON IS FOUND*/;

********************************************************************;
** #1 ** DATA-IN;
********************************************************************;

*** #1.0 ** SET DIRECTORY;

    cd ../../../;

*** #1.1 ** IMPORT DATA;

    import delimited
        "https://docs.google.com/spreadsheets/d/1vlhHSErnKs6uIl8oCrHQMqFhAW1hOmdQrR6AkVR7wkQ/pub?output=csv"
        ,
        clear
        ;

*********************************************************************;
*** #2 *** ORGANIZE DATA;
********************************************************************;

*** #2.1 *** RENAME;

    rename marcatemporal                fecha;
    rename fechadenacimientomesdíaaño   fecha_fdn;
    rename mediaestatura                estatura_media;
    rename desviaciónestándarestatura   estatura_sd;
    rename mediapeso                    peso_media;
    rename desviaciónestándarpeso       peso_sd; 
    rename mediagénero                  genero_media;
    rename desviaciónestándargénero     genero_sd;
    rename observacionesestatura        estatura_n;
    rename observacionesgénero          genero_n;
    rename observacionespeso            peso_n;

*** #2.3 *** LABEL AND TIDY DATA;

    label var fecha "Fecha";

*** #2.4 ** GENERAR VARIABLES;

    gen n = _n;
        label var n "Obs.";
        
    tsset n;

*** #2.9 ** ORDER;

    aorder;

    order fecha n;

*** #2.10 ** SAVE;

*    save datos/muestreo/muestreo.dta, replace;

*********************************************************************;
*** #3 *** GRAPHS;
********************************************************************;

    local obs = "5 15 25";
    
    foreach var in estatura peso genero{;
    local graphs "";
        foreach n of local obs{;
            histogram `var'_media if n < `n', width(.25) name(`var'_media_hist_`n');
            histogram `var'_sd if n < `n', width(.1) name(`var'_sd_hist_`n');
            graph combine `var'_media_hist_`n' `var'_sd_hist_`n', title(`var' n=`n') rows(1) name(`var'_`n');
            graph drop `var'_media_hist_`n' `var'_sd_hist_`n';
            local graphs "`graphs' `var'_`n'";
            };
        graph combine `graphs', cols(1) xsize(4.5) ysize(6) xcommon name(`var');
        graph drop `graphs';
        };

