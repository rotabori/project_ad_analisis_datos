/*REGRESIÓN AUTOREGRESIVA*/
/*DATOS ESTACIONARIOS*/
    use http://www.principlesofeconometrics.com/poe3/data/stata/inflation, clear
    gen tt = ym(year,month)
    tsset tt, monthly

    regress  infln L1.infln L2.infln L3.infln
    predict ehat, residuals
    scalar var = e(rmse)^2
    ac ehat
    more

    #delimit ;
    scalar yhat1 = _b[_cons]+_b[L1.infln]*infln[270]+ _b[L2.infln]*infln[269]+_b[L3.infln]*infln[268];
    scalar yhat2 = _b[_cons]+_b[L1.infln]*yhat1+ _b[L2.infln]*infln[270]+_b[L3.infln]*infln[269];
    scalar yhat3 = _b[_cons]+_b[L1.infln]*yhat2+ _b[L2.infln]*yhat1+_b[L3.infln]*infln[270];
    scalar list yhat1 yhat2 yhat3;

    scalar se1 = sqrt(var);
    scalar se2 = sqrt(var*(1+(_b[L1.infln])^2));
    scalar se3 = sqrt(var*((_b[L1.infln]^2+_b[L2.infln])^2+1+_b[L1.infln]^2));
    scalar list se1 se2 se3;

    #delimit cr

    scalar f1L = yhat1 - 1.969*se1
    scalar f1U = yhat1 + 1.969*se1

    scalar f2L = yhat2 - 1.969*se2
    scalar f2U = yhat2 + 1.969*se2

    scalar f3L = yhat3 - 1.969*se3
    scalar f3U = yhat3 + 1.969*se3

    scalar list f1L f1U f2L f2U f3L f3U

/*DISTRIBUTED LAG MODEL*/
    regress  infln  pcwage L1.pcwage L2.pcwage L3.pcwage
    predict ehat2, residual
    ac ehat2
    more

    scalar IM0 = _b[pcwage]
    scalar IM1 = IM0 + _b[L1.pcwage]
    scalar IM2 = IM1 + _b[L2.pcwage]
    scalar IM3 = IM2 + _b[L3.pcwage]
    scalar list IM0 IM1 IM2 IM3

/*ARDL*/
    regress infln pcwage L1.pcwage L2.pcwage L3.pcwage L1.infln L2.infln
    predict ehat3, residual
    ac ehat3
    more

    scalar b0 = _b[pcwage]
    scalar b1 = _b[L1.infln]*b0+_b[L1.pcwage]
    scalar b2 = _b[L1.infln]*b1+_b[L2.infln]*b0+_b[L2.pcwage]
    scalar b3 = _b[L1.infln]*b2+_b[L2.infln]*b1+_b[L3.pcwage]
    scalar b4 = _b[L1.infln]*b3+_b[L2.infln]*b2
    scalar list b0 b1 b2 b3 b4
