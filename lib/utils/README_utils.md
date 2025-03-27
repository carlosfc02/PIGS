Purpose:
Contains utility functions and helper classes used across the app.

Structure:

date_utils.dart – Functions to format dates.

string_utils.dart – String manipulation helpers.

constants.dart – Global constants.

Example:
class DateUtils {
    static String formatDate(DateTime date) {
        return "${date.day}/${date.month}/${date.year}";
    }
}