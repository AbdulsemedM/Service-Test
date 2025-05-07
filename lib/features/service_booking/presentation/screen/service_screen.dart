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
  String? selectedFilter;

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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        hint: const Text('Filter by'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedFilter = newValue;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'rating',
                            child: Text('Rating'),
                          ),
                          DropdownMenuItem(
                            value: 'category',
                            child: Text('Category'),
                          ),
                          DropdownMenuItem(
                            value: 'price',
                            child: Text('Price'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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

              return ListView.builder(
                itemCount: filteredServices.length,
                itemBuilder: (context, index) {
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
              );
            }),
          ),
        ],
      ),
    );
  }
}
