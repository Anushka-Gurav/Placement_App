class Application {
  String company;
  String status;
  String notes;

  Application({
    required this.company,
    this.status = "Applied",
    this.notes = "",
  });
}