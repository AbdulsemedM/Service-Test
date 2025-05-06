import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/features/service_booking/controllers/service_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
               showDialog(
                context: context,
                builder: (context) => const Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: AddServiceModal(),
                  ),
                ),
                      );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Services',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Implement search logic
                controller.fetchServices(); // Refresh services
              },
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
              return ListView.builder(
                itemCount: controller.services.length,
                itemBuilder: (context, index) {
                  final service = controller.services[index];
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
              );
            }),
          ),
        ],
      ),
    );
  }
}
