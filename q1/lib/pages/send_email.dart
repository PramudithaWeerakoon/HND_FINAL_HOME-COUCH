import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmailOTP(String email, String otp) async {
  String username = 'playlog1234@gmail.com';
  String password = 'sbyr nhga ejdl nbxv';
  
  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'Couch@Home')
    ..recipients.add(email)
    ..subject = 'Password Reset OTP'
    ..text = 'Your OTP for password reset in Couch@Home is: $otp';

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } catch (e) {
    print('Error sending email: $e');
  }
}
