trigger DuplicateEventSpeakerTrigger on Event_Speaker__c (before insert) {
    Try {
        DuplicateEventSpeakerHandler.handleDuplicateSpeaker(Trigger.new);
    } catch (Exception e) {
        ErrorLog.insertErrorLog('Duplicate Event Speaker Trigger', e.getMessage());
        // System.debug('The following exception has occurred: ' + errorMessage);
    }
}