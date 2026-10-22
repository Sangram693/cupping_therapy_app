import '../datasources/contact_inquiry_remote_data_source.dart';

class ContactInquiryRepositoryImpl {
  const ContactInquiryRepositoryImpl(this._remote);

  final ContactInquiryRemoteDataSource _remote;

  Future<void> submit({
    required String name,
    required String phone,
    String? email,
    String? subject,
    required String message,
  }) => _remote.submit({
    'name': name,
    'phone': phone,
    if (email != null && email.isNotEmpty) 'email': email,
    if (subject != null && subject.isNotEmpty) 'subject': subject,
    'message': message,
  });
}
