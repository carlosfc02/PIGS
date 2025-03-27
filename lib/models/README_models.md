Purpose:
This folder contains all the data models used throughout the app. Each model represents a data 
structure and includes serialization methods when needed.

Structure:

event.dart – Represents an event.

user.dart – Represents a user.

message.dart – Represents a chat message.

Example:
class Event {
    final String id;
    final String name;
    final String date;
    final String location;
    
    Event({required this.id, required this.name, required this.date, required this.location});
}