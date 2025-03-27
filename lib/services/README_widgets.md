Purpose:
Contains reusable UI components such as buttons, cards, or list items.

Structure:

event_card.dart – Widget to display an event summary.

custom_button.dart – Reusable button component.

avatar.dart – Circular avatar widget for user profiles.

Example:
class CustomButton extends StatelessWidget {
    final String text;
    final VoidCallback onPressed;
    
    CustomButton({required this.text, required this.onPressed});
    
    @override
    Widget build(BuildContext context) {
        return ElevatedButton(
            onPressed: onPressed,
            child: Text(text),
        );
    }
}