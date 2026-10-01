package com.muhasib.app

import android.graphics.Paint
import android.graphics.pdf.PdfDocument
import android.text.Layout
import android.text.StaticLayout
import android.text.TextPaint
import java.io.OutputStream

object PdfUtil {
    private fun writeLines(out: OutputStream, title: String, lines: List<String>) {
        val doc = PdfDocument()
        val paint = TextPaint(Paint.ANTI_ALIAS_FLAG).apply { textSize = 12f }
        val titlePaint = TextPaint(Paint.ANTI_ALIAS_FLAG).apply { textSize = 18f; isFakeBoldText = true }
        val pageWidth = 595
        val pageHeight = 842
        val margin = 36
        val contentWidth = pageWidth - margin * 2
        var pageNo = 1
        var y = margin
        var page = doc.startPage(PdfDocument.PageInfo.Builder(pageWidth, pageHeight, pageNo++).create())

        fun drawAt(text: String, tp: TextPaint, gap: Int) {
            val layout = StaticLayout.Builder.obtain(text, 0, text.length, tp, contentWidth)
                .setAlignment(Layout.Alignment.ALIGN_NORMAL)
                .setTextDirection(android.text.TextDirectionHeuristics.RTL)
                .setIncludePad(true)
                .build()
            if (y + layout.height > pageHeight - margin) {
                doc.finishPage(page)
                page = doc.startPage(PdfDocument.PageInfo.Builder(pageWidth, pageHeight, pageNo++).create())
                y = margin
            }
            page.canvas.save()
            page.canvas.translate(margin.toFloat(), y.toFloat())
            layout.draw(page.canvas)
            page.canvas.restore()
            y += layout.height + gap
        }

        drawAt(title, titlePaint, 18)
        lines.forEach { drawAt(it, paint, 8) }
        doc.finishPage(page)
        doc.writeTo(out)
        doc.close()
    }

    fun invoice(out: OutputStream, title: String, number: Long, date: String, party: String, amount: Double, lines: List<String>) {
        writeLines(out, title, buildList {
            add("رقم المستند: " + number)
            add("التاريخ: " + date)
            if (party.isNotBlank()) add("الحساب: " + party)
            add("")
            addAll(lines)
            add("")
            add("الإجمالي: " + money(amount))
        })
    }

    fun report(out: OutputStream, title: String, rows: List<String>) {
        writeLines(out, title, rows)
    }
}
