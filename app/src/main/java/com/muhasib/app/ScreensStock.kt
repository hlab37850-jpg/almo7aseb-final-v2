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

// ------------------------------------------------------------------------------------- items
@Composable
fun ItemsScreen(n: Nav) {
    val list = remember(n.tick) { n.db.items() }
    val units = remember { n.db.units() }
    val types = remember { n.db.itemTypes() }
    var q by remember { mutableStateOf("") }
    var add by remember { mutableStateOf(false) }
    var edit by remember { mutableStateOf<Item?>(null) }
    Page(n, "الأصناف", bottom = { BottomBar({ add = true }) }) {
        Field(q, { q = it }, "بحث بالاسم أو الباركود")
        val shown = list.filter { it.name.contains(q, true) || it.barcode.contains(q) }
        if (shown.isEmpty()) Empty() else LazyColumn(Modifier.fillMaxSize()) {
            items(shown) { i ->
                Row(Modifier.fillMaxWidth().clickable { edit = i }.padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1f)) {
                        Text(i.name, fontWeight = FontWeight.SemiBold)
                        Text("سعر البيع: ${money(i.price)}", fontSize = 12.sp, color = Color.Gray)
                    }
                    Text("${money(i.qty)} ${i.unit}", color = if (i.qty <= 0) Debit else Color.Unspecified)
                }
                HorizontalDivider()
            }
        }
    }
    if (add) {
        var name by remember { mutableStateOf("") }; var bc by remember { mutableStateOf("") }
        var unit by remember { mutableLongStateOf(1L) }; var type by remember { mutableLongStateOf(0L) }
        var price by remember { mutableStateOf("") }; var oq by remember { mutableStateOf("") }; var oc by remember { mutableStateOf("") }
        AlertDialog(
            onDismissRequest = { add = false }, title = { Text("إضافة صنف") },
            text = {
                Column(Modifier.verticalScroll(rememberScrollState())) {
                    Field(name, { name = it }, "اسم الصنف"); Field(bc, { bc = it }, "الباركود (اختياري)")
                    Drop("الوحدة", units, unit) { unit = it }; Drop("مجموعة الصنف", types, type) { type = it }
                    Field(price, { price = it }, "سعر البيع", kb = numKb); Field(oq, { oq = it }, "كمية افتتاحية", kb = numKb); Field(oc, { oc = it }, "تكلفة الوحدة الافتتاحية", kb = numKb)
                }
            },
            confirmButton = {
                TextButton(onClick = {
                    if (name.isBlank()) n.toast("اكتب اسم الصنف")
                    else { val e = n.db.addItem(name, bc, unit, type, num(price), num(oq), num(oc)); if (e == null) { add = false; n.bump() } else n.toast(e) }
                }) { Text("حفظ") }
            },
            dismissButton = { TextButton(onClick = { add = false }) { Text("إلغاء") } }
        )
    }
    edit?.let { it0 ->
        var name by remember { mutableStateOf(it0.name) }; var bc by remember { mutableStateOf(it0.barcode) }; var type by remember { mutableLongStateOf(it0.typeId) }
        AlertDialog(
            onDismissRequest = { edit = null }, title = { Text("تعديل صنف") },
            text = { Column { Field(name, { name = it }, "اسم الصنف"); Field(bc, { bc = it }, "الباركود"); Drop("مجموعة الصنف", types, type) { type = it } } },
            confirmButton = { TextButton(onClick = { val e = n.db.updateItem(it0.id, name, bc, type); if (e == null) { edit = null; n.bump() } else n.toast(e) }) { Text("حفظ") } },
            dismissButton = { TextButton(onClick = { edit = null }) { Text("إلغاء") } }
        )
    }
}

@Composable
fun PricesScreen(n: Nav) {
    val list = remember(n.tick) { n.db.items() }
    var q by remember { mutableStateOf("") }
    var sel by remember { mutableStateOf<Item?>(null) }
    Page(n, "أسعار البيع") {
        Field(q, { q = it }, "بحث")
        LazyColumn(Modifier.fillMaxSize()) {
            items(list.filter { it.name.contains(q, true) }) { i ->
                Row(Modifier.fillMaxWidth().clickable { sel = i }.padding(14.dp)) { Text(i.name, Modifier.weight(1f)); Text(money(i.price), fontWeight = FontWeight.Bold) }
                HorizontalDivider()
            }
        }
    }
    sel?.let { i ->
        var p by remember { mutableStateOf(if (i.price > 0) i.price.toString() else "") }
        AlertDialog(
            onDismissRequest = { sel = null }, title = { Text(i.name) },
            text = { Field(p, { p = it }, "سعر البيع (للوحدة الأساسية: ${i.unit})", kb = numKb) },
            confirmButton = { TextButton(onClick = { val e = n.db.setPrice(i, num(p)); if (e == null) { sel = null; n.bump() } else n.toast(e) }) { Text("حفظ") } },
            dismissButton = { TextButton(onClick = { sel = null }) { Text("إلغاء") } }
        )
    }
}

@Composable
fun ItemUnitsScreen(n: Nav) {
    val items = remember { n.db.items().map { Opt(it.id, it.name) } }
    val units = remember { n.db.units() }
    var item by remember { mutableStateOf<Opt?>(null) }
    var unit by remember { mutableStateOf<Long?>(null) }
    var factor by remember { mutableStateOf("") }
    var r by remember { mutableIntStateOf(0) }
    val list = remember(item, r) { item?.let { n.db.unitsOf(it.id) } ?: emptyList() }
    Page(n, "وحدات الصنف") {
        Column(Modifier.padding(12.dp).verticalScroll(rememberScrollState())) {
            SearchField("اسم الصنف", items, item?.id) { item = it }
            list.forEach { Text("${it.name}  =  ${money(it.uVal)} من الوحدة الأساسية", Modifier.padding(vertical = 8.dp)); HorizontalDivider() }
            if (item != null) {
                Spacer(Modifier.height(10.dp)); Text("إضافة وحدة فرعية", fontWeight = FontWeight.Bold)
                Drop("الوحدة", units, unit) { unit = it }
                Field(factor, { factor = it }, "عدد الوحدات الأساسية في هذه الوحدة (مثال 12 للكرتون)", kb = numKb)
                PillButton("إضافة", Modifier.align(Alignment.CenterHorizontally).padding(top = 8.dp)) {
                    if (unit == null || num(factor) <= 0) n.toast("اختر الوحدة واكتب المعامل")
                    else { val e = n.db.addSubUnit(item!!.id, unit!!, num(factor)); if (e == null) { r++; factor = "" } else n.toast(e) }
                }
            }
        }
    }
}

@Composable
fun ItemMoveScreen(n: Nav) {
    val opts = remember { n.db.items().map { Opt(it.id, it.name) } }
    var item by remember { mutableStateOf<Opt?>(null) }
    val rows = remember(item) { item?.let { n.db.itemMovement(it.id) } ?: emptyList() }
    Page(n, "حركة الأصناف") {
        SearchField("اسم الصنف", opts, item?.id) { item = it }
        TableHeader(listOf("التاريخ" to 1.3f, "البيان" to 2.2f, "وارد" to 0.9f, "صادر" to 0.9f, "الرصيد" to 1f))
        if (rows.isEmpty()) Box(Modifier.weight(1f)) { Empty() } else LazyColumn(Modifier.fillMaxSize()) {
            items(rows) { r ->
                Row(Modifier.fillMaxWidth().padding(horizontal = 10.dp, vertical = 8.dp)) {
                    Text(r.date, Modifier.weight(1.3f), fontSize = 11.sp); Text(r.text, Modifier.weight(2.2f), fontSize = 12.sp)
                    Text(if (r.inQ != 0.0) money(r.inQ) else "", Modifier.weight(0.9f), fontSize = 12.sp, color = Credit)
                    Text(if (r.outQ != 0.0) money(r.outQ) else "", Modifier.weight(0.9f), fontSize = 12.sp, color = Debit)
                    Text(money(r.running), Modifier.weight(1f), fontSize = 12.sp, fontWeight = FontWeight.SemiBold)
                }
                HorizontalDivider()
            }
        }
    }
}

// ------------------------------------------------------------------------------------- transfer (3) / adjustment (4)
@Composable
fun MoveScreen(n: Nav, kind: Int) {
    val db = n.db
    val items = remember { db.items() }
    val opts = remember { items.map { Opt(it.id, it.name) } }
    val branches = remember { db.branches() }
    val adjTypes = remember { listOf(Opt(1, "عجز"), Opt(2, "زيادة"), Opt(3, "تالف")) }
    var from by remember { mutableLongStateOf(branches.firstOrNull()?.id ?: 0L) }
    var to by remember { mutableStateOf<Long?>(null) }
    var adj by remember { mutableLongStateOf(1L) }
    var rem by remember { mutableStateOf("") }
    var picked by remember { mutableStateOf<Item?>(null) }
    var qty by remember { mutableStateOf("1") }
    var cost by remember { mutableStateOf("") }
    var rk by remember { mutableIntStateOf(0) }
    val lines = remember { mutableStateListOf<Line>() }
    fun addLine() {
        val p = picked ?: return n.toast("اختر الصنف")
        if (num(qty) <= 0) return n.toast("الكمية غير صحيحة")
        lines.add(Line(p, UnitOpt(p.unitId, p.unit, 1.0), num(qty), num(cost))); picked = null; qty = "1"; cost = ""; rk++
    }
    fun save() {
        if (lines.isEmpty()) return n.toast("أضف صنفاً واحداً على الأقل")
        if (kind == 3 && (to == null || to == from)) return n.toast("اختر مخزناً مختلفاً للتحويل إليه")
        val e = db.saveMove(kind, from, if (kind == 3) to else null, if (kind == 4) adj.toInt() else 0, lines.toList(), rem, n.userId)
        if (e == null) { n.toast("تم الحفظ"); n.bump(); n.pop() } else n.toast(e)
    }
    Column(Modifier.fillMaxSize()) {
        AppBar(if (kind == 3) "تحويل مخزني" else "تسوية مخزنية", n.pop) { BarIcon("💾") { save() } }
        BorderCard {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(if (kind == 3) "من:" else "المخزن:"); Drop("المخزن", branches, from, Modifier.weight(1f)) { from = it }
                if (kind == 3) { Text("إلى:"); Drop("اختر المخزن", branches, to, Modifier.weight(1f)) { to = it } }
                else Drop("نوع التسوية", adjTypes, adj, Modifier.weight(1f)) { adj = it }
            }
            Field(rem, { rem = it }, "ملاحظات")
        }
        BorderCard {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(Modifier.weight(1f)) {
                    key(rk) { SearchField("إكتب اسم الصنف", opts, picked?.id) { o -> picked = o?.let { x -> items.first { it.id == x.id } }; cost = picked?.cost?.takeIf { it > 0 }?.toString() ?: "" } }
                }
                TextButton(onClick = { addLine() }) { Text("⊕", fontSize = 34.sp, color = Blue) }
            }
            if (picked != null) Row {
                Field(qty, { qty = it }, "الكمية (${picked!!.unit})", Modifier.weight(1f), numKb)
                if (kind == 4) { Spacer(Modifier.width(8.dp)); Field(cost, { cost = it }, "التكلفة", Modifier.weight(1f), numKb) }
            }
        }
        TableHeader(listOf("الصنف" to 2.5f, "الكمية" to 1f, "" to 0.5f))
        LazyColumn(Modifier.weight(1f).fillMaxWidth()) {
            itemsIndexed(lines.toList()) { i, l ->
                Row(Modifier.fillMaxWidth().padding(horizontal = 10.dp, vertical = 10.dp)) {
                    Text(l.item.name, Modifier.weight(2.5f)); Text(money(l.qty), Modifier.weight(1f))
                    Text("✕", Modifier.weight(0.5f).clickable { lines.removeAt(i) }, color = Debit)
                }
                HorizontalDivider()
            }
        }
    }
}

// ------------------------------------------------------------------------------------- stocktake (جرد)
@Composable
fun CountScreen(n: Nav) {
    val db = n.db
    val all = remember { db.items() }
    val branches = remember { db.branches() }
    var br by remember { mutableLongStateOf(branches.firstOrNull()?.id ?: 0L) }
    val stock = remember(br) { db.stockBy(br) }
    val counted = remember(br) { mutableStateMapOf<Long, String>() }
    var q by remember { mutableStateOf("") }
    fun save() {
        val short = ArrayList<Line>(); val extra = ArrayList<Line>()
        for (i in all) {
            val c = counted[i.id]?.takeIf { it.isNotBlank() }?.let { num(it) } ?: continue
            val diff = c - (stock[i.id] ?: 0.0)
            if (diff < 0) short.add(Line(i, UnitOpt(i.unitId, i.unit, 1.0), -diff, i.cost))
            else if (diff > 0) extra.add(Line(i, UnitOpt(i.unitId, i.unit, 1.0), diff, i.cost))
        }
        if (short.isEmpty() && extra.isEmpty()) return n.toast("لا توجد فروقات لتسويتها")
        val e1 = if (short.isNotEmpty()) db.saveMove(4, br, null, 1, short, "تسوية جرد - عجز", n.userId) else null
        val e2 = if (extra.isNotEmpty()) db.saveMove(4, br, null, 2, extra, "تسوية جرد - زيادة", n.userId) else null
        val e = e1 ?: e2
        if (e == null) { n.toast("تم تسجيل فروقات الجرد"); n.bump(); n.pop() } else n.toast(e)
    }
    Column(Modifier.fillMaxSize()) {
        AppBar("جرد مخزني", n.pop) { BarIcon("💾") { save() } }
        Row(verticalAlignment = Alignment.CenterVertically) { Text("  المخزن:"); Drop("المخزن", branches, br) { br = it } }
        Field(q, { q = it }, "بحث")
        Text("أدخل الكمية الفعلية فقط للأصناف التي جرّدتها، وسيُسجَّل الفرق كتسوية.", fontSize = 12.sp, color = Color.Gray, modifier = Modifier.padding(horizontal = 12.dp))
        LazyColumn(Modifier.weight(1f)) {
            items(all.filter { it.name.contains(q, true) }) { i ->
                Row(Modifier.fillMaxWidth().padding(horizontal = 10.dp, vertical = 4.dp), verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1.6f)) { Text(i.name); Text("الدفتري: ${money(stock[i.id] ?: 0.0)} ${i.unit}", fontSize = 12.sp, color = Color.Gray) }
                    Field(counted[i.id] ?: "", { counted[i.id] = it }, "الفعلي", Modifier.weight(1f), numKb)
                }
                HorizontalDivider()
            }
        }
    }
}
