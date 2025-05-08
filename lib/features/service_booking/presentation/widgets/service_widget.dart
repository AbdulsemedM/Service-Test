import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/service_model.dart';
import 'package:shimmer/shimmer.dart';

class ServiceWidget extends StatelessWidget {
  final ServiceModel service;
  const ServiceWidget({super.key, required this.service});

  ServiceWidget.shimmer({super.key})
      : service = ServiceModel(
          id: 'shimmer_id',
          name: 'Loading...',
          imageUrl: '',
          availability: 'Loading...',
          category: 'Loading...',
          price: 0,
          createdAt: 0,
          duration: 0,
          rating: 0,
        );

  static Widget detailShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 20,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Container(
                  width: 150,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static List<ServiceModel> filterServices(
      List<ServiceModel> services, String? filter) {
    if (filter == null) return services;

    switch (filter) {
      case 'rating':
        services.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'category':
        services.sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'price':
        services.sort((a, b) => a.price.compareTo(b.price));
        break;
    }
    return services;
  }

  static List<ServiceModel> searchServices(
      List<ServiceModel> services, String query) {
    if (query.isEmpty) return services;

    return services.where((service) {
      final serviceName = service.name.toLowerCase();
      final searchQuery = query.toLowerCase();
      return serviceName.contains(searchQuery);
    }).toList();
  }

  static Widget buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (service.id == 'shimmer_id') {
      // Shimmer effect
      return ListTile(
        leading: Container(width: 50, height: 50, color: Colors.grey[300]),
        title: Container(width: 100, height: 10, color: Colors.grey[300]),
        subtitle: Container(width: 150, height: 10, color: Colors.grey[300]),
      );
    }
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: service.imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        // placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      title: Text(service.name),
      subtitle: Text('\$${service.price} - ${service.category}'),
    );
  }
}
