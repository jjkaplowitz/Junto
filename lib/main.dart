import 'dart:io';
import 'dart:math';
import 'API.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

String userLikes = "dogs,movies,food";
void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
  //runApp(MyApp());
}

String sort = 'Newest';
List<dynamic> _dataM = [];
List<dynamic> dataPerm = [];
bool _loading = false;

class DataTable extends StatefulWidget {
  @override
  DataTableState createState() => DataTableState();
}

class DataTableState extends State<DataTable> {
  List<List<dynamic>> _data = [];

  void initState() {
    super.initState();
    _load();
  }

  void _loadCSVUpvotes() async {
    // final _rawData = await rootBundle.loadString("assets/reddit_questions.csv");
    // const conv = CsvToListConverter(fieldDelimiter: ';');
    // List<List<dynamic>> _listData = conv.convert(_rawData);

    // _listData.sort((b, a) => a[2].compareTo(b[2]));

    String url = 'http://127.0.0.1:5000/upvote';
    String data = await Getdata(url);
    List<String> _listofposts = data.split("|");
    List<List<String>> _listData = [];
    for (int i = 0; i < _listofposts.length - 1; i++) {
      //add each post to list data
      _listData.add(_listofposts[i].split(";"));
    }

    setState(() {
      _data = _listData;
    });
  }

  void _loadCSNewest() async {
    /*final _rawData = await rootBundle.loadString("assets/reddit_questions.csv");
    const conv = CsvToListConverter(fieldDelimiter: ';');
    List<List<dynamic>> _listData = conv.convert(_rawData);

    _listData.sort((b, a) => a[3].toString().compareTo(b[3].toString()));
    */
    String url = 'http://127.0.0.1:5000/newest';
    String data = await Getdata(url);
    List<String> _listofposts = data.split("|");
    List<List<String>> _listData = [];
    for (int i = 0; i < _listofposts.length - 1; i++) {
      //add each post to list data
      _listData.add(_listofposts[i].split(";"));
    }

    setState(() {
      _data = _listData;
    });
  }

  void _loadMostPopular() async {
    // final _rawData = await rootBundle.loadString("assets/reddit_questions.csv");
    // const conv = CsvToListConverter(fieldDelimiter: ';');
    // List<List<dynamic>> _listData = conv.convert(_rawData);

    // _listData.sort((b, a) =>
    //     ((log(a[2]) / 2.30258509299) + (a[3] - 1134028003) / 4500000).compareTo(
    //         (log(b[2]) / 2.30258509299) + (b[3] - 1134028003) / 4500000));

    String url = 'http://127.0.0.1:5000/popular';
    String data = await Getdata(url);
    List<String> _listofposts = data.split("|");
    List<List<String>> _listData = [];
    for (int i = 0; i < _listofposts.length - 1; i++) {
      //add each post to list data
      _listData.add(_listofposts[i].split(";"));
    }
    setState(() {
      _data = _listData;
    });
  }

  void _loadRecommend() async {
    String url = 'http://127.0.0.1:5000/rec?Query=' + userLikes;
    String data = await Getdata(url);
    List<String> _listofposts = data.split("|");
    List<List<String>> _listData = [];
    for (int i = 0; i < _listofposts.length - 1; i++) {
      //add each post to list data
      _listData.add(_listofposts[i].split(";"));
    }
    setState(() {
      _data = _listData;
    });
  }

  void _load() {
    if (sort == 'Newest') {
      _loadCSNewest();
    } else if (sort == 'Most Upvoted') {
      _loadCSVUpvotes();
    } else if (sort == 'Most Popular') {
      _loadMostPopular();
    } else if (sort == 'Recommended') {
      _loadRecommend();
    }
  }

//buildFloatingSearchBar()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, index) {
          return Card(
            margin: const EdgeInsets.all(3),
            color: Colors.white,
            child: ListTile(
              leading: Text(_data[index][2].toString()),
              title: Text(_data[index][0].toString()),
              trailing: Text(_data[index][1].toString()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          _load();
        },
      ),
    );
  }
}

//START JANTZENS TAG TAB CODE

String tag = "tags";

class TagDataTable extends StatefulWidget {
  @override
  TagDataTableState createState() => TagDataTableState();
}

class TagDataTableState extends State<TagDataTable> {
  List<List<dynamic>> _data = [];

  void initState() {
    super.initState();
    _loadAll();
  }

  void _loadAll() async {
    final _rawData = await rootBundle.loadString("stack_questions_short.csv");
    const conv = CsvToListConverter(fieldDelimiter: ',');
    List<List<dynamic>> _listData = conv.convert(_rawData);
    List<List<dynamic>> _listDataTemp = [];
    //TAG SORTING SECTION, IF TAG IS SELECTED
    if (tag != "tags") {
      for (var i = 0; i < _listData.length; i++) {
        List<String> tags = _listData[i][3].split(",");
        for (var j = 0; j < tags.length; j++) {
          if (tags[j].trim().contains(tag.trim())) {
            _listDataTemp.add(_listData[i]);
          }
        }
      }
    } else {
      _listDataTemp = _listData;
    }

    setState(() {
      _data = _listDataTemp;
    });
  }

//buildFloatingSearchBar()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, index) {
          return Card(
            margin: const EdgeInsets.all(3),
            color: Colors.white,
            child: ListTile(
              title: Text(_data[index][2].toString()),
              trailing: Text(_data[index][3].toString()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          _loadAll();
        },
      ),
    );
  }
}

//END JANTZENS TAG TAB CODE

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var d = DataTableState();

  get mainAxisSize => null;
  void _refresh() {
    d._load();
  }

  int _value = 1;
  String dropdownValue;
  String dropdownValueTwo;

  //LOADS TAGS CSV INTO LIST OF STRINGS
  var csv = <String>[];

  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  void loadCSV() {
    loadAsset('tags_short.csv').then((String output) {
      setState(() {
        csv = output.split("\n");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    loadCSV();
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              DropdownButton<String>(
                value: dropdownValue,
                hint: Text("Category"),
                items: <String>[
                  'Newest',
                  'Most Upvoted',
                  'Most Popular',
                  'Recommended'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String val) {
                  setState(() {
                    dropdownValue = val;
                    sort = val;
                  });
                },
              ),
              DropdownButton<String>(
                value: dropdownValueTwo,
                hint: Text("tags"),
                items: csv.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String val) {
                  setState(() {
                    dropdownValueTwo = val;
                    tag = val;
                  });
                },
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: 'Problems'),
                Tab(text: 'Search'),
                Tab(text: 'Tags'),
              ],
            ),
          ),
          body: TabBarView(
            children: [DataTable(), SearchDataTable(), TagDataTable()],
          ),
        ));
  }
}

class SearchDataTable extends StatefulWidget {
  @override
  SearchDataTableState createState() => SearchDataTableState();
}

class SearchDataTableState extends State<SearchDataTable> {
  bool submitted = false;
  List<String> listResults = [];
  Future<void> getData() async {
    _loading = true;
    final _rawData = await rootBundle.loadString("assets/reddit_questions.csv");
    List<List<dynamic>> _listData =
        CsvToListConverter(fieldDelimiter: ';').convert(_rawData);
    List<dynamic> data = [];
    for (var i = 0; i < _listData.length; i++) {
      data.add(_listData[i][1]);
    }
    _dataM = data;
    dataPerm = _dataM;
    _loading = false;
  }

  void initStateSearch() {
    super.initState();
    _loadAllSearch();
  }

  void _loadAllSearch() async {
    setState(() {
      _dataM = listResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!submitted) {
      getData();
    }
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              onSubmitted: (String value) async {
                submitted = true;
                int searchresult_int;
                if (value.toString().length > 250) {
                  value = value.toString().substring(0, 250);
                }
                String url =
                    'http://127.0.0.1:5000/search?Query=' + value.toString();
                String data = await Getdata(url);
                listResults.clear();

                listResults = data.split("|");
                // listResults.add("No Matches Found.");
                // '''
                // if (dataPerm.isNotEmpty) {
                //   //Loops through Data set and matches with query.
                //   if (value.isEmpty) {
                //     listResults.clear();
                //     listResults.add("No Results Found.");
                //   } else {
                //     for (var i = 0; i < dataPerm.length; i++) {
                //       String data = dataPerm[i];
                //       if (data.toLowerCase().contains(value.toLowerCase())) {
                //         searchresult_int = i;
                //         //Adds similar searches to a List
                //         listResults.add(dataPerm[searchresult_int].toString());
                //       }
                //     }
                //     if (listResults.isEmpty) {
                //       listResults.add("No Results Found.");
                //     }
                //   }
                // } else {
                //   print("NULL DATASET FOR SEARCH");
                // }'''
                _loadAllSearch();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _dataM.length,
            itemBuilder: (_, index) {
              return Card(
                margin: const EdgeInsets.all(3),
                color: Colors.white,
                child: ListTile(
                  title: Text(_dataM[index].toString()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

 
// getData();
//     //print(_dataM);

//     int searchresult_int;
//     List<String> listResults = [];
//     listResults.add("No Matches Found.");


// //Dataset has posts in it.
//         if (_dataM.isNotEmpty) {
//           //Loops through Data set and matches with query.
//           if (query.isEmpty) {
//             listResults.clear();
//             listResults.add("No Results Found.");
//           } else {
//             for (var i = 0; i < _dataM.length; i++) {
//               String data = _dataM[i];
//               if (data.toLowerCase().contains(query.toLowerCase())) {
//                 searchresult_int = i;
//                 //Adds similar searches to a List
//                 listResults.add(_dataM[searchresult_int].toString());
//               }
//             }
//             if (listResults.isEmpty) {
//               listResults.add("No Results Found.");
//             }
//           }

//           //Dataset has NO posts in it.
//         } else {
//           print("NULL DATASET FOR SEARCH");
//         }
//         print("SEARCH RESULT: " + listResults.toString());
//       }