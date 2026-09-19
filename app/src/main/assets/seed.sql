INSERT OR IGNORE INTO "account_tree_type"("id","name") VALUES(0,'فرعي')
-- @@ --
INSERT OR IGNORE INTO "account_tree_type"("id","name") VALUES(1,'رئيسي')
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(1,'اصول',0,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(2,'التزامات وحقوق الملكية',0,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(3,'مصروفات',0,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(4,'ايرادات',0,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(11,'اصول ثابتة',1,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(12,'اصول متداولة',1,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(21,'حقوق الملكية',2,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(22,'التزمات متداولة',2,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(23,'التزامات ثابتة',2,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(31,'تكاليف النشاط',3,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(32,'مصاريف تشغيلية وإدارية',3,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(41,'ايرادات النشاط',4,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(42,'إيرادات أخرى',4,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(121,'الصناديق',12,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(122,'البنوك',12,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(123,'العملاء',12,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(124,'اخرى',12,1,0,0,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(125,'البضاعة',12,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(211,'راس المال',21,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(212,'الأرباح والخسائر',21,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(213,'المسحوبات ',21,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(214,'المساهمين ',21,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(221,'الموردون',22,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(311,'المشتريات',31,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(312,'مردودات مبيعات',31,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(313,'الخصم المسموح به',31,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(314,'تسوية المخزون',31,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(315,'الأصناف التالفة',31,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(321,'مصاريف النشاط',32,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(322,'مصاريف عمومية وادارية',32,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(323,'مصاريف أخرى',32,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(411,'المبيعات',41,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(412,'مردودات مشتريات',41,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "account_tree"("id","name","parent_id","p","cus_id","admin","online","online_ref2") VALUES(413,'الخصم المكتسب',41,1,0,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "adj_type"("id","name","acc_id","in_") VALUES(1,'عجز',-15,1)
-- @@ --
INSERT OR IGNORE INTO "adj_type"("id","name","acc_id","in_") VALUES(2,'زيادة',-15,-1)
-- @@ --
INSERT OR IGNORE INTO "adj_type"("id","name","acc_id","in_") VALUES(3,'تالف',-16,1)
-- @@ --
INSERT OR IGNORE INTO "adj_type"("id","name","acc_id","in_") VALUES(4,'افتتاحي',-14,1)
-- @@ --
INSERT OR IGNORE INTO "bill_type"("id","name","param1","param2") VALUES(0,'حركة',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "bill_type"("id","name","param1","param2") VALUES(1,'نقد',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "bill_type"("id","name","param1","param2") VALUES(2,'آجل',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "branches"("id","name","date_","IS_ACTIVE","ADDRESS","gsm","remarks","param1","param2","online","online_ref2","cr_no","common_name","z_address","z_name") VALUES(0,'المخزن الرئيسي','2026-09-18',1,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "currency"("id","name","curr_type","param1","param2","fils_name","code_name","online","online_ref","online_ref2") VALUES(0,'محلي',0,NULL,NULL,'فلس','YR',0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "currency"("id","name","curr_type","param1","param2","fils_name","code_name","online","online_ref","online_ref2") VALUES(1,'دولار',1,NULL,NULL,'سنت','USD',0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "cus_type"("id","name","param1","param2","online","online_ref2") VALUES(0,'عملاء',NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "cus_type"("id","name","param1","param2","online","online_ref2") VALUES(1,'موردون',NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "cus_type"("id","name","param1","param2","online","online_ref2") VALUES(2,'مبيعات ومشتريات',NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "cus_type"("id","name","param1","param2","online","online_ref2") VALUES(4,'نقدية',NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "cus_type"("id","name","param1","param2","online","online_ref2") VALUES(5,'مصروفات',NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "cus_type"("id","name","param1","param2","online","online_ref2") VALUES(6,'إيرادات',NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "cus_type"("id","name","param1","param2","online","online_ref2") VALUES(7,'أخرى',NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "days_"("id","name") VALUES(0,'الأحد')
-- @@ --
INSERT OR IGNORE INTO "days_"("id","name") VALUES(1,'الإثنين')
-- @@ --
INSERT OR IGNORE INTO "days_"("id","name") VALUES(2,'الثلاثاء')
-- @@ --
INSERT OR IGNORE INTO "days_"("id","name") VALUES(3,'الأربعاء')
-- @@ --
INSERT OR IGNORE INTO "days_"("id","name") VALUES(4,'الخميس')
-- @@ --
INSERT OR IGNORE INTO "days_"("id","name") VALUES(5,'الجمعة')
-- @@ --
INSERT OR IGNORE INTO "days_"("id","name") VALUES(6,'السبت')
-- @@ --
INSERT OR IGNORE INTO "discount_type"("id","name") VALUES(0,'نسبة مئوية')
-- @@ --
INSERT OR IGNORE INTO "discount_type"("id","name") VALUES(1,'مبلغ')
-- @@ --
INSERT OR IGNORE INTO "groups"("id","name","param1","param2","online","online_ref2") VALUES(0,'عام',NULL,NULL,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "item_type"("id","name","remarks","param1","param2","online","online_ref2") VALUES(0,'عام',NULL,NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "item_type_"("id","name","remarks","param1","param2") VALUES(0,'سلعة',NULL,NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "item_type_"("id","name","remarks","param1","param2") VALUES(1,'خدمة',NULL,NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "revenue_type"("id","name") VALUES(1,'صافي المبيعات')
-- @@ --
INSERT OR IGNORE INTO "revenue_type"("id","name") VALUES(2,'تكلفة المبيعات')
-- @@ --
INSERT OR IGNORE INTO "revenue_type"("id","name") VALUES(3,'صافي المشتريات')
-- @@ --
INSERT OR IGNORE INTO "revenue_type"("id","name") VALUES(4,'صافي المبيعات')
-- @@ --
INSERT OR IGNORE INTO "revenue_type"("id","name") VALUES(5,'الايرادات')
-- @@ --
INSERT OR IGNORE INTO "revenue_type"("id","name") VALUES(6,'المصروفات')
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(-9,'الحسابات',1,0,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(-8,'قبض/صرف',1,0,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(-7,'المشتريات',1,0,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(-6,'المبيعات',1,0,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(-5,'استرجاع نسخة احتياطية',1,0,-1,-1,1,-1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(-4,'حفظ نسخة احتياطية',1,0,-1,-1,1,-1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(-3,'صرف مخزني',1,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(-2,'توريد مخزني',1,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(1,'عمليات مخزنية',0,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(2,'قيود وحسابات',0,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(3,'أصناف',0,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(4,'العملات ',0,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(5,'التقارير',0,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(6,'تحويل مخزني',1,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(7,'تسوية مخزنية',1,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(8,'إضافة مخزن',1,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(9,'قيد يومي',2,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(10,'قيد إفتتاحي',2,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(11,'إضافة حساب',2,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(12,'حركة الصندوق',2,1,-1,-1,1,-1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(13,'دليل الحسابات',2,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(14,'إقفال سنوي',2,1,-1,-1,1,-1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(15,'الأصناف',3,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(16,'أسعار البيع',3,1,1,-1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(19,'إضافة عملة',4,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(20,'سعر العملات',4,1,1,-1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(21,'حركة الأصناف',5,1,-1,-1,1,-1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(23,'ميزان المراجعة',5,1,-1,-1,1,-1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(24,'قائمة الدخل',5,1,-1,-1,1,-1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(25,'المركز المالي',5,1,-1,-1,1,-1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(26,'تقارير أخرى',5,1,-1,-1,1,-1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(27,'وحدات الصنف',3,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(28,'جرد مخزني',1,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(29,' فاتورة عرض سعر',3,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(30,'  طلب شراء',3,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "screens"("id","name","p_id","is_active","new","edit","view","del") VALUES(31,'سقف الحساب',4,1,1,1,1,1)
-- @@ --
INSERT OR IGNORE INTO "sys_conf"("id","desc_","value_") VALUES(1,'Account Cash','-3')
-- @@ --
INSERT OR IGNORE INTO "sys_conf"("id","desc_","value_") VALUES(2,'F-DATE','now')
-- @@ --
INSERT OR IGNORE INTO "sys_conf"("id","desc_","value_") VALUES(3,'CURR','0')
-- @@ --
INSERT OR IGNORE INTO "sys_conf"("id","desc_","value_") VALUES(4,'Fund Cash','-13')
-- @@ --
INSERT OR IGNORE INTO "sys_conf"("id","desc_","value_") VALUES(5,'VAT Acc','-18')
-- @@ --
INSERT OR IGNORE INTO "sys_conf"("id","desc_","value_") VALUES(6,'VAT enable','0')
-- @@ --
INSERT OR IGNORE INTO "sys_conf"("id","desc_","value_") VALUES(8,'share_type','0')
-- @@ --
INSERT OR IGNORE INTO "sys_conf"("id","desc_","value_") VALUES(9,'curr_diff_id','-27')
-- @@ --
INSERT OR IGNORE INTO "sys_conf"("id","desc_","value_") VALUES(10,'show_end_date','0')
-- @@ --
INSERT OR IGNORE INTO "sys_conf"("id","desc_","value_") VALUES(100,'dev_id','')
-- @@ --
INSERT OR IGNORE INTO "sys_conf"("id","desc_","value_") VALUES(101,'online2','0')
-- @@ --
INSERT OR IGNORE INTO "tax_type"("id","name") VALUES(-1,'متضمن')
-- @@ --
INSERT OR IGNORE INTO "tax_type"("id","name") VALUES(1,'غير متضمن')
-- @@ --
INSERT OR IGNORE INTO "tax"("id","name","tax_type_id","per","is_active","is_default","online","online_ref2") VALUES(-1,'بدون',1,0.0,1,1,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "tax"("id","name","tax_type_id","per","is_active","is_default","online","online_ref2") VALUES(0,'ض.قيمة مضافة',1,5.0,1,0,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(-6,'عملات',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(-5,'رسوم',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(-4,'ضريبة',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(-3,'سندات',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(-2,'قيود يومية',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(-1,'قيد افتتاحي',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(0,'افتتاحي',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(1,'بيع',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(2,'شراء',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(3,'تحويل مخزني',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(4,'تسوية مخزنية',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(5,'قبض',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(6,'صرف',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(7,'جرد',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(8,'عرض سعر',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(9,'طلب شراء',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(10,'بيع عملة',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(11,'صرف مخزني',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(13,'شراء عملة',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "tran_type"("id","name","param1","param2") VALUES(21,'توريد مخزني',NULL,NULL)
-- @@ --
INSERT OR IGNORE INTO "units"("id","name","code","param1","param2","online","online_ref2") VALUES(0,'بدون','.',NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "units"("id","name","code","param1","param2","online","online_ref2") VALUES(1,'حبة','حبة',NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "units"("id","name","code","param1","param2","online","online_ref2") VALUES(2,'كيلو','ك',NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "units"("id","name","code","param1","param2","online","online_ref2") VALUES(3,'كرتون','كرتون',NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "units"("id","name","code","param1","param2","online","online_ref2") VALUES(4,'كيس','كيس',NULL,NULL,1,NULL)
-- @@ --
INSERT OR IGNORE INTO "z_status"("id","name","desc_") VALUES(-4,'Error','خطأ')
-- @@ --
INSERT OR IGNORE INTO "z_status"("id","name","desc_") VALUES(-3,'Failed','فشلت العملية')
-- @@ --
INSERT OR IGNORE INTO "z_status"("id","name","desc_") VALUES(-2,'NOT_CLEARED','لم يتم اعتماد المستند')
-- @@ --
INSERT OR IGNORE INTO "z_status"("id","name","desc_") VALUES(-1,'NOT_REPORTED','لم يتم قبول المستند')
-- @@ --
INSERT OR IGNORE INTO "z_status"("id","name","desc_") VALUES(0,'Not_Submitted','لم يتم الإرسال')
-- @@ --
INSERT OR IGNORE INTO "z_status"("id","name","desc_") VALUES(1,'REPORTED','تم قبول المستند')
-- @@ --
INSERT OR IGNORE INTO "z_status"("id","name","desc_") VALUES(2,'CLEARED','تم إعتماد المستند')
-- @@ --
INSERT OR IGNORE INTO "z_status"("id","name","desc_") VALUES(3,'REPORTED+','تم قبول المستند + تحذيرات')
-- @@ --
INSERT OR IGNORE INTO "z_status"("id","name","desc_") VALUES(4,'CLEARED+','تم إعتماد المستند + تحذيرات')
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-30,'تسوية المخزون-صرف وتوريد','',0,7,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',314,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-27,'فوارق بيع وشراء العملات','',0,7,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',42,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-24,'اجور نقل','',0,7,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',322,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-20,'رسوم أخرى','',0,7,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',323,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-18,'الضريبة','',0,7,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',22,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-17,'ح/الارباح والخسائر','',0,7,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',212,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-16,'البضاعة التالفة','',0,7,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',314,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-15,'عجز و زيادة البضاعة ','',0,7,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',314,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-14,'بضاعة أول المدة','',0,7,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',125,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-13,'رأس المال','',0,7,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',211,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-12,'مردودات  مشتريات نقدي','',0,2,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',412,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-11,'مردودات  مبيعات نقدي','',0,2,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',312,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-10,'مردودات  مشتريات آجل','',0,2,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',412,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-9,'مردودات مبيعات آجل','',0,2,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',312,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-8,'الخصم المسموح به','',0,5,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',313,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-7,'الخصم المكتسب','',0,6,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',413,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-6,'مشتريات نقدي','',0,2,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',311,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-5,'مبيعات نقدي','',0,2,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',411,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-3,'الصندوق','',0,4,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',121,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-2,'مشتريات آجل','',0,2,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',311,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "customers"("id","name","gsm","g_id","cus_type_id","date_","ADDRESS","remarks","param1","param2","f1","f2","f3","vat_no","acc_p_id","online","online_ref","online_ref2","sms","wa","cr_no") VALUES(-1,'مبيعات آجل','',0,2,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',411,0,0,NULL,0,0,NULL)
-- @@ --
INSERT OR IGNORE INTO "trigger_flags"("is_active") VALUES(1)
-- @@ --
INSERT OR IGNORE INTO "current_closing_balance"("id","date_","updated") VALUES(0,'2025-09-18',1)
-- @@ --
INSERT OR IGNORE INTO users(id,user_name,name,pwd,gsm,is_active,cash_id,br_id,date_,param1,param2,f1,f2,f3,online,online_ref2) VALUES(0,'مدير النظام','مدير النظام','',NULL,0,-3,0,'2026-09-18',NULL,NULL,NULL,NULL,NULL,1,NULL)