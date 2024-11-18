import 'package:flutter/material.dart';
import 'package:monetar_ia/components/buttons/search_button.dart';
import 'package:monetar_ia/components/buttons/pdf_button.dart';

class HeaderAdd extends StatefulWidget {
  final String month;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final Color backgroundColor;
  final String? imagePath;
  final Color circleIconColor;
  final Color circleBackgroundColor;
  final String label;
  final String value;
  final Function(DateTime) onDateChanged;
  final Function(String) onSearch;

  const HeaderAdd({
    super.key,
    required this.month,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.backgroundColor,
    this.imagePath,
    required this.circleIconColor,
    required this.circleBackgroundColor,
    required this.label,
    required this.value,
    required this.onDateChanged,
    required this.onSearch,
  });

  @override
  _HeaderAddState createState() => _HeaderAddState();
}

class _HeaderAddState extends State<HeaderAdd> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchField = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.backgroundColor.withOpacity(0.7),
                  widget.backgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'lib/assets/logo2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Monetar.IA',
                      style: TextStyle(
                        fontFamily: 'Kumbh Sans',
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () async {
                        DateTime? selected = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                        );
                        if (selected != null && selected != _selectedDate) {
                          setState(() {
                            _selectedDate = selected;
                          });
                          widget.onDateChanged(selected);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: const TextStyle(
                            fontFamily: 'Kumbh Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: Color(0xFFFFFFFF),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
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
                        if (widget.imagePath != null)
                          Image.asset(
                            widget.imagePath!,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                          )
                        else
                          const SizedBox(width: 52, height: 52),
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
                    )
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
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Buscar',
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                            ),
                            onChanged: (value) {
                              widget.onSearch(value);
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
        ],
      ),
    );
  }
}
