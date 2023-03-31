class RecipeModel {
  late String appLabel;
  late String appimgUrl;
  late String appCalorie;
  late String appurl;

  RecipeModel(
      {this.appCalorie = "calorie",
      this.appLabel = "label",
      this.appimgUrl = "imgurl",
      this.appurl = "url"});

  factory RecipeModel.fromMap(Map recipe) {
    return RecipeModel(
      appCalorie: recipe['calories'].toString().length >= 6
          ? recipe['calories'].toString().substring(0, 6)
          : recipe['calories'].toString().substring(0, 4),
      appLabel: recipe['label'],
      appimgUrl: recipe['image'],
      appurl: recipe['url'],
    );
  }
}
