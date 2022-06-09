import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class navigationScreen extends StatefulWidget {
  const navigationScreen(
      {Key? key,
      required this.uid,
      required this.lati,
      required this.longi,
      required this.name,
      required this.age,
      required this.address,
      required this.email,
      required this.imeiNum,
      required this.mobileModel})
      : super(key: key);
  final String uid;
  final double lati, longi;
  final String name, age, address, email, imeiNum, mobileModel;

  @override
  State<navigationScreen> createState() => _navigationScreenState();
}

class _navigationScreenState extends State<navigationScreen> {
  late GoogleMapController _controller;
  late String _name, _age, _address, _email, _imeiNum, _mobileModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocation();
    fetchUserDetails();
  }

  fetchLocation() {
    FirebaseFirestore.instance
        .collection('Emergency')
        .doc(widget.uid)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<double, dynamic> firestoreInfo =
          documentSnapshot.data()! as Map<double, dynamic>;
    }).onError((e) => print(e));
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final CameraPosition _initialPosition =
        CameraPosition(target: LatLng(widget.lati, widget.longi));
    final List<Marker> markers = [];
    markers.add(
      Marker(
          markerId: MarkerId('Location'),
          position: LatLng(widget.lati, widget.longi)),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Name : " +
                              widget.name +
                              "\n" +
                              "Age : " +
                              widget.age +
                              "\n" +
                              "From : " +
                              widget.address +
                              "\n" +
                              "Email : " +
                              widget.email +
                              "\n" +
                              "IMEI number : " +
                              widget.imeiNum +
                              "\n" +
                              "Mobile Model : " +
                              widget.mobileModel +
                              "\n"
                                  "\n",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 160,
                ),
              ),
              Container(
                height: 580,
                width: double.infinity,
                child: GoogleMap(
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  initialCameraPosition: _initialPosition,
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(markers),
                  onMapCreated: (controller) {
                    setState(() {
                      _controller = controller;
                    });
                  },
                  onTap: (coordinate) {
                    _controller
                        .animateCamera(CameraUpdate.newLatLng(coordinate));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  fetchUserDetails() {
    FirebaseFirestore.instance
        .collection('Emergency')
        .doc(widget.uid)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreInfo =
          documentSnapshot.data()! as Map<String, dynamic>;
      setState(() {
        _name = firestoreInfo['name'];
        _age = firestoreInfo['age'];
        _address = firestoreInfo['address'];
        _email = firestoreInfo['email'];
        _imeiNum = firestoreInfo['imei'];
        _mobileModel = firestoreInfo['mobileModel'];
      });
    }).onError((e) => print(e));
  }
}
