import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../main.dart'; // For global accessors
import '../../models/alert_detail.dart';
import '../../services/api_service.dart';
import '../../network/dio_client.dart';
import '../../utils/app_constants.dart';
import '../../utils/responsive.dart' as $appUtils; // To get rootUrl

class AlertDetailsPage extends StatefulWidget {
  final int alertSessionId;
  const AlertDetailsPage({super.key, required this.alertSessionId});

  @override
  State<AlertDetailsPage> createState() => _AlertDetailsPageState();
}

class _AlertDetailsPageState extends State<AlertDetailsPage> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _sessionDetails;
  List<AlertDetail> _alertDetails = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlertSessionDetails();
  }

  Future<void> _fetchAlertSessionDetails() async {
    setState(() { _isLoading = true; });
    final data = await _apiService.getAlertSessionDetails(widget.alertSessionId);
    if (data != null) {
      _sessionDetails = data;
      _alertDetails = (data['alert_details'] as List)
          .map((json) => AlertDetail.fromJson(json))
          .toList();
    }
    setState(() { _isLoading = false; });
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return $strings.unknown;
    return DateFormat('dd MMM yyyy HH:mm').format(dateTime);
  }

  // Helper to get image URL from backend path
  String _getImageUrl(String backendImagePath) {
    // Assuming backendImagePath is like '/home/root/bhuprahari_app/flaskapp/captured_images/1/unique_key_timestamp.png'
    // And Nginx serves /static_images/ from captured_images/
    final String baseStaticUrl = DioClient.rootUrl + 'static_images/';

    // Find the index of 'captured_images/' and get the substring after it
    int startIndex = backendImagePath.indexOf('captured_images/');
    if (startIndex != -1) {
      String relativePath = backendImagePath.substring(startIndex + 'captured_images/'.length);
      return '$baseStaticUrl$relativePath';
    }
    return ''; // Or handle error
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Alert Session Details",
          style: TextStyle(
            fontSize: $appUtils.sizing(20.0, context),
            fontWeight: FontWeight.bold,
            color: $styles.colors.title,
          ),
        ),
        backgroundColor: $styles.colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: $styles.colors.primary))
          : _sessionDetails == null
          ? Center(child: Text("Failed to load session details.", style: TextStyle(color: $styles.colors.red, fontSize: $appUtils.sizing(16.0, context))))
          : ListView(
        padding: EdgeInsets.all($appUtils.sizing(defaultPadding, context)),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all($appUtils.sizing(15, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Session ID: ${_sessionDetails!['id']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: $appUtils.sizing(16.0, context))),
                  $appUtils.gap(context, height: 5),
                  Text("Area Config ID: ${_sessionDetails!['areaConfigId']}", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                  $appUtils.gap(context, height: 5),
                  Text("Start Time: ${_formatDateTime(DateTime.parse(_sessionDetails!['startTime']))}", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                  $appUtils.gap(context, height: 5),
                  Text("End Time: ${_formatDateTime(_sessionDetails!['endTime'] != null ? DateTime.parse(_sessionDetails!['endTime']) : null)}", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                  $appUtils.gap(context, height: 5),
                  Row(
                    children: [
                      Text("Status: ", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                      Text(
                        _sessionDetails!['status'],
                        style: TextStyle(
                          color: _sessionDetails!['status'] == 'COMPLETED_CHANGES_DETECTED' ? $styles.colors.red : $styles.colors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: $appUtils.sizing(14.0, context),
                        ),
                      ),
                    ],
                  ),
                  $appUtils.gap(context, height: 5),
                  Text("Total Changes Detected: ${_sessionDetails!['totalChangesDetected']}", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                ],
              ),
            ),
          ),
          $appUtils.gap(context, height: 20),
          Text("Detected Changes:", style: TextStyle(fontSize: $appUtils.sizing(18.0, context), fontWeight: FontWeight.bold)),
          $appUtils.gap(context, height: 10),
          if (_alertDetails.isEmpty)
            Text("No specific changes logged for this session.", style: TextStyle(color: $styles.colors.greyLight, fontSize: $appUtils.sizing(14.0, context)))
          else
            ..._alertDetails.map((detail) => Card(
              margin: EdgeInsets.only(bottom: $appUtils.sizing(10, context)),
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: EdgeInsets.all($appUtils.sizing(15, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Image Tile ID: ${detail.imageTileId}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: $appUtils.sizing(16.0, context))),
                    $appUtils.gap(context, height: 5),
                    Text("Alert Time: ${_formatDateTime(detail.alertTime)}", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                    $appUtils.gap(context, height: 5),
                    Text("Change Log:", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                    Text(
                      detail.changeLog != null
                          ? detail.changeLog.toString()
                          : "N/A",
                      style: TextStyle(fontSize: $appUtils.sizing(12.0, context)),
                      maxLines: 50,
                    ),
                    $appUtils.gap(context, height: 10),
                    Text("Previous Image:", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                    _getImageDisplay(_getImageUrl(detail.previousImagePath)),
                    $appUtils.gap(context, height: 10),
                    Text("Current Image:", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                    _getImageDisplay(_getImageUrl(detail.currentImagePath)),
                  ],
                ),
              ),
            )).toList(),
        ],
      ),
    );
  }

  Widget _getImageDisplay(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Text("Image path not available.", style: TextStyle(color: $styles.colors.greyLight, fontSize: $appUtils.sizing(14.0, context)));
    }
    return Image.network(
      imageUrl,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Text("Could not load image. Check path/Nginx config. Error: $error", style: TextStyle(color: $styles.colors.red, fontSize: $appUtils.sizing(14.0, context)));
      },
      fit: BoxFit.cover,
      width: double.infinity,
      height: $appUtils.sizing(200.0, context),
    );
  }
}
