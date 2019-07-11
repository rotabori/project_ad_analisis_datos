** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: anova_manova.do
** PROGRAM TASK: EXECUTE CLUSTER ANALYSIS
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 01/09/2018
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
** #10 ** DATA-IN;
********************************************************************;



********************************************************************;
** #20 ** EXAMINE GROUPS;
********************************************************************;

    tabulate treatment;
    table treatment, contents(mean outcome sd outcome n outcome min outcome max outcome) format(%4.2f);
    graph box outcome, over(treatmen) ylabel(#(#)#);
    graph bar (mean) outcome, over(treatment) ylabel(#(#)#);

    histogram estatura;
    kdensity estatura;

    kdensity estatura
        ,
        addplot(kdensity estatura if genero_num == 0 || kdensity estatura if genero_num == 1)
        legend(row(1) label(1 "Total") label (2 "Hombres") label (3 "Mujeres"))
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

    oneway outcome treatment;
    anova outcome treatment;

** #40.2 ** MULTIPLE;

    anova outcome treatment1 treatment2;
    anova outcome treatment1 treatment2 treatment1#treatment2;

** #40.3 ** MARGINS;

    margins, dydx(treatment);
    marginsplot;
