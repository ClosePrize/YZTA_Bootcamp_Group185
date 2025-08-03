import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gemini_service.dart';
import 'db_helper.dart';
import 'summary_model.dart';
import 'widgets.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  String _summary = '';
  bool _isLoading = false;
  int _currentIndex = 0;
  late final PageController _controller;

  final List<Summary> _summaryHistory = [];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _loadHistoryFromDB();
  }

  Future<void> _loadHistoryFromDB() async {
    final summaries = await DBHelper.getAllSummaries();
    setState(() => _summaryHistory.addAll(summaries));
  }

  Future<void> _summarize() async {
    final inputText = _textController.text.trim();
    if (inputText.isEmpty) return;

    setState(() {
      _isLoading = true;
      _summary = '';
    });

    try {
      final result = await GeminiService.summarizeText(inputText);

      final newSummary = Summary(input: inputText, output: result);
      await DBHelper.insertSummary(newSummary);

      setState(() {
        _summary = result;
        _summaryHistory.insert(0, newSummary);
      });
    } catch (e) {
      setState(() => _summary = 'Bir hata oluştu: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Tıbbi Not Özetleyici',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: _currentIndex == 0
          ? buildSummarizerTab(
        textController: _textController,
        isLoading: _isLoading,
        summary: _summary,
        onSummarize: _summarize,
      )
          : buildHistoryTab(_summaryHistory),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            _controller.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          backgroundColor: Colors.white,
          elevation: 10,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.text_snippet_outlined),
              label: 'Özetle',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Özetlerim',
            ),
          ],
        ),
      ),
    );
  }
}
