import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:brightness_volume/brightness_volume.dart';

class blkScreen extends StatefulWidget {
  const blkScreen({Key? key}) : super(key: key);

  @override
  State<blkScreen> createState() => _blkScreenState();
}

class _blkScreenState extends State<blkScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Wakelock.enable();
    BVUtils.setBrightness(0);
    BVUtils.setVolume(0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(backgroundColor: Colors.black),
    );
  }
}
