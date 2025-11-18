// import 'package:dio/dio.dart';
// import 'package:injectable/injectable.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
//
// import 'api_constants.dart';
//
// @module
// abstract class DioModule {
//   @lazySingleton
//   Dio providerDio() {
//     Dio dio = Dio(
//       BaseOptions(
//         baseUrl: ApiConstants.baseUrl,
//         connectTimeout: const Duration(seconds: 5),
//         receiveTimeout: const Duration(seconds: 5),
//         sendTimeout: const Duration(seconds: 5),
//       ),
//     );
//
//     // Add headers
//     dio.options.headers = {
//       'Content-Type': 'application/json',
//       // 'Authorization': 'Bearer YOUR_TOKEN',
//     };
//
//     /// Add PrettyDioLogger
//     dio.interceptors.add(
//       PrettyDioLogger(
//         requestHeader: true,
//         requestBody: true,
//         responseHeader: true,
//         responseBody: true,
//         compact: true,
//         maxWidth: 90,
//       ),
//
//     );
//
//     // Add Error Handling
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//
//           return handler.next(response);
//         },
//         onError: (DioError error, handler) {
//
//           return handler.next(error);
//         },
//       ),
//     );
//
//     return dio;
//   }
// }
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_constants.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio providerDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(PrettyDioLogger());

    // customization
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        filter: (options, args) {
          // don't print requests with uris containing '/posts'
          if (options.path.contains('/posts')) {
            return false;
          }
          // don't print responses with unit8 list data
          return !args.isResponse || !args.hasUint8ListData;
        },
      ),
    );
    // Logger interceptor
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    // // Interceptor لإضافة التوكن وتجديده تلقائيًا
    // dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) async {
    //       final token = await CacheService.getData(key: CacheKeys.token);
    //       if (token != null) {
    //         options.headers['Authorization'] = 'Bearer $token';
    //       }
    //       return handler.next(options);
    //     },
    //     onResponse: (response, handler) {
    //       return handler.next(response);
    //     },
    //     onError: (DioError error, handler) async {
    //       // لو الخطأ 401، نجرب نجدد التوكن
    //       if (error.response?.statusCode == 401) {
    //         final refreshToken = await CacheService.getData(key: CacheKeys.refreshToken);
    //         if (refreshToken != null) {
    //           try {
    //             final dioForRefresh = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    //             final response = await dioForRefresh.post(
    //               '/auth/refresh',
    //               data: {'refresh_token': refreshToken},
    //             );
    //
    //             final newToken = response.data['access_token'];
    //             await CacheService.setData(key: CacheKeys.token, value: newToken);
    //
    //             // إعادة إرسال الطلب الأصلي بالتوكن الجديد
    //             final requestOptions = error.requestOptions;
    //             requestOptions.headers['Authorization'] = 'Bearer $newToken';
    //
    //             final opts = Options(
    //               method: requestOptions.method,
    //               headers: requestOptions.headers,
    //             );
    //
    //             final cloneReq = await dio.request(
    //               requestOptions.path,
    //               options: opts,
    //               data: requestOptions.data,
    //               queryParameters: requestOptions.queryParameters,
    //             );
    //
    //             return handler.resolve(cloneReq);
    //           } catch (e) {
    //             // لو فشل التجديد، نحذف التوكنات ونمرر الخطأ للمستخدم
    //             await CacheService.setData(key: CacheKeys.token, value: null);
    //             await CacheService.setData(key: CacheKeys.refreshToken, value: null);
    //             return handler.next(error);
    //           }
    //         }
    //       }
    //
    //       return handler.next(error);
    //     },
    //   ),
    // );

    return dio;
  }
}
