import "package:dio/dio.dart";
import "package:flutter_phonepe_demo/model/books_model.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";

class DioSingleton {
  factory DioSingleton() {
    return _singleton;
  }

  DioSingleton._internal();
  static final DioSingleton _singleton = DioSingleton._internal();

  final Dio dio = Dio();

  final String booksListLink = "https://www.jsonkeeper.com/b/6K25";

  Future<void> addPrettyDioLoggerInterceptor() {
    dio.interceptors.add(PrettyDioLogger());
    return Future<void>.value();
  }

  Future<BooksModel> bookListAPI({
    required void Function(String) errorMessageFunction,
  }) async {
    BooksModel newModel = BooksModel();
    Response<dynamic> response = Response<dynamic>(
      requestOptions: RequestOptions(path: ""),
    );
    try {
      response = await dio.get(
        booksListLink,
        options: Options(
          headers: <String, dynamic>{
            "Content-Type": "application/json",
          },
        ),
      );
      newModel = BooksModel.fromJson(response.data);
    } on DioError catch (error) {
      errorMessageFunction(error.response?.statusMessage ?? "Unknown Error");
    }
    return Future<BooksModel>.value(newModel);
  }
}
