*******************************************
*RODRIGO TABORDA 20240515
*MICROECONOMIA FINANCIERA
*MAESTRIA FINANZAS
*******************************************
*CODIGO STATA PARA MANIPULACION SP500
*CAPM
*PORTAFOLIO
*******************************************
*INFORMACIÓN 
*PRECIOS DE ACCIONES EN SP500 (HIGH-LOW-CLOSE)
*INDICE SP500
*MARKET YIELD ON U.S. TREASURY SECURITIES AT 1-YEAR CONSTANT MATURITY, QUOTED ON AN INVESTMENT BASIS, PERCENT, DAILY, NOT SEASONALLY ADJUSTED
*******************************************

*********************************************
***EXTRACCION INFORMACION PARA CALCULO PORTAFOLIO
*********************************************
*use https://rodrigotaborda.com/ad/data/sp500/sp500_dgs1_dgs1mo_weekly.dta, clear
*
*    local a ed
*    local b etr
*    local c duk
*    local d aep
*
*generate `a'_ret_anual = (`a'close / l52.`a'close) - 1
*generate `b'_ret_anual = (`b'close / l52.`b'close) - 1
*generate `c'_ret_anual = (`c'close / l52.`c'close) - 1
*generate `d'_ret_anual = (`d'close / l52.`d'close) - 1
*
*correlate `a'close `b'close `c'close `d'close /*CORRELACION*/
*summarize `a'close `b'close `c'close `d'close /*ESTADÍSTICAS DESCRIPTIVAS*/
*
*correlate `a'_ret_anual `b'_ret_anual `c'_ret_anual `d'_ret_anual /*CORRELACION*/
*summarize `a'_ret_anual `b'_ret_anual `c'_ret_anual `d'_ret_anual /*ESTADÍSTICAS DESCRIPTIVAS*/

*******************************************
*EXTRACCION INFORMACION PARA CALCULO CAPM
********************************************
use https://rodrigotaborda.com/ad/data/sp500/sp500_dgs1_dgs1mo_weekly.dta, clear

    local a pg
    local b ko
    local c pep
    local d cost

generate `a'_ret_anual = ((`a'close / l52.`a'close) - 1)*100
generate `b'_ret_anual = ((`b'close / l52.`b'close) - 1)*100
generate `c'_ret_anual = ((`c'close / l52.`c'close) - 1)*100
generate `d'_ret_anual = ((`d'close / l52.`c'close) - 1)*100
generate sp500_ret_anual = ((sp500 / l52.sp500) - 1)*100

generate `a'_ret_exc = `a'_ret_anual - dgs1
generate `b'_ret_exc = `b'_ret_anual - dgs1
generate `c'_ret_exc = `c'_ret_anual - dgs1
generate `d'_ret_exc = `d'_ret_anual - dgs1
generate sp500_ret_exc = sp500_ret_anual - dgs1

graph twoway (scatter `a'_ret_exc sp500_ret_exc)(lfit `a'_ret_exc sp500_ret_exc), name(a, replace)
graph twoway (scatter `b'_ret_exc sp500_ret_exc)(lfit `b'_ret_exc sp500_ret_exc), name(b, replace)
graph twoway (scatter `c'_ret_exc sp500_ret_exc)(lfit `c'_ret_exc sp500_ret_exc), name(c, replace)
graph twoway (scatter `d'_ret_exc sp500_ret_exc)(lfit `d'_ret_exc sp500_ret_exc), name(d, replace)

regress `a'_ret_exc sp500_ret_exc
regress `b'_ret_exc sp500_ret_exc
regress `c'_ret_exc sp500_ret_exc
regress `d'_ret_exc sp500_ret_exc



