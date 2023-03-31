import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:recipebook/RecipeView.dart';
import 'package:recipebook/models.dart';
import 'package:recipebook/search.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    Response response = await get(Uri.parse(
        "https://api.edamam.com/search?q=$query&app_id=85cdead5&app_key=9c3d0f3b8f0d53b5d0bb50dab64b9d05"));
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
    getRecipe("Ladoo");
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
                              Navigator.push(
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "WHAT DO YOU WANT TO COOK TODAY?",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Let's Cook Something New!",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  child: ListView.builder(
                      itemCount: recipeCatList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RecipeSearch(
                                          recipeCatList[index]['label'])));
                            },
                            child: Card(
                              margin: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              elevation: 0.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18.0),
                                    child: Image.network(
                                      recipeCatList[index]['url'],
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height: 150,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration:
                                          BoxDecoration(color: Colors.black26),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            recipeCatList[index]['label'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
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
                                Navigator.push(
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
