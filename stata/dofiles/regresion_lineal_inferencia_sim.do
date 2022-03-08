** PROJECT: ANALISIS DE DATOS
** PROGRAM: regresion_lineal_inferencia_sim.do
** PROGRAM TASK: SIMULATION INFERENCE ON LINEAR REGRESSION
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2020/08/22
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

    cd ../../;

********************************************************************;
** #5 ** SIMULATION;
********************************************************************;

*    VIDEO BASED ON:
*    https://blog.stata.com/2014/03/24/how-to-create-animated-graphics-using-stata/

** #5.0 ** NUMBER OF REPETITIONS;
    local sim_num = 70;

********************************************************************;
** #10 ** SIMULATION FROM A RANDOM SAMPLE SIZE;
********************************************************************;

** #10.1 ** REGRESSION;

    #delimit ;
    graph drop _all;

    /*LOAD DATA*/;
    use http://www.rodrigotaborda.com/ad/data/pv/pv8387.dta, clear;

    /*GENERATE VARIABLES*/;
    gen ventas_ln = ln(ventas);
        label var ventas_ln "Ventas (Ln)";

    gen publicidad_ln = ln(publicidad);
        label var publicidad_ln "Publicidad (Ln)";

    /*REGRESSION*/;
    reg ventas_ln publicidad_ln;

        local b0: di%3.2f = _b[_cons];
        local b1: di%3.2f = _b[publicidad_ln];
        local b0_se: di%6.4f = _se[_cons];
        local b1_se: di%6.4f = _se[publicidad_ln];
        local sample = _N;

    /*GRAPH*/;
        twoway (
                scatter ventas_ln publicidad_ln
                ,
                text(19 10 "Ventas (ln)    =     `b0'     +     `b1'   *   Publicidad (ln)")
                text(18 10 "(`b0_se')  +  (`b1_se')")
                msize(vsmall)
                ylabel(7(2)20)
                xlabel(0(3)15)
               )
               (
                lfit ventas_ln publicidad_ln
               )
               ,
               title(Original)
               subtitle(Sample: `sample')
               name(original)
               ;
        qui graph export data/inference/original.png, as(png) width(1280) height(720) replace;

** #10.2 ** LOOP;

    /*OPEN LOOP*/;
        postfile postfile_inf sim b0 b1 n using data/inference/postfile_inf_data_sample_random.dta, replace;

    /*OPEN LOOP*/;
        foreach sim of numlist 1/`sim_num' {;

    /*PRESERVE DATA*/;
        preserve;

    /*SUBSAMPLE RANDOM*/
        local sample = round(runiform(1,100));
        qui sample `sample';

    /*REGRESSION*/;
        qui regress ventas_ln publicidad_ln;
        local sample = _N;

        twoway (
                scatter ventas_ln publicidad_ln
                ,
                msize(vsmall)
                ylabel(7(2)19)
                xlabel(0(3)14)
               )
               (
               lfit ventas_ln publicidad_ln
               ,
               title(Sim: `sim')
               subtitle(Sample: `sample')
               )
               ;
        local file = string(`sim', "%03.0f");
        qui graph export data/inference/graph_`file'.png, as(png) width(1280) height(720) replace;
        graph drop Graph;

    /*KEEP REGRESSION RESULT*/;
        post postfile_inf (`sim') (_b[_cons]) (_b[publicidad_ln]) (_N);

    /*RESTORE DATA*/;
        restore;

    /*CLOSE LOOP*/;
    };

    /*CLOSE LOOP*/;
    postclose postfile_inf;

** #10.3 ** EXAMINE RESULTS;

    /*LOAD DATA*/;
    use data/inference/postfile_inf_data_sample_random.dta, clear;

    /*LOAD DATA*/;
    summarize b0 b1 n;

    qui summarize b0;
        local b0_sim: di%3.2f = r(mean);

    qui summarize b1;
        local b1_sim: di%3.2f = r(mean);

    /*HISTOGRAM CONSTANT*/;
    kdensity b0
        ,
        xline(`b0')
            text(0.1 `b0' "`b0'", placement(east))
        xline(`b0_sim', lcolor(green) lpattern(dash))
        title("Constant")
        name(b0)
        ;

    /*HISTOGRAM SLOPE*/;
    kdensity b1
        ,
        xline(`b1')
            text(0.1 `b1' "`b1'", placement(east))
        xline(`b1_sim', lcolor(green) lpattern(dash))
        title("Slope")
        name(b1)
        ;

    /*HISTOGRAM SAMPLE*/;
    hist n
        ,
        width(100)
        frac
        title("Sample")
        xlabel(0(100)1200)
        name(sample)
        ;

    /*COMBINE*/;
    graph combine b0 b1
        ,
        xsize(11)
        iscale(*1.1)
        note(Note: Solid line: OLS. Dashed line: subsampled.)
        name(b0b1)
        ;

    graph combine b0b1 sample
        ,
        cols(1)
        iscale(*1.0)
        name(b0b1n)
        ;

        graph export data/inference/b0b1n_sample_random.png
            ,
            as(png)replace
            ;

    graph close b0 b1 b0b1 sample;

** #10.4 ** CREATE VIDEO;

    capture: erase data/inference/video_sample_random.mpg;
    local graphpath "data/inference/";
*    winexec "C:\rodrigo\software\ffmpeg\ffmpeg\bin\ffmpeg.exe" -i `graphpath'graph_%03d.png -b:v 512k `graphpath'video.mpg;
    winexec "C:\rodrigo\software\ffmpeg\ffmpeg\bin\ffmpeg.exe"
        -i `graphpath'graph_%03d.png
        -filter:v "setpts=6.0*PTS" `graphpath'video_sample_random.mpg;

    /*SLEEP FOR 60 SECONDS*/;
    sleep 60000;

    foreach sim of numlist 1/`sim_num' {;
        local file = string(`sim', "%03.0f");
        capture: erase data/inference/graph_`file'.png;
    };

********************************************************************;
** #20 ** SIMULATION FROM A RANDOM SAMPLE SIZE;
********************************************************************;

** #20.1 ** REGRESSION;

    #delimit ;
    graph drop _all;

    /*LOAD DATA*/;
    use http://www.rodrigotaborda.com/ad/data/pv/pv8387.dta, clear;

    /*GENERATE VARIABLES*/;
    gen ventas_ln = ln(ventas);
        label var ventas_ln "Ventas (Ln)";

    gen publicidad_ln = ln(publicidad);
        label var publicidad_ln "Publicidad (Ln)";

    /*REGRESSION*/;
    reg ventas_ln publicidad_ln;

        local b0: di%3.2f = _b[_cons];
        local b1: di%3.2f = _b[publicidad_ln];
        local b0_se: di%6.4f = _se[_cons];
        local b1_se: di%6.4f = _se[publicidad_ln];
        local sample = _N;

    /*GRAPH*/;
        twoway (
                scatter ventas_ln publicidad_ln
                ,
                text(19 10 "Ventas (ln)    =     `b0'     +     `b1'   *   Publicidad (ln)")
                text(18 10 "(`b0_se')  +  (`b1_se')")
                msize(vsmall)
                ylabel(7(2)20)
                xlabel(0(3)15)
               )
               (
                lfit ventas_ln publicidad_ln
               )
               ,
               title(Original)
               subtitle(Sample: `sample')
               name(original)
               ;
        qui graph export data/inference/original.png, as(png) width(1280) height(720) replace;

** #20.2 ** LOOP;

    /*OPEN LOOP*/;
        postfile postfile_inf sim b0 b1 n using data/inference/postfile_inf_data_sample_20.dta, replace;

    /*OPEN LOOP*/;
        foreach sim of numlist 1/`sim_num' {;

    /*PRESERVE DATA*/;
        preserve;

    /*SUBSAMPLE 20%*/
        local sample = 20;
        qui sample `sample';

    /*REGRESSION*/;
        qui regress ventas_ln publicidad_ln;
        local sample = _N;

        twoway (
                scatter ventas_ln publicidad_ln
                ,
                msize(vsmall)
                ylabel(7(2)19)
                xlabel(0(3)14)
               )
               (
               lfit ventas_ln publicidad_ln
               ,
               title(Sim: `sim')
               subtitle(Sample: `sample')
               )
               ;
        local file = string(`sim', "%03.0f");
        qui graph export data/inference/graph_`file'.png, as(png) width(1280) height(720) replace;
        graph drop Graph;

    /*KEEP REGRESSION RESULT*/;
        post postfile_inf (`sim') (_b[_cons]) (_b[publicidad_ln]) (_N);

    /*RESTORE DATA*/;
        restore;

    /*CLOSE LOOP*/;
    };

    /*CLOSE LOOP*/;
    postclose postfile_inf;

** #20.3 ** EXAMINE RESULTS;

    /*LOAD DATA*/;
    use data/inference/postfile_inf_data_sample_20.dta, clear;

    /*LOAD DATA*/;
    summarize b0 b1 n;

    qui summarize b0;
        local b0_sim: di%3.2f = r(mean);

    qui summarize b1;
        local b1_sim: di%3.2f = r(mean);

    /*HISTOGRAM CONSTANT*/;
    kdensity b0
        ,
        xline(`b0')
            text(0.1 `b0' "`b0'", placement(east))
        xline(`b0_sim', lcolor(green) lpattern(dash))
        title("Constant")
        name(b0)
        ;

    /*HISTOGRAM SLOPE*/;
    kdensity b1
        ,
        xline(`b1')
            text(0.1 `b1' "`b1'", placement(east))
        xline(`b1_sim', lcolor(green) lpattern(dash))
        title("Slope")
        name(b1)
        ;

    /*HISTOGRAM SAMPLE*/;
    hist n
        ,
        width(100)
        frac
        title("Sample")
        xlabel(0(100)1200)
        name(sample)
        ;

    /*COMBINE*/;
    graph combine b0 b1
        ,
        xsize(11)
        iscale(*1.1)
        note(Note: Solid line: OLS. Dashed line: subsampled.)
        name(b0b1)
        ;

    graph combine b0b1 sample
        ,
        cols(1)
        iscale(*1.0)
        name(b0b1n)
        ;

        graph export data/inference/b0b1n_sample_20.png
            ,
            as(png)replace
            ;

    graph close b0 b1 b0b1 sample;

** #20.4 ** CREATE VIDEO;

    capture: erase data/inference/video_sample_20.mpg;
    local graphpath "data/inference/";
*    winexec "C:\rodrigo\software\ffmpeg\ffmpeg\bin\ffmpeg.exe" -i `graphpath'graph_%03d.png -b:v 512k `graphpath'video.mpg;
    winexec "C:\rodrigo\software\ffmpeg\ffmpeg\bin\ffmpeg.exe"
        -i `graphpath'graph_%03d.png
        -filter:v "setpts=6.0*PTS" `graphpath'video_sample_20.mpg;

    /*SLEEP FOR 60 SECONDS*/;
    sleep 60000;

    foreach sim of numlist 1/`sim_num' {;
        local file = string(`sim', "%03.0f");
        capture: erase data/inference/graph_`file'.png;
    };

********************************************************************;
** #80 ** RESULTS TO PDF;
********************************************************************;

** #80.1 ** RESULTS TO PDF;

    putpdf begin;

    putpdf paragraph, halign(center) font(,16);
    putpdf text ("Inference simulation");

    putpdf paragraph;
    putpdf text ("Regression using all data:");

        putpdf paragraph, halign(center);
        putpdf image data/inference/original.png
            ,
            width(10cm)
            ;

    putpdf paragraph;
    putpdf text ("Regression using 20% of the data and `sim_num' repetitions:");

        putpdf paragraph, halign(center);
        putpdf image data/inference/b0b1n_sample_20.png
            ,
            width(10cm)
            ;

    putpdf paragraph;
    putpdf text ("Regression using random percentage of the data and `sim_num' repetitions:");

        putpdf paragraph, halign(center);
        putpdf image data/inference/b0b1n_sample_random.png
            ,
            width(10cm)
            ;

    putpdf save data/inference/inference.pdf, replace;
