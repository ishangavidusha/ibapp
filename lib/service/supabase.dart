import 'package:flutter/material.dart';
import 'package:ibapp/models/employee.dart';
import 'package:ibapp/utils/snack_bar.dart';
import 'package:supabase/supabase.dart';

class DataBaseService {
  // ignore: non_constant_identifier_names
  final EMPLOYEE_TABLE = "employees";
  // ignore: non_constant_identifier_names
  final WORKINGDAYS_TABLE = "workingdays";
  final SupabaseClient supabaseClient = SupabaseClient(
    "https://twtkbmihdnbgxcuypfmw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNjQyNzUyMzY3LCJleHAiOjE5NTgzMjgzNjd9.8l5Y1QSjWGfXN5GBDIBHLm6R1d6wDqBzL1j0EcQxA8M",
  );

  Future<List<dynamic>> getWorkingDays(String employeeId, {DateTime? startDate, DateTime? endDate}) async {
    try {
      PostgrestFilterBuilder filterBuilder = supabaseClient.from(WORKINGDAYS_TABLE).select().eq("employee", employeeId);
      if (startDate == null) {
        startDate = _getFirstDayOfMonth();
        filterBuilder.gte("date", startDate.toIso8601String());
      } else {
        filterBuilder.gte("date", startDate.toIso8601String());
      }
      if (endDate == null) {
        endDate = _getLastDayOfMonth();
        filterBuilder.lte("date", endDate.toIso8601String());
      } else {
        filterBuilder.lte("date", endDate.toIso8601String());
      }
      PostgrestResponse response = await filterBuilder.execute();
      if (response.hasError) {
        throw PostgrestError(message: response.error?.message ?? "Unknown Error");
      }
      if (response.data != null) {
        return response.data;
      } else {
        return [];
      }
    } on PostgrestError catch (e) {
      AppSnackBar.error(e.message);
      return [];
    } on Exception catch (e) {
      AppSnackBar.error(e.toString());
      return [];
    }
  }

  Future<bool> addWorkingDay(CreateWorkingDay createWorkingDay) async {
    try {
      PostgrestResponse response = await supabaseClient.from(WORKINGDAYS_TABLE).insert(createWorkingDay.toMap(), returning: ReturningOption.minimal).execute();
      if (response.hasError) {
        throw PostgrestError(message: response.error?.message ?? "Unknown Error");
      }
      return true;
    } on PostgrestError catch (e) {
      AppSnackBar.error(e.message);
      return false;
    } on Exception catch (e) {
      AppSnackBar.error(e.toString());
      return false;
    }
  }

  Future<bool> updateWorkingDay(UpdateWorkingDay updateWorkingDay, String id) async {
    try {
      PostgrestResponse response = await supabaseClient.from(WORKINGDAYS_TABLE).update(updateWorkingDay.toMap(), returning: ReturningOption.minimal).eq("id", id).execute();
      if (response.hasError) {
        throw PostgrestError(message: response.error?.message ?? "Unknown Error");
      }
      return true;
    } on PostgrestError catch (e) {
      AppSnackBar.error(e.message);
      return false;
    } on Exception catch (e) {
      AppSnackBar.error(e.toString());
      return false;
    }
  }

  Future<bool> deleteByWorkingDay(String id) async {
    try {
      PostgrestResponse response = await supabaseClient.from(WORKINGDAYS_TABLE).delete(returning: ReturningOption.minimal).eq("id", id).execute();
      if (response.hasError) {
        throw PostgrestError(message: response.error?.message ?? "Unknown Error");
      }
      return true;
    } on PostgrestError catch (e) {
      AppSnackBar.error(e.message);
      return false;
    } on Exception catch (e) {
      AppSnackBar.error(e.toString());
      return false;
    }
  }

  Future<List<dynamic>> getEmployees() async {
    try {
      PostgrestResponse response = await supabaseClient.from(EMPLOYEE_TABLE).select().execute();
      if (response.hasError) {
        throw PostgrestError(message: response.error?.message ?? "Unknown Error");
      }
      if (response.data != null) {
        return response.data;
      } else {
        return [];
      }
    } on PostgrestError catch (e) {
      AppSnackBar.error(e.message);
      return [];
    } on Exception catch (e) {
      AppSnackBar.error(e.toString());
      return [];
    }
  }
  
  Future<bool> deleteById(String id) async {
    try {
      PostgrestResponse response = await supabaseClient.from(EMPLOYEE_TABLE).delete(returning: ReturningOption.minimal).eq("id", id).execute();
      if (response.hasError) {
        throw PostgrestError(message: response.error?.message ?? "Unknown Error");
      }
      return true;
    } on PostgrestError catch (e) {
      AppSnackBar.error(e.message);
      return false;
    } on Exception catch (e) {
      AppSnackBar.error(e.toString());
      return false;
    }
  }
  
  Future<bool> addNewEmployee(CreateEmployee employee) async {
    try {
      PostgrestResponse response = await supabaseClient.from(EMPLOYEE_TABLE).insert(employee.toMap(), returning: ReturningOption.minimal).execute();
      if (response.hasError) {
        throw PostgrestError(message: response.error?.message ?? "Unknown Error");
      }
      return true;
    } on PostgrestError catch (e) {
      AppSnackBar.error(e.message);
      return false;
    } on Exception catch (e) {
      AppSnackBar.error(e.toString());
      return false;
    }
  }
  
  Future<bool> updateEmployee(String id, UpdateEmployee employee) async {
    try {
      PostgrestResponse response = await supabaseClient.from(EMPLOYEE_TABLE).update(employee.toMap(), returning: ReturningOption.minimal).eq("id", id).execute();
      if (response.hasError) {
        throw PostgrestError(message: response.error?.message ?? "Unknown Error");
      }
      return true;
    } on PostgrestError catch (e) {
      AppSnackBar.error(e.message);
      return false;
    } on Exception catch (e) {
      AppSnackBar.error(e.toString());
      return false;
    }
  }

  DateTime _getFirstDayOfMonth() {
    DateTime currentDate = DateTime.now();
    return DateTime(currentDate.year, currentDate.month, 1);
  }

  DateTime _getLastDayOfMonth() {
    DateTime currentDate = DateTime.now();
    return DateTime(currentDate.year, currentDate.month, 0).add(Duration(days: DateUtils.getDaysInMonth(currentDate.year, currentDate.month)));
  }
}