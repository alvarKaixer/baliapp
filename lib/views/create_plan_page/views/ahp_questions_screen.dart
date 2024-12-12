import 'package:flutter/material.dart';
import 'recommendation_page.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:music_recommender/service/api_service.dart';
import 'dart:convert';
import 'models/recommended.dart';

class AHPQuestionsScreen extends StatefulWidget {
  const AHPQuestionsScreen({super.key});

  @override
  _AHPQuestionsScreenState createState() => _AHPQuestionsScreenState();
}

class _AHPQuestionsScreenState extends State<AHPQuestionsScreen> {
  static const Color darkForestGreen = Color.fromRGBO(46, 79, 79, 1);
  static const Color brightGreen = Color.fromRGBO(96, 186, 96, 1);

  final List<List<Map<String, String>>> criteriaSets = [
    [
      { 
        'criterion1': 'Facilities', 
        'criterion2': 'Tourist Activities', 
        'pair': 'M2-M1'
      },
      { 
        'criterion1': 'Facilities', 
        'criterion2': 'Cost',
        'pair': 'M2-M3'
      },
      {
        'criterion1': 'Facilities',
        'criterion2': 'Accessibility and Loc. of Destinations',
        'pair': 'M2-M4'
      },
    ],
    [
      {
        'criterion1': 'Cost', 
        'criterion2': 'Tourist Activities',
        'pair': 'M3-M1'
      },
      {
        'criterion1': 'Cost', 
        'criterion2': 'Facilities',
        'pair': 'M3-M2'
      },
      {
        'criterion1': 'Cost',
        'criterion2': 'Accessibility and Loc. of Destinations',
        'pair': 'M3-M4'
      },
    ],
    [
      {
        'criterion1': 'Accessibility and Loc. of Destinations',
        'criterion2': 'Tourist Activities',
        'pair': 'M4-M1'
      },
      {
        'criterion1': 'Accessibility and Loc. of Destinations',
        'criterion2': 'Facilities',
        'pair': 'M4-M2'  
      },
      {
        'criterion1': 'Accessibility and Loc. of Destinations',
        'criterion2': 'Cost',
        'pair': 'M4-M3'
      },
    ],
    [
      {
        'criterion1': 'Tourist Activities', 
        'criterion2': 'Facilities',
        'pair': 'M1-M2'  
      },
      {
        'criterion1': 'Tourist Activities', 
        'criterion2': 'Cost',
        'pair': 'M1-M3'
      },
      {
        'criterion1': 'Tourist Activities',
        'criterion2': 'Accessibility and Loc. of Destinations',
        'pair': 'M1-M4'
      },
    ],
  ];

  final Map<String, dynamic> entranceFees = const {
    'BEBEDECK': 50,
    'EMMANUEL SPRING': 50,
    'IP VILLAGE': 55,
    'HARDROCK LUX SPRING RESORT': 100,
    'MANG INASAL GAISANO': 0,
    'NOODLE NOOK': 0,
    'THE EDGE': 0,
    'THE SPOT': 99,
    'BALINGASAG PARK': 0,
    'ISLA VERDE': 50,
    'JOANNAS NOOK': 0,
    'LA ROCKA': 0,
    'ESCANILLA': {'day': 50, 'overnight': 100},
    'ST. RITAS PARISH CHURCH': 0,
    'LINABU MOUNTAIN VIEW': 150,
  };



  final List<int> _sliderValues = List.filled(12, 5);

  bool _isLoading = false;
  String _errorMessage = '';
  int _currentSetIndex = 0;

  final ApiService _apiService = ApiService();

  // Declare selectedPairsWithScores here, so it's accessible later
  List<Map<String, dynamic>> selectedPairsWithScores = [];

  // Tracks selected button indices
  final Map<int, Map<String, dynamic>> selectedCriteria = {};


 // AHP Rating API call and error handling
  void _ahpRatePairs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _apiService.ratePairWise({
        'ratings': selectedPairsWithScores
      });

      if (response.statusCode == 201) {
        // final recommendedLocation = response.data;

        // Save the Recommended using SharedPreferences
        // Assuming response.data is a valid Map or JSON object that can be converted to a Recommended
        final recommendedLocation = Recommended.fromMap(response.data);  // Convert the response data to Recommended
        
        // Call the method to store the Recommended
        await storeRecommended(recommendedLocation); 


      } else {
        setState(() {
          _errorMessage = 'Failed to calculate AHP';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'An error occurred. Please try again later. ERROR: ${e.toString()}';
      });
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  Future<void> storeRecommended(Recommended recommendation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Convert the Recommendation object to a map and then to a JSON string
    String recommendationJson = jsonEncode(recommendation.toMap());
    
    // Save the JSON string in SharedPreferences
    await prefs.setString('recommend_location', recommendationJson);
    
    debugPrint('Stored Recommendation: $recommendationJson');
  }


  Future<Recommended?> getRecommended() async {
    // Access SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the stored recommendation JSON string
    String? recommendedLocationJson = prefs.getString('recommend_location');

    // If the stored recommendation exists
    if (recommendedLocationJson != null) {
      // Decode the JSON string to a Map
      Map<String, dynamic> recommendedLocationMap = jsonDecode(recommendedLocationJson);

      // Create and return the Recommendation object from the map
      return Recommended.fromMap(recommendedLocationMap);
    } else {
      // Return null if no Recommended is found
      return null;
    }
  }

  Future<int> getBalanceBudget(int locationEntranceFee) async {
    // Load preferences asynchronously
    final prefs = await SharedPreferences.getInstance();

    // Retrieve saved preferences
    final budgetString = prefs.getString('budget') ?? '0';
    final noOfPaxString = prefs.getString('no_of_pax') ?? '0';

    // Parse the budget and number of pax
    final budget = int.tryParse(budgetString) ?? 0;
    final noOfPax = int.tryParse(noOfPaxString) ?? 0;

    // Calculate budget
    final int totalFee = noOfPax * locationEntranceFee;
    int balanceBudget = budget - totalFee;

    // Ensure non-negative balance
    if (balanceBudget < 0) {
      balanceBudget = 0;
    }
  
    debugPrint('SAVED Budget : ${budget}');
    debugPrint('SAVED No.Of Pax : ${noOfPax}');
    debugPrint('LOCATION Fee : ${locationEntranceFee}');


    // Return the balance budget
    return balanceBudget;
  }




  void _saveAndNext() async {
    if (_currentSetIndex < 3) {
      setState(() {
        _currentSetIndex++;
      });

      // Convert selected criteria to an array of objects
      selectedPairsWithScores = selectedCriteria.entries
          .where((entry) => entry.value.containsKey('pair') && entry.value.containsKey('score'))
          .map((entry) => {
                'pair': entry.value['pair'],
                'score': entry.value['score'],
              })
          .toList();

      // Log the result
      debugPrint('Selected Pairs with Scores: $selectedPairsWithScores');
    } else {

      // Call AHP API
      _ahpRatePairs();

      // Get the recommendation before navigating
      Recommended? recommendation = await getRecommended();
      debugPrint('SAVED Recommended : ${recommendation?.toString() ?? "No recommendation"}');

      // Calculate budget
      final int locationEntranceFee = entranceFees[recommendation?.name] ?? 0;
      int balanceBudget = await getBalanceBudget(locationEntranceFee);
      debugPrint('SAVED Balance Budget : $balanceBudget');

      // Navigate to Recomendation page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendationPage(
            recommendations: const [], 
            remainingBudget: balanceBudget.toDouble(),
            recommendation: recommendation,
            locationFee:  locationEntranceFee.toDouble()
          ),
        ),
      );

    }
  }

  void _goBack() {
    if (_currentSetIndex > 0) {
      setState(() {
        _currentSetIndex--;
      });
    }
  }

  @override
    Widget build(BuildContext context) {
      final currentSet = criteriaSets[_currentSetIndex];

      return Scaffold(
        appBar: AppBar(
          title: Text('AHP Questions - Set ${_currentSetIndex + 1}/${criteriaSets.length}'),
          leading: _currentSetIndex > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goBack,
                )
              : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please rate the following criterion pairs:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: currentSet.length,
                  itemBuilder: (context, i) {
                    final pairKey = _currentSetIndex * 3 + i;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCriteria[pairKey] = {
                                    'pair': currentSet[i]['pair'], // Set the selected criterion as the pair
                                    'score': selectedCriteria[pairKey]?['score'] ?? 5,
                                  };
                                });
                                
                                debugPrint('PAIR : ${currentSet[i]}');
                                debugPrint('SCORE : ${selectedCriteria[pairKey]}');
                                debugPrint('PAIR KEY : ${pairKey}');
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 140,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: selectedCriteria[pairKey]?['criterion1'] == currentSet[i]['criterion1']
                                      ? brightGreen
                                      : darkForestGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    currentSet[i]['criterion1']!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCriteria[pairKey] = {
                                    'pair': currentSet[i]['pair'], // Set the selected criterion as the pair
                                    'score': selectedCriteria[pairKey]?['score'] ?? 5,
                                  };
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 140,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: selectedCriteria[pairKey]?['criterion2'] == currentSet[i]['criterion2']
                                      ? brightGreen
                                      : darkForestGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    currentSet[i]['criterion2']!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('Select the importance level for this pair:'),
                        Slider(
                          value: (selectedCriteria[pairKey]?['score'] ?? 5).toDouble(),
                          min: 1,
                          max: 9,
                          divisions: 8,
                          label: (selectedCriteria[pairKey]?['score'] ?? 5).toString(),
                          activeColor: darkForestGreen,
                          inactiveColor: darkForestGreen.withOpacity(0.3),
                          onChanged: (value) {
                            setState(() {
                              selectedCriteria[pairKey] ??= {};
                              selectedCriteria[pairKey]!['score'] = value.toInt();
                            });

                            setState(() {
                              selectedCriteria[pairKey] = {
                                'pair': currentSet[i]['pair'], // Set the selected criterion as the pair
                                'score': selectedCriteria[pairKey]?['score'] ?? 5,
                              };
                            });

                          },
                        ),

                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _saveAndNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkForestGreen,
                ),
                child: const Text('Next Set'),
              ),
            ],
          ),
        ),
      );
    }

}



