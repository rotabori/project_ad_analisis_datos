** PROJECT: HERRAMIENTAS DECISIONES
** PROGRAM: credit_rating.do
** PROGRAM TASK: PROBIT LOGIT ORDENADO
** AUTHOR: RODRIGO TABORDA
** DATE CREATEC: 2020/11/02
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

**** #10.1 ** IMPORT DATA;

    /*credit_rating*/;
    frame create credit_rating;
    frame change credit_rating;
    import excel http://www.rodrigotaborda.com/ad/data/credit_rating/credit_rating.xlsx
        ,
        sheet("credit_rating")
        cellrange(B2:G156)
        firstrow
        case(lower)
        ;
    rename sp credit_rating_sp;
    rename moodys credit_rating_moodys;
    rename fitch credit_rating_fitch;
    rename dbrs credit_rating_dbrs;
    rename te credit_rating_te;

    /*gov_debt_gdp*/;
    frame create gov_debt_gdp;
    frame change gov_debt_gdp;
    import excel http://www.rodrigotaborda.com/ad/data/credit_rating/credit_rating.xlsx
        ,
        sheet("gov_debt_gdp")
        cellrange(B2:F175)
        firstrow
        case(lower)
        ;
    keep country last;
    rename last gov_debt_gdp;
        label var gov_debt_gdp "Gov. Debt (% GDP)";

    /*gov_spending_gdp*/;
    frame create gov_spending_gdp;
    frame change gov_spending_gdp;
    import excel http://www.rodrigotaborda.com/ad/data/credit_rating/credit_rating.xlsx
        ,
        sheet("gov_spending_gdp")
        cellrange(B2:F47)
        firstrow
        case(lower)
        ;
    keep country last;
    rename last gov_spending_gdp;
        label var gov_spending_gdp "Gov. Spending (% GDP)";

    /*inflation_core*/;
    frame create inflation_core;
    frame change inflation_core;
    import excel http://www.rodrigotaborda.com/ad/data/credit_rating/credit_rating.xlsx
        ,
        sheet("inflation_core")
        cellrange(B2:F88)
        firstrow
        case(lower)
        ;
    keep country last;
    rename last inflation_core;
        label var inflation_core "Inflation (core)";

    /*gdp_growth*/;
    frame create gdp_growth;
    frame change gdp_growth;
    import excel http://www.rodrigotaborda.com/ad/data/credit_rating/credit_rating.xlsx
        ,
        sheet("gdp_growth")
        cellrange(B2:F187)
        firstrow
        case(lower)
        ;
    keep country last;
    rename last gdp_growth;
        label var gdp_growth "GDP growth";

    /*gdp_pc_ppp*/;
    frame create gdp_pc_ppp;
    frame change gdp_pc_ppp;
    import excel http://www.rodrigotaborda.com/ad/data/credit_rating/credit_rating.xlsx
        ,
        sheet("gdp_pc_ppp")
        cellrange(B2:F185)
        firstrow
        case(lower)
        ;
    keep country last;
    rename last gdp_pc_ppp;
        label var gdp_pc_ppp "GDP (PC - PPP)";

    /*corporate_tax_rate*/;
    frame create corporate_tax_rate;
    frame change corporate_tax_rate;
    import excel http://www.rodrigotaborda.com/ad/data/credit_rating/credit_rating.xlsx
        ,
        sheet("corporate_tax_rate")
        cellrange(B2:F165)
        firstrow
        case(lower)
        ;
    keep country last;
    rename last corporate_tax_rate;
        label var corporate_tax_rate "Corp. tax rate";


    /*GATHER ALL VARIABLES*/;
    frame change credit_rating;

    foreach var in gov_debt_gdp gov_spending_gdp inflation_core gdp_growth gdp_pc_ppp corporate_tax_rate {;
        frlink 1:1 country, generate(linkvar) frame(`var');
        frget `var', from(linkvar);
        drop linkvar;
        };

*** #10.2 ** ORGANIZE DEBT RATING VARIABLE ;

    /*MOODYS*/;
    replace credit_rating_moodys = strtrim(credit_rating_moodys);
    gen credit_rating_moodys_num = .;
        label var credit_rating_moodys_num "Moody's";

        replace credit_rating_moodys_num = 0 if credit_rating_moodys == "C" |
                                            credit_rating_moodys == "Ca" |
                                            credit_rating_moodys == "Caa1" |
                                            credit_rating_moodys == "Caa2" |
                                            credit_rating_moodys == "Caa3"
                                            ;

        replace credit_rating_moodys_num = 1 if credit_rating_moodys == "B1" |
                                            credit_rating_moodys == "B2" |
                                            credit_rating_moodys == "B3" |
                                            credit_rating_moodys == "Ba1" |
                                            credit_rating_moodys == "Ba2" |
                                            credit_rating_moodys == "Ba3" |
                                            credit_rating_moodys == "Baa1" |
                                            credit_rating_moodys == "Baa2" |
                                            credit_rating_moodys == "Baa3"
                                            ;

        replace credit_rating_moodys_num = 2 if credit_rating_moodys == "A1" |
                                            credit_rating_moodys == "A2" |
                                            credit_rating_moodys == "A3" |
                                            credit_rating_moodys == "Aa1" |
                                            credit_rating_moodys == "Aa2" |
                                            credit_rating_moodys == "Aa3" |
                                            credit_rating_moodys == "Caa3" |
                                            credit_rating_moodys == "Aaa"
                                            ;

*********************************************************************;
*** #20 ** ANALYSIS;
*********************************************************************;

    /*credit_rating_moodys_num*/;

    sum credit_rating_moodys_num gov_debt_gdp inflation_core gdp_growth gdp_pc_ppp corporate_tax_rate;
    corr credit_rating_moodys_num gov_debt_gdp inflation_core gdp_growth gdp_pc_ppp corporate_tax_rate;

    reg credit_rating_moodys_num gov_debt_gdp inflation_core gdp_growth gdp_pc_ppp corporate_tax_rate;
    reg credit_rating_moodys_num gov_debt_gdp inflation_core /*gdp_growth*/ gdp_pc_ppp corporate_tax_rate;

    ologit credit_rating_moodys_num gov_debt_gdp inflation_core gdp_growth gdp_pc_ppp corporate_tax_rate;
    ologit credit_rating_moodys_num gov_debt_gdp inflation_core /*gdp_growth*/ gdp_pc_ppp corporate_tax_rate;

        margins, at(inflation_core=(0(5)60)) atmeans predict(outcome(0)) predict(outcome(1)) predict(outcome(2));
            marginsplot, noci name(pr_inflation_core);

        margins, at(gov_debt_gdp=(0(10)200)) atmeans predict(outcome(0)) predict(outcome(1)) predict(outcome(2));
            marginsplot, noci name(pr_gov_debt_gdp);

        margins, at(corporate_tax_rate=(0(5)40)) atmeans predict(outcome(0)) predict(outcome(1)) predict(outcome(2));
            marginsplot, noci name(pr_corporate_tax_rate);

*    /*credit_rating_te*/;
*
*    sum credit_rating_te gov_debt_gdp inflation_core gdp_growth gdp_pc_ppp corporate_tax_rate;
*    corr credit_rating_te gov_debt_gdp inflation_core gdp_growth gdp_pc_ppp corporate_tax_rate;
*
*    reg credit_rating_te gov_debt_gdp inflation_core gdp_growth gdp_pc_ppp corporate_tax_rate;
*    reg credit_rating_te gov_debt_gdp inflation_core /*gdp_growth*/ gdp_pc_ppp corporate_tax_rate;


**** #90.9.9 ** GOOD BYE;
*
*    clear;
