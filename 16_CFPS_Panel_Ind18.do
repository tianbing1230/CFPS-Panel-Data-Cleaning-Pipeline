version 15

**======================================================**
**            Information of Family Members             **
**======================================================**

    use "$f_raw_2018_famconf", clear
    gen nchild = 0
    foreach var of varlist code_a_c* {
        replace nchild = nchild+1 if `var'>=0 & `var'!=.
    }
    keep pid pid_a_f code_a_f tb4_a18_f pid_a_m code_a_m tb4_a18_m pid_a_s code_a_s tb1y_a_s tb4_a18_s nchild
    save "$f_out_fammember18", replace

**========================================**
**            CFPS 2018 Child             **
**========================================**

    use "$f_raw_2018_childproxy", clear

    merge 1:1 pid using "$f_raw_2018_crossyearid", ///
        keep(master match) nogen replace update ///
        keepusing(birthy gender ethnicity subsample fid18 marriage_18 cfps2018edu cfps2018sch cfps2018eduy cfps2018eduy_im urban18 hk18 employ18)

    merge 1:1 pid using "$f_out_fammember18", keep(master match) nogen replace update

    foreach wave in 16 14 12 10 {
        merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", nogen keep(master match)
    }

**********************************
* Part0. Identifiers
**********************************

    mvdecode pid fid18 countyid18 provcd18 *cyear *cmonth interviewerid18 rswt_natcs18n rswt_natpn1018n subsample, mv(-10/-1)

* Individual ID / 个人ID
    clonevar a_pid = pid

* Family ID / 家庭ID
    clonevar a_fid = fid18

* Community ID / 社区ID
    gen a_cid = .

* County ID / 区县ID
    clonevar a_countyid = countyid18

* Province Code / 省代码
    gen a_provcd = provcd18

* Wave ID / 调查轮次
    gen a_wave = 18

* Survey Year / 问卷调查年
    gen a_syear = cyear

* Survey Year / 问卷调查月
    gen a_smonth = cmonth

* Questionnaire Type / 问卷类别
    gen a_qtype = 1

* Interviewer ID / 访员ID
    clonevar a_interviewerid = interviewerid18

* Weight_National / 个人权重-全国样本
    clonevar a_rswt_nat = rswt_natcs18n

* Weight_National_Panel / 个人权重-全国样本
    clonevar a_rswt_nat_p = rswt_natpn1018n

* Resample / 是否在全国再抽样样本中
    clonevar a_resample = subsample

**********************************
* Part1. Basic Demographics
**********************************

*  Birth year / 出生年
    gen a_birthy = birthy if birthy >= 0

*  Age in Survey Year / 年龄（调查年）
    gen a_age = 2018-birthy

*  Gender / 性别
    gen a_gender = gender

* Ethnicity / 民族
    gen a_ethnicity = ethnicity

* Han / 汉族
    gen a_han = ethnicity==1
    replace a_han = . if ethnicity == .

*  Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban = urban18 if urban18 >= 0
    foreach wave in 16 14 12 10 {
        replace a_urban = urban_`wave' if a_urban == .
    }

*  Hukou / 户口
    recode hk18 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)
    foreach wave in 16 14 12 10 {
        replace a_hukou = hukou_`wave' if a_hukou == .
    }

*  Hukou (Province) / 户口所在省
    gen a_hkprov = wa302acode if wa302acode > 0
    replace a_hkprov = a_provcd if inlist(wa302, 1,2,3,4,5) // hk in residential province
    foreach wave in 16 14 12 10 {
        replace a_hkprov = hkprov_`wave' if a_hkprov == .
    }

**********************************
* Part2. Education
**********************************

* Highest Educational Level Attained / 最高学历
    gen a_edu = cfps2018edu if cfps2018edu > 0
     foreach wave in 16 14 12 10 {
        replace a_edu = edu_`wave' if a_edu == .
    }

* Highest Educational Level Attend / 在读/离校阶段
    gen a_sch = cfps2018sch if cfps2018sch > 0
    foreach wave in 16 14 12 10 {
        replace a_sch = sch_`wave' if a_sch == .
    }
* Years of Education Received / 教育年限
    gen a_eduy = cfps2018eduy if cfps2018eduy >= 0
    foreach wave in 16 14 12 10 {
        replace a_eduy = eduy_`wave' if a_eduy == .
    }

* Years of Education Received (Imputation) / 教育年限（插补值）
    gen a_eduy_im = cfps2018eduy_im if cfps2018eduy_im >= 0
    foreach wave in 16 14 12 10 {
        replace a_eduy_im = eduy_im_`wave' if a_eduy_im == .
    }

**********************************
* Part5. Family Socioecnomic Status
**********************************

* Birthplace (Province) / 出生省份
    gen a_birthprov = provcd18 if provcd18>0
    replace a_birthprov = wa401acode if wa401acode>0
    foreach wave in 16 14 12 10 {
        replace a_birthprov = birthprov_`wave' if a_birthprov==.
    }

* Residence (Province) When R in Adolescence / 青少年时居住省份
    gen a_yresprov = wa602acode if wa602acode > 0
    replace a_yresprov = wa502acode if wa502acode > 0 & a_yresprov == .
    replace a_yresprov = a_birthprov if a_yresprov == .
    foreach wave in 16 14 12 10 {
        replace a_yresprov = yresprov_`wave' if a_yresprov==.
    }

* Hukou When R in Adolescence / 青少年时户口
    recode wa301 (1=0) (3=1) (5 79=2) (else=.), gen(a_yhukou)
    foreach wave in 16 14 12 10 {
        replace a_yhukou = yhukou_`wave' if a_yhukou==.
    }

* Number of Siblings / 兄弟姐妹数
    gen a_nsib = .
    foreach wave in 16 14 12 10 {
        replace a_nsib = nsib_`wave' if a_nsib==.
    }

* Father's Highest Educational Level Attained / 父亲最高学历
* Mother's Highest Educational Level Attained / 母亲最高学历
    gen a_fedu = tb4_a18_f if tb4_a18_f >= 0
    foreach wave in 16 14 12 10 {
        replace a_fedu = fedu_`wave' if a_fedu == .
    }
    gen a_medu = tb4_a18_m if tb4_a18_m >=0
    foreach wave in 16 14 12 10 {
        replace a_medu = medu_`wave' if a_medu == .
    }

* Father's Occupation (ISCO88) / 父亲职业（ISCO88）
* Mother's Occupation (ISCO88) / 母亲职业（ISCO88）
    gen a_focctype_isco = .
    foreach wave in 16 14 12 10 {
        replace a_focctype_isco = focctype_isco_`wave' if a_focctype_isco == .
    }
    gen a_mocctype_isco = .
    foreach wave in 16 14 12 10 {
        replace a_mocctype_isco = mocctype_isco_`wave' if a_mocctype_isco == .
    }

* Father's Occupation ISEI / 父亲职业ISEI
* Mother's Occupation ISEI / 母亲职业ISEI
    iskoisei a_foccisei, isko(a_focctype_isco)
    iskoisei a_moccisei, isko(a_mocctype_isco)

* Whether Father's a CCP Member
* Whether Mother's a CCP Member
    gen a_fccp = .
    foreach wave in 16 14 12 10 {
        replace a_fccp = fccp_`wave' if a_fccp == .
    }
    gen a_mccp = .
    foreach wave in 16 14 12 10 {
        replace a_mccp = mccp_`wave' if a_mccp == .
    }

* Father's ID / 父亲ID
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

**********************************
* Part6. Cognitive/Non-cognitive/Language Abilities
**********************************

* Intelligence Level (Interviewer Grading) / 智力水平（访员打分）
    gen a_intelligence_ir = wz207 if wz207 > 0

**********************************
* Save Data Temporarily
**********************************

*  Keep Generated Variables
    keep a_*

*  Rename Variables for later Usage
    rename a_* *_18
    rename pid_18 pid

*  Save Data for Later Usage
    sort pid
    save "$data_gen/cfps18_ind.dta", replace

**========================================**
**            CFPS 2018 Adult             **
**========================================**    
    use "$f_raw_2018_person", clear
    
    merge 1:1 pid using "$f_raw_2018_crossyearid", ///
        keep(master match) nogen replace update ///
        keepusing(birthy gender ethnicity subsample fid18 marriage_18 cfps2018edu cfps2018sch cfps2018eduy cfps2018eduy_im urban18 hk18 employ18)

    merge 1:1 pid using "$f_out_fammember18", keep(master match) nogen replace update

    foreach wave in 16 14 12 10 {
        merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", nogen keep(master match)
    }

**********************************
* Part0. Identifiers
**********************************

    mvdecode pid fid18 countyid18 provcd18 *cyear *cmonth interviewerid18 rswt_natcs18n rswt_natpn1018n subsample, mv(-10/-1)

* Individual ID / 个人ID
    clonevar a_pid = pid

* Family ID / 家庭ID
    clonevar a_fid = fid18

* Community ID / 社区ID
    gen a_cid = .

* County ID / 区县ID
    clonevar a_countyid = countyid18

* Province Code / 省代码
    gen a_provcd = provcd18

* Wave ID / 调查轮次
    gen a_wave = 18

* Survey Year / 问卷调查年
    gen a_syear = cyear

* Survey Year / 问卷调查月
    gen a_smonth = cmonth

* Questionnaire Type / 问卷类别
    gen a_qtype = 0

* Interviewer ID / 访员ID
    clonevar a_interviewerid = interviewerid18

* Weight_National / 个人权重-全国样本
    clonevar a_rswt_nat = rswt_natcs18n

* Weight_National_Panel / 个人权重-全国样本
    clonevar a_rswt_nat_p = rswt_natpn1018n

* Resample / 是否在全国再抽样样本中
    clonevar a_resample = subsample
    
**********************************
* Part1. Basic Demographics
**********************************  

*  Birth year / 出生年
    gen a_birthy = birthy if birthy >= 0

*  Age in Survey Year / 年龄（调查年）
    gen a_age = 2018-birthy

*  Gender / 性别
    gen a_gender = gender

* Ethnicity / 民族
    gen a_ethnicity = ethnicity

* Han / 汉族
    gen a_han = ethnicity==1
    replace a_han = . if ethnicity == .

*  Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban = urban18 if urban18 >= 0
    foreach wave in 16 14 12 10 {
        replace a_urban = urban_`wave' if a_urban == .
    }

*  Hukou / 户口
    recode hk18 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)
    foreach wave in 16 14 12 10 {
        replace a_hukou = hukou_`wave' if a_hukou == .
    }

*  Hukou (Province) / 户口所在省
    gen a_hkprov = qa302a_code if qa302a_code > 0
    replace a_hkprov = a_provcd if inlist(qa302, 1,2,3,4,5) // hukou in residential province
    foreach wave in 16 14 12 10 {
        replace a_hkprov = hkprov_`wave' if a_hkprov == . 
    }

**********************************
* Part2. Education
**********************************

* Highest Educational Level Attained / 最高学历
    gen a_edu = cfps2018edu if cfps2018edu > 0
     foreach wave in 16 14 12 10 {
        replace a_edu = edu_`wave' if a_edu == .
    }

* Highest Educational Level Attend / 在读/离校阶段
    gen a_sch = cfps2018sch if cfps2018sch > 0
    foreach wave in 16 14 12 10 {
        replace a_sch = sch_`wave' if a_sch == .
    }
* Years of Education Received / 教育年限
    gen a_eduy = cfps2018eduy if cfps2018eduy >= 0
    foreach wave in 16 14 12 10 {
        replace a_eduy = eduy_`wave' if a_eduy == .
    }

* Years of Education Received (Imputation) / 教育年限（插补值）
    gen a_eduy_im = cfps2018eduy_im if cfps2018eduy_im >= 0
    foreach wave in 16 14 12 10 {
        replace a_eduy_im = eduy_im_`wave' if a_eduy_im == .
    }

* Field of Study of the Highest Degree / 最高学历专业
    gen a_major = .
    foreach var in qs701_b_1code kw1003_a_1code qs9code kw1003_a_2code kw1003_a_3code kw1003_a_4code {
        replace a_major = `var' if `var'>0
    }
    foreach wave in 16 14 12 10 {
        replace a_major = major_`wave' if a_major == .
    }

* College Type / 本科学校类型
    gen a_collegetype = qs1_b_1code-1 if qs1_b_1code > 1 & qs1_b_1code < 99
    replace a_collegetype = 1 if qs1_b_1code == 1
    replace qs1_b_1code = 99 if qs1_b_1code == 99
    foreach wave in 16 14 12 10 {
        replace a_collegetype = collegetype_`wave' if a_collegetype == .
    }

**********************************
* Part3. Labor Market Outcomes
**********************************      

    mvdecode qg303code_isco qg303code_isei, mv(-10/-1)

* Labor Market Participation / 经济活动情况
    gen a_employ = employ18 if employ18 >= 0

* Current Occupation Employment Status / 当前职业就业身份
    recode jobclass_base (3/5=1) (2=2) (1=3) (else=.), gen(a_employs)
    
* Current Occupation Type (ISCO88/08) / 当前职业（ISCO88/08） 
    gen a_occtype_isco = qg303code_isco if qg303code_isco > 0
    
* Current Occupation (10 Categories) / 当前职业（10类）
    gen a_occtype_crude = floor(a_occtype_isco/1000)
    
* Current Occupation ISEI / 当前职业ISEI
    gen a_occisei = qg303code_isei if qg303code_isei >= 0
    
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
    recode qg15 (1 3=1) (2 78 79=0) (else=.), gen(a_promote_e)
    recode qg15 (2 3=1) (1 78 79=0) (else=.), gen(a_promote_t)

* Administrative Management Position / 行政管理职务
    // Specific Position Not Issued Yet
    gen a_mngpos = qg14 if qg14 >= 0

* Number of Subordinates / 负责管理人数
    gen a_subnum = qg1701 if qg1701 >= 0
    replace a_subnum = 0 if qg17 == 5
        
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
        replace `var' = 2015 if `var' == 2020
    }
    gen a_tenure = egc1053y - egc1052y if egc1052y > 0 & egc1053y > 0
    
* Working Hours Per Week / 每周工作小时数
    gen a_wkhr = qg6 if qg6 >= 0

* Self-rated Education Level Needed for Current Occupation / 胜任当前工作所需教育程度
    gen a_occedu = kg1302 if kg1302>0
    replace a_occedu = kgd2 if a_occedu==. & kgd2>0
    replace a_occedu = a_occedu-1
    replace a_occedu = 1 if a_occedu == 10

* First Occupation Type (ISCO88) / 初职（ISCO88）
    gen a_occtype_isco_1st = qg303code_isco if qgd0 == 1 & qg303code_isco > 0
    foreach wave in 16 14 12 10 {
        replace a_occtype_isco_1st = occtype_isco_1st_`wave' if a_occtype_isco_1st == .
    }   

**********************************
* Part4. Income
**********************************  
    mvdecode qg11 qg12 qg1201_min qg1201_max incomeb qg1203 qg1204_min qg1204_max income, mv(-10/0)
    
* Main Job Monthly Wage / 当前主要工作月均收入
    gen a_mwage = qg11
    
* Main Job Hourly Wage / 当前主要工作小时工资
    gen a_hwage = qg11/(qg6/7*30) if qg6 > 0

* Main Job Annual Income (Bonus Included) / 当前主要工作年收入（包括奖金等）
    replace qg12 = (qg1201_min+qg1201_max)/2 if qg12==. & qg1201_min!=. & qg1201_max!=.
    gen a_ywage = qg12
    replace a_ywage = incomeb if (a_ywage == . | a_ywage == 0) & incomeb != .
    
* Annual Income from All Jobs (Bonus Included) / 所有工作年收入（包括奖金等）
    replace qg1203 = (qg1204_min+qg1204_max)/2 if qg1203==. & qg1204_min!=. & qg1204_max!=.
    egen a_ywaget = rowmax(qg12 qg1203 income incomeb)
        
* Annual Total Income / 年总收入

**********************************
* Part5. Family Socioecnomic Status     
**********************************      

* Birthplace (Province) / 出生省份
    gen a_birthprov = qa401a_code if qa401a_code>0
    replace a_birthprov = provcd18 if provcd18>0 & a_birthprov==.
    foreach wave in 16 14 12 10 {
        replace a_birthprov = birthprov_`wave' if a_birthprov==.
    }
    
* Residence (Province) When R in Adolescence / 青少年时居住省份
    gen a_yresprov = qa602a_code if qa602a_code > 0
    replace a_yresprov = a_birthprov if a_yresprov == .
    foreach wave in 16 14 12 10 {
        replace a_yresprov = yresprov_`wave' if a_yresprov==.
    }
    
* Hukou When R in Adolescence / 青少年时户口
    recode qa603 (1=0) (3=1) (5 79=2) (else=.), gen(a_yhukou)
    foreach wave in 16 14 12 10 {
        replace a_yhukou = yhukou_`wave' if a_yhukou==.
    }   
    
* Number of Siblings / 兄弟姐妹数
    gen a_nsib = .
    foreach wave in 16 14 12 10 {
        replace a_nsib = nsib_`wave' if a_nsib==.
    }   

* Father's Highest Educational Level Attained / 父亲最高学历
* Mother's Highest Educational Level Attained / 母亲最高学历
    gen a_fedu = tb4_a18_f if tb4_a18_f >= 0
    foreach wave in 16 14 12 10 {
        replace a_fedu = fedu_`wave' if a_fedu == .
    }
    gen a_medu = tb4_a18_m if tb4_a18_m >=0
    foreach wave in 16 14 12 10 {
        replace a_medu = medu_`wave' if a_medu == .
    }

* Father's Occupation (ISCO88) / 父亲职业（ISCO88）
* Mother's Occupation (ISCO88) / 母亲职业（ISCO88）
    gen a_focctype_isco = .
    foreach wave in 16 14 12 10 {
        replace a_focctype_isco = focctype_isco_`wave' if a_focctype_isco == .
    }
    gen a_mocctype_isco = .
    foreach wave in 16 14 12 10 {
        replace a_mocctype_isco = mocctype_isco_`wave' if a_mocctype_isco == .
    }

* Father's Occupation ISEI / 父亲职业ISEI
* Mother's Occupation ISEI / 母亲职业ISEI
    iskoisei a_foccisei, isko(a_focctype_isco)
    iskoisei a_moccisei, isko(a_mocctype_isco)

* Whether Father's a CCP Member
* Whether Mother's a CCP Member
    gen a_fccp = .
    foreach wave in 16 14 12 10 {
        replace a_fccp = fccp_`wave' if a_fccp == .
    }
    gen a_mccp = .
    foreach wave in 16 14 12 10 {
        replace a_mccp = mccp_`wave' if a_mccp == .
    }

* Father's ID / 父亲ID
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

**********************************
* Part6. Cognitive/Non-cognitive/Language Abilities         
**********************************      

* Original Score for Word Test / 字词测试原始得分
    gen a_word = wordtest18 if wordtest18 >= 0
    gen a_word2 = wordtest18_sc2 if wordtest18_sc2 >= 0

* Original Score for Math Test / 数学测试原始得分
    gen a_math = mathtest18 if mathtest18 >= 0
    gen a_math2 = mathtest18_sc2 if mathtest18_sc2 >= 0

* Intelligence Level (Interviewer Grading) / 智力水平（访员打分）
    gen a_intelligence_ir = kz207 if kz207 > 0

**********************************
* Part7. Marriage Related
**********************************  
    
* Current Marital Status / 当前婚姻状况
    gen a_marriage = marriage_18 if marriage_18 > 0
    replace a_marriage = marriage_last if a_marriage ==. &  marriage_last>0
    replace a_marriage = marriage_last_update if a_marriage ==. &  marriage_last_update>0
    foreach wave in 16 14 12 10 {
        replace a_marriage = marriage_`wave' if a_marriage == .
    }

* Number of Children / 孩子数
    gen a_nchild = nchild

**********************************
* Part8. Political Experience & Attitudes
**********************************

* CCP Membership / 党员
    gen a_ccp = qn4001 if qn4001>=0
    replace a_ccp = party if party>=0 & a_ccp==.
    foreach wave in 16 14 12 10 {
        replace a_ccp = ccp_`wave' if a_ccp == .
    }
            
**********************************
* Save Data Temporarily
**********************************      

//  Keep Generated Variables 
    keep a_*
    
//  Rename Variables for Later Usage
    rename a_* *_18
    rename pid_18 pid
    
//  Include Information from Child Dataset
    append using "$data_gen/cfps18_ind.dta"
    gsort -qtype
    duplicates drop pid, force // pid duplicates
    
//  Save Data for Later Usage
    sort pid
    save "$data_gen/cfps18_ind.dta", replace
    
