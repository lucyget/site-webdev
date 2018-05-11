// #docregion
@TestOn('browser')
import 'dart:async';

import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'app_test.template.dart' as ng;

part 'app_test.g.dart';

// #docregion AppPO, AppPO-initial, AppPO-hero, AppPO-input
@PageObject()
abstract class AppPO {

  AppPO();
  factory AppPO.create(PageLoaderElement context) = $AppPO.create;

  // #enddocregion AppPO-hero, AppPO-input
  @ByTagName('h1')
  PageLoaderElement _title;
  // #enddocregion AppPO-initial

  // #docregion AppPO-hero
  @First(ByCss('div'))
  PageLoaderElement _id; // e.g. 'id: 1'

  @ByTagName('h2')
  PageLoaderElement _heroName;
  // #enddocregion AppPO-hero

  // #docregion AppPO-input
  @ByTagName('input')
  PageLoaderElement _input;
  // #enddocregion AppPO-input

  // #docregion AppPO-initial
  String get title => _title.visibleText;
  // #enddocregion AppPO-initial

  // #docregion AppPO-hero
  int get heroId {
    final idAsString = _id.visibleText.split(':')[1];
    return int.tryParse(idAsString) ?? -1;
  }

  String get heroName => _heroName.visibleText;
  // #enddocregion AppPO-hero

  // #docregion AppPO-input
  Future<void> type(String s) => _input.type(s);
  // #docregion AppPO-initial, AppPO-hero
}
// #enddocregion AppPO, AppPO-initial, AppPO-hero, AppPO-input

void main() {
  // #docregion appPO-setup
  final testBed =
      NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);
  NgTestFixture<AppComponent> fixture;
  AppPO appPO;

  setUp(() async {
    fixture = await testBed.create();
    final context = new HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    appPO = new AppPO.create(context);
  });
  // #enddocregion appPO-setup

  tearDown(disposeAnyRunningTest);

  // #docregion title
  test('title', () async {
    expect(await appPO.title, 'Tour of Heroes');
  });
  // #enddocregion title

  // #docregion hero
  const windstormData = const <String, dynamic>{'id': 1, 'name': 'Windstorm'};

  test('initial hero properties', () async {
    expect(await appPO.heroId, windstormData['id']);
    expect(await appPO.heroName, windstormData['name']);
  });
  // #enddocregion hero

  // #docregion update-name
  const nameSuffix = 'X';

  test('update hero name', () async {
    await appPO.type(nameSuffix);
    expect(await appPO.heroId, windstormData['id']);
    expect(await appPO.heroName, windstormData['name'] + nameSuffix);
  });
  // #enddocregion update-name
}
