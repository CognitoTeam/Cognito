import '../../views/utils/PriorityAgenda/priority.dart';
import 'package:flutter/material.dart';

class Item {

  String name;
  Priority priority;
  String description;
  double completion;

  Item(this.name, this.priority, this.description, this.completion);

  String getPriorityString()
  {
    switch(priority)
    {
      case Priority.URGENT:
        {
          return "Urgent";
        }
        break;
      case Priority.ROUTINE:
        {
          return "Routine";
        }
        break;
      case Priority.DISCRETIONARY:
        {
          return "Discretionary";
        }
        break;
      default:
        {
          return "No priority assigned";
        }
    }
  }

  Color getPriorityColor()
  {
    switch(priority)
    {
      case Priority.URGENT:
        {
          return Colors.red[100];
        }
        break;
      case Priority.ROUTINE:
        {
          return Colors.yellow[100];
        }
        break;
      case Priority.DISCRETIONARY:
        {
          return Colors.green[100];
        }
        break;
      default:
        {
          return Colors.white;
        }
    }
  }
}