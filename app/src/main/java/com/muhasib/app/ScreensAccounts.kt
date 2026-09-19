package com.muhasib.app

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
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

val ACC_TYPES = listOf(0 to "العملاء", 1 to "الموردون", 4 to "النقدية", 5 to "المصروفات", 6 to "الإيرادات", 7 to "أخرى")

@Composable
fun AccountsScreen(n: Nav) {
    var type by remember { mutableStateOf<Int?>(null) }
    var q by remember { mutableStateOf("") }
    val list = remember(n.tick, type) { n.db.accounts(type) }
    Page(n, "الحسابات", bottom = { BottomBar({ n.push(Route("addacc")) }) }) {
        Row(Modifier.horizontalScroll(rememberScrollState()).padding(horizontal = 6.dp)) {
            FilterChip(type == null, { type = null }, label = { Text("الكل") }); Spacer(Modifier.width(6.dp))
            ACC_TYPES.forEach { (t, l) -> FilterChip(type == t, { type = t }, label = { Text(l) }); Spacer(Modifier.width(6.dp)) }
        }
        Field(q, { q = it }, "بحث بالاسم أو الهاتف")
        val shown = list.filter { it.name.contains(q, true) || it.phone.contains(q) }
        if (shown.isEmpty()) Empty() else LazyColumn(Modifier.fillMaxSize()) {
            items(shown) { a ->
                Row(Modifier.fillMaxWidth().clickable { n.push(Route("statement", a.id, a.name)) }.padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1f)) {
                        Text(a.name, fontWeight = FontWeight.SemiBold)
                        if (a.phone.isNotBlank()) Text(a.phone, fontSize = 12.sp, color = Color.Gray)
                    }
                    BalanceText(a.bal)
                }
                HorizontalDivider()
            }
        }
    }
}

@Composable
fun AddAccountScreen(n: Nav) {
    val parents = remember { n.db.parentAccounts() }
    val groups = remember { n.db.groups() }
    var type by remember { mutableIntStateOf(0) }
    var parent by remember { mutableLongStateOf(123L) }
    var group by remember { mutableLongStateOf(0L) }
    var name by remember { mutableStateOf("") }
    var phone by remember { mutableStateOf("") }
    var addr by remember { mutableStateOf("") }
    var vat by remember { mutableStateOf("") }
    Page(n, "إضافة حساب", actions = {
        BarIcon("💾") {
            if (name.isBlank()) n.toast("اكتب اسم الحساب")
            else { val e = n.db.addAccount(name, phone, addr, type, parent, group, vat); if (e == null) { n.toast("تمت الإضافة"); n.bump(); n.pop() } else n.toast(e) }
        }
    }) {
        Column(Modifier.padding(12.dp).verticalScroll(rememberScrollState())) {
            Text("نوع الحساب", color = Color.Gray)
            Drop("النوع", ACC_TYPES.map { Opt(it.first.toLong(), it.second) }, type.toLong(), Modifier.fillMaxWidth()) { type = it.toInt(); parent = n.db.defaultParent(type) }
            Text("الحساب الرئيسي", color = Color.Gray)
            Drop("الحساب الرئيسي", parents, parent, Modifier.fillMaxWidth()) { parent = it }
            Text("التصنيف", color = Color.Gray)
            Drop("التصنيف", groups, group, Modifier.fillMaxWidth()) { group = it }
            Field(name, { name = it }, "اسم الحساب"); Field(phone, { phone = it }, "الهاتف"); Field(addr, { addr = it }, "العنوان"); Field(vat, { vat = it }, "الرقم الضريبي")
        }
    }
}

@Composable
fun StatementBody(n: Nav, id: Long) {
    val currs = remember { n.db.currencies() }
    var curr by remember { mutableLongStateOf(0L) }
    val rows = remember(id, curr, n.tick) { n.db.statement(id, curr) }
    Column(Modifier.fillMaxSize()) {
        Drop("العملة", currs, curr) { curr = it }
        TableHeader(listOf("التاريخ" to 1.3f, "البيان" to 2f, "المبلغ" to 1.2f, "الرصيد" to 1.3f))
        if (rows.isEmpty()) Box(Modifier.weight(1f)) { Empty() } else LazyColumn(Modifier.weight(1f)) {
            items(rows) { r ->
                Row(Modifier.fillMaxWidth().padding(horizontal = 10.dp, vertical = 8.dp)) {
                    Text(r.date, Modifier.weight(1.3f), fontSize = 12.sp); Text(r.note, Modifier.weight(2f), fontSize = 12.sp)
                    Text(money(r.amount), Modifier.weight(1.2f), fontSize = 12.sp, color = if (r.amount > 0) Debit else Credit)
                    Text(money(r.running), Modifier.weight(1.3f), fontSize = 12.sp, fontWeight = FontWeight.SemiBold)
                }
                HorizontalDivider()
            }
        }
        val last = rows.lastOrNull()?.running ?: 0.0
        Text("الرصيد: ${money(kotlin.math.abs(last))} ${if (last > 0) "عليه" else if (last < 0) "له" else ""}",
            Modifier.fillMaxWidth().background(Blue).padding(14.dp), color = Color.White, fontWeight = FontWeight.Bold)
    }
}

@Composable
fun StatementScreen(n: Nav, id: Long, name: String) = Page(n, "كشف حساب: $name") { StatementBody(n, id) }

@Composable
fun CashScreen(n: Nav) {
    val funds = remember { n.db.accountOpts(4) }
    var fund by remember { mutableLongStateOf(-3L) }
    Page(n, "حركة الصندوق") {
        Drop("الصندوق", funds, fund) { fund = it }
        key(fund) { StatementBody(n, fund) }
    }
}

@Composable
fun ChartScreen(n: Nav) {
    val rows = remember(n.tick) { n.db.chart() }
    Page(n, "دليل الحسابات") {
        LazyColumn(Modifier.fillMaxSize()) {
            items(rows) { (level, text, bal) ->
                if (bal == null) Text(text, Modifier.fillMaxWidth().background(Color(0xFFE3EEF6)).padding(start = ((level.toInt() - 1) * 14).dp, top = 8.dp, bottom = 8.dp, end = 10.dp), fontWeight = FontWeight.Bold)
                else Row(Modifier.fillMaxWidth().padding(horizontal = 30.dp, vertical = 6.dp)) {
                    Text(text, Modifier.weight(1f)); Text(money(kotlin.math.abs(bal)) + if (bal > 0) " عليه" else if (bal < 0) " له" else "", color = if (bal > 0) Debit else Credit, fontSize = 13.sp)
                }
            }
        }
    }
}

@Composable
fun CurrencyScreen(n: Nav) {
    var name by remember { mutableStateOf("") }; var code by remember { mutableStateOf("") }; var fils by remember { mutableStateOf("") }
    val list = remember(n.tick) { n.db.currencies() }
    Page(n, "إضافة عملة") {
        Column(Modifier.padding(12.dp)) {
            Field(name, { name = it }, "اسم العملة"); Field(code, { code = it }, "الرمز (USD)"); Field(fils, { fils = it }, "اسم الكسر (سنت)")
            PillButton("إضافة", Modifier.align(Alignment.CenterHorizontally).padding(top = 10.dp)) {
                if (name.isBlank()) n.toast("اكتب اسم العملة") else { val e = n.db.addCurrency(name, code, fils); if (e == null) n.bump() else n.toast(e) }
            }
            list.forEach { Text(it.name, Modifier.padding(vertical = 8.dp)); HorizontalDivider() }
        }
    }
}

@Composable
fun CurrPricesScreen(n: Nav) {
    val currs = remember { n.db.currencies().filter { it.id != 0L } }
    var curr by remember { mutableStateOf<Long?>(null) }
    var date by remember { mutableStateOf(n.db.today()) }
    var price by remember { mutableStateOf("") }
    val list = remember(n.tick) { n.db.currencyPrices() }
    Page(n, "سعر العملات") {
        Column(Modifier.padding(12.dp).verticalScroll(rememberScrollState())) {
            Drop("اختر العملة", currs, curr) { curr = it }
            Field(date, { date = it }, "من تاريخ (yyyy-MM-dd)"); Field(price, { price = it }, "السعر مقابل العملة المحلية", kb = numKb)
            PillButton("حفظ السعر", Modifier.align(Alignment.CenterHorizontally).padding(top = 10.dp)) {
                if (curr == null) n.toast("اختر العملة") else if (num(price) <= 0) n.toast("السعر غير صحيح")
                else { val e = n.db.setCurrencyPrice(curr!!, date, num(price)); if (e == null) n.bump() else n.toast(e) }
            }
            Spacer(Modifier.height(10.dp))
            list.forEach { (c, d, p) -> Text("$c  |  من $d  |  ${money(p)}", Modifier.padding(vertical = 8.dp)); HorizontalDivider() }
        }
    }
}

@Composable
fun LimitsScreen(n: Nav) {
    val accs = remember { n.db.accountOpts(0, 1) }
    val currs = remember { n.db.currencies() }
    var acc by remember { mutableStateOf<Opt?>(null) }
    var curr by remember { mutableLongStateOf(0L) }
    var maxDebit by remember { mutableStateOf("") }; var maxCredit by remember { mutableStateOf("") }
    val list = remember(n.tick) { n.db.limits() }
    Page(n, "سقف الحساب") {
        Column(Modifier.padding(12.dp).verticalScroll(rememberScrollState())) {
            SearchField("اسم الحساب", accs, acc?.id) { acc = it }
            Drop("العملة", currs, curr) { curr = it }
            Field(maxDebit, { maxDebit = it }, "أقصى مديونية (عليه)", kb = numKb); Field(maxCredit, { maxCredit = it }, "أقصى دائنية (له)", kb = numKb)
            PillButton("حفظ السقف", Modifier.align(Alignment.CenterHorizontally).padding(top = 10.dp)) {
                if (acc == null) n.toast("اختر الحساب") else { val e = n.db.setLimit(acc!!.id, curr, num(maxDebit), num(maxCredit)); if (e == null) n.bump() else n.toast(e) }
            }
            Spacer(Modifier.height(10.dp))
            list.forEach { Text(it, Modifier.padding(vertical = 8.dp)); HorizontalDivider() }
        }
    }
}

@Composable
fun BranchScreen(n: Nav) {
    var name by remember { mutableStateOf("") }; var addr by remember { mutableStateOf("") }
    val list = remember(n.tick) { n.db.branches() }
    Page(n, "إضافة مخزن") {
        Column(Modifier.padding(12.dp)) {
            Field(name, { name = it }, "اسم المخزن"); Field(addr, { addr = it }, "العنوان")
            PillButton("إضافة", Modifier.align(Alignment.CenterHorizontally).padding(top = 10.dp)) {
                if (name.isBlank()) n.toast("اكتب اسم المخزن") else { val e = n.db.addBranch(name, addr); if (e == null) n.bump() else n.toast(e) }
            }
            list.forEach { Text(it.name, Modifier.padding(vertical = 8.dp)); HorizontalDivider() }
        }
    }
}
