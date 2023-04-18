public class EmailHelper {
    public static void sendEmail(List<Messaging.SingleEmailMessage> mails) {
        Messaging.sendEmail(mails, false);
    }

    public static Messaging.SingleEmailMessage singleEmailSetup(String[] emailAddresses, String subject, String plainTextBody) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = emailAddresses;
        message.subject = subject;
        message.plainTextBody = plainTextBody;
        return message;
    }
}