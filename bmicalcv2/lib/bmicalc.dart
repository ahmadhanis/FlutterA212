import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class BMIScreen extends StatelessWidget {
  const BMIScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BMI Calc'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                height: 200,
                child: Center(
                  child: Image.asset('assets/images/bmicalc.png'),
                )),
            Container(child: BmiForm()),
          ]),
        ),
      ),
    );
  }
}

class BmiForm extends StatefulWidget {
  const BmiForm({Key? key}) : super(key: key);

  @override
  State<BmiForm> createState() => _BmiFormState();
}

class _BmiFormState extends State<BmiForm> {
  TextEditingController heightEditingController = TextEditingController();
  TextEditingController weightEditingController = TextEditingController();
  double height = 0.0, weight = 0.0, bmi = 0.0;
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "BMI Calculator",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: heightEditingController,
            keyboardType: const TextInputType.numberWithOptions(),
            decoration: InputDecoration(
                hintText: "Height in Meter",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: weightEditingController,
            keyboardType: const TextInputType.numberWithOptions(),
            decoration: InputDecoration(
                hintText: "Weight in Kg",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: _bmiCalc, child: const Text("Calculate BMI")),
          const SizedBox(height: 10),
          Text(
            "Your BMI " + bmi.toStringAsPrecision(3),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _bmiCalc() {
    height = double.parse(heightEditingController.text);
    weight = double.parse(weightEditingController.text);
    setState(() {
      bmi = weight / (height * height);
      loadOk();
    });
  }

  Future loadOk() async {
    audioPlayer = await AudioCache().play("audios/fail.wav");
  }

}
