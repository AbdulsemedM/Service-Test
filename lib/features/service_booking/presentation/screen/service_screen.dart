import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/app/utils/dialog_utils.dart';
import 'package:service_booking/features/service_booking/controllers/service_controller.dart';
import '../../../../app/app_button.dart';
import '../../../../app/utils/app_colors.dart';
import '../widgets/add_service_modal.dart';
import '../widgets/service_widget.dart';
import '../widgets/view_service_detail_modal.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final ServiceController controller = Get.find<ServiceController>();
  final TextEditingController searchController = TextEditingController();
  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Services',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Find your perfect service',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        actions: [
          // Notifications button
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
          // Add service button with beautiful animation
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: AddServiceModal(),
                            ),
                          ),
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                    barrierDismissible: true,
                    barrierLabel: '',
                    barrierColor: Colors.black54,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.add,
                        color: Colors.black87,
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Services',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      controller.searchQuery.value = value;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    flex: 2,
                    child: MyButton(
                        backgroundColor: AppColors.primaryColor,
                        onPressed: () {
                          displaySnack(
                              context, 'Filter button pressed', Colors.green);
                        },
                        buttonText: const Text('Filter'))),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return ListView.builder(
                  itemCount: 10, // Number of shimmer items
                  itemBuilder: (context, index) => ServiceWidget.shimmer(),
                );
              }
              if (controller.error.isNotEmpty) {
                return Center(child: Text(controller.error.value));
              }

              var searchedServices = ServiceWidget.searchServices(
                  controller.services, controller.searchQuery.value);

              final filteredServices = ServiceWidget.filterServices(
                  searchedServices, selectedFilter);

              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      !controller.isLoadingMore.value) {
                    controller.loadMore();
                  }
                  return true;
                },
                child: ListView.builder(
                  itemCount: filteredServices.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == filteredServices.length) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final service = filteredServices[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child:
                                  ViewServiceDetailModal(serviceId: service.id),
                            ),
                          ),
                        );
                      },
                      child: ServiceWidget(service: service),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
