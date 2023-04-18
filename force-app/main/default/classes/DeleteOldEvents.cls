public class DeleteOldEvents implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('Select Id from Event__c Where End__c <= LAST_N_MONTHS:2 AND Live__c = true');
    }

    public void execute(Database.BatchableContext bc, List<Event__c> eventScope) {
       delete eventScope;
    }

    public void finish( Database.BatchableContext bc ) {
        String[] toAddresses = new String[] {'pushkar.raja@mirketa.com'};
        String subject = 'Execution of the batch has been processed';
        String plainTextBody = 'Batch for deleting 2 months old has been processed';

        

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        mails.add(EmailHelper.singleEmailSetup(toAddresses, subject, plainTextBody));
        EmailHelper.sendEmail(mails);
    }
}