import 'package:flutter/material.dart';
import 'package:music_recommender/views/create_plan_page/views/ahp_questions_screen.dart'; // Import AHPQuestionsScreen
// ignore: unused_import
import 'package:music_recommender/views/bali_trip_screen/bali_trip_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _noOfPaxController = TextEditingController();
  
  String? _selectedOption = 'tourist'; // Default selected option

  Future<void> savePreferences(int budget, int noOfPax) async {
    // Get the instance of SharedPreferences asynchronously
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Save the provided budget and noOfPax values to SharedPreferences
    await prefs.setString('budget', budget.toString());
    await prefs.setString('no_of_pax', noOfPax.toString());
    
    // Optionally, log the saved values to confirm
    debugPrint('Budget saved: $budget');
    debugPrint('No. of Pax saved: $noOfPax');
  }




  void _handleNext() async {
    if (_budgetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your budget.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_noOfPaxController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter number of pax.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } 

    // Save the budget and no.Of Pax using SharedPreferences
    // Get the values from the controllers and parse them to int
    int budget = int.tryParse(_budgetController.text) ?? 0;  // Default to 0 if parsing fails
    int noOfPax = int.tryParse(_noOfPaxController.text) ?? 0;  // Default to 0 if parsing fails

// Call the savePreferences method with the parsed values
await savePreferences(budget, noOfPax);

    // Proceed to AHP Questions Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AHPQuestionsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 247, 247),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Expanded(child: SizedBox()),
            Text(
              'BaliTrip',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(46, 79, 79, 1),
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferences',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Budget Text Field
            TextField(
              controller: _budgetController,
              decoration: InputDecoration(
                labelText: 'Budget',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                floatingLabelStyle: TextStyle(
                  color: Colors.black,
                ),           
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey, // Set your preferred color here
                    width: 2.0, // Customize the border width if needed
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),
            // No. of Pax Text Field
            TextField(
              controller: _noOfPaxController,
              decoration: InputDecoration(
                labelText: 'Number of Pax',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                floatingLabelStyle: TextStyle(
                  color: Colors.black,
                ),           
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey, // Set your preferred color here
                    width: 2.0, // Customize the border width if needed
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),            

            // // Radio buttons for Local Tourist Attraction or Local Dining
            // const Text('Please choose one:'),
            // const SizedBox(height: 10),
            // RadioListTile<String>(
            //   title: const Text('Local Tourist Attraction'),
            //   value: 'tourist',
            //   groupValue: _selectedOption,
            //   onChanged: (value) {
            //     setState(() {
            //       _selectedOption = value;
            //     });
            //   },
            //   activeColor: const Color.fromRGBO(
            //       46, 79, 79, 1), // Green color for the radio button circle
            // ),
            // RadioListTile<String>(
            //   title: const Text('Local Dining'),
            //   value: 'dining',
            //   groupValue: _selectedOption,
            //   onChanged: (value) {
            //     setState(() {
            //       _selectedOption = value;
            //     });
            //   },
            //   activeColor: const Color.fromRGBO(
            //       46, 79, 79, 1), // Green color for the radio button circle
            // ),
            const SizedBox(
                height: 20), // Adjusted space between radio options and buttons

            // Back and Next Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(46, 79, 79, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, {
                      'budget': _budgetController.text,
                      'selectedOption': _selectedOption,
                    });
                  },
                  child: const Text(
                    'BACK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(46, 79, 79, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _handleNext,
                  child: const Text(
                    'NEXT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
