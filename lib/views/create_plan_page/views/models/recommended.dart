class Recommended {
  final String id;
  final String name;
  final double cost;
  final double facilities;
  final double touristActivities;
  final double accessibility;
  final String createdAt;
  final String updatedAt;

  Recommended({
    required this.id,
    required this.name,
    required this.cost,
    required this.facilities,
    required this.touristActivities,
    required this.accessibility,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create Recommended from a map (e.g., API response)
  factory Recommended.fromMap(Map<String, dynamic> map) {
    return Recommended(
      id: map['id'],
      name: map['name'],
      cost: map['cost'].toDouble(),
      facilities: map['facilities'].toDouble(),
      touristActivities: map['touristActivities'].toDouble(),
      accessibility: map['accessibility'].toDouble(),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  // Method to convert Recommended to a map (for storage or API request)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'facilities': facilities,
      'touristActivities': touristActivities,
      'accessibility': accessibility,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Override toString for better logging
  @override
  String toString() {
    return 'Recommended(id: $id, name: $name, cost: $cost, facilities: $facilities, touristActivities: $touristActivities, accessibility: $accessibility)';
  }
}
