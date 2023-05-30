import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mfyp_cust/includes/models/history.model.dart';

import '../utilities/colors.dart';
import '../utilities/dimension.util.dart';

class MFYPHistoryWidget extends StatefulWidget {
  RequestHistoryModel? requestHistoryModel;
  MFYPHistoryWidget({super.key, this.requestHistoryModel});

  @override
  State<MFYPHistoryWidget> createState() => _MFYPHistoryWidgetState();
}

class _MFYPHistoryWidgetState extends State<MFYPHistoryWidget> {
  String formattedDateTime(String dateTime) {
    DateTime dateTimeLocal = DateTime.parse(dateTime);
    String formattedDT =
        "${DateFormat.MMMd().format(dateTimeLocal)}, ${DateFormat.y().format(dateTimeLocal)} @ ${DateFormat.jm().format(dateTimeLocal)}";
    return formattedDT;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimension.radiusFx(5)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: AppColor.textFieldColor,
          )),
      child: Container(
        padding: EdgeInsets.all(Dimension.radiusFx(5)),
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.primaryColor, width: 1.5),
            borderRadius: BorderRadius.circular(Dimension.radiusFx(8))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.requestHistoryModel!.fullName!,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: Dimension.fontSize(20),
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_history,
                  color: AppColor.primaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Provider Name",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: Dimension.fontSize(14),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.place_outlined,
                  color: AppColor.primaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  widget.requestHistoryModel!.destinationAddress!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Dimension.fontSize(12)),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.schedule_outlined,
                  color: AppColor.primaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  formattedDateTime(widget.requestHistoryModel!.dateTime!),
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimension.fontSize(12)),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.car_repair_outlined,
                  color: AppColor.primaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  widget.requestHistoryModel!.status! == 'done'
                      ? 'Completed'
                      : "",
                  style: TextStyle(
                      color: widget.requestHistoryModel!.status! == 'done'
                          ? Colors.green
                          : Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimension.fontSize(12)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
