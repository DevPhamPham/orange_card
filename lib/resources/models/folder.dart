import 'package:flutter/material.dart';

class Folder {
  final IconData icon;
  final String title;
  final String time;
  final int numberOfChildren;

  Folder({
    required this.icon,
    required this.title,
    required this.time,
    required this.numberOfChildren,
  });
}