@isTest
public class DuplicateSpeakerTest {

    @TestSetup
    static void makeData() {

        List<Event__c> eventsToInsert = new List<Event__c>(); 

        Event__c testEvent = new Event__c(
            Name__c = 'test1',
            Live__c = true,
            Start__c = Datetime.newInstance(2023, 4, 1, 12, 00, 00),
            End__c = Datetime.newInstance(2023, 4, 2, 12, 00, 00)
        );
        eventsToInsert.add(testEvent);

        Event__c testEvent1 = new Event__c(
            Name__c = 'test2',
            Live__c = true,
            Start__c = Datetime.newInstance(2023, 4, 2, 14, 00, 00),
            End__c = Datetime.newInstance(2023, 4, 3, 18, 00, 00)
        );
        eventsToInsert.add(testEvent1);

        Event__c testEvent2 = new Event__c(
            Name__c = 'test3',
            Live__c = true,
            Start__c = Datetime.newInstance(2023, 3, 28, 12, 00, 00),
            End__c = Datetime.newInstance(2023, 4, 1, 14, 00, 00)
        );     
        eventsToInsert.add(testEvent2);

        insert eventsToInsert;

        List<Speaker__c> speakersToInsert = new List<Speaker__c>();

        Speaker__c testSpeaker = new Speaker__c(
            Name = 'test speaker'
        );
        speakersToInsert.add(testSpeaker);

        // Speaker__c testSpeaker2 = new Speaker__c(
        //     Name = 'test speaker 2'
        // );
        // speakersToInsert.add(testSpeaker2);

        insert speakersToInsert;

        Event_Speaker__c testEventSpeaker = new Event_Speaker__c(
            Event__c = testEvent.Id,
            Speaker__c = testSpeaker.Id
        );
        insert testEventSpeaker;
    }

    @isTest
    static void myTest() {
        
        // Test.startTest();

        Event_Speaker__c testEventSpeaker = new Event_Speaker__c(
            Event__c = [SELECT Id FROM Event__c WHERE Name__c = 'test2' LIMIT 1].Id,
            Speaker__c = [SELECT Id FROM Speaker__c WHERE Name = 'test speaker' LIMIT 1].Id
        );

        Event_Speaker__c testEventSpeaker2 = new Event_Speaker__c(
            Event__c = [SELECT Id FROM Event__c WHERE Name__c = 'test3'].Id,
            Speaker__c = [SELECT Id FROM Speaker__c WHERE Name = 'test speaker'].Id
        );

        
        try {
            insert testEventSpeaker;
        } catch (Exception e) {
            system.debug(e.getMessage());
        }

        try {
            insert testEventSpeaker2;
            // Assert.fail('DmlException expected');
        } catch (Exception e) {
            system.debug(e.getMessage());
        }

        List<Event_Speaker__c> es = [SELECT Event__c, Speaker__c FROM Event_Speaker__c];

        System.assertEquals(true, es.contains(testEventSpeaker));
        System.assertEquals(false, es.contains(testEventSpeaker2));
        // System.assertEquals('Speaker is already booked for this time slot.', message2);
        
        // Test.stopTest();
    }

}