import 'package:doorce_panel/dtos/concept.dart';

class XDefaultAppTemplate {
  Map<String,String> useCaseScenarios = <String,String>{};
  List<XConcept> auxiliaryConcepts = List<XConcept>.empty(growable: true);
  
  XDefaultAppTemplate();
  
  void fromJson(Map<String, dynamic> json) {
    useCaseScenarios = Map<String,String>.from(json['useCaseScenarios'] ?? {});
    auxiliaryConcepts = (json['auxiliaryConcepts'] as List<dynamic>?)
        ?.map((c) => XConcept()..fromJson(c as Map<String, dynamic>))
        .toList() ?? [];
  }

  Map<String, dynamic> toJson() {
    return {
      'useCaseScenarios': useCaseScenarios,
      "auxiliaryConcepts": auxiliaryConcepts.map((c) => c.toJson()).toList(),
    };
  }
}