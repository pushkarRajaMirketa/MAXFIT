@RestResource(urlMapping='/Events/*')

global class EventsManager {

    @HttpGet
    global static void getEvents() {

        // RestResponse response = new RestResponse();

        List<Event__c> eventsList = [SELECT Name__c, Start__c, Max_Seats__c, Organizer__r.Name, Organizer__r.Email__c FROM Event__c];
        List<Object> eventsListToSend = new List<Object>();

        for (Event__c event : eventsList) {
            Map<String, Object> finalMap = new Map<String, Object>();
            Map<String, Object> eventMap = new Map<String, Object>();
            Map<String, Object> organizerMap = new Map<String, Object>();

            eventMap.put('name', event.Name__c);
            eventMap.put('date_time', event.Start__c);
            eventMap.put('max_attendee', event.Max_Seats__c);

            organizerMap.put('name', event.Organizer__r.Name);
            organizerMap.put('email', event.Organizer__r.Email__c);

            
            finalMap.put('event_organizer', organizerMap);
            finalMap.put('event', eventMap);

            eventsListToSend.add(finalMap);
        }

        // response.setBody()
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(eventsListToSend));
        
        // return eventsList;
    }
    
}