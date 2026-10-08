class XSourceCreationRequest {
  final String sourceDatasetName;
  final List<String> agentUris;

  XSourceCreationRequest(
    this.sourceDatasetName,
    this.agentUris
  );

  Map<String, dynamic> toJson() {
    return {
      'sourceDatasetName': sourceDatasetName,
      'agentUris': agentUris
    };
  }
}