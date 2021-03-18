class SubjectModel {
  int period;
  int dayNum;
  String dayKanji;
  String periodString;
  String name;
  String faculty;
  String university;
  String teacher;
  String subjectID;
  String createdBy;
  String place;
  SubjectModel({
    int period,
    int dayNum,
    String name,
    String faculty,
    String university,
    String teacher,
    String subjectID,
    String createdBy,
    String place,
  }){
    this.period = period;
    this.periodString = period.toString();
    this.dayNum = dayNum;
    this.name = name;
    this.faculty = faculty;
    this.university = university;
    this.teacher = teacher;
    this.subjectID = subjectID;
    this.createdBy = createdBy;
    this.place = place;
    switch(dayNum){
      case 0:
        this.dayKanji = '月';
        break;
      case 1:
        this.dayKanji = '火';
        break;
      case 2:
        this.dayKanji = '水';
        break;
      case 3:
        this.dayKanji = '木';
        break;
      case 4:
        this.dayKanji = '金';
        break;
      case 5:
        this.dayKanji = '土';
        break;
      default:
        break;
    }
  }
}