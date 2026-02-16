class Personnel {
  final String? id;
  final String name;
  final String number;
  final String department;

  Personnel({
    this.id,
    required this.name,
    required this.number,
    required this.department,
  });

  // Convert Personnel to JSON
  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'number': number,
      'department': department,
    };
    
    // Only include id if it's not null (for updates)
    if (id != null) {
      json['id'] = id!;
    }
    
    return json;
  }

  // Create Personnel from JSON
  factory Personnel.fromJson(Map<String, dynamic> json) {
    return Personnel(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      department: json['department'] ?? '',
    );
  }

  // Create a copy with updated fields
  Personnel copyWith({
    String? id,
    String? name,
    String? number,
    String? department,
  }) {
    return Personnel(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      department: department ?? this.department,
    );
  }
}
