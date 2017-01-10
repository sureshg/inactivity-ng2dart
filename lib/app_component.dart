// Copyright (c) 2017, Suresh. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:inactivity/hello_dialog/hello_dialog.dart';
import 'package:async/async.dart';
import 'dart:async';
import 'dart:html';
import 'package:quiver/time.dart';

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [materialDirectives, HelloDialog],
  providers: const [materialProviders],
)
class AppComponent implements OnDestroy, AfterViewInit {
  String activeSince;
  bool pauseAnimate = true;
  DateTime _time = systemTime();
  StreamSubscription<Event> _sub;

  // final DateFormat _formatter = new DateFormat.Hms();

  @override
  ngAfterViewInit() async {
    new Timer.periodic(aMillisecond * 500, (t) => update());
    var brEvents = StreamGroup.merge([
      window.onMouseUp,
      window.onMouseDown,
      window.onMouseMove,
      window.onMouseWheel,
      window.onScroll,
      window.onResize,
      window.onKeyPress,
      window.onTouchStart,
      window.onPageShow,
      window.onFocus,
      window.onContextMenu
    ]).distinct();

    await for (Event e in brEvents) {
      _time = systemTime();
      pauseAnimate = true;
    }
  }

  update() async {
    var diff = systemTime().difference(_time).abs();
    activeSince = diff.toString().split(".")[0];
    // User is inactive here!
    if (diff.inSeconds > 0) {
      pauseAnimate = false;
    }
  }

  @override
  ngOnDestroy() {
    _sub?.cancel();
  }
}
