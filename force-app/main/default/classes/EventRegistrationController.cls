public class EventRegistrationController {

    public Event_Organizer__c eventOrganizer {get; set;}

    public Location__c eventLocation {get; set;}

    public Event__c event {get; set;}

    public EventRegistrationController() {
        eventOrganizer = new Event_Organizer__c();
        eventLocation = new Location__c();
        event = new Event__c();
    }


    public void save() {

        Savepoint sp = Database.setSavepoint();
        Try {
            insert eventOrganizer;
            insert eventLocation;
            
            event.Organizer__c = eventOrganizer.Id;

            if (event.Event_Type__c != 'Virtual') {
                event.Location__c = eventLocation.Id;
            }

            insert event;
        } catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            ErrorLog.insertErrorLog('Event Registration Controller', e.getMessage());
        } finally {
            eventOrganizer = new Event_Organizer__c();
            eventLocation = new Location__c();
            event = new Event__c();
        }
    }
}