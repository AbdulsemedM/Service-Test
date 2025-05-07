import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../models/service_model.dart';
import '../../controllers/service_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'service_widget.dart';
import 'package:intl/intl.dart';

class ViewServiceDetailModal extends StatelessWidget {
  final String serviceId;
  const ViewServiceDetailModal({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final ServiceController controller = Get.find<ServiceController>();
    controller.fetchServiceById(serviceId);

    return Obx(() {
      if (controller.isLoadingById.value) {
        return ServiceWidget.detailShimmer();
      }

      final service = controller.service.value;
      if (service == null) {
        return const Center(child: Text('Service not found'));
      }

      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Image Section with Gradient Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    service.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      service.name,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                ),
              ],
            ),

            // Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '\$${service.price}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: (service.rating / 100) *
                                5, // Convert to 5-star scale
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: _getStarColor(
                                  double.parse(service.rating.toString())),
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            unratedColor: Colors.grey[300],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${service.rating}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category
                  ServiceWidget.buildInfoRow(
                    context,
                    Icons.category_outlined,
                    'Category',
                    service.category,
                  ),
                  const SizedBox(height: 12),

                  // Availability
                  ServiceWidget.buildInfoRow(
                    context,
                    Icons.timelapse,
                    'Availability',
                    service.availability,
                  ),
                  const SizedBox(height: 12),

                  // Duration
                  ServiceWidget.buildInfoRow(
                    context,
                    Icons.access_time,
                    'Duration',
                    DateFormat('dd-MM-yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(service.duration.toString())),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.1),
                        ),
                        icon: const Icon(Icons.edit),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {
                          _showDeleteConfirmation(
                              context, controller, serviceId);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.1),
                        ),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.1),
                        ),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showDeleteConfirmation(
      BuildContext context, ServiceController controller, String serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this service?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                controller.deleteService(serviceId);
                controller.fetchServices(); // Refresh the list
                Navigator.of(context).pop(); // Close the confirmation dialog
                Navigator.of(context).pop(); // Close the detail modal
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Color _getStarColor(double rating) {
    if (rating >= 80) {
      return Colors.green;
    } else if (rating >= 60) {
      return Colors.amber;
    } else if (rating >= 40) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
