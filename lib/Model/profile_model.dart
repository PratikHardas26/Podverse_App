class ProfileModel {
  String name;
  String id;

  ProfileModel({required this.id, required this.name});

  @override
  String toString() {
    return 'ProfileModel(id: $id, name: $name)';
  }
}
