import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();
String? key = database.ref('User').push().key;
TextEditingController emailController = TextEditingController();
TextEditingController passController = TextEditingController();
TextEditingController nameController = TextEditingController();
String? password;
String? name;
String? email;
String? confirmPassword;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vortex Gaming',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  List<Map> data = [];
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //define a list to store data from firebase
  List<Map> userList = [];



  //method to get data from firebase
  void _getData()async {
    FirebaseDatabase.instance.ref().child('User').once().then(
            (DatabaseEvent event) async {
          userList.clear();
          Map values = event.snapshot.value as Map;
          values.forEach((key, value){
            userList.add(value as Map);
          });
        });
  }



  //method to compare login details with data from Firebase
  void _compareData(String email1, String password1) {
    try {
      for (int i = 0; i < userList.length; i++) {
        if (email1 == userList[i]['email'] &&
            password1 == userList[i]['pass']) {
          //push to home page
          //write your code here
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VortexGamingEmporiumApp(),
            ),
          );
        }
      }
    }catch(e){ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text('Invalid email or password ${e.toString()}')));}
  }
  //method to call _compareData on button press
  void _login()async{
    String email1 = emailController.text;
    String password1 = passwordController.text;
    _compareData(email1, password1);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vortex Gaming'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30),
                  ),
                ),
                child:  Icon(Icons.account_circle_rounded),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email',
                    icon: Padding(
                      padding:  EdgeInsets.only(top: 15.0),
                      child:  Icon(Icons.email),
                    )
                ),
                validator: (value) {
                  if (value!.isEmpty|| !value.contains('@') || !value.contains('.')) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                controller: emailController,
              ),
              const SizedBox(height: 30,),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password',
                  icon: Padding(
                    padding:  EdgeInsets.only(top: 15.0),
                    child:  Icon(Icons.lock),

                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    _getData();
                    _login();
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );*/
                  }
                },
                child: const Text('Log In',style: TextStyle(
                    fontSize: 15
                ),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Editaccountdetails(),
                    ),
                  );
                },
                child: const Text('Forgot password',style: TextStyle(
                    fontSize: 15
                ),),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: () {
          // navigate to registration page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  const RegistrationPage(),
            ),
          );
        },
      ),
    );
  }
}

class Editaccountdetails extends StatefulWidget {
  const Editaccountdetails({Key? key}) : super(key: key);

  @override
  State<Editaccountdetails> createState() => EditaccountdetailsState();
}

class EditaccountdetailsState extends State<Editaccountdetails> {
  List<Map> data = [];
  String? selectedKey = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body:Center(
        child: Column(
          children: [
            const SizedBox(height: 15.0),
            TextField(controller: emailController,
              decoration: const InputDecoration(labelText: 'Email',
                  icon: Padding(
                    padding:  EdgeInsets.only(top: 15.0),
                    child:  Icon(Icons.email),
                  )
              ),
            ),
            const SizedBox(height: 15.0),
            TextField(controller: passController,
              decoration: const InputDecoration(labelText: 'Password',
                  icon: Padding(
                    padding:  EdgeInsets.only(top: 15.0),
                    child:  Icon(Icons.password),
                  )
              ),
            ),
            const SizedBox(height: 15.0),
            /*ElevatedButton(
                  onPressed: () {
                    String? key = database.ref('User').push().key;
                    database.ref('User').child(key!).set({
                      'email': emailController.text,
                      'pass': passController.text,
                      'key': key,
                    });
                  },
                  child: const Text('Insert'),
                ),*/
            const SizedBox(height: 15.0),
            ElevatedButton(onPressed: (){
              setState(() {
                database.ref('User').child(selectedKey!).update({
                  'email': emailController.text,
                  'pass': passController.text,
                });
              });
            }, child:const Text('Update'),),
            const SizedBox(height: 15.0),
            /*ElevatedButton(
                  onPressed: () {
                    database.ref('User').child(selectedKey!).remove();
                  },
                  child: const Text('Delete'),
                ),
                const SizedBox(height: 15.0),*/
            ElevatedButton(
              onPressed: () async {
                DatabaseEvent d = await database.ref('User').once();
                Map temp = d.snapshot.value as Map;
                data.clear();
                temp.forEach((key, value) {
                  data.add(value);
                });
                setState(() {});
              },
              child: const Text('Find'),
            ),
            const SizedBox(height: 15.0),
            Expanded(
              child: GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                      onTap: () {
                        emailController.text = data[index]['email'];
                        passController.text = data[index]['pass'];
                        selectedKey = data[index]['key'];
                      },
                      child: Text(
                        data[index]['email'],
                        style: const TextStyle(fontSize: 30.0),
                      ),

                    ),
              ),
            ),
          ],
        ),
      ),
    ),
    );

  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _maritalStatus;
  String? _gender;
  final List<String> _genderList = ["Male", "Female", "Other", "Rather Not Say"];
  final List<String> _maritalStatusList = [
    "Single (unmarried)",
    "Married",
    "Divorced",
    "Widowed",
    "Separated",
    "Co-habiting (unmarried but living with a partner)"
  ];


  //here Date time picker

  DateTime? _birthDate;
  String? _age;

  String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return 'Your age is $age years';
  }

  //end here datetime picker


  //here section for checkbox
  Map<String, bool> hobbies = {
    'Reading': false,
    'Writing': false,
    'Painting': false,
    'Singing': false,
    'Dancing': false,
  };

  int selectedHobbies = 0;

  void toggle(String hobby) {
    setState(() {
      hobbies[hobby] = !hobbies[hobby]!;
      if (hobbies[hobby]!) {
        selectedHobbies++;
      } else {
        selectedHobbies--;
      }
    });
  }

  void enable(String hobby, bool value) {
    setState(() {
      hobbies[hobby] = value;
    });
  }
  List<String> selectedHobbiesList = [];


  //checkbox section end here

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
            appBar: AppBar(
              title: const Text('Create an Account'),
            ),

            body: SingleChildScrollView(
              child:Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children : [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name',
                            icon: Padding(
                              padding:  EdgeInsets.only(top: 15.0),
                              child:  Icon(Icons.person),
                            )
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onSaved: (value) => name = value,
                      ),
                      const SizedBox(height: 30,),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email',
                            icon: Padding(
                              padding:  EdgeInsets.only(top: 15.0),
                              child:  Icon(Icons.email),
                            )
                        ),
                        validator: (value) {
                          if (value!.isEmpty|| !value.contains('@') || !value.contains('.')) {
                            return 'Please enter an email';
                          }
                          return null;
                        },
                        onSaved: (value) => email = value,
                      ),
                      const SizedBox(height: 30,),

                      TextFormField(controller: passController,
                        decoration: const InputDecoration(labelText: 'Password',
                            icon: Padding(
                              padding:  EdgeInsets.only(top: 15.0),
                              child:  Icon(Icons.lock),
                            )
                        ),
                        validator: (value) {
                          if (value == null||value.isEmpty) {
                            return 'Please enter a password';
                          }
                          else if(value.length < 6){return 'Password too short.'; }
                          else{
                            password = value;
                          }
                          return null;
                        },
                        obscureText: true,

                      ),
                      const SizedBox(height: 30,),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Confirm Password',
                            icon: Padding(
                              padding:  EdgeInsets.only(top: 15.0),
                              child:  Icon(Icons.lock),
                            )

                        ),
                        validator: (value) {
                          if (value != password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        obscureText: true,
                        onSaved: (value) => confirmPassword = value,
                      ),
                      const SizedBox(height: 30,),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Birthdate',
                          icon: Padding(
                            padding:  EdgeInsets.only(top: 15.0),
                            child:  Icon(Icons.person_rounded),
                          ),
                        ),

                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          _birthDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (_birthDate != null) {
                            setState(() {
                              _age = calculateAge(_birthDate!);
                            });
                          }
                        },
                        readOnly: true,
                        validator: (value) {
                          if (_birthDate == null) {
                            return 'Please enter your birthdate';
                          }
                          return null;
                        },
                        controller: TextEditingController(
                          text: _birthDate == null ? '' : DateFormat.yMd().format(_birthDate!),
                        ),
                      ),
                      const SizedBox(height: 20),


                      Text(
                        _age ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      Column(
                        children: <Widget>[
                          const Text("Gender"),
                          const SizedBox(width: 10.0),
                          ..._genderList.map((gender) {
                            return Row(
                              children: <Widget>[
                                Text(gender),
                                Radio(
                                    value: gender,
                                    groupValue: _gender,
                                    onChanged: (val) {
                                      setState(() {
                                        _gender = val;
                                      });
                                    }),
                              ],
                            );
                          }).toList(),
                        ],
                      ),

                      const SizedBox(height: 30,),
                      Column(
                        children:[
                          const Text("Marital Status"),
                          const SizedBox(width: 30.0),
                          /*
                      '...' is the spread operator in Dart programming language.
                       It is used to spread the elements of an iterable (such as a list or an array) into a new list.
                        In this code, it is used to spread the elements of
                        the _maritalStatusList list into the children property of the Row widget,
                       so that each element of the list is displayed as a separate child of the Row widget.
                   */
                          ..._maritalStatusList.map((status) {
                            return Row(
                              children: <Widget>[
                                Text(status),
                                Radio(
                                    value: status,
                                    groupValue: _maritalStatus,
                                    onChanged: (val) {
                                      setState(() {
                                        _maritalStatus = val;
                                      });
                                    }),
                              ],
                            );
                          }).toList(),
                          const SizedBox(height: 10.0),
                          const Text('Hobbies',
                            style: TextStyle(fontSize: 14,),
                          ),
                          const SizedBox(height: 10.0),


                          Column(
                            children: hobbies.keys.map((String key) {
                              return CheckboxListTile(
                                value: hobbies[key],
                                onChanged: selectedHobbies < 3
                                    ? (bool? value) {
                                  toggle(key);
                                  if (selectedHobbies == 3) {
                                    hobbies.keys.forEach((String disabledHobby) {
                                      if (!hobbies[disabledHobby]!) {
                                        enable(disabledHobby, false);
                                      }
                                    });
                                  }
                                  selectedHobbiesList.clear();
                                  hobbies.forEach((key, value) {
                                    if (value) {
                                      selectedHobbiesList.add(key);
                                    }
                                  });

                                }
                                    : null,
                                title: Text(key),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 30,),

                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // Perform registration here

                                database.ref('User').child(key!).set({
                                  'Name': nameController.text,
                                  'email': emailController.text,
                                  'pass': passController.text,
                                  'key': key,
                                  'age': _age,
                                  'birthdate': _birthDate.toString(),
                                  'Marital Status': _maritalStatus.toString(),
                                  'Hobbies': selectedHobbiesList.toString()
                                });
                                Navigator.pop(context);
                              }
                            }
                            ,
                            child: const Text('Sign Up'),
                          ),
                        ],
                      ),
                    ]
                ),
              ),
            )
        )
    );
  }
}

class VortexGamingEmporiumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vortex Gaming Emporium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        fontFamily: 'Roboto',
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    BookingPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vortex Gaming Emporium'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool isShopOpen = true; // Replace this with the status set by admin

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vortex Gaming Emporium'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store Opening Hours',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '9:00 AM - 7:00 PM',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Price per Slot:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            PriceCard(
              title: 'Common Zone',
              price: 'Rs. 15/- per 30m',
            ),
            PriceCard(
              title: 'Private Room',
              price: 'Rs. 40/- per 1 hour',
            ),
            PriceCard(
              title: 'Game Zone',
              price: 'Rs. 60/- per 1 hour',
            ),
            SizedBox(height: 16),
            Text(
              "Today's Shop Status:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              isShopOpen ? 'Open' : 'Closed',
              style: TextStyle(
                fontSize: 16,
                color: isShopOpen ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  final String title;
  final String price;

  const PriceCard({
    Key? key,
    required this.title,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('History Page'),
    );
  }
}

class BookingPage extends StatelessWidget {
  final List<String> gameImages = [
    'assets/images/game1.jpg',
    'assets/images/game2.jpg',
    'assets/images/game3.jpg',
    'assets/images/game4.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ImageSlider(gameImages: gameImages),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to Common Zone screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CommonZoneScreen()),
                          );
                        },
                        child: ImageCard(
                          image: 'assets/images/common_zone.png',
                          title: 'Common Zone - 20 Group Computers',
                          description: 'Enjoy gaming in a shared environment with other gamers.',
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Private Room screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PrivateRoomScreen()),
                          );
                        },
                        child: ImageCard(
                          image: 'assets/images/private_room.png',
                          title: 'Private Room - 10 PCs Available',
                          description: 'Book a private room for a more personalized gaming experience.',
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Game Room screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GameRoomScreen()),
                          );
                        },
                        child: ImageCard(
                          image: 'assets/images/vrgame_room.png',
                          title: 'Game Room - Choose a Platform (Xbox, PlayStation, VR)',
                          description: 'Indulge in your favorite gaming platform.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSlider extends StatefulWidget {
  final List<String> gameImages;

  const ImageSlider({Key? key, required this.gameImages}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.gameImages.length,
          onPageChanged: (int index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return Image.asset(
              widget.gameImages[index],
              fit: BoxFit.cover,
            );
          },
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.gameImages.length, (index) {
              return Container(
                width: 10,
                height: 10,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class ImageCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const ImageCard({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class CommonZoneScreen extends StatefulWidget {
  @override
  _CommonZoneScreenState createState() => _CommonZoneScreenState();
}

class _CommonZoneScreenState extends State<CommonZoneScreen> {
  List<Computer> computers = [];
  List<int> selectedComputers = [];

  void bookComputer(int id) {
    setState(() {
      if (selectedComputers.contains(id)) {
        selectedComputers.remove(id);
      } else {
        selectedComputers.add(id);
      }
    });
  }

  void handleBooking() {
    if (selectedComputers.isEmpty) {
      // Show an error message indicating that no computers are selected
      return;
    }

    // Implement the booking logic here
    // You can integrate with Firebase or your backend to save the booking information
    // Example:
    // for (int computerId in selectedComputers) {
    //   // Set the corresponding computer as booked in the database
    //   // ...
    // }

    // Clear the selected computers list
    setState(() {
      selectedComputers.clear();
    });

    // Show a success message or navigate to a new screen
    // ...
  }

  @override
  void initState() {
    super.initState();
    // Initialize the list of computers
    for (int i = 1; i <= 20; i++) {
      computers.add(Computer(id: i, isBooked: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Common Zone'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          SizedBox(height: 16),
          Text(
            'Common Zone - 20 Group Computers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4, // Show 4 computers per row
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.5,
            physics: NeverScrollableScrollPhysics(),
            children: computers.map((computer) {
              bool isSelected = selectedComputers.contains(computer.id);
              return GestureDetector(
                onTap: () => bookComputer(computer.id),
                child: Container(
                  decoration: BoxDecoration(
                    color: computer.isBooked ? Colors.grey : isSelected ? Colors.blue : Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      computer.isBooked ? 'Booked' : 'Computer ${computer.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: computer.isBooked ? Colors.white : isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Text(
            'Selected Computers: ${selectedComputers.length}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Selected Computers: ${selectedComputers.length}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),

          // Additional services checkboxes
          Text(
            'Additional Services',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          CheckboxListTile(
            title: Text('Fast Internet'),
            value: false,
            onChanged: (value) {
              // Handle fast internet checkbox
            },
          ),
          CheckboxListTile(
            title: Text('Headphones'),
            value: false,
            onChanged: (value) {
              // Handle headphones checkbox
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: handleBooking,
            child: Text('Book'),
          ),
        ],
      ),
    );
  }
}

class PrivateRoomScreen extends StatefulWidget {
  @override
  _PrivateRoomScreenState createState() => _PrivateRoomScreenState();
}

class _PrivateRoomScreenState extends State<PrivateRoomScreen> {
  List<Room> rooms = [];
  List<int> selectedRooms = [];

  @override
  void initState() {
    super.initState();
    // Initialize the list of rooms
    for (int i = 1; i <= 10; i++) {
      rooms.add(Room(id: i, isBooked: false));
    }
  }

  void bookRoom(int id) {
    setState(() {
      if (selectedRooms.contains(id)) {
        selectedRooms.remove(id);
      } else {
        selectedRooms.add(id);
      }
    });
  }

  void handleBooking() {
    if (selectedRooms.isEmpty) {
      // Show an error message indicating that no rooms are selected
      return;
    }

    // Check if any of the selected rooms are already booked
    List<int> alreadyBookedRooms = selectedRooms.where((id) => rooms[id - 1].isBooked).toList();

    if (alreadyBookedRooms.isNotEmpty) {
      // Show an error message indicating that some rooms are already booked
      String roomNumbers = alreadyBookedRooms.join(', ');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Booking Error'),
            content: Text('Rooms $roomNumbers are already booked.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Implement the booking logic here
    // You can integrate with Firebase or your backend to save the booking information
    // Example:
    // for (int roomId in selectedRooms) {
    //   // Set the corresponding room as booked in the database
    //   // ...
    // }

    // Clear the selected rooms list
    setState(() {
      selectedRooms.clear();
    });

    // Show a success message or navigate to a new screen
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Private Room'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          SizedBox(height: 16),
          Text(
            'Private Room - 10 PCs Available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4, // Show 4 rooms per row
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.5,
            physics: NeverScrollableScrollPhysics(),
            children: rooms.map((room) {
              bool isSelected = selectedRooms.contains(room.id);
              return GestureDetector(
                onTap: () => bookRoom(room.id),
                child: Container(
                  decoration: BoxDecoration(
                    color: room.isBooked ? Colors.grey : isSelected ? Colors.blue : Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      room.isBooked ? 'Booked' : 'Room ${room.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: room.isBooked ? Colors.white : isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Text(
            'Selected Rooms: ${selectedRooms.length}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: handleBooking,
            child: Text('Book'),
          ),
        ],
      ),
    );
  }
}

class GameRoomScreen extends StatefulWidget {
  @override
  _GameRoomScreenState createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  List<GameStation> gameStations = [];
  List<int> selectedStations = [];
  List<String> platforms = ['Xbox', 'PlayStation', 'VR'];
  String selectedPlatform = 'Xbox';

  @override
  void initState() {
    super.initState();
    // Initialize the list of game stations
    for (int i = 1; i <= 10; i++) {
      gameStations.add(GameStation(id: i, isBooked: false));
    }
  }

  void bookStation(int id) {
    setState(() {
      if (selectedStations.contains(id)) {
        selectedStations.remove(id);
      } else {
        selectedStations.add(id);
      }
    });
  }

  void handleBooking() {
    if (selectedStations.isEmpty) {
      // Show an error message indicating that no stations are selected
      return;
    }

    // Implement the booking logic here
    // You can integrate with Firebase or your backend to save the booking information
    // Example:
    // for (int stationId in selectedStations) {
    //   // Set the corresponding station as booked in the database
    //   // ...
    // }

    // Clear the selected stations list
    setState(() {
      selectedStations.clear();
    });

    // Show a success message or navigate to a new screen
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Room'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          SizedBox(height: 16),
          Text(
            'Game Room - Choose a Platform',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedPlatform,
            items: platforms.map((platform) {
              return DropdownMenuItem<String>(
                value: platform,
                child: Text(platform),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedPlatform = value!;
              });
            },
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4, // Show 4 game stations per row
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.5,
            physics: NeverScrollableScrollPhysics(),
            children: gameStations.map((station) {
              bool isSelected = selectedStations.contains(station.id);
              return GestureDetector(
                onTap: () => bookStation(station.id),
                child: Container(
                  decoration: BoxDecoration(
                    color: station.isBooked ? Colors.grey : isSelected ? Colors.blue : Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      station.isBooked ? 'Booked' : 'Station ${station.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: station.isBooked ? Colors.white : isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Text(
            'Selected Stations: ${selectedStations.length}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: handleBooking,
            child: Text('Book'),
          ),
        ],
      ),
    );
  }
}

// special class
class Computer {
  final int id;
  final bool isBooked;

  Computer({required this.id, required this.isBooked});
}
//special class
class GameStation {
  final int id;
  final bool isBooked;

  GameStation({required this.id, required this.isBooked});
}
//special classs
class Room {
  final int id;
  final bool isBooked;

  Room({required this.id, required this.isBooked});
}




