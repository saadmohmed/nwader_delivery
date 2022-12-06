class MealsListData {
  MealsListData(
      {this.imagePath = '',
      this.titleTxt = '',
      this.startColor = '',
      this.endColor = '',
      this.kacl = 0,
        this.id = '0',

        this.short_desc = '',
      this.isFav = ''});

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  String short_desc;
  String isFav;
  String id;

  int kacl;
}

class CategoriesListData {
  CategoriesListData({
    this.imagePath = '',
    this.titleTxt = '',
  });

  String imagePath;
  String titleTxt;
}
