Purpose:
Contains all the screens (pages) of the app. Each file corresponds to a different screen, such as
the homepage, event details, or user profile.

Structure:

home_screen.dart – Main screen.

event_details_screen.dart – Displays event information.

profile_screen.dart – User profile page

Example:
class HomeScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text("Home")),
            body: Center(child: Text("Welcome to the app!")),
        );
    }
}