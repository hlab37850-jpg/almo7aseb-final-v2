package com.muhasib.app

import android.app.DatePickerDialog
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

@Composable
fun DateField(value: String, onChange: (String) -> Unit, label: String, modifier: Modifier = Modifier.fillMaxWidth()) {
    val ctx = LocalContext.current
    Field(value, onChange, label, modifier = modifier, enabled = false)
    LaunchedEffect(Unit) {
        // The field remains visually identical; the calendar is opened by the overlay below.
    }
}

@Composable
fun DatePickerField(value: String, onChange: (String) -> Unit, label: String, modifier: Modifier = Modifier.fillMaxWidth()) {
    val ctx = LocalContext.current
    val cal = remember(value) {
        Calendar.getInstance().apply {
            runCatching {
                val d = SimpleDateFormat("yyyy-MM-dd", Locale.US).parse(value)
                if (d != null) time = d
            }
        }
    }
    Box(modifier) {
        Field(value, { }, label, modifier = Modifier.fillMaxWidth(), enabled = false)
        Spacer(Modifier.matchParentSize().clickable {
            DatePickerDialog(
                ctx,
                { _, y, m, d -> onChange(String.format(Locale.US, "%04d-%02d-%02d", y, m + 1, d)) },
                cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH)
            ).show()
        })
    }
}

@Composable
fun ClosingScreen(n: Nav) {
    var date by remember { mutableStateOf(n.db.today()) }
    var refresh by remember { mutableIntStateOf(0) }
    val rows = remember(refresh) { n.db.closingYears() }
    Page(n, "إقفال سنوي") {
        Column(Modifier.padding(12.dp).verticalScroll(rememberScrollState())) {
            Text("إقفال الفترة يمنع إضافة أو تعديل أو حذف الحركات والفواتير السابقة لهذا التاريخ.", color = Color.Gray, fontSize = 12.sp)
            DatePickerField(date, { date = it }, "حتى تاريخ")
            PillButton("إقفال الفترة", Modifier.align(Alignment.CenterHorizontally).padding(top = 10.dp)) {
                if (!n.db.canDo(n.userId, 14, "new")) n.toast("ليس لديك صلاحية الإضافة")
                else {
                    val e = n.db.closeYear(date)
                    if (e == null) { refresh++; n.bump(); n.toast("تم إقفال الفترة حتى $date") } else n.toast(e)
                }
            }
            Spacer(Modifier.height(18.dp))
            Text("الفترات المقفلة", fontWeight = FontWeight.Bold)
            rows.forEach { r ->
                Row(Modifier.fillMaxWidth().padding(vertical = 10.dp), verticalAlignment = Alignment.CenterVertically) {
                    Text(r.date, Modifier.weight(1f))
                    if (r.id == rows.firstOrNull()?.id && n.db.canDo(n.userId, 14, "edit")) {
                        TextButton(onClick = {
                            val e = n.db.reopenLastYear()
                            if (e == null) { refresh++; n.bump(); n.toast("تم فتح آخر فترة") } else n.toast(e)
                        }) { Text("فتح") }
                    }
                }
                HorizontalDivider()
            }
        }
    }
}

@Composable
fun SecurityScreen(n: Nav) {
    var old by remember { mutableStateOf("") }
    var next by remember { mutableStateOf("") }
    var confirm by remember { mutableStateOf("") }
    Page(n, "خيارات الأمان") {
        Column(Modifier.padding(12.dp).verticalScroll(rememberScrollState())) {
            Text("تغيير كلمة المرور", fontWeight = FontWeight.Bold)
            TextField(old, { old = it }, Modifier.fillMaxWidth(), label = { Text("كلمة المرور الحالية") }, singleLine = true, visualTransformation = PasswordVisualTransformation())
            TextField(next, { next = it }, Modifier.fillMaxWidth(), label = { Text("كلمة المرور الجديدة") }, singleLine = true, visualTransformation = PasswordVisualTransformation())
            TextField(confirm, { confirm = it }, Modifier.fillMaxWidth(), label = { Text("تأكيد كلمة المرور") }, singleLine = true, visualTransformation = PasswordVisualTransformation())
            PillButton("حفظ", Modifier.align(Alignment.CenterHorizontally).padding(top = 10.dp)) {
                if (next != confirm) n.toast("تأكيد كلمة المرور غير متطابق")
                else {
                    val e = n.db.changePassword(n.userId, old, next)
                    if (e == null) { old = ""; next = ""; confirm = ""; n.toast("تم تغيير كلمة المرور") } else n.toast(e)
                }
            }
        }
    }
}

@Composable
fun DataSettingsScreen(n: Nav) {
    var auto by remember { mutableStateOf(n.db.conf(301) == "1") }
    Page(n, "خيارات حفظ البيانات") {
        Column(Modifier.padding(12.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text("تذكير بالنسخ الاحتياطي", Modifier.weight(1f))
                Switch(auto, {
                    auto = it
                    n.db.setConf(301, "Backup reminder", if (it) "1" else "0")
                    n.bump()
                })
            }
            HorizontalDivider()
            Text("النسخة الاحتياطية اليدوية متاحة من القائمة الجانبية، وتحفظ ملف inv.db كما هو.", modifier = Modifier.padding(top = 12.dp), color = Color.Gray)
        }
    }
}

@Composable
fun PrintSettingsScreen(n: Nav) {
    Page(n, "خيارات الطباعة") {
        Column(Modifier.padding(12.dp).verticalScroll(rememberScrollState())) {
            Text("تصدير PDF", fontWeight = FontWeight.Bold)
            Text("يمكن حفظ الفواتير وملفات التقارير بصيغة PDF من داخل الشاشة نفسها، دون تغيير شكل التطبيق.")
            Spacer(Modifier.height(12.dp))
            Text("الطباعة المباشرة تعتمد على خدمة الطباعة التي يثبتها المستخدم في Android.", color = Color.Gray, fontSize = 12.sp)
        }
    }
}

@Composable
fun ThermalPrinterScreen(n: Nav) {
    var host by remember { mutableStateOf(n.db.conf(302)) }
    var port by remember { mutableStateOf(n.db.conf(303).ifBlank { "9100" }) }
    Page(n, "الطابعة الحرارية") {
        Column(Modifier.padding(12.dp)) {
            Field(host, { host = it }, "عنوان الشبكة")
            Field(port, { port = it }, "المنفذ", kb = numKb)
            PillButton("حفظ الإعدادات", Modifier.align(Alignment.CenterHorizontally).padding(top = 10.dp)) {
                n.db.setConf(302, "Thermal printer host", host.trim())
                n.db.setConf(303, "Thermal printer port", port.trim())
                n.toast("تم حفظ إعدادات الطابعة")
            }
            Text("يمكن استخدام إعدادات الشبكة مع خدمة الطباعة/ESC-POS المتوافقة؛ لا يتم إرسال أي بيانات قبل تنفيذ أمر الطباعة.", color = Color.Gray, fontSize = 12.sp, modifier = Modifier.padding(top = 12.dp))
        }
    }
}

@Composable
fun NotificationSettingsScreen(n: Nav) {
    var enabled by remember { mutableStateOf(n.db.conf(304) != "0") }
    Page(n, "خيارات الإشعارات") {
        Row(Modifier.fillMaxWidth().padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
            Text("تفعيل إشعارات التطبيق", Modifier.weight(1f))
            Switch(enabled, {
                enabled = it
                n.db.setConf(304, "Notifications", if (it) "1" else "0")
            })
        }
    }
}

@Composable
fun OtherSettingsScreen(n: Nav) {
    var strict by remember { mutableStateOf(n.db.conf(305) == "1") }
    Page(n, "خيارات أخرى") {
        Column(Modifier.padding(12.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text("التحقق الصارم من الصلاحيات", Modifier.weight(1f))
                Switch(strict, {
                    strict = it
                    n.db.setConf(305, "Strict permissions", if (it) "1" else "0")
                })
            }
            Text("يتم تطبيق الصلاحيات على العمليات الحساسة من طبقة التطبيق وقاعدة البيانات.", color = Color.Gray, fontSize = 12.sp, modifier = Modifier.padding(top = 12.dp))
        }
    }
}
