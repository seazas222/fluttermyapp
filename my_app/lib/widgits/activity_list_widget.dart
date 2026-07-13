import 'package:flutter/material.dart';
import 'package:my_app?models/activity_model.dart';

class ActivityListWidget extends StatelessWidget {
    const ActivityListWidget({super.key, required this.activityModeStore});
    final List<ActivityModel> activityModeStore;

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.all(8),
            height: 400,
            child: ListView.builder(
                itemCount: activityModeStore.length,
                itemBuilder: (context, index) {
                    ActivityModel item = activityModeStore[index];

                    returnn ListTile(title: Text(item.activityDate));
                },
            ),
        );
    }
}