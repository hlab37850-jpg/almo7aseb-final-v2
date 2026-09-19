package com.muhasib.app

import androidx.compose.foundation.clickable
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
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun PersonalScreen(n: Nav) {
    val keys = listOf(201 to "اسم المنشأة", 202 to "العنوان", 203 to "أرقام التواصل", 204 to "الرقم الضريبي", 205 to "السجل التجاري")
    val vals = remember { mutableStateListOf(*keys.map { n.db.conf(it.first) }.toTypedArray()) }
    Page(n, "البيانات الشخصية", actions = {
        BarIcon("💾") {
            var err: String? = null
            keys.forEachIndexed { i, k -> err = err ?: n.db.setConf(k.first, k.second, vals[i]) }
            if (err == null) { n.toast("تم الحفظ"); n.bump(); n.pop() } else n.toast(err!!)
        }
    }) {
        Column(Modifier.padding(12.dp).verticalScroll(rememberScrollState())) {
            keys.forEachIndexed { i, k -> Field(vals[i], { vals[i] = it }, k.second) }
        }
    }
}

@Composable
fun UsersScreen(n: Nav) {
    var r by remember { mutableIntStateOf(0) }
    val active = remember(r) { n.db.adminActive() }
    val users = remember(r) { n.db.users() }
    var pwd by remember { mutableStateOf("") }
    var uname by remember { mutableStateOf("") }; var name by remember { mutableStateOf("") }; var upwd by remember { mutableStateOf("") }
    Page(n, "المستخدمين والصلاحيات") {
        Column(Modifier.padding(12.dp).verticalScroll(rememberScrollState())) {
            if (!active) {
                Text("نظام المستخدمين غير مفعّل. عيّن كلمة مرور لمدير النظام لتفعيله (سيُطلب تسجيل الدخول عند فتح التطبيق).")
                TextField(pwd, { pwd = it }, Modifier.fillMaxWidth(), label = { Text("كلمة مرور مدير النظام") }, singleLine = true, visualTransformation = PasswordVisualTransformation())
                PillButton("تفعيل", Modifier.align(Alignment.CenterHorizontally).padding(top = 10.dp)) {
                    if (pwd.length < 4) n.toast("كلمة المرور قصيرة (4 أحرف على الأقل)")
                    else { val e = n.db.activateAdmin(pwd); if (e == null) { pwd = ""; r++; n.toast("تم التفعيل — اسم مدير النظام: ${n.db.userName(0)}") } else n.toast(e) }
                }
            } else {
                users.forEach { u ->
                    Text(u.name + if (u.id == 0L) "  (مدير النظام)" else "  — اضغط لتعديل الصلاحيات",
                        Modifier.fillMaxWidth().clickable { if (u.id != 0L) n.push(Route("priv", u.id, u.name)) }.padding(vertical = 12.dp), fontSize = 17.sp)
                    HorizontalDivider()
                }
                Spacer(Modifier.height(14.dp)); Text("إضافة مستخدم", fontWeight = FontWeight.Bold)
                Field(name, { name = it }, "الاسم"); Field(uname, { uname = it }, "اسم الدخول")
                TextField(upwd, { upwd = it }, Modifier.fillMaxWidth(), label = { Text("كلمة المرور") }, singleLine = true, visualTransformation = PasswordVisualTransformation())
                PillButton("إضافة", Modifier.align(Alignment.CenterHorizontally).padding(top = 10.dp)) {
                    if (name.isBlank() || uname.isBlank() || upwd.length < 4) n.toast("أكمل البيانات (كلمة المرور 4 أحرف على الأقل)")
                    else { val e = n.db.addUser(uname, name, upwd); if (e == null) { name = ""; uname = ""; upwd = ""; r++ } else n.toast(e) }
                }
            }
        }
    }
}

@Composable
fun PrivScreen(n: Nav, userId: Long, name: String) {
    var r by remember { mutableIntStateOf(0) }
    val rows = remember(r) { n.db.privs(userId) }
    Page(n, "صلاحيات: $name") {
        Row(Modifier.fillMaxWidth().padding(horizontal = 10.dp)) {
            Text("الشاشة", Modifier.weight(2f), fontWeight = FontWeight.Bold)
            listOf("عرض", "إضافة", "تعديل", "حذف").forEach { Text(it, Modifier.weight(1f), fontSize = 12.sp, fontWeight = FontWeight.Bold) }
        }
        LazyColumn(Modifier.weight(1f)) {
            items(rows) { p ->
                Row(Modifier.fillMaxWidth().padding(horizontal = 10.dp), verticalAlignment = Alignment.CenterVertically) {
                    Text(p.name, Modifier.weight(2f), fontSize = 14.sp)
                    listOf("view" to p.view, "new" to p.new, "edit" to p.edit, "del" to p.del).forEach { (col, v) ->
                        Checkbox(v, { c -> val e = n.db.setPriv(userId, p.screenId, col, c); if (e == null) r++ else n.toast(e) }, Modifier.weight(1f))
                    }
                }
                HorizontalDivider()
            }
        }
    }
}

@Composable
fun SimpleListScreen(n: Nav, title: String, kind: Int) {
    var name by remember { mutableStateOf("") }; var code by remember { mutableStateOf("") }
    val list = remember(n.tick) { when (kind) { 0 -> n.db.groups(); 1 -> n.db.itemTypes(); else -> n.db.units() } }
    Page(n, title) {
        Column(Modifier.padding(12.dp).verticalScroll(rememberScrollState())) {
            Field(name, { name = it }, "الاسم")
            if (kind == 2) Field(code, { code = it }, "الرمز المختصر")
            PillButton("إضافة", Modifier.align(Alignment.CenterHorizontally).padding(top = 10.dp)) {
                if (name.isBlank()) n.toast("اكتب الاسم") else {
                    val e = when (kind) { 0 -> n.db.addGroup(name); 1 -> n.db.addItemType(name); else -> n.db.addUnit(name, code) }
                    if (e == null) n.bump() else n.toast(e)
                }
            }
            Spacer(Modifier.height(8.dp))
            list.forEach { Text(it.name, Modifier.padding(vertical = 10.dp), fontSize = 17.sp); HorizontalDivider() }
        }
    }
}

@Composable
fun TaxScreen(n: Nav) {
    var name by remember { mutableStateOf("") }; var per by remember { mutableStateOf("") }
    var vat by remember { mutableStateOf(n.db.conf(6) == "1") }
    val list = remember(n.tick) { n.db.taxes() }
    Page(n, "الضريبة") {
        Column(Modifier.padding(12.dp).verticalScroll(rememberScrollState())) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text("تفعيل ضريبة القيمة المضافة", Modifier.weight(1f))
                Switch(vat, { vat = it; n.db.setConf(6, "VAT enable", if (it) "1" else "0") })
            }
            HorizontalDivider()
            list.forEach { Text("${it.name}  —  ${money(it.per)}%", Modifier.padding(vertical = 10.dp), fontSize = 17.sp); HorizontalDivider() }
            Spacer(Modifier.height(10.dp)); Text("إضافة ضريبة", fontWeight = FontWeight.Bold)
            Field(name, { name = it }, "الاسم"); Field(per, { per = it }, "النسبة %", kb = numKb)
            PillButton("إضافة", Modifier.align(Alignment.CenterHorizontally).padding(top = 10.dp)) {
                if (name.isBlank()) n.toast("اكتب الاسم") else { val e = n.db.addTax(name, num(per)); if (e == null) n.bump() else n.toast(e) }
            }
        }
    }
}
