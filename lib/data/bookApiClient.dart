class BookApiClient {
  static const baseURL =
      "https://firebasestorage.googleapis.com/v0/b/ormanbakanligikitap.appspot.com/o/";

  Future<List<String>> getImages(String bookID) async {
    List<String> imageUrls = [];
    int size = 19;
    if (bookID == "paintbookcover") size = 3;
    if (bookID == "boyacitirmik") size = 34;
    if (bookID == "kahraman") size = 23;
    for (int i = 1; i < size; i++) {
      imageUrls.add('assets/$bookID/' + i.toString() + "-min.jpeg");
    }

    return imageUrls;
  }
}
