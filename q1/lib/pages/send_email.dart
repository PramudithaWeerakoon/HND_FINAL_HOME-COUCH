import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmailOTP(String email, String otp) async {
  String username = 'playlog1234@gmail.com';
  String password = 'sbyr nhga ejdl nbxv';
  
  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'Couch@Home')
    ..recipients.add(email)
    ..subject = 'Your Secure OTP for Password Reset - Couch@Home'
    ..text = '''
Hello,

We received a request to reset the password for your Couch@Home account. 
Here is your One-Time Password (OTP) to proceed with the reset:

$otp

Please enter this OTP in the app to verify your request. If you did not request a password reset, please ignore this email.

Thank you,  
Couch@Home Team
''';


  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: $sendReport');
  } catch (e) {
    print('Error sending email: $e');
  }
}
