import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/models/task.dart';

class TaskWidget extends StatelessWidget {
  final TaskModel taskModel;
  const TaskWidget({
    Key? key,
    required this.taskModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 90.w,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: AppColors.getDarkLinearGradient(
                      Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(2, 6),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskModel.taskName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${taskModel.from.hour}  min - ${taskModel.to.hour} min",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
