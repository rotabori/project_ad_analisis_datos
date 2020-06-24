* HUNGER GAMES SURVIVAL ANALYSIS
* .do code file for use with Stata (http://stata.com/)
* created by Brett Keller (contact info at http://www.bdkeller.com)
* last updated April 12, 2012

* This .do file hosted as a Google Doc at http://bit.ly/HAnqoY
* Data set and code are made available so that we can all join together to
* defeat Capitol and their evil ways! Unite! (If you use this example / data
* online or for teaching purposes please credit me by linking to the original * post at http://www.bdkeller.com/writing/hunger-games-survival-analysis/)

* Instructions: first, open the Google Docs spreadsheet: http://bit.ly/IZBCCB
* In that Google Doc go to File > Download as > CSV
* Put that file in your Stata working directory and then use this code:



insheet using "..\..\datos\Hunger Games survival analysis data set - Sheet1.csv"

desc

gen failure= 1-winner

stset survival_days, failure(failure)
sts graph, na
*graph save Graph "NA_hazard.gph", replace
ddd
sts test sex, logrank
sts graph, by(sex)
*graph save Graph "KM_sex.gph", replace

sts test career, logrank
sts graph, by(career)
*graph save Graph "KM_career.gph", replace

sts test age, logrank
sts graph, by(age)
graph save Graph "KM_age.gph", replace

sts test alliance, logrank
sts graph, by(alliance)
graph save Graph "KM_alliance.gph", replace

gen age_12to14 = 1 if age<15
replace age_12to14 = 0 if age > 14
gen age_15to16 = 1 if age==15
replace age_15to16 = 1 if age==16
replace age_15to16 = 0 if missing(age_15to16)
gen age_17to18 = 1 if age==17
replace age_17to18 = 1 if age==18
replace age_17to18 = 1 if missing(age_17to18)
gen age_3cat = 0 if age_12to14 == 1
replace age_3cat = 1 if age_15to16 == 1
replace age_3cat = 2 if age == 17
replace age_3cat = 2 if age == 18

sts test age_3cat, logrank
sts graph, by(age_3cat)
*graph save Graph "KM_age3cat.gph", replace

stcox age
stcox age, efron
stcox age, nohr efron

stcox rating
stcox rating, efron

stcox rating_ave, efron
stcox rating_ave, nohr efron

stcox rating_rand, efron
stcox rating_rand, nohr efron

*stcox i.district sex age volunteer career rating_rand alliance, nohr
stcox sex age volunteer career rating_rand alliance, nohr

stcox sex age volunteer career rating_rand, nohr

*stcox i.district sex age volunteer career rating_rand alliance, nohr efron
stcox sex age volunteer career rating_rand alliance, nohr efron

stcox sex age volunteer career rating_rand, nohr efron

*dropping volunteer
stcox sex age career rating_rand, nohr efron

* CONGRATS YOU ARE A NERD!*
