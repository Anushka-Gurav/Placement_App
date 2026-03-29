import '../models/company_model.dart';

class CompanyService {
  static final List<Company> _companies = [];

  List<Company> get companies => _companies;

  void addCompany(Company c) => _companies.add(c);

  void deleteCompany(Company c) => _companies.remove(c);
}