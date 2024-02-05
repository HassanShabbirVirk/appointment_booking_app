import 'package:appointment_booking_1/providers/date_provider.dart';
import 'package:appointment_booking_1/providers/theme_change_provider.dart';
import 'package:appointment_booking_1/utils/app_colors.dart';

import 'package:appointment_booking_1/widgets/log_out_button.dart';

import 'package:appointment_booking_1/widgets/theme_change_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final auth = FirebaseAuth.instance;
  final CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

  int? day;
  int? month;
  int? year;

  // Deleteing a product by id
  // Future<void> _deleteProduct(String productId) async {
  //   await _productss.doc(productId).delete();

  //   // Show a snackbar
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('You have successfully deleted a product')));
  // }

  Future<void> _updateStatus(
      [DocumentSnapshot? documentSnapshot, String? status]) async {
    await appointments.doc(documentSnapshot!.id).update({'status': status});
  }

  Future<void> datePicker(BuildContext context) async {
    // print('$pickedDate');
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      // Use Provider.of to get the existing instance
      DateProvider dateProvider =
          Provider.of<DateProvider>(context, listen: false);

      // Call the datePicker method on the existing instance
      dateProvider.datePicker(pickedDate);

      day = pickedDate.day;
      month = pickedDate.month;
      year = pickedDate.year;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Admin ',
          style: TextStyle(
            color: AppColors.whiteTextColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          const ThemeChangerButton(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                datePicker(context);
              },
              icon: const Icon(Icons.work_history_outlined),
              color: AppColors.whiteTextColor,
            ),
          ),
          LogOut(),
        ],
      ),
      body: Consumer<DateProvider>(builder: (ctx, value, child) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      'Appointments of the day',
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                  Center(
                      child: Text(
                    '${value.day} - ${value.month} - ${value.year}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: appointments
                    .where('appointmentDay', isEqualTo: value.day)
                    .where('appointmentMonth', isEqualTo: value.month)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        final themeChanger = Provider.of<ThemeChanger>(context);
                        return (documentSnapshot['status'] == 'awaiting' ||
                                documentSnapshot['status'] == 'checking')
                            ? Card(
                                color: documentSnapshot['status'] == 'checking'
                                    ? AppColors.inProcessCard
                                    : themeChanger.themeMode == ThemeMode.light
                                        ? AppColors.cardLightThemeColor
                                        : AppColors.cardDarkThemeColor,
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${documentSnapshot['appointmentNumber']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: AppColors.whiteTextColor),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    '${documentSnapshot['patientName']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      "Time ${documentSnapshot['appointmentHour']} : ${documentSnapshot['appointmentMins']}\nStatue : ${documentSnapshot['status']}"),
                                  trailing: SizedBox(
                                    width: 150,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (documentSnapshot['status'] ==
                                                'awaiting') {
                                              _updateStatus(
                                                  documentSnapshot, 'checking');
                                            }
                                            if (documentSnapshot['status'] ==
                                                'checking') {
                                              _updateStatus(
                                                  documentSnapshot, 'awaiting');
                                            }
                                          },
                                          icon: (documentSnapshot['status'] ==
                                                  'checking')
                                              ? const Icon(
                                                  Icons.play_arrow,
                                                  size: 30,
                                                  color: AppColors
                                                      .playAndCheckedIconColor,
                                                )
                                              : const Icon(
                                                  Icons.pause,
                                                  size: 30,
                                                  color: AppColors
                                                      .pauseAndCancleIconColor,
                                                ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _updateStatus(
                                                documentSnapshot, 'checked');
                                          },
                                          icon: const Icon(
                                            Icons.check_circle,
                                            size: 30,
                                            color: AppColors
                                                .playAndCheckedIconColor,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _updateStatus(
                                                documentSnapshot, 'inactive');
                                          },
                                          icon: const Icon(
                                            Icons.cancel,
                                            size: 30,
                                            color: AppColors
                                                .pauseAndCancleIconColor,
                                          ),
                                        ),
                                        // This icon button is used to delete a single product
                                        // IconButton(
                                        //     icon: const Icon(Icons.delete),
                                        //     onPressed: () =>
                                        //         _deleteProduct(documentSnapshot.id)),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Card(
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.inActiveCardColor,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${documentSnapshot['appointmentNumber']}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: AppColors
                                                .inActiveCardTextAndIconColor),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    'Patient Name: ${documentSnapshot['patientName']}',
                                    style: const TextStyle(
                                        color: AppColors
                                            .inActiveCardTextAndIconColor),
                                  ),
                                  subtitle: Text(
                                      "Appointment Time ${documentSnapshot['appointmentHour']} : ${documentSnapshot['appointmentMins']}\nStatue : ${documentSnapshot['status']}",
                                      style: const TextStyle(
                                          color: AppColors
                                              .inActiveCardTextAndIconColor)),
                                  trailing: IconButton(
                                    onPressed: () {
                                      _updateStatus(
                                          documentSnapshot, 'awaiting');
                                    },
                                    icon: const Icon(Icons.restore),
                                  ),
                                ),
                              );
                      },
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
