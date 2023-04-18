@RestResource(urlMapping='/CreateSpeaker/*')

global class CreateSpeakerService {


    @HttpPost
    global static String createSpeaker(String name, String email, String phone) {
        Speaker__c speaker = new Speaker__c(
           Name = name,
           Email__c = email,
           Phone__c = phone
        );

        Try {
            RestResponse res = RestContext.response;
            insert speaker;
            res.statusCode = 200;
            return 'Successful';
        } catch (Exception e) {
            RestResponse res = RestContext.response;
            res.statusCode = 400;
            return 'Insertion Failed';
        }
    }   
    
}