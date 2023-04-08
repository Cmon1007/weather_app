import 'package:flutter/material.dart';

class HelpScreenPageHome extends StatefulWidget {
  const HelpScreenPageHome({super.key});

  @override
  State<HelpScreenPageHome> createState() => _HelpScreenPageHomeState();
}

class _HelpScreenPageHomeState extends State<HelpScreenPageHome> {
@override
  void initState() {
    super.initState();
    _goToHomee();
  }

  _goToHomee() async{
    await Future.delayed(const Duration(seconds:5));
    if (!mounted) return;
    setState(() {
       Navigator.of(context).pop();   //Will close the page and goes to the page where it previously was.
    });
 
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/rain.png"),  // adding background image
            fit: BoxFit.fill) 
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("We show weather for you",style: TextStyle(color: Colors.black,fontSize: 25),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();    //will go to the previous page.
                },           
               style: ElevatedButton.styleFrom(backgroundColor: Colors.black,fixedSize: const Size(80, 30)),
               child: const Text("SKIP"),
               )
            ],
          )
             )
        ),
    );
      
  }
}