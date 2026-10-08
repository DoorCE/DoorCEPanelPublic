import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class AppRouteInformationParser extends RouteInformationParser<(String, bool)> {
  AppRouteInformationParser({required this.routes});

  final List<String> routes;

  @override
  Future<(String, bool)> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    return (findMatchingRoutePattern(uri.toString(), routes), null != routeInformation.state);
  }

  @override
  RouteInformation? restoreRouteInformation((String,bool) configuration) {
    if (configuration.$1.isNotEmpty) {
      return RouteInformation(uri: Uri.parse(configuration.$1), state: "");
    }

    return null;
  }
}

bool matchRoute(String pattern, String path) {
  final pathSegments = path.split(':').where((s) => s.isNotEmpty).toList();
  Logger.root.info("[matchRoute] Path segments: $pathSegments");
  final patternSegments = getSegments(pattern);
  Logger.root.info("[matchRoute] Pattern segments: $patternSegments");

  // if (patternSegments.length != pathSegments.length) return false;

  for (var i = 0; i < patternSegments.length; i++) {
    // if (patternSegments[i].startsWith(':')) continue;
    Logger.root.info("[matchRoute] Comparing pattern segment '${patternSegments[i]}' with path segment '${pathSegments[i]}'");
    if (patternSegments[i] == pathSegments[i]) return true;
  }

  return false;
}

String findMatchingRoutePattern(String path, List<String> routes) {
  // Extract just the routing prefix (before the first ':')
  final routePrefix = path.split(':').first; // e.g., "/agent_management"
  
  // Check if this prefix exists in our routes
  final isValidRoute = routes.contains(routePrefix);
  
  if (isValidRoute) {
    return path; // Return the full path with query parameters intact
  } else {
    return routes.firstWhere((route) => route == '/'); // Fallback to home
  }
}

/// Splits a path into segments, filtering out empty segments
List<String> getSegments(String path) =>
    path.split(':').where((s) => s.isNotEmpty).toList();