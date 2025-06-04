import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For FilteringTextInputFormatter

import '../../main.dart'; // For global accessors, navigatePop, snackBar
import '../../models/area_config.dart';
import '../../services/api_service.dart';
import '../components/global_snackbar.dart';
import '../utils/app_constants.dart';
import '../utils/responsive.dart' as $appUtils;

class AddAreaConfigPage extends StatefulWidget {
  const AddAreaConfigPage({super.key});

  @override
  State<AddAreaConfigPage> createState() => _AddAreaConfigPageState();
}

class _AddAreaConfigPageState extends State<AddAreaConfigPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _centerLatController = TextEditingController();
  final TextEditingController _centerLonController = TextEditingController();
  final TextEditingController _northKmController = TextEditingController();
  final TextEditingController _southKmController = TextEditingController();
  final TextEditingController _eastKmController = TextEditingController();
  final TextEditingController _westKmController = TextEditingController();

  final ApiService _apiService = ApiService();
  final StreamController<bool> _loadingController = StreamController<bool>();

  Future<void> _saveAreaConfig() async {
    _loadingController.add(true);
    final name = _nameController.text.trim();
    final centerLat = double.tryParse(_centerLatController.text);
    final centerLon = double.tryParse(_centerLonController.text);
    final northKm = double.tryParse(_northKmController.text);
    final southKm = double.tryParse(_southKmController.text);
    final eastKm = double.tryParse(_eastKmController.text);
    final westKm = double.tryParse(_westKmController.text);

    if (name.isEmpty ||
        centerLat == null || centerLon == null ||
        northKm == null || southKm == null ||
        eastKm == null || westKm == null) {
      GlobalSnackbarHelper.showSnackbar($strings.error, "Please fill all fields with valid numbers.");
      _loadingController.add(false);
      return;
    }

    final newAreaConfig = AreaConfig(
      name: name,
      centerLat: centerLat,
      centerLon: centerLon,
      northKm: northKm,
      southKm: southKm,
      eastKm: eastKm,
      westKm: westKm,
      createdAt: DateTime.now(),
    );

    final createdConfig = await _apiService.createAreaConfig(newAreaConfig);
    _loadingController.add(false);

    if (createdConfig != null) {
      GlobalSnackbarHelper.showSnackbar($strings.success, $strings.areaSavedSuccess);
      if(!mounted) return;
      navigatePop(context);
    } else {
      // Error message handled by ApiService.snackBar
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _centerLatController.dispose();
    _centerLonController.dispose();
    _northKmController.dispose();
    _southKmController.dispose();
    _eastKmController.dispose();
    _westKmController.dispose();
    _loadingController.close();
    super.dispose();
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? inputType,
    bool isNumeric = false,
    bool isDecimalNumeric = false,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType ?? (isNumeric || isDecimalNumeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text),
      inputFormatters: [
        if (isNumeric) FilteringTextInputFormatter.digitsOnly,
        if (isDecimalNumeric) FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        hintText: hint,
        labelText: hint,
        prefixIcon: icon != null ? Icon(icon, color: $styles.colors.greyMedium) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
          borderSide: BorderSide(color: $styles.colors.greyLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
          borderSide: BorderSide(color: $styles.colors.blue, width: 2.0),
        ),
      ),
      style: TextStyle(fontSize: $appUtils.sizing(14.0, context), color: $styles.colors.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          $strings.addArea,
          style: TextStyle(
            fontSize: $appUtils.sizing(20.0, context),
            fontWeight: FontWeight.bold,
            color: $styles.colors.title,
          ),
        ),
        backgroundColor: $styles.colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all($appUtils.sizing(defaultPadding, context)),
        child: Column(
          children: [
            _buildInputField(controller: _nameController, hint: $strings.areaName, icon: Icons.drive_file_rename_outline),
            $appUtils.gap(context, height: 15),
            _buildInputField(controller: _centerLatController, hint: $strings.centerLatitude, inputType: TextInputType.numberWithOptions(decimal: true), isDecimalNumeric: true, icon: Icons.location_on),
            $appUtils.gap(context, height: 15),
            _buildInputField(controller: _centerLonController, hint: $strings.centerLongitude, inputType: TextInputType.numberWithOptions(decimal: true), isDecimalNumeric: true, icon: Icons.location_on),
            $appUtils.gap(context, height: 15),
            _buildInputField(controller: _northKmController, hint: $strings.northKm, inputType: TextInputType.number, isNumeric: true, icon: Icons.arrow_upward),
            $appUtils.gap(context, height: 15),
            _buildInputField(controller: _southKmController, hint: $strings.southKm, inputType: TextInputType.number, isNumeric: true, icon: Icons.arrow_downward),
            $appUtils.gap(context, height: 15),
            _buildInputField(controller: _eastKmController, hint: $strings.eastKm, inputType: TextInputType.number, isNumeric: true, icon: Icons.arrow_forward),
            $appUtils.gap(context, height: 15),
            _buildInputField(controller: _westKmController, hint: $strings.westKm, inputType: TextInputType.number, isNumeric: true, icon: Icons.arrow_back),
            $appUtils.gap(context, height: 25),
            SizedBox(
              width: double.infinity,
              child: StreamBuilder<bool>(
                stream: _loadingController.stream,
                initialData: false,
                builder: (context, snapshot) {
                  final isLoading = snapshot.data ?? false;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _saveAreaConfig,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: $styles.colors.primary,
                      foregroundColor: $styles.colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
                      ),
                      padding: EdgeInsets.all($appUtils.sizing(15.0, context)),
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
                        : Text($strings.saveArea),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
