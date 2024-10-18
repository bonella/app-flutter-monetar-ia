import 'package:flutter/material.dart';
import 'package:monetar_ia/components/buttons/search_button.dart';
import 'package:monetar_ia/components/buttons/pdf_button.dart';

class HeaderAdd extends StatefulWidget {
  final String month;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final Color backgroundColor;
  final IconData circleIcon;
  final Color circleIconColor;
  final Color circleBackgroundColor;
  final String label;
  final String value;
  final Function(DateTime) onDateChanged;
  final Function(String) onSearchGoals;

  const HeaderAdd({
    super.key,
    required this.month,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.backgroundColor,
    required this.circleIcon,
    required this.circleIconColor,
    required this.circleBackgroundColor,
    required this.label,
    required this.value,
    required this.onDateChanged,
    required this.onSearchGoals,
  });

  @override
  _HeaderAddState createState() => _HeaderAddState();
}

class _HeaderAddState extends State<HeaderAdd> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchField = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 36.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: widget.onPrevMonth,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    widget.month,
                    style: const TextStyle(
                      fontFamily: 'Kumbh Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                      color: Color(0xFFFFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: widget.onNextMonth,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(
                        widget.circleIcon,
                        color: widget.circleIconColor,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.label,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            widget.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, bottom: 10.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_showSearchField)
                    Expanded(
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.only(left: 16, right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: const Border(
                            left: BorderSide(color: Colors.white, width: 2),
                            bottom: BorderSide(color: Colors.white, width: 2),
                            // right: BorderSide(color: Colors.white, width: 2),
                            // top: BorderSide(color: Color(0xFF003566), width: 2),
                          ),
                          // color: Colors.white,
                        ),
                        child: TextField(
                          controller: _searchController,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Buscar metas',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                          ),
                          onChanged: (value) {
                            widget.onSearchGoals(value);
                          },
                        ),
                      ),
                    ),
                  SearchButton(
                    icon: _showSearchField ? Icons.close : Icons.search,
                    onPressed: () {
                      setState(() {
                        _showSearchField = !_showSearchField;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  PdfButton(
                    onPressed: () {
                      // Ação para o botão de gerar relatório
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
