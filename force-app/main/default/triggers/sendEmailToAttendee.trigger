trigger sendEmailToAttendee on Event_Attendee__c (after insert) {
    try {
        AttendeeConfirmationHelper.emailHandler(Trigger.new);
    } catch (Exception e) {
        ErrorLog.insertErrorLog('Send Email to Attendee', e.getMessage());
        // System.debug('The following exception has occurred: ' + errorMessage);
    }
}