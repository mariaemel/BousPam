import 'package:flutter/material.dart';

class ToggleButtonsContainer extends StatelessWidget {
  final bool isRegistrationSelected;
  final ValueChanged<bool> onToggle;

  const ToggleButtonsContainer({
    required this.isRegistrationSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Color(0xFF30262F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          buildToggleButton('Registration', true),
          buildToggleButton('Login', false),
        ],
      ),
    );
  }

  Widget buildToggleButton(String text, bool isSelectedTab) {
    bool isSelected = isRegistrationSelected == isSelectedTab;

    return Expanded(
      child: GestureDetector(
        onTap: () => onToggle(isSelectedTab),
        child: FractionallySizedBox(
          widthFactor: isSelected ? 0.9 : 1.0,
          child: Container(
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF8B7B89) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
