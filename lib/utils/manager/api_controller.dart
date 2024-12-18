import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_setup/extension/localization_extension.dart';
import 'package:flutter_setup/utils/manager/navigation_manager.dart';
import 'package:flutter_setup/utils/manager/storage_manager.dart';

import '../../core/models/api/api_model.dart';
import '../../core/models/api/exceptions.dart';
import '../../core/widgets/dialog/custom_dialog.dart';
import '../constants/apis.dart';
import '../constants/app_config.dart';
import '../constants/app_constants.dart';
import '../services/app_state.dart';
import 'get_it_manager.dart';

enum APIMethod { post, get, delete, put, patch }

final class APIController {
  static final Dio _dio = Dio();

  void _addInterceptors() {
    const String apiTag = "API :";
    final InterceptorsWrapper mInterceptorsWrapper = InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint("$apiTag headers ${options.headers}");
        debugPrint("$apiTag Method ${options.method}");
        debugPrint("$apiTag Request ${options.baseUrl + options.path}");
        debugPrint(
            "$apiTag Request Parameters ${options.method == "GET" ? options.queryParameters : options.data}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint("Response Code ${response.statusCode}");
        final prettyString =
            const JsonEncoder.withIndent('  ').convert(response.data);
        debugPrint("Response is :");
        log(prettyString.toString());
        return handler.next(response);
      },
      onError: (error, handler) {
        debugPrint("$apiTag Error ${error.error}", wrapWidth: 1024);
        debugPrint("$apiTag Error ${error.response}", wrapWidth: 1024);
        return handler.next(error);
      },
    );
    _dio.interceptors.add(mInterceptorsWrapper);
  }

  void prepareRequest() {
    BaseOptions dioOptions = BaseOptions(
      baseUrl: AppConfig.instance.apiBaseUrl,
      responseType: ResponseType.json,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
    _dio.options = dioOptions;
    if (kDebugMode) _addInterceptors();
  }

  /// Method to make normal Requests
  Future<ApiResponseModel> request(
    final String url,
    final APIMethod method, {
    final Map<String, dynamic> param = const {},
    final bool shouldNotThrowException = false,
    final bool isResponseHasModel = true,
  }) async {
    late ApiResponseModel apiResponse;
    late ErrorModel error;
    late Response response;
    final Map<String, dynamic> params = {"params": param};
    try {
      final Map<String, dynamic> headerOptions = {
        'Cookie': getIt<AppState>().sessionId,
        'tz': getIt<AppState>().timeZone,
        if (getIt<AppState>().userId.isNotEmpty)
          "user-id": getIt<AppState>().userId,
        if (getIt<AppState>().accessToken.isEmpty)
          "auth-key-file": getIt<AppState>().authKeyFile
        else
          "access-token": getIt<AppState>().accessToken,
      };
      if (method == APIMethod.get) {
        response = await _dio.get(
          url,
          queryParameters: params,
          options: Options(headers: headerOptions),
        );
      }
      if (method == APIMethod.post) {
        response = await _dio.post(
          url,
          data: params,
          options: Options(headers: headerOptions),
        );
      }
      if (method == APIMethod.delete) {
        response = await _dio.delete(
          url,
          data: params,
          options: Options(headers: headerOptions),
        );
      }
      if (method == APIMethod.put) {
        response = await _dio.put(
          url,
          data: params,
          options: Options(headers: headerOptions),
        );
      }
      if (method == APIMethod.patch) {
        response = await _dio.patch(
          url,
          data: params,
          options: Options(headers: headerOptions),
        );
      }
      if (!isResponseHasModel) {
        return apiResponse = ApiResponseModel(response.data, null, true);
      }
      apiResponse = await _responseHandler(response,
          shouldShowLogoutDialog: url != getIt<APIS>().logout);
    } on DioException catch (e) {
      error = _handleError(e);
      apiResponse = ApiResponseModel(null, error, false);
    } catch (e) {
      error = ErrorModel(
        NavigationManager.navigatorKey.currentContext!.localization.error,
        NavigationManager
            .navigatorKey.currentContext!.localization.somethingWentWrong,
        504,
      );
      apiResponse = ApiResponseModel(null, error, false);
    }
    if (apiResponse.status) {
      return apiResponse;
    } else if (!apiResponse.status && shouldNotThrowException) {
      return apiResponse;
    } else {
      throw ErrorException(apiResponse.error!);
    }
  }

  /// Method to make request to upload files
  Future<ApiResponseModel> uploadFile(
    String url,
    APIMethod method,
    List<FileInfo> files, {
    Map<String, String> param = const {},
    String filesKey = "",
    bool shouldNotThrowException = false,
    bool isResponseHasModel = true,
  }) async {
    late ApiResponseModel apiResponse;
    late ErrorModel error;
    if (method != APIMethod.post) {
      error = ErrorModel(
        NavigationManager.navigatorKey.currentContext!.localization.error,
        "Only Post Method Allowed.",
        503,
      );
      return apiResponse = ApiResponseModel(null, error, false);
    }
    late Response response;
    _dio.options.headers["Content-Type"] = "multipart/form-data";
    FormData formData = FormData();
    if (filesKey.isNotEmpty) {
      List<MultipartFile> multiPartFiles = [];
      for (FileInfo file in files) {
        multiPartFiles
            .add(MultipartFile.fromFileSync(file.path, filename: file.name));
      }
      formData = FormData.fromMap({filesKey: multiPartFiles});
    } else {
      List<MapEntry<String, MultipartFile>> multiPartFiles = [];
      for (FileInfo file in files) {
        multiPartFiles.add(MapEntry('attachment',
            MultipartFile.fromFileSync(file.path, filename: file.name)));
      }
      formData.files.addAll(multiPartFiles);
    }
    final mapData = param.entries.map((e) => MapEntry(e.key, e.value)).toList();
    for (MapEntry<String, String> entry in mapData) {
      formData.fields.add(entry);
    }
    try {
      response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: {
          'Cookie': getIt<AppState>().sessionId,
          'tz': getIt<AppState>().timeZone,
          'Accept-Language': getIt<AppState>().isArabic.value
              ? getIt<AppConstants>().localeAr
              : getIt<AppConstants>().localeEn,
          if (getIt<AppState>().userId.isNotEmpty)
            "user-id": getIt<AppState>().userId,
          if (getIt<AppState>().accessToken.isEmpty)
            "auth-key-file": getIt<AppState>().authKeyFile
          else
            "access-token": getIt<AppState>().accessToken,
        }),
      );
      if (!isResponseHasModel) {
        return apiResponse = ApiResponseModel(response.data, null, true);
      }
      apiResponse = await _responseHandler(response);
    } on DioException catch (e) {
      error = _handleError(e);
      apiResponse = ApiResponseModel(null, error, false);
    } catch (e) {
      error = ErrorModel(
        NavigationManager.navigatorKey.currentContext!.localization.error,
        NavigationManager
            .navigatorKey.currentContext!.localization.somethingWentWrong,
        504,
      );
      apiResponse = ApiResponseModel(null, error, false);
    }
    if (apiResponse.status) {
      return apiResponse;
    } else if (shouldNotThrowException && !apiResponse.status) {
      return apiResponse;
    } else {
      throw ErrorException(apiResponse.error!);
    }
  }

  /// Method to download files
  Future<ApiResponseModel> downloadFile({
    required final String urlPath,
    required final String savePath,
    final StreamController<double>? progressStream,
    final bool useBaseUrl = false,
  }) async {
    try {
      final Response response = await Dio().download(
        useBaseUrl ? "${_dio.options.baseUrl}$urlPath" : urlPath,
        savePath,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: progressStream != null
            ? (count, total) {
                final double percentage = (count / total) * 100;
                progressStream.sink.add(percentage);
              }
            : null,
      );
      return ApiResponseModel(response.data, null, true);
    } catch (e) {
      final error = ErrorModel(
        NavigationManager.navigatorKey.currentContext!.localization.error,
        NavigationManager
            .navigatorKey.currentContext!.localization.somethingWentWrong,
        504,
      );
      throw ErrorException(error);
    }
  }

  Future<ApiResponseModel> _responseHandler(Response response,
      {final bool shouldShowLogoutDialog = true}) async {
    late ApiResponseModel apiResponse;
    late ErrorModel error;
    final responseData = response.data;
    String? session = response.headers['set-cookie']?.firstWhere(
      (element) => element.startsWith(getIt<AppConstants>().sessionId),
      orElse: () => '',
    );
    if (session != null && session.isNotEmpty) {
      await getIt<StorageManager>()
          .saveData(getIt<AppConstants>().sessionId, session.substring(0, 51));
      getIt<AppState>().setSessionId = session.substring(0, 51);
    }
    if ((responseData['error'] != null) &&
        (responseData['error']['code'] == 100)) {
      error = ErrorModel(
        NavigationManager.navigatorKey.currentContext!.localization.error,
        NavigationManager
            .navigatorKey.currentContext!.localization.sessionExpired,
        401,
      );
      apiResponse = ApiResponseModel(null, error, false);
      if (shouldShowLogoutDialog) {
        CustomDialog.showLogoutDialog(
          NavigationManager.navigatorKey.currentContext!,
        );
      }
    } else if ((responseData['error'] != null) &&
        (responseData['error']['code'] == 200)) {
      try {
        final ValidationErrorModel validationError =
            ValidationErrorModel.fromJson(responseData['error']['data']);
        error = ErrorModel(
          NavigationManager.navigatorKey.currentContext!.localization.error,
          validationError.arguments.isNotEmpty
              ? validationError.arguments.first
              : validationError.message,
          301,
        );
      } catch (e) {
        error = ErrorModel(
          NavigationManager.navigatorKey.currentContext!.localization.error,
          NavigationManager
              .navigatorKey.currentContext!.localization.somethingWentWrong,
          303,
        );
      }
      return ApiResponseModel(null, error, false);
    }
    if (response.statusCode == 200) {
      (responseData['result']['status']['success'])
          ? apiResponse = ApiResponseModel(
              responseData['result']['result'],
              null,
              responseData['result']['status']['success'],
              message: getIt<AppState>().isArabic.value
                  ? (responseData['result']['status']['error_message_ar'] ??
                      NavigationManager.navigatorKey.currentContext!
                          .localization.somethingWentWrong)
                  : (responseData['result']['status']['error_message_en'] ??
                      NavigationManager.navigatorKey.currentContext!
                          .localization.somethingWentWrong),
            )
          : apiResponse = ApiResponseModel(
              responseData,
              ErrorModel(
                NavigationManager
                    .navigatorKey.currentContext!.localization.error,
                getIt<AppState>().isArabic.value
                    ? (responseData['result']['status']['error_message_ar'] ??
                        NavigationManager.navigatorKey.currentContext!
                            .localization.somethingWentWrong)
                    : (responseData['result']['status']['error_message_en'] ??
                        NavigationManager.navigatorKey.currentContext!
                            .localization.somethingWentWrong),
                responseData['result']['status']['error_code'],
              ),
              responseData['result']['status']['success'],
              message: getIt<AppState>().isArabic.value
                  ? (responseData['result']['status']['error_message_ar'] ??
                      NavigationManager.navigatorKey.currentContext!
                          .localization.somethingWentWrong)
                  : (responseData['result']['status']['error_message_en'] ??
                      NavigationManager.navigatorKey.currentContext!
                          .localization.somethingWentWrong),
            );
    } else if (response.statusCode == 401) {
      error = ErrorModel(
        NavigationManager.navigatorKey.currentContext!.localization.error,
        NavigationManager
            .navigatorKey.currentContext!.localization.somethingWentWrong,
        response.statusCode!,
      );
      apiResponse = ApiResponseModel(null, error, false);
    } else if (response.statusCode == 500) {
      apiResponse = ApiResponseModel(
        null,
        ErrorModel(
          NavigationManager.navigatorKey.currentContext!.localization.error,
          NavigationManager
              .navigatorKey.currentContext!.localization.somethingWentWrong,
          response.statusCode!,
        ),
        false,
      );
    } else {
      if (response.data.isNotEmpty) {
        error = ErrorModel(
          NavigationManager.navigatorKey.currentContext!.localization.error,
          getIt<AppState>().isArabic.value
              ? (responseData['result']['status']['error_message_ar'] ??
                  NavigationManager.navigatorKey.currentContext!.localization
                      .somethingWentWrong)
              : (responseData['result']['status']['error_message_en'] ??
                  NavigationManager.navigatorKey.currentContext!.localization
                      .somethingWentWrong),
          responseData['result']['status']['error_code'] ?? 401,
        );
        apiResponse = ApiResponseModel(null, error, false);
      } else {
        error = ErrorModel(
            NavigationManager
                .navigatorKey.currentContext!.localization.somethingWentWrong,
            NavigationManager
                .navigatorKey.currentContext!.localization.somethingWentWrong,
            504);
        apiResponse = ApiResponseModel(null, error, false);
      }
    }
    return apiResponse;
  }

  ErrorModel _handleError(DioException error) {
    late ErrorModel errorRes;
    switch (error.type) {
      case DioExceptionType.cancel:
        return errorRes = ErrorModel(
          NavigationManager
              .navigatorKey.currentContext!.localization.somethingWentWrong,
          NavigationManager
              .navigatorKey.currentContext!.localization.somethingWentWrong,
          499,
        );
      case DioExceptionType.badResponse:
        if (error.response != null && error.response!.data != null) {
          try {
            if (error.response?.data['error']['code'] == 404) {
              errorRes = ErrorModel(
                  NavigationManager
                      .navigatorKey.currentContext!.localization.error,
                  NavigationManager
                      .navigatorKey.currentContext!.localization.pageNotFound,
                  404);
            } else if (error.response?.data['message']
                    .contains("Unauthorized") ||
                error.response?.data['message'].contains("jwt expired") ||
                error.response?.data['message'].contains("jwt malformed")) {
              errorRes = ErrorModel("Unauthorized", "Token Expired", 504);
              // NavigationManager.navigatorKey.currentContext!
              //     .pushNamedAndRemoveUntil(RouteName.authScreen);
              break;
            } else if (error.response!.data.length > 1) {
              errorRes = ErrorModel.fromJson(error.response!.data);
            } else {
              errorRes = ErrorModel(
                  NavigationManager
                      .navigatorKey.currentContext!.localization.error,
                  NavigationManager.navigatorKey.currentContext!.localization
                      .somethingWentWrong,
                  599);
            }
          } catch (e) {
            errorRes = ErrorModel(
                NavigationManager
                    .navigatorKey.currentContext!.localization.error,
                NavigationManager.navigatorKey.currentContext!.localization
                    .somethingWentWrong,
                599);
          }
        } else {
          errorRes = ErrorModel(
              NavigationManager.navigatorKey.currentContext!.localization.error,
              NavigationManager
                  .navigatorKey.currentContext!.localization.somethingWentWrong,
              499);
        }
        break;
      case DioExceptionType.connectionTimeout:
        errorRes = ErrorModel(
            NavigationManager.navigatorKey.currentContext!.localization.error,
            NavigationManager
                .navigatorKey.currentContext!.localization.serverTimeout,
            599);
        break;
      case DioExceptionType.receiveTimeout:
        errorRes = ErrorModel(
            NavigationManager.navigatorKey.currentContext!.localization.error,
            NavigationManager
                .navigatorKey.currentContext!.localization.serverTimeout,
            524);
        break;
      case DioExceptionType.sendTimeout:
        errorRes = ErrorModel(
            NavigationManager.navigatorKey.currentContext!.localization.error,
            NavigationManager
                .navigatorKey.currentContext!.localization.serverTimeout,
            408);
        break;
      case DioExceptionType.badCertificate:
        errorRes = ErrorModel(
            NavigationManager.navigatorKey.currentContext!.localization.error,
            NavigationManager
                .navigatorKey.currentContext!.localization.somethingWentWrong,
            303);
        break;
      case DioExceptionType.connectionError:
        errorRes = ErrorModel(
            NavigationManager.navigatorKey.currentContext!.localization.error,
            NavigationManager
                .navigatorKey.currentContext!.localization.somethingWentWrong,
            303);
        break;
      case DioExceptionType.unknown:
        errorRes = ErrorModel(
            NavigationManager.navigatorKey.currentContext!.localization.error,
            NavigationManager
                .navigatorKey.currentContext!.localization.somethingWentWrong,
            303);
        break;
    }
    return errorRes;
  }
}
