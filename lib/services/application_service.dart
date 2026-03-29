import '../models/application_model.dart';

class ApplicationService {
  static final ApplicationService _instance = ApplicationService._internal();
  factory ApplicationService() => _instance;
  ApplicationService._internal();

  final List<Application> _apps = [];

  List<Application> get apps => _apps;

  void apply(String company) {
    if (_apps.any((e) => e.company == company)) return;
    _apps.add(Application(company: company));
  }

  void updateStatus(int index, String status) {
    _apps[index].status = status;
  }
}