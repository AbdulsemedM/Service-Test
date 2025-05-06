import 'package:get/get.dart';
import '../models/service_model.dart';
import '../providers/service_api_provider.dart';

class ServiceController extends GetxController {
  final ApiProvider apiProvider = ApiProvider();

  var services = <ServiceModel>[].obs;
  var isLoading = true.obs;
  var isLoadingById = true.obs;
  var error = ''.obs;
  var service = Rxn<ServiceModel>();
  var isDeleted = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  void fetchServices() async {
    try {
      isLoading.value = true;
      final result = await apiProvider.fetchServices();
      services.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void fetchServiceById(String id) async {
    try {
      isLoadingById.value = true;
      final result = await apiProvider.fetchServicesById(id);
      service.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingById.value = false;
    }
  }

  void deleteService(String id) async {
    try {
      await apiProvider.deleteService(id);
      isDeleted.value = true;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isDeleted.value = false;
    }
  }
}
