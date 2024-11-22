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

*******************************************
*EXTRACCION INFORMACION PARA CALCULO PORTAFOLIO
*PFIZER - BAXTER - LAS VEGAS SANDS
use https://rodrigotaborda.com/ad/data/sp500/sp500_dgs1_dgs1mo_weekly.dta, clear
generate pfe_ret_anual = (pfeclose / l52.pfeclose) - 1
generate bax_ret_anual = (baxclose / l52.baxclose) - 1
generate lvs_ret_anual = (lvsclose / l52.lvsclose) - 1
correlate pfeclose baxclose lvsclose /*CORRELACION*/
summarize pfeclose baxclose lvsclose /*ESTADÍSTICAS DESCRIPTIVAS*/
summarize pfe_ret_anual bax_ret_anual lvs_ret_anual /*ESTADÍSTICAS DESCRIPTIVAS*/

*******************************************
*EXTRACCION INFORMACION PARA CALCULO CAPM
*PFIZER - BAXTER - LAS VEGAS SANDS
use https://rodrigotaborda.com/ad/data/sp500/sp500_dgs1_dgs1mo_weekly.dta, clear
generate pfe_ret_anual = ((pfeclose / l52.pfeclose) - 1)*100
generate bax_ret_anual = ((baxclose / l52.baxclose) - 1)*100
generate lvs_ret_anual = ((lvsclose / l52.lvsclose) - 1)*100
generate sp500_ret_anual = ((sp500 / l52.sp500) - 1)*100

generate pfe_ret_exc = pfe_ret_anual - dgs1
generate bax_ret_exc = bax_ret_anual - dgs1
generate lvs_ret_exc = lvs_ret_anual - dgs1
generate sp500_ret_exc = sp500_ret_anual - dgs1

graph twoway (scatter pfe_ret_exc sp500_ret_exc)(lfit pfe_ret_exc sp500_ret_exc), name(a, replace)
graph twoway (scatter bax_ret_exc sp500_ret_exc)(lfit bax_ret_exc sp500_ret_exc), name(b, replace)
graph twoway (scatter lvs_ret_exc sp500_ret_exc)(lfit lvs_ret_exc sp500_ret_exc), name(c, replace)

regress pfe_ret_exc sp500_ret_exc
regress bax_ret_exc sp500_ret_exc
regress lvs_ret_exc sp500_ret_exc



