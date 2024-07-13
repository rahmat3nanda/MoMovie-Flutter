/*
 * *
 *  * dev_page.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:44
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 18:44
 *
 */

import 'package:flutter/material.dart';

class DevPage extends StatefulWidget {
  const DevPage({super.key, this.transparent = false});

  final bool transparent;

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.transparent ? Colors.transparent : null,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64.0,
              color: Colors.grey[700],
            ),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text("Halaman ini\nsedang dalam tahap\nPengembangan",
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
