import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:recipebook/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'RecipeView.dart';

class RecipeSearch extends StatefulWidget {
  String query;
  RecipeSearch(this.query);

  @override
  State<RecipeSearch> createState() => _RecipeSearchState();
}

class _RecipeSearchState extends State<RecipeSearch> {
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List<RecipeModel> recipeList = <RecipeModel>[];
  List<Map> recipeCatList = [
    {
      'url':
          'https://images.unsplash.com/photo-1518133299975-8e1b628e1cfd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
      'label': 'Chilli'
    },
    {
      'url':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      'label': 'Healthy'
    },
    {
      'url':
          'https://images.unsplash.com/photo-1628088062854-d1870b4553da?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      'label': 'Dairy'
    },
    {
      'url':
          'https://images.unsplash.com/photo-1626266798999-aa2b0c520cc9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
      'label': 'Protien'
    },
    {
      'url':
          'https://images.unsplash.com/photo-1512152272829-e3139592d56f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      'label': 'Fast Food'
    },
  ];
  getRecipe(String query) async {
    String? appKey = dotenv.env['APP_KEY'];
    Response response = await get(Uri.parse(
        "https://api.edamam.com/search?q=$query&app_id=85cdead5&app_key=$appKey"));
    Map data = jsonDecode(response.body);

    data['hits'].forEach((element) {
      RecipeModel recipeModel = RecipeModel();
      recipeModel = RecipeModel.fromMap(element['recipe']);
      recipeList.add(recipeModel);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipe(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Color(0xff213A50), Color(0xff071938)],
            )),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                //search bar container
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.00),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((searchController.text.replaceAll)(" ", "") ==
                                "") {
                              print("Blank Text");
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RecipeSearch(searchController.text)));
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(2, 0, 5, 0),
                            child: const Icon(
                              Icons.search,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: "Let's Cook Something!",
                              border: InputBorder.none,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: recipeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecipeView(
                                            recipeList[index].appurl)));
                              },
                              child: Card(
                                margin: const EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0.0,
                                child: Stack(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      recipeList[index].appimgUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: const BoxDecoration(
                                        color: Colors.black26,
                                      ),
                                      child: Text(
                                        recipeList[index].appLabel,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.local_fire_department),
                                            Text(recipeList[index].appCalorie),
                                          ],
                                        )),
                                    right: 0,
                                    height: 40,
                                    width: 80,
                                  )
                                ]),
                              ),
                            );
                          }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
