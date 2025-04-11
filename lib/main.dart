
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sneex',
      theme: ThemeData(
        fontFamily: "Sans_Regular",
        brightness: Brightness.light,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Color(0xffE8E8E8), width: 1),
          ),
          outlineBorder: BorderSide(
            color: Color(0xffE8E8E8),
            width: 1,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Color(0xffE8E8E8), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Color(0xffE8E8E8), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Color(0xffE8E8E8), width: 1),
          ),
          hoverColor: Colors.transparent,
          labelStyle: TextStyle(color: Color(0xff9E9E9E)),
          hintStyle: TextStyle(color: Color(0xff9E9E9E)),
        ),

        // ✅ Checkbox Themem
        checkboxTheme: CheckboxThemeData(
          splashRadius: 0,
          side: BorderSide(width: 1, color: Color(0xffE8E8E8)),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Color(0xff0139FF);
            }
            return Colors.transparent;
          }),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          color: Color(0xfff3f5fc),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const FreightRatesScreen(),
    );
  }
}

class FreightRatesScreen extends StatefulWidget {
  const FreightRatesScreen({super.key});

  @override
  _FreightRatesScreenState createState() => _FreightRatesScreenState();
}

class _FreightRatesScreenState extends State<FreightRatesScreen> {
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController commodityController = TextEditingController();
  final TextEditingController cutoffDateController = TextEditingController();
  final TextEditingController boxesController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  bool includeNearbyOrigin = false;
  bool includeNearbyDestination = false;
  bool fclSelected = true;
  bool lclSelected = false;

  List<String> universities = [];
  List<String> country = [];

  Future<void> fetchUnivAndCountry() async {
    final response = await http
        .get(Uri.parse('http://universities.hipolabs.com/search?name=middle'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      setState(() {
        universities = data.map<String>((e) => e['name']).toList();
        country = data.map<String>((e) => e['country']).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUnivAndCountry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6eaf8),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Search the best Freight Rates',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xfff3f5fc),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFF2962FF)),
                foregroundColor: Color(0xFF2962FF),
              ),
              child: Text(
                'History',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 18,
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      buildAutoCompleteField(
                          'Origin', originController, country),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: includeNearbyOrigin,
                              onChanged: (val) =>
                                  setState(() => includeNearbyOrigin = val!)),
                          Text(
                            'Include nearby origin ports',
                            style: TextStyle(color: Color(0xff666666)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Column(
                    children: [
                      buildAutoCompleteField(
                          'Destination', destinationController, universities),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: includeNearbyDestination,
                              onChanged: (val) => setState(
                                  () => includeNearbyDestination = val!)),
                          Text('Include nearby destination ports',
                              style: TextStyle(color: Color(0xff666666))),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: buildDropdown(
                          'Commodity', ["Commodity", "Commodity 1"],
                          isFirstSelected: false)),
                  SizedBox(width: 10),
                  Expanded(
                      child: buildTextField(
                          'Cut Off Date', cutoffDateController,
                          isCalender: true,context: context)),
                ],
              ),
              SizedBox(height: 18),
              Text(
                'Shipment Type:',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Checkbox(
                    value: fclSelected,
                    onChanged: (val) {
                      setState(() {
                        fclSelected = val!;
                        if (fclSelected) {
                          lclSelected = !val;
                        }
                      });
                    },
                  ),
                  Text('FCL'),
                  SizedBox(width: 20),
                  Checkbox(
                    value: lclSelected,
                    onChanged: (val) {
                      setState(() {
                        lclSelected = val!;
                        if (lclSelected) {
                          fclSelected = !val;
                        }
                      });
                    },
                  ),
                  Text('LCL'),
                ],
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: buildDropdown('Container Size', [
                        '20\' Standard',
                        '40\' Standard',
                        '60\' Standard',
                      ])),
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: buildTextField('No of Boxes', boxesController,
                          onlyTakeInt: true)),
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: buildTextField('Weight (Kg)', weightController,
                          onlyTakeInt: true)),
                ],
              ),
              SizedBox(height: 15),
              Wrap(alignment: WrapAlignment.end, children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                ),
                Text(
                  ' To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate.',
                  style: TextStyle(fontSize: 13, color: Color(0xff666666)),
                ),
              ]),
              SizedBox(height: 18),
              Text(
                'Container Internal Dimensions:',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
              ),
              SizedBox(height: 18),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Column(
                      spacing: 5,
                      children: [
                        Text('Length ',style: TextStyle(fontSize: 13),),
                        Text('Width ',style: TextStyle(fontSize: 13),),
                        Text('Height ',style: TextStyle(fontSize: 13),),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Column(children: [
                      Text('39.46 ft',style: TextStyle(fontSize: 13),),
                        Text('7.70 ft',style: TextStyle(fontSize: 13),),
                        Text('7.84 ft',style: TextStyle(fontSize: 13),),
                    ],),
                    SizedBox(
                      width: 60,
                    ),
                    Image.asset("assets/images/container.png")
                  ],
                ),
              ),
              SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    backgroundColor: Color(0xFFE6EBFF),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xff0139FF)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Image.asset(
                          'assets/images/search.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Search   ',
                        style: TextStyle(
                          color: Color(0xff0139FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

Widget buildTextField(
  String label,
  TextEditingController controller, {
  bool onlyTakeInt = false,
  bool isCalender = false,
  BuildContext? context,
}) {
  return GestureDetector(
    onTap: () async {
      if (isCalender && context != null) {
        FocusScope.of(context).unfocus(); // hide keyboard
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Color(0xff0139FF), // header background color
                  onPrimary: Colors.white, // header text color
                  onSurface: Colors.black, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xff0139FF), // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          String formattedDate =
              "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
          controller.text = formattedDate;
        }
      }
    },
    child: AbsorbPointer(
      absorbing: isCalender,
      child: TextField(
        controller: controller,
        keyboardType:
            onlyTakeInt ? TextInputType.number : TextInputType.text,
        inputFormatters: onlyTakeInt
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
          suffixIcon: isCalender
              ? Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Image.asset(
                    "assets/images/calender.png",
                    width: 20,
                    height: 20,
                  ),
                )
              : null,
          labelText: label,
          labelStyle: TextStyle(color: Color(0xff9E9E9E)),
          border: OutlineInputBorder(),
        ),
      ),
    ),
  );
}

  Widget buildDropdown(String label, List<String> items,
      {bool isFirstSelected = true}) {
    return DropdownButtonFormField<String>(
      icon: Icon(Icons.keyboard_arrow_down),
      value: isFirstSelected ? items.first : null,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        hintStyle: TextStyle(color: Color(0xff9E9E9E)),
        labelStyle: TextStyle(color: Color(0xff9E9E9E)),
        border: OutlineInputBorder(),
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (val) {},
    );
  }

  Widget buildAutoCompleteField(
      String label, TextEditingController controller, List<String> list) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return list.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        textEditingController.text = controller.text;

        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            prefixIcon: Image.asset("assets/images/location.png"),

            // Sync internal controller with external one
            // Sync internal controller with external one
            labelText: label,
            labelStyle: TextStyle(color: Color(0xff9E9E9E)),

            border: OutlineInputBorder(),
          ),
          // style: TextStyle(color: Color(0xff9E9E9E)),
          onChanged: (val) {
            controller.text = val;
          },
        );
      },
    );
  }
}
