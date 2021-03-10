** PROJECT: ANALISIS DE DATOS
** PROGRAM: cluster.do
** PROGRAM TASK: EXECUTE CLUSTER ANALYSIS
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2017/02/05
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

    scatter x2 x1, mlabel(id);

********************************************************************;
** #20 ** CLUSTER SINGLE LINKAGE;
********************************************************************;

    cluster singlelinkage var1 var2, name(cluster_name_sl);
        /*USE EASY TO REMEMBER NAME AND ADD sl AS A SUFFIX FOR single linkage*/;

** #20.1 ** DENDROGRAM;

    cluster dendrogram cluster_name_sl, labels(var_id) xlabel(,angle(45)) name(ddd);
    cluster dendrogram cluster_name_sl, cutnumber(#branches) labels(var_id) xlabel(,angle(45)) showcount name(ddd);
    cluster dendrogram cluster_name_sl, cutvalue(#value) xlabel(,angle(45)) showcount name(ddd);

** #20.2 ** GENERATE VARIABLE SHOWING CLUSTER GROUPS;

    cluster generate cluster_name_sl_g3 = groups(3), name(cluster_name_sl);
    table cluster_name_sl_g3, contents(mean var1 sd var1 n var1) format(%4.2f);
    twoway (scatter var1 var2 if cluster_name_sl_g3 == 1) (scatter var1 var2 if cluster_name_sl_g3 == 2) (scatter var1 var2 if cluster_name_sl_g3 == 3)

********************************************************************;
** #30 ** OTHER CLUSTER ALGORITHMS IN STATA;
********************************************************************;

    cluster completelinkage var1 var2, name(cluster_name_cl);
    /*USE EASY TO REMEMBER NAME AND ADD cl AS A SUFFIX FOR complete linkage*/;

    cluster averagelinkage var1 var2, name(cluster_name_al);
    /*USE EASY TO REMEMBER NAME AND ADD al AS A SUFFIX FOR average linkage*/;

    cluster waveragelinkage var1 var2, name(cluster_name_wl);
    /*USE EASY TO REMEMBER NAME AND ADD wl AS A SUFFIX FOR weighted average linkage*/;

    cluster centroidlinkage var1 var2, name(cluster_name_ctl);
    /*USE EASY TO REMEMBER NAME AND ADD ctl AS A SUFFIX FOR centroid linkage*/;

    cluster wardslinkage var1 var2, name(cluster_name_wdl);
    /*USE EASY TO REMEMBER NAME AND ADD wdl AS A SUFFIX FOR wards linkage*/;

********************************************************************;
** #40 ** COMBINE CLUSTER DENDROGRAM;
********************************************************************;

    graph combine cluster_name_sl cluster_name_cl, ysize(12) xsize(6) ycommon;
    /*COMBINE TWO CLUSTER DENDROGRAM TO SEE DIFERENCES*/;
