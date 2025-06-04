import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart'; // For global accessors
import '../models/image_tile.dart';
import '../services/api_service.dart';
import '../network/dio_client.dart';
import '../utils/app_constants.dart';
import '../utils/responsive.dart' as $appUtils; // To get rootUrl

class ViewChangesPage extends StatefulWidget {
  final int areaConfigId;
  const ViewChangesPage({super.key, required this.areaConfigId});

  @override
  State<ViewChangesPage> createState() => _ViewChangesPageState();
}

class _ViewChangesPageState extends State<ViewChangesPage> {
  final ApiService _apiService = ApiService();
  List<ImageTile> _imageTiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchImageTiles();
  }

  Future<void> _fetchImageTiles() async {
    setState(() { _isLoading = true; });
    _imageTiles = await _apiService.getAreaImageTiles(widget.areaConfigId);
    setState(() { _isLoading = false; });
  }

  String _formatDateWithTime(DateTime? date) {
    if (date == null) return $strings.unknown;
    return DateFormat('dd MMMMilizce HH:mm').format(date);
  }

  // Helper to get image URL from backend file path
  String _getImageUrl(String backendFilePath) {
    // Ensure DioClient.rootUrl is correctly set to 'http://69.62.85.159/' or your domain
    const baseStaticUrl = '${DioClient.rootUrl}static_images/';

    // The backendFilePath is like: /home/root/bhuprahari_app/flaskapp/captured_images/1/1_25_...png
    // We need to extract '1/1_25_...png' from it.

    // Find the index of 'captured_images/' and get the substring after it
    int startIndex = backendFilePath.indexOf('captured_images/');
    if (startIndex != -1) {
      String relativePath = backendFilePath.substring(startIndex + 'captured_images/'.length);
      // Ensure the relative path doesn't start with a slash if it's already part of the baseStaticUrl
      if (relativePath.startsWith('/')) {
        relativePath = relativePath.substring(1);
      }
      return '$baseStaticUrl$relativePath';
    }
    return ''; // Return empty string or a placeholder URL if path is invalid
  }

  // Helper widget to display an image with loading and error states
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
        print("Could not load image. Check path/Nginx config. Error: $error");
        return Text("Could not load image. Check path/Nginx config. Error: $error", style: TextStyle(color: $styles.colors.red, fontSize: $appUtils.sizing(14.0, context)));
      },
      fit: BoxFit.cover,
      width: double.infinity,
      height: $appUtils.sizing(200.0, context), // Fixed height for preview
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          $strings.viewChanges,
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
          : _imageTiles.isEmpty
          ? Center(child: Text("No image tiles found for this area.", style: TextStyle(color: $styles.colors.greyLight, fontSize: $appUtils.sizing(16.0, context))))
          : ListView.builder(
        padding: EdgeInsets.all($appUtils.sizing(defaultPadding, context)),
        itemCount: _imageTiles.length,
        itemBuilder: (context, index) {
          final tile = _imageTiles[index];
          print("object>>>>>>>>>>>>>>>>>>>> ${tile.toJson()}");
          return Card(
            margin: EdgeInsets.only(bottom: $appUtils.sizing(10, context)),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all($appUtils.sizing(15, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${$strings.uniqueKey}: ${tile.uniqueKey}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: $appUtils.sizing(16.0, context))),
                  $appUtils.gap(context, height: 5),
                  Text("${$strings.captureTime}: ${_formatDateWithTime(tile.captureTime)}", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                  $appUtils.gap(context, height: 5),
                  Text("${$strings.status}: ${tile.status}", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                  $appUtils.gap(context, height: 5),
                  Text("${$strings.lastComparison}: ${_formatDateWithTime(tile.lastComparisonTime)}", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                  $appUtils.gap(context, height: 5),
                  Row(
                    children: [
                      Text("${$strings.changeDetected}: ", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                      Text(
                        tile.changeDetected == true ? $strings.yes : (tile.changeDetected == false ? $strings.no : $strings.no),
                        style: TextStyle(
                          color: tile.changeDetected == true ? $styles.colors.red : (tile.changeDetected == false ? $styles.colors.primary : $styles.colors.black),
                          fontWeight: FontWeight.bold,
                          fontSize: $appUtils.sizing(14.0, context),
                        ),
                      ),
                    ],
                  ),
                  $appUtils.gap(context, height: 10), // Gap before image
                  Text("Captured Image:", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                  _getImageDisplay(_getImageUrl(tile.imagePath)), // Display the image
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
