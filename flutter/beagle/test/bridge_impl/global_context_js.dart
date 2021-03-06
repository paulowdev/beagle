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

import 'dart:convert';

import 'package:beagle/bridge_impl/beagle_js_engine.dart';
import 'package:beagle/bridge_impl/global_context_js.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockJSRuntime extends Mock implements JavascriptRuntime {}

class User {
  User(this.name, this.age);
  String name;
  int age;
}

void main() {
  test('Should set value in global context', () {
    BeagleJSEngine.js = MockJSRuntime();
    final value = {
      'abc': 1,
      'def': false,
      'ghi': 'test',
      'jkl': [1, '2', true]
    };
    GlobalContextJS().set(value);
    expect(verify(BeagleJSEngine.js.evaluate(captureAny)).captured.single,
        'global.beagle.getService().globalContext.set(${jsonEncode(value)})');
  });

  test('Should set value in global context at specific path', () {
    BeagleJSEngine.js = MockJSRuntime();
    GlobalContextJS().set('test', 'order.cart.name');
    expect(verify(BeagleJSEngine.js.evaluate(captureAny)).captured.single,
        "global.beagle.getService().globalContext.set(\"test\", 'order.cart.name')");
  });

  test('Should throw exception when trying to set non-encodable value', () {
    BeagleJSEngine.js = MockJSRuntime();

    final user = User('Fulano', 30);
    expect(() => GlobalContextJS().set(user, 'user'),
        throwsA(isInstanceOf<GlobalContextSerializationError>()));
    verifyNever(BeagleJSEngine.js.evaluate(captureAny));
  });

  test('Should get global context', () {
    BeagleJSEngine.js = MockJSRuntime();
    final value = {
      'account': {'number': 1, 'name': 'Fulano', 'email': 'fulano@beagle.com'},
      'order': {
        'cart': {
          'name': 'Flutter test',
          'items': [
            {'name': 'keyboard', 'price': 39.9},
            {'name': 'mouse', 'price': 28.45}
          ]
        }
      }
    };
    when(BeagleJSEngine.js
            .evaluate('global.beagle.getService().globalContext.get()'))
        .thenReturn(JsEvalResult(value.toString(), value));
    final result = GlobalContextJS().get();
    expect(result, value);
  });

  test('Should get value in global context at specific path', () {
    BeagleJSEngine.js = MockJSRuntime();
    const value = 'Flutter test';
    when(BeagleJSEngine.js.evaluate(
            "global.beagle.getService().globalContext.get('order.cart.name')"))
        .thenReturn(JsEvalResult(value, value));
    final result = GlobalContextJS().get('order.cart.name');
    expect(result, value);
  });

  test('Should clear global context', () {
    BeagleJSEngine.js = MockJSRuntime();
    GlobalContextJS().clear();
    expect(verify(BeagleJSEngine.js.evaluate(captureAny)).captured.single,
        'global.beagle.getService().globalContext.clear()');
  });

  test('Should clear global context at specific path', () {
    BeagleJSEngine.js = MockJSRuntime();
    GlobalContextJS().clear('order.cart.name');
    expect(verify(BeagleJSEngine.js.evaluate(captureAny)).captured.single,
        "global.beagle.getService().globalContext.clear('order.cart.name')");
  });
}
