/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:beagle/model/beagle_style.dart';
import 'package:beagle/model/beagle_ui_element.dart';
import 'package:beagle/utils/flex.dart';
import 'package:flutter/widgets.dart';

class BeagleContainer extends StatefulWidget {
  const BeagleContainer({
    Key key,
    this.children,
    this.context,
    this.onInit,
    this.style,
  }) : super(key: key);

  final List<Widget> children;
  final DataContext context;
  final Function onInit;
  final BeagleStyle style;

  @override
  _BeagleContainerState createState() => _BeagleContainerState();
}

class _BeagleContainerState extends State<BeagleContainer> {
  @override
  void initState() {
    super.initState();
    if (widget.onInit != null) {
      widget.onInit();
    }
  }

  @override
  Widget build(BuildContext context) =>
      // todo this will be extracted to work with other components
      applyFlexDirection(widget.children, flex: widget.style?.flex);
}