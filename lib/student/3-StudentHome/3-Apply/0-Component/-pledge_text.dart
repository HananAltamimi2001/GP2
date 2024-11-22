import 'package:flutter/material.dart';

class PledgeText extends StatelessWidget {
  const PledgeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height *
                    0.03, 
                width: MediaQuery.of(context).size.width *
                    0.9, 
                decoration: BoxDecoration(color: Color(0xff007580)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Text(
                    "Dear student: ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
              width: MediaQuery.of(context).size.width *
                    0.9, 
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Text(
                        "1- Familiarize yourself with the Student Housing Regulations and abide by the systems, instructions, and any new systems and regulations issued by the university."),
                    Text(
                        "2- Continuously monitor your university email as it is the official means of communication."),
                    Text("3- Present your university ID card when requested."),
                    Text(
                        "4- Adhere to proper behavior in dealing with university housing staff and refrain from verbally or physically harassing anyone."),
                    Text(
                        "5- Adhere to general etiquette in wearing appropriate attire outside the housing unit."),
                    Text("6- Maintain the cleanliness of the housing unit."),
                    Text(
                        "7- Allow maintenance to enter the housing unit when necessary."),
                    Text(
                        "8- Do not move the furniture provided by the university housing to the housing unit or out of it, or make any changes to the housing unit in any way."),
                    Text(
                        "9- Adhere to the specified hours for entering and exiting the university housing, as announced by the housing administration."),
                    Text(
                        "10- Submit a request to the housing administration in case of absence from the residence and specify the duration of the absence."),
                    Text(
                        "11- Renew the guarantee certificate for social security beneficiaries at the beginning of each academic semester."),
                    Text(
                        "12- There must be no health impediment that conflicts with residing in university housing for female students. If any obstacle is found, the housing administration has the right to take appropriate measures."),
                    Text(
                        '13- New students must submit a medical report from King Abdullah University Hospital.'),
                    Text(
                        '14- Vacate the housing during official holidays that exceed 7 days, such as religious holidays.'),
                    Text(
                        '15- Evacuate the housing at the end of the contract. The student will be responsible for any loss or damage to personal belongings in the housing unit after two weeks from the end of the contract.'),
                    Text(
                        '16- Complete the eviction procedures, hand over the key to the housing unit, sign the required form, and ensure the housing unit is empty of personal belongings.'),
                    Text(
                        '17- If you wish to renew your residency, a new contract must be signed two weeks before the end of the current contract.')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
