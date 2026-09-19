package com.muhasib.app

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import java.util.Locale

val Navy = Color(0xFF1A4E8A)
val Blue = Color(0xFF0B6FAA)
val Bg = Color(0xFFFAFAFA)
val Pink = Color(0xFFFF4081)
val Debit = Color(0xFFB3261E)   // عليه
val Credit = Color(0xFF1B6E3C)  // له
val BarBrush = Brush.horizontalGradient(listOf(Navy, Blue, Navy))
val PillBrush = Brush.verticalGradient(listOf(Color(0xFF1E88D0), Color(0xFF0A5C9E)))
val numKb = KeyboardOptions(keyboardType = KeyboardType.Decimal)

fun money(v: Double): String = String.format(Locale.US, "%,.2f", v)
fun num(s: String): Double = s.trim().replace(',', '.').toDoubleOrNull() ?: 0.0

data class Route(val k: String, val id: Long = 0, val name: String = "")

class Nav(
    val db: Db, val userId: Long, val push: (Route) -> Unit, val pop: () -> Unit,
    val toast: (String) -> Unit, val tick: Int, val bump: () -> Unit
)

@Composable
fun AppBar(title: String, onBack: (() -> Unit)?, navIcon: String = "←", actions: @Composable RowScope.() -> Unit = {}) {
    CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Ltr) {
        Row(Modifier.fillMaxWidth().background(BarBrush).height(56.dp), verticalAlignment = Alignment.CenterVertically) {
            if (onBack != null) BarIcon(navIcon, onBack) else Spacer(Modifier.width(12.dp))
            Text(title, color = Color.White, fontSize = 20.sp, fontWeight = FontWeight.Bold, modifier = Modifier.weight(1f), maxLines = 1)
            actions()
        }
    }
}

@Composable
fun BarIcon(t: String, onClick: () -> Unit) {
    Text(t, color = Color.White, fontSize = 24.sp, modifier = Modifier.clickable(onClick = onClick).padding(horizontal = 14.dp, vertical = 10.dp))
}

@Composable
fun SectionHeader(title: String, open: Boolean, onClick: () -> Unit) {
    Row(Modifier.fillMaxWidth().background(Blue).clickable(onClick = onClick).padding(horizontal = 16.dp, vertical = 16.dp), verticalAlignment = Alignment.CenterVertically) {
        Text(title, color = Color.White, fontSize = 19.sp, fontWeight = FontWeight.Bold, modifier = Modifier.weight(1f))
        Text(if (open) "⌃" else "⌄", color = Color.White, fontSize = 20.sp)
    }
    HorizontalDivider(color = Color.White.copy(alpha = 0.6f))
}

@Composable
fun MenuRow(label: String, onClick: () -> Unit) {
    Text(label, fontSize = 18.sp, modifier = Modifier.fillMaxWidth().clickable(onClick = onClick).padding(horizontal = 18.dp, vertical = 16.dp))
    HorizontalDivider()
}

@Composable
fun PillButton(text: String, modifier: Modifier = Modifier, onClick: () -> Unit) {
    Box(modifier.clip(RoundedCornerShape(50)).background(PillBrush).clickable(onClick = onClick).padding(horizontal = 26.dp, vertical = 9.dp), contentAlignment = Alignment.Center) {
        Text(text, color = Color.White, fontWeight = FontWeight.Bold, fontSize = 17.sp)
    }
}

@Composable
fun BorderCard(content: @Composable ColumnScope.() -> Unit) {
    Column(Modifier.fillMaxWidth().padding(horizontal = 6.dp, vertical = 3.dp).border(2.dp, Blue, RoundedCornerShape(12.dp)).padding(8.dp), content = content)
}

@Composable
fun Field(value: String, onChange: (String) -> Unit, label: String, modifier: Modifier = Modifier.fillMaxWidth(), kb: KeyboardOptions = KeyboardOptions.Default, enabled: Boolean = true) {
    TextField(
        value, onChange, modifier = modifier, label = { Text(label, color = Color.Gray) }, singleLine = true,
        keyboardOptions = kb, enabled = enabled,
        colors = TextFieldDefaults.colors(
            focusedContainerColor = Color.Transparent, unfocusedContainerColor = Color.Transparent, disabledContainerColor = Color.Transparent,
            focusedIndicatorColor = Pink, unfocusedIndicatorColor = Color.DarkGray, disabledIndicatorColor = Color.Gray
        )
    )
}

@Composable
fun Drop(label: String, options: List<Opt>, selected: Long?, modifier: Modifier = Modifier, onSelect: (Long) -> Unit) {
    var open by remember { mutableStateOf(false) }
    Box(modifier) {
        Row(Modifier.clickable { open = true }.padding(8.dp), verticalAlignment = Alignment.CenterVertically) {
            Text(options.firstOrNull { it.id == selected }?.name ?: label, textDecoration = TextDecoration.Underline, fontWeight = FontWeight.SemiBold)
            Text(" ▾", fontSize = 16.sp)
        }
        DropdownMenu(open, { open = false }) {
            options.forEach { o -> DropdownMenuItem(text = { Text(o.name) }, onClick = { onSelect(o.id); open = false }) }
        }
    }
}

/** Type-ahead field; matches are listed inline below the field (no popup, so the keyboard stays open). */
@Composable
fun SearchField(label: String, options: List<Opt>, selected: Long?, onSelect: (Opt?) -> Unit) {
    var text by remember { mutableStateOf(options.firstOrNull { it.id == selected }?.name ?: "") }
    Column(Modifier.fillMaxWidth()) {
        Field(text, { text = it; onSelect(null) }, label)
        if (selected == null && text.isNotBlank()) {
            options.filter { it.name.contains(text, true) }.take(6).forEach { o ->
                Text(o.name, Modifier.fillMaxWidth().background(Color(0xFFEAF3FA)).clickable { text = o.name; onSelect(o) }.padding(12.dp))
                HorizontalDivider()
            }
        }
    }
}

@Composable
fun BottomBar(onAdd: (() -> Unit)?, text: String = "") {
    CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Ltr) {
        Box(Modifier.fillMaxWidth().background(BarBrush).height(64.dp)) {
            Text(text, color = Color.White, fontSize = 18.sp, fontWeight = FontWeight.SemiBold, modifier = Modifier.align(Alignment.Center))
            if (onAdd != null) Box(
                Modifier.align(Alignment.CenterEnd).padding(12.dp).size(48.dp).clip(CircleShape).background(Color.White).clickable(onClick = onAdd),
                contentAlignment = Alignment.Center
            ) { Text("+", color = Blue, fontSize = 34.sp, fontWeight = FontWeight.Bold) }
        }
    }
}

@Composable
fun TableHeader(cols: List<Pair<String, Float>>) {
    Row(Modifier.fillMaxWidth().background(Blue).padding(horizontal = 10.dp, vertical = 12.dp)) {
        cols.forEach { (t, w) -> Text(t, Modifier.weight(w), color = Color.White, textDecoration = TextDecoration.Underline, fontSize = 15.sp) }
    }
}

@Composable
fun Empty(text: String = "لا توجد نتائج...") {
    Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) { Text(text, color = Color(0xFF5B73D6), fontSize = 18.sp, textAlign = TextAlign.Center) }
}

@Composable
fun Confirm(title: String, msg: String, yes: String = "حذف", onYes: () -> Unit, onDismiss: () -> Unit) {
    AlertDialog(
        onDismissRequest = onDismiss, title = { Text(title) }, text = { Text(msg) },
        confirmButton = { TextButton(onClick = { onYes(); onDismiss() }) { Text(yes, color = Debit) } },
        dismissButton = { TextButton(onClick = onDismiss) { Text("إلغاء") } }
    )
}

@Composable
fun Page(n: Nav, title: String, actions: @Composable RowScope.() -> Unit = {}, bottom: @Composable () -> Unit = {}, content: @Composable ColumnScope.() -> Unit) {
    Column(Modifier.fillMaxSize()) {
        AppBar(title, n.pop, actions = actions)
        Column(Modifier.weight(1f).fillMaxWidth(), content = content)
        bottom()
    }
}

@Composable
fun BalanceText(b: Map<String, Double>) {
    if (b.isEmpty()) { Text("0.00", color = Color.Gray); return }
    Column(horizontalAlignment = Alignment.End) {
        b.forEach { (cur, v) ->
            Text("${money(kotlin.math.abs(v))} ${if (v > 0) "عليه" else "له"} ($cur)", color = if (v > 0) Debit else Credit, fontSize = 13.sp)
        }
    }
}
