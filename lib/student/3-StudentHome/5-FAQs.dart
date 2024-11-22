import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library

// Defining a Stateless widget for the Frequently Asked Questions page
class FAQs extends StatelessWidget {

  final List<Map<String, String>> faqs = [
    {
      'question': 'How much is the housing unit fee per semester?',
      'answer': '1400 SAR For Single Unit and 700 SAR for sharing Unit.'
    },
    {
      'question': 'Who is eligible for student housing?',
      'answer': 'Princess Nourah bint Abdulrahman University students whose homes are 150 km away or more from the university.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        // Our Custom AppBar widget  from  our design library
        title: "Frequently Asked Questions", // Setting the title of the AppBar
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return FAQTile(
            question: faq['question']!,
            answer: faq['answer']!,
          );
        },
      ),
    );
  }
}

class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  FAQTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title:text(
          t: question, // Set text
          color: dark1, // Text color
          align: TextAlign.start, // Text alignment
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: text(
              t: answer, // Display the fetched Vision statement
              color: Colors.black, // Set text color to black
              align: TextAlign.start, // Align text to start
            ),
          ),
        ],
      ),
    );
  }
}