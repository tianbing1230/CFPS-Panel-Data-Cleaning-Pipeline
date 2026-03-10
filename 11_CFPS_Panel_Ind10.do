version 15

**======================================================**
**            Information of Family Members             **
**======================================================**

    use "$f_raw_2010_famconf", clear
    gen nchild = 0
    foreach var of varlist code_a_c* {
        replace nchild = nchild+1 if `var'>=0 & `var'!=.
    }
    keep pid nchild code_a_f code_a_m code_a_s tb1y_a_s tb4_a_s td8_a_s tb5_isco_a_s tb5_isei_a_s fbirthy feduc foccupcode foccupisco fparty mbirthy meduc moccupcode moccupisco mparty
    save "$f_out_fammember10", replace

**========================================**
**            CFPS 2010 Child             **
**========================================**

    use "$f_raw_2010_child", clear

    merge 1:1 pid using "$f_raw_2018_crossyearid", ///
        keep(master match) nogen replace update ///
        keepusing(birthy gender ethnicity subsample fid10 marriage_10 cfps2010edu cfps2010sch cfps2010eduy cfps2010eduy_im urban10 hk10)

    merge 1:1 pid using "$f_out_fammember10", keep(master match) nogen replace update

**********************************
* Part0. Identifiers
**********************************

    mvdecode pid fid cid countyid provcd cyear cmonth interviewerid rswt_nat rswt_res subsample, mv(-10/-1)

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
    gen a_wave = 10

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

* Resample / 是否在全国再抽样样本中
    clonevar a_resample = subsample

**********************************
* Part1. Basic Demographics
**********************************

* Birth year / 出生年
    gen a_birthy = birthy

* Age in Survey Year / 年龄（调查年）
    gen a_age = 2010-birthy

* Gender / 性别
    gen a_gender = gender

* Ethnicity / 民族
    gen a_ethnicity = ethnicity

* Han / 汉族
    gen a_han = ethnicity==1
    replace a_han = . if ethnicity == .

* Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban= urban

* Hukou / 户口
    recode hk10 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)

* Hukou (Province) / 户口所在省
    gen a_hkprov = wa501acode if wa501acode > 0

**********************************
* Part2. Education
**********************************

* Highest Educational Level Attained / 最高学历
    gen a_edu = cfps2010edu if cfps2010edu > 0

* Highest Educational Level Attend / 在读/离校阶段
    gen a_sch = cfps2010sch if cfps2010sch > 0

* Years of Education Received / 教育年限
    gen a_eduy = cfps2010eduy if cfps2010eduy >= 0

* Years of Education Received (Imputation) / 教育年限（插补值）
    gen a_eduy_im = cfps2010eduy_im if cfps2010eduy_im >= 0

* Field of Study of the Highest Degree / 最高学历专业
    gen a_major = .
    foreach var in kr801 {
        replace a_major = `var' if `var'>0
    }

**********************************
* Part5. Family Socioecnomic Status
**********************************

* Birthplace (Province) / 出生省份
    gen a_birthprov = wa107acode if wa107acode > 0

* Residence (Province) When R in Adolescence / 青少年时居住省份
    gen a_yresprov = wa201acode if wa201acode > 0
    replace a_yresprov = a_birthprov if a_yresprov==.

* Hukou When R in Adolescence / 青少年时户口
    recode wa3 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_yhukou)
    replace a_yhukou = a_hukou if a_yhukou==.

* Father's Highest Educational Level Attained / 父亲最高学历
* Mother's Highest Educational Level Attained / 母亲最高学历
    gen a_fedu = feduc if feduc > 0
    gen a_medu = meduc if meduc > 0

* Father's Occupation (ISCO88) / 父亲职业（ISCO88）
* Mother's Occupation (ISCO88) / 母亲职业（ISCO88）
    gen a_focctype_isco = foccupisco if foccupisco > 0
    gen a_mocctype_isco = moccupisco if moccupisco > 0

* Father's Occupation ISEI / 父亲职业ISEI
* Mother's Occupation ISEI / 母亲职业ISEI
    iskoisei a_foccisei, isko(a_focctype_isco)
    iskoisei a_moccisei, isko(a_mocctype_isco)

* Whether Father's a CCP Member / 父亲是否共产党员
* Whether Mother's a CCP Member / 母亲是否共产党员
    recode fparty (1=1) (2/4=0) (else=.), gen(a_fccp)
    recode mparty (1=1) (2/4=0) (else=.), gen(a_mccp)

* Father's ID / 父亲ID
* Mother's ID / 母亲ID
    clonevar a_pid_f = pid_f if pid_f>0
    replace a_pid_f = fid*1000 + code_a_f if code_a_f > 0 & a_pid_f == .
    clonevar a_pid_m = pid_m if pid_m>0
    replace a_pid_m = fid*1000 + code_a_m if code_a_m > 0 & a_pid_m == .

**********************************
* Part6. Cognitive/Non-cognitive/Language Abilities
**********************************

* Original Score for Word Test / 字词测试原始得分
    gen a_word = wordtest if wordtest >= 0

* Original Score for Math Test / 数学测试原始得分
    gen a_math = mathtest if mathtest >= 0

* Comprehension Ability (Interviewer Grading) / 理解能力（访员打分）
    gen a_comprehend_ir = wz201 if wz201 > 0

* Intelligence Level (Interviewer Grading) / 智力水平（访员打分）
    gen a_intelligence_ir = wz207 if wz207 > 0

* Interpersonal Skills (Interviewer Grading) / 待人接物水平（访员打分）
    gen a_interperson_ir = wz208 if wz208 > 0

* Language Competence (Interviewer Grading) / 语言表达能力（访员打分）
    gen a_language_ir = wz212 if wz212 > 0

* Mandarin Proficiency (Interviewer Grading) / 普通话熟练程度（访员打分）
    gen a_mandarin_ir = wz205 if wz205 > 0


**********************************
* Part8. Health
**********************************


**********************************
* Save Data Temporarily
**********************************

//  Keep Generated Variables
    keep a_*

//  Rename Variables for later Usage
    rename a_* *_10
    rename pid_10 pid

//  Save Data for Later Usage
    sort pid
    save "$data_gen/cfps10_ind.dta", replace


**========================================**
**            CFPS 2010 Adult             **
**========================================**

    use "$f_raw_2010_adult", clear
    merge 1:1 pid using "$f_raw_2018_crossyearid", ///
        keep(master match) nogen replace update ///
        keepusing(birthy gender ethnicity subsample fid10 marriage_10 cfps2010edu cfps2010sch cfps2010eduy cfps2010eduy_im urban10 hk10)
     merge 1:1 pid using "$f_out_fammember10", keep(master match) nogen replace update

**********************************
* Part0. Identifiers
**********************************

    mvdecode pid fid cid countyid provcd cyear cmonth rswt_nat rswt_res subsample, mv(-10/-1)
    
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
    gen a_wave = 10
    
* Survey Year / 问卷调查年
    gen a_syear = cyear
    
* Survey Year / 问卷调查月
    gen a_smonth = cmonth

* Questionnaire Type / 问卷类别
    gen a_qtype = 1
    
* Interviewer ID / 访员ID
    clonevar a_interviewerid = interviewerid

* Weight_National / 个人权重-全国样本
    clonevar a_rswt_nat = rswt_nat

* Weight_Resample / 个人权重-全国再抽样样本
    clonevar a_rswt_res = rswt_res

* Resample / 是否在全国再抽样样本中
    clonevar a_resample = subsample

**********************************
* Part1. Basic Demographics
**********************************

* Birth year / 出生年
    gen a_birthy = birthy

* Age in Survey Year / 年龄（调查年）
    gen a_age = 2010-birthy

* Gender / 性别
    gen a_gender = gender

* Ethnicity / 民族
    gen a_ethnicity = ethnicity

* Han / 汉族
    gen a_han = ethnicity==1
    replace a_han = . if ethnicity == .

* Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban= urban

* Hukou / 户口
    recode hk10 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)

* Hukou (Province) / 户口所在省
    gen a_hkprov = qa201acode if qa201acode > 0

**********************************
* Part2. Education
**********************************

* Highest Educational Level Attained / 最高学历
    gen a_edu = cfps2010edu if cfps2010edu > 0

* Highest Educational Level Attend / 在读/离校阶段
    gen a_sch = cfps2010sch if cfps2010sch > 0

* Years of Education Received / 教育年限
    gen a_eduy = cfps2010eduy if cfps2010eduy >= 0

* Years of Education Received (Imputation) / 教育年限（插补值）
    gen a_eduy_im = cfps2010eduy_im if cfps2010eduy_im >= 0

* Field of Study of the Highest Degree / 最高学历专业
    gen a_major = .
    foreach var in kr601 qc402 qc302 qc202 kr801 qc102 {
        replace a_major = `var' if `var'>0
    }

* College Type / 本科学校类型
    recode collegetype (-10/-1=.), gen(a_collegetype)

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
    
* Current Occupation Type (ISCO88) / 当前职业（ISCO88）
    clonevar a_occtype_isco = qg307isco if qg307isco > 0
    
* Current Occupation (10 Categories) / 当前职业（10类）
    gen a_occtype_crude = floor(a_occtype_isco/1000)
    
* Current Occupation ISEI / 当前职业ISEI
    gen a_occisei = qg307isei if qg307isei > 0
    
* Current Occupation Industry / 当前职业所在行业
    gen a_industry = qg308code if qg308code > 0
    
* Current Occupation Organization Type / 当前职业所在机构类型
    gen a_orgtype = .
    replace a_orgtype = 1 if qg305 == 1
    replace a_orgtype = 2 if qg305 == 2
    replace a_orgtype = 3 if qg305 == 3
    replace a_orgtype = 4 if inlist(qg305, 4,5,6,7,11)
    replace a_orgtype = 5 if inlist(qg305, 8,9)
    replace a_orgtype = 6 if qg305 == 10
    replace a_orgtype = 7 if inlist(qg305, 12,13,14)
    
* Got Promoted Last Year (Excutive Position) / 去年是否获得行政职务晋升
* Got Promoted Last Year (Technical Position) / 去年是否获得技术职称晋升
    recode qg407 (1 4=1) (2 3=0) (else=.), gen(a_promote_e)
    recode qg407 (2 4=1) (1 3=0) (else=.), gen(a_promote_t)

* Administration / Management Position / 行政管理职务
    recode qg310code (0=0) (1/2=1) (3/4=2) (5/6=3) (7/8=4) (else=.), gen(a_mngpos)
    replace a_mngpos = 0 if qg309 == 0

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
    gen a_tenure = a_syear - qg311 if qg311 > 1000
    
* Working Hours Per Week / 每周工作小时数
    gen a_wkhr = (qg402/(30/7))*qg403 if qg403 >= 0 & qg402 >= 0
    replace a_wkhr = . if a_wkhr >=  168

* First Occupation Type (ISCO88) / 初职（ISCO88）
    gen a_occtype_isco_1st = qg601_isco if qg601_isco > 0
    replace a_occtype_isco_1st = a_occtype_isco if qg6==1

**********************************
* Part4. Income
**********************************  

mvdecode qk101 qk102 qk103 qk104 income, mv(-10/-1)
        
* Main Job Monthly Wage / 当前主要工作月均收入
    gen a_mwage = qk101

* Main Job Hourly wage / 当前主要工作小时工资
    gen a_hwage = qk101/qg402/qg403 if qg402 >= 0 & qg403 >= 0

* Main Job Annual Income (Bonus Included) / 当前主要工作年收入（包括奖金等）
    gen a_ywage = (qk101 +qk102)*12 + qk103 +qk104

* Annual Income from All Jobs (Bonus Included) / 所有工作年收入（包括奖金等）
    gen a_ywaget = a_ywage 
    foreach var in qk105 qk106 {
        replace a_ywaget = a_ywaget + `var' if `var' > 0 
    }
    
* Annual Total Income / 年总收入
    gen a_income = income
    
**********************************
* Part5. Family Socioecnomic Status
**********************************

* Birthplace (Province) / 出生省份
    gen a_birthprov = qa102acode if qa102acode > 0

* Residence (Province) When R in Adolescence / 青少年时居住省份
    gen a_yresprov = qa401acode if qa401acode > 0
    replace a_yresprov = a_birthprov if qa4 == 1

* Hukou When R in Adolescence / 青少年时户口
    recode qa402 (1=0) (3=1) (5 79=2) (else=.), gen(a_yhukou)

* Number of Siblings / 兄弟姐妹数
    gen a_nsib = qb1 if qb1 >=0

* Father's Highest Educational Level Attained / 父亲最高学历
* Mother's Highest Educational Level Attained / 母亲最高学历
    gen a_fedu = feduc if feduc > 0
    gen a_medu = meduc if meduc > 0

* Father's Occupation (ISCO88) / 父亲职业（ISCO88）
* Mother's Occupation (ISCO88) / 母亲职业（ISCO88）
    gen a_focctype_isco = foccupisco if foccupisco > 0
    gen a_mocctype_isco = moccupisco if moccupisco > 0

* Father's Occupation ISEI / 父亲职业ISEI
* Mother's Occupation ISEI / 母亲职业ISEI
    iskoisei a_foccisei, isko(a_focctype_isco)
    iskoisei a_moccisei, isko(a_mocctype_isco)

* Whether Father's a CCP Member / 父亲是否共产党员
* Whether Mother's a CCP Member / 母亲是否共产党员
    recode fparty (1=1) (2/4=0) (else=.), gen(a_fccp)
    recode mparty (1=1) (2/4=0) (else=.), gen(a_mccp)

* Father's ID / 父亲ID
* Mother's ID / 母亲ID
    clonevar a_pid_f = pid_f if pid_f>0
    replace a_pid_f = fid*1000 + code_a_f if code_a_f > 0 & a_pid_f == .
    clonevar a_pid_m = pid_m if pid_m>0
    replace a_pid_m = fid*1000 + code_a_m if code_a_m > 0 & a_pid_m == .
    
**********************************
* Part6. Cognitive/Non-cognitive/Language Abilities         
**********************************      

* Original Score for Word Test / 字词测试原始得分
    gen a_word = wordtest if wordtest >= 0
    
* Original Score for Math Test / 数学测试原始得分   
    gen a_math = mathtest if mathtest >= 0

* Comprehension Ability (Interviewer Grading) / 理解能力（访员打分）
    gen a_comprehend_ir = qz201 if qz201 > 0

* Intelligence Level (Interviewer Grading) / 智力水平（访员打分）
    gen a_intelligence_ir = qz207 if qz207 > 0
    
* Interpersonal Skills (Interviewer Grading) / 待人接物水平（访员打分） 
    gen a_interperson_ir = qz208 if qz208 > 0

* Language Competence (Interviewer Grading) / 语言表达能力（访员打分）
    gen a_language_ir = qz212 if qz212 > 0
    
* Mandarin Proficiency (Interviewer Grading) / 普通话熟练程度（访员打分）
    gen a_mandarin_ir = qz205 if qz205 > 0
    
**********************************
* Part7. Marriage and Family
**********************************  
    
* Current Marital Status / 当前婚姻状况
    gen a_marriage = marriage_10 if marriage_10 > 0

* Year of First Marriage / 初婚年份
    gen a_fmarri_y = qe210y if qe210y > 0 & qe2 == 1
    replace a_fmarri_y = qe605y_best if qe605y_best > 0 & qe2 == 0

* Year of Current Marriage / 当前婚姻结婚年份
    gen a_cmarri_y = qe210y if qe210y > 0

* Spousal ID / 配偶ID
    gen a_pid_s = fid*1000 + code_a_s if code_a_s > 0
    
* Spouse's Birth Year / 配偶出生年份
    gen a_sbirthy = qe211y if qe211y > 0
    replace a_sbirthy = tb1y_a_s if tb1y_a_s > 0 & a_sbirthy == .

* Spouse's Highest Educational Level Attained / 配偶最高学历
    gen a_sedu = tb4_a_s if tb4_a_s >= 0
    replace a_sedu = sedu if sedu >= 0 & a_sedu == .

* Spouse's Years of Education / 配偶受教育年限
    gen a_seduy = seduy if seduy >= 0

* Spouse's Occupation (ISCO88) / 配偶职业（ISCO88）
    gen a_socctype_isco = tb5_isco_a_s if tb5_isco_a_s >= 0

* Spouse's Occupation ISEI / 配偶职业ISEI
    gen a_soccisei = tb5_isei_a_s if tb5_isei_a_s >= 0

* Number of Children / 孩子数
    gen a_nchild = nchild

**********************************
* Part10. Political Experience & Attitudes
**********************************

* CCP Membership / 党员
    gen a_ccp = .
    forvalues i=1/14 {
        replace a_ccp = 1 if qa7_s_`i'==1
    }
    replace a_ccp = 0 if qa7_s_1>0 & a_ccp==.
    
**********************************
* Save Data Temporarily
**********************************      

//  Keep Generated Variables 
    keep a_*
    
//  Rename Variables for later Usage
    rename a_* *_10
    rename pid_10 pid
    
//  Include Information from Child Dataset
    append using "$data_gen/cfps10_ind.dta"
    
//  Save Data for Later Usage
    sort pid
    save "$data_gen/cfps10_ind.dta", replace
