const String tableProducts = 'products';

class TodoFields {
  static final List<String> values = [
    id,
    name,
    isChecked,
    createdAt,
  ];

  static const String id = 'id';
  static const String name = 'name';
  static const String isChecked = 'isChecked';
  static const String createdAt = 'createdAt';
}

class TodoModel {
  int? id;
  String? name;
  int? isChecked;
  String? createdAt;

  TodoModel({this.id, this.name, this.isChecked, this.createdAt});

  TodoModel copy({
    int? id,
    String? name,
    int? isChecked,
    String? createAt,
  }) =>
      TodoModel(
        id: id ?? this.id,
        name: name ?? this.name,
        isChecked: isChecked ?? this.isChecked,
        createdAt: createdAt ?? createdAt,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isChecked': isChecked,
      'created_at': createdAt,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Product{id: $id, name: $name, isChecked: $isChecked}';
  }

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    isChecked = json['isChecked'] ?? '';
    createdAt = json['createdAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isChecked'] = isChecked;
    data['createdAt'] = createdAt;
    return data;
  }

  // static TodoModel fromJson(Map<String, Object?> json) => TodoModel(
  //       id: json[ProductFields.id] as int?,
  //       name: json[ProductFields.name] as String?,
  //       image: json[ProductFields.image] as String?,
  //       interest: json[ProductFields.interest] as String?,
  //       isHot: json[ProductFields.isHot] as int?,
  //       isNew: json[ProductFields.id] as int?,
  //       categoryId: json[ProductFields.categoryId] as int?,
  //       createdAt: json[ProductFields.id] as String?,
  //       updatedAt: json[ProductFields.updatedAt] as String?,
  //       category: json[ProductFields.category] as Category?,
  //     );

  // Map<String, Object?> toJson() => {
  //       ProductFields.id: id,
  //       ProductFields.name: name,
  //       ProductFields.image: image,
  //       ProductFields.interest: id,
  //       ProductFields.isHot: isHot,
  //       ProductFields.isNew: isNew,
  //       ProductFields.categoryId: categoryId,
  //       ProductFields.createdAt: createdAt,
  //       ProductFields.updatedAt: updatedAt,
  //       ProductFields.category: category,
  //     };

  // map(StatelessWidget Function(dynamic e) param0) {}
}
