version 15

* Labeling module extracted from 20_CFPS_Panel_Individual_Crosswave.do
* Applies Chinese/English variable and value labels to $data_gen/cfps_ind.dta

**========================================**
**        Variable & Value Labels         **
**========================================**

	use "$data_gen/cfps_ind.dta", clear

**********************************
* Chinese Labels
**********************************

//  Set Label Language		
	label language Chinese, new

//  Variable Label 	
label var pid "个人ID"
label var fid "家庭ID"
label var cid "社区ID"
label var countyid "区县ID"
label var provcd "省编码"
label var wave "调查轮次"
label var syear "问卷调查年"
label var smonth "问卷调查月"
label var qtype "问卷类型"
label var interviewerid "访员ID"
label var rswt_nat "个人权重-全国样本"
label var rswt_res "个人权重-全国再抽样样本"
label var rswt_nat_p "追踪权重-全国样本"
label var rswt_res_p "追踪权重-全国再抽样样本"
label var resample "是否在全国再抽样样本中"

label var birthy "出生年"
label var age "年龄（调查年）"
label var gender "性别"
label var ethnicity "民族"
label var han "汉族"
label var urban "居住地（城乡）"
label var hukou "户口"
label var hkprov "户口所在省"

label var edu "最高学历"
label var sch "在读/离校阶段"
label var eduy "教育年限"
label var eduy_im "教育年限（插补值）"
label var major "最高学历专业"
label var collegetype "本科学校类型"

label var employ "就业状态"
label var employs "当前职业就业身份"
label var occtype_isco "当前职业（ISCO88/08）"
label var occtype_crude "当前职业（10类）"
label var occisei "当前职业ISEI"
label var industry "当前职业所在行业"
label var orgtype "当前职业所在机构类型"
label var occtype_isco_1st "初职（ISCO88）"
label var promote_e "去年是否获得行政职务晋升"
label var promote_t "去年是否获得技术职称晋升"
label var mngpos "行政管理职务"
label var subnum "负责管理人数"
label var wksat_inc "对目前工作收入的满意度"
label var wksat_safe "对目前工作安全性的满意度"
label var wksat_env "对目前工作环境的满意度"
label var wksat_wkh "对目前工作时间的满意度"
label var wksat_prom  "对目前工作晋升机会的满意度"
label var wksat_all "对目前工作的总体满意度"
label var tenure "当前职业工龄"
label var occedu "胜任当前工作所需教育程度"

label var mwage "当前主要工作月均工资"
label var hwage "当前主要工作小时工资"
label var ywage "当前主要工作年收入（包括奖金等）"
label var ywaget "所有工作年收入（包括奖金等）"
label var income "年总收入"

label var birthprov "出生省份"
label var yresprov "青少年时居住省份"
label var yhukou "青少年时户口"
label var nsib "兄弟姐妹数"
label var fedu "父亲最高学历"
label var medu "母亲最高学历"
label var focctype_isco "父亲职业（ISCO88）"
label var mocctype_isco "母亲职业（ISCO88）"
label var foccisei "父亲职业ISEI"
label var moccisei "母亲职业ISEI"
label var fccp "父亲是否共产党员"
label var mccp "母亲是否共产党员"
label var pid_f "父亲ID"
label var pid_m "母亲ID"

label var word "字词测试原始得分"
label var word2 "字词测试原始得分"
label var math "数学测试原始得分"
label var math2 "字词测试原始得分"
label var iwr "瞬时字词记忆得分"
label var dwr "延时字词记忆得分"
label var ns_g "数列测试得分: Guttman Scale"
label var ns_w "数列测试得分: W-Score"
label var comprehend_ir "理解能力（访员打分）"
label var intelligence_ir "智力水平（访员打分）"
label var interperson_ir "待人接物水平（访员打分）"
label var language_ir "语言表达能力（访员打分）"
label var mandarin_ir "普通话熟练程度（访员打分）"

label var marriage "当前婚姻状态"
label var fmarri_y "初婚年份"
label var cmarri_y "当前婚姻结婚年份"
label var pid_s "配偶ID"
label var sbirthy "配偶出生年份"
label var sedu "配偶最高学历"
label var seduy "配偶受教育年限"
label var socctype_isco "配偶职业（ISCO88）"
label var soccisei "配偶职业ISEI"
label var nchild "孩子数"

label var ccp "党员"


//  Values Label
	#delimit ;
	label define provcd_c 
		11 "北京市"
		12 "天津市"
		13 "河北省"
		14 "山西省"
		15 "内蒙古自治区"
		21 "辽宁省"
		22 "吉林省"
		23 "黑龙江省"
		31 "上海市"
		32 "江苏省"
		33 "浙江省"
		34 "安徽省"
		35 "福建省"
		36 "江西省"
		37 "山东省"
		41 "河南省"
		42 "湖北省"
		43 "湖南省"
		44 "广东省"
		45 "广西壮族自治区"
		46 "海南省"
		50 "重庆市"
		51 "四川省"
		52 "贵州省"
		53 "云南省"
		54 "西藏自治区"
		61 "陕西省"
		62 "甘肃省"
		63 "青海省"
		64 "宁夏回族自治区"
		65 "新疆维吾尔自治区"
		;
	#delimit cr
	label define qtype_c 0 "少儿" 1 "成人"
	label define wave_c 10 "2010" 11 "2011" 12 "2012" 14 "2014" 16 "2016"
	label define resample_c 0 "否" 1 "是"

	label define gender_c 0 "女" 1 "男"
	label define han_c 0 "少数民族" 1 "汉族"
	label define urban_c 0 "乡村" 1 "城镇"
	label define hukou_c 0 "农业户口" 1 "非农户口" 2 "其他"
	label copy provcd_c hkprov_c
	
	#delimit ;
	label define edu_c
		1 "小学以下" 
		2 "小学" 
		3 "初中" 
		4 "高中" 
		5 "大专" 
		6 "本科" 
		7 "硕士" 
		8 "博士"
		;
	label define major_c
		1 "哲学"
		2 "经济学"
		3 "法学"
		4 "教育学"
		5 "文学"
		6 "历史学"
		7 "理学"
		8 "工学"
		9 "农学"
		10 "医学"
		11 "军事学"
		12 "管理学"
		;
	label define collegetype_c
		1 "全国重点"
		2 "普通重点"
		3 "二本"
		4 "三本"
		5 "部队院校"
		6 "艺体院校"
		7 "海外院校"
		8 "大专高职"
		9 "中专"
		10 "夜大与函授"
		11 "自考"
		12 "广播电视大学"
		13 "网络教育院校"
		14 "党校"
		99 "其他"
		;
	#delimit cr
	label copy edu_c sch_c
	
	label define employ_c 0 "失业" 1 "在业" 2 "非经济活动人口"
	label define employs_c 1 "受雇" 2 "非农自雇" 3 "务农"
	label copy qg307isco occtype_isco_c
	#delimit ;
	label define occtype_crude_c	
		1 "国家机关、党群组织、企业、事业单位负责人"
		2 "专业技术人员"
		3 "技术人员和辅助专业人员"
		4 "办事人员和有关人员" 
		5 "商业、服务业人员"
		6 "农渔业技术工人"
		7 "工艺人员及相关产业技术工人"
		8 "设备和机械操作工人"
		9 "非技术工人"
		;
	label define industry_c
		1 "农、林、牧、渔业"
		2 "采矿业"
		3 "制造业"
		4 "电力、燃气及水的生产和供应业"
		5 "建筑业"
		6 "交通运输、仓储和邮政业"
		7 "信息传播、计算机服务和软件业"
		8 "批发和零售业"
		9 "住宿和餐饮业"
		10 "金融业"
		11 "房地产业"
		12 "租赁和商务服务业"
		13 "科学研究、技术服务和地质勘查业"
		14 "水利、环境和公共设施管理业"
		15 "居民服务和其他服务业"
		16 "教育"
		17 "卫生、社会保障和社会福利业"
		18 "文化、体育和娱乐业"
		19 "公共管理和社会组织"
		20 "国际组织"
		21 "其他行业"	
		;
	label define orgtype_c
		1 "政府部门/党政机关/人民团体"
		2 "事业单位"
		3 "国有企业"
		4 "私营企业/个体工商户/其他类型企业"
		5 "外商/港澳台商企业"
		6 "个人/家庭"
		7 "民办非企业组织/协会/行会/基金会/村居委会"
		;
	label define promote_e_c 0 "否" 1 "是" ;
	label define promote_t_c 0 "否" 1 "是" ;
	label define mngpos_c
		0 "无行政/管理职务"
		1 "基层行政/管理职务"
		2 "中层行政/管理职务"
		3 "高层行政/管理职务"
		4 "顶层行政/管理职务"
		5 "有行政/管理职务"
		;
	label define wksat_inc_c 
		1 "非常不满意"
		2 "不太满意"
		3 "一般"
		4 "比较满意"
		5 "非常满意"
		;
	label copy wksat_inc_c wksat_safe_c ;
	label copy wksat_inc_c wksat_env_c ;
	label copy wksat_inc_c wksat_wkh_c ;
	label copy wksat_inc_c wksat_prom_c ;
	label copy qg307isco occtype_isco_1st_c;
	label define occedu_c
		1 "不必念书"
		2 "小学"
		3 "初中"
		4 "高中/中专/技校/职高"
		5 "大专"
		6 "本科"
		7 "硕士"
		8 "博士"
		;

	label define marriage_c
		1 "未婚"
		2 "在婚"
		3 "同居"
		4 "离婚"
		5 "丧偶"
		;
	#delimit cr

	label define ccp_c 0 "否" 1 "是"

	foreach var in provcd qtype resample wave gender han urban hukou hkprov edu sch major ///
				   collegetype employ employs occtype_isco occtype_crude industry orgtype ///
				   promote_e promote_t mngpos wksat_inc wksat_safe wksat_env occedu ///
				   wksat_wkh wksat_prom wksat_all occtype_isco_1st marriage ccp {
		label values `var' `var'_c
	}

**********************************
* English Labels
**********************************

*  Set Label Language
	label language English, new

*  Variable Label
label var pid "Individual ID"
label var fid "Family ID"
label var cid "Community ID"
label var countyid "County ID"
label var provcd "Province code"
label var wave "Wave ID"
label var syear "Survey Year"
label var smonth "Survey Month"
label var qtype "Questionnaire Type"
label var interviewerid "Interviewer ID"
label var rswt_nat "Weight_National"
label var rswt_res "Weight_Resample"
label var resample "Resamle"

label var birthy "Birth Year"
label var age "Age in Survey Year"
label var gender "Gender "
label var ethnicity "Ethnicity"
label var han "Han"
label var urban "Residence (Urban/Rural)"
label var hukou "Hukou"
label var hkprov "Hukou (Province)"

label var edu "Highest Educational Level Attained"
label var sch "Highest Educational Level Attend"
label var eduy "Years of Education Received"
label var eduy_im "Years of Education Received (Imputation)"
label var major "Field of Study of the Highest Degree"
label var collegetype "College Type"

label var employ "Labor Market Participation"
label var employs "Current Employment Status"
label var occtype_isco "Current Occupation (ISCO88/08)"
label var occtype_crude "Current Occupation (10 Categories)"
label var occisei "Current Occupation ISEI"
label var industry "Current Occupation Industry"
label var orgtype "Current Occupation Organization Type"
label var occtype_isco_1st "First Occupation Type (ISCO88)"
label var promote_e "Got Promoted Last Year (Excutive Position)"
label var promote_t "Got Promoted Last Year (Technical Position)"
label var mngpos "Administration / Management Position (?)"
label var subnum "Number of Subordinates"
label var wksat_inc "Satisfaction for Current Occupation's Income"
label var wksat_safe "Satisfaction for Current Occupation's Safety "
label var wksat_env "Satisfaction for Current Occupation's Working Environment"
label var wksat_wkh "Satisfaction for Current Occupation's Working Hours"
label var wksat_prom  "Satisfaction for Current Occupation's Chance of Promotion"
label var wksat_all "Overall Satisfaction for Current Occupation"
label var tenure "Tenure of Current Occupation"
label var occedu "Self-rated Education Level Needed for Current Occupation"
label var wkhr ""

label var mwage "Main Job Monthly Wage"
label var hwage "Main Job Hourly Wage"
label var ywage "Main Job Annual Income (Bonus Included)"
label var ywaget "Annual Income from All Jobs (Bonus Included) "
label var income "Annual Total Income"

label var birthprov "Birthplace (Province)"
label var yresprov "Residence (Province) When R in Adolescence"
label var yhukou "Hukou When R in Adolescence"
label var nsib "Number of Siblings"
label var fedu "Father's Highest Educational Level Attained"
label var medu "Mother's Highest Educational Level Attained"
label var focctype_isco "Father's Occupation (ISCO88)"
label var mocctype_isco "Mother's Occupation (ISCO88)"
label var foccisei "Father's Occupation ISEI"
label var moccisei "Mother's Occupation ISEI"
label var fccp "Whether Father's a CCP Member"
label var mccp "Whether Mother's a CCP Member"
label var pid_f "Father's ID"
label var pid_m "Mother's ID"

label var word "Original Score for Word Test"
label var math "Original Score for Math Test"
label var iwr "Immediate Word Recall"
label var dwr "Delayed Word Recall"
label var ns_g "Number Series Test: Guttman Scale"
label var ns_w "Number Series Test: W-Score"
label var comprehend_ir "Comprehension Ability (Interviewer Grading)"
label var intelligence_ir "Intelligence Level (Interviewer Grading)"
label var interperson_ir "Interpersonal Skills (Interviewer Grading)"
label var language_ir "Language Competence (Interviewer Grading)"
label var mandarin_ir "Mandarin Proficiency (Interviewer Grading)"

label var marriage "Current Marriage Status"
label var fmarri_y "Year of First Marriage"
label var cmarri_y "Year of Current Marriage"
label var pid_s "Spousal ID"
label var sbirthy "Spouse's Birth Year"
label var sedu "Spouse's Highest Educational Level Attained"
label var seduy "Spouse's Years of Education"
label var socctype_isco "Spouse's Occupation (ISCO88)"
label var soccisei "Spouse's Occupation ISEI"
label var nchild "Number of Children"

label var ccp "CCP Membership"
	
//  Values Label
	#delimit ;
	label define provcd_e 
		11 "Beijing"
		12 "Tianjin"
		13 "Hebei"
		14 "Shanxi"
		15 "Neimenggu"
		21 "Liaoning"
		22 "Jilin"
		23 "Heilongjiang"
		31 "Shanghai"
		32 "Jiangsu"
		33 "Zhejiang"
		34 "Anhui"
		35 "Fujian"
		36 "Jiangxi"
		37 "Shandong"
		41 "Henan"
		42 "Hubei"
		43 "Hunan"
		44 "Guangdong"
		45 "Guangxi"
		46 "Hainan"
		50 "Chongqing"
		51 "Sichuan"
		52 "Guizhou"
		53 "Yunnan"
		54 "Xizang"
		61 "Shaanxi"
		62 "Gansu"
		63 "Qinghai"
		64 "Ningxia"
		65 "Xinjiang"
		;
	#delimit cr

	label define qtype_e 0 "Child" 1 "Adult"
	label define wave_e 10 "2010" 11 "2011" 12 "2012" 14 "2014" 16 "2016"
	label define resample_e 0 "No" 1 "Yes"

	label define gender_e 0 "Female" 1 "Male"
	label define han_e 0 "Ethnic Minorities" 1 "Ethnic Majorities: Han"
	label define urban_e 0 "Rural Areas" 1 "Urban Areas"
	label define hukou_e 0 "Rural" 1 "Non-Rural" 2 "Others"
	label copy provcd_e hkprov_e
	
	#delimit ;
	label define edu_e
		1 "Below Elementary" 
		2 "Elementary School" 
		3 "Junior High and Vocational School" 
		4 "Senior High and Vocational School" 
		5 "Vocational College or Some College" 
		6 "Bachelor Degree" 
		7 "Master Degree" 
		8 "PhD Degree"
		;
	label define major_e
		1 "Philosophy" 
		2 "Economics" 
		3 "Law" 
		4 "Education" 
		5 "Literature" 
		6 "History" 
		7 "Science" 
		8 "Engineering" 
		9 "Agronomy" 
		10 "Medicine" 
		11 "Military Science" 
		12 "Management" 
		;
	label define collegetype_e
		1 "全国重点"
		2 "普通重点"
		3 "二本"
		4 "三本"
		5 "部队院校"
		6 "艺体院校"
		7 "海外院校"
		8 "大专高职"
		9 "中专"
		10 "夜大与函授"
		11 "自考"
		12 "广播电视大学"
		13 "网络教育院校"
		14 "党校"
		99 "其他"
		;
	#delimit cr
	label copy edu_e sch_e
	
	label define employ_e 0 "Unemployed" 1 "Currently Working" 2 "Not in Labor Market"
	label define employs_e 1 "Employed" 2 "Non-Farm Self-Employed" 3 "Farmer"

	#delimit ;
	label define occtype_crude_e
		1 "Legislators, Senior Officials And Managers"
		2 "Professionals"
		3 "Technicians And Associate Professionals"
		4 "Clerks" 
		5 "Service Workers And Shop And Market Sales Workers"
		6 "Skilled Agricultural And Fishery Workers"
		7 "Craft And Related Trades Workers"
		8 "Plant And Machine Operators And Assemblers"
		9 "Elementary Occupations"
		;
	label define industry_e
		1 "Agriculture, forestry, fishing and hunting"
		2 "Mining" 
		3 "Manufacture" 
		4 "Production and supply of electricity, gas, and water"
		5 "Construction" 
		6 "Transportation, storage, and postal service"
		7 "Information transmission, computers, and software industry"
		8 "Wholesale and retail"
		9 "Hotel and catering" 
		10 "Finance" 
		11 "Real estate" 
		12 "Rental and commercial service"
		13 "Scientific research, technology services and geological survey"
		14 "Water resource, environment and public facility management"
		15 "Residential and other service industry" 
		16 "Education"
		17 "Health, social security, and social welfare"
		18 "Culture, sports, and entertainment"
		19 "Public administration and social organization" 
		20 "International Organization"
		21 "other industries" 
		;
	label define orgtype_e
		1 "Government/Party/People's organization/Military" 
		2 "State-owned/Collectively-owned public institution/Research institute" 
		3 "State-owned/State-controlled enterprise" 
		4 "Private enterprise/Individually owned business (getihu)/Enterprise of Other Types"
		5 "Enterprise invested in by Foreign Hong Kong/Macao/Taiwan Capital"
		6 "Family business" 
		7 "Private non-profit organization; Association /Guild/Foundation/Social organization; Residential community committee/Village committee/Autonomous organization" 
		;
	label define promote_e_e 0 "No" 1 "Yes" ;
	label define promote_t_e 0 "No" 1 "Yes" ;
	label define mngpos_e
		0 "No Administration / Management Position"
		1 "Primary Administration / Management Position"
		2 "Middle Administration / Management Position"
		3 "Senior Administration / Management Position"
		4 "Top Administration / Management Position"
		5 "Has Administration / Management Position"
		;
	label define wksat_inc_e
		1 "Very Unsatisfied" 
		2 "Unsatisfied"
		3 "Fair" 
		4 "Satisfied" 
		5 "Very Satisfied"
		;
	label copy wksat_inc_e wksat_safe_e ;
	label copy wksat_inc_e wksat_env_e ;
	label copy wksat_inc_e wksat_wkh_e ;
	label copy wksat_inc_e wksat_prom_e ;


	label define occedu_e
		1 "None" 
		2 "Elementary School" 
		3 "Junior High and Vocational School" 
		4 "Senior High and Vocational School" 
		5 "Vocational College or Some College" 
		6 "Bachelor Degree" 
		7 "Master Degree" 
		8 "PhD Degree"
		;

	label define marriage_e
		1 "Never Married"
		2 "Married"
		3 "Cohabiting"
		4 "Divorced"
		5 "Widowed"
		;
	#delimit cr

	label define ccp_e 0 "No" 1 "Yes"

	foreach var in provcd qtype resample wave gender han urban hukou hkprov edu sch major ///
				   collegetype employ employs occtype_crude industry orgtype ///
				   promote_e promote_t mngpos wksat_inc wksat_safe wksat_env occedu ///
				   wksat_wkh wksat_prom wksat_all  marriage ccp {
		label values `var' `var'_e
	}

	iscolbl isco88com occtype_isco occtype_isco_1st

	
	label language default, delete
	save "$data_gen/cfps_ind.dta", replace
	
	label language English
	save "$data_gen/cfps_ind.dta", replace

/**========================================**
**            Data Inspection             **
**========================================**	
	label language Chinese
	
	bysort wave: tab provcd, mi
	bysort wave: tab wave, mi
	bysort wave: tab qtype, mi
	
	bysort wave: ins birthy
	bysort wave: tab birthm, mi
	bysort wave: ins age
	bysort wave: tab gender, mi
	bysort wave: tab han, mi
	bysort wave: tab urban, mi
	bysort wave: tab hukou, mi
	bysort wave: tab hkprov, mi

	bysort wave: tab edu, mi
	bysort wave: tab major, mi

/**========================================**
**              Delete Files              **
**========================================**

