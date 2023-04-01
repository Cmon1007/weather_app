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
          backgroundColor: const Color(0xff610F7F),
          centerTitle: true,
          title: const Text("View Weather",style: TextStyle(color: Colors.white),),
          actions: [      // help screen page when clicked
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpScreenPageHome(),),
              );
            },
             icon: const Icon(Icons.help_sharp,color: Colors.white,))
          ],
          elevation: 0,
        ),
        backgroundColor: const Color(0xffF6F7EB),
        body: Column(
            children: [
              const SizedBox(height: 18.0,),
              TextField(            // Textfield to enter city name
                     decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                      suffixIcon: Icon(Icons.search,color: Colors.black.withOpacity(0.5),size: 30,),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.black),        
            ),
            enabledBorder: OutlineInputBorder( 
              borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(style:BorderStyle.solid,color: Colors.black),        
                  ),
                  focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(style:BorderStyle.solid,color: Colors.black),        
                  ),
              // hintText: "Search (City)",
              // hintStyle:  const TextStyle(color: Color(0xff14213d)),
              labelText: "Search (City)",
              labelStyle: const TextStyle(color: Color(0xff14213d))
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
           const SizedBox(height: 15.0),
          _weatherData.isNotEmpty
              ? Column(                     // for displaying weather details
                  children: [
                    Text(
                      'City: ${_weatherData['location']['name']}',
                      style: const TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      'Temperature: ${_weatherData['current']['temp_c']}°C',
                      style: const TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15.0,),
                    Text('Condition: ${_weatherData['current']['condition']['text']}',
                     style: const TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold)),
                     const SizedBox(height: 15.0),
                     Image.network('https:${_weatherData['current']['condition']['icon']}',),
                    
                  ],
                )
              : const Center(
                  child: Text('Loading...',
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