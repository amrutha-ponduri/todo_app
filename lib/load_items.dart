class LoadItems{
  final String id;
  final String title;
  final String description;
  final bool iscompleted;
  const LoadItems({required this.id,required this.title, required this.description, required this.iscompleted,});
  factory LoadItems.fromJson(Map<String,dynamic> json){
    return LoadItems(id: json['_id'],title: json['title'], description: json['description'], iscompleted: json['is_completed']);
  }
}