public class ErrorLog {
    public static void insertErrorLog(String processName, String logDetails) {
        Error_Log__c errorLogObj = new Error_Log__c();
        errorLogObj.Log_Details__c = logDetails;
        errorLogObj.Process_Name__c = processName;
        errorLogObj.Log_Date_Time__c = DateTime.now();
        // System.debug(logDetails + ' ' + processName + ' ' + DateTime.now());
        insert errorLogObj;
    }
}