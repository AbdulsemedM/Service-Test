import 'dart:convert';
import 'package:service_booking/configuration/api_constants.dart';
import 'package:service_booking/providers/provider_setup.dart';
import '../models/service_model.dart';
import 'package:get/get.dart';

class ServiceApiProvider {
  Future<List<ServiceModel>> fetchServices(int page, int size) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider
          .getRequest("/api/v1/service", params: {"page": page, "limit": size});
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("data");
        return data.map((json) => ServiceModel.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load services'.tr);
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
        throw Exception('Failed to load service'.tr);
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
        return "Successfully deleted service".tr;
      } else {
        throw Exception('Failed to delete service'.tr);
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
        return "Successfully added service".tr;
      } else {
        throw Exception('Failed to add service'.tr);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<String> editService(Map<String, dynamic> service, String id) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.putRequest("/api/v1/service/$id", service);
      if (response.statusCode == 200) {
        return "Successfully updated service".tr;
      } else {
        throw Exception('Failed to update service'.tr);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }
}
