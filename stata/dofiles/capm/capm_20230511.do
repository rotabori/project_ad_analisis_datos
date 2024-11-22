use https://rodrigotaborda.com/ad/data/capm/capm_200109-201904.dta, clear
tsline argos || tsline colcap, yaxis(2)
gen argos_ret_dtf_m = (((argos / l1.argos) - 1) * 100) - dtf_m
gen colcap_ret_dtf_m = (((colcap / l1.colcap) - 1) * 100) - dtf_m
scatter argos_ret_dtf_m colcap_ret_dtf_m
reg argos_ret_dtf_m colcap_ret_dtf_m
scatter argos_ret_dtf_m colcap_ret_dtf_m || lfit argos_ret_dtf_m colcap_ret_dtf_m