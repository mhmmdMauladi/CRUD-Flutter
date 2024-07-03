import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_api/models/create_model.dart';
import 'package:flutter_api/models/delete_model.dart';
import 'package:flutter_api/models/doctor_model.dart';
import 'package:flutter_api/models/service_model.dart';
import 'package:flutter_api/models/update_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

var selectedService = 0;
var menus = [
  FeatherIcons.home,
  FeatherIcons.heart,
  FeatherIcons.messageCircle,
  FeatherIcons.user
];
var selectedMenu = 0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<DoctorModel>> futureDoctors;

  @override
  void initState() {
    super.initState();
    futureDoctors = fetchDoctors();
  }

  void _refreshDoctors() {
    setState(() {
      futureDoctors = fetchDoctors();
    });
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, DoctorModel doctorModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text("Konfirmasi Hapus"),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              "Apakah Anda yakin ingin menghapus data ${doctorModel.name}?",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () async {
                try {
                  await deleteDoctor(doctorModel.id);
                  _refreshDoctors(); // Panggil metode hapus API
                  Navigator.of(context).pop(); // Tutup dialog
                } catch (e) {
                  print('Error deleting doctor: $e');
                  // Tampilkan pesan kesalahan atau lakukan tindakan lain
                }
              },
              child: const Text("Iya"),
            ),
          ],
        );
      },
    );
  }

  void _showAddDoctorDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController positionController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text("Tambah Dokter"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan nama';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: positionController,
                  decoration: const InputDecoration(labelText: 'Jabatan'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan jabatan';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan alamat';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Simpan"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await addDoctor(
                      nameController.text,
                      positionController.text,
                      addressController.text,
                    );
                    _refreshDoctors(); // Refresh the list after adding a doctor
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error adding doctor: $e');
                    // Show an error message to the user
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDoctorDialog(BuildContext context, DoctorModel doctorModel) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: doctorModel.name);
    final TextEditingController positionController =
        TextEditingController(text: doctorModel.jabatan);
    final TextEditingController addressController =
        TextEditingController(text: doctorModel.alamat);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text("Edit Dokter"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan nama';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: positionController,
                  decoration: const InputDecoration(labelText: 'Jabatan'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan jabatan';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan alamat';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Simpan"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await updateDoctor(
                      doctorModel.id,
                      nameController.text,
                      positionController.text,
                      addressController.text,
                    );
                    _refreshDoctors(); // Refresh the list after editing a doctor
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error editing doctor: $e');
                    // Show an error message to the user
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _bottomNavigationBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              _greetings(),
              const SizedBox(
                height: 16,
              ),
              _card(),
              const SizedBox(
                height: 20,
              ),
              _search(),
              const SizedBox(
                height: 20,
              ),
              _services(),
              const SizedBox(
                height: 27,
              ),
              FutureBuilder<List<DoctorModel>>(
                future: futureDoctors,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No doctors found'));
                  } else {
                    return _doctors(snapshot.data!);
                  }
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDoctorDialog(context);
        },
        backgroundColor: const Color(0xFF818AF9),
        child: const Icon(
          Icons.add,
          color: Colors.white, // Mengatur warna ikon menjadi putih
        ),
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar() => BottomNavigationBar(
        selectedItemColor: const Color(0xFF818AF9),
        type: BottomNavigationBarType.fixed,
        items: menus
            .map((e) =>
                BottomNavigationBarItem(icon: Icon(e), label: e.toString()))
            .toList(),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: const Color(0xFFBFBFBF),
      );

  ListView _doctors(List<DoctorModel> doctors) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == doctors.length) {
          return const SizedBox(
              height: 80); // Adjust the height according to your needs
        }
        return _doctor(doctors[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 11,
      ),
      itemCount: doctors.length + 1,
    );
  }

  Widget _doctor(DoctorModel doctorModel) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF35385A).withOpacity(.12),
                blurRadius: 30,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: Image.asset(
                  'assets/images/${doctorModel.image}',
                  width: 88,
                  height: 103,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorModel.name,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3F3E3F),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    RichText(
                      text: TextSpan(
                        text: doctorModel.jabatan,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        const Icon(
                          FeatherIcons.mapPin,
                          size: 14,
                          color: Color(0xFFACA3A3),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          doctorModel.alamat,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: const Color(0xFFACA3A3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text(
                          "Available for",
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF50CC98),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        SvgPicture.asset('assets/svgs/cat.svg'),
                        const SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset('assets/svgs/dog.svg'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: -4,
          bottom: 30,
          child: Container(
            width: 35, // Adjust the width as needed
            height: 35, // Adjust the height as needed
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(35 / 5),
            ),
            child: Align(
              alignment: Alignment.center, // Adjust alignment as needed
              child: IconButton(
                icon: const Icon(FeatherIcons.trash, color: Colors.white),
                iconSize: 18, // Adjust the icon size as needed
                padding: EdgeInsets.zero, // Remove padding for precise control
                onPressed: () {
                  _showDeleteConfirmationDialog(context, doctorModel);
                },
              ),
            ),
          ),
        ),
        Positioned(
          right: -4,
          bottom: 80,
          child: Container(
            width: 35, // Adjust the width as needed
            height: 35, // Adjust the height as needed
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(35 / 5),
            ),
            child: Align(
              alignment: Alignment.center, // Adjust alignment as needed
              child: IconButton(
                icon: const Icon(FeatherIcons.edit, color: Colors.white),
                iconSize: 18, // Adjust the icon size as needed
                padding: EdgeInsets.zero, // Remove padding for precise control
                onPressed: () {
                  _showEditDoctorDialog(context, doctorModel);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _services() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: selectedService == index
                        ? const Color(0xFF818AF9)
                        : const Color(0xFFF6F6F6),
                    border: selectedService == index
                        ? Border.all(
                            color: const Color(0xFFF1E5E5).withOpacity(.22),
                            width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                  Service.all()[index],
                  style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: selectedService == index
                          ? Colors.white
                          : const Color(0xFF3F3E3F).withOpacity(.3)),
                )),
              ),
          separatorBuilder: (context, index) => const SizedBox(
                width: 10,
              ),
          itemCount: Service.all().length),
    );
  }

  Widget _search() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(14)),
      child: TextFormField(
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: const Icon(
              FeatherIcons.search,
              color: Color(0xFFADACAD),
            ),
            hintText: "Find best vaccinate, treatment...",
            hintStyle: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFCACACA),
                height: 150 / 100)),
      ),
    );
  }

  AspectRatio _card() {
    return AspectRatio(
      aspectRatio: 336 / 184,
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF818AF9),
        ),
        child: Stack(children: [
          Image.asset(
            'assets/images/background_card.png',
            height: double.maxFinite,
            width: double.maxFinite,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Your ",
                        style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: const Color(0xFFDEE1FE),
                            height: 150 / 100),
                        children: const [
                      TextSpan(
                          text: "Catrine ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                      TextSpan(text: "will get\nvaccination "),
                      TextSpan(
                          text: "tomorrow \nat 07.00 am!",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                    ])),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.4),
                      border: Border.all(
                          color: Colors.white.withOpacity(.12), width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "See details",
                    style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Padding _greetings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hello, Human!',
            style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF3F3E3F)),
          ),
          Stack(children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  FeatherIcons.shoppingBag,
                  color: Color(0xFF818AF9),
                )),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    color: const Color(0xFFEF6497),
                    borderRadius: BorderRadius.circular(15 / 2)),
                child: Center(
                    child: Text(
                  "2",
                  style: GoogleFonts.mPlus1p(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800),
                )),
              ),
            )
          ])
        ],
      ),
    );
  }
}
