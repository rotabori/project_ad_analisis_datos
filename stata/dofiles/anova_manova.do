** PROJECT: ANALISIS DE DATOS
** PROGRAM: anova_manova.do
** PROGRAM TASK: ANOVA ANALYSIS
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2018/09/01
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
** #10 ** DATA-IN;
********************************************************************;



********************************************************************;
** #20 ** EXAMINE GROUPS CASE ONE TREATMENT ONE OUTCOME;
********************************************************************;

    tabulate treatment;
    table treatment, contents(mean outcome sd outcome n outcome min outcome max outcome) format(%4.2f);
    graph box outcome, over(treatment1) over(treatment2) ylabel(#(#)#);
    graph bar (mean) outcome, over(treatment) ylabel(#(#)#);

    histogram outcome;
    kdensity outcome;

    sum outcome if treatment == 0;
        local treatment_0: di%3.2f = r(mean);

    sum outcome if treatment == 1;
        local treatment_1: di%3.2f = r(mean);

    sum outcome;
        local outcome: di%3.2f = r(mean);

    kdensity outcome
        ,
        addplot(kdensity outcome if treatment == 0 || kdensity outcome if treatment == 1)
        legend(row(1) label(1 "All") label(2 "Treatment 0") label(3 "Treatment 1"))
        xline(`outcome')
        xline(`treatment_0')
        xline(`treatment_1')
        ;

    /*EXAMPLE GENDER - HEIGHT UANDES STUDENTS*/;

    use http://rodrigotaborda.com/ad/data/ee/encuesta_estudiantes_202010_old.dta;

    histogram estatura;
    kdensity estatura;

    sum estatura if genero_num == 0;
        local estatura_0: di%3.2f = r(mean);

    sum estatura if genero_num == 1;
        local estatura_1: di%3.2f = r(mean);

    sum estatura;
    local estatura: di%3.2f = r(mean);

    kdensity estatura
        ,
        addplot(kdensity estatura if genero_num == 0 || kdensity estatura if genero_num == 1)
        legend(row(1) label(1 "Total") label(2 "Hombres") label(3 "Mujeres"))
        xline(`estatura')
        xline(`estatura_0')
        xline(`estatura_1')
        ;

    /*THIS EXAMPLE IS RESTRICTED TO OUR STUDENTS SURVEY*/;
    /*PLOTS CONTINUOUS DENSITY OF HIGH FOR ALL, FEMALE AND MALE STUDENTS*/;
    /*STILL USEFUL IF YOU WANT TO SEE THE DISTRIBUTION OF A VARIABLE AMONG TWO CHARACTERISTICS OR TREATMENTS*/;

********************************************************************;
** #30 ** T-TEST MEAN;
********************************************************************;

    ttest outcome, by(treatment);

********************************************************************;
** #40 ** ANOVA;
********************************************************************;

** #40.1 ** SINGLE;

    oneway outcome i.treatment, tabulate bonferroni;
    anova outcome i.treatment;
    regress outcome i.treatment;

** #40.2 ** MULTIPLE;

    anova outcome i.treatment1 i.treatment2;
    anova outcome i.treatment1 i.treatment2 i.treatment1#i.treatment2;

    manova outcome1 outcome2 = i.treatment1;

** #40.3 ** MARGINS & CONTRAST;

    anova outcome i.treatment1;

    margins i.treatment;
        marginsplot;

    margins, dydx(i.treatment);
        marginsplot;

    contrast, r.treatment;

    margins i.treatment, pwcompare;
        pwcompare i.treatment;
