class ImageConstants {
  static late ImageConstants _instance;

  static ImageConstants get instance {
    _instance ??= ImageConstants._init();
    return _instance;
  }

  ImageConstants._init();

  String get logo => toPng("mete");
  String toPng(String name) => "asset/image/$name";
}
