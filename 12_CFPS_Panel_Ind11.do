version 15


**========================================**
**            CFPS 2011 Child             **
**========================================**

    use "$f_raw_2011_child", clear
    merge 1:1 pid using "$data_gen/cfps10_ind.dta", nogen keep(master match)

**********************************
* Part0. Identifiers
**********************************

    mvdecode pid fid cid countyid provcd cyear cmonth rswt_nat rswt_res, mv(-10/-1)
    
* Individual ID / 个人ID
    clonevar a_pid = pid
    
* Family ID / 家庭ID
    clonevar a_fid = fid

* Community ID / 社区ID
    clonevar a_cid = cid

* County ID / 区县ID
    clonevar a_countyid = countyid

* Province Code / 省代码
    gen a_provcd = provcd

* Wave ID / 调查轮次
    gen a_wave = 11
    
* Survey Year / 问卷调查年
    gen a_syear = cyear
    
* Survey Year / 问卷调查月
    gen a_smonth = cmonth

* Questionnaire Type / 问卷类别
    gen a_qtype = 0
    
* Interviewer ID / 访员ID
    clonevar a_interviewerid = interviewerid    

* Weight_National / 个人权重-全国样本
    clonevar a_rswt_nat = rswt_nat

* Weight_Resample / 个人权重-全国再抽样样本
    clonevar a_rswt_res = rswt_res

**********************************
* Part1. Basic Demographics
**********************************  
    
* Birth year / 出生年
    gen a_birthy = wa1y
    
* Age in Survey Year / 年龄（调查年）
    gen a_age = wa1age

* Gender / 性别
    gen a_gender = gender

* Ethnicity / 民族
    gen a_ethnicity = . // No information
    replace a_ethnicity = ethnicity_10 if a_ethnicity == . // Using information from previous wave

* Han / 汉族
    gen a_han = ethnicity==1
    replace a_han = . if ethnicity == .

* Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban = urban 

* Hukou / 户口
    recode wa4 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)
    replace a_hukou = hukou_10 if a_hukou == .
    
* Hukou (Province) / 户口所在省
    gen a_hkprov = wa501acode if wa501acode > 0
    replace a_hkprov = hkprov_10 if a_hkprov == . 

**********************************
* Part2. Education
**********************************  

* Highest Educational Level Attained / 最高学历
    gen a_edu = edu if edu > 0
    replace a_edu = edu_10 if a_edu==.

* Highest Educational Level Attend / 在读/离校阶段
    gen a_sch = wh4 if wh4 > 0
    replace a_sch = kr1 if kr1 > 0
    replace a_sch = sch_10 if a_sch==.

* Years of Education Received / 教育年限
    gen a_eduy = edul2 if edul2 >= 0

* Years of Education Received (Imputation) / 教育年限（插补值）
    // No information

* Field of Study of the Highest Degree / 最高学历专业
    // No information

**********************************
* Part6. Cognitive/Non-cognitive/Language Abilities
**********************************

* Original Score for Word Test / 字词测试原始得分
    gen a_word = wordtest if wordtest11 >= 0

* Original Score for Math Test / 数学测试原始得分
    gen a_math = mathtest if mathtest11 >= 0

**********************************
* Save Data Temporarily
**********************************      

//  Keep Generated Variables 
    keep a_*
    
//  Rename Variables for later Usage
    rename a_* *_11
    rename pid_11 pid
    
//  Save Data for Later Usage
    sort pid
    save "$data_gen/cfps11_ind.dta", replace

    
**========================================**
**            CFPS 2011 Adult             **
**========================================**

    use "$f_raw_2011_adult", clear
    merge 1:1 pid using "$data_gen/cfps10_ind.dta", nogen keep(master match)

**********************************
* Part0. Identifiers
**********************************

    mvdecode pid fid cid countyid provcd cyear rswt_nat rswt_res, mv(-10/-1)
    
* Individual ID / 个人ID
    clonevar a_pid = pid
    
* Family ID / 家庭ID
    clonevar a_fid = fid

* Community ID / 社区ID
    clonevar a_cid = cid

* County ID / 区县ID
    clonevar a_countyid = countyid

* Province Code / 省代码
    gen a_provcd = provcd

* Wave ID / 调查轮次
    gen a_wave = 11
    
* Survey Year / 问卷调查年
    gen a_syear = cyear
    
* Survey Year / 问卷调查月
    gen a_smonth = . // 无信息

* Questionnaire Type / 问卷类别
    gen a_qtype = 1

* Interviewer ID / 访员ID
    clonevar a_interviewerid = interviewerid

* Weight_National / 个人权重-全国样本
    clonevar a_rswt_nat = rswt_nat

* Weight_Resample / 个人权重-全国再抽样样本
    clonevar a_rswt_res = rswt_res

**********************************
* Part1. Basic Demographics
**********************************  
    
*  Birth year / 出生年
    gen a_birthy = qa1y

*  Age in Survey Year / 年龄（调查年）
    gen a_age = qa1age
    
*  Gender / 性别
    gen a_gender = gender
    
* Ethnicity / 民族
    gen a_ethnicity = qa5code if qa5code >= 0
    replace a_ethnicity = ethnicity_10 if a_ethnicity==.

* Han / 汉族
    gen a_han = ethnicity==1
    replace a_han = . if ethnicity == .

*  Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban = urban 
    
*  Hukou / 户口
    recode qa2 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)
    replace a_hukou = hukou_10 if a_hukou == .
    
*  Hukou (Province) / 户口所在省
    gen a_hkprov = qa201acode if qa201acode > 0
    replace a_hkprov = hkprov_10 if a_hkprov == . 

**********************************
* Part2. Education
**********************************  

* Highest Educational Level Attained / 最高学历
    gen a_edu = edu if edu > 0
    replace a_edu = edu_10 if a_edu==.

* Highest Educational Level Attend / 在读/离校阶段
    gen a_sch = qc1 if qc1 > 0
    replace a_sch = kr1 if kr1 > 0
    replace a_sch = sch_10 if a_sch==.

* Years of Education Received / 教育年限
    gen a_eduy = edul2 if edul2 >= 0

* Years of Education Received (Imputation) / 教育年限（插补值）
    *gen a_eduy_im = cfps2010eduy_im if cfps2010eduy_im >= 0

* Field of Study of the Highest Degree / 最高学历专业
    gen a_major = kr601 if kr601 > 0

* Education History

**********************************
* Part3. Labor Market Outcomes
**********************************      

* Labor Market Participation / 经济活动情况
    gen a_employ = .
    replace a_employ = 0 if (qg3 == 0 | qg2 == 0) & qj1 == 1
    replace a_employ = 1 if qg3 == 1
    replace a_employ = 2 if (qg3 == 0 | qg2 == 0) & a_employ == .

* Current Occupation Employment Status / 当前职业就业身份
    gen a_employs = .
    replace a_employs = 1 if qg303 == 3
    replace a_employs = 2 if qg303 == 1
    replace a_employs = 3 if qg303 == 5 | qg4 == 1
    replace a_employs = employs_10 if a_employs == . & a_employ == 1
    
* Current Occupation Type (ISCO88) / 当前职业（ISCO88）
    clonevar a_occtype_isco = qg306isco if qg306isco > 0
    replace a_occtype_isco = occtype_isco_10 if a_occtype_isco ==. & a_employ == 1
    
* Current Occupation (10 Categories) / 当前职业（10类）
    gen a_occtype_crude = floor(a_occtype_isco/1000)
    
* Current Occupation ISEI / 当前职业ISEI
    gen a_occisei = qg306isei if qg306isei  > 0
    replace a_occisei = occisei_10 if a_occisei ==. & a_employ == 1
        
* Current Occupation Industry / 当前职业所在行业
    gen a_industry = qg308codes if qg308codes > 0
    replace a_industry = industry_10 if a_industry ==. & a_employ == 1
    
* Current Occupation Organization Type / 当前职业所在机构类型
    gen a_orgtype = .
    replace a_orgtype = 1 if qg305 == 1
    replace a_orgtype = 2 if qg305 == 2
    replace a_orgtype = 3 if qg305 == 3
    replace a_orgtype = 4 if inlist(qg305, 4,5,6,7,11)
    replace a_orgtype = 5 if inlist(qg305, 8,9)
    replace a_orgtype = 6 if qg305 == 10
    replace a_orgtype = 7 if inlist(qg305, 12,13,14)
    replace a_orgtype = orgtype_10 if a_orgtype ==. & a_employ == 1
    
* Got Promoted Last Year (Excutive Position) / 去年是否获得行政职务晋升
* Got Promoted Last Year (Technical Position) / 去年是否获得技术职称晋升
    recode nqg407 (1 3=1) (2 78=0) (else=.), gen(a_promote_e)
    recode nqg407 (2 3=1) (1 78=0) (else=.), gen(a_promote_t)

* Administration / Management Position / 行政管理职务
    gen a_mngpos = qg309 if qg309 >= 0
    
* Number of Subordinates / 负责管理人数
    gen a_subnum = qg406 if qg406 >= 0
    replace a_subnum = 0 if qg405 == 0
    
* Satisfaction for Current Occupation's Income / 对目前工作收入的满意度
* Satisfaction for Current Occupation's Safety / 对目前工作安全性的满意度
* Satisfaction for Current Occupation's Working Environment / 对目前工作环境的满意度
* Satisfaction for Current Occupation's Working Hours / 对目前工作时间的满意度
* Satisfaction for Current Occupation's Chance of Promotion / 对目前工作晋升机会的满意度
* Overall Satisfaction for Current Occupation / 对目前工作的总体满意度
    local type inc safe env wkh prom all
    forvalues i = 1/6 {
        local j: word `i' of `type'
        gen a_wksat_`j' = qg50`i' if qg50`i' >0 
    }   
    
* Tenure of Current Occupation / 当前职业工龄
    gen a_tenure = a_syear - qng301y if qng301y > 1000
    
* Working Hours Per Week / 每周工作小时数
    gen a_wkhr = (qg402/(30/7))*nqg403 if nqg403 >= 0 & qg402 >= 0
    replace a_wkhr = . if a_wkhr >=  168

* First Occupation Type (ISCO88) / 初职（ISCO88）
    gen a_occtype_isco_1st = qg601_isco if qg601_isco > 0
    replace a_occtype_isco_1st = a_occtype_isco if qg6==1
    replace a_occtype_isco_1st = occtype_isco_1st_10 if a_occtype_isco_1st == . 
    
**********************************
* Part4. Income
**********************************  
mvdecode qk101 qk102 qk103 qk104 qk105 qk106 qk2 qk301 qk401 qk501 qk6_max qk6_min qk601, mv(-10/-1)
    
*  Main Job Monthly Wage / 当前主要工作月均收入
    gen a_mwage = qk101

*  Main Job Hourly wage / 当前主要工作小时工资
    gen a_hwage = qk101/qg402/nqg403 if qg402 >= 0 & nqg403 >= 0

*  Main Job Annual Income (Bonus Included) / 当前主要工作年收入（包括奖金等）
    gen a_ywage = (qk101 + qk102)*12 + qk103 + qk104

* Annual Income from All Jobs (Bonus Included) / 所有工作年收入（包括奖金等）
    gen a_ywaget = a_ywage 
    foreach var in qk105 qk106 {
        replace a_ywaget = a_ywaget + `var' if `var' > 0 
    }
        
*  Annual Total Income / 年总收入
    gen a_income = .
    replace a_income = qk601
    replace a_income = 0.5 * (qk6_min + qk6_max) if a_income == .
    replace a_income = qk101+qk101+qk102+qk103+qk104+qk105+qk106+qk2+qk301+qk401+qk501 if a_income == . 

**********************************
* Part6. Cognitive/Non-cognitive/Language Abilities
**********************************

* Original Score for Word Test / 字词测试原始得分
    gen a_word = wordtest if wordtest11 >= 0

* Original Score for Math Test / 数学测试原始得分
    gen a_math = mathtest if mathtest11 >= 0

**********************************
* Part7. Marriage Related
**********************************  
    
* Current Marital Status / 当前婚姻状况
    gen a_marriage = qe1 if qe1 > 0

*
    
**********************************
* Part10. Political Experience & Attitudes
**********************************

* CCP Membership / 党员
    gen a_ccp = .
    forvalues i = 1/4 {
        replace a_ccp = 1 if qa7_s_`i'==1
    }
    replace a_ccp = 0 if qa7_s_1>0 & a_ccp==.
    
**********************************
* Save Data Temporarily
**********************************      

//  Keep Generated Variables 
    keep a_*
    
//  Rename Variables for Later Usage
    rename a_* *_11
    rename pid_11 pid
    
//  Include Information from Child Dataset
    append using "$data_gen/cfps11_ind.dta"
    
//  Save Data for Later Usage
    sort pid
    save "$data_gen/cfps11_ind.dta", replace
    
