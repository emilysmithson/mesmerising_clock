import 'package:flutter/material.dart';
import 'analog_clock.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'color_model.dart';
import 'information_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _handThickness = 1;

  bool _showSettings = false;
  bool _showSettingsButton = false;
  final globalKey = GlobalKey<ScaffoldState>();
  int _currentColor = 0;

  int id = 0;

  @override
  Widget build(BuildContext context) {
    bool _colorSelected = false;

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: _showSettings ? true : false,
            child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    saveCurrentSelection();
                  });
                },
                foregroundColor: Colors.grey,
                backgroundColor: Color(0x00000000),
                elevation: 0,
                child: Icon(
                  Icons.save,
                )),
          ),
          Visibility(
            visible: _showSettingsButton ? true : false,
            child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _showSettings = !_showSettings;
                    if (!_showSettings) {
                      _showSettingsButton = false;
                      _currentColor = 7;
                    }
                  });
                },
                foregroundColor: Colors.grey,
                backgroundColor: Color(0x00000000),
                elevation: 0,
                child: Icon(
                  _showSettings ? Icons.clear : Icons.settings,
                )),
          ),
        ],
      ),
      body: Stack(
        children: [
          _showSettings
              ? SafeArea(
                  child: ListView(
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_showSettings) {
                                _showSettings = false;
                                _showSettingsButton = false;
                              } else {
                                _showSettingsButton = true;
                              }
                            });
                          },
                          child: AnalogClock()),
                      settingsWidget()
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_showSettings) {
                        _showSettings = false;
                        _showSettingsButton = false;
                      } else {
                        _showSettingsButton = true;
                      }
                    });
                  },
                  child: AnalogClock()),
          SafeArea(
            child: Align(
                alignment: Alignment.topLeft,
                child: Visibility(
                    visible: _showSettingsButton ? true : false,
                    child: IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _showSettingsButton = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InformationPage()),
                        );
                      },
                    ))),
          )
        ],
      ),
    );
  }

  Widget settingsWidget() {
    return Column(
      children: [
        Slider(
          value: currentHandThickness,
          min: 0.5,
          max: 3,
          onChanged: (value) {
            setState(() {
              currentHandThickness = value;
            });
          },
          label: '$currentHandThickness',
        ),
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: currentColor.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentColor = index;
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border:
                              Border.all(width: _currentColor == index ? 3 : 0),
                          color: currentColor[index]),
                      height: 50,
                      width: 50),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
         ColorPicker(
                displayThumbColor: true,
                pickerAreaHeightPercent: 0.3,
                pickerAreaBorderRadius: BorderRadius.circular(10.0),
                pickerColor: _currentColor == 7
                    ? Colors.black
                    : currentColor[_currentColor],
                onColorChanged: (color) {
                  setState(() {
                    changeColor(_currentColor, color);
                  });
                },
                showLabel: true,
              ),
        SizedBox(height: 10),
        Container(
          height: 500,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: clockSettingsList.length,
              itemBuilder: (context, i) {
                List<Color> listColors = [
                  clockSettingsList[i].backgroundColor,
                  clockSettingsList[i].clockFace,
                  clockSettingsList[i].secondsClockwise,
                  clockSettingsList[i].secondsAnticlockwise,
                  clockSettingsList[i].minutesClockwise,
                  clockSettingsList[i].minutesAntiClockwise,
                ];
                List<Widget> optionButton = List<Widget>();
                for (int i = 0; i < listColors.length; i++) {
                  optionButton.add(Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: listColors[i]),
                        height: 20,
                        width: 20),
                  ));
                }
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            resetColors(i);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: i==currentColorSelection? 4:2)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 20,
                              child: Row(children: optionButton),
                            ),
                          ),
                        ),
                      ),
                    ),
                    i == 0
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                deleteColors(i);
                              });
                            },
                            icon: Icon(Icons.delete))
                  ],
                );
              }),
        ),
      ],
    );
  }

  @override
  void initState() {
    DatabaseHelper helper = DatabaseHelper.instance;
    helper.getUserDb();

    super.initState();
  }
}
