import 'package:flutter/material.dart';
import 'package:todo/load_items.dart';
import 'package:todo/pages/add_todo_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<LoadItems> tasks=[];
   @override
    void initState() {
     super.initState();
     fetchTasks();
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Your ToDo list'),
      ),
      body: RefreshIndicator(
        onRefresh: (){
          return fetchTasks();
        },
        child: ListView.builder(itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.lightBlueAccent,
              ),
              child: ListTile(

                leading: Checkbox(value: tasks[index].iscompleted, onChanged: (value){
                  updateCheck(todo:tasks[index]);
                },),
                title: Text(tasks[index].title),
                subtitle: Text(tasks[index].description),
                trailing: PopupMenuButton(onSelected: (value){
                  if(value=='edit')
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTodoPage(todo:tasks[index])));
                  }
                  else if(value=='delete'){
                    deleteItem(tasks[index].id);
                  }
                },
                  itemBuilder: (context) {
                  return [
                    const PopupMenuItem(value: 'edit',child: Text('Edit'),),
                    const PopupMenuItem(value: 'delete',child: Text('Delete'),),
                  ];
                },),
              ),
            ),
          );
        },itemCount: tasks.length,),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTodoPage(),));
      },
        child: const Icon(Icons.add),
      ),
    );
  }
  fetchTasks() async{
    const url='https://api.nstack.in/v1/todos?page=1&limit=20';
    final uri=Uri.parse(url);
    final response=await http.get(uri);
    final jsonObj=jsonDecode(response.body);
    final items=jsonObj['items'] as List<dynamic>;
    final transformed=items.map((e) {
      return LoadItems.fromJson(e);
    },).toList();
    setState(() {
      tasks=transformed;
    });
  }
  deleteItem(String id) async{
    final url='https://api.nstack.in/v1/todos/$id';
    final uri=Uri.parse(url);
    await http.delete(uri);
    fetchTasks();
  }
  void updateCheck({required LoadItems todo}) async{
    var body={
      "title":todo.title,
      "description":todo.description,
      "is_completed":!todo.iscompleted
    };
    final id=todo.id;
    final url='https://api.nstack.in/v1/todos/$id';
    final uri=Uri.parse(url);
    await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body)
    );
    fetchTasks();
  }
}
