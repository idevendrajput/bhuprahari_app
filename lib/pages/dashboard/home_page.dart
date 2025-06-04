import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../components/global_snackbar.dart';
import '../../main.dart'; // For global accessors
import '../../models/area_config.dart';
import '../../models/image_tile.dart';
import '../../services/api_service.dart';
import '../../utils/responsive.dart' as $appUtils;
import '../add_area_config_page.dart';
import '../view_changes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  final ApiService _apiService = ApiService();

  AreaConfig? _selectedAreaConfig;
  List<AreaConfig> _areaConfigs = [];
  ImageTile? _latestImageTile;
  int _geoChangeCount = 0;
  final StreamController<bool> _superviseLoadingController = StreamController<bool>();


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.346251, 74.636383), // Default Location : Bhilwara, Rajasthan
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _fetchAreaConfigs();
  }

  @override
  void dispose() {
    _superviseLoadingController.close();
    super.dispose();
  }

  Future<void> _fetchAreaConfigs() async {
    _areaConfigs = await _apiService.getAllAreaConfigs();
    if (_areaConfigs.isNotEmpty) {
      setState(() {
        _selectedAreaConfig = _areaConfigs.first;
      });
      _fetchLatestImageTileAndChanges();
    } else {
      setState(() {
        _selectedAreaConfig = null;
      });
    }
  }

  Future<void> _fetchLatestImageTileAndChanges() async {
    if (_selectedAreaConfig == null || _selectedAreaConfig!.id == null) return;

    final areaId = _selectedAreaConfig!.id!;
    final imageTiles = await _apiService.getAreaImageTiles(areaId);

    if (imageTiles.isNotEmpty) {
      imageTiles.sort((a, b) => b.captureTime.compareTo(a.captureTime));
      setState(() {
        _latestImageTile = imageTiles.first;
        _geoChangeCount = imageTiles.where((tile) => tile.changeDetected == true).length;
      });
    } else {
      setState(() {
        _latestImageTile = null;
        _geoChangeCount = 0;
      });
    }
  }

  Future<void> _triggerSuperviseNow() async {
    if (_selectedAreaConfig == null || _selectedAreaConfig!.id == null) {
      GlobalSnackbarHelper.showSnackbar($strings.error, "Please select an area configuration first.");
      return;
    }

    _superviseLoadingController.add(true);
    GlobalSnackbarHelper.showSnackbar($strings.success, "Triggering supervision...");
    bool captureSuccess = await _apiService.triggerImageCapture(_selectedAreaConfig!.id!);
    if (captureSuccess) {
      GlobalSnackbarHelper.showSnackbar($strings.success, $strings.captureTriggered);
      bool compareSuccess = await _apiService.triggerImageComparison(_selectedAreaConfig!.id!);
      if (compareSuccess) {
        GlobalSnackbarHelper.showSnackbar($strings.success, $strings.comparisonTriggered);
        await _fetchLatestImageTileAndChanges();
      } else {
        GlobalSnackbarHelper.showSnackbar($strings.error, $strings.comparisonFailed);
      }
    } else {
      GlobalSnackbarHelper.showSnackbar($strings.error, $strings.captureFailed);
    }
    _superviseLoadingController.add(false);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return $strings.unknown;
    return DateFormat('dd MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: LatLng(_selectedAreaConfig?.centerLat ?? _kGooglePlex.target.latitude,
                  _selectedAreaConfig?.centerLon ?? _kGooglePlex.target.longitude),
              zoom: _kGooglePlex.zoom,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _selectedAreaConfig != null
                ? {
              Marker(
                markerId: MarkerId(_selectedAreaConfig!.id.toString()),
                position: LatLng(_selectedAreaConfig!.centerLat, _selectedAreaConfig!.centerLon),
                infoWindow: InfoWindow(title: _selectedAreaConfig!.name),
              ),
            }
                : {},
          ),
        ),
        Container(
          padding: EdgeInsets.all($appUtils.sizing(15, context)),
          decoration: BoxDecoration(
            color: $styles.colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Default Location: Bhilwara",
                style: TextStyle(
                  fontSize: $appUtils.sizing(16.0, context),
                  fontWeight: FontWeight.bold,
                  color: $styles.colors.title,
                ),
              ),
              Row(
                children: [
                  if (_areaConfigs.isNotEmpty)
                    DropdownButton<AreaConfig>(
                      value: _selectedAreaConfig,
                      onChanged: (AreaConfig? newValue) {
                        setState(() {
                          _selectedAreaConfig = newValue;
                        });
                        _fetchLatestImageTileAndChanges();
                      },
                      items: _areaConfigs.map<DropdownMenuItem<AreaConfig>>((AreaConfig config) {
                        return DropdownMenuItem<AreaConfig>(
                          value: config,
                          child: Text(
                            config.name,
                            style: TextStyle(fontSize: $appUtils.sizing(14.0, context)),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Text(
                      $strings.noAreaConfigs,
                      style: TextStyle(fontSize: $appUtils.sizing(14.0, context), color: $styles.colors.red),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      navigate(context, const AddAreaConfigPage());
                      _fetchAreaConfigs();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: $styles.colors.accent1,
                      foregroundColor: $styles.colors.white,
                      padding: EdgeInsets.symmetric(horizontal: $appUtils.sizing(10, context), vertical: $appUtils.sizing(7, context)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular($appUtils.sizing(10, context)),
                      ),
                      textStyle: TextStyle(fontSize: $appUtils.sizing(12.0, context)),
                    ),
                    child: const Text("Add Area"),
                  ),
                ],
              ),
              $appUtils.gap(context, height: 10),
              Container(
                padding: EdgeInsets.all($appUtils.sizing(15, context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular($appUtils.sizing(10, context)),
                  border: Border.all(color: $styles.colors.greyLight, width: 1),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          $strings.lastUpdate,
                          style: TextStyle(fontSize: $appUtils.sizing(14.0, context), color: $styles.colors.title),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(_latestImageTile?.captureTime),
                          style: TextStyle(fontSize: $appUtils.sizing(14.0, context), color: $styles.colors.title),
                        ),
                      ],
                    ),
                    $appUtils.gap(context, height: 10),
                    Row(
                      children: [
                        Text(
                          $strings.nextUpdate,
                          style: TextStyle(fontSize: $appUtils.sizing(14.0, context), color: $styles.colors.title),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(_latestImageTile?.captureTime?.add(const Duration(days: 15))),
                          style: TextStyle(fontSize: $appUtils.sizing(14.0, context), color: $styles.colors.title),
                        ),
                      ],
                    ),
                    $appUtils.gap(context, height: 15),
                    Row(
                      children: [
                        Text(
                          "$_geoChangeCount",
                          style: TextStyle(
                            fontSize: $appUtils.sizing(16.0, context),
                            fontWeight: FontWeight.bold,
                            color: _geoChangeCount > 0 ? $styles.colors.red : $styles.colors.primary,
                          ),
                        ),
                        $appUtils.gap(context, width: 5),
                        Text(
                          _geoChangeCount > 0 ? $strings.geoChangesDetected : $strings.noChangesDetected,
                          style: TextStyle(
                            fontSize: $appUtils.sizing(14.0, context),
                            color: _geoChangeCount > 0 ? $styles.colors.red : $styles.colors.primary,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            if (_selectedAreaConfig != null) {
                              navigate(context, ViewChangesPage(areaConfigId: _selectedAreaConfig!.id!));
                            } else {
                              GlobalSnackbarHelper.showSnackbar($strings.error, $strings.selectAreaForAction);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: $styles.colors.blue,
                            foregroundColor: $styles.colors.white,
                            padding: EdgeInsets.symmetric(horizontal: $appUtils.sizing(10, context), vertical: $appUtils.sizing(7, context)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular($appUtils.sizing(10, context)),
                            ),
                            textStyle: TextStyle(fontSize: $appUtils.sizing(12.0, context)),
                          ),
                          child: Text($strings.viewNow),
                        ),
                      ],
                    ),
                    $appUtils.gap(context, height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: StreamBuilder<bool>(
                        stream: _superviseLoadingController.stream,
                        initialData: false,
                        builder: (context, snapshot) {
                          final isLoading = snapshot.data ?? false;
                          return ElevatedButton(
                            onPressed: isLoading ? null : _triggerSuperviseNow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: $styles.colors.primary,
                              foregroundColor: $styles.colors.white,
                              padding: EdgeInsets.all($appUtils.sizing(15.0, context)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
                              ),
                              textStyle: TextStyle(
                                fontSize: $appUtils.sizing(16.0, context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: isLoading
                                ? SizedBox(
                              height: $appUtils.sizing(20.0, context),
                              width: $appUtils.sizing(20.0, context),
                              child: CircularProgressIndicator(
                                color: $styles.colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text($strings.superviseNow),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
