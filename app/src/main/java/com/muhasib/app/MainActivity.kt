package com.muhasib.app

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.BackHandler
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val db = Db(this)
        setContent {
            MaterialTheme(colorScheme = lightColorScheme(primary = Blue, onPrimary = Color.White, secondary = Navy, background = Bg)) {
                CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Rtl) { Root(db) }
            }
        }
    }
}

@Composable
fun Root(db: Db) {
    var user by remember { mutableStateOf<Opt?>(if (db.adminActive()) null else Opt(0, db.userName(0))) }
    val u = user
    if (u == null) LoginScreen(db) { user = it } else App(db, u) { user = null }
}

@Composable
fun LoginScreen(db: Db, onOk: (Opt) -> Unit) {
    var name by remember { mutableStateOf("") }
    var pwd by remember { mutableStateOf("") }
    var err by remember { mutableStateOf("") }
    Column(Modifier.fillMaxSize().background(Bg)) {
        AppBar("تسجيل الدخول", null)
        Column(Modifier.padding(24.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            Field(name, { name = it }, "اسم المستخدم")
            TextField(
                pwd, { pwd = it }, Modifier.fillMaxWidth(), label = { Text("كلمة المرور") }, singleLine = true,
                visualTransformation = PasswordVisualTransformation(),
                colors = TextFieldDefaults.colors(focusedContainerColor = Color.Transparent, unfocusedContainerColor = Color.Transparent, focusedIndicatorColor = Pink)
            )
            if (err.isNotEmpty()) Text(err, color = Debit)
            PillButton("دخول", Modifier.align(Alignment.CenterHorizontally)) {
                val u = db.login(name, pwd)
                if (u == null) err = "اسم المستخدم أو كلمة المرور غير صحيحة" else onOk(u)
            }
        }
    }
}

data class MenuItem(val label: String, val screenId: Int, val route: Route)

val SECTIONS: List<Pair<String, List<MenuItem>>> = listOf(
    "عمليات مخزنية" to listOf(
        MenuItem("صرف مخزني", -3, Route("invoice", 11)), MenuItem("توريد مخزني", -2, Route("invoice", 21)),
        MenuItem("تحويل مخزني", 6, Route("move", 3)), MenuItem("تسوية مخزنية", 7, Route("move", 4)),
        MenuItem("إضافة مخزن", 8, Route("addbranch")), MenuItem("جرد مخزني", 28, Route("count"))
    ),
    "قيود وحسابات" to listOf(
        MenuItem("قيد يومي", 9, Route("journal")), MenuItem("قيد إفتتاحي", 10, Route("opening")),
        MenuItem("إضافة حساب", 11, Route("addacc")), MenuItem("حركة الصندوق", 12, Route("cash")),
        MenuItem("دليل الحسابات", 13, Route("chart")), MenuItem("إقفال سنوي", 14, Route("closing"))
    ),
    "أصناف" to listOf(
        MenuItem("الأصناف", 15, Route("items")), MenuItem("أسعار البيع", 16, Route("prices")),
        MenuItem("وحدات الصنف", 27, Route("itemunits")), MenuItem("فاتورة عرض سعر", 29, Route("bills", 8)),
        MenuItem("طلب شراء", 30, Route("bills", 9))
    ),
    "العملات" to listOf(
        MenuItem("إضافة عملة", 19, Route("addcurr")), MenuItem("سعر العملات", 20, Route("currprices")),
        MenuItem("سقف الحساب", 31, Route("limits"))
    ),
    "التقارير" to listOf(
        MenuItem("حركة الأصناف", 21, Route("itemmove")), MenuItem("ميزان المراجعة", 23, Route("trial")),
        MenuItem("قائمة الدخل", 24, Route("income")), MenuItem("المركز المالي", 25, Route("balance")),
        MenuItem("تقارير أخرى", 26, Route("others"))
    )
)

@Composable
fun App(db: Db, user: Opt, onLogout: () -> Unit) {
    val ctx = LocalContext.current
    val stack = remember { mutableStateListOf(Route("home")) }
    var tick by remember { mutableIntStateOf(0) }
    val ds = rememberDrawerState(DrawerValue.Closed)
    val scope = rememberCoroutineScope()
    val toast: (String) -> Unit = { Toast.makeText(ctx, it, Toast.LENGTH_LONG).show() }
    val nav = Nav(db, user.id, { stack.add(it) }, { if (stack.size > 1) stack.removeAt(stack.lastIndex) }, toast, tick, { tick++ })

    val save = rememberLauncherForActivityResult(ActivityResultContracts.CreateDocument("application/octet-stream")) { uri ->
        if (uri != null) runCatching { ctx.contentResolver.openOutputStream(uri)!!.use { db.exportTo(it) } }
            .onSuccess { toast("تم حفظ النسخة الاحتياطية") }.onFailure { toast("فشل الحفظ: ${it.message}") }
    }
    val load = rememberLauncherForActivityResult(ActivityResultContracts.OpenDocument()) { uri ->
        if (uri != null) runCatching { ctx.contentResolver.openInputStream(uri)!!.use { db.importFrom(it) } }
            .onSuccess { tick++; toast("تم استرجاع قاعدة البيانات") }.onFailure { toast("فشل الاسترجاع: ${it.message}") }
    }

    BackHandler(enabled = ds.isOpen || stack.size > 1) {
        if (ds.isOpen) scope.launch { ds.close() } else nav.pop()
    }
    val cur = stack.last()
    val closeThen: (() -> Unit) -> Unit = { a -> scope.launch { ds.close() }; a() }

    CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Ltr) {
        ModalNavigationDrawer(
            drawerState = ds, gesturesEnabled = cur.k == "home",
            drawerContent = {
                ModalDrawerSheet(drawerContainerColor = Color.White) {
                    CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Rtl) {
                        Box(Modifier.fillMaxWidth().background(BarBrush).padding(20.dp)) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Box(Modifier.size(56.dp).clip(CircleShape).background(Color(0xFF1E88D0)), contentAlignment = Alignment.Center) { Text("💲", fontSize = 28.sp) }
                                Spacer(Modifier.width(14.dp))
                                Column {
                                    Text(db.conf(201).ifBlank { "المحاسب" }, color = Color.White, fontSize = 22.sp, fontWeight = FontWeight.Bold)
                                    Text("(${user.id}) ${user.name}", color = Color.White)
                                }
                            }
                        }
                        DrawerItem("💾", "حفظ نسخة إحتياطية") { closeThen { save.launch("inv.db") } }
                        DrawerItem("♻️", "إسترجاع قاعدة البيانات") { closeThen { load.launch(arrayOf("*/*")) } }
                        DrawerItem("📒", "دليل الحسابات") { closeThen { nav.push(Route("chart")) } }
                        DrawerItem("⚙️", "إعدادات") { closeThen { nav.push(Route("settings")) } }
                        DrawerItem("ℹ️", "حول البرنامج") { closeThen { nav.push(Route("about")) } }
                        DrawerItem("🚪", "خروج") { closeThen { if (db.adminActive()) onLogout() else (ctx as Activity).finish() } }
                    }
                }
            }
        ) {
            CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Rtl) {
                Box(Modifier.fillMaxSize().background(Bg)) {
                    key(cur, tick) { RouteContent(nav, cur) { scope.launch { ds.open() } } }
                }
            }
        }
    }
}

@Composable
fun DrawerItem(icon: String, label: String, onClick: () -> Unit) {
    Row(Modifier.fillMaxWidth().clickable(onClick = onClick).padding(horizontal = 18.dp, vertical = 16.dp), verticalAlignment = Alignment.CenterVertically) {
        Text(icon, fontSize = 24.sp)
        Spacer(Modifier.width(16.dp))
        Text(label, fontSize = 18.sp, fontWeight = FontWeight.SemiBold)
    }
    HorizontalDivider()
}

@Composable
fun RouteContent(n: Nav, r: Route, openDrawer: () -> Unit) {
    when (r.k) {
        "home" -> HomeScreen(n, openDrawer)
        "bills" -> BillList(n, r.id.toInt())
        "invoice" -> InvoiceScreen(n, r.id.toInt())
        "vouchers" -> VoucherList(n)
        "voucher" -> VoucherScreen(n)
        "journal" -> EntryList(n, false)
        "journalnew" -> JournalNew(n)
        "opening" -> EntryList(n, true)
        "openingnew" -> OpeningNew(n)
        "accounts" -> AccountsScreen(n)
        "addacc" -> AddAccountScreen(n)
        "statement" -> StatementScreen(n, r.id, r.name)
        "cash" -> CashScreen(n)
        "chart" -> ChartScreen(n)
        "items" -> ItemsScreen(n)
        "prices" -> PricesScreen(n)
        "itemunits" -> ItemUnitsScreen(n)
        "itemmove" -> ItemMoveScreen(n)
        "move" -> MoveScreen(n, r.id.toInt())
        "count" -> CountScreen(n)
        "addbranch" -> BranchScreen(n)
        "addcurr" -> CurrencyScreen(n)
        "currprices" -> CurrPricesScreen(n)
        "limits" -> LimitsScreen(n)
        "trial" -> TrialScreen(n)
        "income" -> FinScreen(n, "قائمة الدخل") { it.incomeStatement() }
        "balance" -> FinScreen(n, "المركز المالي") { it.balanceSheet() }
        "others" -> OthersScreen(n)
        "balances" -> BalancesScreen(n, r.id.toInt(), r.name)
        "stockrem" -> StockRemainingScreen(n)
        "settings" -> SettingsScreen(n)
        "personal" -> PersonalScreen(n)
        "users" -> UsersScreen(n)
        "priv" -> PrivScreen(n, r.id, r.name)
        "groups" -> SimpleListScreen(n, r.name, r.id.toInt())
        "tax" -> TaxScreen(n)
        "about" -> AboutScreen(n)
        "closing" -> Page(n, "إقفال سنوي") { Empty("إقفال السنة غير متاح في هذه النسخة") }
    }
}

// ------------------------------------------------------------------------------------- Home
@Composable
fun HomeScreen(n: Nav, openDrawer: () -> Unit) {
    val ctx = LocalContext.current
    var open by remember { mutableIntStateOf(-1) }
    val branch = remember(n.tick) { n.db.branches().firstOrNull()?.name ?: "" }
    val title = remember(n.tick) { n.db.conf(201).ifBlank { "المحاسب" } }
    Column(Modifier.fillMaxSize()) {
        AppBar(title, openDrawer, navIcon = "☰") {
            BarIcon("🔔") { n.toast("لا توجد إشعارات") }
            BarIcon("⤴") {
                val i = Intent(Intent.ACTION_SEND).apply { type = "text/plain"; putExtra(Intent.EXTRA_TEXT, title) }
                ctx.startActivity(Intent.createChooser(i, null))
            }
        }
        Column(Modifier.weight(1f).verticalScroll(rememberScrollState())) {
            Column(Modifier.fillMaxWidth().background(Color.White).padding(vertical = 10.dp)) {
                Row(Modifier.fillMaxWidth()) {
                    Tile("🧺", "المبيعات", { n.push(Route("invoice", 1)) }, Modifier.weight(1f)) { n.push(Route("bills", 1)) }
                    Tile("💵", "قبض/صرف", null, Modifier.weight(1f)) { n.push(Route("vouchers")) }
                }
                Spacer(Modifier.height(8.dp))
                Row(Modifier.fillMaxWidth()) {
                    Tile("🛒", "المشتريات", { n.push(Route("invoice", 2)) }, Modifier.weight(1f)) { n.push(Route("bills", 2)) }
                    Tile("📊", "الحسابات", null, Modifier.weight(1f)) { n.push(Route("accounts")) }
                }
            }
            HorizontalDivider(thickness = 2.dp, color = Color.LightGray)
            SECTIONS.forEachIndexed { i, (title2, items) ->
                SectionHeader(title2, open == i) { open = if (open == i) -1 else i }
                if (open == i) items.filter { n.db.canView(n.userId, it.screenId) }.forEach { m ->
                    MenuRow(m.label) { n.push(m.route) }
                }
            }
        }
        BottomBar(null, branch)
    }
}

@Composable
fun Tile(icon: String, label: String, plus: (() -> Unit)?, modifier: Modifier, onClick: () -> Unit) {
    Column(modifier, horizontalAlignment = Alignment.CenterHorizontally) {
        Text(icon, fontSize = 46.sp)
        Spacer(Modifier.height(6.dp))
        Row(verticalAlignment = Alignment.CenterVertically) {
            if (plus != null) {
                Box(Modifier.size(34.dp).clip(CircleShape).background(Color(0xFF3F5B6B)).clickable(onClick = plus), contentAlignment = Alignment.Center) {
                    Text("+", color = Color.White, fontSize = 22.sp, fontWeight = FontWeight.Bold)
                }
                Spacer(Modifier.width(8.dp))
            }
            PillButton(label, onClick = onClick)
        }
    }
}

// ------------------------------------------------------------------------------------- Settings
@Composable
fun SettingsScreen(n: Nav) {
    val items = listOf(
        Triple("🪪", "البيانات الشخصية", Route("personal")),
        Triple("🖨️", "خيارات الطباعة", null),
        Triple("🔒", "خيارات الأمان", null),
        Triple("👤", "المستخدمين والصلاحيات", Route("users")),
        Triple("🏷️", "التصنيفات", Route("groups", 0, "التصنيفات")),
        Triple("🛍️", "مجموعة الصنف", Route("groups", 1, "مجموعة الصنف")),
        Triple("📦", "وحدات القياس", Route("groups", 2, "وحدات القياس")),
        Triple("🗄️", "خيارات حفظ البيانات", null),
        Triple("🧾", "الطابعة الحرارية", null),
        Triple("💰", "الضريبة", Route("tax")),
        Triple("▥", "طابعة باركود الأصناف", null),
        Triple("🔔", "خيارات الإشعارات", null),
        Triple("🛠️", "خيارات أخرى", null)
    )
    Page(n, "إعدادات") {
        Column(Modifier.verticalScroll(rememberScrollState())) {
            items.forEach { (icon, label, route) ->
                Row(
                    Modifier.fillMaxWidth().clickable { if (route != null) n.push(route) else n.toast("قريباً في الإصدار القادم") }.padding(horizontal = 14.dp, vertical = 12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Box(Modifier.size(40.dp).clip(CircleShape).background(Blue), contentAlignment = Alignment.Center) { Text(icon, fontSize = 20.sp) }
                    Spacer(Modifier.width(14.dp))
                    Text(label, fontSize = 18.sp, color = if (route == null) Color.Gray else Color.Unspecified)
                }
            }
        }
    }
}

@Composable
fun AboutScreen(n: Nav) {
    Page(n, "حول البرنامج") {
        Column(Modifier.padding(24.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Text("المحاسب", fontSize = 26.sp, fontWeight = FontWeight.Bold, color = Blue)
            Text("الإصدار 1.0")
            Text("نظام محاسبة ومخازن يعمل دون إنترنت. قاعدة البيانات بصيغة inv.db.")
        }
    }
}
