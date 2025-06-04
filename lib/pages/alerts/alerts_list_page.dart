import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../main.dart'; // For global accessors
import '../../models/alert_session.dart';
import '../../services/api_service.dart';
import '../../utils/app_constants.dart';
import '../../utils/responsive.dart' as $appUtils;
import 'alert_details_page.dart';

class AlertsListPage extends StatefulWidget {
  const AlertsListPage({super.key});

  @override
  State<AlertsListPage> createState() => _AlertsListPageState();
}

class _AlertsListPageState extends State<AlertsListPage> {
  final ApiService _apiService = ApiService();
  List<AlertSession> _alertSessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlertSessions();
  }

  Future<void> _fetchAlertSessions() async {
    setState(() { _isLoading = true; });
    _alertSessions = await _apiService.getAlertSessions();
    setState(() { _isLoading = false; });
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return $strings.unknown;
    return DateFormat('dd MMM yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: $styles.colors.primary))
          : _alertSessions.isEmpty
          ? Center(child: Text("No alert sessions found.", style: TextStyle(color: $styles.colors.greyLight, fontSize: $appUtils.sizing(16.0, context))))
          : ListView.builder(
        padding: EdgeInsets.all($appUtils.sizing(defaultPadding, context)),
        itemCount: _alertSessions.length,
        itemBuilder: (context, index) {
          final session = _alertSessions[index];
          return Card(
            margin: EdgeInsets.only(bottom: $appUtils.sizing(10, context)),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: InkWell( // Replaced CustomInkWell with InkWell
              onTap: () {
                navigate(context, AlertDetailsPage(alertSessionId: session.id!));
              },
              child: Padding(
                padding: EdgeInsets.all($appUtils.sizing(15, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Session ID: ${session.id}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: $appUtils.sizing(16.0, context))),
                    $appUtils.gap(context, height: 5),
                    Text("Area Config ID: ${session.areaConfigId}", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                    $appUtils.gap(context, height: 5),
                    Text("Start Time: ${_formatDateTime(session.startTime)}", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                    $appUtils.gap(context, height: 5),
                    Text("End Time: ${_formatDateTime(session.endTime)}", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                    $appUtils.gap(context, height: 5),
                    Row(
                      children: [
                        Text("Status: ", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                        Text(
                          session.status,
                          style: TextStyle(
                            color: session.status == 'COMPLETED_CHANGES_DETECTED' ? $styles.colors.red : $styles.colors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: $appUtils.sizing(14.0, context),
                          ),
                        ),
                      ],
                    ),
                    $appUtils.gap(context, height: 5),
                    Text("Total Changes: ${session.totalChangesDetected}", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}