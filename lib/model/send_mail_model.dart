// class SendGrid {
//   final List<ToModel> personalizations;
//   final Email from;
//   final List<Content> content;
//
//   SendGrid(
//       {required this.personalizations,
//       required this.from,
//       required this.content});
//
//   Map toJson() {
//     return {
//       "personalizations": personalizations.map((toModel) => toModel.toJson()),
//       "from": from,
//       "content": content.map((c) => c.toJson())
//     };
//   }
// }
//
// class ToModel {
//   final List<Email> to;
//   final String subject;
//
//   ToModel({required this.to, required this.subject});
//
//   Map toJson() {
//     return {
//       "to": to.map((email) => email.toJson()),
//       "subject": subject,
//     };
//   }
// }
//
// class Email {
//   final String email;
//
//   Email({required this.email});
//
//   Map toJson() {
//     return {"email": email};
//   }
// }
//
// class Content {
//   final String type;
//   final String value;
//
//   Content({required this.type, required this.value});
//
//   Map toJson() {
//     return {
//       "type": type,
//       "value": value,
//     };
//   }
// }

class SendSimpleModel {
  final String fromEmail;
  final String toEmail;
  final String title;
  final String desc;

  SendSimpleModel(
      {required this.fromEmail,
      required this.toEmail,
      required this.title,
      required this.desc});

  Map toJson() {
    return {
      "personalizations": [
        {
          "to": [
            {"email": toEmail}
          ],
          "subject": title
        }
      ],
      "from": {"email": fromEmail},
      "content": [
        {"type": "text/plain", "value": desc}
      ]
    };
  }
}
