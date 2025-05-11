import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/utils/app_colors.dart';

class FilterServiceModal extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final double minRating;
  final double maxRating;

  const FilterServiceModal({
    Key? key,
    required this.minPrice,
    required this.maxPrice,
    required this.minRating,
    required this.maxRating,
  }) : super(key: key);

  @override
  _FilterServiceModalState createState() => _FilterServiceModalState();
}

class _FilterServiceModalState extends State<FilterServiceModal> {
  late RangeValues priceRange;
  late RangeValues ratingRange;

  @override
  void initState() {
    super.initState();
    priceRange = RangeValues(widget.minPrice, widget.maxPrice);
    ratingRange = RangeValues(widget.minRating, widget.maxRating);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Services'.tr,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            _buildRangeSlider(
              label: 'Price Range'.tr,
              rangeValues: priceRange,
              min: 0,
              max: 100,
              onChanged: (values) {
                setState(() {
                  priceRange = values;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildRangeSlider(
              label: 'Rating Range'.tr,
              rangeValues: ratingRange,
              min: 0,
              max: 100,
              onChanged: (values) {
                setState(() {
                  ratingRange = values;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Get.back(result: {
                  'priceRange': priceRange,
                  'ratingRange': ratingRange,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Apply Filters'.tr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeSlider({
    required String label,
    required RangeValues rangeValues,
    required double min,
    required double max,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        RangeSlider(
          values: rangeValues,
          min: min,
          max: max,
          divisions: 10,
          labels: RangeLabels(
            rangeValues.start.toStringAsFixed(1),
            rangeValues.end.toStringAsFixed(1),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
