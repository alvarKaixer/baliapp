import 'package:flutter/material.dart';
import 'models/recommended.dart';
import 'widgets/recommendation_list.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:music_recommender/views/destinations/balipark.dart';
import 'package:music_recommender/views/destinations/bebedeck.dart';
import 'package:music_recommender/views/destinations/emmanuelspring.dart';
import 'package:music_recommender/views/destinations/escanilla.dart';
import 'package:music_recommender/views/destinations/ipvillage.dart';
import 'package:music_recommender/views/destinations/islaverde.dart';
import 'package:music_recommender/views/destinations/joannasnook.dart';
import 'package:music_recommender/views/destinations/larocka.dart';
import 'package:music_recommender/views/destinations/linabumountainview.dart';
import 'package:music_recommender/views/destinations/manginasal.dart';
import 'package:music_recommender/views/destinations/noodlenook.dart';
import 'package:music_recommender/views/destinations/srparishchurch.dart';
import 'package:music_recommender/views/destinations/theedge.dart';
import 'package:music_recommender/views/destinations/thespot.dart';
import 'package:music_recommender/views/destinations/hardrock.dart';
import './create_plan_page.dart';
import 'package:music_recommender/views/bali_trip_screen/bali_trip_screen.dart';

class RecommendationPage extends StatelessWidget {
  final List<Recommended> recommendations;
  final double remainingBudget;
  final double locationFee;
  final Recommended? recommendation;

  const RecommendationPage({
    Key? key,
    required this.recommendations,
    required this.remainingBudget,
    required this.recommendation,
    required this.locationFee
  }) : super(key: key);

  final locationImages = const {
    'BEBEDECK': 'assets/bebedeck.jpg',
    'EMMANUEL SPRING': 'assets/emmanuelspring.jpg',
    'IP VILLAGE': 'assets/ipvillage.jpg',
    'HARDROCK LUX SPRING RESORT': 'assets/hardrock.jpg',
    'MANG INASAL GAISANO': 'assets/mang_inasal.jpg',
    'NOODLE NOOK': 'assets/noodlenook.jpg',
    'THE EDGE': 'assets/theedge.jpg',
    'THE SPOT': 'assets/thespot.jpg',
    'BALINGASAG PARK': 'assets/balingasagpark.jpg',
    'ISLA VERDE': 'assets/islaverde.jpg',
    'JOANNAS NOOK': 'assets/larocka.jpg',
    'LA ROCKA': 'assets/larocka.jpg',
    'ESCANILLA': 'assets/escanilla.jpg',
    'ST. RITAS PARISH CHURCH': 'assets/stritaparishchurch.jpg',
    'LINABU MOUNTAIN VIEW': 'assets/linabumountainview.jpg',
  };



  // Fetch the recommendation object from SharedPreferences
  Future<Recommended?> getRecommendation() async {
    final prefs = await SharedPreferences.getInstance();
    String? recommendationJson = prefs.getString('recommend_location');

    debugPrint('RECO PAGE ${recommendationJson}');

    if (recommendationJson != null) {
      // Decode the JSON and convert it into a Recommendation object
      Map<String, dynamic> recommendationMap = jsonDecode(recommendationJson);
      return Recommended.fromMap(recommendationMap);
    } else {
      // Return null if no recommendation is stored
      return null;
    }
  }



  @override
  Widget build(BuildContext context) {

    void _gotoHomePage() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BaliTripScreen()),
          );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Options'),
        backgroundColor: const Color.fromRGBO(72, 111, 111, 1),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Budget and Preferred Area Information
                _buildInfoText('Your Remaining Budget:',
                    '₱${remainingBudget.toStringAsFixed(2)}'),
                const SizedBox(height: 8),

                // Display Top Recommendation
                if (recommendation != null) ...[
                  _buildSectionTitle('Top Recommendation:'),
                  // _buildInfoText('Name:', recommendation!.name),




                  DestinationCard(
                    imageUrl: locationImages[recommendation?.name] ?? 'assets/hardrock.jpg',
                    title: recommendation?.name ?? 'Unknown Destination',
                    description: 'Discover the scenic ${recommendation?.name ?? 'location'} @ ${locationFee} / pax',
                    onViewPressed: () {}
                  ),



                  // _buildInfoText('Location:', recommendation!.location),
                  // _buildInfoText('Entrance Fee:', '₱${recommendation!.entranceFee.toStringAsFixed(2)}'),
                ] else ...[
                  const Text('No recommendation available'),
                ],


                const SizedBox(height: 16),

                // Section Title
                // _buildSectionTitle('Pick your recommendation:'),
                const SizedBox(height: 16),

                // Display More Recommendations
                _buildSectionTitle('More Recommendations:'),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: [
                      DestinationCard(
                        imageUrl: 'assets/hardrock.jpg',
                        title: 'HARDROCK LUX SPRING RESORT',
                        description: 'A luxurious experience awaits you!',
                        onViewPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HardRockPage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/mang_inasal.jpg',
                        title: 'MANG INASAL GAISANO',
                        description: 'Enjoy a delicious meal at Mang Inasal.',
                        onViewPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MangInasalPage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/noodlenook.jpg',
                        title: 'NOODLE NOOK',
                        description: 'NOODLES.',
                        onViewPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TheThirdNoodleNookPage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/stritaparishchurch.jpg',
                        title: 'ST. RITAS PARISH CHURCH',
                        description: 'Pray to God.',
                        onViewPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SrParishChurchPage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/theedge.jpg',
                        title: 'THE EDGE',
                        description: 'Experience vibrant city life.',
                        onViewPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TheEdgePage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/thespot.jpg',
                        title: 'THE SPOT',
                        description: 'Taste authentic local cuisine.',
                        onViewPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TheSpotPage(),
                            ),
                          );
                        },
                      ),
                      // New Destinations Added
                      DestinationCard(
                        imageUrl: 'assets/balingasagpark.jpg',
                        title: 'BALINGASAG PARK',
                        description:
                            'Explore the natural beauty of Balingasag Park.',
                        onViewPressed: () {
                          // Temporary navigation to a new page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BalingasagParkPage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/bebedeck.jpg',
                        title: 'BEBEDECK',
                        description: 'Discover the scenic Bebedeck.',
                        onViewPressed: () {
                          // Temporary navigation to a new page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BebedeckPage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/emmanuelspring.jpg',
                        title: 'EMMANUEL SPRING',
                        description: 'Relax and refresh at Emmanuel Spring.',
                        onViewPressed: () {
                          // Temporary navigation to a new page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EmmanuelSpringPage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/escanilla.jpg',
                        title: 'ESCANILLA',
                        description: 'A hidden gem with breathtaking views.',
                        onViewPressed: () {
                          // Temporary navigation to a new page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EscanillaPage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/ipvillage.jpg',
                        title: 'IP VILLAGE',
                        description: 'Experience the culture at IP Village.',
                        onViewPressed: () {
                          // Temporary navigation to a new page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IpVillagePage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/islaverde.jpg',
                        title: 'ISLA VERDE',
                        description: 'Island vibes at Isla Verde.',
                        onViewPressed: () {
                          // Temporary navigation to a new page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IslaVerdePage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/joannasnook.jpg',
                        title: 'JOANNAS NOOK',
                        description: 'A cozy spot for relaxation and food.',
                        onViewPressed: () {
                          // Temporary navigation to a new page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JoannasNookPage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/larocka.jpg',
                        title: 'LA ROCKA',
                        description: 'A unique cultural experience at Jap Tiago.',
                        onViewPressed: () {
                          // Temporary navigation to a new page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LaRockaPage(),
                            ),
                          );
                        },
                      ),
                      DestinationCard(
                        imageUrl: 'assets/linabumountainview.jpg',
                        title: 'LINABU MOUNTAIN VIEW',
                        description: 'Mountain views',
                        onViewPressed: () {
                          // Temporary navigation to a new page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LinabuMountainViewPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Back and Next buttons at the bottom
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // _buildNavigationButton(context, 'Back', '/preferencePage',
                    //     const Color.fromRGBO(72, 111, 111, 1)),
                    // _buildNavigationButton(context, 'Next', '/finishPage',
                    //     const Color.fromRGBO(72, 111, 111, 1),
                    //     textColor: Colors.black),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(46, 79, 79, 1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _gotoHomePage,
                      child: const Text(
                        'NEXT',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),                    
                  ],
                ),
              ],
          ),
        )
      ),
    );
  }

  // Helper Method to Build Info Text
  Widget _buildInfoText(String label, String value) {
    return Text(
      '$label $value',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E4F4F),
      ),
    );
  }

  // Helper Method to Build Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E4F4F),
      ),
    );
  }



  // Helper Method to Build Navigation Button
  Widget _buildNavigationButton(
      BuildContext context, String label, String route, Color backgroundColor,
      {Color textColor = Colors.white}) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the specified route
        Navigator.pushReplacementNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor),
      ),
    );
  }


}


class DestinationCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final VoidCallback onViewPressed;

  const DestinationCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onViewPressed,
        child: Row(
          children: [
            Image.asset(
              imageUrl,
              width: 120,
              height: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E4F4F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Placeholder')),
      body: const Center(child: Text('Placeholder Page')),
    );
  }
}
