import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/infra/http/http.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  ClientSpy client;
  HttpAdapter sut;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('shared', () {
    test('Should thrown server error if invalid method is providedd', () async {
      final future = sut.request(url: url, method: 'invalid_method');

      expect(future, throwsA(HttpError.serverError));
    });
  });
  group('post', () {
    PostExpectation mockRequest() => when(
        client.post(any, body: anyNamed('body'), headers: anyNamed('headers')));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
      );

      verify(client.post(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: '{"any_key":"any_value"}',
      ));
    });

    test('Should call post without body', () async {
      await sut.request(
        url: url,
        method: 'post',
      );

      verify(client.post(
        any,
        headers: anyNamed('headers'),
      ));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(
        url: url,
        method: 'post',
      );

      expect(response, {"any_key": "any_value"});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(
        url: url,
        method: 'post',
      );

      expect(response, null);
    });

    test('Should return null if post returns 204 with no data', () async {
      mockResponse(204, body: '');

      final response = await sut.request(
        url: url,
        method: 'post',
      );

      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(
        url: url,
        method: 'post',
      );

      expect(response, null);
    });

    test('Should return bad resquest erros if post return 400', () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return bad resquest erros if post return 400', () async {
      mockResponse(400);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return ForbiddenError erros if post return 403', () async {
      mockResponse(403);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return notFoundError erros if post return 404', () async {
      mockResponse(404);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return UnauthorizedError erros if post return 401', () async {
      mockResponse(401);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return serverError erros if post return 500', () async {
      mockResponse(500);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return serverError erros if post throws', () async {
      mockError();

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
