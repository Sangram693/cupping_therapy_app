import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';

class ContactInquiryRemoteDataSource {
  const ContactInquiryRemoteDataSource(this._client);

  final ApiClient _client;

  Future<void> submit(Map<String, dynamic> values) async {
    await _client.post<Map<String, dynamic>>(
      ApiEndpoints.contactInquiries,
      data: values,
    );
  }
}
