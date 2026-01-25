import 'package:file_picker/file_picker.dart' show PlatformFile;

class Task {
  final String dueDate;
  final String assignedTo;
  final String project;
  final String category;
  final String priority;
  final bool hasAttachment;
  //final List<String>? attachmentPaths; 
    final List<PlatformFile>? attachmentFiles; 

  Task({
    required this.dueDate,
    required this.assignedTo,
    required this.project,
    required this.category,
    required this.priority,
    this.hasAttachment = false,
    //this.attachmentPaths,
    this.attachmentFiles
  });
}