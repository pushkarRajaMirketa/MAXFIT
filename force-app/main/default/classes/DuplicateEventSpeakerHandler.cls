public class DuplicateEventSpeakerHandler {
    public static void handleDuplicateSpeaker(List<Event_Speaker__c> newEventSpeakers) {
        Set<Id> newSpeakerList = new Set<Id>();
        Set<Id> newEventList = new Set<Id>();

        for (Event_Speaker__c eventSpeaker : newEventSpeakers) {
            newSpeakerList.add(eventSpeaker.Speaker__c);
            newEventList.add(eventSpeaker.Event__c);
        }

        // Fetching All the Existing Events
        List<Event__c> OldEventsList = [SELECT Id, Name__c, Start__c, End__c FROM Event__c WHERE End__c > Today];

        //Map -> event id, event object
        Map<Id, Event__c> oldEventsMap = new  Map<Id, Event__c>();

        for (Event__c oldEvent : OldEventsList) {
            oldEventsMap.put(oldEvent.Id, oldEvent);
        }


        /* INIT Setup : */
        //key -> speaker Id, value -> list of events
        Map<Id, List<Event__c>> speakerToEventsMap = new Map<Id, List<Event__c>>();

        // soql -> to get event id, speaker id from event speaker order by event start date (ascending)
        for (Event_Speaker__c eventSpeaker : [SELECT Id, Event__c, Speaker__c, Event__r.Start__c FROM Event_Speaker__c WHERE Speaker__c IN: newSpeakerList ORDER BY Event__r.Start__c]) {
            if (speakerToEventsMap.containsKey(eventSpeaker.Speaker__c)) {
                speakerToEventsMap.get(eventSpeaker.Speaker__c).add(oldEventsMap.get(eventSpeaker.Event__c));
            } else {
                speakerToEventsMap.put(eventSpeaker.Speaker__c, new List<Event__c>{oldEventsMap.get(eventSpeaker.Event__c)});
            }
        }

        
        for (Event_Speaker__c eventSpeaker : newEventSpeakers) {
            if (speakerToEventsMap.containsKey(eventSpeaker.Speaker__c)) {
                //checking for conflict :
                Event__c eventNow = oldEventsMap.get(eventSpeaker.Event__c);
                List<Event__c> existingEvents = speakerToEventsMap.get(eventSpeaker.Speaker__c);
                integer n = existingEvents.size();

                // Case 1 : Event should go at Start
                if (eventNow.End__c < existingEvents.get(0).Start__c) {
                    existingEvents.add(0, eventNow);
                    speakerToEventsMap.get(eventSpeaker.Speaker__c).add(eventNow);
                    continue;
                }
                
                // Case 2 : Event should go at End
                if (eventNow.Start__c > existingEvents.get(n - 1).End__c) {
                    existingEvents.add(eventNow);
                    speakerToEventsMap.get(eventSpeaker.Speaker__c).add(eventNow);
                    continue;
                }

                // Case 3 : Event should go in between

                boolean mark = false;

                for (integer i = 1; i < n; i++) {
                    if (eventNow.Start__c > existingEvents.get(i - 1).End__c && eventNow.End__c < existingEvents.get(i).Start__c) {
                        existingEvents.add(i, eventNow);
                        mark = true;
                    }

                    if (mark) break;
                }
                
                // Case 4 : Invalid Event
                if (!mark) {
                    eventSpeaker.addError('Speaker is already booked for this time slot.');
                }

                speakerToEventsMap.get(eventSpeaker.Speaker__c).add(eventNow);
            }            
        }
    }
}


    // Set<Id> speakerIds = new Set<Id>();

    // for (Event_Speaker__c eventSpeaker : Trigger.new) {
    //     speakerIds.add(eventSpeaker.Speaker__c);
    // }

    // Map<Id, Event_Speaker__c> existingEvents = new Map<Id, Event_Speaker__c>();
    

    // for (Event_Speaker__c eventSpeaker : [SELECT Id, Event__c, Speaker__c, Event__r.Name__c FROM Event_Speaker__c WHERE Speaker__c IN :speakerIds]) {
    //     existingEvents.put(eventSpeaker.Speaker__c, eventSpeaker);
    // }


    // for (Event_Speaker__c eventSpeaker : Trigger.new) {
    //     if (existingEvents.containsKey(eventSpeaker.Speaker__c)) {
    //         Event_Speaker__c existingEvent = existingEvents.get(eventSpeaker.Speaker__c);
    //         eventSpeaker.addError('Speaker is already associated with event ' + existingEvent.Event__r.Name__c);

    //     } else {
    //         speakerIds.add(eventSpeaker.Speaker__c);
    //         existingEvents.put(eventSpeaker.Speaker__c, eventSpeaker);
    //     }
    // }