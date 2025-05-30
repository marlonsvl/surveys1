import 'package:flutter/material.dart';

// --- DATA MODELS ---

// Represents a single survey question
class Question {
  final String id;
  final String text;
  final List<String> optionLabels; // e.g., ['a', 'b', 'c']
  final List<String> optionsText; // e.g., ['Yes', 'No', 'Maybe']
  String? selectedOptionLabel;

  Question({
    required this.id,
    required this.text,
    required this.optionLabels,
    required this.optionsText,
    this.selectedOptionLabel,
  }) : assert(
         optionLabels.length == optionsText.length,
         "Option labels and texts must have the same length",
       );
}

// --- MAIN APPLICATION ---

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encuesta Flutter',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Inter', // Using Inter as a clean, modern font
        scaffoldBackgroundColor:
            Colors.grey[100], // Light background for the app
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          elevation: 0, // Flat app bar
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, // Button background
            foregroundColor: Colors.white, // Button text color
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded buttons
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.teal; // Color when radio is selected
            }
            return Colors.grey; // Color when radio is unselected
          }),
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontFamily: 'Inter',
          ), // For question text
          titleMedium: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontFamily: 'Inter',
          ), // For option text
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontFamily: 'Inter',
          ), // For section titles
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.teal, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          labelStyle: TextStyle(color: Colors.grey[700], fontFamily: 'Inter'),
          prefixIconColor:
              Colors.teal, // Color for prefix icons in TextFormFields
        ),
      ),
      home: SurveyScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- CONTACT INFO PAGE WIDGET ---
class ContactInfoPage extends StatefulWidget {
  final Function(Map<String, String> contactData) onSubmit;

  ContactInfoPage({required this.onSubmit});

  @override
  _ContactInfoPageState createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In a real app,
      // you'd often call a server or save the information.
      widget.onSubmit({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
      });
    }
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, ingrese su $fieldName.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, ingrese su correo electrónico.';
    }
    // Basic email validation regex
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, ingrese un correo electrónico válido.';
    }
    return null;
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          icon,
        ), // Icon color will be from theme's prefixIconColor
        // Other properties like border, focusedBorder are handled by inputDecorationTheme in MyApp
      ),
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode:
          AutovalidateMode.onUserInteraction, // Validate as user types
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información de Contacto'),
        automaticallyImplyLeading: false, // No back button on this initial page
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Make button full width
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Complete su información personal para continuar',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                _buildTextFormField(
                  controller: _firstNameController,
                  labelText: 'Nombre(s)',
                  icon: Icons.person_outline,
                  validator: (value) => _validateRequired(value, 'nombre(s)'),
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _lastNameController,
                  labelText: 'Apellido(s)',
                  icon: Icons.person_outline,
                  validator: (value) => _validateRequired(value, 'apellido(s)'),
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _emailController,
                  labelText: 'Correo Electrónico',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Siguiente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- SURVEY SCREEN WIDGET ---

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0; // Index for question pages

  Map<String, String>? _collectedContactData; // To store contact info

  // List of questions for the survey
  final List<Question> _questions = [
    Question(
      id: 'q1',
      text: '¿Con qué frecuencia hace nuevas amistades?',
      optionLabels: ['a', 'b', 'c', 'd', 'e'],
      optionsText: [
        'Totalmente de acuerdo',
        'De acuerdo',
        'Ni de acuerdo ni en desacuerdo',
        'En desacuerdo',
        'Totalmente en desacuerdo',
      ],
    ),
    Question(
      id: 'q2',
      text: '¿Se ha visto afectado tus calificaciones por el juego?',
      optionLabels: ['b', 'c', 'd', 'e'], // Options as specified in the prompt
      optionsText: [
        'De acuerdo',
        'Ni de acuerdo ni en desacuerdo',
        'En desacuerdo',
        'Totalmente en desacuerdo',
      ],
    ),
    // Add more questions here if needed
  ];

  // Stores the answers: questionId -> selectedOptionLabel
  Map<String, String?> _answers = {};

  @override
  void initState() {
    super.initState();
    // Initialize answers map for questions
    for (var q in _questions) {
      _answers[q.id] = null;
    }
  }

  void _onOptionSelected(String questionId, String optionLabel) {
    setState(() {
      _answers[questionId] = optionLabel;
      _questions.firstWhere((q) => q.id == questionId).selectedOptionLabel =
          optionLabel;
    });
  }

  void _nextPage() {
    // This logic is for navigating between question pages or finishing
    if (_currentPageIndex < _questions.length - 1) {
      // Check if an option is selected for the current question
      if (_answers[_questions[_currentPageIndex].id] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor, seleccione una opción.'),
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
          ),
        );
        return;
      }
      _pageController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Last question, navigate to results screen
      if (_answers[_questions[_currentPageIndex].id] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Por favor, seleccione una opción antes de finalizar.',
            ),
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
          ),
        );
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResultsScreen(
                answers: _answers,
                questions: _questions,
                contactData: _collectedContactData, // Pass contact data
              ),
        ),
      );
    }
  }

  void _previousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If contact data hasn't been collected, show the ContactInfoPage
    if (_collectedContactData == null) {
      return ContactInfoPage(
        onSubmit: (data) {
          setState(() {
            _collectedContactData = data;
          });
        },
      );
    }

    // Otherwise, show the survey questions
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuesta: Pregunta ${_currentPageIndex + 1}'),
        leading:
            _currentPageIndex > 0
                ? IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: _previousPage,
                )
                : null, // No back button on the first question page
      ),
      body: Column(
        children: [
          // Progress Indicator for questions
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pregunta ${_currentPageIndex + 1} de ${_questions.length}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.teal[700],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (_currentPageIndex + 1) / _questions.length,
                      backgroundColor: Colors.teal[100],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      minHeight: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _questions.length,
              physics:
                  NeverScrollableScrollPhysics(), // Disable swipe navigation
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return QuestionCard(
                  question: _questions[index],
                  selectedOption: _answers[_questions[index].id],
                  onOptionSelected: (optionLabel) {
                    _onOptionSelected(_questions[index].id, optionLabel);
                  },
                );
              },
            ),
          ),
          // Navigation Buttons for questions
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPageIndex > 0)
                  TextButton(
                    onPressed: _previousPage,
                    child: Text(
                      'Anterior',
                      style: TextStyle(color: Colors.teal, fontSize: 16),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.teal),
                      ),
                    ),
                  )
                else
                  SizedBox(width: 80), // Placeholder for alignment

                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPageIndex < _questions.length - 1
                        ? 'Siguiente'
                        : 'Finalizar',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- QUESTION CARD WIDGET ---

class QuestionCard extends StatelessWidget {
  final Question question;
  final String? selectedOption;
  final ValueChanged<String> onOptionSelected;

  QuestionCard({
    required this.question,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                question.text,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 25),
              ...List.generate(question.optionsText.length, (index) {
                final optionLabel = question.optionLabels[index];
                final optionText = question.optionsText[index];
                return RadioListTile<String>(
                  title: Text(
                    '${optionLabel}. ${optionText}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  value: optionLabel,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    if (value != null) {
                      onOptionSelected(value);
                    }
                  },
                  activeColor: Colors.teal,
                  contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tileColor:
                      selectedOption == optionLabel
                          ? Colors.teal.withOpacity(0.1)
                          : null,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// --- RESULTS SCREEN WIDGET ---

class ResultsScreen extends StatelessWidget {
  final Map<String, String?> answers;
  final List<Question> questions;
  final Map<String, String>? contactData; // Added to receive contact info

  ResultsScreen({
    required this.answers,
    required this.questions,
    this.contactData, // Make it optional
  });

  @override
  Widget build(BuildContext context) {
    int answeredCount = answers.values.where((ans) => ans != null).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados de la Encuesta'),
        automaticallyImplyLeading: false, // No back button
      ),
      body: Center(
        child: SingleChildScrollView(
          // Added for scrollability if content is long
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 80,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '¡Gracias por completar la encuesta!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.teal[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Has respondido $answeredCount de ${questions.length} preguntas.',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  // Display contact information if available
                  if (contactData != null) ...[
                    Divider(height: 30, thickness: 1),
                    Text(
                      'Información de Contacto Registrada:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nombre: ${contactData!['firstName']} ${contactData!['lastName']}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Email: ${contactData!['email']}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Divider(height: 30, thickness: 1),
                  ],

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to the beginning of the survey (will show contact page first)
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SurveyScreen()),
                        (Route<dynamic> route) => false, // Remove all routes
                      );
                    },
                    child: Text('Tomar la encuesta de nuevo'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
