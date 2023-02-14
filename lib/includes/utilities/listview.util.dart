import 'package:flutter/material.dart';
import 'package:mfyp_cust/includes/models/predicted_nearby_places.dart';

class MFYPListView extends StatelessWidget {
  final MFYPNearBy? predictedNearby;
  const MFYPListView({super.key, this.predictedNearby});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Container(),
      title: Text(
        predictedNearby!.mainText!,
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: const EdgeInsets.all(10.0),
      leading: const Icon(Icons.location_city_outlined),
    );
  }
}
