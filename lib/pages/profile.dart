import 'package:flutter/material.dart';
import '../addons/about.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
    void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
  @override
  Widget build(BuildContext context) {
    AboutPage ab = AboutPage();
    ab.customStyle(descFontFamily: "Roboto",listTextFontFamily: "RobotoMedium");

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Add logic for editing the profile
            },
          ),
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name and Photo Section
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          radius: 150,
                          backgroundImage: NetworkImage('res/Mukul.jpg'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Mukul Bushi Reddy M',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Flutter Developer',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Details Section
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Age: 20',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Email: mukulmbr@gmail.com',
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children:[
                        Text("Location: Tenali,India "),
                        GestureDetector(
                          onTap: () {
                            _launchURL('https://www.google.co.in/maps/place/16°20\'52.9"N 80°36\'05.1"E');
                          },
                          child: Icon(Icons.location_on),
                        ),
                        ],
                      ),
                    ],
                  ),
                ),


                SizedBox(height: 24),

                // Links Section
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Links',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(flex: 1, child: ab.addEmail("mukulmbr@gmail.com")),
                          Expanded(flex: 1, child: ab.addPhone("+91 8919866652")),
                          Expanded(flex: 1, child: ab.addText("+91 8919866652")),
                        ],
                      ),
                      Row(
                        children:[
                          Expanded(flex: 1, child: ab.addGithub("MukulMBR")),
                          Expanded(flex: 1, child: ab.addWebsite("https://posture2.wordpress.com/")),
                          Expanded(flex: 1, child: ab.addLinkedIn("mukul-bushi-reddy-m-0170471a2")),
                        ],
                      ),
                      Row(
                        children:[
                          Expanded(flex: 1, child: ab.addFacebook("Mukulmbr")),
                          Expanded(flex: 1, child: ab.addInstagram("mukulmbr")),
                          Expanded(flex: 1, child: ab.addTwitter("mmbrmnr")),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
