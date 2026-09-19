CREATE TABLE tmp_real (r real)
-- @@ --
CREATE TABLE `tran_type` (
		`id` INTEGER PRIMARY KEY,
		`name` TEXT unique,
		param1 text,
		param2 text
		)
-- @@ --
CREATE TABLE `bill_type` (
		`id` INTEGER PRIMARY KEY,
		`name` TEXT unique,
		param1 text,
		param2 text
		)
-- @@ --
CREATE TABLE `cus_type` (
		`id` INTEGER PRIMARY KEY,
		`name` TEXT unique,
		param1 text,
		param2 text
		, online integer default 1, online_ref2 Text)
-- @@ --
CREATE TABLE branches
		(
		id     INTEGER PRIMARY KEY AUTOINCREMENT,
		name   text UNIQUE,
		date_              text default (strftime('%Y-%m-%d','now')),
		IS_ACTIVE            integer default 1,
		ADDRESS              text,
		gsm                text,
		remarks text,
		`param1`	TEXT,
		`param2`	TEXT
		, online integer default 1, online_ref2 Text, cr_no text, common_name text, z_address text, z_name text)
-- @@ --
CREATE TABLE "customers" (
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		`name`	TEXT UNIQUE,
		`gsm`	TEXT default '' ,
		g_id INTEGER default 0,
		cus_type_id integer default 0 references cus_type(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		date_ default (strftime('%Y-%m-%d','now')),
		ADDRESS              text,
		remarks text,
		`param1`	TEXT,
		`param2`	TEXT,
		`f1`	TEXT,
		`f2`	TEXT,
		`f3`	TEXT

		, vat_no text default '', acc_p_id integer default 0, online integer default 0, online_ref integer default 0, online_ref2 Text, sms integer default 0, wa integer default 0, cr_no text)
-- @@ --
CREATE TABLE "transactions" (
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		`cus_id`	INTEGER,
		`in`	TEXT,
		`out`	TEXT,
		`date_`	TEXT,
		`remarks`	TEXT,
		now_ TEXT,
		`param1`	TEXT,
		`param2`	TEXT,
		t_cus_id INTEGER ,
		`f1`	TEXT,
		`f2`	TEXT,
		`f3`	TEXT,
		curr_id integer default 0 references currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		bill_id integer default 0,
		p_id integer default 0,
		p_remarks text,
		p_amount real default 0,
		p_status integer default 0,
		p_ref_no text,
		d_amount real default 0,
		d_remarks text,
		curr_price real default 0,
		p_curr_id integer default 0,
		p_date text

		, item_id integer default 0, cash_id integer default -3, fund_id integer default -13, tr_type integer default 0, p_curr_price real default 0, curr_mod integer default 0, user_id integer references users(id) ON UPDATE RESTRICT ON DELETE RESTRICT, online integer default 1, online_ref integer default 0, c_curr_id integer default 0, c_curr_price real default 0, c_price real default 0, c_diff_id integer default -27, c_p_id integer default 0, last_user integer references users(id) ON UPDATE RESTRICT ON DELETE RESTRICT, last_update text, online_ref2 Text)
-- @@ --
CREATE TABLE "groups" (
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		`name`	TEXT UNIQUE,
		`param1`	TEXT,
		`param2`	TEXT
		, online integer default 0, online_ref2 Text)
-- @@ --
CREATE TABLE "currency" (
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		`name`	TEXT UNIQUE,
		curr_type integer default 1,
		`param1`	TEXT,
		`param2`	TEXT
		, fils_name text, code_name text, online integer default 0, online_ref integer default 0, online_ref2 Text)
-- @@ --
CREATE TABLE "item_type" (
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		`name`	TEXT UNIQUE,
		remarks text,
		`param1`	TEXT,
		`param2`	TEXT
		, online integer default 1, online_ref2 Text)
-- @@ --
CREATE TABLE items
		(
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		`name`	TEXT UNIQUE,
		item_type_id integer default 0  REFERENCES item_type(id) ON UPDATE RESTRICT ON DELETE RESTRICT ,
		date_                    text default (strftime('%Y-%m-%d','now')),
		IS_ACTIVE                  integer default 1  ,
		o_qty real default 0,
		o_cost real default 0,
		o_br_id integer default 0,
		o_date text default (strftime('%Y-%m-%d','now')),
        e_date text,
		pic text,
		remarks text,
		qty real default 0,
		price real default 0,
		curr_id integer default 0,
		curr_price real default 0,
		`param1`	TEXT,
		`param2`	TEXT
		, item_type_id_ integer default 0 REFERENCES item_type_(id), unit_id integer default 0, u_val integer default 1, barcode text, online integer default 0, online_ref integer default 0, e_date2 text, online_ref2 Text)
-- @@ --
CREATE TABLE `items_temp` (
		item_id integer references items(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		item_type_id integer references item_type(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		curr_id integer ,
		qty real default 0,
		price real default 0,
		no_ INTEGER PRIMARY KEY,
		remark text

		, unit_id integer default 0 references units(id) ON UPDATE RESTRICT ON DELETE RESTRICT, u_val real default 1, base_unit integer default -1, qty_pr real, qty_t text, u_cost2 real default 0, e_date text)
-- @@ --
CREATE TABLE item_price_history
		(
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		item_id integer REFERENCES items(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		curr_id integer REFERENCES currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		sls_u_price real,
		date_                    text ,
		log_date text default (strftime('%Y-%m-%d','now')),
		remarks text,
		`param1`	TEXT,
		`param2`	TEXT
		, unit_id integer  REFERENCES units(id) ON UPDATE RESTRICT ON DELETE RESTRICT)
-- @@ --
CREATE TABLE bills
		(
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		date_            text default (strftime('%Y-%m-%d','now')),
		remarks         text,
		bill_no text ,-- used for return bill
		curr_id          integer default 0 references currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		bill_type integer default 0,
		tr_type integer references tran_type(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		is_back            integer default 0,
		br_id          integer default 0 references branches(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		cus_id integer  ,
		tran_status integer,
		to_br_id integer  references branches(id) ON UPDATE RESTRICT ON DELETE RESTRICT ,
		amount real default 0,
		d_amount real default 0,
		tax_amount             real default 0,
		param1 text,
		param2 text,
		param3 text,
		curr_price real default 0,
		bill_no2 integer default 0,
		cash_id integer default -3

		, adj_id integer default 0, adj_acc integer default 0, curr_mod integer default 0, discount_id integer
		default 0  references discount_type(id) ON UPDATE RESTRICT ON DELETE RESTRICT, d_val real default 0, paid_amount real default 0, id2 integer, online integer default 1, online_ref integer default 0, tax_id integer default -1  references
		tax(id) ON UPDATE RESTRICT ON DELETE RESTRICT, t_val real default 0, time_ text, cost2 real default 0, cost_id integer default -24, r_cost real default 0, user_id integer references users(id) ON UPDATE RESTRICT ON DELETE RESTRICT, last_user integer references users(id) ON UPDATE RESTRICT ON DELETE RESTRICT, last_update text, online_ref2 Text, qr text, z_status integer references z_status(id), z_unit_id integer references z_units(id), z_user_id integer references users(id), z_date text, z_code text, z_reply text, z_uuid text, z_pih text, z_inv_hash text, z_cleared_inv text, xml_file text, curr_price_sar numeric default 0)
-- @@ --
CREATE TABLE bill_transactions
		(
		bill_id                  integer references bills(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		item_id                    integer references items(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		item_type_id                    integer references item_type(id) ,
		curr_id                    integer references currency(id) ,
		qty                          integer,
		cost_price                    real default 0,
		sls_u_price               	real default 0,
		d_amount real default 0,
		param1 text,
		param2 text,
		param3 text,
		cash_id integer default -3,
		remark         text

		, unit_id integer default 0 references units(id) ON UPDATE RESTRICT ON DELETE RESTRICT, u_val real default 1, base_unit integer default -1, qty_pr real, qty_t text, u_cost2 real default 0, date_ text, e_date text)
-- @@ --
CREATE TABLE items_closing_balance
		(
		`id`	INTEGER ,
		`name`	TEXT ,
		item_type_id integer REFERENCES item_type(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		date_                    text default (strftime('%Y-%m-%d','now')),
		IS_ACTIVE                  integer default 1  ,
		o_qty real default 0,
		o_cost real default 0,
		o_br_id integer default 0,
		o_date text default (strftime('%Y-%m-%d','now')),
		remarks text,
		qty real default 0,
		price real default 0,
		curr_id integer default 0,
		`param1`	TEXT,
		`param2`	TEXT
		, e_qty real default 0)
-- @@ --
CREATE TABLE current_closing_balance
		(
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		date_                    text default (strftime('%Y-%m-%d','now')),
		updated                  integer default 0
		)
-- @@ --
CREATE TABLE days_ (id integer primary key,name text)
-- @@ --
CREATE TABLE "tr_p_temps" (
		`no_`	INTEGER PRIMARY KEY AUTOINCREMENT,
		`cus_id`	INTEGER,
		`in_`	TEXT,
		`out`	TEXT,
		`date_`	TEXT,
		`remarks`	TEXT,
		now_ TEXT,
		`param1`	TEXT,
		`param2`	TEXT,
		t_cus_id INTEGER ,
		`f1`	TEXT,
		`f2`	TEXT,
		`f3`	TEXT,
		curr_id integer default 0 references currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		p_curr_id integer default 0 references currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		bill_id integer default 0,
		p_id integer default 0,
		p_remarks text,
		p_amount real default 0,
		p_status integer default 0,
		p_ref_no text,
		curr_price real default 0,
		p_date text

		, cash_id integer default -3, p_curr_price real default 0, tr_type integer default 0, curr_mod integer default 0, c_price real default 0, c_diff_id integer default -27)
-- @@ --
CREATE TABLE adj_type (id integer primary key,name text,acc_id integer,in_ integer)
-- @@ --
CREATE TABLE screens (id integer primary key,name text,p_id integer default 0, is_active integer default 1, new integer default 1, edit integer default 1, view integer default 1, del integer default 1)
-- @@ --
CREATE TABLE notifications (
		`id` INTEGER PRIMARY KEY,
		`name` TEXT ,
		date_              text default (strftime('%Y-%m-%d','now')),
		status integer default 0,
		param1 text,
		param2 text
		)
-- @@ --
CREATE TABLE closing_year
		(id integer primary key autoincrement,date_ text, cnt real default 0,
		now_ text default (strftime('%Y-%m-%d','now')), online integer default 1, online_ref2 Text)
-- @@ --
CREATE TABLE discount_type (id integer primary
		key,name text unique)
-- @@ --
CREATE TABLE "item_type_" (
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		`name`	TEXT UNIQUE,
		remarks text,
		`param1`	TEXT,
		`param2`	TEXT
		)
-- @@ --
CREATE TABLE "currency_price_temp" (
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		curr_id integer references currency(id),
		price real,
		`param1`	TEXT,
		`param2`	TEXT,
		unique(curr_id)
		)
-- @@ --
CREATE TABLE "currency_price" (
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		curr_id integer references currency(id),
		f_date text,
		t_date text,
		price real,
		is_new integer default 1,
		`param1`	TEXT,
		`param2`	TEXT, online integer default 1, online_ref2 Text, price_sar numeric,
		unique(curr_id,f_date)
		)
-- @@ --
CREATE TABLE trigger_flags (is_active INTEGER DEFAULT 1 UNIQUE)
-- @@ --
CREATE TABLE revenue_type (id integer primary key,name text)
-- @@ --
CREATE TABLE account_tree( id integer PRIMARY KEY ,name text ,parent_id integer default 0,
		p integer default 0,cus_id integer default 0,admin integer default 0, online integer default 1, online_ref2 Text,unique(name))
-- @@ --
CREATE TABLE account_tree_type (id integer primary key,name text)
-- @@ --
CREATE TABLE units (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		name text NOT NULL ,
		code text NOT NULL,
		param1 text ,
		param2 text , online integer default 1, online_ref2 Text,
		unique( name),
		unique( code)
		)
-- @@ --
CREATE TABLE unit_item
		(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		item_id                    integer references items(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		unit_id                  integer references units(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		u_val               	real default 1,
		date_            text default (strftime('%Y-%m-%d','now')),
		param1 text,
		param2 text,
		param3 text, online integer default 1, online_ref2 Text,
		unique( item_id,unit_id)
		)
-- @@ --
CREATE TABLE bills2(
  id INT,
  date_ TEXT,
  remarks TEXT,
  bill_no TEXT,
  curr_id INT,
  bill_type INT,
  tr_type INT,
  is_back INT,
  br_id INT,
  cus_id INT,
  tran_status INT,
  to_br_id INT,
  amount REAL,
  d_amount REAL,
  tax_amount REAL,
  param1 TEXT,
  param2 TEXT,
  param3 TEXT,
  curr_price REAL,
  bill_no2 INT,
  cash_id INT,
  adj_id INT,
  adj_acc INT,
  curr_mod INT,
  discount_id INT,
  d_val REAL,
  paid_amount REAL
, online integer default 1, online_ref integer default 0, time_ text, t_val real default 0, user_id integer references users(id) ON UPDATE RESTRICT ON DELETE RESTRICT, last_user integer references users(id) ON UPDATE RESTRICT ON DELETE RESTRICT, last_update text, online_ref2 Text)
-- @@ --
CREATE TABLE bill_transactions2(
  bill_id INT,
  item_id INT,
  item_type_id INT,
  curr_id INT,
  qty INT,
  cost_price REAL,
  sls_u_price REAL,
  d_amount REAL,
  param1 TEXT,
  param2 TEXT,
  param3 TEXT,
  cash_id INT,
  remark TEXT,
  unit_id INT,
  u_val REAL,
  base_unit INT,
  qty_pr REAL,
  qty_t TEXT,
  u_cost2 REAL,
  date_ TEXT,
  e_date TEXT
)
-- @@ --
CREATE TABLE items_cost_calc(
  item_id INT,
  br_id INT,
  to_br_id,
  date_ TEXT,
  bill_id,
  tr_type,
  is_back,
  name,
  bill_no,
  bill_no2,
  i_q REAL,
  i_u,
  o_q,
  o_u,
  n_q,
  n_u,
  n_t,
  r_u,
  adj_id,
  e_date TEXT,
  id2
)
-- @@ --
CREATE TABLE error_exception
		(id integer primary key autoincrement,desc_ text,
		now_ text default (strftime('%Y-%m-%d','now')))
-- @@ --
CREATE TABLE sys_conf (id integer PRIMARY KEY,desc_ text,value_ text)
-- @@ --
CREATE TABLE `chat_rooms` (
		`chat_room_id` INTEGER PRIMARY KEY,
		`name` TEXT ,
		`level_` INTEGER,
		`last_msg` TEXT,
		created_at TEXT
		)
-- @@ --
CREATE TABLE `messages` (
		`message_id` INTEGER PRIMARY KEY AUTOINCREMENT,
		`chat_room_id` INTEGER NOT NULL,
		`user_name` TEXT NOT NULL,
		`user_id` INTEGER NOT NULL,
		`message` text NOT NULL,
		`created_at` TEXT NOT NULL,
		server_id INTEGER,
		reply_id INTEGER default 0,
		reply_msg text,
		reply_to text,
		unique(server_id, chat_room_id)
		)
-- @@ --
CREATE TABLE requests
		(
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		date_            text default (strftime('%Y-%m-%d','now')),
		f_user_id integer,t_user_id integer,
		f_br_id integer,t_br_id integer,
		ref_no text,tr_type integer,acc_type integer,
		json_ text,status integer
		, err text)
-- @@ --
CREATE TABLE requests_bills
		(
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		bill_id integer,
		bill_sys integer,
		date_            text default (strftime('%Y-%m-%d','now')),
		remarks         text,
		bill_no text ,-- used for return bill
		curr_name text,
		curr_id          integer default 0 references currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		bill_type integer default 0,
		tr_type integer references tran_type(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		is_back            integer default 0,
		br_id          integer default 0 references branches(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		cus_name text,
		cus_id integer  ,
		tran_status integer,
		to_br_id integer  references branches(id) ON UPDATE RESTRICT ON DELETE RESTRICT ,
		amount real default 0,
		d_amount real default 0,
		tax_amount             real default 0,
		param1 text,
		param2 text,
		param3 text,
		curr_price real default 0,
		bill_no2 integer default 0,
		cash_name text,
		cash_id integer default -3,


		status integer default 0, adj_id  integer default 0, req_id integer, time_ text, cost2 real, t_val real default 0, online_ref  integer default 0, paid_amount real default 0,
		unique(bill_sys)
		)
-- @@ --
CREATE TABLE requests_bills_det
		(
		bill_id                  integer references requests_bills(bill_sys) ON UPDATE RESTRICT ON DELETE RESTRICT,
		item_name text,
		item_unit text,
		item_id                    integer references items(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		item_type_id                    integer references item_type(id) ,
		curr_id2                    integer references currency(id) ,
		qty                          integer,
		cost_price                    real default 0,
		sls_u_price               	real default 0,
		d_amount2 real default 0,

		cash_id2 integer default -3,
		remark2         text,
		unit_name text,
		unit_id integer default 0 references units(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		u_val real default 1,
		base_name text,
		base_unit integer default -1,
		qty_pr real,
		qty_t text
		)
-- @@ --
CREATE TABLE requests_out
		(
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		date_            text default (strftime('%Y-%m-%d','now')),
		_un text,_p_un text,
		f_br_id integer,t_br_id integer,
		ref_no text,tr_type integer,acc_type integer,action_type integer default 0,
		json_ text,status integer default 0
		)
-- @@ --
CREATE TABLE doc_hdr
		(
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		tr_id integer,
		tr_sys integer,
		`cus_id`	INTEGER,
		cus_name text,
		`in`	TEXT,
		`out`	TEXT,
		`date_`	TEXT,
		`remarks`	TEXT,
		now_ TEXT,
		`param1`	TEXT,
		`param2`	TEXT,
		t_cus_id INTEGER ,
		t_cus_name text,
		`f1`	TEXT,
		`f2`	TEXT,
		`f3`	TEXT,
		curr_id integer default 0 references currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		curr_name text,
		bill_id integer default 0,
		p_id integer default 0,
		p_remarks text,
		p_amount real default 0,
		p_status integer default 0,
		p_ref_no text,
		d_amount real default 0,
		d_remarks text,
		p_curr_id integer default 0,
		p_curr_name text,
		curr_price real default 0,
		p_curr_price real default 0,
		p_date text,
		cash_id integer default -3,
		cash_name text,
		curr_mod integer default 0,
		status integer default 0,
		tr_type integer references tran_type(id) ON UPDATE RESTRICT ON DELETE RESTRICT, req_id integer, online_ref  integer default 0,
		unique(tr_sys)


		)
-- @@ --
CREATE TABLE doc_det
		(
		tr_id                  integer references doc_hdr(tr_sys) ON UPDATE RESTRICT ON DELETE RESTRICT,
		`cus_id`	INTEGER,
		cus_name text,
		`in`	TEXT,
		`out`	TEXT,
		`date_`	TEXT,
		`remarks`	TEXT,
		now_ TEXT,
		`param1`	TEXT,
		`param2`	TEXT,
		t_cus_id INTEGER ,
		t_cus_name text,
		`f1`	TEXT,
		`f2`	TEXT,
		`f3`	TEXT,
		curr_id integer default 0 references currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		curr_name text,
		bill_id integer default 0,
		p_id integer default 0,
		p_remarks text,
		p_amount real default 0,
		p_status integer default 0,
		p_ref_no text,
		d_amount real default 0,
		d_remarks text,
		p_curr_id integer default 0,
		p_curr_name text,
		curr_price real default 0,
		p_curr_price real default 0,
		p_date text,
		cash_id integer default -3,
		cash_name text,
		curr_mod integer default 0,
		tr_type integer references tran_type(id) ON UPDATE RESTRICT ON DELETE RESTRICT

		)
-- @@ --
CREATE TABLE requests_notify
		(
		id	INTEGER PRIMARY KEY AUTOINCREMENT,
		title text,date_ text default (strftime('%Y-%m-%d','now'))
		,message text,param1 text,param2 text

		)
-- @@ --
CREATE TABLE requests_items
		(
		id	INTEGER PRIMARY KEY AUTOINCREMENT,

		req_id integer,
		date_            text default (strftime('%Y-%m-%d','now')),

		item_name text,
		item_id          integer references items(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		unit_name text,
		unit_id          integer references units(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		o_date text,

		status integer default 0, remarks text, online_ref integer, type_id integer, type_name text,
		unique(req_id,item_name)

		)
-- @@ --
CREATE TABLE requests_items_unit
		(
		req_id                  integer ,
		item_name text,
		item_id          integer references items(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		unit_name text,
		unit_id          integer references units(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		u_val real default 1
		)
-- @@ --
CREATE TABLE requests_items_price
		(
		req_id                  integer ,
		date_ text default (strftime('%Y-%m-%d','now')),
		item_name text,
		item_id          integer references items(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		unit_name text,
		unit_id          integer references units(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		curr_name text,
		curr_id          integer references currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		sls_u_price real default 1
		)
-- @@ --
CREATE TABLE requests_names
		(
		id	INTEGER PRIMARY KEY AUTOINCREMENT,

		req_id integer,


		cus_name text,
		cus_id          integer references customers(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		g_name text,
		g_id          integer references groups(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		gsm text,
		address text,
		status integer default 0, acc_p_id text, online_ref integer,
		unique(req_id,cus_name)

		)
-- @@ --
CREATE TABLE requests_curr
		(
		id	INTEGER PRIMARY KEY AUTOINCREMENT,

		req_id integer,


		curr_name text,
		curr_id          integer references currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		code_name text,
		status integer default 0, fils_name text, online_ref integer,
		unique(req_id,curr_name)

		)
-- @@ --
CREATE TABLE requests_curr_price
		(
		req_id                  integer ,
		f_date text default (strftime('%Y-%m-%d','now')),
		t_date text,
		curr_name text,
		curr_id          integer references currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		price real default 1
		)
-- @@ --
CREATE TABLE tax_type(id INTEGER PRIMARY KEY AUTOINCREMENT,
		name text, unique(name) )
-- @@ --
CREATE TABLE tax(id INTEGER PRIMARY KEY AUTOINCREMENT,
		name text ,
		tax_type_id integer default 1  references tax_type(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		per real default 0 ,is_active integer default 1,is_default integer default 0
		, online integer default 1, online_ref2 Text,unique(name),unique(per) )
-- @@ --
CREATE TABLE cus_limit
		(id INTEGER PRIMARY key AUTOINCREMENT,
		cus_id INTEGER references customers(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		curr_id INTEGER references currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		cr REAL,
		db REAL, online integer default 0, online_ref2 Text,

		unique(cus_id,curr_id)
		)
-- @@ --
CREATE TABLE cus_limit_h
		(id INTEGER PRIMARY key AUTOINCREMENT,
		cus_id INTEGER references customers(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		curr_id INTEGER references currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		cr REAL,
		db REAL, online integer default 0, online_ref2 Text,

		unique(cus_id,curr_id)
		)
-- @@ --
CREATE TABLE reminders
		(
		`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
		cus_id integer references customers(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		date_            text default (strftime('%Y-%m-%d','now')),
		time_ text,
		remarks text,
		flag integer default 0,
		param1 text,param2 text

		, online integer default 0, online_ref2 Text)
-- @@ --
CREATE TABLE users (
		id	INTEGER PRIMARY KEY AUTOINCREMENT,
		user_name	TEXT UNIQUE,
		name	TEXT ,
		pwd	TEXT,
		gsm	TEXT,
		is_active INTEGER default 1,
		cash_id integer  references customers(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		br_id integer  references branches(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		date_ text default (strftime('%Y-%m-%d','now')),
		`param1`	TEXT,
		`param2`	TEXT,
		`f1`	TEXT,
		`f2`	TEXT,
		`f3`	TEXT
		, online integer default 1, online_ref2 Text)
-- @@ --
CREATE TABLE user_priv (
		id	INTEGER PRIMARY KEY AUTOINCREMENT,
		screen_id integer  references screens(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		user_id integer  references users(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
		new INTEGER default 0,
		edit INTEGER default 0,
		view INTEGER default 0,
		del INTEGER default 0,
		date_ text default (strftime('%Y-%m-%d','now')),
		`param1`	TEXT,
		`param2`	TEXT, online integer default 1, online_ref2 Text,
		unique(user_id,screen_id)
		)
-- @@ --
CREATE TABLE bills_log(
  id INT,
  bill_no2 INT,
  date_ TEXT,
  tr_type INT,
  type_ TEXT,
  bill_type INT,
  bill_type_name TEXT,
  cus_name TEXT,
  amount,
  amount2,
  diff,
  d_amount REAL,
  tax_amount REAL,
  d_val REAL,
  discount_id INT,
  t_val REAL,
  tax_id INT,
  tax_amount2,
  d_amount2,
  cost2 REAL,
  r_cost REAL
)
-- @@ --
CREATE TABLE transactions_issue(
  id INT,
  cus_id INT,
  "in" TEXT,
  out TEXT,
  date_ TEXT,
  remarks TEXT,
  now_ TEXT,
  param1 TEXT,
  param2 TEXT,
  t_cus_id INT,
  f1 TEXT,
  f2 TEXT,
  f3 TEXT,
  curr_id INT,
  bill_id INT,
  p_id INT,
  p_remarks TEXT,
  p_amount REAL,
  p_status INT,
  p_ref_no TEXT,
  d_amount REAL,
  d_remarks TEXT,
  curr_price REAL,
  p_curr_id INT,
  p_date TEXT,
  item_id INT,
  cash_id INT,
  fund_id INT,
  tr_type INT,
  p_curr_price REAL,
  curr_mod INT,
  user_id INT,
  online INT,
  online_ref INT,
  c_curr_id INT,
  c_curr_price REAL,
  c_price REAL,
  c_diff_id INT,
  c_p_id INT,
  last_user INT,
  last_update TEXT,
  online_ref2 TEXT
)
-- @@ --
CREATE TABLE z_units (
        id integer primary key autoincrement,
        br_id integer references branches(id),
        env_type integer default 1,
        icv integer,
        pih text default 'NWZlY2ViNjZmZmM4NmYzOGQ5NTI3ODZjNmQ2OTZjNzljMmRiYzIzOWRkNGU5MWI0NjcyOWQ3M2EyN2ZiNTdlOQ==',
        serial_no text unique,
        taxer_id integer,
        egs_id integer,
        cert_id integer unique,
        is_active integer default 0,
        otp text,
        pk text,
        token text,
        date_ text default (strftime('%Y-%m-%d','now'))
        , unit_name text, auto_ integer default 1, vat_no text, cr_no text, z_name text, user_id integer references users(id), device_id text default '', z_address text)
-- @@ --
CREATE TABLE z_status (
        id integer primary key,
        name text unique
        , desc_ text)
-- @@ --
CREATE TABLE item_price_bk (item_id integer REFERENCES items(id) ON UPDATE RESTRICT ON DELETE RESTRICT,curr_id integer REFERENCES currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,unit_id integer REFERENCES units(id) ON UPDATE RESTRICT ON DELETE RESTRICT,SLS_U_PRICE real,date_                    text default (strftime('%Y-%m-%d','now')) ,remarks text,`param1` TEXT,`param2` TEXT)
-- @@ --
CREATE TABLE item_price_org(
  item_id INT,
  curr_id INT,
  SLS_U_PRICE REAL,
  date_ TEXT,
  remarks TEXT,
  param1 TEXT,
  param2 TEXT,
  unit_id INT,
  online INT,
  online_ref2 TEXT
)
-- @@ --
CREATE TABLE item_price (item_id integer REFERENCES items(id) ON UPDATE RESTRICT ON DELETE RESTRICT,curr_id integer REFERENCES currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT,unit_id integer REFERENCES units(id) ON UPDATE RESTRICT ON DELETE RESTRICT,SLS_U_PRICE real,date_                    text default (strftime('%Y-%m-%d','now')) ,remarks text,`param1` TEXT,`param2` TEXT)
-- @@ --
CREATE TABLE cus_search_tmp(
  id INT,
  _id TEXT,
  phone TEXT,
  amount,
  _in,
  curr_name,
  g_name TEXT,
  cnt,
  cus_type TEXT,
  curr_code TEXT,
  "ID:1" INT,
  name TEXT,
  gsm TEXT,
  g_id INT,
  "g_name:1" TEXT,
  f_id INT,
  f_name TEXT,
  cr,
  db,
  balance,
  curr,
  curr_id INT,
  "phone:1" TEXT,
  d,
  days_late,
  max_id,
  "cnt:1"
)
-- @@ --
CREATE INDEX transactions_cus_id on transactions(cus_id)
-- @@ --
CREATE INDEX transactions_t_cus_id on transactions(t_cus_id)
-- @@ --
CREATE INDEX transactions_curr_id on transactions(curr_id)
-- @@ --
CREATE INDEX bill_trans_id on bill_transactions(bill_id)
-- @@ --
CREATE INDEX bill_trans_item_id on bill_transactions(item_id)
-- @@ --
CREATE INDEX bills_br_id on bills(br_id)
-- @@ --
CREATE INDEX bills_curr_id on bills(curr_id)
-- @@ --
CREATE INDEX bills_tr_type_id on bills(tr_type)
-- @@ --
CREATE INDEX transactions_bill_id_t on transactions(bill_id)
-- @@ --
CREATE INDEX cus_ind_g_id on customers(g_id)
-- @@ --
CREATE INDEX cus_ind_acc_id on customers(acc_p_id)
-- @@ --
CREATE INDEX acc_tree_ind_id on account_tree(id)
-- @@ --
CREATE INDEX customers_cus_type_id on customers(cus_type_id)
-- @@ --
CREATE UNIQUE INDEX uq_item_barcode ON items(barcode)
-- @@ --
CREATE UNIQUE INDEX bills2_uq2 ON bills2(tr_type,bill_no2,br_id)
-- @@ --
CREATE INDEX items_cost_calc_item_id on  items_cost_calc(item_id)
-- @@ --
CREATE INDEX items_cost_calc_date_ on  items_cost_calc(date_)
-- @@ --
CREATE INDEX items_cost_calc_br_bill_id on items_cost_calc(br_id,bill_id)
-- @@ --
CREATE UNIQUE INDEX uq_bills_no2 ON bills(tr_type,is_back,br_id,bill_no2,adj_id)
-- @@ --
CREATE UNIQUE INDEX bills_ref2_uq ON bills(online_ref2)
-- @@ --
CREATE UNIQUE INDEX bills2_ref2_uq ON bills2(online_ref2)
-- @@ --
CREATE UNIQUE INDEX items_ref2_uq ON items(online_ref2)
-- @@ --
CREATE UNIQUE INDEX currency_ref2_uq ON currency(online_ref2)
-- @@ --
CREATE UNIQUE INDEX currency_price_ref2_uq ON currency_price(online_ref2)
-- @@ --
CREATE UNIQUE INDEX customers_ref2_uq ON customers(online_ref2)
-- @@ --
CREATE UNIQUE INDEX cus_type_ref2_uq ON cus_type(online_ref2)
-- @@ --
CREATE UNIQUE INDEX groups_ref2_uq ON groups(online_ref2)
-- @@ --
CREATE UNIQUE INDEX closing_year_ref2_uq ON closing_year(online_ref2)
-- @@ --
CREATE UNIQUE INDEX users_ref2_uq ON users(online_ref2)
-- @@ --
CREATE UNIQUE INDEX user_priv_ref2_uq ON user_priv(online_ref2)
-- @@ --
CREATE UNIQUE INDEX tax_ref2_uq ON tax(online_ref2)
-- @@ --
CREATE UNIQUE INDEX units_ref2_uq ON units(online_ref2)
-- @@ --
CREATE UNIQUE INDEX unit_item_ref2_uq ON unit_item(online_ref2)
-- @@ --
CREATE UNIQUE INDEX item_type_ref2_uq ON item_type(online_ref2)
-- @@ --
CREATE UNIQUE INDEX branches_ref2_uq ON branches(online_ref2)
-- @@ --
CREATE UNIQUE INDEX account_tree_ref2_uq ON account_tree(online_ref2)
-- @@ --
CREATE UNIQUE INDEX cus_limit_ref2_uq ON cus_limit(online_ref2)
-- @@ --
CREATE UNIQUE INDEX reminders_ref2_uq ON reminders(online_ref2)
-- @@ --
CREATE UNIQUE INDEX transactions_ref2_uq ON transactions(online_ref2)
-- @@ --
CREATE VIEW item_avg_cost2 as
		select  date(a.date_) date_ ,c.name curr_name,b.item_id,sum(b.qty) qty,b.cost_price,sum(b.qty*b.cost_price) tot_cost
		from bill_transactions b ,bills a,currency c
		where a.id=b.bill_id  and a.curr_id=c.id and a.tr_type =2
		group by b.item_id,c.name,b.cost_price,date(a.date_)
		union all
		select a.o_date,b.name,a.id,a.o_qty,a.o_cost,o_qty*o_cost
		from items a,currency b
		where a.curr_id=b.id
-- @@ --
CREATE VIEW item_avg_cost4 as
		select  a.id,a.date_,d.name br_name,e.name cus_name,h.name item_name,sum(b.qty) qty,
		(case when a.is_back=1 then 'مرتجع'||' '||f.name else f.name end) name,
		(case when a.is_back=1 then -1*f.id else f.id end) tr_type,b.cost_price+b.sls_u_price as price
		from bill_transactions b ,bills a,currency c,branches d  ,customers e,tran_type f,items h
		where a.id=b.bill_id  and a.curr_id=c.id and a.tr_type in (1,2)
		and (a.br_id=d.id or a.to_br_id=d.id)
		and a.cus_id=e.id and a.tr_type=f.id and b.item_id=h.id
		group by b.item_id,a.date_,a.id,c.name,d.name  ,e.id,e.name,f.id,f.name,h.id,h.name,b.cost_price,b.sls_u_price
		union all
		select  a.id,a.date_,(select d.name from branches d where d.id=a.br_id)  br_name,(select d.name from branches d where d.id=a.to_br_id) cus_name,h.name item_name,sum(b.qty) qty,f.name
		,f.id,b.cost_price+b.sls_u_price as price
		from bill_transactions b ,bills a,currency c  ,tran_type f,items h
		where a.id=b.bill_id  and a.curr_id=c.id and a.tr_type=3
		and a.tr_type=f.id and b.item_id=h.id
		group by b.item_id,a.date_,a.id,c.name  ,f.id,f.name,h.id,h.name,b.cost_price,b.sls_u_price
		union all
		select  a.id,a.date_,(select d.name from branches d where d.id=a.to_br_id)
		br_name,(select d.name from branches d where d.id=a.br_id) cus_name,h.name item_name,sum(b.qty) qty,f.name
		,f.id*-1,b.cost_price+b.sls_u_price as price
		from bill_transactions b ,bills a,currency c  ,tran_type f,items h
		where a.id=b.bill_id  and a.curr_id=c.id and a.tr_type=3
		and a.tr_type=f.id and b.item_id=h.id
		group by b.item_id,a.date_,a.id,c.name  ,f.id,f.name,h.id,h.name,b.cost_price,b.sls_u_price
		union all
		select 0 ,a.o_date,c.name,' ' cus_name,a.name,a.o_qty,'إفتتاحي'
		,-1,a.o_cost
		from items a,currency b,branches c
		where a.curr_id=b.id and a.curr_id=c.id
-- @@ --
CREATE VIEW bills2_v as select * from bills2
-- @@ --
CREATE VIEW items_v as select * from items
-- @@ --
CREATE VIEW units_v as select * from units
-- @@ --
CREATE VIEW currency_price_v as
		select * from currency_price where t_date is null
-- @@ --
CREATE VIEW cus_tr_curr_view as
		select a.id as a_id,a.*,b.id b_id,b.name b_name,c.id c_id,c.name c_name,ifnull(d.id,0) d_id,
		ifnull(d.name,(select name from currency where id=0)) d_name,b.g_id,e.id e_id,e.name e_name,b.gsm
		,(case when a.curr_id=0 then 1 else a.curr_price end )*a.out out_,f.id f_id,f.name f_name
		,(case when a.curr_id=0 then 1 else (select price from currency_price_v where curr_id=a.curr_id) end )*a.out out_2
		,a.param2,a.user_id,b.address
		FROM groups c inner join customers AS b on c.id=b.g_id  left join transactions AS a
		on (  a.cus_id = b.id)
		left join currency d on (a.curr_id=d.id)
		inner join cus_type e on e.id=b.cus_type_id
		inner join account_tree f on f.id=b.acc_p_id
		--where  b.cus_type_id in (0,1,4)
		where a.id is not null
		union all
		select a.id as a_id,a.*,b.id b_id,b.name b_name,c.id c_id,c.name c_name,ifnull(d.id,0) d_id,
		ifnull(d.name,(select name from currency where id=0)) d_name,b.g_id,e.id e_id,e.name e_name,b.gsm
		,(case when a.curr_id=0 then 1 else a.curr_price end )*a.out out_,f.id f_id,f.name f_name
		,(case when a.curr_id=0 then 1 else (select price from currency_price_v where curr_id=a.curr_id) end )*a.out out_2
		,a.param2,a.user_id,b.address
		FROM groups c inner join customers AS b on c.id=b.g_id  left join transactions AS a
		on (  a.t_cus_id = b.id)
		left join currency d on (a.curr_id=d.id)
		inner join cus_type e on e.id=b.cus_type_id
		inner join account_tree f on f.id=b.acc_p_id
		where a.t_cus_id is not null
		--and  b.cus_type_id in (0,1,4)
		and a.id is not null
-- @@ --
CREATE VIEW bill_transactions2_v as select a.*,
		ifnull((select u_val from unit_item where item_id=a.item_id and unit_id=a.base_unit ),1) c_val
		,(select b.date_ from bills2 b where b.id=a.bill_id)  bill_date
		from bill_transactions2 a
-- @@ --
CREATE VIEW bill_transactions_v as select a.*,
		ifnull((select u_val from unit_item where item_id=a.item_id and unit_id=a.base_unit ),1) c_val
		,(select b.date_ from bills b where b.id=a.bill_id)  bill_date
		from bill_transactions a
-- @@ --
CREATE VIEW bills_v as select * from bills
-- @@ --
CREATE VIEW items_cost_calc_v as

		-- Opening balance
		select   c.id as item_id,c.o_br_id as br_id,0 to_br_id,c.o_date as date_,-1 bill_id,0 tr_type, 0 is_back,'' name,
		0 bill_no,0 bill_no2,
		c.o_qty as i_q,
		(case when c.curr_id=0 then c.o_cost  else c.curr_price*c.o_cost end ) i_u, 0 o_q,0 as o_u,
		0 n_q,0 n_u,0 n_t,0 r_u,0 adj_id,c.e_date e_date,0 id2
		from items_v c
		where c.o_qty !=0

		union all
		-- purchase and sales with is_back=0
		--v1.120 adj2
		select   b.item_id,a.br_id,a.br_id,a.date_,b.bill_id,a.tr_type,a.is_back,(select name from customers where id=a.cus_id) name,
		a.bill_no,a.bill_no2,
		(case when a.tr_type in(2,21) then b.qty_pr*b.u_val*b.c_val else 0 end) i_q,(case when a.tr_type in(2,21) then
		(case when a.curr_id=0 then b.cost_price+b.u_cost2-b.d_amount/b.u_val
		else a.curr_price*(cost_price+b.u_cost2-b.d_amount/b.u_val) end )

		else 0 end)/b.c_val i_u,
		(case when a.tr_type in(1,11) then b.qty_pr*b.u_val*b.c_val else 0 end) o_q,(case when a.tr_type in(1,11) then
		(case when a.curr_id=0 then b.sls_u_price-b.d_amount/b.u_val
		else a.curr_price*(sls_u_price-b.d_amount/b.u_val ) end )
		else 0 end)/b.c_val o_u,
		0 n_q,0 n_u,0 n_t,0 r_u,a.adj_id,b.e_date e_date,ifnull(a.id2,a.id) id2

		from bills_v a,bill_transactions_v b,items_v c
		where a.id=b.bill_id and b.item_id=c.id
		and a.tr_type in (1,2,11,21) and a.is_back=0
		--2024-12 old yrs
		and a.date_=b.bill_date


		union all

		-- purchase and sales with is_back=1
		--v1.120 adj2 no back with (11,21)
		select   b.item_id,a.br_id,a.br_id,a.date_,b.bill_id,a.tr_type,a.is_back,(select name from customers where id=a.cus_id) name,
		a.bill_no,a.bill_no2,
		(case when a.tr_type in(1,11)  then b.qty_pr*b.u_val*b.c_val else 0 end) i_q,
		(case when a.tr_type in(1,11) then
		(case when a.curr_id=0 then b.sls_u_price-b.d_amount/b.u_val
		else a.curr_price*(sls_u_price-b.d_amount/b.u_val) end )

		else 0 end)/b.c_val i_u,
		(case when a.tr_type=2 then b.qty_pr*b.u_val*b.c_val else 0 end) o_q,
		(case when a.tr_type=2 then
		(case when a.curr_id=0 then b.cost_price+b.u_cost2-b.d_amount/b.u_val
		else a.curr_price*(cost_price+b.u_cost2-b.d_amount/b.u_val ) end )
		else 0 end)/b.c_val o_u,
		0 n_q,0 n_u,0 n_t,0 r_u,a.adj_id,b.e_date e_date,ifnull(a.id2,a.id) id2

		from bills_v a,bill_transactions_v b,items_v c
		where a.id=b.bill_id and b.item_id=c.id
		and a.tr_type in (1,2) and a.is_back=1
		--2024-12 old yrs
		and a.date_=b.bill_date

		--Order Iusse...OUT
		union all
		select  b.item_id,a.br_id,a.to_br_id,a.date_,b.bill_id,a.tr_type,a.is_back,(select name from branches where id=a.to_br_id) name,
		a.bill_no,a.bill_no2,
		0 i_q,0 i_u,
		b.qty_pr*b.u_val*b.c_val o_q,0 o_u,
		0 n_q,0 n_u,0 n_t,0 r_u,a.adj_id,b.e_date e_date,ifnull(a.id2,a.id) id2
		from bills_v a,bill_transactions_v b,items_v c
		where a.id=b.bill_id and b.item_id=c.id
		and a.tr_type =3
		--2024-12 old yrs
		and a.date_=b.bill_date
		union all

		-- Order Issue...IN
		select  b.item_id ,a.to_br_id,a.br_id,a.date_,b.bill_id,a.tr_type,a.is_back,(select name from branches where id=a.br_id) name,
		a.bill_no,a.bill_no2,
		b.qty_pr*b.u_val*b.c_val i_q,0 i_u,
		0 o_q,0 o_u,
		0 n_q,0 n_u,0 n_t,0 r_u,a.adj_id,b.e_date e_date,ifnull(a.id2,a.id) id2
		from bills_v a,bill_transactions_v b,items_v c
		where a.id=b.bill_id and b.item_id=c.id
		and a.tr_type =3
		--2024-12 old yrs
		and a.date_=b.bill_date

		--Adj...IN
		union all
		select  b.item_id ,a.br_id,a.to_br_id,a.date_,b.bill_id,a.tr_type,a.is_back,
		(select name from adj_type where id=a.adj_id) name,
		a.bill_no,a.bill_no2,
		b.qty_pr*b.u_val*b.c_val i_q,b.cost_price/b.c_val i_u,
		0 o_q,0 o_u,
		0 n_q,0 n_u,0 n_t,0 r_u,a.adj_id,b.e_date e_date,ifnull(a.id2,a.id) id2
		from bills_v a,bill_transactions_v b,items_v c
		where a.id=b.bill_id and b.item_id=c.id
		and a.tr_type =4 and a.adj_id in (2,4)
		--2024-12 old yrs
		and a.date_=b.bill_date

		--Adj...OUT
		union all
		select  b.item_id ,a.br_id,a.to_br_id,a.date_,b.bill_id,a.tr_type,a.is_back,
		(select name from adj_type where id=a.adj_id) name,
		a.bill_no,a.bill_no2,
		0 i_q,0 i_u,
		b.qty_pr*b.u_val*b.c_val o_q,b.cost_price/b.c_val o_u,
		0 n_q,0 n_u,0 n_t,0 r_u,a.adj_id,b.e_date e_date,ifnull(a.id2,a.id) id2
		from bills_v a,bill_transactions_v b,items_v c
		where a.id=b.bill_id and b.item_id=c.id
		and a.tr_type =4 and a.adj_id not in(2,4)
		--2024-12 old yrs
		and a.date_=b.bill_date
		order by a.date_,id2,b.bill_id desc,b.item_id
-- @@ --
CREATE VIEW items_cost_calc_end_yr as
		select a.br_id,a.item_id,ifnull(a.e_date,'') e_date,
		ifnull(sum( case when ( (  substr(a.tr_type,1,1)*1=2 and a.is_back=0)  or (a.tr_type=1 and a.is_back=1)
		or (a.tr_type=3 and a.i_q!=0) or a.tr_type=0 or (a.tr_type=4 and a.adj_id in (2,4)) ) then a.i_q else 0 end)
		- sum( case when ( ( substr(a.tr_type,1,1)*1=1 and a.is_back=0)  or (a.tr_type=2 and a.is_back=1)
		or (a.tr_type=3 and a.o_q!=0) or (a.tr_type=4 and a.adj_id not in (2,4)) ) then a.o_q else 0 end),0) n_q
		from items_cost_calc_v a
		where date('now','localtime','start of year','-1 day')>=date(a.date_)
		group by a.br_id,a.item_id,ifnull(a.e_date,'')
-- @@ --
CREATE VIEW profit_loss_vw as
		select 1 id,
		ifnull(abs(sum( case when (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end)>= 0 then  (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end) else 0 end )),0) AS f3,
		ifnull(abs( sum(
		(case when a.b_id in(-8,-11,-9) then -1 else 1 end )*
		case when (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end)>= 0 then 0 else  (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end)  end )),0) AS f4,
		--Net Sales and Discount OUT
		'Net.Sales' ,
		date(strftime('%Y-%m-%d',substr(a.date_,7,4)||'-' ||substr(a.date_,4,2)||'-'||substr(a.date_,1,2) )) date_
		,a.b_name as b_name
		FROM cus_tr_curr_view a
		where  ( a.e_id=2 or a.b_id in (-7,-8))
		and a.a_id is not null
		and a.b_id in (-8,-11,-9,-1,-5)
		group by date(strftime('%Y-%m-%d',substr(a.date_,7,4)||'-' ||substr(a.date_,4,2)||'-'||substr(a.date_,1,2) ))
		,a.b_name

		union all

		select 2 id,
		sum(ifnull((case
		when (substr(a.tr_type,1,1) and a.is_back=0)  then a.o_q*a.n_u
		when (a.tr_type=1 and a.is_back=1)  then -1*a.i_q*a.r_u
		else 0 end) ,0)) AS f3,
		0 f4,
		'Cost.Sales' ,
		a.date_,''
		FROM items_cost_calc a

		group by a.date_

		union all

		select 2 id,
		ifnull(abs(sum(
		(case when a.b_id in(-7,-10,-12) then -1 else 1 end )*
		case when (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end)>= 0 then  (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end) else 0 end )),0) AS f3,
		ifnull(abs( sum(case when (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end)>= 0 then 0 else  (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end)  end )),0) AS f4,
		'Discount.IN' ,
		date(strftime('%Y-%m-%d',substr(a.date_,7,4)||'-' ||substr(a.date_,4,2)||'-'||substr(a.date_,1,2) )) date_
		,a.b_name
		FROM cus_tr_curr_view a
		where  ( a.e_id=2 or a.b_id in (-7,-8))
		and a.a_id is not null
		and a.b_id in (-7)

		group by date(strftime('%Y-%m-%d',substr(a.date_,7,4)||'-' ||substr(a.date_,4,2)||'-'||substr(a.date_,1,2) ))
		,a.b_name
		union
		select 5 id,
		ifnull(abs(sum(case when (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end)>= 0 then  (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end) else 0 end )),0) AS f3,
		ifnull(abs( sum(case when (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end)>= 0 then 0 else  (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end)  end )),0) AS f4,
		'Income' ,
		date(strftime('%Y-%m-%d',substr(a.date_,7,4)||'-' ||substr(a.date_,4,2)||'-'||substr(a.date_,1,2) )) date_
		,a.b_name
		FROM cus_tr_curr_view a
		where  ( a.f_id like '4%' and a.f_id not in(41) )
		and a.a_id is not null
		and a.b_id >0

		group by date(strftime('%Y-%m-%d',substr(a.date_,7,4)||'-' ||substr(a.date_,4,2)||'-'||substr(a.date_,1,2) ))
		,a.b_name
		union
		select 6 id,
		ifnull(abs(sum(case when (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end)>= 0 then  (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end) else 0 end )),0) AS f3,
		ifnull(abs( sum(case when (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end)>= 0 then 0 else  (case when (a.t_cus_id=a.b_id) then -1*a.out_ else
		(a.[in]*a.out_) end)  end )),0) AS f4,
		'Outcome' ,
		date(strftime('%Y-%m-%d',substr(a.date_,7,4)||'-' ||substr(a.date_,4,2)||'-'||substr(a.date_,1,2) )) date_
		,a.b_name
		FROM cus_tr_curr_view a
		where  ( a.f_id like '3%' and a.f_id not in (31) )
		and a.a_id is not null
		and a.b_id >0

		group by date(strftime('%Y-%m-%d',substr(a.date_,7,4)||'-' ||substr(a.date_,4,2)||'-'||substr(a.date_,1,2) ))
		,a.b_name
-- @@ --
CREATE VIEW customers_tree_v as
		select b.id b_id,b.name b_name,c.id c_id,c.name c_name,e.id e_id,e.name e_name,f.id f_id,f.name f_name,b.gsm
		from groups c LEFT join customers AS b on b.g_id=c.id
		INNER join  cus_type e on b.cus_type_id=e.id
		inner join  account_tree f on b.acc_p_id=f.id
-- @@ --
CREATE VIEW transactions_tot_v as
		select a.curr_id curr_id, a.cus_id cus_id,a.t_cus_id t_cus_id,a.[in] [in],sum(a.out) out
		,max(strftime('%Y-%m-%d',substr(a.date_,7,4)||'-' ||substr(a.date_,4,2)||'-'||substr(a.date_,1,2) )) d,count(*) cnt
		,max(a.id) a_id,(select name from currency d where d.id=a.curr_id) d_name
		from transactions_v a
		group by a.curr_id , a.cus_id ,a.t_cus_id ,a.[in]
-- @@ --
CREATE VIEW cus_curr as

		SELECT b.b_id as ID, b.b_name as name,b.gsm gsm ,b.c_id as g_id, b.c_name g_name ,b.f_id as f_id  ,b.f_name,
		sum(case when not(a.[in] = 1 and (a.t_cus_id!=b.b_id or a.t_cus_id is null)) then a.out else 0 end )*1.0 as cr ,
		sum  ( case when a.[in] = 1 and (a.t_cus_id!=b.b_id or a.t_cus_id is null) then a.out else 0 end)*1.0 as db ,
		ifnull( (sum(case when (a.t_cus_id=b.b_id) then -1*a.out else  (a.[in]*a.out) end)),0) AS balance,
		ifnull( a.d_name, (select name from currency where id=0))  curr
		,a.curr_id as curr_id,b.gsm as phone
		,max(a.d) d
		, ( julianday(strftime('%Y-%m-%d','now'))
		-julianday(max(a.d))
		) as days_late,
		ifnull(max(a.a_id),0) max_id,sum(a.cnt) cnt

		from transactions_tot_v a,customers_tree_v b
		where (a.cus_id=b.b_id or a.t_cus_id=b.b_id)
		GROUP BY b.b_name, b.b_id,a.d_name,b.c_id,b.c_name,b.f_id,b.f_name,b.gsm,a.curr_id
		union
		select a.id,a.name,a.gsm,a.g_id,(select name from groups where id=a.g_id) g_name,a.acc_p_id,
		(select name from account_tree where id=a.acc_p_id) f_name,
		0,0,0,
		(select name from currency where id=0),0,a.gsm,strftime('%Y-%m-%d','now'),0,0,0
		from customers a
		where a.id not in (select distinct cus_id from transactions union  select distinct t_cus_id from transactions where t_cus_id is not null)
		ORDER BY d DESC,max_id desc
-- @@ --
CREATE VIEW transactions_v as select * from transactions
-- @@ --
CREATE VIEW bills_tot_issue as
		select a.id id,a.bill_no2 bill_no2,a.date_ date_,a.tr_type tr_type,d.name type_,a.bill_type bill_type,b.name bill_type_name,c.name cus_name
		,round(amount,3) amount,
		(select DISTINCT round(((sum((case when substr(a.tr_type,1,1)*1=1 then sls_u_price else  cost_price end)*qty_pr*u_val))-(case when a.discount_id=0 then a.d_amount when a.d_amount=0 then 0
		else sum((case when substr(a.tr_type,1,1)*1=1 then sls_u_price else  cost_price end)*qty_pr*u_val)*(a.d_val/100) end))*(1+a.t_val/100)+a.cost2,3) from bill_transactions b
		where b.bill_id=a.id) amount2
		,round(amount,3) -
		(select round(((sum((case when substr(a.tr_type,1,1)*1=1 then sls_u_price else  cost_price end)*qty_pr*u_val))-(case when a.discount_id=0 then a.d_amount when a.d_amount=0 then 0
		else sum((case when substr(a.tr_type,1,1)*1=1 then sls_u_price else  cost_price end)*qty_pr*u_val)*(a.d_val/100) end))*(1+a.t_val/100)+a.cost2,3) from bill_transactions b
		where b.bill_id=a.id)  diff,a.d_amount d_amount,a.tax_amount tax_amount,a.d_val d_val,a.discount_id discount_id,a.t_val t_val,a.tax_id tax_id
		,(select DISTINCT round(((sum((case when substr(a.tr_type,1,1)*1=1 then sls_u_price else  cost_price end)*qty_pr*u_val))-(case when a.discount_id=0 then a.d_amount when a.d_amount=0 then 0
		else sum((case when substr(a.tr_type,1,1)*1=1 then sls_u_price else  cost_price end)*qty_pr*u_val)*(a.d_val/100) end))*(0+a.t_val/100),3) from bill_transactions b
		where b.bill_id=a.id) tax_amount2
		,(select DISTINCT round(((case when a.discount_id=0 then a.d_amount when a.d_amount=0 then 0 else sum((case when substr(a.tr_type,1,1)*1=1 then sls_u_price else  cost_price end)*qty_pr*u_val)*(a.d_val/100) end)),3)
		from bill_transactions b
		where b.bill_id=a.id) d_amount2,a.cost2 cost2,a.r_cost r_cost
		from bills a,bill_type b,customers c,tran_type d
		where
		a.bill_type=b.id and a.cus_id=c.id and a.tr_type=d.id and
		abs(round(amount,3))-(select DISTINCT round(((sum((case when substr(a.tr_type,1,1)*1=1 then sls_u_price else  cost_price end)*qty_pr*u_val))-(case when a.discount_id=0 then a.d_amount when a.d_amount=0 then 0
		else sum((case when substr(a.tr_type,1,1)*1=1 then sls_u_price else  cost_price end)*qty_pr*u_val)*(a.d_val/100) end))*(1+a.t_val/100)+a.cost2,3) from bill_transactions b
		where b.bill_id=a.id) not BETWEEN -1 and 1
		and tr_type in(1,2,11,21)
-- @@ --
CREATE TRIGGER bills_delete after delete ON bills
		BEGIN
		delete from transactions where bill_id=OLD.id;
		END
-- @@ --
CREATE TRIGGER items_delete after delete ON items
		BEGIN
		delete from transactions where item_id=OLD.id;
		END
-- @@ --
CREATE TRIGGER closing_year_update_tr
		BEFORE update  ON transactions
		FOR EACH ROW
		WHEN (date(strftime('%Y-%m-%d',substr( OLD.date_,7,4)||'-' ||substr( OLD.date_,4,2)||'-'||substr( OLD.date_,1,2) ))<=
		(select ifnull(max(date_),date(date(strftime('%Y-%m-%d',substr( OLD.date_,7,4)||'-' ||substr( OLD.date_,4,2)||'-'||substr( OLD.date_,1,2) )),'-1 day')) from closing_year))
		BEGIN
		SELECT RAISE(ABORT, 'CLOSED YEAR') ;
		END
-- @@ --
CREATE TRIGGER closing_year_delete_tr
		BEFORE delete  ON transactions
		FOR EACH ROW
		WHEN (date(strftime('%Y-%m-%d',substr( OLD.date_,7,4)||'-' ||substr( OLD.date_,4,2)||'-'||substr( OLD.date_,1,2) ))<=
		(select ifnull(max(date_),date(date(strftime('%Y-%m-%d',substr( OLD.date_,7,4)||'-' ||substr( OLD.date_,4,2)||'-'||substr( OLD.date_,1,2) )),'-1 day')) from closing_year))
		BEGIN
		SELECT RAISE(ABORT, 'CLOSED YEAR') ;
		END
-- @@ --
CREATE TRIGGER closing_year_insert_tr
		BEFORE insert  ON transactions
		FOR EACH ROW
		WHEN (date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) ))
		<=
		(select ifnull(max(date_),date(date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-'
		||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) )),'-1 day')) from closing_year))
		BEGIN
		SELECT RAISE(ABORT, 'CLOSED YEAR') ;
		END
-- @@ --
CREATE TRIGGER closing_year_update_bills
		BEFORE update ON bills
		FOR EACH ROW
		WHEN (date(OLD.date_)<=
		(select ifnull(max(date_),date(OLD.date_,'-1 day')) from closing_year))
		BEGIN
		SELECT RAISE(ABORT, 'CLOSED YEAR') ;
		END
-- @@ --
CREATE TRIGGER invalid_update_bills
		BEFORE update ON bills
		FOR EACH ROW
		WHEN (NEW.bill_no2='' )
		BEGIN
		SELECT RAISE(ABORT, 'Invalid Bill') ;
		END
-- @@ --
CREATE TRIGGER closing_year_delete_bills
		BEFORE delete ON bills
		FOR EACH ROW
		WHEN (date(OLD.date_)<=
		(select ifnull(max(date_),date(OLD.date_,'-1 day')) from closing_year))
		BEGIN
		SELECT RAISE(ABORT, 'CLOSED YEAR') ;
		END
-- @@ --
CREATE TRIGGER closing_year_insert_bills
		BEFORE insert ON bills
		FOR EACH ROW
		WHEN (date(NEW.date_)<=
		(select ifnull(max(date_),date(NEW.date_,'-1 day')) from closing_year))
		BEGIN
		SELECT RAISE(ABORT, 'CLOSED YEAR') ;
		END
-- @@ --
CREATE TRIGGER closing_year_delete_bills2
		BEFORE delete ON bills2
		FOR EACH ROW
		WHEN OLD.tr_type=7 and (date(OLD.date_)<=
		(select ifnull(max(date_),date(OLD.date_,'-1 day')) from closing_year))
		BEGIN
		SELECT RAISE(ABORT, 'CLOSED YEAR') ;
		END
-- @@ --
CREATE TRIGGER closing_year_update_bills2
		BEFORE update ON bills2
		FOR EACH ROW
		WHEN OLD.tr_type=7 and (date(OLD.date_)<=
		(select ifnull(max(date_),date(OLD.date_,'-1 day')) from closing_year))
		BEGIN
		SELECT RAISE(ABORT, 'CLOSED YEAR') ;
		END
-- @@ --
CREATE TRIGGER closing_year_delete_items
		BEFORE delete ON items
		FOR EACH ROW
		WHEN (date(OLD.o_date)<=
		(select ifnull(max(date_),date(OLD.o_date,'-1 day')) from closing_year))
		BEGIN
		SELECT RAISE(ABORT, 'CLOSED YEAR') ;
		END
-- @@ --
CREATE TRIGGER closing_year_insert_items
		BEFORE insert ON items
		FOR EACH ROW
		WHEN (date(NEW.o_date)<=
		(select ifnull(max(date_),date(NEW.o_date,'-1 day')) from closing_year))
		BEGIN
		SELECT RAISE(ABORT, 'CLOSED YEAR') ;
		END
-- @@ --
CREATE TRIGGER invalid_delete_customers
		BEFORE delete ON customers
		FOR EACH ROW
		WHEN (
		exists (select 1 from transactions where cus_id=OLD.id)
		or exists(select 1 from transactions where t_cus_id is not null and t_cus_id=OLD.id)
		or exists(select 1 from bills where cus_id is not null and cus_id=OLD.id)
		or exists(select 1 from bills2 where cus_id is not null and cus_id=OLD.id)
		)
		BEGIN
		SELECT RAISE(ABORT, 'Invalid Delete Customer') ;
		END
-- @@ --
CREATE TRIGGER items_OP_insert after insert ON items
		when (NEW.o_cost!=0 and NEW.o_qty!=0)
		BEGIN
		--delete from transactions where item_id=NEW.id and date_=strftime('%d-%m-%Y',NEW.o_date);
		delete from transactions where item_id=NEW.id ;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,item_id,remarks,param2)
		values(-14,-13,
		1,NEW.o_qty*NEW.o_cost,NEW.curr_id,strftime('%d-%m-%Y',NEW.o_date),-4,NEW.id,
		(select name from tran_type where id=0)||'#'||NEW.name
		,
		strftime('%H:%M', datetime('now','localtime'))
		);
		END
-- @@ --
CREATE TRIGGER items_OP_update after update ON items
		when (( NEW.o_cost!=0 or OLD.o_cost!=0)
		--to allow change unit--2023-01-23
		--prevent update if unit_id is changed after closing year--2023-01-23
		and not (date(OLD.o_date)<=
		(select ifnull(max(date_),date(OLD.o_date,'-1 day')) from closing_year))
		)


		BEGIN
		--delete from transactions where item_id=NEW.id and date_=strftime('%d-%m-%Y',OLD.o_date);
		delete from transactions where item_id=NEW.id ;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,item_id,remarks,param2)
		select -14,-13,
		1,NEW.o_qty*NEW.o_cost,NEW.curr_id,strftime('%d-%m-%Y',NEW.o_date),-4,NEW.id,
		(select name from tran_type where id=0)||'#'||NEW.name
		,
		strftime('%H:%M', datetime('now','localtime'))
		where NEW.o_cost!=0;
		--delete if new cost is zero
		delete from transactions where item_id=NEW.id and date_=strftime('%d-%m-%Y',NEW.o_date) and [out]=0.0;
		END
-- @@ --
CREATE TRIGGER bills_purchase_insert after insert ON bills
		when (NEW.tr_type=2 and NEW.bill_type=2 and NEW.is_back=0 and NEW.tax_amount=0
		and NEW.cost2=0)
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-2,NEW.cus_id,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);
		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cus_id,NEW.cash_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مشتريات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;
		END
-- @@ --
CREATE TRIGGER bills_purchase_insert_t after insert ON bills
		when (NEW.tr_type=2 and NEW.bill_type=2 and NEW.is_back=0 and
		(NEW.tax_amount!=0 or NEW.cost2!=0) )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-2,NEW.tr_type,
		1,NEW.amount-NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,NEW.tr_type,
		-1,NEW.amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		-1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم فاتورة مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة فاتورة مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cus_id,NEW.cash_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مشتريات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;
		delete from transactions where bill_id=NEW.id and [out]=0.0;

		END
-- @@ --
CREATE TRIGGER bills_purchase_insert_is_back after insert ON bills
		when (NEW.tr_type=2 and NEW.bill_type=2 and NEW.is_back=1 and NEW.tax_amount=0
		and NEW.cost2=0)
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(t_cus_id,cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-10,NEW.cus_id,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);
		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cash_id,NEW.cus_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مرتجع مشتريات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;
		END
-- @@ --
CREATE TRIGGER bills_purchase_insert_is_back_t after insert ON bills
		when (NEW.tr_type=2 and NEW.bill_type=2 and NEW.is_back=1
		and (NEW.cost2!=0 or NEW.tax_amount!=0))
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-10,NEW.tr_type,
		-1,NEW.amount-NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,NEW.tr_type,
		1,NEW.amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم مرتجع مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		-1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة مرتجع مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cash_id,NEW.cus_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مرتجع مشتريات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;

		delete from transactions where bill_id=NEW.id and [out]=0.0;


		END
-- @@ --
CREATE TRIGGER bills_sales_insert after insert ON bills
		when (NEW.tr_type=1 and NEW.bill_type=2 and NEW.is_back=0 and NEW.tax_amount=0
		and NEW.cost2=0)
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,-1,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);
		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cash_id,NEW.cus_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مبيعات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;

		END
-- @@ --
CREATE TRIGGER bills_sales_insert_t after insert ON bills
		when (NEW.tr_type=1 and NEW.bill_type=2 and NEW.is_back=0 and
		(NEW.cost2!=0 or NEW.tax_amount!=0 ))
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,NEW.tr_type,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-1,NEW.tr_type,
		-1,NEW.amount-NEW.tax_amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		-1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة فاتورة مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cost_id,-5,
		-1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم فاتورة مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cash_id,NEW.cus_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مبيعات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;



		delete from transactions where bill_id=NEW.id and [out]=0.0;


		END
-- @@ --
CREATE TRIGGER bills_sales_insert_is_back after insert ON bills
		when (NEW.tr_type=1 and NEW.bill_type=2 and NEW.is_back=1 and NEW.tax_amount=0
		and NEW.cost2=0)
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(t_cus_id,cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,-9,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);

		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cus_id,NEW.cash_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مرتجع مبيعات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;

		END
-- @@ --
CREATE TRIGGER bills_sales_insert_is_back_t after insert ON bills
		when (NEW.tr_type=1 and NEW.bill_type=2 and NEW.is_back=1 and
		(NEW.cost2!=0 or NEW.tax_amount!=0 ))
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,NEW.tr_type,
		-1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-9,NEW.tr_type,
		1,NEW.amount-NEW.tax_amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة مرتجع مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cost_id,-5,
		1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم مرتجع مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cus_id,NEW.cash_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مرتجع مبيعات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;



		delete from transactions where bill_id=NEW.id and [out]=0.0;


		END
-- @@ --
CREATE TRIGGER bills_sales_insert_cash after insert ON bills
		when ( NEW.tr_type=1 and NEW.bill_type=1 and NEW.is_back=0 and NEW.tax_amount=0
		and NEW.cost2=0)
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);
		END
-- @@ --
CREATE TRIGGER bills_sales_insert_cash_t after insert ON bills
		when ( NEW.tr_type=1 and NEW.bill_type=1 and NEW.is_back=0 and
		(NEW.cost2!=0 or NEW.tax_amount!=0 or NEW.r_cost!=0))
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,NEW.tr_type,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-5,NEW.tr_type,
		-1,NEW.amount-NEW.tax_amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		-1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||	NEW.remarks||'_'||
		'مقابل ضريبة فاتورة مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cost_id,-5,
		-1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||	'#'||NEW.remarks||'_'||
		'مقابل رسوم فاتورة مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);




		delete from transactions where bill_id=NEW.id and [out]=0.0;

		END
-- @@ --
CREATE TRIGGER bills_sales_insert_cash_is_back after insert ON bills
		when ( NEW.tr_type=1 and NEW.bill_type=1 and NEW.is_back=1 and NEW.tax_amount=0
		and NEW.cost2=0)
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(t_cus_id,cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-11,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);
		END
-- @@ --
CREATE TRIGGER bills_sales_insert_cash_is_back_t after insert ON bills
		when ( NEW.tr_type=1 and NEW.bill_type=1 and NEW.is_back=1 and
		(NEW.cost2!=0 or NEW.tax_amount!=0 ))
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,NEW.tr_type,
		-1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-11,NEW.tr_type,
		1,NEW.amount-NEW.tax_amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||	NEW.remarks||'_'||
		'مقابل ضريبة مرتجع مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cost_id,-5,
		1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||	NEW.remarks||'_'||
		'مقابل رسوم مرتجع مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);


		delete from transactions where bill_id=NEW.id and [out]=0.0;




		END
-- @@ --
CREATE TRIGGER bills_purchase_insert_cash after insert ON bills
		when ( NEW.tr_type=2 and NEW.bill_type=1 and NEW.is_back=0 and NEW.tax_amount=0
		and NEW.cost2=0)
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-6,NEW.cash_id,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);
		END
-- @@ --
CREATE TRIGGER bills_purchase_insert_cash_t after insert ON bills
		when ( NEW.tr_type=2 and NEW.bill_type=1 and NEW.is_back=0 and
		(NEW.cost2!=0 or NEW.tax_amount!=0 ))
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-6,NEW.tr_type,
		1,NEW.amount-NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,NEW.tr_type,
		-1,NEW.amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||	NEW.remarks||'_'||
		'مقابل ضريبة فاتورة مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		-1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||	NEW.remarks||'_'||
		'مقابل رسوم فاتورة مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		delete from transactions where bill_id=NEW.id and [out]=0.0;

		END
-- @@ --
CREATE TRIGGER bills_purchase_insert_cash_is_back after insert ON bills
		when ( NEW.tr_type=2 and NEW.bill_type=1 and NEW.is_back=1 and NEW.tax_amount=0
		and NEW.cost2=0)
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(t_cus_id,cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-12,NEW.cash_id,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);
		END
-- @@ --
CREATE TRIGGER bills_purchase_insert_cash_is_back_t after insert ON bills
		when ( NEW.tr_type=2 and NEW.bill_type=1 and NEW.is_back=1 and
		(NEW.cost2!=0 or NEW.tax_amount!=0 ))
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,NEW.tr_type,
		1,NEW.amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-12,NEW.tr_type,
		-1,NEW.amount-NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		-1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||	NEW.remarks||'_'||
		'مقابل ضريبة مرتجع مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||	NEW.remarks||'_'||
		'مقابل رسوم مرتجع مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);
		delete from transactions where bill_id=NEW.id and [out]=0.0;



		END
-- @@ --
CREATE TRIGGER bills_purchase_update_cash after update ON bills
		when ( NEW.tr_type=2 and NEW.bill_type=1 and NEW.is_back=0 and NEW.tax_amount=0
		and NEW.cost2=0 and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-6,NEW.cash_id,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);
		END
-- @@ --
CREATE TRIGGER bills_purchase_update_cash_t after update ON bills
		when ( NEW.tr_type=2 and NEW.bill_type=1 and NEW.is_back=0 and
		(NEW.cost2!=0 or NEW.tax_amount!=0) and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-6,NEW.tr_type,
		1,NEW.amount-NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,NEW.tr_type,
		-1,NEW.amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		-1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم فاتورة مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة فاتورة مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		delete from transactions where bill_id=NEW.id and [out]=0.0;

		END
-- @@ --
CREATE TRIGGER bills_purchase_update_cash_is_back after update ON bills
		when ( NEW.tr_type=2 and NEW.bill_type=1 and NEW.is_back=1 and NEW.tax_amount=0
		and NEW.cost2=0 and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(t_cus_id,cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-12,NEW.cash_id,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);
		END
-- @@ --
CREATE TRIGGER bills_purchase_update_cash_is_back_t after update ON bills
		when ( NEW.tr_type=2 and NEW.bill_type=1 and NEW.is_back=1 and
		(NEW.cost2!=0 or NEW.tax_amount!=0) and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,NEW.tr_type,
		1,NEW.amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-12,NEW.tr_type,
		-1,NEW.amount-NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم مرتجع مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		-1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة مرتجع مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		delete from transactions where bill_id=NEW.id and [out]=0.0;


		END
-- @@ --
CREATE TRIGGER bills_purchase_update_post after update ON bills
		when ( NEW.tr_type=2 and NEW.bill_type=2 and NEW.is_back=0 and NEW.tax_amount=0
		and NEW.cost2=0 and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-2,NEW.cus_id,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);

		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cus_id,NEW.cash_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مشتريات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;


		END
-- @@ --
CREATE TRIGGER bills_purchase_update_post_t after update ON bills
		when ( NEW.tr_type=2 and NEW.bill_type=2 and NEW.is_back=0 and
		(NEW.cost2!=0 or NEW.tax_amount!=0) and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-2,NEW.tr_type,
		1,NEW.amount-NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,NEW.tr_type,
		-1,NEW.amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		-1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم فاتورة مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة فاتورة مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cus_id,NEW.cash_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مشتريات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;

		delete from transactions where bill_id=NEW.id and [out]=0.0;


		END
-- @@ --
CREATE TRIGGER bills_purchase_update_post_is_back after update ON bills
		when ( NEW.tr_type=2 and NEW.bill_type=2 and NEW.is_back=1 and NEW.tax_amount=0
		and NEW.cost2=0  and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(t_cus_id,cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-10,NEW.cus_id,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);

		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cash_id,NEW.cus_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مرتجع مشتريات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;

		END
-- @@ --
CREATE TRIGGER bills_purchase_update_post_is_back_t after update ON bills
		when ( NEW.tr_type=2 and NEW.bill_type=2 and NEW.is_back=1 and
		(NEW.cost2!=0 or NEW.tax_amount!=0) and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-10,NEW.tr_type,
		-1,NEW.amount-NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,NEW.tr_type,
		1,NEW.amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم مرتجع مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		-1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة مرتجع مشتريات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cash_id,NEW.cus_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مرتجع مشتريات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;

		delete from transactions where bill_id=NEW.id and [out]=0.0;



		END
-- @@ --
CREATE TRIGGER bills_sales_update_cash after update ON bills
		when ( NEW.tr_type=1 and NEW.bill_type=1 and NEW.is_back=0 and NEW.tax_amount=0
		and NEW.cost2=0 and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);
		END
-- @@ --
CREATE TRIGGER bills_sales_update_cash_t after update ON bills
		when ( NEW.tr_type=1 and NEW.bill_type=1 and NEW.is_back=0 and
		(NEW.cost2!=0 or NEW.tax_amount!=0 ) and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,NEW.tr_type,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-5,NEW.tr_type,
		-1,NEW.amount-NEW.tax_amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		-1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||	NEW.remarks||'_'||
		'مقابل ضريبة فاتورة مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cost_id,-5,
		-1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks||'_'||
		'مقابل رسوم فاتورة مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);




		delete from transactions where bill_id=NEW.id and [out]=0.0;


		END
-- @@ --
CREATE TRIGGER bills_sales_update_cash_is_back after update ON bills
		when ( NEW.tr_type=1 and NEW.bill_type=1 and NEW.is_back=1 and NEW.tax_amount=0
		and NEW.cost2=0 and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(t_cus_id,cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-11,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);
		END
-- @@ --
CREATE TRIGGER bills_sales_update_cash_is_back_t after update ON bills
		when ( NEW.tr_type=1 and NEW.bill_type=1 and NEW.is_back=1 and
		(NEW.cost2!=0 or NEW.tax_amount!=0 ) and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,NEW.tr_type,
		-1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-11,NEW.tr_type,
		1,NEW.amount-NEW.tax_amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks||'_'||
		'مقابل ضريبة مرتجع مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cost_id,-5,
		1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		(select name from customers where id=NEW.cus_id)||'#'||NEW.remarks||'_'||
		'مقابل رسوم مرتجع مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);


		delete from transactions where bill_id=NEW.id and [out]=0.0;

		END
-- @@ --
CREATE TRIGGER bills_sales_update_post after update ON bills
		when ( NEW.tr_type=1 and NEW.bill_type=2 and NEW.is_back=0 and NEW.tax_amount=0
		and NEW.cost2=0 and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,-1,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);
		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cash_id,NEW.cus_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مبيعات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;

		END
-- @@ --
CREATE TRIGGER bills_sales_update_post_t after update ON bills
		when ( NEW.tr_type=1 and NEW.bill_type=2 and NEW.is_back=0 and
		(NEW.cost2!=0 or NEW.tax_amount!=0 ) and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,NEW.tr_type,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-1,NEW.tr_type,
		-1,NEW.amount-NEW.tax_amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		-1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة فاتورة مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cost_id,-5,
		-1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم فاتورة مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cash_id,NEW.cus_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مبيعات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;



		delete from transactions where bill_id=NEW.id and [out]=0.0;


		END
-- @@ --
CREATE TRIGGER bills_sales_update_post_is_back after update ON bills
		when ( NEW.tr_type=1 and NEW.bill_type=2 and NEW.is_back=1 and NEW.tax_amount=0
		and NEW.cost2=0 and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(t_cus_id,cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,-9,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2

		);

		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cus_id,NEW.cash_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مرتجع مبيعات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;
		END
-- @@ --
CREATE TRIGGER bills_sales_update_post_is_back_t after update ON bills
		when ( NEW.tr_type=1 and NEW.bill_type=2 and NEW.is_back=1 and
		(NEW.cost2!=0 or NEW.tax_amount!=0 ) and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,NEW.tr_type,
		-1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-9,NEW.tr_type,
		1,NEW.amount-NEW.tax_amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة مرتجع مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cost_id,-5,
		1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم مرتجع مبيعات#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		--v195
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		select NEW.cus_id,NEW.cash_id,
		1,NEW.paid_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		'من قيمة فاتورة مرتجع مبيعات#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2
		where NEW.paid_amount!=0;


		delete from transactions where bill_id=NEW.id and [out]=0.0;

		END
-- @@ --
CREATE TRIGGER bills_inv_out_insert after insert ON bills
		when (NEW.tr_type=11 and NEW.bill_type=2 and NEW.is_back=0 and NEW.tax_amount=0
		and NEW.cost2=0 and NEW.r_cost=0)
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no,tr_type)
		values(NEW.cus_id,-30,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2,NEW.tr_type

		);
		END
-- @@ --
CREATE TRIGGER bills_inv_out_insert_t after insert ON bills
		when (NEW.tr_type=11 and NEW.bill_type=2 and NEW.is_back=0
		and (NEW.cost2!=0 or NEW.tax_amount!=0 or NEW.r_cost!=0))
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,NEW.tr_type,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);



		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-30,NEW.tr_type,
		-1,NEW.amount-NEW.tax_amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);


		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		-1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة صرف مخزني#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		-1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم صرف مخزني#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);


		delete from transactions where bill_id=NEW.id and [out]=0.0;

		END
-- @@ --
CREATE TRIGGER bills_inv_out_update_post after update ON bills
		when ( NEW.tr_type=11 and NEW.bill_type=2 and NEW.is_back=0 and NEW.tax_amount=0
		and NEW.cost2=0 and NEW.r_cost=0 and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no,tr_type)
		values(NEW.cus_id,-30,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2,NEW.tr_type

		);
		END
-- @@ --
CREATE TRIGGER bills_inv_out_update_post_t after update ON bills
		when (NEW.tr_type=11 and NEW.bill_type=2 and NEW.is_back=0
		and (NEW.cost2!=0 or NEW.tax_amount!=0 or NEW.r_cost!=0) and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,NEW.tr_type,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-30,NEW.tr_type,
		-1,NEW.amount-NEW.tax_amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);


		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		-1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة صرف مخزني#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		-1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم صرف مخزني#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2);


		delete from transactions where bill_id=NEW.id and [out]=0.0;


		END
-- @@ --
CREATE TRIGGER bills_inv_in_insert after insert ON bills
		when (NEW.tr_type=21 and NEW.bill_type=2 and NEW.is_back=0 and NEW.tax_amount=0
		and NEW.cost2=0)
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no,tr_type)
		values(-30,NEW.cus_id,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2,NEW.tr_type

		);
		END
-- @@ --
CREATE TRIGGER bills_inv_in_insert_t after insert ON bills
		when (NEW.tr_type=21 and NEW.bill_type=2 and NEW.is_back=0
		and (NEW.cost2!=0 or NEW.tax_amount!=0)
		)
		BEGIN
		delete from transactions where bill_id=NEW.id;

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-30,NEW.tr_type,
		1,NEW.amount-NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,NEW.tr_type,
		-1,NEW.amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		-1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم توريد مخزني#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );



		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة توريد مخزني#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		delete from transactions where bill_id=NEW.id and [out]=0.0;

		END
-- @@ --
CREATE TRIGGER bills_inv_in_update_post after update ON bills
		when ( NEW.tr_type=21 and NEW.bill_type=2 and NEW.is_back=0 and NEW.tax_amount=0
		and NEW.cost2=0 and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no,tr_type)
		values(-30,NEW.cus_id,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2,NEW.tr_type

		);
		END
-- @@ --
CREATE TRIGGER bills_inv_in_update_post_t after update ON bills
		when (NEW.tr_type=21 and NEW.bill_type=2 and NEW.is_back=0
		and (NEW.cost2!=0 or NEW.tax_amount!=0)
		and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-30,NEW.tr_type,
		1,NEW.amount-NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cus_id,NEW.tr_type,
		-1,NEW.amount-NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(NEW.cash_id,-5,
		-1,NEW.cost2,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل رسوم توريد مخزني#'
		||NEW.bill_no2
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );



		insert or ignore into transactions(cus_id,tr_type,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no)
		values(-18,-4,
		1,NEW.tax_amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks||'_'||
		'مقابل ضريبة توريد مخزني#'
		||NEW.bill_no2,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2 );

		delete from transactions where bill_id=NEW.id and [out]=0.0;

		END
-- @@ --
CREATE TRIGGER transactions_cr_insert after insert ON transactions
		when (NEW.[in]='-1' and NEW.t_cus_id is null and NEW.bill_id=0  )
		BEGIN
		update transactions set [in]=1,t_cus_id=NEW.cus_id,cus_id=NEW.cash_id
		,curr_price=
		(case when NEW.curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.curr_id and
		date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) ))
		between f_date and
		ifnull(t_date,date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) )))),0)
		else 1 end )

		,p_curr_price=
		(case when NEW.p_curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.p_curr_id and
		date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) ))
		between f_date and
		ifnull(t_date,date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) )))),0)
		else 1 end )
		,p_date=NEW.date_

		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER transactions_db_insert after insert ON transactions
		when (NEW.[in]='1' and NEW.t_cus_id is null and NEW.bill_id=0 )
		BEGIN
		update transactions set t_cus_id=NEW.cash_id
		,p_date=NEW.date_
		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER transactions_cr_op_insert after insert ON transactions
		when (NEW.[in]='-1' and NEW.t_cus_id is null and NEW.bill_id=-1  )
		BEGIN
		--Supplier
		update transactions set [in]=1,t_cus_id=NEW.cus_id,cus_id=New.fund_id


		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER transactions_db_op_insert after insert ON transactions
		when (NEW.[in]='1' and NEW.t_cus_id is null and NEW.bill_id=-1 )
		BEGIN
		--Customer
		update transactions set t_cus_id=New.fund_id

		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER transactions_cr_op_update after update ON transactions
		when (NEW.[in]='-1' and NEW.t_cus_id is null and NEW.bill_id=-1  and (select is_active from trigger_flags)=1  )
		BEGIN
		--Supplier
		update transactions set [in]=1,t_cus_id=NEW.cus_id,cus_id=New.fund_id



		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER transactions_db_op_update after update ON transactions
		when (NEW.[in]='1' and NEW.t_cus_id is null and NEW.bill_id=-1 and (select is_active from trigger_flags)=1  )
		BEGIN
		--Customer
		update transactions set t_cus_id=New.fund_id



		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER transactions_cr_disc_insert after insert ON transactions
		when (NEW.[in]='-1' and NEW.d_amount !=0 and NEW.bill_id=0  )
		BEGIN
		insert or ignore into transactions(cus_id,t_cus_id,date_,remarks,[in],out,param1,param2,d_amount,bill_id,p_id,curr_id,p_curr_id,p_date
		)
		values(-8,NEW.cus_id,NEW.date_,NEW.d_remarks,1,NEW.d_amount,NEW.param1,NEW.param2,0,
		-2,
		(select ifnull(max(a.p_id),0)+1   as _id from transactions a where a.bill_id=-2)
		,NEW.curr_id,NEW.curr_id
		,NEW.date_

		);
		update transactions set bill_id=-2,p_id=
		--without incremental as prev. record
		(select ifnull(max(a.p_id),0)   as _id from transactions a where a.bill_id=-2)
		,p_curr_id=NEW.curr_id

		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER transactions_db_disc_insert after insert ON transactions
		when (NEW.[in]='1' and  NEW.d_amount !=0 and NEW.bill_id=0 )
		BEGIN
		insert or ignore into transactions(cus_id,t_cus_id,date_,remarks,[in],out,param1,param2,d_amount,bill_id,p_id
		,curr_id,p_curr_id,p_date)
		values(NEW.cus_id,-7,NEW.date_,NEW.d_remarks,1,NEW.d_amount,NEW.param1,NEW.param2,0,
		-2,
		(select ifnull(max(a.p_id),0)+1   as _id from transactions a where a.bill_id=-2)
		,NEW.curr_id,NEW.curr_id
		,NEW.date_
		);
		update transactions set bill_id=-2,p_id=
		--without incremental as prev. record
		(select ifnull(max(a.p_id),0)   as _id from transactions a where a.bill_id=-2)
		,p_curr_id=NEW.curr_id
		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER currency_price_delete after delete ON currency_price
		when (OLD.t_date is null)
		BEGIN
		update currency_price set
		t_date=null
		where curr_id=OLD.curr_id
		and f_date = (select max(f_date) from currency_price where curr_id=OLD.curr_id );
		END
-- @@ --
CREATE TRIGGER currency_price_delete2 after delete ON currency_price
		when (OLD.t_date is not null)
		BEGIN
		update currency_price set
		t_date=OLD.t_date
		where curr_id=OLD.curr_id
		and f_date = (select max(f_date) from currency_price
		where curr_id=OLD.curr_id and f_date
		--less than
		<
		OLD.f_date);
		END
-- @@ --
CREATE TRIGGER transactions_curr_price_insert after insert ON transactions
		when ((NEW.curr_id!=0 or NEW.p_curr_id!=0  ) and NEW.curr_mod=0) --new record
		BEGIN
		update transactions set
		curr_price=
		(case when NEW.curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.curr_id and
		date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) ))
		between f_date and
		ifnull(t_date,date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) )))),0)
		else 1 end )
		,p_curr_price=
		(case when NEW.p_curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.p_curr_id and
		date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) ))
		between f_date and
		ifnull(t_date,date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) )))),0)
		else 1 end )

		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER transactions_curr_price_update after update ON transactions
		--when ( NEW.curr_id!=0 and (OLD.curr_id!=NEW.curr_id  or OLD.date_!=NEW.date_ ) and NEW.curr_mod=0   ) --update curr or date
		when (( NEW.curr_id!=0 or NEW.p_curr_id!=0   ) and  NEW.curr_mod=0  and (select is_active from trigger_flags)=1 ) --update curr or date
		BEGIN
		update transactions set curr_price=
		(case when NEW.curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.curr_id and
		date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) ))
		between f_date and
		ifnull(t_date,date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) )))),0)
		else 1 end )
		,p_curr_price=
		(case when NEW.p_curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.p_curr_id and
		date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) ))
		between f_date and
		ifnull(t_date,date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) )))),0)
		else 1 end )

		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER tr_p_temps_curr_price_insert after insert ON tr_p_temps
		when ((NEW.curr_id!=0 or NEW.p_curr_id!=0 ) and NEW.curr_mod=0) --new record
		BEGIN
		update tr_p_temps set
		curr_price=
		(case when NEW.curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.curr_id and
		date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) ))
		between f_date and
		ifnull(t_date,date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) )))),0)
		else 1 end )
		,p_curr_price=
		(case when NEW.p_curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.p_curr_id and
		date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) ))
		between f_date and
		ifnull(t_date,date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) )))),0)
		else 1 end )

		where no_=NEW.no_;
		END
-- @@ --
CREATE TRIGGER tr_p_temps_curr_price_update after update ON tr_p_temps
		--when ( NEW.curr_id!=0 and (OLD.curr_id!=NEW.curr_id  or OLD.date_!=NEW.date_ )   ) --update curr or date
		when (( NEW.curr_id!=0 or NEW.p_curr_id!=0  ) and NEW.curr_mod=0) --update curr or date
		BEGIN
		update tr_p_temps set curr_price=
		(case when NEW.curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.curr_id and
		date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) ))
		between f_date and
		ifnull(t_date,date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) )))),0)
		else 1 end )
		,p_curr_price=
		(case when NEW.p_curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.p_curr_id and
		date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) ))
		between f_date and
		ifnull(t_date,date(strftime('%Y-%m-%d',substr( NEW.date_,7,4)||'-' ||substr( NEW.date_,4,2)||'-'||substr( NEW.date_,1,2) )))),0)
		else 1 end )

		where no_=NEW.no_;
		END
-- @@ --
CREATE TRIGGER bill_transactions_curr_price_insert after insert ON bills
		when (NEW.curr_id!=0 and NEW.curr_price=0 ) --new record
		BEGIN
		update bills set
		curr_price=
		(case when NEW.curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.curr_id and
		NEW.date_
		between f_date and
		ifnull(t_date,NEW.date_))
		,0)
		else 1 end )
		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER bill_transactions_curr_price_update after update ON bills
		--when ( NEW.curr_id!=0 and (OLD.curr_id!=NEW.curr_id  or OLD.date_!=NEW.date_ )   ) --update curr or date
		when ( NEW.curr_id!=0  and NEW.curr_mod=0  and (select is_active from trigger_flags)=1 ) --update curr or date
		BEGIN
		update bills set curr_price=
		(case when NEW.curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.curr_id and
		NEW.date_
		between f_date and
		ifnull(t_date,NEW.date_))
		,0)
		else 1 end )

		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER items_curr_price_insert after insert ON items
		when (NEW.curr_id!=0 and NEW.curr_price=0 ) --new record
		BEGIN
		update items set
		curr_price=
		(case when NEW.curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.curr_id and
		NEW.o_date
		between f_date and
		ifnull(t_date,NEW.o_date))
		,0)
		else 1 end )
		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER items_curr_price_update after update ON items
		--when ( NEW.curr_id!=0 and (OLD.curr_id!=NEW.curr_id  or OLD.date_!=NEW.date_ )   ) --update curr or date
		when ( NEW.curr_id!=0   ) --update curr or date
		BEGIN
		update items set
		curr_price=
		(case when NEW.curr_id!=0 then ifnull((select price from currency_price
		where curr_id=NEW.curr_id and
		NEW.o_date
		between f_date and
		ifnull(t_date,NEW.o_date))
		,0)
		else 1 end )

		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER bills_opening_adj_insert after insert ON bills
		when (NEW.tr_type=4 and NEW.adj_id=4 and NEW.is_back=0)
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no,tr_type)
		values(-14,-13,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2,NEW.tr_type
		);
		END
-- @@ --
CREATE TRIGGER bills_opening_adj_update after update ON bills
		when ( NEW.tr_type=4  and NEW.is_back=0 and (select is_active from trigger_flags)=1 )
		BEGIN
		delete from transactions where bill_id=NEW.id;
		insert or ignore into transactions(cus_id,t_cus_id,[in],[out],curr_id,date_,bill_id,remarks,param2,p_ref_no,tr_type)
		select -14,-13,
		1,NEW.amount,NEW.curr_id,strftime('%d-%m-%Y',NEW.date_),NEW.id,
		NEW.remarks
		||'',
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.bill_no2,NEW.tr_type

		where NEW.adj_id=4;
		END
-- @@ --
CREATE TRIGGER items_unit_insert after insert ON items
		--when (NEW.o_cost!=0 and NEW.o_qty!=0)
		BEGIN
		insert or ignore into unit_item(item_id,unit_id,u_val) values(NEW.id,NEW.unit_id,NEW.u_val);
		END
-- @@ --
CREATE TRIGGER items_unit_update after update ON items
		when ( NEW.unit_id!=OLD.unit_id)
		BEGIN
		-- if base unit not existing before
		insert or ignore into unit_item(item_id,unit_id,u_val) select id,unit_id,u_val from items where id=NEW.id
		and not exists(select * from unit_item where item_id=NEW.id and unit_id=NEW.unit_id);
		-- delete old base unit
		delete from unit_item where item_id=NEW.id and unit_id=OLD.unit_id
		and not exists(select * from bill_transactions where item_id=NEW.id and unit_id=OLD.unit_id);
		--and not exists(select * from bill_transactions_h where item_id=NEW.id and unit_id=OLD.unit_id);
		--update old base unit if used
        --update existing u_val in unit_item except base unit
        update unit_item set id=id where item_id=NEW.id and unit_id=OLD.unit_id
        and exists(select * from bill_transactions where item_id=NEW.id and unit_id=OLD.unit_id);
        --and not exists(select * from bill_transactions_h where item_id=NEW.id and unit_id=OLD.unit_id);

        update unit_item
		set u_val=u_val/(select u_val from unit_item where item_id=NEW.id and unit_id=NEW.unit_id)
		where item_id=NEW.id and unit_id!=NEW.unit_id;
		-- update u_val of base unit id
		update unit_item set u_val=1 where item_id=NEW.id and unit_id=NEW.unit_id;
		END
-- @@ --
CREATE TRIGGER prevent_invalid_u_val
		BEFORE update ON unit_item
		FOR EACH ROW
		WHEN ( NEW.u_val!=1 and OLD.unit_id=(select unit_id from items where id=OLD.item_id) )
		BEGIN
		SELECT RAISE(ABORT, 'Invalid Update base Unit') ;
		END
-- @@ --
CREATE TRIGGER prevent_invalid_unit_id
        BEFORE update ON unit_item
        FOR EACH ROW
        WHEN ( NEW.unit_id is null or NEW.item_id is null  )
        BEGIN
        SELECT RAISE(ABORT, 'Invalid Update Unit_Item') ;
        END
-- @@ --
CREATE TRIGGER prevent_delete_base_unit
		BEFORE delete  ON unit_item
		FOR EACH ROW
		WHEN ( OLD.unit_id=(select unit_id from items where id=OLD.item_id) )
		BEGIN
		SELECT RAISE(ABORT, 'Cannot Remove Base Unit') ;
		END
-- @@ --
CREATE TRIGGER raise_error1_tr
		BEFORE INSERT  ON error_exception
		FOR EACH ROW
		WHEN (NEW.id=1 )
		BEGIN
		SELECT RAISE(ABORT, 'ERROR:Closing Year with Items Cost') ;
		END
-- @@ --
CREATE TRIGGER prevent_invalid_tr
		BEFORE INSERT  ON transactions
		FOR EACH ROW
		WHEN (NEW.cus_id is null or not(NEW.out*1>=0) or NEW.cus_id=ifnull(NEW.t_cus_id,0)
		and (select is_active from trigger_flags)=1
		)
		BEGIN
		SELECT RAISE(ABORT, 'ERROR:Invalid Transaction') ;
		END
-- @@ --
CREATE TRIGGER paid_amount_update_bills
		BEFORE update ON bills
		FOR EACH ROW
		WHEN (NEW.paid_amount>NEW.amount and NEW.tr_type in(1,2) )
		BEGIN
		SELECT RAISE(ABORT, 'paid amount Error') ;
		END
-- @@ --
CREATE TRIGGER closing_year_insert_bills2
		BEFORE insert ON bills2
		FOR EACH ROW
		WHEN NEW.tr_type=7 and (date(NEW.date_)<=
		(select ifnull(max(date_),date(NEW.date_,'-1 day')) from closing_year))
		BEGIN
		SELECT RAISE(ABORT, 'CLOSED YEAR') ;
		END
-- @@ --
CREATE TRIGGER closing_year_update_items
		BEFORE update ON items
		FOR EACH ROW
		WHEN (date(OLD.o_date)<=
		(select ifnull(max(date_),date(OLD.o_date,'-1 day')) from closing_year)
		-- to allow change barcode after closing year
		and (OLD.o_date!=NEW.o_date or OLD.o_qty!=NEW.o_qty or OLD.o_cost!=NEW.o_cost
		-- to allow change base unit after closing year--2023-01-23
		--or OLD.unit_id!=NEW.unit_id
		)
		)
		BEGIN
		SELECT RAISE(ABORT, 'CLOSED YEAR') ;
		END
-- @@ --
CREATE TRIGGER prevent_invalid_bill_trans
		BEFORE INSERT  ON bill_transactions
		FOR EACH ROW
		WHEN (not(NEW.qty_pr>0) or NEW.item_type_id is null or not(NEW.cost_price>=0)
        or NEW.bill_id is null
        )
		BEGIN
		SELECT RAISE(ABORT, 'ERROR:Invalid Bill Transaction') ;
		END
-- @@ --
CREATE TRIGGER prevent_invalid_bill_trans_update
		BEFORE UPDATE  ON bill_transactions
		FOR EACH ROW
		WHEN (not(NEW.qty_pr>0) or NEW.item_type_id is null or not(NEW.cost_price>=0)
        or NEW.bill_id is null
        )
		BEGIN
		SELECT RAISE(ABORT, 'ERROR:Invalid Bill Transaction') ;
		END
-- @@ --
CREATE TRIGGER currency_price_insert after insert ON currency_price
		--when (NEW.tr_type=2 and NEW.bill_type=2 and NEW.is_back=0)
		BEGIN
		--update the below plan
		update currency_price set
		t_date=date(strftime('%Y-%m-%d',NEW.f_date),'-1 day')
		where curr_id=NEW.curr_id and t_date is null and id !=NEW.id
		and f_date
		--Less than char
		<
		NEW.f_date;
		--update me to the above plan
		update currency_price set
		t_date=date(strftime('%Y-%m-%d',((select min(f_date) from currency_price where curr_id=NEW.curr_id  and id !=NEW.id))),'-1 day')
		where curr_id=NEW.curr_id and t_date is null and id ==NEW.id
		and f_date
		--Less than char
		<
		(select min(f_date) from currency_price where curr_id=NEW.curr_id and id !=NEW.id);
		--update old date ...step1...t_date is null
		update currency_price set
		t_date=((select min(t_date) from currency_price a where a.curr_id=NEW.curr_id  and NEW.f_date between a.f_date and a.t_date))
		where curr_id=NEW.curr_id and t_date is null and id ==NEW.id
		and  NEW.f_date between f_date and  ifnull(t_date,NEW.f_date)


		;
		--update old date ...step2...t_date is not null
		update currency_price set
		t_date=date(strftime('%Y-%m-%d',NEW.f_date),'-1 day')
		where curr_id=NEW.curr_id and t_date is not null and id !=NEW.id
		and  NEW.f_date between f_date and t_date;

		--update online--0
		update currency set online=0 where id=NEW.curr_id;

		END
-- @@ --
CREATE TRIGGER tax_default_insert after insert ON tax
		when (NEW.is_default ==1)
		BEGIN
		update tax set is_default=0 where id!=NEW.id;
		END
-- @@ --
CREATE TRIGGER tax_default_update after update ON tax
		when (NEW.is_default ==1)
		BEGIN
		update tax set is_default=0 where id!=NEW.id;
		END
-- @@ --
CREATE TRIGGER tax_default_update2 after update ON tax
		when ((select count(*) from tax where is_default=1)==0)
		BEGIN
		update tax set is_default=1 where id= -1 ;
		END
-- @@ --
CREATE TRIGGER tax_used_update
		BEFORE update  ON tax
		FOR EACH ROW
		WHEN ( NEW.per!=OLD.per and (select count(*) from bills where t_val=OLD.per)>0 )
		BEGIN
		SELECT RAISE(ABORT, 'ERROR:Invalid Update TAX') ;
		END
-- @@ --
CREATE TRIGGER tax_used_delete
		BEFORE delete  ON tax
		FOR EACH ROW
		WHEN ((select count(*) from bills where t_val=OLD.per)>0 )
		BEGIN
		SELECT RAISE(ABORT, 'ERROR:Invalid Delete TAX') ;
		END
-- @@ --
CREATE TRIGGER bills_cost2_update after update ON bills
		when (NEW.cost2!=0  and (select is_active from trigger_flags)=1 )
		BEGIN
		update bill_transactions
		set u_cost2=
		((NEW.cost2)*((cost_price+sls_u_price)*u_val*qty_t)/(NEW.amount-NEW.tax_amount-NEW.cost2+NEW.d_amount))
		/(u_val*qty_t)
		where bill_id=NEW.id;
		END
-- @@ --
CREATE TRIGGER bills_cost2_update2 after update ON bills
		when (NEW.cost2=0 and OLD.cost2!=0  and (select is_active from trigger_flags)=1 )
		BEGIN
		update bill_transactions
		set u_cost2=0
		where bill_id=NEW.id;
		END
-- @@ --
CREATE TRIGGER bills_discount_update after update ON bills
		when (NEW.d_amount!=0  and (select is_active from trigger_flags)=1 )
		BEGIN
		update bill_transactions
		set d_amount=
		((NEW.d_amount)*((cost_price+sls_u_price)*u_val*qty_t)/(NEW.amount-NEW.tax_amount-NEW.cost2+NEW.d_amount))
		/(qty_t)
		where bill_id=NEW.id;
		END
-- @@ --
CREATE TRIGGER bills_discount_update2 after update ON bills
		when (NEW.d_amount=0 and OLD.d_amount!=0  and (select is_active from trigger_flags)=1 )
		BEGIN
		update bill_transactions
		set d_amount=0
		where bill_id=NEW.id;
		END
-- @@ --
CREATE TRIGGER bill_transactions_curr_price_insert2 after update ON transactions
		when (NEW.curr_id!=0 and NEW.bill_id>0 and (select curr_mod from bills where id=NEW.bill_id)=1
		and (select is_active from trigger_flags)=1 )
		BEGIN
		update transactions set curr_mod=1
		,curr_price=(select curr_price from bills where id=NEW.bill_id)
		where id=NEW.id and bill_id>0;
		END
-- @@ --
CREATE TRIGGER cus_limit_cr_insert
		BEFORE insert  ON transactions
		FOR EACH ROW
		WHEN (  NEW.cus_id is not null
		and exists(select * from cus_limit where cus_id=NEW.cus_id and curr_id=NEW.curr_id
		) )
		BEGIN
		SELECT RAISE(ABORT, 'تجاوزت سقف الحساب ')
		where ifnull((select balance*1 from cus_curr where
		id=NEW.cus_id and curr_id=NEW.curr_id),0)
		+( NEW.[in]*NEW.[out]*1)
		not between (select db*-1  from cus_limit
		where cus_id=NEW.cus_id and curr_id=NEW.curr_id
		)
		and (select cr  from cus_limit
		where cus_id=NEW.cus_id and curr_id=NEW.curr_id
		)

		;
		END
-- @@ --
CREATE TRIGGER t_cus_limit_cr_insert
		BEFORE insert  ON transactions
		FOR EACH ROW
		WHEN ( NEW.t_cus_id is not null
		and exists(select * from cus_limit where cus_id=NEW.t_cus_id and curr_id=NEW.curr_id
		) )
		BEGIN
		SELECT RAISE(ABORT, 'تجاوزت سقف الحساب# ')
		where ifnull((select balance*1 from cus_curr where
		id=NEW.t_cus_id and curr_id=NEW.curr_id),0)
		+( NEW.[out]*-1)

		not between (select db*-1  from cus_limit
		where cus_id=NEW.t_cus_id and curr_id=NEW.curr_id
		)
		and (select cr  from cus_limit
		where cus_id=NEW.t_cus_id and curr_id=NEW.curr_id
		)
		;
		END
-- @@ --
CREATE TRIGGER cus_limit_cr_update
		BEFORE update  ON transactions
		FOR EACH ROW
		WHEN ( NEW.cus_id is not null
		and exists(select * from cus_limit where cus_id=NEW.cus_id and curr_id=NEW.curr_id
		) )
		BEGIN
		SELECT RAISE(ABORT, 'تجاوزت سقف الحساب ')
		where ifnull((select balance*1 from cus_curr where
		id=NEW.cus_id and curr_id=NEW.curr_id),0)
		-(select ( [in]*[out]*1) from transactions where id=NEW.id )
		+( NEW.[in]*NEW.[out]*1)

		not between (select db*-1  from cus_limit
		where cus_id=NEW.cus_id and curr_id=NEW.curr_id
		)
		and (select cr  from cus_limit
		where cus_id=NEW.cus_id and curr_id=NEW.curr_id
		)
		;
		END
-- @@ --
CREATE TRIGGER t_cus_limit_cr_update
		BEFORE update  ON transactions
		FOR EACH ROW
		WHEN ( NEW.t_cus_id is not null
		and exists(select * from cus_limit where cus_id=NEW.t_cus_id and curr_id=NEW.curr_id
		) )
		BEGIN
		SELECT RAISE(ABORT, 'تجاوزت سقف الحساب# ')
		where ifnull((select balance*1 from cus_curr where
		id=NEW.t_cus_id and curr_id=NEW.curr_id),0)
		-(select ( [out]*-1) from transactions where id=NEW.id )
		+( NEW.[out]*-1)

		not between (select db*-1  from cus_limit
		where cus_id=NEW.t_cus_id and curr_id=NEW.curr_id
		)
		and (select cr  from cus_limit
		where cus_id=NEW.t_cus_id and curr_id=NEW.curr_id
		)
		;
		END
-- @@ --
CREATE TRIGGER prevent_invalid_tr2
		BEFORE INSERT  ON transactions
		FOR EACH ROW
		WHEN (NEW.bill_id=-6 and NEW.c_p_id=0 and (NEW.curr_id=0 or NEW.curr_id=NEW.c_curr_id
		or NEW.c_price=0 or NEW.cus_id=NEW.c_diff_id ))
		BEGIN
		SELECT RAISE(ABORT, 'ERROR:Invalid Transaction Curr') ;
		END
-- @@ --
CREATE TRIGGER transactions_curr_insert after insert ON transactions
		when (NEW.bill_id=-6 and NEW.c_p_id=0 )
		BEGIN
		-- reverse curr
		insert or ignore into transactions(cus_id,[in],[out],curr_id,curr_price,curr_mod,date_,bill_id,remarks,param2
		,p_ref_no,c_p_id,c_curr_id,c_curr_price,c_price,c_diff_id,tr_type,p_date,p_id)
		select NEW.cus_id,
		NEW.[in]*-1,NEW.out*NEW.c_price,NEW.c_curr_id,NEW.c_curr_price,1,NEW.date_,NEW.bill_id,
		NEW.out||
		(select name from currency where id=NEW.curr_id)||' '||'بسعر'||NEW.c_price||' '
		||(select name from currency where id=NEW.c_curr_id)||' '||NEW.remarks
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.p_ref_no,NEW.p_id,NEW.c_curr_id,NEW.c_curr_price,NEW.c_price,NEW.c_diff_id
		,NEW.tr_type,NEW.p_date,NEW.p_id
		where NEW.tr_type in(10,11) ;

		-- diff_id positive rev
		insert or ignore into transactions(cus_id,[in],[out],curr_id,curr_price,curr_mod,date_,bill_id,remarks,param2
		,p_ref_no,c_p_id,c_curr_id,c_curr_price,c_price,c_diff_id,tr_type,p_date,p_id)
		select NEW.c_diff_id
		,(case when NEW.tr_type=10 then -1 else 1 end),
		abs(NEW.out*(NEW.c_price*(case when NEW.c_curr_price=0 then 1 else NEW.c_curr_price end)-NEW.curr_price))
		,0,0,1,NEW.date_,NEW.bill_id,
		NEW.out||
		(select name from currency where id=NEW.curr_id)||' '||'بسعر'||NEW.c_price||' '
		||(select name from currency where id=NEW.c_curr_id)||' '||NEW.remarks
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.p_ref_no,NEW.p_id,NEW.c_curr_id,NEW.c_curr_price,NEW.c_price,NEW.c_diff_id
		,NEW.tr_type,NEW.p_date,NEW.p_id
		where NEW.out*(NEW.c_price*(case when NEW.c_curr_price=0 then 1 else NEW.c_curr_price end)
		-NEW.curr_price)>0 ;

		-- diff_id negative rev
		insert or ignore into transactions(cus_id,[in],[out],curr_id,curr_price,curr_mod,date_,bill_id,remarks,param2
		,p_ref_no,c_p_id,c_curr_id,c_curr_price,c_price,c_diff_id,tr_type,p_date,p_id)
		select NEW.c_diff_id
		,(case when NEW.tr_type=10 then 1 else -1 end),
		abs(NEW.out*(NEW.c_price*(case when NEW.c_curr_price=0 then 1 else NEW.c_curr_price end)-NEW.curr_price))
		,0,0,1,NEW.date_,NEW.bill_id,
		NEW.out||
		(select name from currency where id=NEW.curr_id)||' '||'بسعر'||NEW.c_price||' '
		||(select name from currency where id=NEW.c_curr_id)||' '||NEW.remarks
		,
		strftime('%H:%M', datetime('now','localtime'))
		,NEW.p_ref_no,NEW.p_id,NEW.c_curr_id,NEW.c_curr_price,NEW.c_price,NEW.c_diff_id
		,NEW.tr_type,NEW.p_date,NEW.p_id
		where not(NEW.out*(NEW.c_price*(case when NEW.c_curr_price=0 then 1 else NEW.c_curr_price end)
		-NEW.curr_price)>0) ;
		END
-- @@ --
CREATE TRIGGER user_priv_insert after insert ON users
		WHEN ( (select count(*) from user_priv where user_id=NEW.id  )=0 )
		BEGIN
		insert or ignore into user_priv (screen_id,user_id,new,edit,view,del)
		select id,NEW.id,new,edit,view,del
		from screens where p_id!=0;
		update user_priv set new=0 where new=1 and user_id=NEW.id and NEW.id!=0 and screen_id not   in(-6,-7,9,-8,6,7,-2,-3,16,29,30);
		update user_priv set edit=0 where edit=1 and user_id=NEW.id and NEW.id!=0 and screen_id not in(-6,-7,9,-8,6,7,-2,-3,16,29,30);
		update user_priv set view=0 where view=1 and user_id=NEW.id and NEW.id!=0 and screen_id not in(-6,-7,9,-8,6,7,-2,-3,16,29,30);
		update user_priv set del=0 where del=1 and user_id=NEW.id and NEW.id!=0 ;
		END
-- @@ --
CREATE TRIGGER user_priv_update_edit after update ON user_priv
		WHEN ( ( (NEW.edit=1 and OLD.edit=0) or (NEW.new=1 and OLD.new=0) or (NEW.del=1 and OLD.del=0)
		) and NEW.view=0 and OLD.view=0 )
		BEGIN
		update user_priv set view=1 where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER prevent_invalid_priv
		BEFORE update  ON user_priv
		FOR EACH ROW
		WHEN (( OLD.new=-1 and NEW.new!=-1 ) or ( OLD.edit=-1 and NEW.edit!=-1 )
		or ( OLD.del=-1 and NEW.del!=-1 )
		or ( OLD.view=-1 and NEW.view!=-1 )
		or NEW.user_id=0
		)
		BEGIN
		SELECT RAISE(ABORT, 'Invalid Update Priv') ;
		END
-- @@ --
CREATE TRIGGER prevent_stop_admin
		BEFORE update  ON users
		FOR EACH ROW
		WHEN (NEW.id=0 and NEW.is_active=0 and(select count(*) from users where is_active=1 and id!=0)>0
		)
		BEGIN
		SELECT RAISE(ABORT, 'Invalid Stop Admin') ;
		END
-- @@ --
CREATE TRIGGER prevent_add_user
		BEFORE insert  ON users
		FOR EACH ROW
		WHEN ((select count(*) from users where is_active=1 and id=0)=0
        and NEW.is_active=1
		)
		BEGIN
		SELECT RAISE(ABORT, 'Invalid Add User') ;
		END
-- @@ --
CREATE TRIGGER prevent_update_admin_br_cash
		BEFORE update  ON users
		FOR EACH ROW
		WHEN (NEW.id=0 and (NEW.br_id!=0 or NEW.cash_id!=-3)
		)
		BEGIN
		SELECT RAISE(ABORT, 'Invalid Update Admin') ;
		END
-- @@ --
CREATE TRIGGER prevent_update_user_br_cash
		BEFORE update  ON users
		FOR EACH ROW
		WHEN (
		--(NEW.br_id!=OLD.br_id or NEW.cash_id!=OLD.cash_id) or
		(NEW.id!=0 and NEW.is_active=1 and (select count(*) from users where is_active=1 and id=0)=0)
		)
		BEGIN
		SELECT RAISE(ABORT, 'Invalid Update User') ;
		END
-- @@ --
CREATE TRIGGER bills_user_id_insert after insert ON bills
		when (NEW.user_id!=null  )
		BEGIN
		update transactions set
		user_id=NEW.user_id
		where bill_id=NEW.id;
		END
-- @@ --
CREATE TRIGGER prevent_invalid_bill_trans2
		BEFORE INSERT  ON bill_transactions
		FOR EACH ROW
		WHEN (NEW.item_id is null  )
		BEGIN
		SELECT RAISE(ABORT, 'ERROR:Invalid Bill_Tran2') ;

		END
-- @@ --
CREATE TRIGGER prevent_invalid_bill_trans2_
		BEFORE INSERT  ON bill_transactions2
		FOR EACH ROW
		WHEN (NEW.item_id is null or NEW.bill_id is null )
		BEGIN
		SELECT RAISE(ABORT, 'ERROR:Invalid Bill_Tran2_') ;

		END
-- @@ --
CREATE TRIGGER user_priv_update_view after update ON user_priv
		WHEN (((NEW.edit=1 or NEW.new=1 or NEW.del=1) ) and NEW.view=0 and OLD.view=1 )
		BEGIN
		update user_priv set edit=(case when edit!=-1 then 0 else edit end)
		,new=(case when new!=-1 then 0 else new end)
		,del=(case when del!=-1 then 0 else del end)
		where id=NEW.id;
		END
-- @@ --
CREATE TRIGGER item_price_update after insert ON item_price  BEGIN
 INSERT INTO item_price_history(item_id,curr_id,sls_u_price,date_,remarks,param1,param2,unit_id) VALUES(NEW.item_id,NEW.curr_id,NEW.sls_u_price,NEW.date_,NEW.remarks,NEW.param1,NEW.param2,NEW.unit_id);END