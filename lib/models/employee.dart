import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ibapp/utils/common.dart';


class Employee {
  String id;
  String name;
  String phoneNumber;
  double hourlyRate;
  double otRate;
  DateTime createdAt;
  Employee({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.hourlyRate,
    required this.otRate,
    required this.createdAt,
  });

  Employee copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    double? hourlyRate,
    double? otRate,
    DateTime? createdAt,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      otRate: otRate ?? this.otRate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'hourlyRate': hourlyRate,
      'otRate': otRate,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      hourlyRate: map['hourlyRate']?.toDouble() ?? 0.0,
      otRate: map['otRate']?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(map['created_at']) ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) => Employee.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Employee(id: $id, name: $name, phoneNumber: $phoneNumber, hourlyRate: $hourlyRate, otRate: $otRate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Employee &&
      other.id == id &&
      other.name == name &&
      other.phoneNumber == phoneNumber &&
      other.hourlyRate == hourlyRate &&
      other.otRate == otRate &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      phoneNumber.hashCode ^
      hourlyRate.hashCode ^
      otRate.hashCode ^
      createdAt.hashCode;
  }
}

class CreateEmployee {
  String name;
  String phoneNumber;
  double hourlyRate;
  double otRate;
  CreateEmployee({
    required this.name,
    required this.phoneNumber,
    required this.hourlyRate,
    required this.otRate,
  });

  CreateEmployee copyWith({
    String? name,
    String? phoneNumber,
    double? hourlyRate,
    double? otRate,
  }) {
    return CreateEmployee(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      otRate: otRate ?? this.otRate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'hourlyRate': hourlyRate,
      'otRate': otRate,
    };
  }

  factory CreateEmployee.fromMap(Map<String, dynamic> map) {
    return CreateEmployee(
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      hourlyRate: map['hourlyRate']?.toDouble() ?? 0.0,
      otRate: map['otRate']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateEmployee.fromJson(String source) => CreateEmployee.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CreateEmployee(name: $name, phoneNumber: $phoneNumber, hourlyRate: $hourlyRate, otRate: $otRate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CreateEmployee &&
      other.name == name &&
      other.phoneNumber == phoneNumber &&
      other.hourlyRate == hourlyRate &&
      other.otRate == otRate;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      phoneNumber.hashCode ^
      hourlyRate.hashCode ^
      otRate.hashCode;
  }
}

class UpdateEmployee {
  String? name;
  String? phoneNumber;
  double? hourlyRate;
  double? otRate;
  UpdateEmployee({
    this.name,
    this.phoneNumber,
    this.hourlyRate,
    this.otRate,
  });

  UpdateEmployee copyWith({
    String? name,
    String? phoneNumber,
    double? hourlyRate,
    double? otRate,
  }) {
    return UpdateEmployee(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      otRate: otRate ?? this.otRate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'hourlyRate': hourlyRate,
      'otRate': otRate,
    };
  }

  factory UpdateEmployee.fromMap(Map<String, dynamic> map) {
    return UpdateEmployee(
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      hourlyRate: map['hourlyRate']?.toDouble(),
      otRate: map['otRate']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateEmployee.fromJson(String source) => UpdateEmployee.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateEmployee(name: $name, phoneNumber: $phoneNumber, hourlyRate: $hourlyRate, otRate: $otRate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UpdateEmployee &&
      other.name == name &&
      other.phoneNumber == phoneNumber &&
      other.hourlyRate == hourlyRate &&
      other.otRate == otRate;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      phoneNumber.hashCode ^
      hourlyRate.hashCode ^
      otRate.hashCode;
  }
}

class WorkingDay {
  String id;
  DateTime date;
  TimeOfDay startAt;
  TimeOfDay stopAt;
  double hours;
  double otHours;
  String employee;
  DateTime createdAt;
  WorkingDay({
    required this.id,
    required this.date,
    required this.startAt,
    required this.stopAt,
    required this.hours,
    required this.otHours,
    required this.employee,
    required this.createdAt,
  });

  WorkingDay copyWith({
    String? id,
    DateTime? date,
    TimeOfDay? startAt,
    TimeOfDay? stopAt,
    double? hours,
    double? otHours,
    String? employee,
    DateTime? createdAt,
  }) {
    return WorkingDay(
      id: id ?? this.id,
      date: date ?? this.date,
      startAt: startAt ?? this.startAt,
      stopAt: stopAt ?? this.stopAt,
      hours: hours ?? this.hours,
      otHours: otHours ?? this.otHours,
      employee: employee ?? this.employee,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'startAt': fromTimeOfDay(startAt),
      'stopAt': fromTimeOfDay(stopAt),
      'hours': hours,
      'otHours': otHours,
      'employee': employee,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory WorkingDay.fromMap(Map<String, dynamic> map) {
    return WorkingDay(
      id: map['id'] ?? '',
      date: DateTime.tryParse(map['date']) ?? DateTime.now(),
      startAt: toTimeOfDay(map['startAt']),
      stopAt: toTimeOfDay(map['stopAt']),
      hours: map['hours']?.toDouble() ?? 0.0,
      otHours: map['otHours']?.toDouble() ?? 0.0,
      employee: map['employee'] ?? '',
      createdAt: DateTime.tryParse(map['created_at']) ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkingDay.fromJson(String source) => WorkingDay.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WorkingDay(id: $id, date: $date, startAt: $startAt, stopAt: $stopAt, hours: $hours, otHours: $otHours, employee: $employee, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is WorkingDay &&
      other.id == id &&
      other.date == date &&
      other.startAt == startAt &&
      other.stopAt == stopAt &&
      other.hours == hours &&
      other.otHours == otHours &&
      other.employee == employee &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      date.hashCode ^
      startAt.hashCode ^
      stopAt.hashCode ^
      hours.hashCode ^
      otHours.hashCode ^
      employee.hashCode ^
      createdAt.hashCode;
  }
}

class CreateWorkingDay {
  DateTime date;
  TimeOfDay startAt;
  TimeOfDay stopAt;
  double hours;
  double otHours;
  String employee;
  CreateWorkingDay({
    required this.date,
    required this.startAt,
    required this.stopAt,
    required this.hours,
    required this.otHours,
    required this.employee,
  });

  CreateWorkingDay copyWith({
    DateTime? date,
    TimeOfDay? startAt,
    TimeOfDay? stopAt,
    double? hours,
    double? otHours,
    String? employee,
  }) {
    return CreateWorkingDay(
      date: date ?? this.date,
      startAt: startAt ?? this.startAt,
      stopAt: stopAt ?? this.stopAt,
      hours: hours ?? this.hours,
      otHours: otHours ?? this.otHours,
      employee: employee ?? this.employee,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'startAt': fromTimeOfDay(startAt),
      'stopAt': fromTimeOfDay(stopAt),
      'hours': hours,
      'otHours': otHours,
      'employee': employee,
    };
  }

  factory CreateWorkingDay.fromMap(Map<String, dynamic> map) {
    return CreateWorkingDay(
      date: DateTime.tryParse(map['date']) ?? DateTime.now(),
      startAt: toTimeOfDay(map['startAt']),
      stopAt: toTimeOfDay(map['stopAt']),
      hours: map['hours']?.toDouble() ?? 0.0,
      otHours: map['otHours']?.toDouble() ?? 0.0,
      employee: map['employee'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateWorkingDay.fromJson(String source) => CreateWorkingDay.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CreateWorkingDay(date: $date, startAt: $startAt, stopAt: $stopAt, hours: $hours, otHours: $otHours, employee: $employee)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CreateWorkingDay &&
      other.date == date &&
      other.startAt == startAt &&
      other.stopAt == stopAt &&
      other.hours == hours &&
      other.otHours == otHours &&
      other.employee == employee;
  }

  @override
  int get hashCode {
    return date.hashCode ^
      startAt.hashCode ^
      stopAt.hashCode ^
      hours.hashCode ^
      otHours.hashCode ^
      employee.hashCode;
  }
}

class UpdateWorkingDay {
  TimeOfDay startAt;
  TimeOfDay stopAt;
  double hours;
  double otHours;
  UpdateWorkingDay({
    required this.startAt,
    required this.stopAt,
    required this.hours,
    required this.otHours,
  });

  UpdateWorkingDay copyWith({
    TimeOfDay? startAt,
    TimeOfDay? stopAt,
    double? hours,
    double? otHours,
  }) {
    return UpdateWorkingDay(
      startAt: startAt ?? this.startAt,
      stopAt: stopAt ?? this.stopAt,
      hours: hours ?? this.hours,
      otHours: otHours ?? this.otHours,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startAt': fromTimeOfDay(startAt),
      'stopAt': fromTimeOfDay(stopAt),
      'hours': hours,
      'otHours': otHours,
    };
  }

  factory UpdateWorkingDay.fromMap(Map<String, dynamic> map) {
    return UpdateWorkingDay(
      startAt: toTimeOfDay(map['startAt']),
      stopAt: toTimeOfDay(map['stopAt']),
      hours: map['hours']?.toDouble() ?? 0.0,
      otHours: map['otHours']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateWorkingDay.fromJson(String source) => UpdateWorkingDay.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateWorkingDay(startAt: $startAt, stopAt: $stopAt, hours: $hours, otHours: $otHours)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UpdateWorkingDay &&
      other.startAt == startAt &&
      other.stopAt == stopAt &&
      other.hours == hours &&
      other.otHours == otHours;
  }

  @override
  int get hashCode {
    return startAt.hashCode ^
      stopAt.hashCode ^
      hours.hashCode ^
      otHours.hashCode;
  }
}
