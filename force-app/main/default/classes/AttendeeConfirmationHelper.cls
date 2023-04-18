public class AttendeeConfirmationHelper {
    public static void emailHandler(List<Event_Attendee__c> currentEventAttendees) {

        // Master Mail List -> storing all the mails in a list
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        // creating a set of attendee and event from event attendee using trigger.new
        Set<Id> currentAttendeeSet = new Set<Id>();
        Set<Id> currentEventSet = new Set<Id>();

        // adding attendee and event id to the set -> since we are using a set, we will have unique id only 
        for (Event_Attendee__c currentEA : currentEventAttendees) {
            currentAttendeeSet.add(currentEA.Attendee__c);
            currentEventSet.add(currentEA.Event__c);
        }

        // map of id and event obj -> fetching id, name, start and location.name and organizer.name from event object (if the id of event is present in the event set)
        Map<Id, Event__c> eventMap = new Map<Id, Event__c>([SELECT Id, Name__c, Start__c, Location__r.Name, Organizer__r.Name FROM Event__c WHERE Id IN: currentEventSet]);

        // map of id and attendee obj -> fetching id, name, email from attendee object (if the id of attendee is present in attendee set)
        Map<Id, Attendee__c> attendeeMap = new Map<Id, Attendee__c>([SELECT Id, Name, Email__c FROM Attendee__c WHERE Id IN: currentAttendeeSet]);

        // iterating on event attendee retrieved from trigger.new
        for (Event_Attendee__c currentEA : currentEventAttendees) {

            // storing the attendee object by matching the id in attendee map
            Attendee__c attendee = attendeeMap.get(currentEA.Attendee__c);
            // storing the event object by matching the id in event map
            Event__c event = eventMap.get(currentEA.Event__c);

            //Email subject
            String subject = 'Pass for the ' + event.Name__c;
            // Email Body
            String plainTextBody = 'Dear ' + attendee.Name + ', ';
            plainTextBody += 'Thank you for registering for '+ event.Name__c +' which will be Organized on ' + event.Start__c +' & will be held in ' + event.Location__r.Name + '. ';
            plainTextBody += 'We are excited to have you, see you at the event. ';
            plainTextBody += 'Thanks, '+ event.Organizer__r.Name;
        
            // adding a single mail to master list -> using EmailHelper class that I created to setup a single mail
            mails.add(EmailHelper.singleEmailSetup(new String[]{attendee.Email__c}, subject, plainTextBody));
            // Sending the mails to emails in master email list using EmailHelper class
            EmailHelper.sendEmail(mails);
        }
    }
}