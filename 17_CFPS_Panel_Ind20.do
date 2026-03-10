version 15

/**======================================================**
**            Information of Family Members             **
**======================================================**

    use "$f_raw_2014_famconf", clear
    duplicates drop pid, force
    gen nchild = 0
    foreach var of varlist code_a_c* {
        replace nchild = nchild+1 if `var'>=0 & `var'!=.
    }
    keep pid tb1y_a_s tb4_a14_s tb4_a14_f tb4_a14_m
    save "$f_out_fammember14", replace
*/
**========================================**
**            CFPS 2020 Child             **
**========================================**

    use "$f_raw_2020_childproxy", clear

    foreach wave in 10 12 14 16 18 {
        merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", nogen keep(master match)
    }
    
**********************************
* Part0. Identifiers
**********************************

    mvdecode pid fid20 countyid20 provcd20 cyear cmonth subsample, mv(-10/-1)
    
* Individual ID / 个人ID
    clonevar a_pid = pid
    
* Family ID / 家庭ID
    clonevar a_fid = fid20

* Community ID / 社区ID
    *clonevar a_cid = cid20

* County ID / 区县ID
    clonevar a_countyid = countyid20

* Province Code / 省代码
    gen a_provcd = provcd20

* Wave ID / 调查轮次
    gen a_wave = 20
    
* Survey Year / 问卷调查年
    gen a_syear = cyear
    
* Survey Year / 问卷调查月
    gen a_smonth = cmonth

* Questionnaire Type / 问卷类别
    gen a_qtype = 0
    
* Interviewer ID / 访员ID
    *clonevar a_interviewerid = interviewerid

* Weight_National / 个人权重-全国样本
    *clonevar a_rswt_nat = rswt_natcs14

* Weight_Resample / 个人权重-全国再抽样样本
    *clonevar a_rswt_res = rswt_rescs14

* Weight_National_Panel / 个人权重-全国样本
    *clonevar a_rswt_nat_p = rswt_natpn1014

* Weight_Resample_Panel / 个人权重-全国再抽样样本
    *clonevar a_rswt_res_p = rswt_respn1014

* Resample / 是否在全国再抽样样本中
    clonevar a_resample = subsample

**********************************
* Part1. Basic Demographics
**********************************  
    
*  Birth year / 出生年
    gen a_birthy = ibirthy_update if ibirthy_update > 0
    
*  Age in Survey Year / 年龄（调查年）
    gen a_age = 2020-a_birthy

*  Gender / 性别
    gen a_gender = gender_update if gender_update >= 0

* Ethnicity / 民族
    gen a_ethnicity = wa701code if wa701code > 0
    foreach wave in 18 16 14 12 10 {
        replace a_ethnicity = ethnicity_`wave' if a_ethnicity == .
    }

* Han / 汉族
    gen a_han = a_ethnicity==1
    replace a_han = . if a_ethnicity == .

*  Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban = urban20 if urban20 >= 0
    foreach wave in 18 16 14 12 10 {
        replace a_urban = urban_`wave' if a_urban == .
    }

*  Hukou / 户口
    recode wa301 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)
    foreach wave in 18 16 14 12 10 {
        replace a_hukou = hukou_`wave' if a_hukou == .
    }

    
*  Hukou (Province) / 户口所在省
    gen a_hkprov = wa302a_code if wa302a_code > 0
    foreach wave in 18 16 14 12 10 {
        replace a_hkprov = hkprov_`wave' if a_hkprov == . 
    }
    
/**********************************
* Part2. Education
**********************************  

* Highest Educational Level Attained / 最高学历
    gen a_edu = cfps2014edu if cfps2014edu > 0
     foreach wave in 12 10 {
        replace a_edu = edu_`wave' if a_edu == .
    }

* Highest Educational Level Attend / 在读/离校阶段
    gen a_sch = cfps2014sch if cfps2014sch > 0
    foreach wave in 12 10 {
        replace a_sch = sch_`wave' if a_sch == .
    }
* Years of Education Received / 教育年限
    gen a_eduy = cfps2014eduy if cfps2014eduy >= 0
    foreach wave in 12 10 {
        replace a_eduy = eduy_`wave' if a_eduy == .
    }

* Years of Education Received (Imputation) / 教育年限（插补值）
    gen a_eduy_im = cfps2014eduy_im if cfps2014eduy_im >= 0
    foreach wave in 12 10 {
        replace a_eduy_im = eduy_im_`wave' if a_eduy_im == .
    }


**********************************
* Part5. Family Socioecnomic Status     
**********************************      

* Birthplace (Province) / 出生省份
    gen a_birthprov = wa107m_3code if wa107m_3code > 0
    replace a_birthprov = provcd14 if a_birthprov==.
    foreach wave in 12 10 {
        replace a_birthprov = birthprov_`wave' if a_birthprov == .
    }

* Residence (Province) When R in Adolescence / 青少年时居住省份
    gen a_yresprov = provcd14 if provcd14 > 0
    foreach wave in 12 10 {
        replace a_yresprov = yresprov_`wave' if a_yresprov == .
    }
    
* Hukou When R in Adolescence / 青少年时户口
    recode wa4 (1=0) (3=1) (5 79=2) (else=.), gen(a_yhukou)
    foreach wave in 12 10 {
        replace a_yhukou = yhukou_`wave' if a_yhukou == .
    }
    
* Number of Siblings / 兄弟姐妹数
    gen a_nsib = .
    foreach wave in 12 10 {
        replace a_nsib = nsib_`wave' if a_nsib==.
    }   

* Father's Highest Educational Level Attained / 父亲最高学历
* Mother's Highest Educational Level Attained / 母亲最高学历
    gen a_fedu = tb4_a14_f if tb4_a14_f >= 0
    foreach wave in 12 10 {
        replace a_fedu = fedu_`wave' if a_fedu == .
    }
    gen a_medu = tb4_a14_m if tb4_a14_m >=0
    foreach wave in 12 10 {
        replace a_medu = medu_`wave' if a_medu == .
    }

* Father's Occupation (ISCO88) / 父亲职业（ISCO88）
* Mother's Occupation (ISCO88) / 母亲职业（ISCO88）
    gen a_focctype_isco = .
    foreach wave in 12 10 {
        replace a_focctype_isco = focctype_isco_`wave' if a_focctype_isco == .
    }
    gen a_mocctype_isco = .
    foreach wave in 12 10 {
        replace a_mocctype_isco = mocctype_isco_`wave' if a_mocctype_isco == .
    }

* Father's Occupation ISEI / 父亲职业ISEI
* Mother's Occupation ISEI / 母亲职业ISEI
    iskoisei a_foccisei, isko(a_focctype_isco)
    iskoisei a_moccisei, isko(a_mocctype_isco)

* Whether Father's a CCP Member
* Whether Mother's a CCP Member
    gen a_fccp = .
    foreach wave in 12 10 {
        replace a_fccp = fccp_`wave' if a_fccp == .
    }
    gen a_mccp = .
    foreach wave in 12 10 {
        replace a_mccp = mccp_`wave' if a_mccp == .
    }

* Father's ID / 父亲ID
* Mother's ID / 母亲ID
    clonevar a_pid_f = pid_f if pid_f >= 0
    replace a_pid_f = fid14*1000 + code_a_f if code_a_f>0 & a_pid_f == .
    foreach wave in 12 10 {
        replace a_pid_f = pid_f_`wave' if a_pid_f == .
    }
    clonevar a_pid_m = pid_m if pid_m >=0
    replace a_pid_m = fid14*1000 + code_a_m if code_a_m>0 & a_pid_m == .
    foreach wave in 12 10 {
        replace a_pid_m = pid_m_`wave' if a_pid_m == .
    }
    
**********************************
* Part6. Cognitive/Non-cognitive/Language Abilities         
**********************************      

* Original Score for Word Test / 字词测试原始得分
    gen a_word = wordtest14 if wordtest14 >= 0
    
* Original Score for Math Test / 数学测试原始得分   
    gen a_math = mathtest14 if mathtest14 >= 0

* Comprehension Ability (Interviewer Grading) / 理解能力（访员打分）
    gen a_comprehend_ir = kz201_b_2 if kz201_b_2 > 0

* Intelligence Level (Interviewer Grading) / 智力水平（访员打分）
    gen a_intelligence_ir = kz207_b_2 if kz207_b_2 > 0
    
* Interpersonal Skills (Interviewer Grading) / 待人接物水平（访员打分） 
    gen a_interperson_ir = kz208_b_2 if kz208_b_2 > 0

* Language Competence (Interviewer Grading) / 语言表达能力（访员打分）
    gen a_language_ir = kz212_b_2 if kz212_b_2 > 0
    
* Mandarin Proficiency (Interviewer Grading) / 普通话熟练程度（访员打分）
    gen a_mandarin_ir = kz205_b_2 if kz205_b_2 > 0
*/
**********************************
* Save Data Temporarily
**********************************      

*  Keep Generated Variables
    keep a_*
    
*  Rename Variables for later Usage
    rename a_* *_20
    rename pid_20 pid
    
*  Save Data for Later Usage
    sort pid
    save "$data_gen/cfps20_ind.dta", replace

    
**========================================**
**            CFPS 2020 Adult             **
**========================================**

    use "$f_raw_2020_person", clear
/*
    merge 1:1 pid using "$f_raw_2018_crossyearid", ///
        keep(master match) nogen replace update ///
        keepusing(birthy gender ethnicity subsample fid14 marriage_14 cfps2014edu cfps2014sch cfps2014eduy cfps2014eduy_im urban14 hk14)

    merge 1:1 pid using "$f_out_fammember14", keep(master match) nogen replace update
*/
    foreach wave in 10 12 14 16 18 {
        merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", nogen keep(master match)
    }
    
**********************************
* Part0. Identifiers
**********************************

    mvdecode pid fid20 countyid20 provcd20 cyear cmonth subsample, mv(-10/-1)

* Individual ID / 个人ID
    clonevar a_pid = pid

* Family ID / 家庭ID
    clonevar a_fid = fid20

* Community ID / 社区ID
    *clonevar a_cid = cid20

* County ID / 区县ID
    clonevar a_countyid = countyid20

* Province Code / 省代码
    gen a_provcd = provcd20

* Wave ID / 调查轮次
    gen a_wave = 20

* Survey Year / 问卷调查年
    gen a_syear = cyear

* Survey Year / 问卷调查月
    gen a_smonth = cmonth

* Questionnaire Type / 问卷类别
    gen a_qtype = 1

* Interviewer ID / 访员ID
    *clonevar a_interviewerid = interviewerid

* Weight_National / 个人权重-全国样本
    *clonevar a_rswt_nat = rswt_natcs14

* Weight_Resample / 个人权重-全国再抽样样本
    *clonevar a_rswt_res = rswt_rescs14

* Weight_National_Panel / 个人权重-全国样本
    *clonevar a_rswt_nat_p = rswt_natpn1014

* Weight_Resample_Panel / 个人权重-全国再抽样样本
    *clonevar a_rswt_res_p = rswt_respn1014

* Resample / 是否在全国再抽样样本中
    clonevar a_resample = subsample

**********************************
* Part1. Basic Demographics
**********************************  

*  Birth year / 出生年
    gen a_birthy = birthy if birthy > 0
    replace a_birthy = ibirthy_update if a_birthy==. & ibirthy_update > 0
    foreach wave in 18 16 14 12 10 {
        replace a_birthy = birthy_`wave' if a_birthy == .
    }

*  Age in Survey Year / 年龄（调查年）
    gen a_age = 2020-a_birthy

*  Gender / 性别
    gen a_gender = gender if gender >= 0
    replace a_gender = gender_update if a_gender == . & gender_update >= 0
    foreach wave in 18 16 14 12 10 {
        replace a_gender = gender_`wave' if a_gender == .
    }

* Ethnicity / 民族
    gen a_ethnicity = qa701code if qa701code >= 0
    foreach wave in 18 16 14 12 10 {
        replace a_ethnicity = ethnicity_`wave' if a_ethnicity == .
    }

* Han / 汉族
    gen a_han = a_ethnicity==1
    replace a_han = . if a_ethnicity == .

*  Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban = urban20 if urban20 >= 0
    foreach wave in 18 16 14 12 10 {
        replace a_urban = urban_`wave' if a_urban == .
    }

*  Hukou / 户口
    recode qa301 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)
    foreach wave in 18 16 14 12 10 {
        replace a_hukou = hukou_`wave' if a_hukou == .
    }

*  Hukou (Province) / 户口所在省
    gen a_hkprov = qa302a_code if qa302a_code > 0
    replace a_hkprov = a_provcd if a_hkprov==. & inlist(qa302, 1,2,3,4,5)
    foreach wave in 18 16 14 12 10 {
        replace a_hkprov = hkprov_`wave' if a_hkprov == . 
    }
    
**********************************
* Part2. Education
**********************************  

* Highest Educational Level Attained / 最高学历
    gen a_edu = cfps2020edu if cfps2020edu > 0
     foreach wave in 18 16 14 12 10 {
        replace a_edu = edu_`wave' if a_edu == .
    }

* Highest Educational Level Attend / 在读/离校阶段
    gen a_sch = cfps2020sch if cfps2020sch > 0
    foreach wave in 18 16 14 12 10 {
        replace a_sch = sch_`wave' if a_sch == .
    }
* Years of Education Received / 教育年限
    gen a_eduy = cfps2020eduy if cfps2020eduy >= 0
    foreach wave in 18 16 14 12 10 {
        replace a_eduy = eduy_`wave' if a_eduy == .
    }

* Years of Education Received (Imputation) / 教育年限（插补值）
    gen a_eduy_im = cfps2020eduy_im if cfps2020eduy_im >= 0
    foreach wave in 18 16 14 12 10 {
        replace a_eduy_im = eduy_im_`wave' if a_eduy_im == .
    }

/* Highest Educational Level Attained / 最高学历
    gen a_edu = .
    replace a_edu = 1 if inlist(qc3, 0,1,2,10)
    replace a_edu = qc3-2 if inlist(qc3, 3,4,5,6,8,9)
    replace a_edu = 4 if qc3 == 7

    replace a_edu = w01-1 if inlist(w01, 3,4,5,6,7,8,9)
    replace a_edu = 1 if inlist(w01, 0, 1,2,10)

    forvalues i=1/7 {
        replace a_edu = `i' if kw1004_b_`i' == 5
    }
    replace a_edu = 4 if kw1004_b_5 == 0

    foreach wave in 16 14 12 11 10 {
        replace a_edu = edu_`wave' if a_edu == .
    }
*/
    
* Field of Study of the Highest Degree / 最高学历专业
    gen a_major = .
    foreach var in qs701_b_1code kw1003_b_1code qs9code kw1003_b_2code kw1003_b_3code kw1003_b_4code {
        replace a_major = `var' if `var'>0
    }
    foreach wave in 18 16 14 12 10 {
        replace a_major = major_`wave' if a_major == .
    }

* College Type / 本科学校类型
    gen a_collegetype = .
    foreach wave in 18 16 14 12 10 {
        replace a_collegetype = collegetype_`wave' if a_collegetype == .
    }
    
**********************************
* Part3. Labor Market Outcomes
**********************************      

* Labor Market Participation / 经济活动情况
    gen a_employ = employ if employ >= 0

* Current Occupation Employment Status / 当前职业就业身份
    recode jobclass_base (3/5=1) (2=2) (1=3) (else=.), gen(a_employs)
    
/* Current Occupation Type (ISCO88/08) / 当前职业（ISCO88/08）
    csco2isco_cfps a_occtype_isco, csco(qg303code)
    replace a_occtype_isco = . if a_occtype_isco < 0 
*/
* Current Occupation (10 Categories) / 当前职业（10类）
    gen a_occtype_crude = qg303code_g if qg303code_g > 0
    
/* Current Occupation ISEI / 当前职业ISEI
    csco2isei_cfps a_occisei, csco(qg303code)
    replace a_occisei = . if a_occisei < 0 
        
* Current Occupation Industry / 当前职业所在行业
    gen a_industry = qg302code if qg302code > 0 & qg302code != 99
    replace a_industry = 1 if inlist(jobclass, 1,3)
*/
* Current Occupation Organization Type / 当前职业所在机构类型 
    // For employed only
    gen a_orgtype = .
    replace a_orgtype = 1 if qg2 == 1
    replace a_orgtype = 2 if qg2 == 2
    replace a_orgtype = 3 if qg2 == 3
    replace a_orgtype = 4 if inlist(qg2, 4,6)
    replace a_orgtype = 5 if qg2 == 5
    replace a_orgtype = 6 if qg2 == 7
    replace a_orgtype = 7 if qg2 == 8
    
* Got Promoted Last Year (Excutive Position) / 去年是否获得行政职务晋升
* Got Promoted Last Year (Technical Position) / 去年是否获得技术职称晋升
    recode qg15 (1 3=1) (2 78=0) (else=.), gen(a_promote_e)
    recode qg15 (2 3=1) (1 78=0) (else=.), gen(a_promote_t)

* Administrative Management Position / 行政管理职务
    recode qg1401code (0=0) (1/2=1) (3/4=2) (5/6=3) (7/8=4) (else=.), gen(a_mngpos)
    replace a_mngpos = 0 if qg14 == 0

* Number of Subordinates / 负责管理人数
    gen a_subnum = qg1701 if qg1701 >= 0
    replace a_subnum = 0 if qg17 == 0
        
* Satisfaction for Current Occupation's Income / 对目前工作收入的满意度
* Satisfaction for Current Occupation's Safety / 对目前工作安全性的满意度
* Satisfaction for Current Occupation's Working Environment / 对目前工作环境的满意度
* Satisfaction for Current Occupation's Working Hours / 对目前工作时间的满意度
* Satisfaction for Current Occupation's Chance of Promotion / 对目前工作晋升机会的满意度
* Overall Satisfaction for Current Occupation / 对目前工作的总体满意度
    local type inc safe env wkh prom all
    forvalues i = 1/6 {
        local j: word `i' of `type'
        gen a_wksat_`j' = qg40`i' if qg40`i' >0
    }
    
* Tenure of Current Occupation / 当前职业工龄
    foreach var in egc1052y egc1053y {
        replace `var' = 2013 if `var' == -2020
    }
    gen a_tenure = egc1053y - egc1052y if egc1052y > 0 & egc1053y > 0
    replace a_tenure = . if egc1052y < a_birthy &  egc1052y > 0 & a_birthy  > 0
    
* Working Hours Per Week / 每周工作小时数
    gen a_wkhr = qg6 if qg6 >= 0

* Self-rated Education Level Needed for Current Occupation / 胜任当前工作所需教育程度
    gen a_occedu = kg1302 if kg1302>0
    replace a_occedu = kgd2 if a_occedu==. & kgd2>0
    replace a_occedu = a_occedu-1
    replace a_occedu = 1 if a_occedu == 10

/* First Occupation Type (ISCO88) / 初职（ISCO88）
    gen a_occtype_isco_1st = qg303code_isco if qgd0 == 1 & qg303code_isco > 0
    foreach wave in 18 16 14 12 10 {
        replace a_occtype_isco_1st = occtype_isco_1st_`wave' if a_occtype_isco_1st == .
    }
*/

* 工作时间弹性
    gen a_workatnight = qg601 if qg601>=0
    gen a_workonweekend = qg602 if qg602>=0
    gen a_alwaysonduty = qg603 if qg603>=0
    gen a_flexworkhour = qg604 if qg604>=0

**********************************
* Part4. Income
**********************************  
mvdecode qg11 qg12 qg1201_min qg1201_max incomeb qg1203 qg1204_min qg1204_max income , mv(-10/0)
    
* Main Job Monthly Wage / 当前主要工作月均收入
    gen a_mwage = qg11
    
* Main Job Hourly Wage / 当前主要工作小时工资
    gen a_hwage = qg11/(qg6/7*30) if qg6 > 0

* Main Job Annual Income (Bonus Included) / 当前主要工作年收入（包括奖金等）
    replace qg12 = 0.5*(qg1201_min+qg1201_max) if qg12==.
    gen a_ywage = qg12
    replace a_ywage = incomeb if (a_ywage == . | a_ywage == 0 | incomeb > a_ywage) & incomeb != .
    
* Annual Income from All Jobs (Bonus Included) / 所有工作年收入（包括奖金等）
    // the highest value of all labor income variables
    replace qg1203 = 0.5*(qg1204_min+qg1204_max) if qg1203==.
    egen a_ywaget = rowmax(qg1203 income incomeb qg12)
        
* Annual Total Income / 年总收入
    *gen a_income = p_income

**********************************
* Part5. Family Socioecnomic Status     
**********************************      

* Birthplace (Province) / 出生省份
    gen a_birthprov = provcd20 if provcd20>0
    replace a_birthprov = qa401a_code if qa401a_code>0
    foreach wave in 18 16 14 12 10 {
        replace a_birthprov = birthprov_`wave' if a_birthprov==.
    }
    
* Residence (Province) When R in Adolescence / 青少年时居住省份
    gen a_yresprov = qa602a_code if qa602a_code > 0
    replace a_yresprov = a_birthprov if a_yresprov == .
    foreach wave in 18 16 14 12 10 {
        replace a_yresprov = yresprov_`wave' if a_yresprov==.
    }

* Hukou When R in Adolescence / 青少年时户口
    recode qa603 (1=0) (3=1) (5 79=2) (else=.), gen(a_yhukou)
    foreach wave in 18 16 14 12 10 {
        replace a_yhukou = yhukou_`wave' if a_yhukou==.
    }   
    
* Number of Siblings / 兄弟姐妹数
    gen a_nsib = .
    foreach wave in 18 16 14 12 10 {
        replace a_nsib = nsib_`wave' if a_nsib==.
    }   

* Father's Highest Educational Level Attained / 父亲最高学历
* Mother's Highest Educational Level Attained / 母亲最高学历
    gen a_fedu = qv102 if qv102 >= 0
    foreach wave in 18 16 14 12 10 {
        replace a_fedu = fedu_`wave' if a_fedu == .
    }
    gen a_medu = qv202 if qv202 >=0
    foreach wave in 18 16 14 12 10 {
        replace a_medu = medu_`wave' if a_medu == .
    }

* Father's Occupation (ISCO88) / 父亲职业（ISCO88）
* Mother's Occupation (ISCO88) / 母亲职业（ISCO88）
    gen a_focctype_isco = .
    foreach wave in 18 16 14 12 10 {
        replace a_focctype_isco = focctype_isco_`wave' if a_focctype_isco == .
    }
    gen a_mocctype_isco = .
    foreach wave in 18 16 14 12 10 {
        replace a_mocctype_isco = mocctype_isco_`wave' if a_mocctype_isco == .
    }

* Father's Occupation ISEI / 父亲职业ISEI
* Mother's Occupation ISEI / 母亲职业ISEI
    iskoisei a_foccisei, isko(a_focctype_isco)
    iskoisei a_moccisei, isko(a_mocctype_isco)

* Whether Father's a CCP Member
* Whether Mother's a CCP Member
    recode qv104 (1=1) (2/4=0) (else=.), gen (a_fccp)
    foreach wave in 18 16 14 12 10 {
        replace a_fccp = fccp_`wave' if a_fccp == .
    }
    recode qv204 (1=1) (2/4=0) (else=.), gen (a_mccp)
    foreach wave in 18 16 14 12 10 {
        replace a_mccp = mccp_`wave' if a_mccp == .
    }

/* Father's ID / 父亲ID
* Mother's ID / 母亲ID
    clonevar a_pid_f = pid_a_f if pid_a_f >= 0
    replace a_pid_f = fid18*1000 + code_a_f if code_a_f>0 & a_pid_f == .
    foreach wave in 16 14 12 10 {
        replace a_pid_f = pid_f_`wave' if a_pid_f == .
    }
    clonevar a_pid_m = pid_a_m if pid_a_m >=0
    replace a_pid_m = fid18*1000 + code_a_m if code_a_m>0 & a_pid_m == .
    foreach wave in 16 14 12 10 {
        replace a_pid_m = pid_m_`wave' if a_pid_m == .
    }
*/
**********************************
* Part6. Cognitive/Non-cognitive/Language Abilities
**********************************

* Immediate Word Recall / 瞬时字词记忆得分
    gen a_iwr = iwr if iwr >= 0

* Delayed Word Recall / 延时字词记忆得分
    gen a_dwr = dwr if dwr >= 0

* Number Series Test: Guttman Scale / 数列测试得分: Guttman Scale
    gen a_ns_g = ns_g if ns_g >= 0

* Number Series Test: W-Score / 数列测试得分: W-Score
    gen a_ns_w = ns_w if ns_w >= 0

* Intelligence Level (Interviewer Grading) / 智力水平（访员打分）
    gen a_intelligence_ir = qz207 if qz207 > 0

**********************************
* Part7. Marriage Related
**********************************

* Current Marital Status / 当前婚姻状况
    gen a_marriage = qea0 if qea0 > 0
    replace a_marriage = marriage_last_update if a_marriage ==. &  marriage_last_update>0
    foreach wave in 18 16 14 12 10 {
        replace a_marriage = marriage_`wave' if a_marriage == .
    }

* Number of Children / 孩子数
    gen a_nchild = 0
    foreach var of varlist xchildpid_a_* {
        replace a_nchild = a_nchild+1 if `var'>=0 & `var'!=.
    }

**********************************
* Part8. Political Experience & Attitudes
**********************************

* CCP Membership / 党员
    gen a_ccp = qn4001 if qn4001>=0
    replace a_ccp = party if party >= 0
    foreach wave in 18 16 14 12 10 {
        replace a_ccp = ccp_`wave' if a_ccp == .
    }
            
**********************************
* Save Data Temporarily
**********************************      

//  Keep Generated Variables 
    keep a_*
    
//  Rename Variables for Later Usage
    rename a_* *_20
    rename pid_20 pid
    
//  Include Information from Child Dataset
    append using "$data_gen/cfps20_ind.dta"
    
//  Save Data for Later Usage
    sort pid

    duplicates tag pid, gen(dup)
    drop if dup==1 & qtype==0
    drop dup

    save "$data_gen/cfps20_ind.dta", replace
