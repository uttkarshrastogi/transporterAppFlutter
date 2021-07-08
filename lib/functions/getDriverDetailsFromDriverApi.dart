import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'dart:convert';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

Future<List> getDriverDetailsFromDriverApi(
    BuildContext context/*, driverIdList*/) async {
  var providerData = Provider.of<ProviderData>(context, listen: false);
  var jsonData;
  TransporterIdController tIdController = Get.find<TransporterIdController>();
  final String driverApiUrl = FlutterConfig.get('driverApiUrl').toString();
  List<DriverModel> driverDetailsList = [];
    try {
      http.Response response = await http.get(Uri.parse("$driverApiUrl?transporterId=${tIdController.transporterId}"));
      jsonData = json.decode(response.body);
      for(var json in jsonData) {
        DriverModel driverModel = DriverModel();
        driverModel.driverId = json["driverId"];
        driverModel.transporterId = json["transporterId"];
        driverModel.phoneNum = json["phoneNum"];
        driverModel.driverName = json["driverName"];
        driverModel.truckId = json["truckId"];
        driverDetailsList.add(driverModel);
        providerData.updateDriverNameList(
            newValue: "${driverModel.driverName} - ${driverModel.phoneNum}");
      }
    } catch (e) {
      print(e);
    }
  return driverDetailsList;
}
