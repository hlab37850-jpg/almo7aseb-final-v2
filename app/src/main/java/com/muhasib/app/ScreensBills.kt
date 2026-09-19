package com.muhasib.app

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

private fun billTitle(tr: Int) = when (tr) { 1 -> "قائمة المبيعات"; 2 -> "قائمة المشتريات"; 8 -> "عروض الأسعار"; 9 -> "طلبات الشراء"; else -> "الفواتير" }

// ------------------------------------------------------------------------------------- bills list
@Composable
fun BillList(n: Nav, tr: Int) {
    val rows = remember(n.tick) { n.db.bills(tr) }
    var search by remember { mutableStateOf(false) }
    var q by remember { mutableStateOf("") }
    var sel by remember { mutableStateOf<BillRow?>(null) }
    var del by remember { mutableStateOf<BillRow?>(null) }
    Page(n, billTitle(tr), actions = { BarIcon("🔍") { search = !search } }, bottom = { BottomBar({ n.push(Route("invoice", tr.toLong())) }, "........") }) {
        if (search) Field(q, { q = it }, "بحث بالاسم أو الرقم")
        TableHeader(listOf("رقم" to 1f, "التاريخ" to 1.5f, "الإسم" to 2f, "المبلغ" to 1.3f))
        val shown = rows.filter { q.isBlank() || it.party.contains(q, true) || it.no.toString() == q }
        if (shown.isEmpty()) Empty() else LazyColumn(Modifier.fillMaxSize()) {
            items(shown) { r ->
                Row(Modifier.fillMaxWidth().clickable { sel = r }.padding(horizontal = 10.dp, vertical = 12.dp)) {
                    Text("${r.no}${if (r.isBack) " ↩" else ""}", Modifier.weight(1f))
                    Text(r.date, Modifier.weight(1.5f), fontSize = 13.sp)
                    Text(r.party, Modifier.weight(2f))
                    Text(money(r.amount), Modifier.weight(1.3f), fontWeight = FontWeight.SemiBold)
                }
                HorizontalDivider()
            }
        }
    }
    sel?.let { r ->
        AlertDialog(
            onDismissRequest = { sel = null }, title = { Text("فاتورة رقم ${r.no}") },
            text = { Column(Modifier.verticalScroll(rememberScrollState())) { n.db.billLines(r.id).forEach { Text(it, Modifier.padding(vertical = 4.dp)) }; Text("الإجمالي: ${money(r.amount)}", fontWeight = FontWeight.Bold) } },
            confirmButton = { TextButton(onClick = { del = r; sel = null }) { Text("حذف", color = Debit) } },
            dismissButton = { TextButton(onClick = { sel = null }) { Text("إغلاق") } }
        )
    }
    del?.let { r ->
        Confirm("حذف الفاتورة", "سيتم حذف الفاتورة رقم ${r.no} وقيودها.", onYes = {
            val e = n.db.deleteBill(r.id); if (e == null) n.bump() else n.toast(e)
        }, onDismiss = { del = null })
    }
}

// ------------------------------------------------------------------------------------- invoice
@Composable
fun InvoiceScreen(n: Nav, tr: Int) {
    val db = n.db
    val items = remember { db.items() }
    val itemOpts = remember { items.map { Opt(it.id, it.name) } }
    val branches = remember { db.branches() }
    val currs = remember { db.currencies() }
    val taxes = remember { db.taxes() }
    val party = remember {
        when (tr) { 1, 8 -> db.accountOpts(0); 2, 9 -> db.accountOpts(1); else -> db.accountOpts(0, 1) }
    }
    val hasCash = tr in listOf(1, 2)
    val salesSide = tr in listOf(1, 8, 11)

    var credit by remember { mutableStateOf(true) }
    var isBack by remember { mutableStateOf(false) }
    var brId by remember { mutableLongStateOf(branches.firstOrNull()?.id ?: 0L) }
    var currId by remember { mutableLongStateOf(0L) }
    var partyId by remember { mutableStateOf<Long?>(null) }
    var date by remember { mutableStateOf(db.today()) }
    var remarks by remember { mutableStateOf("") }
    val lines = remember { mutableStateListOf<Line>() }
    var picked by remember { mutableStateOf<Item?>(null) }
    var unit by remember { mutableStateOf<UnitOpt?>(null) }
    var qty by remember { mutableStateOf("1") }
    var price by remember { mutableStateOf("") }
    var pickKey by remember { mutableIntStateOf(0) }
    var disc by remember { mutableStateOf("") }
    var taxId by remember { mutableLongStateOf(-1L) }
    var fees by remember { mutableStateOf("") }
    var paid by remember { mutableStateOf("") }

    val no = remember(tr, isBack, brId) { db.nextBillNo(tr, isBack, brId) }
    val uopts = remember(picked) { picked?.let { db.unitsOf(it.id) } ?: emptyList() }
    val taxPct = if (hasCash) (taxes.firstOrNull { it.id == taxId }?.per ?: 0.0) else 0.0
    val sub = lines.sumOf { it.qty * it.price }
    val net = sub - (if (tr in listOf(1, 2, 8, 9)) num(disc) else 0.0)
    val tax = net * taxPct / 100.0
    val total = net + tax + (if (hasCash) num(fees) else 0.0)
    val paidV = if (hasCash && credit) num(paid) else if (hasCash) total else 0.0

    fun defaultPrice(it0: Item, u: UnitOpt) = (if (salesSide) it0.price else it0.cost) * u.uVal
    fun addLine() {
        val it0 = picked ?: return n.toast("اختر الصنف")
        val q = num(qty)
        if (q <= 0) return n.toast("الكمية غير صحيحة")
        lines.add(Line(it0, unit ?: UnitOpt(it0.unitId, it0.unit, 1.0), q, num(price)))
        picked = null; unit = null; qty = "1"; price = ""; pickKey++
    }
    fun save() {
        if (lines.isEmpty()) return n.toast("أضف صنفاً واحداً على الأقل")
        if ((!hasCash || credit) && partyId == null) return n.toast(if (salesSide) "اختر العميل" else "اختر المورد")
        val cus = partyId ?: if (tr == 1) -5L else if (tr == 2) -6L else null
        val e = db.saveBill(BillIn(tr, isBack, hasCash && !credit, brId, currId, cus, date, remarks, lines.toList(), if (tr in listOf(1, 2, 8, 9)) num(disc) else 0.0,
            taxId, taxPct, if (hasCash) num(fees) else 0.0, paidV, n.userId))
        if (e == null) { n.toast("تم حفظ الفاتورة"); n.bump(); n.pop() } else n.toast(e)
    }

    val title = when (tr) {
        1 -> if (isBack) "مرتجع مبيعات" else if (credit) "بيع آجل" else "بيع نقدي"
        2 -> if (isBack) "مرتجع مشتريات" else if (credit) "شراء آجل" else "شراء نقدي"
        8 -> "فاتورة عرض سعر"; 9 -> "طلب شراء"; 11 -> "صرف مخزني"; else -> "توريد مخزني"
    }
    Column(Modifier.fillMaxSize()) {
        AppBar(title, n.pop) { BarIcon("💾") { save() } }
        BorderCard {
            Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.fillMaxWidth()) {
                if (hasCash) {
                    Text("آجل"); Spacer(Modifier.width(6.dp)); Switch(credit, { credit = it })
                }
                Drop("المخزن", branches, brId, Modifier.weight(1f)) { brId = it }
                if (hasCash) { Checkbox(isBack, { isBack = it }); Text("مرتجع") }
            }
            Drop("العملة", currs, currId) { currId = it }
            Row(verticalAlignment = Alignment.Bottom) {
                Field(date, { date = it }, "التاريخ", Modifier.weight(1f))
                Spacer(Modifier.width(8.dp))
                Box(Modifier.weight(1.6f)) { SearchField(if (salesSide) "العميل" else "المورد", party, partyId) { partyId = it?.id } }
            }
            Row {
                Field(remarks, { remarks = it }, "ملاحظات", Modifier.weight(1f))
                Spacer(Modifier.width(8.dp))
                Text("رقم#$no", Modifier.padding(top = 18.dp), fontSize = 18.sp, color = Color.Gray)
            }
        }
        BorderCard {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(Modifier.weight(1f)) {
                    key(pickKey) {
                        SearchField("إكتب اسم الصنف", itemOpts, picked?.id) { o ->
                            picked = o?.let { x -> items.first { it.id == x.id } }
                            unit = picked?.let { p -> db.unitsOf(p.id).firstOrNull { it.id == p.unitId } ?: UnitOpt(p.unitId, p.unit, 1.0) }
                            price = picked?.let { p -> unit?.let { u -> defaultPrice(p, u).let { d -> if (d > 0) d.toString() else "" } } } ?: ""
                        }
                    }
                }
                TextButton(onClick = { addLine() }) { Text("⊕", fontSize = 34.sp, color = Blue) }
            }
            if (picked != null) Row(verticalAlignment = Alignment.CenterVertically) {
                Drop("الوحدة", uopts.map { Opt(it.id, it.name) }, unit?.id) { id ->
                    unit = uopts.first { it.id == id }
                    picked?.let { p -> price = defaultPrice(p, unit!!).let { d -> if (d > 0) d.toString() else "" } }
                }
                Field(qty, { qty = it }, "الكمية", Modifier.weight(1f), numKb)
                Spacer(Modifier.width(6.dp))
                Field(price, { price = it }, "السعر", Modifier.weight(1f), numKb)
            }
        }
        TableHeader(listOf("الصنف" to 2.2f, "الكمية" to 1f, "السعر" to 1.2f, "الاجمالي" to 1.3f, "" to 0.4f))
        LazyColumn(Modifier.weight(1f).fillMaxWidth()) {
            itemsIndexed(lines.toList()) { i, l ->
                Row(Modifier.fillMaxWidth().padding(horizontal = 10.dp, vertical = 8.dp), verticalAlignment = Alignment.CenterVertically) {
                    Text(l.item.name, Modifier.weight(2.2f))
                    Text("${money(l.qty)} ${l.unit.name}", Modifier.weight(1f), fontSize = 12.sp)
                    Text(money(l.price), Modifier.weight(1.2f), fontSize = 13.sp)
                    Text(money(l.qty * l.price), Modifier.weight(1.3f), fontWeight = FontWeight.SemiBold, fontSize = 13.sp)
                    Text("✕", Modifier.weight(0.4f).clickable { lines.removeAt(i) }, color = Debit)
                }
                HorizontalDivider()
            }
        }
        HorizontalDivider(thickness = 2.dp, color = Blue)
        Column(Modifier.fillMaxWidth().background(Color(0xFFF3F6F8)).padding(horizontal = 12.dp, vertical = 4.dp)) {
            if (tr in listOf(1, 2, 8, 9)) Row(verticalAlignment = Alignment.CenterVertically) {
                Text("الخصم", Modifier.weight(1f)); Field(disc, { disc = it }, "0", Modifier.weight(1f), numKb)
                Spacer(Modifier.width(10.dp)); Text("الصافي", Modifier.weight(1f)); Text(money(total), fontWeight = FontWeight.Bold, fontSize = 18.sp, modifier = Modifier.weight(1f))
            }
            if (hasCash) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("الضريبة%", Modifier.weight(1f)); Drop("بدون", taxes.map { Opt(it.id, it.name) }, taxId, Modifier.weight(1f)) { taxId = it }
                    Spacer(Modifier.width(10.dp)); Text("رسوم أخرى", Modifier.weight(1f)); Field(fees, { fees = it }, "0", Modifier.weight(1f), numKb)
                }
                if (credit) Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("المبلغ المدفوع", Modifier.weight(1f)); Field(paid, { paid = it }, "0", Modifier.weight(1f), numKb)
                    Spacer(Modifier.width(10.dp)); Text("المبلغ المتبقي", Modifier.weight(1f)); Text(money(total - paidV), fontWeight = FontWeight.Bold, modifier = Modifier.weight(1f), color = Debit)
                }
            }
            if (tr in listOf(11, 21)) Text("الإجمالي: ${money(total)}", fontWeight = FontWeight.Bold, fontSize = 18.sp, modifier = Modifier.padding(8.dp))
        }
    }
}

// ------------------------------------------------------------------------------------- vouchers
@Composable
fun VoucherList(n: Nav) {
    val rows = remember(n.tick) { n.db.vouchers() }
    var sel by remember { mutableStateOf<VRow?>(null) }
    var del by remember { mutableStateOf<VRow?>(null) }
    Page(n, "قبض/صرف", bottom = { BottomBar({ n.push(Route("voucher")) }) }) {
        TableHeader(listOf("رقم السند" to 1f, "التاريخ" to 1.5f, "المجموع" to 1.3f, "البيان" to 1.5f, "نوعه" to 0.8f))
        if (rows.isEmpty()) Empty() else LazyColumn(Modifier.fillMaxSize()) {
            items(rows) { r ->
                Row(Modifier.fillMaxWidth().clickable { sel = r }.padding(horizontal = 10.dp, vertical = 12.dp)) {
                    Text("${r.no}", Modifier.weight(1f)); Text(r.date, Modifier.weight(1.5f), fontSize = 13.sp)
                    Text(money(r.total), Modifier.weight(1.3f), fontWeight = FontWeight.SemiBold); Text(r.note, Modifier.weight(1.5f), fontSize = 13.sp)
                    Text(if (r.tr == 5) "قبض" else "صرف", Modifier.weight(0.8f), color = if (r.tr == 5) Credit else Debit)
                }
                HorizontalDivider()
            }
        }
    }
    sel?.let { r ->
        AlertDialog(
            onDismissRequest = { sel = null }, title = { Text("${if (r.tr == 5) "سند قبض" else "سند صرف"} رقم ${r.no}") },
            text = { Column { n.db.voucherLines(r.tr, r.no).forEach { Text(it, Modifier.padding(vertical = 4.dp)) } } },
            confirmButton = { TextButton(onClick = { del = r; sel = null }) { Text("حذف", color = Debit) } },
            dismissButton = { TextButton(onClick = { sel = null }) { Text("إغلاق") } }
        )
    }
    del?.let { r -> Confirm("حذف السند", "سيتم حذف السند وقيوده.", onYes = { val e = n.db.deleteVoucher(if (r.tr == 5) 5 else 6, r.no); if (e == null) n.bump() else n.toast(e) }, onDismiss = { del = null }) }
}

@Composable
fun VoucherScreen(n: Nav) {
    val db = n.db
    val funds = remember { db.accountOpts(4) }
    val accs = remember { db.accountOpts(0, 1, 5, 6, 7) }
    val currs = remember { db.currencies() }
    var receipt by remember { mutableStateOf(false) }
    var fund by remember { mutableLongStateOf(-3L) }
    var curr by remember { mutableLongStateOf(0L) }
    var date by remember { mutableStateOf(db.today()) }
    var remarks by remember { mutableStateOf("") }
    val lines = remember { mutableStateListOf<VLine>() }
    var acc by remember { mutableStateOf<Opt?>(null) }
    var amt by remember { mutableStateOf("") }
    var note by remember { mutableStateOf("") }
    var rk by remember { mutableIntStateOf(0) }
    val no = remember(receipt) { db.nextVoucherNo(if (receipt) 5 else 6) }

    fun addLine() {
        val a = acc ?: return n.toast("اختر الحساب")
        if (num(amt) <= 0) return n.toast("المبلغ غير صحيح")
        lines.add(VLine(a.id, a.name, num(amt), note)); acc = null; amt = ""; note = ""; rk++
    }
    fun save() {
        if (lines.isEmpty()) return n.toast("أضف قيداً واحداً على الأقل")
        val e = db.saveVoucher(receipt, fund, curr, date, remarks, lines.toList())
        if (e == null) { n.toast("تم حفظ السند"); n.bump(); n.pop() } else n.toast(e)
    }
    Column(Modifier.fillMaxSize()) {
        AppBar(if (receipt) "سند قبض" else "سند صرف", n.pop) { BarIcon("💾") { save() } }
        BorderCard {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(if (receipt) "قبض" else "صرف"); Spacer(Modifier.width(6.dp)); Switch(!receipt, { receipt = !it })
                Drop("العملة", currs, curr, Modifier.weight(1f)) { curr = it }
                Drop("الصندوق", funds, fund) { fund = it }
            }
            Row(verticalAlignment = Alignment.CenterVertically) {
                Field(date, { date = it }, "التاريخ", Modifier.weight(1f)); Spacer(Modifier.width(8.dp))
                Text("رقم#$no", fontSize = 18.sp, color = Color.Gray)
            }
            Field(remarks, { remarks = it }, "البيان")
        }
        BorderCard {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(Modifier.weight(1f)) { key(rk) { SearchField("القيد (الحساب)", accs, acc?.id) { acc = it } } }
                TextButton(onClick = { addLine() }) { Text("⊕", fontSize = 34.sp, color = Blue) }
            }
            Row {
                Field(amt, { amt = it }, "المبلغ", Modifier.weight(1f), numKb); Spacer(Modifier.width(8.dp))
                Field(note, { note = it }, "ملاحظات", Modifier.weight(1.4f))
            }
        }
        TableHeader(listOf("الحساب" to 2f, "المبلغ" to 1.2f, "ملاحظات" to 1.5f, "" to 0.4f))
        LazyColumn(Modifier.weight(1f).fillMaxWidth()) {
            itemsIndexed(lines.toList()) { i, l ->
                Row(Modifier.fillMaxWidth().padding(horizontal = 10.dp, vertical = 10.dp)) {
                    Text(l.name, Modifier.weight(2f)); Text(money(l.amount), Modifier.weight(1.2f)); Text(l.note, Modifier.weight(1.5f), fontSize = 12.sp)
                    Text("✕", Modifier.weight(0.4f).clickable { lines.removeAt(i) }, color = Debit)
                }
                HorizontalDivider()
            }
        }
        HorizontalDivider(thickness = 2.dp, color = Blue)
        Row(Modifier.fillMaxWidth().padding(14.dp)) { Text("المجموع", Modifier.weight(1f), color = Color.Gray); Text(money(lines.sumOf { it.amount }), fontWeight = FontWeight.Bold, fontSize = 18.sp) }
    }
}

// ------------------------------------------------------------------------------------- journal / opening entries
@Composable
fun EntryList(n: Nav, opening: Boolean) {
    val rows = remember(n.tick) { if (opening) n.db.openings() else n.db.journal() }
    var del by remember { mutableStateOf<EntryRow?>(null) }
    Page(n, if (opening) "القيود الإفتتاحية" else "القيود اليومية", bottom = { BottomBar({ n.push(Route(if (opening) "openingnew" else "journalnew")) }) }) {
        if (rows.isEmpty()) Empty() else LazyColumn(Modifier.fillMaxSize()) {
            items(rows) { r ->
                Row(Modifier.fillMaxWidth().clickable { del = r }.padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1f)) { Text(r.text); Text(r.date, fontSize = 12.sp, color = Color.Gray) }
                    Text(money(r.amount), fontWeight = FontWeight.Bold)
                }
                HorizontalDivider()
            }
        }
    }
    del?.let { r -> Confirm("حذف القيد", "هل تريد حذف هذا القيد؟", onYes = { val e = n.db.deleteEntry(r.id); if (e == null) n.bump() else n.toast(e) }, onDismiss = { del = null }) }
}

@Composable
fun JournalNew(n: Nav) {
    val accs = remember { n.db.accountOpts(0, 1, 2, 4, 5, 6, 7) }
    var d by remember { mutableStateOf<Opt?>(null) }
    var c by remember { mutableStateOf<Opt?>(null) }
    var amt by remember { mutableStateOf("") }
    var date by remember { mutableStateOf(n.db.today()) }
    var rem by remember { mutableStateOf("") }
    Page(n, "قيد يومي", actions = {
        BarIcon("💾") {
            if (d == null || c == null) n.toast("اختر الحسابين")
            else if (num(amt) <= 0) n.toast("المبلغ غير صحيح")
            else { val e = n.db.saveJournal(d!!.id, c!!.id, num(amt), date, rem); if (e == null) { n.bump(); n.pop() } else n.toast(e) }
        }
    }) {
        Column(Modifier.padding(12.dp).verticalScroll(rememberScrollState())) {
            Text("من حساب (مدين)", color = Color.Gray); SearchField("اسم الحساب", accs, d?.id) { d = it }
            Spacer(Modifier.height(10.dp))
            Text("إلى حساب (دائن)", color = Color.Gray); SearchField("اسم الحساب", accs, c?.id) { c = it }
            Field(amt, { amt = it }, "المبلغ", kb = numKb); Field(date, { date = it }, "التاريخ"); Field(rem, { rem = it }, "البيان")
        }
    }
}

@Composable
fun OpeningNew(n: Nav) {
    val accs = remember { n.db.accountOpts(0, 1, 4, 7) }
    var a by remember { mutableStateOf<Opt?>(null) }
    var debit by remember { mutableStateOf(true) }
    var amt by remember { mutableStateOf("") }
    var date by remember { mutableStateOf(n.db.today()) }
    Page(n, "قيد إفتتاحي", actions = {
        BarIcon("💾") {
            if (a == null) n.toast("اختر الحساب") else if (num(amt) <= 0) n.toast("المبلغ غير صحيح")
            else { val e = n.db.saveOpening(a!!.id, num(amt), debit, date); if (e == null) { n.bump(); n.pop() } else n.toast(e) }
        }
    }) {
        Column(Modifier.padding(12.dp)) {
            SearchField("اسم الحساب", accs, a?.id) { a = it }
            Row(verticalAlignment = Alignment.CenterVertically) {
                FilterChip(debit, { debit = true }, label = { Text("عليه (مدين)") }); Spacer(Modifier.width(8.dp))
                FilterChip(!debit, { debit = false }, label = { Text("له (دائن)") })
            }
            Field(amt, { amt = it }, "المبلغ", kb = numKb); Field(date, { date = it }, "التاريخ")
        }
    }
}
