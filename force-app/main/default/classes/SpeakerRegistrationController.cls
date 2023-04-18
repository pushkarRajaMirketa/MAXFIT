public class SpeakerRegistrationController {

    public Speaker__c speaker {get; set;}

    public Event_Speaker__c eventSpeaker {get; set;}

    public SpeakerRegistrationController() {
        speaker = new Speaker__c();
        eventSpeaker = new Event_Speaker__c();

        Id currentRecordId = ApexPages.currentPage().getParameters().get('id');
        if (currentRecordId != null) {
            eventSpeaker.Event__c = currentRecordId;
        }
    }

    public void save() {
        Savepoint sp = Database.setSavepoint();
        Try {
            insert speaker;
            eventSpeaker.Speaker__c = speaker.Id;
            insert eventSpeaker;
        } catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            ErrorLog.insertErrorLog('Speaker Registration Controller', e.getMessage());
        } finally {
            speaker = new Speaker__c();
            eventSpeaker = new Event_Speaker__c();
        }
    }
}