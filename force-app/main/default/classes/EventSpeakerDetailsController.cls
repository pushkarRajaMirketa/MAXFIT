public class EventSpeakerDetailsController {
    public Event__c event {get; set;}
    public List<Event_Speaker__c> eventSpeakerList {get; set;}

    public EventSpeakerDetailsController() {
        Id currentRecordId = ApexPages.currentPage().getParameters().get('id');
        this.event = [SELECT Id, Name__c, Organizer__r.Name, Location__r.Name, Start__c FROM Event__c WHERE Id =: currentRecordId];
        this.eventSpeakerList = [SELECT Id, Event__c, Speaker__c, Speaker__r.Name, Speaker__r.Profile_URL__c, Speaker__r.About_Me__c FROM Event_Speaker__c WHERE Event__c =: currentRecordId];
    }
}