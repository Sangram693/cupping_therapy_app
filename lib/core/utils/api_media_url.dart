import '../constants/app_constants.dart';

class ApiMediaUrl {
  ApiMediaUrl._();

  static String? resolve(Object? value) {
    if (value is! String || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null) return null;
    if (!uri.hasAuthority) {
      return Uri.parse(AppConstants.apiBaseUrl).resolveUri(uri).toString();
    }

    final configured = Uri.tryParse(AppConstants.apiBaseUrl);
    if (configured == null ||
        !const {'localhost', '127.0.0.1', '::1'}.contains(uri.host) ||
        const {'localhost', '127.0.0.1', '::1'}.contains(configured.host)) {
      return uri.toString();
    }

    return Uri(
      scheme: configured.scheme,
      host: configured.host,
      port: configured.hasPort ? configured.port : null,
      path: uri.path,
      query: uri.hasQuery ? uri.query : null,
      fragment: uri.hasFragment ? uri.fragment : null,
    ).toString();
  }
}
