package com.muhasib.app

import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import java.io.File
import java.io.InputStream
import java.io.OutputStream
import java.security.MessageDigest
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

data class Opt(val id: Long, val name: String)
data class Tax(val id: Long, val name: String, val per: Double)
data class UnitOpt(val id: Long, val name: String, val uVal: Double)
data class Acc(val id: Long, val name: String, val phone: String, val bal: Map<String, Double>)
data class Item(
    val id: Long, val name: String, val unitId: Long, val unit: String, val barcode: String,
    val qty: Double, val price: Double, val typeId: Long, val cost: Double
)
data class Line(val item: Item, val unit: UnitOpt, val qty: Double, val price: Double) // price per selected unit
data class BillIn(
    val tr: Int, val isBack: Boolean, val cash: Boolean, val brId: Long, val currId: Long, val cusId: Long?,
    val date: String, val remarks: String, val lines: List<Line>, val discount: Double,
    val taxId: Long, val taxPct: Double, val fees: Double, val paid: Double, val userId: Long
)
data class BillRow(val id: Long, val no: Long, val date: String, val party: String, val amount: Double, val isBack: Boolean)
data class VRow(val no: Long, val tr: Int, val date: String, val total: Double, val note: String)
data class VLine(val accId: Long, val name: String, val amount: Double, val note: String)
data class StRow(val date: String, val note: String, val amount: Double, val running: Double)
data class TbRow(val id: Long, val name: String, val balance: Double)
data class EntryRow(val id: Long, val date: String, val text: String, val amount: Double)
data class MoveRow(val date: String, val text: String, val inQ: Double, val outQ: Double, val running: Double)
data class Priv(val screenId: Long, val name: String, val view: Boolean, val new: Boolean, val edit: Boolean, val del: Boolean)
data class Fin(val rows: List<Triple<String, Double, Int>>) // label, value, style (0 normal, 1 header, 2 total)

/**
 * The accounting engine lives in the database itself (triggers + views) exactly as in the schema
 * exported from inv.db: inserting a bill / voucher / entry generates the ledger rows.
 */
class Db(private val ctx: Context) : SQLiteOpenHelper(ctx, DB_NAME, null, 1) {

    override fun onCreate(db: SQLiteDatabase) { run(db, "schema.sql"); run(db, "seed.sql") }
    override fun onUpgrade(db: SQLiteDatabase, o: Int, n: Int) {}
    private fun run(db: SQLiteDatabase, file: String) {
        ctx.assets.open(file).bufferedReader(Charsets.UTF_8).use { it.readText() }
            .split(SEP).filter { it.isNotBlank() }.forEach { db.execSQL(it) }
    }

    // ------------------------------------------------------------------ helpers
    fun today(): String = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
    private fun now() = SimpleDateFormat("HH:mm", Locale.US).format(Date())
    private fun ledger(d: String): String { // yyyy-MM-dd -> dd-MM-yyyy
        val p = d.trim().split("-")
        return if (p.size == 3 && p[0].length == 4) "${p[2].padStart(2, '0')}-${p[1].padStart(2, '0')}-${p[0]}" else d
    }

    private fun <T> q(sql: String, vararg a: Any?, f: (Cursor) -> T): List<T> {
        val out = ArrayList<T>()
        readableDatabase.rawQuery(sql, Array(a.size) { a[it].toString() }).use { c -> while (c.moveToNext()) out.add(f(c)) }
        return out
    }
    private fun one(sql: String, vararg a: Any?): String? = q(sql, *a) { it.getString(0) }.firstOrNull()
    private fun opts(sql: String, vararg a: Any?) = q(sql, *a) { Opt(it.getLong(0), it.getString(1) ?: "") }
    private fun tx(block: SQLiteDatabase.() -> Unit): String? = try {
        val d = writableDatabase
        d.beginTransaction()
        try { d.block(); d.setTransactionSuccessful() } finally { d.endTransaction() }
        null
    } catch (e: Exception) { (e.message ?: "خطأ").substringBefore(" (code").trim() }
    private fun SQLiteDatabase.x(sql: String, vararg a: Any?) = execSQL(sql, arrayOf(*a))
    private fun SQLiteDatabase.n(sql: String, vararg a: Any?): Long =
        rawQuery(sql, Array(a.size) { a[it].toString() }).use { it.moveToFirst(); it.getLong(0) }
    private fun sha(s: String) = MessageDigest.getInstance("SHA-256").digest(s.toByteArray()).joinToString("") { "%02x".format(it) }

    // ------------------------------------------------------------------ settings & lookups
    fun conf(id: Int): String = one("select value_ from sys_conf where id=?", id) ?: ""
    fun setConf(id: Int, desc: String, v: String): String? = tx { x("insert or replace into sys_conf(id,desc_,value_) values(?,?,?)", id, desc, v) }
    fun branches() = opts("select id,name from branches where IS_ACTIVE=1 order by id")
    fun addBranch(name: String, addr: String) = tx { x("insert into branches(name,ADDRESS,date_) values(?,?,?)", name.trim(), addr.trim(), today()) }
    fun currencies() = opts("select id,name from currency order by id")
    fun addCurrency(name: String, code: String, fils: String) =
        tx { x("insert into currency(name,curr_type,fils_name,code_name) values(?,1,?,?)", name.trim(), fils.trim(), code.trim()) }
    fun currencyPrices() = q("select c.name,p.f_date,p.price from currency_price p join currency c on c.id=p.curr_id order by p.curr_id,p.f_date desc") {
        Triple(it.getString(0), it.getString(1), it.getDouble(2))
    }
    fun setCurrencyPrice(currId: Long, date: String, price: Double) = tx {
        val e = one("select id from currency_price where curr_id=? and f_date=?", currId, date)
        if (e != null) x("update currency_price set price=? where id=?", price, e.toLong())
        else x("insert into currency_price(curr_id,f_date,price) values(?,?,?)", currId, date, price)
    }
    fun limits() = q("select c.name,u.name,l.cr,l.db from cus_limit l join customers c on c.id=l.cus_id join currency u on u.id=l.curr_id order by c.name") {
        "${it.getString(0)} (${it.getString(1)}): عليه ≤ ${money(it.getDouble(2))} | له ≤ ${money(it.getDouble(3))}"
    }
    fun setLimit(cusId: Long, currId: Long, maxDebit: Double, maxCredit: Double) = tx {
        x("delete from cus_limit where cus_id=? and curr_id=?", cusId, currId)
        x("insert into cus_limit(cus_id,curr_id,cr,db) values(?,?,?,?)", cusId, currId, maxDebit, maxCredit)
    }
    fun taxes() = q("select id,name,per from tax where is_active=1 order by id") { Tax(it.getLong(0), it.getString(1), it.getDouble(2)) }
    fun addTax(name: String, per: Double) = tx { x("insert into tax(name,tax_type_id,per,is_active,is_default) values(?,1,?,1,0)", name.trim(), per) }
    fun groups() = opts("select id,name from groups order by id")
    fun addGroup(n: String) = tx { x("insert into groups(name) values(?)", n.trim()) }
    fun itemTypes() = opts("select id,name from item_type order by id")
    fun addItemType(n: String) = tx { x("insert into item_type(name) values(?)", n.trim()) }
    fun units() = opts("select id,name from units order by id")
    fun addUnit(n: String, code: String) = tx { x("insert into units(name,code) values(?,?)", n.trim(), code.trim().ifBlank { n.trim() }) }
    fun unitsOf(itemId: Long) = q(
        "select ui.unit_id,u.name,ui.u_val from unit_item ui join units u on u.id=ui.unit_id where ui.item_id=? order by ui.u_val", itemId
    ) { UnitOpt(it.getLong(0), it.getString(1), it.getDouble(2)) }
    fun addSubUnit(itemId: Long, unitId: Long, uVal: Double) = tx { x("insert into unit_item(item_id,unit_id,u_val) values(?,?,?)", itemId, unitId, uVal) }

    // ------------------------------------------------------------------ accounts
    fun accounts(type: Int?): List<Acc> {
        val out = LinkedHashMap<Long, Acc>()
        val where = if (type == null) "c.id > 0" else "c.id > 0 and c.cus_type_id = $type"
        q("""select c.id, c.name, ifnull(c.gsm,''), ifnull(v.curr,''), ifnull(v.balance,0)
             from customers c left join cus_curr v on v.id = c.id where $where order by c.name""") { c ->
            val id = c.getLong(0)
            val m = (out[id]?.bal ?: emptyMap()).toMutableMap()
            val b = c.getDouble(4)
            if (b != 0.0) m[c.getString(3)] = b
            out[id] = Acc(id, c.getString(1), c.getString(2), m)
        }
        return out.values.toList()
    }
    fun accountOpts(vararg types: Int) = types.flatMap { t -> accounts(t).map { Opt(it.id, it.name) } }
    fun parentAccounts() = opts("select id,name from account_tree where id>=100 or id in (22,42) order by id")
    fun addAccount(name: String, phone: String, address: String, type: Int, parent: Long, groupId: Long, vat: String) = tx {
        x("insert into customers(name,gsm,ADDRESS,g_id,cus_type_id,acc_p_id,vat_no) values(?,?,?,?,?,?,?)",
            name.trim(), phone.trim(), address.trim(), groupId, type, parent, vat.trim())
    }
    fun defaultParent(type: Int): Long = when (type) { 0 -> 123; 1 -> 221; 4 -> 121; 5 -> 321; 6 -> 42; else -> 124 }

    fun statement(id: Long, currId: Long): List<StRow> {
        var run = 0.0
        return q(
            """select date_, ifnull(remarks,''), case when t_cus_id = ? then -1*[out] else [in]*[out] end
               from transactions where (cus_id = ? or t_cus_id = ?) and curr_id = ?
               order by substr(date_,7,4)||substr(date_,4,2)||substr(date_,1,2), id""", id, id, id, currId
        ) { c -> val a = c.getDouble(2); run += a; StRow(c.getString(0), c.getString(1), a, run) }
    }

    /** chart of accounts: (level-indented name, balance or null for headers) */
    fun chart(): List<Triple<String, String, Double?>> {
        val bal = HashMap<Long, Double>()
        q("select id,balance from cus_curr where curr_id=0") { bal[it.getLong(0)] = it.getDouble(1) }
        val out = ArrayList<Triple<String, String, Double?>>()
        for ((id, name) in opts("select id,name from account_tree order by id").map { it.id to it.name }) {
            out.add(Triple(id.toString().length.toString(), "$id  $name", null))
            q("select id,name from customers where acc_p_id=? order by name", id) { out.add(Triple("9", it.getString(1), bal[it.getLong(0)] ?: 0.0)) }
        }
        return out
    }

    // ------------------------------------------------------------------ items & stock
    fun items(): List<Item> {
        val stock = HashMap<Long, Double>()
        q("select item_id, sum(i_q)-sum(o_q) from items_cost_calc_v group by item_id") { stock[it.getLong(0)] = it.getDouble(1) }
        val price = HashMap<Long, Double>()
        q("select item_id, sls_u_price from item_price where curr_id = 0 order by date_, rowid") { price[it.getLong(0)] = it.getDouble(1) }
        return q(
            """select i.id, i.name, i.unit_id, ifnull(u.name,''), ifnull(i.barcode,''), i.item_type_id,
                 ifnull((select bt.cost_price from bill_transactions bt join bills b on b.id=bt.bill_id
                         where bt.item_id=i.id and b.tr_type in (2,21) and b.is_back=0
                         order by b.date_ desc, b.id desc limit 1), ifnull(i.o_cost,0))
               from items i left join units u on u.id = i.unit_id where i.IS_ACTIVE = 1 order by i.name"""
        ) { c ->
            val id = c.getLong(0)
            Item(id, c.getString(1), c.getLong(2), c.getString(3), c.getString(4), stock[id] ?: 0.0, price[id] ?: 0.0, c.getLong(5), c.getDouble(6))
        }
    }
    fun stockBy(brId: Long): Map<Long, Double> {
        val m = HashMap<Long, Double>()
        q("select item_id, sum(i_q)-sum(o_q) from items_cost_calc_v where br_id=? group by item_id", brId) { m[it.getLong(0)] = it.getDouble(1) }
        return m
    }
    fun addItem(name: String, barcode: String, unitId: Long, typeId: Long, price: Double, openQty: Double, openCost: Double) = tx {
        x("insert into items(name,item_type_id,unit_id,u_val,curr_id,barcode,o_qty,o_cost,o_date) values(?,?,?,1,0,nullif(?,''),?,?,?)",
            name.trim(), typeId, unitId, barcode.trim(), openQty, openCost, today())
        val id = n("select max(id) from items")
        if (price > 0) x("insert into item_price(item_id,curr_id,unit_id,sls_u_price) values(?,0,?,?)", id, unitId, price)
    }
    fun updateItem(id: Long, name: String, barcode: String, typeId: Long) =
        tx { x("update items set name=?, barcode=nullif(?,''), item_type_id=? where id=?", name.trim(), barcode.trim(), typeId, id) }
    fun setPrice(item: Item, price: Double) =
        tx { x("insert into item_price(item_id,curr_id,unit_id,sls_u_price) values(?,0,?,?)", item.id, item.unitId, price) }
    fun itemMovement(itemId: Long): List<MoveRow> {
        var run = 0.0
        return q(
            """select v.date_, ifnull(t.name,''), v.is_back, ifnull(v.name,''), v.i_q, v.o_q
               from items_cost_calc_v v left join tran_type t on t.id=v.tr_type
               where v.item_id=? order by v.date_, v.id2""", itemId
        ) { c ->
            val i = c.getDouble(4); val o = c.getDouble(5); run += i - o
            MoveRow(c.getString(0), (c.getString(1) + (if (c.getInt(2) == 1) " (مرتجع)" else "") + " - " + c.getString(3)).trim(), i, o, run)
        }
    }

    // ------------------------------------------------------------------ bills
    fun nextBillNo(tr: Int, isBack: Boolean, brId: Long, adj: Int = 0): Long =
        (one("select ifnull(max(bill_no2),0)+1 from bills where tr_type=? and is_back=? and br_id=? and adj_id=?", tr, if (isBack) 1 else 0, brId, adj) ?: "1").toLong()

    fun saveBill(b: BillIn): String? = tx {
        val sub = b.lines.sumOf { it.qty * it.price }
        val net = sub - b.discount
        val tax = net * b.taxPct / 100.0
        val total = net + tax + b.fees
        if (b.tr in listOf(1, 2) && !b.cash && b.paid > total + 0.0001) throw IllegalArgumentException("المبلغ المدفوع أكبر من قيمة الفاتورة")
        val billType = when (b.tr) { 1, 2 -> if (b.cash) 1 else 2; 11, 21 -> 2; else -> 0 }
        val no = nextBillNo(b.tr, b.isBack, b.brId)
        x("""insert into bills(date_,time_,tr_type,bill_type,is_back,br_id,cus_id,amount,d_amount,tax_id,t_val,tax_amount,cost2,
             paid_amount,cash_id,curr_id,bill_no2,remarks,user_id) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,-3,?,?,?,?)""",
            b.date, now(), b.tr, billType, if (b.isBack) 1 else 0, b.brId, b.cusId, total, b.discount, b.taxId, b.taxPct, tax, b.fees,
            if (b.cash) 0.0 else b.paid, b.currId, no, b.remarks, b.userId)
        val bid = n("select max(id) from bills")
        for (l in b.lines) {
            val basePrice = l.price / l.unit.uVal
            x("""insert into bill_transactions(bill_id,item_id,item_type_id,curr_id,qty,qty_pr,qty_t,cost_price,sls_u_price,d_amount,unit_id,u_val,base_unit)
                 values(?,?,?,?,?,?,?,?,?,0,?,?,?)""",
                bid, l.item.id, l.item.typeId, b.currId, l.qty, l.qty, l.qty.toString(),
                if (b.tr in listOf(2, 9, 21)) basePrice else 0.0, if (b.tr in listOf(1, 8, 11)) basePrice else 0.0,
                l.unit.id, l.unit.uVal, l.item.unitId)
        }
        if (b.discount != 0.0 || b.fees != 0.0) x("update bills set remarks=remarks where id=?", bid) // fires discount/fee distribution
    }

    fun saveMove(tr: Int, brId: Long, toBr: Long?, adj: Int, lines: List<Line>, remarks: String, userId: Long): String? = tx {
        val no = nextBillNo(tr, false, brId, adj)
        x("""insert into bills(date_,time_,tr_type,bill_type,is_back,br_id,to_br_id,adj_id,amount,cash_id,curr_id,bill_no2,remarks,user_id)
             values(?,?,?,0,0,?,?,?,0,-3,0,?,?,?)""", today(), now(), tr, brId, toBr, adj, no, remarks, userId)
        val bid = n("select max(id) from bills")
        for (l in lines) x(
            """insert into bill_transactions(bill_id,item_id,item_type_id,curr_id,qty,qty_pr,qty_t,cost_price,sls_u_price,d_amount,unit_id,u_val,base_unit)
               values(?,?,?,0,?,?,?,?,0,0,?,?,?)""",
            bid, l.item.id, l.item.typeId, l.qty, l.qty, l.qty.toString(), l.price / l.unit.uVal, l.unit.id, l.unit.uVal, l.item.unitId)
    }

    fun bills(tr: Int): List<BillRow> = q(
        """select a.id, a.bill_no2, a.date_, ifnull(c.name,''), a.amount, a.is_back from bills a left join customers c on c.id=a.cus_id
           where a.tr_type=? order by a.date_ desc, a.id desc limit 500""", tr
    ) { BillRow(it.getLong(0), it.getLong(1), it.getString(2), it.getString(3), it.getDouble(4), it.getInt(5) == 1) }

    fun billLines(id: Long): List<String> = q(
        """select i.name, t.qty_pr, ifnull(u.name,''), t.u_val*(t.cost_price+t.sls_u_price)
           from bill_transactions t join items i on i.id=t.item_id left join units u on u.id=t.unit_id where t.bill_id=?""", id
    ) { "${it.getString(0)}  —  ${money(it.getDouble(1))} ${it.getString(2)} × ${money(it.getDouble(3))}" }

    fun deleteBill(id: Long): String? = tx { x("delete from bill_transactions where bill_id=?", id); x("delete from bills where id=?", id) }

    // ------------------------------------------------------------------ vouchers, journal, opening entries
    fun nextVoucherNo(tr: Int): Long = (one("select ifnull(max(p_id),0)+1 from transactions where bill_id=0 and tr_type=?", tr) ?: "1").toLong()

    fun saveVoucher(receipt: Boolean, fundId: Long, currId: Long, date: String, remarks: String, lines: List<VLine>): String? = tx {
        val tr = if (receipt) 5 else 6
        val no = nextVoucherNo(tr)
        for (l in lines) x(
            """insert into transactions(cus_id,[in],[out],date_,remarks,p_remarks,curr_id,cash_id,tr_type,bill_id,p_id,param2)
               values(?,?,?,?,?,?,?,?,?,0,?,?)""",
            l.accId, if (receipt) "-1" else "1", l.amount, ledger(date), l.note, remarks, currId, fundId, tr, no, now())
    }
    fun vouchers(): List<VRow> = q(
        """select p_id, tr_type, min(date_), sum([out]), ifnull(min(p_remarks),'') from transactions
           where bill_id=0 and tr_type in (5,6) group by tr_type, p_id
           order by substr(min(date_),7,4)||substr(min(date_),4,2)||substr(min(date_),1,2) desc, p_id desc limit 500"""
    ) { VRow(it.getLong(0), it.getInt(1), it.getString(2), it.getDouble(3), it.getString(4)) }
    fun voucherLines(tr: Int, no: Long): List<String> = q(
        """select c.name, t.[out], ifnull(t.remarks,'') from transactions t
           join customers c on c.id = case when t.tr_type=5 then t.t_cus_id else t.cus_id end
           where t.bill_id=0 and t.tr_type=? and t.p_id=?""", tr, no
    ) { "${it.getString(0)}  —  ${money(it.getDouble(1))}  ${it.getString(2)}" }
    fun deleteVoucher(tr: Int, no: Long) = tx { x("delete from transactions where bill_id=0 and tr_type=? and p_id=?", tr, no) }

    fun saveJournal(debit: Long, credit: Long, amount: Double, date: String, remarks: String) = tx {
        x("""insert into transactions(cus_id,t_cus_id,[in],[out],date_,remarks,curr_id,tr_type,bill_id,p_id,param2)
             values(?,?,'1',?,?,?,0,-2,0,?,?)""",
            debit, credit, amount, ledger(date), remarks, n("select ifnull(max(p_id),0)+1 from transactions where tr_type=-2"), now())
    }
    fun journal(): List<EntryRow> = q(
        """select t.id, t.date_, d.name||'  ←  '||c.name||'  '||ifnull(t.remarks,''), t.[out] from transactions t
           join customers d on d.id=t.cus_id join customers c on c.id=t.t_cus_id where t.tr_type=-2 and t.bill_id=0 order by t.id desc limit 300"""
    ) { EntryRow(it.getLong(0), it.getString(1), it.getString(2), it.getDouble(3)) }
    fun saveOpening(accId: Long, amount: Double, debit: Boolean, date: String) = tx {
        x("""insert into transactions(cus_id,[in],[out],date_,remarks,curr_id,tr_type,bill_id,fund_id,param2)
             values(?,?,?,?,'قيد إفتتاحي',0,-1,-1,-13,?)""", accId, if (debit) "1" else "-1", amount, ledger(date), now())
    }
    fun openings(): List<EntryRow> = q(
        """select t.id, t.date_, case when t.cus_id=-13 then c2.name||'  (له)' else c1.name||'  (عليه)' end, t.[out]
           from transactions t left join customers c1 on c1.id=t.cus_id left join customers c2 on c2.id=t.t_cus_id
           where t.tr_type=-1 and t.bill_id=-1 order by t.id desc limit 300"""
    ) { EntryRow(it.getLong(0), it.getString(1), it.getString(2), it.getDouble(3)) }
    fun deleteEntry(id: Long) = tx { x("delete from transactions where id=?", id) }

    // ------------------------------------------------------------------ reports
    fun trialBalance() = q("select id,name,balance from cus_curr where curr_id=0 and balance!=0 order by id") { TbRow(it.getLong(0), it.getString(1), it.getDouble(2)) }
    private fun groupBalances(): Map<Int, Double> {
        val m = HashMap<Int, Double>()
        q("select f_id, sum(balance) from cus_curr where curr_id=0 group by f_id") { m[it.getInt(0)] = it.getDouble(1) }
        return m
    }
    private fun closingStock() = items().sumOf { it.qty * it.cost }

    fun incomeStatement(): Fin {
        val g = groupBalances(); fun v(k: Int) = g[k] ?: 0.0
        val closing = closingStock()
        val netSales = -v(411) - v(312) - v(313)
        val cogs = v(125) + v(311) + v(412) + v(413) + v(314) + v(315) - closing
        val gross = netSales - cogs
        val opex = v(321) + v(322) + v(323)
        val net = gross - opex - v(42)
        return Fin(listOf(
            Triple("المبيعات", -v(411), 0), Triple("مردودات المبيعات", -v(312), 0), Triple("الخصم المسموح به", -v(313), 0),
            Triple("صافي المبيعات", netSales, 2),
            Triple("بضاعة أول المدة", v(125), 0), Triple("المشتريات", v(311), 0),
            Triple("مردودات المشتريات", v(412), 0), Triple("الخصم المكتسب", v(413), 0), Triple("تسوية المخزون والتالف", v(314) + v(315), 0),
            Triple("بضاعة آخر المدة (تقديرية بآخر سعر شراء)", -closing, 0),
            Triple("تكلفة المبيعات", cogs, 2), Triple("مجمل الربح", gross, 2),
            Triple("المصاريف التشغيلية والإدارية", -opex, 0), Triple("إيرادات أخرى", -v(42), 0),
            Triple("صافي الربح / الخسارة", net, 2)
        ))
    }

    fun balanceSheet(): Fin {
        val g = groupBalances(); val closing = closingStock()
        val names = HashMap<Int, String>(); opts("select id,name from account_tree").forEach { names[it.id.toInt()] = it.name.trim() }
        val profit = incomeStatement().rows.last().second
        val rows = ArrayList<Triple<String, Double, Int>>()
        rows.add(Triple("الأصول", 0.0, 1))
        var assets = 0.0
        for ((k, vv) in g.toSortedMap()) if (k.toString().startsWith("1") && k != 125 && vv != 0.0) { rows.add(Triple(names[k] ?: "$k", vv, 0)); assets += vv }
        rows.add(Triple("البضاعة (تقديرية)", closing, 0)); assets += closing
        rows.add(Triple("إجمالي الأصول", assets, 2))
        rows.add(Triple("الالتزامات", 0.0, 1))
        var liab = 0.0
        for ((k, vv) in g.toSortedMap()) if (k.toString().startsWith("2") && !k.toString().startsWith("21") && vv != 0.0) { rows.add(Triple(names[k] ?: "$k", -vv, 0)); liab -= vv }
        rows.add(Triple("إجمالي الالتزامات", liab, 2))
        rows.add(Triple("حقوق الملكية", 0.0, 1))
        var eq = profit
        for ((k, vv) in g.toSortedMap()) if (k.toString().startsWith("21") && vv != 0.0) { rows.add(Triple(names[k] ?: "$k", -vv, 0)); eq -= vv }
        rows.add(Triple("صافي ربح الفترة", profit, 0))
        rows.add(Triple("إجمالي حقوق الملكية", eq, 2))
        rows.add(Triple("إجمالي الالتزامات وحقوق الملكية", liab + eq, 2))
        return Fin(rows)
    }

    // ------------------------------------------------------------------ users & permissions
    fun adminActive() = one("select is_active from users where id=0") == "1"
    fun activateAdmin(pwd: String) = tx { x("update users set is_active=1, pwd=? where id=0", sha(pwd)) }
    fun users() = opts("select id,name from users where is_active=1 order by id")
    fun addUser(userName: String, name: String, pwd: String) =
        tx { x("insert into users(user_name,name,pwd,is_active,cash_id,br_id) values(?,?,?,1,-3,0)", userName.trim(), name.trim(), sha(pwd)) }
    fun login(userName: String, pwd: String): Opt? =
        opts("select id,name from users where is_active=1 and user_name=? and (pwd=? or pwd=?)", userName.trim(), sha(pwd), pwd).firstOrNull()
    fun userName(id: Long) = one("select name from users where id=?", id) ?: ""
    fun privs(userId: Long) = q(
        """select p.screen_id, s.name, p.view, p.[new], p.edit, p.del from user_priv p join screens s on s.id=p.screen_id
           where p.user_id=? and s.id not in (1,2,3,4,5) order by s.id""", userId
    ) { Priv(it.getLong(0), it.getString(1).trim(), it.getInt(2) == 1, it.getInt(3) == 1, it.getInt(4) == 1, it.getInt(5) == 1) }
    fun setPriv(userId: Long, screenId: Long, col: String, v: Boolean): String? {
        require(col in listOf("view", "new", "edit", "del"))
        return tx { x("update user_priv set [$col]=? where user_id=? and screen_id=?", if (v) 1 else 0, userId, screenId) }
    }
    fun canView(userId: Long, screenId: Int): Boolean =
        userId == 0L || (one("select view from user_priv where user_id=? and screen_id=?", userId, screenId) ?: "1") == "1"

    // ------------------------------------------------------------------ backup / restore (same file format as inv.db)
    private fun path(): File = ctx.getDatabasePath(DB_NAME)
    fun exportTo(out: OutputStream) { close(); path().inputStream().use { it.copyTo(out) } }
    fun importFrom(inp: InputStream) {
        close()
        File(path().path + "-wal").delete(); File(path().path + "-shm").delete()
        path().outputStream().use { inp.copyTo(it) }
    }

    companion object {
        const val DB_NAME = "inv.db"
        private const val SEP = "\n-- @@ --\n"
    }
}
