version 15

**======================================================**
**            Information of Family Members             **
**======================================================**

    use "$f_raw_2014_famconf", clear
    duplicates drop pid, force
    gen nchild = 0
    foreach var of varlist code_a_c* {
        replace nchild = nchild+1 if `var'>=0 & `var'!=.
    }
    keep pid tb1y_a_s tb4_a14_s tb4_a14_f tb4_a14_m nchild
    save "$f_out_fammember14", replace

**========================================**
**            CFPS 2014 Child             **
**========================================**

    use "$f_raw_2014_child", clear

    merge 1:1 pid using "$f_raw_2018_crossyearid", ///
        keep(master match) nogen replace update ///
        keepusing(birthy gender ethnicity subsample fid14 marriage_14 cfps2014edu cfps2014sch cfps2014eduy cfps2014eduy_im urban14 hk14)

    merge 1:1 pid using "$f_out_fammember14", keep(master match) nogen replace update

    foreach wave in 10 12 {
        merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", nogen keep(master match)
    }
    
**********************************
* Part0. Identifiers
**********************************

    mvdecode pid fid14 cid14 countyid14 provcd14 cyear cmonth interviewerid rswt_natcs14 rswt_rescs14 rswt_natpn1014 rswt_respn1014 subsample, mv(-10/-1)
    
* Individual ID / 个人ID
    clonevar a_pid = pid
    
* Family ID / 家庭ID
    clonevar a_fid = fid14

* Community ID / 社区ID
    clonevar a_cid = cid14

* County ID / 区县ID
    clonevar a_countyid = countyid14

* Province Code / 省代码
    gen a_provcd = provcd14

* Wave ID / 调查轮次
    gen a_wave = 14
    
* Survey Year / 问卷调查年
    gen a_syear = cyear
    
* Survey Year / 问卷调查月
    gen a_smonth = cmonth

* Questionnaire Type / 问卷类别
    gen a_qtype = 0
    
* Interviewer ID / 访员ID
    clonevar a_interviewerid = interviewerid

* Weight_National / 个人权重-全国样本
    clonevar a_rswt_nat = rswt_natcs14

* Weight_Resample / 个人权重-全国再抽样样本
    clonevar a_rswt_res = rswt_rescs14

* Weight_National_Panel / 个人权重-全国样本
    clonevar a_rswt_nat_p = rswt_natpn1014

* Weight_Resample_Panel / 个人权重-全国再抽样样本
    clonevar a_rswt_res_p = rswt_respn1014

* Resample / 是否在全国再抽样样本中
    clonevar a_resample = subsample

**********************************
* Part1. Basic Demographics
**********************************  
    
*  Birth year / 出生年
    gen a_birthy = birthy
    
*  Age in Survey Year / 年龄（调查年）
    gen a_age = 2014-birthy

*  Gender / 性别
    gen a_gender = gender

* Ethnicity / 民族
    gen a_ethnicity = ethnicity

* Han / 汉族
    gen a_han = ethnicity==1
    replace a_han = . if ethnicity == .

*  Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban = urban14 if urban14 >= 0
    foreach wave in 12 10 {
        replace a_urban = urban_`wave' if a_urban == .
    }

*  Hukou / 户口
    recode hk14 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)
    foreach wave in 12 10 {
        replace a_hukou = hukou_`wave' if a_hukou == .
    }
    
*  Hukou (Province) / 户口所在省
    gen a_hkprov = wa501m_3code if wa501m_3code > 0
    replace a_hkprov = a_provcd if inlist(wa501m, 1,2,3,4) // hk in residential province
    foreach wave in 12 10 {
        replace a_hkprov = hkprov_`wave' if a_hkprov == . 
    }
    
**********************************
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
                    
**********************************
* Save Data Temporarily
**********************************      

//  Keep Generated Variables 
    keep a_*
    
//  Rename Variables for later Usage
    rename a_* *_14
    rename pid_14 pid
    
//  Save Data for Later Usage
    sort pid
    save "$data_gen/cfps14_ind.dta", replace

    
**========================================**
**            CFPS 2014 Adult             **
**========================================**

    use "$f_raw_2014_adult", clear

    merge 1:1 pid using "$f_raw_2018_crossyearid", ///
        keep(master match) nogen replace update ///
        keepusing(birthy gender ethnicity subsample fid14 marriage_14 cfps2014edu cfps2014sch cfps2014eduy cfps2014eduy_im urban14 hk14 employ14)

    merge 1:1 pid using "$f_out_fammember14", keep(master match) nogen replace update

    foreach wave in 10 12 {
        merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", nogen keep(master match)
    }
    
**********************************
* Part0. Identifiers
**********************************

    mvdecode pid fid14 cid14 countyid14 provcd14 cyear cmonth interviewerid_sf interviewerid_pr rswt_natcs14 rswt_rescs14 rswt_natpn1014 rswt_respn1014 subsample, mv(-10/-1)
    
* Individual ID / 个人ID
    clonevar a_pid = pid
    
* Family ID / 家庭ID
    clonevar a_fid = fid14
    
* Community ID / 社区ID
    clonevar a_cid = cid14

* County ID / 区县ID
    clonevar a_countyid = countyid14

* Province Code / 省代码
    gen a_provcd = provcd14

* Wave ID / 调查轮次
    gen a_wave = 14
    
* Survey Year / 问卷调查年
    gen a_syear = cyear
    
* Survey Year / 问卷调查月
    gen a_smonth = cmonth
    
* Questionnaire Type / 问卷类别
    gen a_qtype = 1
    
* Interviewer ID / 访员ID
    clonevar a_interviewerid = interviewerid_sf
    replace a_interviewerid = interviewerid_pr if a_interviewerid==.

* Weight_National / 个人权重-全国样本
    clonevar a_rswt_nat = rswt_natcs14

* Weight_Resample / 个人权重-全国再抽样样本
    clonevar a_rswt_res = rswt_rescs14

* Weight_National_Panel / 个人权重-全国样本
    clonevar a_rswt_nat_p = rswt_natpn1014

* Weight_Resample_Panel / 个人权重-全国再抽样样本
    clonevar a_rswt_res_p = rswt_respn1014

* Resample / 是否在全国再抽样样本中
    clonevar a_resample = subsample

**********************************
* Part1. Basic Demographics
**********************************  

*  Birth year / 出生年
    gen a_birthy = birthy

*  Age in Survey Year / 年龄（调查年）
    gen a_age = 2014-birthy

*  Gender / 性别
    gen a_gender = gender

* Ethnicity / 民族
    gen a_ethnicity = ethnicity

* Han / 汉族
    gen a_han = ethnicity==1
    replace a_han = . if ethnicity == .

*  Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban = urban14 if urban14 >= 0
    foreach wave in 12 10 {
        replace a_urban = urban_`wave' if a_urban == .
    }

*  Hukou / 户口
    recode hk14 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)
    foreach wave in 12 10 {
        replace a_hukou = hukou_`wave' if a_hukou == .
    }

*  Hukou (Province) / 户口所在省
    gen a_hkprov = qa302ccode if qa302ccode > 0
    replace a_hkprov = a_provcd if inlist(qa302, 1,2,3,4) // hk in residential province
    foreach wave in 12 10 {
        replace a_hkprov = hkprov_`wave' if a_hkprov == . 
    }
    
**********************************
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
    
* Field of Study of the Highest Degree / 最高学历专业
    gen a_major = .
    foreach var in kr801m kw802 kr701 kw702 kra601 kw602 kr501 {
        replace a_major = `var' if `var' > 0 & `var' != 77  
    }
    foreach wave in 12 10 {
        replace a_major = major_`wave' if a_major == .
    }

* College Type / 本科学校类型
    recode kra603code  (-10/-1=.), gen(a_collegetype)
    foreach wave in 12 10 {
        replace a_collegetype = collegetype_`wave' if a_collegetype == .
    }

**********************************
* Part3. Labor Market Outcomes
**********************************      

* Labor Market Participation / 经济活动情况
    gen a_employ = employ14 if employ14 >= 0

* Current Occupation Employment Status / 当前职业就业身份
    gen a_employs = .
    replace a_employs = 1 if jobclass >= 3 & jobclass != .
    replace a_employs = 2 if jobclass == 2
    replace a_employs = 3 if jobclass == 1
    
* Current Occupation Type (ISCO88/08) / 当前职业（ISCO88/08）
    csco2isco_cfps a_occtype_isco, csco(qg303code)
    replace a_occtype_isco = . if a_occtype_isco < 0 
    
* Current Occupation (10 Categories) / 当前职业（10类）
    gen a_occtype_crude = floor(a_occtype_isco/1000)
    
* Current Occupation ISEI / 当前职业ISEI
    csco2isei_cfps a_occisei, csco(qg303code)
    replace a_occisei = . if a_occisei < 0 
        
* Current Occupation Industry / 当前职业所在行业
    gen a_industry = qg302code if qg302code > 0 & qg302code != 99
    replace a_industry = 1 if inlist(jobclass, 1,3)
    
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
    gen a_wksat_prom = qg1502 if qg1502 > 0
    gen a_wksat_all = qg4 if qg4 > 0
    
* Tenure of Current Occupation / 当前职业工龄
    foreach var in egc1052y egc1053y {
        replace `var' = 2013 if `var' == -2020
    }
    gen a_tenure = egc1053y - egc1052y if egc1052y > 0 & egc1053y > 0
    replace a_tenure = . if egc1052y < cfps_birthy &  egc1052y > 0 & cfps_birthy  > 0
    
* Working Hours Per Week / 每周工作小时数
    gen a_wkhr = qg6 if qg6 >= 0
    
* First Occupation Type (ISCO88) / 初职（ISCO88）
    gen a_occtype_isco_1st = .
    foreach wave in 12 10 {
        replace a_occtype_isco_1st = occtype_isco_1st_`wave' if a_occtype_isco_1st == .
    }   
    
**********************************
* Part4. Income
**********************************  
mvdecode qg11 qg12 qg1201_min qg1201_max incomeb qg1203 qg1204_min qg1204_max income p_wage p_income, mv(-10/0)
    
* Main Job Monthly Wage / 当前主要工作月均收入
    gen a_mwage = qg11
    
* Main Job Hourly Wage / 当前主要工作小时工资
    gen a_hwage = qg11/(qg6/7*30) if qg6 > 0

* Main Job Annual Income (Bonus Included) / 当前主要工作年收入（包括奖金等）
    replace p_wage = 0.5*(qg1201_min+qg1201_max) if qg12==.
    gen a_ywage = qg12
    replace a_ywage = incomeb if (a_ywage == . | a_ywage == 0 | incomeb > a_ywage) & incomeb != .
    
* Annual Income from All Jobs (Bonus Included) / 所有工作年收入（包括奖金等）
    // the highest value of all labor income variables
    replace qg1203 = 0.5*(qg1204_min+qg1204_max) if qg1203==.
    egen a_ywaget = rowmax(qg1203 p_wage income incomeb qg12)
        
* Annual Total Income / 年总收入
    gen a_income = p_income

**********************************
* Part5. Family Socioecnomic Status     
**********************************      

* Birthplace (Province) / 出生省份
    gen a_birthprov = provcd14 if provcd14>0
    replace a_birthprov = qa401ccode if qa401ccode>0
    foreach wave in 12 10 {
        replace a_birthprov = birthprov_`wave' if a_birthprov==.
    }
    
* Residence (Province) When R in Adolescence / 青少年时居住省份
    gen a_yresprov = qa602ccode if qa602ccode > 0
    replace a_yresprov = qa502ccode if qa502ccode > 0 & a_yresprov == .
    replace a_yresprov = a_birthprov if a_yresprov == .
    foreach wave in 12 10 {
        replace a_yresprov = yresprov_`wave' if a_yresprov==.
    }

* Hukou When R in Adolescence / 青少年时户口
    recode qa603 (1=0) (3=1) (5 79=2) (else=.), gen(a_yhukou)
    foreach wave in 12 10 {
        replace a_yhukou = yhukou_`wave' if a_yhukou==.
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
* Part7. Marriage Related
**********************************  
    
* Current Marital Status / 当前婚姻状况
    gen a_marriage = marriage_14 if marriage_14 > 0
    replace a_marriage = cfps2012_marriage if a_marriage ==. & cfps2012_marriage>0
    foreach wave in 12 10 {
        replace a_marriage = marriage_`wave' if a_marriage == .
    }

* Number of Children / 孩子数
    gen a_nchild = nchild

*qea201y qea205y qea2071 qea202 qea203code

**********************************
* Part8. Political Experience & Attitudes
**********************************

* CCP Membership / 党员
    gen a_ccp = .
    forvalues i = 1/4 {
        replace a_ccp = 1 if qn401_s_`i'==1
    }
    replace a_ccp = 1 if pn401a==1
    replace a_ccp = 0 if (qn401_s_1<0|qn401_s_1==.) & (pn401a<0|pn401a==.) & a_ccp==.
    foreach wave in 12 10 {
        replace a_ccp = ccp_`wave' if a_ccp == .
    }
            
**********************************
* Save Data Temporarily
**********************************      

//  Keep Generated Variables 
    keep a_*
    
//  Rename Variables for Later Usage
    rename a_* *_14
    rename pid_14 pid
    
//  Include Information from Child Dataset
    append using "$data_gen/cfps14_ind.dta"
    
//  Save Data for Later Usage
    sort pid
    save "$data_gen/cfps14_ind.dta", replace
