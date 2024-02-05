import 'package:appointment_booking_1/providers/theme_change_provider.dart';
import 'package:appointment_booking_1/routes/app_navigation.dart';
import 'package:appointment_booking_1/utils/app_colors.dart';
import 'package:appointment_booking_1/utils/app_constants.dart';
import 'package:appointment_booking_1/utils/utils.dart';
import 'package:appointment_booking_1/widgets/log_out_button.dart';
import 'package:appointment_booking_1/widgets/theme_change_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientDashboard extends StatefulWidget {
  final String? userId;
  const PatientDashboard({
    super.key,
    required this.userId,
  });

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  TextEditingController patientNameController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(
                  fontSize: 24,
                  color: AppColors.whiteTextColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              ' ${widget.userId}',
              style: const TextStyle(
                  fontSize: 14, color: AppColors.subtitleTextColo),
            )
          ],
        ),
        actions: [
          const ThemeChangerButton(),
          LogOut(),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
              stream: appointments
                  .where('appointmentDay', isEqualTo: DateTime.now().day)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  int hours = 0;
                  int mins = 0;
                  int apNum = AppConstants.maxAppointments;
                  int? currentAppointment = 0;

                  for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[i];

                    if (documentSnapshot['id'] == widget.userId &&
                        documentSnapshot['appointmentNumber'] < apNum &&
                        documentSnapshot['status'] == 'awaiting' &&
                        documentSnapshot['appointmentHour'] >=
                            DateTime.now().hour) {
                      if (documentSnapshot['appointmentHour'] ==
                              DateTime.now().hour &&
                          documentSnapshot['appointmentMins'] >
                              DateTime.now().minute) {
                        apNum = documentSnapshot['appointmentNumber'];
                        hours = documentSnapshot['appointmentHour'] -
                            DateTime.now().hour;
                        mins = documentSnapshot['appointmentMins'] -
                            DateTime.now().minute;
                      } else {
                        apNum = documentSnapshot['appointmentNumber'];
                        hours = documentSnapshot['appointmentHour'] -
                            DateTime.now().hour -
                            1;
                        mins = documentSnapshot['appointmentMins'] -
                            DateTime.now().minute +
                            60;
                      }
                    }
                    if (documentSnapshot['appointmentNumber'] < apNum &&
                        documentSnapshot['status'] == 'checking') {
                      currentAppointment =
                          documentSnapshot['appointmentNumber'];
                    }
                  }
                  return Column(
                    children: [
                      Center(
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 150,
                            child: Column(
                              children: [
                                const Text(
                                  'Appointment',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  '$currentAppointment',
                                  style: const TextStyle(fontSize: 50),
                                ),
                                const Text(
                                  'InProcess',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          child: Column(
                            children: [
                              const Text(
                                'Your turn will come after',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '$hours : $mins',
                                style: const TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'Your Appointments',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                  left: 20, top: 5, right: 20, bottom: 30),
              height: 1000,
              width: double.infinity,

              child: StreamBuilder(
                stream: appointments
                    .where('id', isEqualTo: widget.userId)
                    .where('appointmentDay', isEqualTo: DateTime.now().day)
                    .where('appointmentMonth', isEqualTo: DateTime.now().month)
                    // .where('appointmentHour',
                    //     isGreaterThanOrEqualTo: AppConstants.clinicStartTime)
                    // .where('appointmentHour',
                    //     isLessThan: AppConstants.clinicEndTime)
                    // .orderBy('appointmentNumber')
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

                        return (documentSnapshot['status'] == 'awaiting')
                            ? Card(
                                color: themeChanger.themeMode == ThemeMode.light
                                    ? AppColors.cardLightThemeColor
                                    : AppColors.cardDarkThemeColor,
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${documentSnapshot['appointmentNumber']}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: AppColors.whiteTextColor),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                      'Patient Name: ${documentSnapshot['patientName']}'),
                                  subtitle: Text(
                                      "Appointment Time ${documentSnapshot['appointmentHour']} : ${documentSnapshot['appointmentMins']}\nStatue : ${documentSnapshot['status']}"),
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
              // ],
              // ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (DateTime.now().weekday == DateTime.sunday) {
            showAlertDialog(context, "Clinic is close today.");
          } else {
            _create();
          }
        },
        tooltip: 'Book Appointment',
        child: const Icon(Icons.add),
      ),
    );
  }

  showAlertDialog(BuildContext context, String? msg) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        AppNavigation.goBack();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Appointment Booking Alert"),
      content: Text('$msg'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    int? appointmentsCount;
    final _formKey = GlobalKey<FormState>();
    FirebaseFirestore.instance
        .collection("appointments")
        .where('appointmentDay', isEqualTo: DateTime.now().day)
        .count()
        .get()
        .then(
      (res) {
        appointmentsCount = res.count != null ? res.count! + 1 : 1;
      },
      onError: (e) {
        Utils().toastMessage('Error completing: $e');
      },
    );

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: patientNameController,
                    decoration:
                        const InputDecoration(labelText: 'Patient Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Name';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Book'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final String? patientName = patientNameController.text;

                      int min = ((appointmentsCount! % 6) > 0 &&
                              (appointmentsCount! % 6) < 6)
                          ? (appointmentsCount! % 6) * 10
                          : 0;
                      int hours = (appointmentsCount! ~/ 6).toInt() +
                          AppConstants.clinicStartTime;

                      if (patientName != null) {
                        if (appointmentsCount! <=
                                AppConstants.maxAppointments &&
                            hours >= AppConstants.clinicStartTime &&
                            hours < AppConstants.clinicEndTime &&
                            DateTime.now().hour < AppConstants.bookingEndTime &&
                            DateTime.now().hour >=
                                AppConstants.bookingStartTime) {
                          // Persist a new product to Firestore
                          await appointments.add({
                            "patientName": patientName,
                            'id': widget.userId,
                            'appointmentNumber': appointmentsCount,
                            'appointmentHour':
                                (DateTime.now().hour <= hours) ? hours : 0,
                            'appointmentMins':
                                (DateTime.now().hour <= hours) ? min : 0,
                            'appointmentDay': DateTime.now().day,
                            'appointmentMonth': DateTime.now().month,
                            'status': 'awaiting',
                          });
                          Utils().toastMessage('Your appointment is booked.');
                        } else {
                          Utils().toastMessage(
                              'Sorry\nAppointment booking is closed now.');
                        }

                        // Clear the text fields
                        patientNameController.text = '';

                        AppNavigation.goBack();
                      }
                    }
                  },
                )
              ],
            ),
          );
        });
  }
}
