version 15

**======================================================**
**            Information of Family Members             **
**======================================================**

    use "$f_raw_2012_famconf", clear
    duplicates drop pid, force
    gen nchild = 0
    foreach var of varlist code_a_c* {
        replace nchild = nchild+1 if `var'>=0 & `var'!=.
    }
    keep pid nchild feduc12 meduc12 code_a_f pid_f tb4_a12_f qa301_a12_f code_a_m pid_m tb4_a12_m qa301_a12_m code_a_s pid_s tb1y_a_s tb4_a12_s qa301_a12_s
    save "$f_out_fammember12", replace

**========================================**
**            CFPS 2012 Child             **
**========================================**

    use "$f_raw_2012_child", clear

    foreach wave in 10 {
        merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", nogen keep(master match)
    }

    merge 1:1 pid using "$f_raw_2018_crossyearid", ///
        keep(master match) nogen replace update ///
        keepusing(birthy gender ethnicity subsample fid12 marriage_12 cfps2012edu cfps2012sch cfps2012eduy cfps2012eduy_im urban12 hk12)

    merge 1:1 pid using "$f_out_fammember12", keep(master match) nogen replace update

**********************************
* Part0. Identifiers
**********************************

    mvdecode pid fid12 cid countyid provcd cyear cmonth interviewerid rswt_natcs12 rswt_rescs12 rswt_natpn1012 rswt_respn1012 subsample, mv(-10/-1)
    
* Individual ID / 个人ID
    clonevar a_pid = pid
    
* Family ID / 家庭ID
    clonevar a_fid = fid12

* Community ID / 社区ID
    clonevar a_cid = cid

* County ID / 区县ID
    clonevar a_countyid = countyid

* Province Code / 省代码
    gen a_provcd = provcd

* Wave ID / 调查轮次
    gen a_wave = 12
    
* Survey Year / 问卷调查年
    gen a_syear = cyear
    
* Survey Year / 问卷调查月
    gen a_smonth = cmonth

* Questionnaire Type / 问卷类别
    gen a_qtype = 0
    
* Interviewer ID / 访员ID
    clonevar a_interviewerid = interviewerid

* Weight_National / 个人权重-全国样本
    clonevar a_rswt_nat = rswt_natcs12

* Weight_Resample / 个人权重-全国再抽样样本
    clonevar a_rswt_res = rswt_rescs12

* Weight_National_Panel / 个人权重-全国样本
    clonevar a_rswt_nat_p = rswt_natpn1012

* Weight_Resample_Panel / 个人权重-全国再抽样样本
    clonevar a_rswt_res_p = rswt_respn1012

* Resample / 是否在全国再抽样样本中
    clonevar a_resample = subsample

**********************************
* Part1. Basic Demographics
**********************************  
    
*  Birth year / 出生年
    gen a_birthy = birthy

*  Age in Survey Year / 年龄（调查年）
    gen a_age = 2012-birthy
    replace a_age = age_10 + 2 if a_age==.

*  Gender / 性别
    gen a_gender = gender

* Ethnicity / 民族
    gen a_ethnicity = ethnicity

* Han / 汉族
    gen a_han = ethnicity==1
    replace a_han = . if ethnicity == .
    
*  Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban = urban12 if urban12 >= 0
    replace a_urban = urbancomm if urbancomm>=0 & a_urban==.
    foreach wave in 10 {
        replace a_urban = urban_`wave' if a_urban == .
    }
    
*  Hukou / 户口
    recode hk12 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)
    foreach wave in 10 {
        replace a_hukou = hukou_`wave' if a_hukou == .
    }
    
*  Hukou (Province) / 户口所在省
    gen a_hkprov = wa501m_3code if wa501m_3code > 0
    replace a_hkprov = a_provcd if inlist(wa501m, 1,2,3,4) // hk in residential province
    foreach wave in 10 {
        replace a_hkprov = hkprov_`wave' if a_hkprov == . 
    }
    
**********************************
* Part2. Education
**********************************  

* Highest Educational Level Attained / 最高学历
    gen a_edu = cfps2012edu if cfps2012edu > 0
    foreach wave in 10 {
        replace a_edu = edu_`wave' if a_edu == .
    }

* Highest Educational Level Attend / 在读/离校阶段
    gen a_sch = cfps2012sch if cfps2012sch > 0
    foreach wave in 10 {
        replace a_sch = sch_`wave' if a_sch == .
    }
* Years of Education Received / 教育年限
    gen a_eduy = cfps2012eduy if cfps2012eduy >= 0
    foreach wave in 10 {
        replace a_eduy = eduy_`wave' if a_eduy == .
    }

* Years of Education Received (Imputation) / 教育年限（插补值）
    gen a_eduy_im = cfps2012eduy_im if cfps2012eduy_im >= 0
    foreach wave in 10 {
        replace a_eduy_im = eduy_im_`wave' if a_eduy_im == .
    }

**********************************
* Part5. Family Socioecnomic Status     
**********************************      

* Birthplace (Province) / 出生省份
    gen a_birthprov = wa107m_3code if wa107m_3code > 0
    replace a_birthprov = provcd if a_birthprov==.
    replace a_birthprov = birthprov_10 if birthprov_10!=.   

* Residence (Province) When R in Adolescence / 青少年时居住省份
    gen a_yresprov = provcd if provcd > 0
    replace a_yresprov = wa2m_3code if a_yresprov==. & wa2m_3code>0
    replace a_yresprov = yresprov_10 if a_yresprov==.
    
* Hukou When R in Adolescence / 青少年时户口
    recode wa4 (1=0) (3=1) (5 79=2) (else=.), gen(a_yhukou)
    replace a_yhukou = yhukou_10 if a_yhukou==.
    
* Number of Siblings / 兄弟姐妹数
    gen a_nsib = nsib_10
    
* Father's Highest Educational Level Attained / 父亲最高学历
* Mother's Highest Educational Level Attained / 母亲最高学历
    gen a_fedu = feduc12 if feduc12 >= 0
    replace a_fedu = tb4_a12_f if tb4_a12_f>=0 & a_fedu == .
    replace a_fedu = fedu_10 if a_fedu == .
    gen a_medu = meduc12 if meduc12 >=0
    replace a_medu = tb4_a12_m if tb4_a12_m>=0 & a_medu == .
    replace a_medu = medu_10 if a_medu == .

* Father's Occupation (ISCO88) / 父亲职业（ISCO88）
* Mother's Occupation (ISCO88) / 母亲职业（ISCO88）
    gen a_focctype_isco = focctype_isco_10
    gen a_mocctype_isco = mocctype_isco_10
    
* Father's Occupation ISEI / 父亲职业ISEI
* Mother's Occupation ISEI / 母亲职业ISEI
    iskoisei a_foccisei, isko(a_focctype_isco)
    iskoisei a_moccisei, isko(a_mocctype_isco)
    
* Whether Father's a CCP Member 
* Whether Mother's a CCP Member 
    gen a_fccp = .
    replace a_fccp = fccp_10 if a_fccp == .
    gen a_mccp = .
    replace a_mccp = mccp_10 if a_mccp == .
    
* Father's ID / 父亲ID
* Mother's ID / 母亲ID
    clonevar a_pid_f = pid_f if pid_f >= 0
    replace a_pid_f = fid12*1000 + code_a_f if code_a_f>0 & a_pid_f == .
    replace a_pid_f = pid_f_10 if a_pid_f == .
    clonevar a_pid_m = pid_m if pid_m >=0
    replace a_pid_m = fid12*1000 + code_a_m if code_a_m>0 & a_pid_m == .
    replace a_pid_m = pid_m_10 if a_pid_m == .

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
    rename a_* *_12
    rename pid_12 pid
    
//  Save Data for Later Usage
    sort pid
    save "$data_gen/cfps12_ind.dta", replace

    
**========================================**
**            CFPS 2012 Adult             **
**========================================**

    use "$f_raw_2012_adult", clear

    foreach wave in 10 {
        merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", nogen keep(master match)
    }
    
    merge 1:1 pid using "$f_raw_2018_crossyearid", ///
        keep(master match) nogen replace update ///
        keepusing(birthy gender ethnicity subsample fid12 marriage_12 cfps2012edu cfps2012sch cfps2012eduy cfps2012eduy_im urban12 hk12 employ12)

    merge 1:1 pid using "$f_out_fammember12", keep(master match) nogen replace update

**********************************
* Part0. Identifiers
**********************************

    mvdecode pid fid12 cid countyid provcd cyear cmonth interviewerid rswt_natcs12 rswt_rescs12 rswt_natpn1012 rswt_respn1012 subsample, mv(-10/-1)
    
* Individual ID / 个人ID
    clonevar a_pid = pid
    
* Family ID / 家庭ID
    clonevar a_fid = fid12

* Community ID / 社区ID
    clonevar a_cid = cid

* County ID / 区县ID
    clonevar a_countyid = countyid

* Province Code / 省代码
    gen a_provcd = provcd

* Wave ID / 调查轮次
    gen a_wave = 12
    
* Survey Year / 问卷调查年
    gen a_syear = cyear
    
* Survey Year / 问卷调查月
    gen a_smonth = cmonth

* Questionnaire Type / 问卷类别
    gen a_qtype = 1
    
* Interviewer ID / 访员ID
    clonevar a_interviewerid = interviewerid

* Weight_National / 个人权重-全国样本
    clonevar a_rswt_nat = rswt_natcs12

* Weight_Resample / 个人权重-全国再抽样样本
    clonevar a_rswt_res = rswt_rescs12

* Weight_National_Panel / 个人权重-全国样本
    clonevar a_rswt_nat_p = rswt_natpn1012

* Weight_Resample_Panel / 个人权重-全国再抽样样本
    clonevar a_rswt_res_p = rswt_respn1012

* Resample / 是否在全国再抽样样本中
    clonevar a_resample = subsample

**********************************
* Part1. Basic Demographics
**********************************  
    
*  Birth year / 出生年
    gen a_birthy = birthy
    
*  Age in Survey Year / 年龄（调查年）
    gen a_age = 2012-birthy
    replace a_age = 2012-a_birthy if a_age==.
    
*  Gender / 性别
    gen a_gender = gender

* Ethnicity / 民族
    gen a_ethnicity = ethnicity

* Han / 汉族
    gen a_han = ethnicity==1
    replace a_han = . if ethnicity == .

*  Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban = urban12 if urban12 >= 0   
    replace a_urban = urbancomm if urbancomm>=0 & a_urban==.
    foreach wave in 10 {
        replace a_urban = urban_`wave' if a_urban == . 
    }

*  Hukou / 户口
    recode hk12 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)
    foreach wave in 10 {
        replace a_hukou = hukou_`wave' if a_hukou == .
    }
    
*  Hukou (Province) / 户口所在省
    gen a_hkprov = qa302ccode if qa302ccode > 0
    replace a_hkprov = a_provcd if inlist(qa302, 1,2,3,4) // hk in residential province
    foreach wave in 10 {
        replace a_hkprov = hkprov_`wave' if a_hkprov == . 
    }
    
**********************************
* Part2. Education
**********************************  

* Highest Educational Level Attained / 最高学历
    gen a_edu = cfps2012edu if cfps2012edu > 0
    foreach wave in 10 {
        replace a_edu = edu_`wave' if a_edu == .
    }

* Highest Educational Level Attend / 在读/离校阶段
    gen a_sch = cfps2012sch if cfps2012sch > 0
    foreach wave in 10 {
        replace a_sch = sch_`wave' if a_sch == .
    }
* Years of Education Received / 教育年限
    gen a_eduy = cfps2012eduy if cfps2012eduy >= 0
    foreach wave in 10 {
        replace a_eduy = eduy_`wave' if a_eduy == .
    }

* Years of Education Received (Imputation) / 教育年限（插补值）
    gen a_eduy_im = cfps2012eduy_im if cfps2012eduy_im >= 0
    foreach wave in 10 {
        replace a_eduy_im = eduy_im_`wave' if a_eduy_im == .
    }

* Field of Study of the Highest Degree / 最高学历专业
    gen a_major = .
    foreach var in kw902 kr801m kw802 kr701 kw702 kra601 kw602 kr501 {
        replace a_major = `var' if `var' > 0 & `var' != 77  
    }
    foreach wave in 10 {
        replace a_major = major_`wave' if a_major == .
    }

* College Type / 本科学校类型
    gen a_collegetype = .
    foreach wave in 10 {
        replace a_collegetype = collegetype_`wave' if a_collegetype == .
    }
    
**********************************
* Part3. Labor Market Outcomes
**********************************  

* Labor Market Participation / 经济活动情况
    gen a_employ = employ12 if employ12 >= 0

* Current Occupation Employment Status / 当前职业就业身份
    gen a_employs = .

* Current Occupation Type (ISCO88) / 当前职业（ISCO88）
    * Main Occupation Defined by CFPS
    gen occ = job2012mn_occu if job2012mn_occu>0 
    replace occ = sg411code_best if sg411code_best>0
    * Non-farming Last/Current Occupation
    *
    gen joblastdate = 0
    gen type = ""
    gen num = .
    local type b c1 c2
    forvalues m = 1/3 {
        local i: word `m' of `type'
        forvalues j = 1/10 {
            replace type = "`i'" if job`i'lastdate_a_`j' > joblastdate & job`i'lastdate_a_`j' != .
            replace num = `j' if job`i'lastdate_a_`j' > joblastdate & job`i'lastdate_a_`j' != .
            replace joblastdate = job`i'lastdate_a_`j' if job`i'lastdate_a_`j' > joblastdate & job`i'lastdate_a_`j' != .
        }
    }   
    *
    gen cocc = .
    local type b c1 c2
    local qnum 411 510 609
    local N = _N
    forvalues n = 1/`N'{
        forvalues i = 1/3 {
            local t: word `i' of `type'
            local q: word `i' of `qnum'
            forvalues j = 1/10 {
                if type[`n'] == "`t'" & num[`n'] == `j' & qg`q'code_a_`j'[`n']>0 {
                    qui replace cocc = qg`q'code_a_`j' in `n'
                }
            }
        }
    }
    replace occ = cocc if occ==.
    * Farming
    replace occ = 50000 if (qg201==1 | qg301==1) & occ==. 
    
    csco2isco_cfps a_occtype_isco, csco(occ)
    
* Current Occupation (10 Categories) / 当前职业（10类）
    gen a_occtype_crude = floor(a_occtype_isco/1000)
    
* Current Occupation ISEI / 当前职业ISEI
    csco2isei_cfps a_occisei, csco(occ)
    
* Current Occupation Organization Type / 当前职业所在机构类型 
    gen a_orgtype = .
    replace a_orgtype = 1 if qg703 == 1
    replace a_orgtype = 2 if qg703 == 2
    replace a_orgtype = 3 if qg703 == 3
    replace a_orgtype = 4 if inlist(qg703, 4,5,6,7)
    replace a_orgtype = 5 if inlist(qg703, 8,9)
    replace a_orgtype = 6 if inlist(qg703, 10,11)
    replace a_orgtype = 7 if inlist(qg703, 12,13,14)    

* Number of Subordinates / 负责管理人数
    gen a_subnum = qg707 if qg707 >= 0
    replace a_subnum = 0 if qg706 == 5

* First Occupation Type (ISCO88) / 初职（ISCO88）
    gen a_occtype_isco_1st = .
    foreach wave in 10 {
        replace a_occtype_isco_1st = occtype_isco_1st_`wave' if a_occtype_isco_1st == .
    }
    
* Working Hours per Week / 每周工作小时数
    forvalues i=1/10 {
        gen wkhra`i' = (qg413_a_`i'/(30/7))*qg414_a_`i' if qg413_a_`i'>=0 & qg414_a_`i'>=0
        replace wkhra`i' = . if wkhra`i' >= 168
    }
    forvalues i=1/4 {
        gen wkhrb`i' = (qg512_a_`i'/(30/7))*qg513_a_`i' if qg512_a_`i'>=0 & qg513_a_`i'>=0
        replace wkhrb`i' = . if wkhrb`i' >= 168
    }
    gen wkhrc = (sg413/(30/7))*sg414 if sg413>=0 & sg414>=0
    replace wkhrc = . if wkhrc >= 168
    egen a_wkhr = rowmean(wkhra* wkhrb* wkhrc)
    replace a_wkhr = . if a_wkhr==0
    
    /*
    // first job from last survey time to now
        // Non-farming Last/Current Occupation 
    *
    replace joblastdate = 1000000000
    replace type = ""
    replace num = .
    local type b c1 c2
    forvalues m = 1/3 {
        local i: word `m' of `type'
        forvalues j = 1/10 {
            replace type = "`i'" if job`i'lastdate_a_`j' < joblastdate & job`i'lastdate_a_`j' != .
            replace num = `j' if job`i'lastdate_a_`j' < joblastdate & job`i'lastdate_a_`j' != .
            replace joblastdate = job`i'lastdate_a_`j' if job`i'lastdate_a_`j' < joblastdate & job`i'lastdate_a_`j' != .
        }
    }   
    *
    gen focc = .
    local type b c1 c2
    local qnum 411 510 609
    local N = _N
    forvalues n = 1/`N'{
        forvalues i = 1/3 {
            local t: word `i' of `type'
            local q: word `i' of `qnum'
            forvalues j = 1/10 {
                if type[`n'] == "`t'" & num[`n'] == `j' & qg`q'code_a_`j'[`n']>0 {
                    qui replace focc = qg`q'code_a_`j' in `n'
                }
            }
        }
    }
    // Farming
    replace focc = 50000 if (qg201==1 | qg301==1) & focc==. 
    */
    
**********************************
* Part4. Income
**********************************  

* Annual Income from All Jobs (Bonus Included) / 所有工作年收入（包括奖金等）
    /*gen qg416 = 0
    forvalues i = 1/30 {
        replace qg416 = qg416 + qg416_a_`i' if qg416_a_`i' > 0 & qg416_a_`i' != .
    }
    gen qg420 = 0
    forvalues i = 1/50 {
        replace qg420 = qg420 + qg420_a_`i' if qg420_a_`i' > 0 & qg420_a_`i' != .
    }       forvalues i = 1/4 {
        replace qg417_a_`i' = qg418est_a_`i' if qg417_a_`i' < 0 | qg417_a_`i' == .
    }
    gen qg417 = 0
    forvalues i = 1/10 {
        replace qg417 = qg417 + qg417_a_`i' if qg417_a_`i' > 0 & qg417_a_`i' != .
    }
    gen a_ywaget = qg417
    *+ 12 * (qg416 + qg420)
    foreach var in sg417 sg418est {
        replace a_ywaget = a_ywaget + `var' if `var' > 0 & `var' != .
    }
    replace a_ywaget = . if qg417_a_1==. & (sg417<0 | sg417==.) & (sg418est<0 | sg418est==.)
    */
    gen a_ywaget = income_adj

*  Annual Total Income / 年总收入
    *gen a_ywaget = income_adj

**********************************
* Part5. Family Socioecnomic Status     
**********************************      

* Birthplace (Province) / 出生省份
    gen a_birthprov = provcd
    replace a_birthprov = qa401ccode if qa401==5
    replace a_birthprov = birthprov_10 if birthprov_10!=.

* Residence (Province) When R in Adolescence / 青少年时居住省份
    gen a_yresprov = qa602ccode if qa602ccode > 0
    replace a_yresprov = qa502ccode if qa502ccode > 0 &  a_yresprov == .
    replace a_yresprov = yresprov_10 if a_yresprov == . 
    replace a_yresprov = a_birthprov if a_yresprov == .

* Hukou When R in Adolescence / 青少年时户口
    recode qa603 (1=0) (3=1) (5 79=2) (else=.), gen(a_yhukou)
    replace a_yhukou = yhukou_10 if a_yhukou == . 

* Number of Siblings / 兄弟姐妹数
    gen a_nsib = nsib_10

* Father's Highest Educational Level Attained / 父亲最高学历
* Mother's Highest Educational Level Attained / 母亲最高学历
    gen a_fedu = feduc12 if feduc12 > 0
    replace a_fedu = fedu_10 if fedu_10 != .
    gen a_medu = meduc12 if meduc12 > 0
    replace a_medu = medu_10 if medu_10 != .

* Father's Occupation (ISCO88) / 父亲职业（ISCO88）
* Mother's Occupation (ISCO88) / 母亲职业（ISCO88）
    gen a_focctype_isco = qv103_isco if qv103_isco > 0
    replace focctype_isco = focctype_isco_10 if focctype_isco_10 != .
    gen a_mocctype_isco = qv203_isco if qv203_isco > 0
    replace mocctype_isco = mocctype_isco_10 if mocctype_isco_10 != .

* Father's Occupation ISEI / 父亲职业ISEI
* Mother's Occupation ISEI / 母亲职业ISEI
    iskoisei a_foccisei, isko(a_focctype_isco)
    iskoisei a_moccisei, isko(a_mocctype_isco)

* Whether Father's a CCP Member / 父亲是否共产党员
* Whether Mother's a CCP Member / 母亲是否共产党员
    recode qv104 (1=1) (2/4=0) (else=.), gen(a_fccp)
    replace a_fccp = fccp_10 if a_fccp == .
    recode qv204 (1=1) (2/4=0) (else=.), gen(a_mccp)
    replace a_mccp = mccp_10 if a_mccp == .

* Father's ID / 父亲ID
* Mother's ID / 母亲ID
    clonevar a_pid_f = pid_f if pid_f>0
    replace a_pid_f = fid12*1000 + code_a_f if code_a_f > 0 & a_pid_f == .
    replace a_pid_f = pid_f_10 if a_pid_f == .
    clonevar a_pid_m = pid_m if pid_m>0
    replace a_pid_m = fid12*1000 + code_a_m if code_a_m > 0 & a_pid_m == .
    replace a_pid_m = pid_m_10 if a_pid_m == .

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
    gen a_marriage = marriage_12 if marriage_12 > 0
    replace a_marriage = cfps2010_marriage if a_marriage ==. & cfps2010_marriage>0
    foreach wave in 10 {
        replace a_marriage = marriage_`wave' if a_marriage == .
    }

* Year of First Marriage / 初婚年份
    gen a_fmarri_y = qe208y if qe208y > 0 & qe213 == 1
    replace a_fmarri_y = qe604y if qe604y > 0 & qe213 == 0
    replace a_fmarri_y = qec105y if qec105y > 0
    replace a_fmarri_y = qec702y if qec702y > 0
    foreach wave in 10 {
        replace a_fmarri_y = fmarri_y_`wave' if a_fmarri_y == .
    }

* Year of Current Marriage / 当前婚姻结婚年份
    gen a_cmarri_y = qe208y if qe208y > 0
    replace a_cmarri_y = qec105y if qec105y > 0
    foreach wave in 10 {
        replace a_cmarri_y = cmarri_y_`wave' if a_cmarri_y == .
    }

* Spousal ID / 配偶ID
    gen a_pid_s = pid_s if pid_s > 0
    replace a_pid_s = fid12*1000 + code_a_s if a_pid_s==. & code_a_s > 0
    foreach wave in 10 {
        replace a_pid_s = pid_s_`wave' if a_pid_s == .
    }

* Spouse's Birth Year / 配偶出生年份
    gen a_sbirthy = qe209y if qe209y > 0
    replace a_sbirthy = qec107y if qec107y > 0
    replace a_sbirthy = tb1y_a_s if tb1y_a_s > 0 & a_sbirthy == .
    foreach wave in 10 {
        replace a_sbirthy = sbirthy_`wave' if a_sbirthy == .
    }

* Spouse's Highest Educational Level Attained / 配偶最高学历
    gen a_sedu = tb4_a12_s if tb4_a12_s >= 0
    replace a_sedu = qe209a if qe209a >= 0 & a_sedu == .
    foreach wave in 10 {
        replace a_sedu = sedu_`wave' if a_sedu == .
    }

* Spouse's Years of Education / 配偶受教育年限
    *gen a_seduy = seduy if seduy >= 0

* Spouse's Occupation (ISCO88) / 配偶职业（ISCO88）
    gen a_socctype_isco = qe209b_isco if qe209b_isco >= 0

* Spouse's Occupation ISEI / 配偶职业ISEI
    iskoisei a_soccisei, isko(a_socctype_isco)

* Number of Children / 孩子数
    gen a_nchild = nchild

**********************************
* Part8. Political Experience & Attitudes
**********************************

* CCP Membership / 党员
    gen a_ccp = .
    forvalues i = 1/5 {
        replace a_ccp = 1 if qn401_s_`i'==1
    }
    replace a_ccp = 1 if sn401==1
    replace a_ccp = 0 if ((qn401_s_1>0&qn401_s_1!=.) | (sn401>0&sn401!=.)) & a_ccp==.
    foreach wave in 10 {
        replace a_ccp = ccp_`wave' if a_ccp == .
    }
    
**********************************
* Save Data Temporarily
**********************************      

//  Keep Generated Variables 
    keep a_*
    
//  Rename Variables for Later Usage
    rename a_* *_12
    rename pid_12 pid
    
//  Include Information from Child Dataset
    append using "$data_gen/cfps12_ind.dta"
    
//  Save Data for Later Usage
    sort pid
    save "$data_gen/cfps12_ind.dta", replace
