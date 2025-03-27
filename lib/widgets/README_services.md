Purpose:
Handles external services like API calls, authentication, and database interactions.

Structure:

api_service.dart – Handles API requests.

auth_service.dart – Manages user authentication.

database_service.dart – Manages data storage (Firebase, local DB, etc.).


Example:
class ApiService {
    static Future<List<Event>> fetchEvents() async {
        // API call to fetch events
    }
}
