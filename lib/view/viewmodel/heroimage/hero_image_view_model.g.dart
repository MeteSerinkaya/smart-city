// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero_image_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HeroImageViewModel on _HeroImageViewModelBase, Store {
  Computed<bool>? _$hasImagesComputed;

  @override
  bool get hasImages => (_$hasImagesComputed ??= Computed<bool>(
    () => super.hasImages,
    name: '_HeroImageViewModelBase.hasImages',
  )).value;

  late final _$isLoadingAtom = Atom(
    name: '_HeroImageViewModelBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$heroImageListAtom = Atom(
    name: '_HeroImageViewModelBase.heroImageList',
    context: context,
  );

  @override
  List<HeroImageModel>? get heroImageList {
    _$heroImageListAtom.reportRead();
    return super.heroImageList;
  }

  @override
  set heroImageList(List<HeroImageModel>? value) {
    _$heroImageListAtom.reportWrite(value, super.heroImageList, () {
      super.heroImageList = value;
    });
  }

  late final _$currentImageAtom = Atom(
    name: '_HeroImageViewModelBase.currentImage',
    context: context,
  );

  @override
  HeroImageModel? get currentImage {
    _$currentImageAtom.reportRead();
    return super.currentImage;
  }

  @override
  set currentImage(HeroImageModel? value) {
    _$currentImageAtom.reportWrite(value, super.currentImage, () {
      super.currentImage = value;
    });
  }

  late final _$currentIndexAtom = Atom(
    name: '_HeroImageViewModelBase.currentIndex',
    context: context,
  );

  @override
  int get currentIndex {
    _$currentIndexAtom.reportRead();
    return super.currentIndex;
  }

  @override
  set currentIndex(int value) {
    _$currentIndexAtom.reportWrite(value, super.currentIndex, () {
      super.currentIndex = value;
    });
  }

  late final _$errorAtom = Atom(
    name: '_HeroImageViewModelBase.error',
    context: context,
  );

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$fetchHeroImagesAsyncAction = AsyncAction(
    '_HeroImageViewModelBase.fetchHeroImages',
    context: context,
  );

  @override
  Future<void> fetchHeroImages() {
    return _$fetchHeroImagesAsyncAction.run(() => super.fetchHeroImages());
  }

  late final _$fetchLatestImageAsyncAction = AsyncAction(
    '_HeroImageViewModelBase.fetchLatestImage',
    context: context,
  );

  @override
  Future<void> fetchLatestImage() {
    return _$fetchLatestImageAsyncAction.run(() => super.fetchLatestImage());
  }

  late final _$addHeroImageAsyncAction = AsyncAction(
    '_HeroImageViewModelBase.addHeroImage',
    context: context,
  );

  @override
  Future<bool> addHeroImage(HeroImageModel model) {
    return _$addHeroImageAsyncAction.run(() => super.addHeroImage(model));
  }

  late final _$updateHeroImageAsyncAction = AsyncAction(
    '_HeroImageViewModelBase.updateHeroImage',
    context: context,
  );

  @override
  Future<bool> updateHeroImage(HeroImageModel model) {
    return _$updateHeroImageAsyncAction.run(() => super.updateHeroImage(model));
  }

  late final _$deleteHeroImageAsyncAction = AsyncAction(
    '_HeroImageViewModelBase.deleteHeroImage',
    context: context,
  );

  @override
  Future<bool> deleteHeroImage(int id) {
    return _$deleteHeroImageAsyncAction.run(() => super.deleteHeroImage(id));
  }

  late final _$uploadImageAsyncAction = AsyncAction(
    '_HeroImageViewModelBase.uploadImage',
    context: context,
  );

  @override
  Future<bool> uploadImage(
    dynamic imageFile,
    String title,
    String description,
  ) {
    return _$uploadImageAsyncAction.run(
      () => super.uploadImage(imageFile, title, description),
    );
  }

  late final _$_HeroImageViewModelBaseActionController = ActionController(
    name: '_HeroImageViewModelBase',
    context: context,
  );

  @override
  void nextImage() {
    final _$actionInfo = _$_HeroImageViewModelBaseActionController.startAction(
      name: '_HeroImageViewModelBase.nextImage',
    );
    try {
      return super.nextImage();
    } finally {
      _$_HeroImageViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void previousImage() {
    final _$actionInfo = _$_HeroImageViewModelBaseActionController.startAction(
      name: '_HeroImageViewModelBase.previousImage',
    );
    try {
      return super.previousImage();
    } finally {
      _$_HeroImageViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void goToImage(int index) {
    final _$actionInfo = _$_HeroImageViewModelBaseActionController.startAction(
      name: '_HeroImageViewModelBase.goToImage',
    );
    try {
      return super.goToImage(index);
    } finally {
      _$_HeroImageViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
heroImageList: ${heroImageList},
currentImage: ${currentImage},
currentIndex: ${currentIndex},
error: ${error},
hasImages: ${hasImages}
    ''';
  }
}
