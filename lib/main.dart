import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Critérios de Ranson'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatientForm()),
            );
          },
          child: Text('Iniciar Avaliação'),
        ),
      ),
    );
  }
}

class PatientForm extends StatefulWidget {
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  int age = 0;
  int leukocytes = 0;
  double glucose = 0.0;
  int astTgo = 0;
  int ldh = 0;
  bool gallstones = false;

  int score = 0;
  double mortality = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Critérios de Ranson'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                onSaved: (value) => age = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Leucócitos'),
                keyboardType: TextInputType.number,
                onSaved: (value) => leukocytes = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Glicemia'),
                keyboardType: TextInputType.number,
                onSaved: (value) => glucose = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'AST/TGO'),
                keyboardType: TextInputType.number,
                onSaved: (value) => astTgo = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'LDH'),
                keyboardType: TextInputType.number,
                onSaved: (value) => ldh = int.parse(value!),
              ),
              CheckboxListTile(
                title: Text('Pancreatite com Litíase Biliar'),
                value: gallstones,
                onChanged: (value) {
                  setState(() {
                    gallstones = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    calculateScore();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          name: name,
                          age: age,
                          leukocytes: leukocytes,
                          glucose: glucose,
                          astTgo: astTgo,
                          ldh: ldh,
                          gallstones: gallstones,
                          score: score,
                          mortality: mortality,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Calcular'),
              ),
              if (score > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pontuação do paciente: $score'),
                    Text('Mortalidade: $mortality%'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateScore() {
    int ageThreshold = gallstones ? 70 : 55;
    int leukocytesThreshold = gallstones ? 18000 : 16000;
    double glucoseThreshold = gallstones ? 12.2 : 11.0;
    int astTgoThreshold = 250;
    int ldhThreshold = gallstones ? 400 : 350;

    score = 0;

    if (age > ageThreshold) score++;
    if (leukocytes > leukocytesThreshold) score++;
    if (glucose > glucoseThreshold) score++;
    if (astTgo > astTgoThreshold) score++;
    if (ldh > ldhThreshold) score++;

    if (score >= 3) {
      mortality = 100.0;
    } else if (score >= 1) {
      mortality = 40.0;
    } else {
      mortality = 2.0;
    }

    setState(() {});
  }
}

class ResultPage extends StatelessWidget {
  final String name;
  final int age;
  final int leukocytes;
  final double glucose;
  final int astTgo;
  final int ldh;
  final bool gallstones;
  final int score;
  final double mortality;

  ResultPage({
    required this.name,
    required this.age,
    required this.leukocytes,
    required this.glucose,
    required this.astTgo,
    required this.ldh,
    required this.gallstones,
    required this.score,
    required this.mortality,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: $name'),
            Text('Idade: $age'),
            SizedBox(height: 20),
            Text('Pontuação do paciente: $score'),
            Text('Mortalidade: $mortality%'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
