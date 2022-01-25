import 'package:flutter/material.dart';
import 'package:ibapp/models/employee.dart';
import 'package:ibapp/service/supabase.dart';
import 'package:ibapp/utils/app_theme.dart';
import 'package:ibapp/utils/common.dart';
import 'package:ibapp/utils/duration_picker.dart';
import 'package:ibapp/utils/size.dart';
import 'package:ibapp/utils/snack_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';


class WorkingDaysPage extends StatefulWidget {
  final Employee employee;
  const WorkingDaysPage({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  _WorkingDaysPageState createState() => _WorkingDaysPageState();
}

class _WorkingDaysPageState extends State<WorkingDaysPage> {
  late Employee _employee;
  DataBaseService dataBaseService = DataBaseService();
  late DateTime focusedDay;
  late DateTime selectedDate;
  List<WorkingDay> currentMonthWorkingDays = [];
  bool isLoading = false;
  double totalNormalHours = 0;
  double totalOtHours = 0;
  double totalHours = 0;
  double totalNormalWage = 0;
  double totalOtWage = 0;
  double totalWage = 0;

  @override
  void initState() {
    _employee = widget.employee;
    focusedDay = DateTime.now();
    selectedDate = DateTime.now();
    getWorkingDaysOfEmployee(_employee.id);
    super.initState();
  }

  Future<void> getWorkingDaysOfEmployee(String id, {DateTime? startDate, DateTime? endDate}) async {
    setState(() {
      currentMonthWorkingDays.clear();
      isLoading = true;
    });
    List<dynamic> data = await dataBaseService.getWorkingDays(id, startDate: startDate, endDate: endDate);
    setState(() {
      isLoading = false;
    });
    List<WorkingDay> workingDays = data.map((e) => WorkingDay.fromMap(e)).toList();
    setState(() {
      currentMonthWorkingDays.addAll(workingDays);
    });
    totalNormalHours = 0;
    totalOtHours = 0;
    for (var day in currentMonthWorkingDays) {
      totalNormalHours += day.hours;
      totalOtHours += day.otHours;
    }
    totalHours = totalNormalHours + totalOtHours;
    totalNormalWage = totalNormalHours * _employee.hourlyRate;
    totalOtWage = totalOtHours * _employee.otRate;
    totalWage = totalNormalWage + totalOtWage;
    setState(() {
      
    });
  }

  Future<void> addNewWorkingDay(CreateWorkingDay createWorkingDay) async {
    setState(() {
      isLoading = true;
    });
    bool result = await dataBaseService.addWorkingDay(createWorkingDay);
    setState(() {
      isLoading = false;
    });
    if (result) {
      getWorkingDaysOfEmployee(_employee.id);
      AppSnackBar.success("New working day added");
    } else {
      AppSnackBar.error("Error adding working day");
    }
  }
  
  Future<void> updateThisWorkingDay(UpdateWorkingDay updateWorkingDay, String dayId) async {
    setState(() {
      isLoading = true;
    });
    bool result = await dataBaseService.updateWorkingDay(updateWorkingDay, dayId);
    setState(() {
      isLoading = false;
    });
    if (result) {
      getWorkingDaysOfEmployee(_employee.id);
      AppSnackBar.success("Working day updated");
    } else {
      AppSnackBar.error("Error updating working day");
    }
  }
  
  Future<void> deleteWorkingDay(String dayId) async {
    setState(() {
      isLoading = true;
    });
    bool result = await dataBaseService.deleteByWorkingDay(dayId);
    setState(() {
      isLoading = false;
    });
    if (result) {
      getWorkingDaysOfEmployee(_employee.id);
      AppSnackBar.success("Working day deleted");
    } else {
      AppSnackBar.error("Error deleting working day");
    }
  }

  WorkingDay? getCurrentWorkingDay() {
    for (var day in currentMonthWorkingDays) {
      if (isSameDay(selectedDate, day.date)) {
        return day;
      }
    }
    return null;
  }

  void onPageChange(DateTime dateTime) async {
    DateTime startDate = DateTime(dateTime.year, dateTime.month, 1);
    DateTime endDate = DateTime(dateTime.year, dateTime.month, 0).add(Duration(days: DateUtils.getDaysInMonth(dateTime.year, dateTime.month)));
    await Future.delayed(const Duration(milliseconds: 200));
    getWorkingDaysOfEmployee(_employee.id, startDate: startDate, endDate: endDate);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Working Days",
        ),
      ),
      backgroundColor: appTheme.background,
      body: Stack(
        children: [
          Positioned(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  verticalSpace(value: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            _employee.name,
                            style: TextStyle(
                              fontSize: 18,
                              color: appTheme.secondaryText,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Text(
                          _employee.phoneNumber,
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Table(
                      border: TableBorder.all(color: appTheme.secondaryText),
                      children: [
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "This month",
                                style: TextStyle(
                                  color: appTheme.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Normal",
                                style: TextStyle(
                                  color: appTheme.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "OT",
                                style: TextStyle(
                                  color: appTheme.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Total",
                                style: TextStyle(
                                  color: appTheme.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ]
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Hours",
                                style: TextStyle(
                                  color: appTheme.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                totalNormalHours.toStringAsFixed(2),
                                style: TextStyle(
                                  color: appTheme.secondaryText,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                totalOtHours.toStringAsFixed(2),
                                style: TextStyle(
                                  color: appTheme.secondaryText,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                totalHours.toStringAsFixed(2),
                                style: TextStyle(
                                  color: appTheme.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ]
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Wage",
                                style: TextStyle(
                                  color: appTheme.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                totalNormalWage.toStringAsFixed(2),
                                style: TextStyle(
                                  color: appTheme.secondaryText,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                totalOtWage.toStringAsFixed(2),
                                style: TextStyle(
                                  color: appTheme.secondaryText,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                totalWage.toStringAsFixed(2),
                                style: TextStyle(
                                  color: appTheme.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ]
                        ),
                      ],
                    )
                  ),
                  Center(
                    child: TableCalendar<WorkingDay>(
                      firstDay: DateTime.now().subtract(const Duration(days: 180)),
                      lastDay: DateTime.now().add(const Duration(days: 90)),
                      focusedDay: focusedDay,
                      currentDay: selectedDate,
                      onDaySelected: (_selectedDay, _focusedDay) {
                        setState(() {
                          selectedDate = _selectedDay;
                          focusedDay = _focusedDay;
                        });
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDate, day);
                      },
                      onPageChanged: (_focusedDay) {
                        focusedDay = _focusedDay;
                        onPageChange(_focusedDay);
                      },
                      eventLoader: (day) {
                        return currentMonthWorkingDays.where((element) => isSameDay(element.date, day)).toList();
                      },
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleTextStyle: TextStyle(
                          color: appTheme.secondaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left_rounded,
                          color: appTheme.secondaryText,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right_rounded,
                          color: appTheme.secondaryText,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          color: appTheme.secondaryText
                        ),
                        weekendStyle: TextStyle(
                          color: appTheme.red
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appTheme.blue
                        ),
                        selectedDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appTheme.primary
                        ),
                        defaultTextStyle: TextStyle(
                          color: appTheme.secondaryText
                        )
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        CurrentWorkingDay(
                          e: getCurrentWorkingDay(),
                          onAdd: () async {
                            CreateWorkingDay? createWorkingDay = await showCupertinoModalBottomSheet<CreateWorkingDay>(
                              context: context,
                              topRadius: const Radius.circular(20),
                              backgroundColor: appTheme.background,
                              animationCurve: Curves.fastOutSlowIn,
                              builder: (context) => SizedBox(
                                child: WorkingDayDetail(employeeId: _employee.id, selectedDate: selectedDate,),
                              )
                            );
                            if (createWorkingDay != null) {
                              addNewWorkingDay(createWorkingDay);
                            }
                          },
                          onEdit: (WorkingDay _day) async {
                            UpdateWorkingDay? updateWorkingDay = await showCupertinoModalBottomSheet<UpdateWorkingDay>(
                              context: context,
                              topRadius: const Radius.circular(20),
                              backgroundColor: appTheme.background,
                              animationCurve: Curves.fastOutSlowIn,
                              builder: (context) => SizedBox(
                                child: WorkingDayDetail(workingDay: _day, employeeId: _employee.id, selectedDate: selectedDate,),
                              )
                            );
                            if (updateWorkingDay != null) {
                              updateThisWorkingDay(updateWorkingDay, _day.id);
                            }
                          },
                          onDelete: (WorkingDay _day) {
                            deleteWorkingDay(_day.id);
                          },
                        )                        
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Column(
              children: [
                if (isLoading) LinearProgressIndicator(
                  color: appTheme.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkingDayDetail extends StatefulWidget {
  final WorkingDay? workingDay;
  final String employeeId;
  final DateTime selectedDate;
  const WorkingDayDetail({
    Key? key,
    this.workingDay,
    required this.employeeId,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<WorkingDayDetail> createState() => _WorkingDayDetailState();
}

class _WorkingDayDetailState extends State<WorkingDayDetail> {
  late DateTime date;
  late TimeOfDay startAt;
  late TimeOfDay stopAt;
  late double hours;
  late double otHours;
  late String employee;

  @override
  void initState() {
    date = widget.workingDay?.date ?? widget.selectedDate;
    startAt = widget.workingDay?.startAt ?? const TimeOfDay(hour: 8, minute: 00);
    stopAt = widget.workingDay?.stopAt ?? const TimeOfDay(hour: 17, minute: 00);
    hours = widget.workingDay?.hours ?? 8;
    otHours = widget.workingDay?.otHours ?? 0;
    employee = widget.employeeId;
    super.initState();
  }

  void updateHours() {
    int stopMinute = (stopAt.hour * 60) + stopAt.minute;
    int startMinute = (startAt.hour * 60) + startAt.minute;
    if (stopMinute > startMinute) {
      int totalMinute = stopMinute - startMinute;
      // If work start befor noon reduse lounch hour
      if (startAt.period == DayPeriod.am) {
        totalMinute = totalMinute - 60;
      }
      if (totalMinute > 480) {
        setState(() {
          hours = 8;
          otHours = (totalMinute - 480) / 60;
        });
      } else {
        setState(() {
          hours = totalMinute / 60;
          otHours = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    return Material(
      color: appTheme.background,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            verticalSpace(value: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Working Day",
                        style: TextStyle(
                          color: appTheme.secondaryText,
                          fontSize: 24,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            verticalSpace(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () async {
                    TimeOfDay? newTime = await showTimePicker(context: context, initialTime: startAt);
                    if (newTime != null) {
                      setState(() {
                        startAt = newTime;
                      });
                    }
                    updateHours();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: appTheme.surface,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Start At",
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText
                          ),
                        ),
                        Text(
                          formatTimeOfDay(startAt),
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () async {
                    TimeOfDay? newTime = await showTimePicker(context: context, initialTime: stopAt);
                    if (newTime != null) {
                      setState(() {
                        stopAt = newTime;
                      });
                    }
                    updateHours();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: appTheme.surface,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Stop At",
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText
                          ),
                        ),
                        Text(
                          formatTimeOfDay(stopAt),
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () async {
                    Duration? newDuration = await showDurationPicker(
                      context: context, 
                      initialTime: hours.toDuration(),
                    );
                    if (newDuration != null) {
                      setState(() {
                        hours = newDuration.toDouble();
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: appTheme.surface,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Normal Hours",
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText
                          ),
                        ),
                        Text(
                          hours.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () async {
                    Duration? newDuration = await showDurationPicker(
                      context: context, 
                      initialTime: otHours.toDuration(),
                    );
                    if (newDuration != null) {
                      setState(() {
                        otHours = newDuration.toDouble();
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: appTheme.surface,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "OT Hours",
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText
                          ),
                        ),
                        Text(
                          otHours.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: appTheme.secondaryText
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            verticalSpace(value: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: ElevatedButton(
                child: Text(
                  widget.workingDay != null ? "UPDATE" : "ADD",
                  style: TextStyle(
                    color: appTheme.surface,
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: appTheme.primary,
                  onPrimary: appTheme.shift(appTheme.primary, 0.2),
                  onSurface: appTheme.secondary,
                  elevation: 8.0,
                  minimumSize: Size(devWidth(context), 40),
                  shadowColor: appTheme.shift(appTheme.secondary, 0.4, stronger: true).withOpacity(0.6),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
                onPressed: () async {
                  if (widget.workingDay != null) {
                    UpdateWorkingDay updateWorkingDay = UpdateWorkingDay(
                      startAt: startAt,
                      stopAt: stopAt,
                      hours: hours,
                      otHours: otHours
                    );
                    Navigator.pop(context, updateWorkingDay);
                  } else {
                    CreateWorkingDay createWorkingDay = CreateWorkingDay(
                      date: date,
                      startAt: startAt,
                      stopAt: stopAt,
                      hours: hours,
                      otHours: otHours,
                      employee: employee
                    );
                    Navigator.pop(context, createWorkingDay);
                  }
                },
              ),
            ),
            verticalSpace(value: 40)
          ],
        ),
      ),
    );
  }
}

class CurrentWorkingDay extends StatelessWidget {
  final WorkingDay? e;
  final VoidCallback onAdd;
  final ValueChanged<WorkingDay> onEdit;
  final ValueChanged<WorkingDay> onDelete;
  const CurrentWorkingDay({
    Key? key,
    this.e,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    if (e != null) {
      return Container(
        width: devWidth(context),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
        decoration: BoxDecoration(
          color: appTheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: appTheme.primary.withAlpha(80),
            width: 0.8
          ),
          boxShadow: [
            BoxShadow(
              color: appTheme.secondary.withAlpha(16),
              blurRadius: 12,
              spreadRadius: 8,
              offset: const Offset(0, 8)
            ),
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Come At:",
                    style: TextStyle(
                      color: appTheme.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  Text(
                    formatTimeOfDay(e!.startAt),
                    style: TextStyle(
                      color: appTheme.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Leave At:",
                    style: TextStyle(
                      color: appTheme.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  Text(
                    formatTimeOfDay(e!.stopAt),
                    style: TextStyle(
                      color: appTheme.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                    ),
                  )
                ],
              ),
            ),
            Divider(color: appTheme.secondaryText,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Normal hours: ${e!.hours}",
                    style: TextStyle(
                      color: appTheme.secondaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    "|",
                    style: TextStyle(
                      color: appTheme.secondaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "OT: ${e!.otHours}",
                    style: TextStyle(
                      color: appTheme.secondaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.edit,
                    color: appTheme.blue,
                    size: 24,
                  ),
                  onPressed: () {
                    onEdit(e!);
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.delete_forever,
                    color: appTheme.red,
                    size: 24,
                  ),
                  onPressed: () {
                    onDelete(e!);
                  },
                ),
              ],
            ),
          ],
        ),
      );  
    } else {
      return Container(
        width: devWidth(context),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
        decoration: BoxDecoration(
          color: appTheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: appTheme.primary.withAlpha(80),
            width: 0.8
          ),
          boxShadow: [
            BoxShadow(
              color: appTheme.secondary.withAlpha(16),
              blurRadius: 12,
              spreadRadius: 8,
              offset: const Offset(0, 8)
            ),
          ]
        ),
        child: Center(
          child: IconButton(
            onPressed: onAdd,
            icon: Icon(
              Icons.add,
              color: appTheme.green,
              size: 24,
            ),
          ),
        ),
      );
    }
  }
}
