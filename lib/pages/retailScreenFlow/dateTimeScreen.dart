import 'package:flutter/material.dart';
import 'package:go_eat_e_commerce_app/pages/retailScreenFlow/summaryScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constant.dart';
import '../../helper_class_snackbar.dart';
import '../../models/OrderData.dart';


class DateTimeScreen extends StatefulWidget {
  final OrderData? orderData;
  const DateTimeScreen({
    super.key,
    this.orderData,
  });
  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  TimeOfDay? earliestTime;
  TimeOfDay? latestTime;

  TimeOfDay nowTime = TimeOfDay.now();

  String selectedDate = "";

  @override
  void initState() {
    super.initState();

    //selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    _selectedDay = DateTime.now();   // 👈 Default selected day = today
    selectedDate = DateFormat('dd-MM-yyyy').format(_selectedDay!);

    debugPrint("=====date_time=${widget.orderData!.driverAide}");
    debugPrint("=====date_time1=${widget.orderData!.vehicleType}");
    debugPrint("=====date_time2=${_selectedDay}");
    debugPrint("=====date_time3=${selectedDate}");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        title: Text(
          "Date & Time",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // ---------- CALENDAR CONTAINER ----------
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColor.borderColor),
              ),
              padding: const EdgeInsets.all(6),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2030),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                  weekendStyle: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),

                // MONTH HEADER STYLE
                headerStyle: HeaderStyle(
                  titleTextStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  formatButtonVisible: false,
                  leftChevronIcon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.black),
                  ),
                  rightChevronIcon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chevron_right, color: Colors.black),
                  ),
                  headerPadding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // DATE SELECTION
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                    selectedDate = DateFormat('dd-MM-yyyy').format(_selectedDay!);
                    debugPrint("=====date=${DateFormat('dd-MM-yyyy').format(_selectedDay!)}");
                    debugPrint("=====date_time2=${selectedDate}");
                  });
                },

                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  defaultTextStyle: GoogleFonts.poppins(fontSize: 14),
                  weekendTextStyle: GoogleFonts.poppins(fontSize: 14),

                  // SELECTED DATE STYLE
                  selectedDecoration: BoxDecoration(
                    color: Colors.tealAccent.shade400,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),

                  // TODAY STYLE
                  todayDecoration: BoxDecoration(
                    color: Colors.tealAccent.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: GoogleFonts.poppins(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------- TIME PICKER BUTTONS ----------
            Row(
              children: [
                Expanded(
                  child: _timeButton(
                    earliestTime == null
                        ? "Earliest Pickup Time"
                        : earliestTime!.format(context),
                    pickEarliestTime,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "To",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: _timeButton(
                    latestTime == null
                        ? "Latest Pickup Time"
                        : latestTime!.format(context),
                    pickLatestTime,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ---------- NEXT BUTTON ----------
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {

                  if (earliestTime == null) {
                    AppSnackBar.error1(context, "Please select Earliest Pickup Time");
                    return;
                  }

                  final updatedOrder = widget.orderData!.copyWith(
                    date: selectedDate,
                    startTime: formatTimeOfDay(earliestTime),
                    endTime: formatTimeOfDay(latestTime),
                  );
                  Helper.moveToScreenwithPush(context, SummaryScreen(orderData: updatedOrder));
                },
                child: Text(
                  "Next",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColor.secondaryColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // REUSABLE TIME BUTTON
  Widget _timeButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.primaryColor),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,fontWeight: FontWeight.w400,
                color: AppColor.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickEarliestTime() async {
    final DateTime today = DateTime.now();
    final DateTime selected = _selectedDay ?? today;

    TimeOfDay initialTime =
    isSameDate(today, selected) ? nowTime : const TimeOfDay(hour: 8, minute: 0);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked == null) return;

    // If today → cannot pick past time
    /*if (isSameDate(today, selected)) {
      // final now = DateTime.now();
      // final pickedDT = DateTime(selected.year, selected.month, selected.day, picked.hour, picked.minute);
      // debugPrint("📦 date_time_0: $now");
      // debugPrint("📦 date_time_1: $pickedDT");
      // if (pickedDT.isBefore(now)) {
      //   _showDialog("Please select valid time");
      //   return;
      // }
      final now = DateTime.now();
      final current = DateTime(selected.year, selected.month, selected.day, now.hour, now.minute);
      final pickedDT = DateTime(selected.year, selected.month, selected.day, picked.hour, picked.minute);

      debugPrint("📦 current_filtered: $current");
      debugPrint("📦 pickedDT: $pickedDT");

      if (pickedDT.isBefore(current)) {
        _showDialog("Please select valid time");
        return;
      }
    }*/

    // Check allowed time range
    if (!isValidTime(picked)) {
      _showDialog("Please select time 8 AM to 8 PM");
      return;
    }

    setState(() {
      earliestTime = picked;
      // Calculate Latest time = earliest + 30 min
      final dt = DateTime(0, 0, 0, picked.hour, picked.minute).add(const Duration(minutes: 30));
      latestTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
    });
  }

  Future<void> pickLatestTime() async {

    //_showDialog("Please select earliest pickup time");

    // if (earliestTime == null) {
    //   _showDialog("Select Earliest Time first");
    //   return;
    // }
    //
    // TimeOfDay initial = latestTime ?? earliestTime!;
    //
    // final TimeOfDay? picked = await showTimePicker(
    //   context: context,
    //   initialTime: initial,
    // );
    //
    // if (picked == null) return;
    //
    // // Time range check
    // if (!isValidTime(picked)) {
    //   _showDialog("Please select time 8 AM to 8 PM");
    //   return;
    // }
    //
    // setState(() {
    //   latestTime = picked;
    // });

  }

  bool isValidTime(TimeOfDay time) {
    // Allow only between 8 AM and 8 PM
    if (time.hour < 8 || time.hour > 20) return false;

    // Disallow 20:01+
    if (time.hour == 20 && time.minute > 0) return false;

    return true;
  }

  bool isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year &&
        d1.month == d2.month &&
        d1.day == d2.day;
  }

  // Convert TimeOfDay to formatted string
  String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return "";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt); // 24-hour format
    // return DateFormat('hh:mm a').format(dt); // 12-hour format if you prefer
  }

  void _showDialog(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Validation"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

}
