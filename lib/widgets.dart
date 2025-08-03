import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'summary_model.dart';

Widget buildSummarizerTab({
  required TextEditingController textController,
  required bool isLoading,
  required String summary,
  required VoidCallback onSummarize,
}) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        TextField(
          controller: textController,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'Tıbbi metni buraya girin...',
            filled: true,
            fillColor: Colors.white,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading ? null : onSummarize,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            backgroundColor: const Color(0xFF2575FC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: isLoading
              ? const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          )
              : const Text('Özetle'),
        ),
        const SizedBox(height: 24),
        if (summary.isNotEmpty)
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Text(
              summary,
              style: GoogleFonts.openSans(fontSize: 16, height: 1.5),
            ),
          ),
        if (!isLoading && summary.isEmpty)
          const Text(
            'Henüz özetlenmiş bir metin bulunmamaktadır.',
            style: TextStyle(color: Colors.grey),
          ),
      ],
    ),
  );
}

Widget buildHistoryTab(List<Summary> summaryHistory) {
  if (summaryHistory.isEmpty) {
    return const Center(
      child: Text("Özet geçmişiniz burada görünecek."),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: summaryHistory.length,
    itemBuilder: (context, index) {
      final item = summaryHistory[index];
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: ExpansionTile(
          title: Text("Özet ${index + 1}",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Girdi:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(item.input, style: const TextStyle(color: Colors.black87)),
                  const SizedBox(height: 12),
                  const Text("Çıktı:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(item.output, style: const TextStyle(color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
