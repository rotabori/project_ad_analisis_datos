
*--------------------------------
* Estimating dummy variable model
*--------------------------------

* Open Grunfeld data
    use http://www.principlesofeconometrics.com/poe3/data/stata/grunfeld, clear

* Keep GE and Westinghouse
    keep if (i==3 | i==8)

* examine data
    sort i
    by i: summarize

* pooled regression
    reg inv v k

* separate regressions
    reg inv v k if i==3
    scalar sse_ge = e(rss)
    reg inv v k if i==8
    scalar sse_we = e(rss)

* Create dummy variable
    gen d = (i == 8)
    gen dv = d*v
    gen dk = d*k

* Estimate dummy variable model
    reg  inv d v dv k dk
    test d dv dk

*--------------------------------
* SUR estimation
*--------------------------------
* Open and summarize data
    use http://www.principlesofeconometrics.com/poe3/data/stata/grunfeld2, clear
    summarize

    * SUR
    sureg ( inv_ge  v_ge k_ge) ( inv_we v_we k_we), corr
    test ([inv_ge]_cons = [inv_we]_cons) ([inv_ge]_b[v_ge] = [inv_we]_b[v_we])  ([inv_ge]_b[k_ge] = [inv_we]_b[k_we])

    sureg ( inv_ge  v_ge k_ge) ( inv_we v_we k_we), corr dfk
    test ([inv_ge]_cons = [inv_we]_cons) ([inv_ge]_b[v_ge] = [inv_we]_b[v_we])  ([inv_ge]_b[k_ge] = [inv_we]_b[k_we])

    sureg ( inv_ge  v_ge k_ge) ( inv_we v_we k_we), dfk corr small
    test ([inv_ge]_cons = [inv_we]_cons) ([inv_ge]_b[v_ge] = [inv_we]_b[v_we])  ([inv_ge]_b[k_ge] = [inv_we]_b[k_we])

    log close

*--------------------------------
* Grunfeld Dummy Variable Model
*--------------------------------

* Open Grunfeld data
    use http://www.principlesofeconometrics.com/poe3/data/stata/grunfeld, clear
    summarize
    tabulate i, generate(d)

* Least squares dummy variable model
    reg inv v k d1-d10, noconstant
    scalar sse_u = e(rss)
    scalar df_u = e(df_r)
    scalar sig2u = sse_u/df_u
    test (d1=d2)(d2=d3)(d3=d4)(d4=d5)(d5=d6)(d6=d7)(d7=d8)(d8=d9)(d9=d10)

* Restricted (pooled) model
    reg inv v k
    scalar sse_r = e(rss)
    scalar f = (sse_r - sse_u)/(9*sig2u)
    scalar fc = invFtail(9,df_u,.05)
    scalar pval = Ftail(9,df_u,f)
    di "F test of equal intercepts = " f
    di "F(9,df_u,.95) = " fc
    di "p value = " pval

*--------------------------------
* Grunfeld Within Regression
*--------------------------------

* Sort data and create group means
    sort i
    by i: egen invbar=mean(inv)
    by i: egen vbar=mean(v)
    by i: egen kbar=mean(k)

* Create data in deviations from mean form
    gen invd = inv-invbar
    gen vd = v-vbar
    gen kd = k-kbar

* Estimate Within regression
    regress invd vd kd, noconstant

*--------------------------------
* Grunfeld Fixed Effects
*--------------------------------

* Declare cross section and time series identifiers
    iis i
    tis t

* Automatic fixed effects estimation
    xtreg inv v k, fe
    predict muhat, u

*-------------------------------------
* Microeconometric Panel Fixed Effects
*-------------------------------------

    use http://www.principlesofeconometrics.com/poe3/data/stata/nls_panel, clear
    summarize lwage exper exper2 tenure tenure2 south union black educ

    iis id
    tis year
    list id year lwage educ collgrad black union exper tenure if i<4

    xtreg  lwage exper exper2 tenure tenure2 south union black educ, fe
    xtsum educ
    xttab educ
    xtreg  lwage exper exper2 tenure tenure2 south union, fe

*--------------------------------------
* Microeconometric Panel Random Effects
*--------------------------------------

    use http://www.principlesofeconometrics.com/poe3/data/stata/nls_panel, clear

* declare cross section and time series identifiers
    iis id
    tis year

* random effects
    xtreg  lwage educ exper exper2 tenure tenure2 black south union, re
    estimates store re

* Breusch-Pagan test
    xttest0

* fixed effects estimation
    xtreg  lwage educ exper exper2 tenure tenure2 black south union, fe
    estimates store fe

* Hausman test
    hausman fe re
