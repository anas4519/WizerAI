import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/ai_guidance/screens/recommendation_screen.dart';
import 'package:career_counsellor/widgets/custom_drop_down.dart';
import 'package:career_counsellor/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';

class CareerSurvey extends StatefulWidget {
  const CareerSurvey({super.key});

  @override
  State<CareerSurvey> createState() => _CareerSurveyState();
}

class _CareerSurveyState extends State<CareerSurvey> {
  final TextEditingController _interestsController = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _strengthsController = TextEditingController();
  final TextEditingController _weaknessesController = TextEditingController();
  final TextEditingController _aspirationsController = TextEditingController();
  final TextEditingController _motherCareerController = TextEditingController();
  final TextEditingController _fatherCareerController = TextEditingController();
  final TextEditingController _parentsExpectationsController =
      TextEditingController();
  final TextEditingController _interdisciplinaryOptionsController =
      TextEditingController();
  final TextEditingController _geographicPrefController =
      TextEditingController();

  final TextEditingController _additionalInfoController =
      TextEditingController();

  String? _selectedStandard;
  String? _preferredLifestyle;
  String? _learningCurve;
  String? _financialStatus;
  String? _salaryExpectation;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Career Survey',
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _interestsController.text = 'Stem, gadgets, smartphones';
                    _hobbiesController.text =
                        'Cricket, Football, Watching gadget yt videos';
                    _strengthsController.text = 'Hardworking';
                    _fatherCareerController.text = 'Accountant';
                    _motherCareerController.text = 'Chef';
                  });
                },
                icon: const Icon(Icons.auto_awesome))
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Qualifications',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomDropDown(
                  label: 'What standard are you currently in?',
                  list: Constants.standards,
                  onChanged: (value) {
                    _selectedStandard = value;
                  },
                  validationText: 'standard',
                ),
                //marks
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Interests',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomInputField(
                  label: 'Enter your interests',
                  controller: _interestsController,
                  required: true,
                  validationText: 'interests',
                ),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'List activities, or topics you are passionate about or enjoy exploring.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Hobbies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomInputField(
                  label: 'Enter your hobbies',
                  controller: _hobbiesController,
                  required: true,
                  validationText: 'hobbies',
                ),

                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Skills (if any)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomInputField(
                    label: 'Enter your skills',
                    controller: _skillsController,
                    required: false),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'eg: Web development, calligraphy, etc.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Strengths',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomInputField(
                  label: 'Enter your strengths',
                  controller: _strengthsController,
                  required: true,
                  validationText: 'strengths',
                ),

                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'eg: Creativity, leadership, teamwork, etc.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Weaknesses (if any)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomInputField(
                    label: 'Enter your weaknesses',
                    controller: _weaknessesController,
                    required: false),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'eg: Math, public speaking',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Desired Lifestyle',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomDropDown(
                    label: 'Select your desired lifestyle',
                    list: Constants.preferredLifestyles,
                    onChanged: (value) {
                      _preferredLifestyle = value;
                    },
                    validationText: 'preferred lifestyle'),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Geographic Preferences (if any)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomInputField(
                    label: 'Geographic Preferences',
                    controller: _geographicPrefController,
                    required: false),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'Any specific locations or regions where you would like to work.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Aspirations (if any)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomInputField(
                    label: 'Enter your aspirations',
                    controller: _aspirationsController,
                    required: false),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'Share your long-term career goals. Example: becoming a senior developer, starting a business, or impacting sustainability.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Learning Curve',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomDropDown(
                    label: 'Select a learning-curve',
                    list: Constants.learningCurves,
                    onChanged: (value) {
                      _learningCurve = value;
                    },
                    validationText: 'learning curve'),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'The learning curve indicates how quickly you can learn a new skill. Select the learning curve you are willing to face for acquiring the skills required for a specific profession.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Parents\' Profession',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomInputField(
                  label: 'Mother\'s Profession',
                  controller: _motherCareerController,
                  required: true,
                  validationText: 'Mother\'s Profession',
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomInputField(
                  label: 'Father\'s Profession',
                  controller: _fatherCareerController,
                  required: true,
                  validationText: 'Father\'s Profession',
                ),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'Parents\' professions can influence career choices through exposure, guidance, role modeling, and networking opportunities.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Parents\' Expectations (if any)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomInputField(
                    label: 'Enter parents\' expectations',
                    controller: _parentsExpectationsController,
                    required: false),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'Describe your parents\' hopes and goals for your career. For example, mention if they expect you to pursue a specific profession, achieve a certain level of education, or follow in their footsteps.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Interdisciplinary Options (if any)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomInputField(
                    label: 'Enter interdisciplinary options',
                    controller: _interdisciplinaryOptionsController,
                    required: false),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'List any fields you are interested in combining for your future career and explain how this interdisciplinary approach will benefit you.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Financial Status',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomDropDown(
                    label: 'Select your financial status',
                    list: Constants.financialStatusOptions,
                    onChanged: (value) {
                      _financialStatus = value;
                    },
                    validationText: 'financial status'),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'Select the option that best describes your household\'s current financial situation.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Salary Expectations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomDropDown(
                    label: 'Salary expectation after education',
                    list: Constants.salaryExpectations,
                    onChanged: (value) {
                      _salaryExpectation = value;
                    },
                    validationText: 'salary expectation'),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'Choose the salary range that you expect to earn annually after finishing your education.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                const Text(
                  'Additional Information (if any)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomInputField(
                    label: 'Additional Information',
                    controller: _additionalInfoController,
                    required: false),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                const Text(
                  'Anything else that you would like us to know. eg: I am looking for a job as soon as possible.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Center(
                  child: Container(
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade700, Colors.red.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // await generateRecommendations();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => RecommendationScreen(
                                    qualifications: _selectedStandard!,
                                    interests: _interestsController.text,
                                    hobbies: _hobbiesController.text,
                                    skills: _skillsController.text,
                                    strengths: _strengthsController.text,
                                    weaknesses: _weaknessesController.text,
                                    desiredLifestyle: _preferredLifestyle!,
                                    geographicPref:
                                        _geographicPrefController.text,
                                    aspirations: _aspirationsController.text,
                                    learningCurve: _learningCurve!,
                                    mothersProfession:
                                        _motherCareerController.text,
                                    fathersProfession:
                                        _fatherCareerController.text,
                                    parentsExpectations:
                                        _parentsExpectationsController.text,
                                    interdisciplinaryOptions:
                                        _interdisciplinaryOptionsController
                                            .text,
                                    financialStatus: _financialStatus!,
                                    salaryExpectations: _salaryExpectation!,
                                    additionalInfo:
                                        _additionalInfoController.text,
                                  )));
                        }
                      },
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        ),
                      ),
                      child: const Text('Generate Recommendations',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: screenHeight * 0.1,
                // ),
                // Text(recommendations)
              ],
            ),
          ),
        ));
  }
}
