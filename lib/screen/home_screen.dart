import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:weatherapp/screen/help_screen.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> _weatherData={}; 
  @override
  void initState() {
    super.initState();
    _getWeatherData();
  }

   void _getWeatherData() async
  {
    Response response=await get(Uri.parse(
      "http://api.weatherapi.com/v1/current.json?key=bcf129e6d8a045f881d43921232703&q=Kathmandu&aqi=no"));
  if(response.statusCode==200)
  {
    setState(() {
      _weatherData=jsonDecode(response.body);
    });
  }
  else
  {
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(" Weather"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpScreenPage(),),
            );
          },
           icon: const Icon(Icons.help_sharp))
        ],
      ),
      body: Column(
          children: [
           const TextField(
                   decoration:  InputDecoration(
            hintText: "Search (City)",
            hintStyle:  TextStyle(color: Color(0xff14213d)),
             
                   )
     ),         
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed:(){ } ,
         child: const Text("Search"),
         ),
         const SizedBox(height: 16.0),
        _weatherData.isNotEmpty
            ? Column(
                children: [
                  Text(
                    '${_weatherData['location']['name']}',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    '${_weatherData['current']['temp_c']}°C',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(height: 16.0,),
                  Text('${_weatherData['current']['condition']['text']}',
                   style: const TextStyle(fontSize: 24.0)),
                   const SizedBox(height: 16.0),
                   Image.network('https:${_weatherData['current']['condition']['icon']}',),
                  
                ],
              )
            : const Center(
                child: Text('Weather Details',
                style: TextStyle(fontSize: 24.0),),
              )
          ]
      )
    );   

    }
  }