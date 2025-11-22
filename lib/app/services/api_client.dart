import 'dart:convert';
import 'dart:io';

import 'package:barber_time/app/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../data/local/shared_prefs.dart';
import 'api_url.dart';
import 'error_response.dart';

class ApiClient extends GetxService {
  static var client = http.Client();

  static const String noInternetMessage = "Can't connect to the internet!";
  static const int timeoutInSeconds = 30;

  static String bearerToken = "";

  ///================================================================Helper Methods============================///
  
  /// Print a visual separator for better readability
  static void printSeparator([String title = '']) {
    const separator = '═════════════════════════════════════════════════════════════';
    if (title.isEmpty) {
      debugPrint(separator);
    } else {
      debugPrint('$separator $title $separator');
    }
  }

  /// Print formatted JSON with proper indentation
  static void printPrettyJson(dynamic input, {String label = ''}) {
    try {
      if (label.isNotEmpty) {
        debugPrint('\n🔹 $label:');
      }
      
      dynamic jsonObject = input;
      
      // If input is a string, try to parse it as JSON
      if (input is String) {
        try {
          jsonObject = jsonDecode(input);
        } catch (e) {
          // If not valid JSON, print as-is
          debugPrint(input);
          return;
        }
      }
      
      const encoder = JsonEncoder.withIndent('  ');
      final pretty = encoder.convert(jsonObject);
      printWrapped(pretty);
    } catch (e) {
      debugPrint('❌ Invalid JSON: $e');
      debugPrint('Raw content: $input');
    }
  }

  /// Print long strings in chunks to avoid truncation
  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    for (final match in pattern.allMatches(text)) {
      debugPrint(match.group(0));
    }
  }

  /// Print API request details in a structured format
  static void printRequest({
    required String method,
    required String uri,
    Map<String, String>? headers,
    dynamic body,
  }) {
    printSeparator();
    debugPrint('🚀 API REQUEST');
    printSeparator();
    debugPrint('📍 Method: $method');
    debugPrint('📍 URL: $uri');
    
    if (headers != null) {
      printPrettyJson(headers, label: '📋 Headers');
    }
    
    if (body != null) {
      printPrettyJson(body, label: '📦 Body');
    }
    printSeparator();
  }

  /// Print API response details in a structured format
  static void printResponse({
    required int statusCode,
    required String uri,
    required dynamic body,
    String? statusText,
  }) {
    printSeparator();
    final emoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    debugPrint('$emoji API RESPONSE');
    printSeparator();
    debugPrint('📍 Status: $statusCode ${statusText ?? ''}');
    debugPrint('📍 URL: $uri');
    printPrettyJson(body, label: '📦 Response Body');
    printSeparator();
  }

  ///================================================================Get Method============================///
  static Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    final mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': '$bearerToken'
    };

    // Build final URI with query params
    Uri baseUri = Uri.parse(uri);
    if (query != null) {
      baseUri = baseUri.replace(queryParameters: query);
    }
    
    try {
      printRequest(
        method: 'GET',
        uri: baseUri.toString(),
        headers: headers ?? mainHeaders,
      );

      final response = await client
          .get(
            baseUri,
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      
      return handleResponse(response, baseUri.toString());
    } catch (e) {
      debugPrint('❌ ERROR: ${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }
/// formdata  patch method 
  static Future<Response> patchFormData(
    String uri,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': '$bearerToken'
    };

    try {
      final usedHeaders = Map<String, String>.from(mainHeaders);
      if (headers != null) {
        usedHeaders.addAll(headers);
      }

      // Convert body to x-www-form-urlencoded format
      final formBody = body.map((k, v) => MapEntry(k.toString(), v.toString()));

      printRequest(
        method: 'PATCH',
        uri: uri,
        headers: usedHeaders,
        body: formBody,
      );

      http.Response response = await client
          .patch(
            Uri.parse(uri),
            body: formBody,
            headers: usedHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));

      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('❌ ERROR: ${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }
  ///================================================================Patch Method============================///
  static Future<Response> patchData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    bool isBody = true,
  }) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': '$bearerToken'
    };
    
    try {
      printRequest(
        method: 'PATCH',
        uri: uri,
        headers: headers ?? mainHeaders,
        body: isBody ? body : null,
      );

      http.Response response = await client
          .patch(
            Uri.parse(uri),
            body: isBody ? body : null,
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('❌ ERROR: ${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  ///================================================================Post Method============================///
  static Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': '$bearerToken'
    };
    
    try {
      printRequest(
        method: 'POST',
        uri: ApiUrl.baseUrl + uri,
        headers: headers ?? mainHeaders,
        body: body,
      );

      http.Response response = await client
          .post(
            Uri.parse(ApiUrl.baseUrl + uri),
            body: body,
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('❌ ERROR: ${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Post Multipart✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  static Future<Response> postMultipartData(
      String uri, Map<String, dynamic> body,
      {List<MultipartBody>? multipartBody,
      String requestType = "POST",
      Map<String, String>? headers}) async {
    try {
      bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

      var mainHeaders = {
        'Accept': 'application/json',
        'Authorization': '$bearerToken'
      };

      printSeparator();
      debugPrint('🚀 MULTIPART REQUEST');
      printSeparator();
      debugPrint('📍 Method: $requestType');
      debugPrint('📍 URL: ${ApiUrl.baseUrl + uri}');
      printPrettyJson(mainHeaders, label: '📋 Headers');
      printPrettyJson(body, label: '📦 Body Fields');
      debugPrint('🖼️  Files: ${multipartBody?.length ?? 0}');
      printSeparator();

      var request =
          http.MultipartRequest(requestType, Uri.parse(ApiUrl.baseUrl + uri));

      Map<String, String> stringBody = body.map((key, value) => MapEntry(
          key,
          value is List || value is Map
              ? jsonEncode(value)
              : value.toString()));

      request.fields.addAll(stringBody);

      if (multipartBody != null && multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          var mimeType =
              lookupMimeType(element.file.path) ?? 'application/octet-stream';
          
          var multipartImg = await http.MultipartFile.fromPath(
            element.key,
            element.file.path,
            contentType: MediaType.parse(mimeType),
          );
          request.files.add(multipartImg);
        }
      }

      request.headers.addAll(mainHeaders);
      http.StreamedResponse response = await request.send();
      final content = await response.stream.bytesToString();
      
      printResponse(
        statusCode: response.statusCode,
        uri: uri,
        body: content,
      );

      return Response(
          statusCode: response.statusCode,
          statusText: response.reasonPhrase,
          body: content);
    } catch (e) {
      debugPrint('❌ ERROR: ${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Patch Multipart✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  static Future<Response> patchMultipart(String uri, Map<String, dynamic> body,
      {List<MultipartBody>? multipartBody,
      String requestType = "PATCH",
      Map<String, String>? headers}) async {
    try {
      bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

      var mainHeaders = {
        'Accept': 'application/json',
        'Authorization': '$bearerToken'
      };

      printSeparator();
      debugPrint('🚀 MULTIPART REQUEST');
      printSeparator();
      debugPrint('📍 Method: $requestType');
      debugPrint('📍 URL: ${ApiUrl.baseUrl + uri}');
      printPrettyJson(mainHeaders, label: '📋 Headers');
      printPrettyJson(body, label: '📦 Body Fields');
      debugPrint('🖼️  Files: ${multipartBody?.length ?? 0}');
      printSeparator();

      var request =
          http.MultipartRequest(requestType, Uri.parse(ApiUrl.baseUrl + uri));

      Map<String, String> stringBody = body.map((key, value) => MapEntry(
          key,
          value is List || value is Map
              ? jsonEncode(value)
              : value.toString()));

      request.fields.addAll(stringBody);

      if (multipartBody != null && multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          var mimeType =
              lookupMimeType(element.file.path) ?? 'application/octet-stream';

          var multipartImg = await http.MultipartFile.fromPath(
            element.key,
            element.file.path,
            contentType: MediaType.parse(mimeType),
          );
          request.files.add(multipartImg);
        }
      }

      request.headers.addAll(mainHeaders);
      http.StreamedResponse response = await request.send();
      final content = await response.stream.bytesToString();
      
      printResponse(
        statusCode: response.statusCode,
        uri: uri,
        body: content,
      );

      return Response(
          statusCode: response.statusCode,
          statusText: response.reasonPhrase,
          body: content);
    } catch (e) {
      debugPrint('❌ ERROR: ${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Put Multipart✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  static Future<Response> putMultipart(String uri, Map<String, dynamic> body,
      {List<MultipartBody>? multipartBody,
      String requestType = "PUT",
      Map<String, String>? headers}) async {
    try {
      bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

      var mainHeaders = {
        'Accept': 'application/json',
        'Authorization': '$bearerToken'
      };

      printSeparator();
      debugPrint('🚀 MULTIPART REQUEST');
      printSeparator();
      debugPrint('📍 Method: $requestType');
      debugPrint('📍 URL: ${ApiUrl.baseUrl + uri}');
      printPrettyJson(mainHeaders, label: '📋 Headers');
      printPrettyJson(body, label: '📦 Body Fields');
      debugPrint('🖼️  Files: ${multipartBody?.length ?? 0}');
      printSeparator();

      var request =
          http.MultipartRequest(requestType, Uri.parse(ApiUrl.baseUrl + uri));

      Map<String, String> stringBody = body.map((key, value) => MapEntry(
          key,
          value is List || value is Map
              ? jsonEncode(value)
              : value.toString()));

      request.fields.addAll(stringBody);

      if (multipartBody != null && multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          var mimeType =
              lookupMimeType(element.file.path) ?? 'application/octet-stream';

          var multipartImg = await http.MultipartFile.fromPath(
            element.key,
            element.file.path,
            contentType: MediaType.parse(mimeType),
          );
          request.files.add(multipartImg);
        }
      }

      request.headers.addAll(mainHeaders);
      http.StreamedResponse response = await request.send();
      final content = await response.stream.bytesToString();
      
      printResponse(
        statusCode: response.statusCode,
        uri: uri,
        body: content,
      );

      return Response(
          statusCode: response.statusCode,
          statusText: response.reasonPhrase,
          body: content);
    } catch (e) {
      debugPrint('❌ ERROR: ${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  ///=============================Put data===================

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);
    var mainHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': '$bearerToken'
    };
    
    try {
      final usedHeaders = Map<String, String>.from(mainHeaders);
      if (headers != null) {
        usedHeaders.addAll(headers);
      }

      Object? requestBody;
      final contentType = (usedHeaders['Content-Type'] ?? '').toLowerCase();
      if (contentType.contains('application/x-www-form-urlencoded')) {
        if (body is Map) {
          requestBody =
              body.map((k, v) => MapEntry(k.toString(), v.toString()));
        } else if (body is String) {
          requestBody = body;
        } else {
          try {
            requestBody = (body as Map)
                .map((k, v) => MapEntry(k.toString(), v.toString()));
          } catch (_) {
            requestBody = body.toString();
          }
        }
      } else {
        requestBody = body is String ? body : jsonEncode(body);
      }

      printRequest(
        method: 'PUT',
        uri: ApiUrl.baseUrl + uri,
        headers: usedHeaders,
        body: requestBody,
      );

      http.Response response = await http
          .put(
            Uri.parse(ApiUrl.baseUrl + uri),
            body: requestBody,
            headers: usedHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('❌ ERROR: ${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> deleteData(
    String uri, {
    Map<String, String>? headers,
  }) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': '$bearerToken',
    };
    
    try {
      printRequest(
        method: 'DELETE',
        uri: uri,
        headers: headers ?? mainHeaders,
      );

      http.Response response = await http
          .delete(
            Uri.parse(uri),
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('❌ ERROR: ${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      body = response.body;
    }
    
    Response response0 = Response(
      body: body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );

    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
      response0 = Response(
          statusCode: response0.statusCode,
          body: response0.body,
          statusText: errorResponse.message);
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = const Response(statusCode: 0, statusText: noInternetMessage);
    }

    printResponse(
      statusCode: response0.statusCode!,
      uri: uri,
      body: response0.body,
      statusText: response0.statusText,
    );

    return response0;
  }
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}

class MultipartListBody {
  String key;
  String value;
  MultipartListBody(this.key, this.value);
}
