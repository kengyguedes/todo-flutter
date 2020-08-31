import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/Todo.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;
  final int index;

  TodoItem({Key key, @required this.todo, @required this.index}) : super(key: key);

  @override
  _TodoItemState createState() => _TodoItemState(todo, index);
}

class _TodoItemState extends State<TodoItem> {
  // List
  Todo _todo;
  int _index;
  // Controler
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  _TodoItemState(Todo todo, int index){
    this._todo = todo;
    this._index = index;
    if(_todo!=null){
      this._tituloController.text = todo.titulo;
      this._descricaoController.text = todo.descricao;
    }
  }

  _saveItem() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('lista');
    List<Todo> list = [];

    if(data != null){
      var objs = jsonDecode(data) as List;
      list = objs.map((e) => Todo.fromJson(e)).toList();
    }

    _todo= new Todo.fromTituloDescricao(_tituloController.text, _descricaoController.text);
    if(_index != -1){
      list[_index] = _todo;
    }else{
      list.add(_todo);
    }
    preferences.setString('lista', jsonEncode(list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Todo Item'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _tituloController,
              decoration: InputDecoration(
                hintText: 'Título',
                border: OutlineInputBorder()
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                hintText: 'Descrição',
                border: OutlineInputBorder()
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonTheme(
              minWidth: double.infinity,
              child: RaisedButton(
                child: Text('Salvar', style: TextStyle(
                    fontSize: 16.0
                ),),
                color: Colors.green,
                textColor: Colors.white,
                onPressed: _saveItem,
              )
            ),
          )
        ],
      ),
    );
  }
}
