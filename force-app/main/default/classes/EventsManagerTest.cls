@isTest
private class EventsManagerTest {
    @TestSetup
    static void makeData(){


        Event_Organizer__c organizer = new Event_Organizer__c (
            Name = 'Harshit Kumar',
            Email__c = 'harshit.kumar.mirketa@gmail.com'
        );

        insert organizer;

        Event__c event = new Event__c(
            Name__c = 'test1',
            Max_Seats__c = 100,
            Organizer__c = organizer.Id,
            Live__c = true,
            Start__c = Datetime.newInstance(2023, 4, 7, 12, 00, 00),
            End__c = Datetime.newInstance(2023, 4, 9, 12, 00, 00)
        );

        insert event;
    }

    @isTest
    static void checkData() {
        // RestRequest request = new RestRequest();
        // request.requestUri = 'https://mirketa76-dev-ed.develop.my.salesforce.com/services/apexrest/Events/';
        // request.httpMethod = 'GET';
        // RestContext.request = request;
        

        Event__c events = [SELECT Id, Name__c, Max_Seats__c, Start__c, Organizer__r.Name, Organizer__r.Email__c FROM Event__c];
        List<Event__c> responseList = EventsManager.getEvents();
        Event__c response = responseList.get(0);

        System.assert(responseList != null);
        System.assertEquals(events.Id, response.Id);
        System.assertEquals(events.Name__c, response.Name__c);
        System.assertEquals(events.Max_Seats__c, response.Max_Seats__c);
        System.assertEquals(events.Start__c, response.Start__c);
        System.assertEquals(events.Organizer__r.Name, response.Organizer__r.Name);
        System.assertEquals(events.Organizer__r.Email__c, response.Organizer__r.Email__c);
        
    }
}