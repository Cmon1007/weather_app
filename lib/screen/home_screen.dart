import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:weatherapp/screen/help_screen_home.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _cityname="";
  bool _buttonLoaded=false;
  Map<String, dynamic> _weatherData={}; 

  //Calling Api with http request
   void _getWeatherData() async
  {
    if(_cityname.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text("Error: Please enter a City Name"),
        duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    Response response=await get(Uri.parse(
      "http://api.weatherapi.com/v1/current.json?key=bcf129e6d8a045f881d43921232703&q=$_cityname&aqi=no"));
  if(response.statusCode==200)
  {
    setState(() {
      _weatherData=jsonDecode(response.body);
      _buttonLoaded=true;
    });
  }
 else
  {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Couldn't find the City name"),
      duration: Duration(seconds: 2),
      )
    );
  }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff7895B2),
          centerTitle: true,
          title: const Text(" Weather"),
          actions: [      // help screen page when clicked
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpScreenPageHome(),),
              );
            },
             icon: const Icon(Icons.help_sharp))
          ],
          elevation: 0,
        ),
        backgroundColor: const Color(0xffAEBDCA),
        body: Column(
            children: [
              TextField(            // Textfield to enter city name
                     decoration:  const InputDecoration(
              hintText: "Search (City)",
              hintStyle:  TextStyle(color: Color(0xff14213d)),
                     ),
              onChanged: (value) {
                setState(() {
                  _cityname=value;
                });
              },
       ),         
          ElevatedButton(             //Button for searching data
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed:(){
              setState(() {
                _getWeatherData();
              });
             } ,
           child: Text(_buttonLoaded?"UPDATE":"SAVE"),
           ),
           const SizedBox(height: 16.0),
          _weatherData.isNotEmpty
              ? Column(                     // for displaying weather details
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
      ),
    );   

    }
    // For getting default data with current latitude and longitute of user using location package
  void _getDefaultWeatherData() async
  {
    final location=Location();
    LocationData? currentLocation;
    try{
      currentLocation= await location.getLocation();
    }
    catch(e)
    {
      return null;
    }
    Response response=await get(Uri.parse(
      "http://api.weatherapi.com/v1/current.json?key=bcf129e6d8a045f881d43921232703&q=${currentLocation.latitude},${currentLocation.longitude}&aqi=no"),
      );
    try
    {
      if(response.statusCode==200)
    {
      setState(() {
        _weatherData=jsonDecode(response.body);
      });
    }
    }
    catch(e)
    {
      return null;
    }  
  }
   
@override
  void initState() {
    super.initState();
    _getDefaultWeatherData();
  }
  }