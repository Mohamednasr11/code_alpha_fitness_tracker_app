import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ApiServiceFetchDataTest {
  Future<dynamic> fetchData() async => 'Real Data';
}

class MockData extends Mock implements ApiServiceFetchDataTest {}

void main() {
  test('Fetch Mock Data', () async {
    final data = MockData();
    when(() => data.fetchData()).thenAnswer((_) async => 'Fake Data');
    final result=await data.fetchData();
    expect(result, 'Fake Data');
    verify(() => data.fetchData()).called(1);
  });
}
