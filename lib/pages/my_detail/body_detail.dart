import 'dart:math';
import 'package:flutter/material.dart';

class BodyDetail extends StatefulWidget {
  final String height, weight, fat, muscle;
  BodyDetail(
      {super.key,
        required this.height,
        required this.weight,
        required this.fat,
        required this.muscle});

  @override
  State<BodyDetail> createState() => _BodyDetailState();
}

class _BodyDetailState extends State<BodyDetail> {
  double? bmi;
  double? fatMass;
  double? muscleMass;
  String errorText = '';
  String status = '';
  String status2 = '';
  String status3 = '';

  void calculateBMI() {
    final double? height = double.tryParse(widget.height);
    final double? weight = double.tryParse(widget.weight);

    if (height == null || weight == null) {
      setState(() {
        errorText = "키와 몸무게를 입력해주십시오";
      });
      return;
    }

    if (height <= 0 || weight <= 0) {
      setState(() {
        errorText = "측정할 수 없는 수치입니다";
      });
      return;
    }

    setState(() {
      bmi = weight / pow((height / 100), 2);
      if (bmi! < 18.5) {
        status = "저체중";
      } else if (bmi! > 18.5 && bmi! <= 23) {
        status = '정상 체중';
      } else if (bmi! > 23 && bmi! <= 25) {
        status = '과체중';
      } else if (bmi! > 25 && bmi! <= 30) {
        status = '비만';
      } else if (bmi! > 30) {
        status = '고도비만';
      } else {
        status = 'Obesity class 3';
      }
    });
  }

  void calculateMuscle() {
    final double? muscle = double.tryParse(widget.muscle);
    final double? weight = double.tryParse(widget.weight);

    if (muscle == null || weight == null) {
      setState(() {
        errorText = "키와 몸무게를 입력해주십시오";
      });
      return;
    }

    if (muscle <= 0 || weight <= 0) {
      setState(() {
        errorText = "측정할 수 없는 수치입니다";
      });
      return;
    }

    setState(() {
      muscleMass = muscle / weight; //골격근량 평균 계산식
      if (muscleMass! < 0.15) {
        status2 = "매우낮음";
      } else if (muscleMass! > 0.15 && muscleMass! <= 0.25) {
        status2 = '낮음';
      } else if (muscleMass! > 0.25 && muscleMass! <= 0.35) {
        status2 = '보통';
      } else if (muscleMass! > 0.35 && muscleMass! <= 0.45) {
        status2 = '높음';
      } else if (muscleMass! > 0.45) {
        status2 = '매우높음';
      } else {
        status2 = 'Muscle class 3';
      }
    });
  }

  void calculateFat() {
    final double? fat = double.tryParse(widget.fat);
    final double? weight = double.tryParse(widget.weight);

    if (fat == null || weight == null) {
      setState(() {
        errorText = "키와 몸무게를 입력해주십시오";
      });
      return;
    }

    if (fat <= 0 || weight <= 0) {
      setState(() {
        errorText = "측정할 수 없는 수치입니다";
      });
      return;
    }

    setState(() {
      fatMass = fat;
      if (fatMass! < 8) {
        status3 = "매우낮음";
      } else if (fatMass! > 8 && fatMass! <= 12) {
        status3 = '낮음';
      } else if (fatMass! > 12 && fatMass! <= 18) {
        status3 = '보통';
      } else if (fatMass! > 18 && fatMass! <= 25) {
        status3 = '높음';
      } else if (fatMass! > 25) {
        status3 = '매우높음';
      } else {
        status3 = 'Fat class 3';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    calculateBMI();
    calculateMuscle();
    calculateFat();
  }

  box(double mass, String title, state, grade1, grade2, grade3, grade4, grade5,
      number1, number2, number3, number4) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  // ignore: unnecessary_null_comparison
                  mass == null ? '00.00' : mass.toStringAsFixed(2),
                  style: TextStyle(
                      fontSize: 40,
                      color: state == grade1
                          ? Colors.blue
                          : state == grade2
                          ? Colors.green
                          : state == grade3
                          ? Colors.yellow.shade700
                          : state == grade4
                          ? Colors.orange
                          : state == grade5
                          ? Colors.red
                          : null),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state,
                      style: TextStyle(
                          color: state == grade1
                              ? Colors.blue
                              : state == grade2
                              ? Colors.green
                              : state == grade3
                              ? Colors.yellow.shade700
                              : state == grade4
                              ? Colors.orange
                              : state == grade5
                              ? Colors.red
                              : null),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(15)),
                      color: Colors.blue,
                    ),
                    child: Center(
                        child: Text(grade1,
                            style:
                            TextStyle(fontSize: 14, color: Colors.white))),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 25,
                    color: Colors.green,
                    child: Center(
                        child: Text(grade2,
                            style:
                            TextStyle(fontSize: 14, color: Colors.white))),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 25,
                    color: Colors.yellow.shade700,
                    child: Center(
                        child: Text(grade3,
                            style:
                            TextStyle(fontSize: 14, color: Colors.white))),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 25,
                    color: Colors.orange,
                    child: Center(
                        child: Text(grade4,
                            style:
                            TextStyle(fontSize: 14, color: Colors.white))),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(15)),
                      color: Colors.red,
                    ),
                    child: Center(
                        child: Text(grade5,
                            style:
                            TextStyle(fontSize: 14, color: Colors.white))),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('    '),
                Text(number1),
                Text(number2),
                Text(number3),
                Text(number4),
                Text('    ')
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadiusDirectional.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '기본정보',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [Text('${widget.height}cm'), Text('키')],
                        ),
                        Column(
                          children: [Text('${widget.weight}kg'), Text('체중')],
                        ),
                        Column(
                          children: [Text('${widget.fat}%'), Text('체지방률')],
                        ),
                        Column(
                          children: [Text('${widget.muscle}Kg'), Text('골격근량')],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                errorText,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadiusDirectional.circular(15)),
                child: Column(
                  children: [
                    box(
                      bmi!,
                      'BMI',
                      status,
                      '저체중',
                      '정상 체중',
                      '과체중',
                      '비만',
                      '고도비만',
                      '18.5',
                      '23.0',
                      '25.0',
                      '30.0',
                    ),
                    Divider(color: Colors.white, thickness: 4),
                    box(
                      muscleMass!,
                      '골격근량',
                      status2,
                      '매우낮음',
                      '낮음',
                      '보통',
                      '높음',
                      '매우높음',
                      '0.15',
                      '0.25',
                      '0.35',
                      '0.45',
                    ),
                    Divider(color: Colors.white, thickness: 4),
                    box(fatMass!, '체지방률', status3, '매우낮음', '낮음', '보통', '높음',
                        '매우높음', '8', '12', '18', '25'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}