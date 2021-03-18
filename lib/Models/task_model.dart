import 'package:campuspost/Models/subject_model.dart';

class TaskModel {
  SubjectModel _subject;
  String _taskID;
  String _name;
  String _deadline;
  String _createdBy;
  String _createdAt;
  String _detail;
  TaskModel({
    SubjectModel subject,
    String id,
    String name,
    String deadline,
    String detail,
    String createdBy,
    String createdAt,
}){
    this._subject = subject;
    this._deadline = deadline;
    this._name = name;
    this._createdAt = createdAt;
    this._createdBy = createdBy;
    this._detail = detail;
    this._taskID = id;
  }
}