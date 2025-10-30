import 'package:flutter/material.dart';

void main() {
  runApp(const PrakritiApp());
}

class PrakritiApp extends StatelessWidget {
  const PrakritiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Know Your Prakriti',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const PrakritiQuiz(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PrakritiQuiz extends StatefulWidget {
  const PrakritiQuiz({super.key});

  @override
  State<PrakritiQuiz> createState() => _PrakritiQuizState();
}

class _PrakritiQuizState extends State<PrakritiQuiz> {
  int currentIndex = 0;
  String? selectedType;
  bool showResult = false;
  String resultText = "";

  Map<String, int> scores = {"Vata": 0, "Pitta": 0, "Kapha": 0};

  final List<Map<String, dynamic>> questions = [
    {
      "question": "1. What best describes your body type?",
      "options": {
        "Vata": "Slim and light",
        "Pitta": "Medium and muscular",
        "Kapha": "Broad and solid"
      }
    },
    {
      "question": "2. What is your skin type?",
      "options": {
        "Vata": "Dry and rough",
        "Pitta": "Warm and reddish",
        "Kapha": "Smooth and oily"
      }
    },
    {
      "question": "3. How is your appetite?",
      "options": {
        "Vata": "Irregular",
        "Pitta": "Strong and steady",
        "Kapha": "Slow but consistent"
      }
    },
    {
      "question": "4. How is your sleep pattern?",
      "options": {
        "Vata": "Light and easily disturbed",
        "Pitta": "Moderate and sound",
        "Kapha": "Deep and long"
      }
    },
    {
      "question": "5. What best describes your mood?",
      "options": {
        "Vata": "Anxious or restless",
        "Pitta": "Irritable or intense",
        "Kapha": "Calm and stable"
      }
    },
    {
      "question": "6. How do you react under stress?",
      "options": {
        "Vata": "Get worried or confused",
        "Pitta": "Get angry or frustrated",
        "Kapha": "Withdraw or stay quiet"
      }
    },
    {
      "question": "7. What is your energy level throughout the day?",
      "options": {
        "Vata": "Variable, comes and goes",
        "Pitta": "High and consistent",
        "Kapha": "Steady but slow"
      }
    },
    {
      "question": "8. What is your preferred climate?",
      "options": {
        "Vata": "Warm climate",
        "Pitta": "Cool climate",
        "Kapha": "Dry and warm climate"
      }
    },
    {
      "question": "9. What best describes your digestion?",
      "options": {
        "Vata": "Irregular digestion",
        "Pitta": "Strong digestion",
        "Kapha": "Slow digestion"
      }
    },
    {
      "question": "10. How fast do you learn and forget things?",
      "options": {
        "Vata": "Learn fast, forget fast",
        "Pitta": "Learn quickly, remember well",
        "Kapha": "Learn slowly, remember long"
      }
    },
  ];

  void nextQuestion() {
    if (selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an option before continuing.")),
      );
      return;
    }

    scores[selectedType!] = (scores[selectedType!] ?? 0) + 1;

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedType = null;
      });
    } else {
      String dominant = scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;

      String suggestion = "";
      if (dominant == "Vata") {
        suggestion =
            "🕊️ You are Vata dominant.\nStay warm, eat cooked foods, and follow a steady routine.";
      } else if (dominant == "Pitta") {
        suggestion =
            "🔥 You are Pitta dominant.\nAvoid spicy food, stay cool, and practice calming activities.";
      } else {
        suggestion =
            "💧 You are Kapha dominant.\nStay active, eat light foods, and avoid oversleeping.";
      }

      setState(() {
        showResult = true;
        resultText = "Your Prakriti Type: $dominant\n\n$suggestion";
      });
    }
  }

  void restartQuiz() {
    setState(() {
      currentIndex = 0;
      selectedType = null;
      showResult = false;
      resultText = "";
      scores = {"Vata": 0, "Pitta": 0, "Kapha": 0};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Know Your Prakriti")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: showResult
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      resultText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: restartQuiz,
                      child: const Text("Restart Quiz"),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: (currentIndex + 1) / questions.length,
                    color: Colors.teal,
                    backgroundColor: Colors.teal.shade100,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    questions[currentIndex]["question"],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ...(questions[currentIndex]["options"] as Map<String, String>).entries.map((option) {
                    final type = option.key;
                    final text = option.value;
                    return Card(
                      child: RadioListTile<String>(
                        title: Text(text),
                        value: type,
                        groupValue: selectedType,
                        onChanged: (value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: nextQuestion,
                    child: Text(currentIndex == questions.length - 1 ? "Submit" : "Next"),
                  ),
                ],
              ),
      ),
    );
  }
}
