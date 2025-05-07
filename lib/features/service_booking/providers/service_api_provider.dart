import 'dart:convert';
import 'package:service_booking/configuration/api_constants.dart';
import 'package:service_booking/providers/provider_setup.dart';
import '../models/service_model.dart';

class ApiProvider {
  Future<List<ServiceModel>> fetchServices() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/service");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("data");
        return data.map((json) => ServiceModel.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<ServiceModel> fetchServicesById(String id) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/service/$id");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("data");
        return ServiceModel.fromMap(data);
      } else {
        throw Exception('Failed to load service');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<String> deleteService(String id) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.deleteRequest("/api/v1/service/$id");
      if (response.statusCode == 200) {
        return "Successfully deleted service";
      } else {
        throw Exception('Failed to delete service');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<String> addService(Map<String, dynamic> service) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.postRequest("/api/v1/service", service);
      if (response.statusCode == 201) {
        return "Successfully added service";
      } else {
        throw Exception('Failed to add service');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }
}
