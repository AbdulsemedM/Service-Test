import 'package:get/get.dart';
import '../models/service_model.dart';
import '../providers/service_api_provider.dart';

class ServiceController extends GetxController {
  final ServiceApiProvider apiProvider = ServiceApiProvider();

  var services = <ServiceModel>[].obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var isLoadingById = true.obs;
  var error = ''.obs;
  var service = Rxn<ServiceModel>();
  var isDeleted = false.obs;
  var searchQuery = ''.obs;
  var isAddedLoading = false.obs;
  var isUpdatedLoading = false.obs;
  var isAdded = false.obs;
  var isUpdated = false.obs;
  var currentPage = 1;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchServices(currentPage, pageSize);
  }

  Future<void> fetchServices(int page, int size) async {
    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      final result = await apiProvider.fetchServices(page, size);
      if (page == 1) {
        services.assignAll(result);
      } else {
        services.addAll(result);
      }
      if (result.isEmpty) {
        currentPage = -1;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMore() {
    if (currentPage != -1 && !isLoadingMore.value) {
      currentPage++;
      fetchServices(currentPage, pageSize);
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

  Future<void> addService(Map<String, dynamic> service) async {
    try {
      isAddedLoading.value = true;
      await apiProvider.addService(service);
      isAddedLoading.value = false;
      isAdded.value = true;
    } catch (e) {
      error.value = e.toString();
      isAdded.value = false;
      isAddedLoading.value = false;
    }
  }

  Future<void> editService(Map<String, dynamic> service, String id) async {
    try {
      isUpdatedLoading.value = true;
      await apiProvider.editService(service, id);
      isUpdatedLoading.value = false;
      isUpdated.value = true;
    } catch (e) {
      error.value = e.toString();
      isUpdated.value = false;
      isUpdatedLoading.value = false;
    }
  }
}
