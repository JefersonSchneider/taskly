import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(TarefaApp());

class TarefaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TarefaHomePage(),
    );
  }
}

class TarefaHomePage extends StatefulWidget {
  @override
  _TarefaHomePageState createState() => _TarefaHomePageState();
}

class _TarefaHomePageState extends State<TarefaHomePage> {
  List _tarefas = [];
  List _tarefasFiltradas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

    if (response.statusCode == 200) {
      setState(() {
        _tarefas = json.decode(response.body);
        _tarefasFiltradas = _tarefas;
        _isLoading = false;
      });
    } else {
      throw Exception('Falha ao carregar as tarefas');
    }
  }

  void _filtrarTarefas(String query) {
    List tarefasFiltradas = _tarefas.where((tarefa) {
      return tarefa['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _tarefasFiltradas = tarefasFiltradas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) => _filtrarTarefas(value),
                    decoration: InputDecoration(
                      labelText: 'Buscar tarefa',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _tarefasFiltradas.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_tarefasFiltradas[index]['title']),
                        subtitle: Text('ID: ${_tarefasFiltradas[index]['id']}'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
