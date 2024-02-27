import 'package:appcurso/services/api_service.dart';
import 'package:flutter/material.dart';

class ApiInherited extends InheritedWidget {
  ApiInherited({super.key, required super.child});

  final apiService = ApiService();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static ApiInherited? of(BuildContext context) {
    return context.getInheritedWidgetOfExactType<ApiInherited>();
  }
}
