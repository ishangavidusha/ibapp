import 'package:flutter/cupertino.dart';
import 'package:ibapp/models/employee.dart';
import 'package:ibapp/service/supabase.dart';

class EmployeeService with ChangeNotifier {
  DataBaseService dataBaseService = DataBaseService();
  List<Employee> _employees = [];
  bool _loading = false;

  List<Employee> get employees {
    _employees.sort((a, b) => a.name.compareTo(b.name));
    return _employees;
  }
  bool get loading => _loading;

  Future<bool> addNewEmployee(CreateEmployee createEmployee) async {
    _setLoading(true);
    bool result = await dataBaseService.addNewEmployee(createEmployee);
    await fetchEmployees(notify: false);
    _setLoading(false);
    return result;
  } 
  
  Future<bool> updateEmployee(UpdateEmployee updateEmployee, String id) async {
    _setLoading(true);
    bool result = await dataBaseService.updateEmployee(id, updateEmployee);
    await fetchEmployees(notify: false);
    _setLoading(false);
    return result;
  }
  
  Future<bool> deleteEmployee(String id) async {
    _employees.removeWhere((e) => e.id == id);
    _setLoading(true);
    bool result = await dataBaseService.deleteById(id);
    await fetchEmployees(notify: false);
    _setLoading(false);
    return result;
  }

  Future<void> fetchEmployees({bool notify = true}) async {
    List<dynamic> data = await dataBaseService.getEmployees();
    _employees = data.map((e) => Employee.fromMap(e)).toList();
    if (notify) {
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
