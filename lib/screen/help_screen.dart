import 'package:flutter/material.dart';
import 'package:weatherapp/screen/home_screen.dart';
class HelpScreenPage extends StatefulWidget {
  const HelpScreenPage({super.key});

  @override
  State<HelpScreenPage> createState() => _HelpScreenPageState();
}

class _HelpScreenPageState extends State<HelpScreenPage> {
@override
  void initState() {
    super.initState();
    _goToHome();
  }

  _goToHome() async{
    await Future.delayed(const Duration(seconds:5));  // stays active for 5 seconds.
      if (!mounted) return;
    setState(() {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const HomePage()));  //will route the page to HomePage
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
            image: DecorationImage(image: AssetImage("assets/images/rain.png"),  //Background frame image
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const HomePage()));   // route the page to HomePage when skip button is clicked
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
