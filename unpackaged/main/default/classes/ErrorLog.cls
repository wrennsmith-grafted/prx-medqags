public class ErrorLog {
    public static List<Error_Log__c> logList = new List<Error_Log__c>();

    public static void log(String method, String endpoint, String requestBody, String responseBody, String errorCode, String errorMessage,
    Id dailyClaimRecordId) {
        ErrorLog.log(method, endpoint, requestBody, responseBody, errorCode, errorMessage, dailyClaimRecordId,null, null, null);
    }
    
    public static void log(String method, String endpoint, String requestBody, String responseBody, String errorCode, String errorMessage,
                            Id dailyClaimRecordId, Id historicalClaimId, Id priorAuthId, Id historicalPriorAuthId){

        Error_Log__c integrationLog = new Error_Log__c();
        if(dailyClaimRecordId != null){
            integrationLog.Daily_Claim__c = dailyClaimRecordId;
        }
        if(historicalClaimId != null){
            integrationLog.Historical_Claim__c = historicalClaimId;
        }
        if(priorAuthId != null){
            integrationLog.Prior_Auth__c = priorAuthId;
        }
        if(historicalPriorAuthId != null){
            integrationLog.Historical_Prior_Auth__c = historicalPriorAuthId;
        }

        integrationLog.Method__c = method;
        integrationLog.Endpoint__c = endpoint;
        if(String.isEmpty(requestBody) != true){
            integrationLog.API_Request__c = requestBody;
        }
        
        if(String.isEmpty(responseBody) != true){
            integrationLog.API_Response__c = responseBody;
        }
        
        integrationLog.Error_Code__c = errorCode;
        integrationLog.Error_Message__c = errorMessage;
        logList.add(integrationLog);

        String emailBody = method + '<p>' + errorMessage;
        ErrorLog.sendErrorLogEmail('Error processing ' + method, emailBody);
    }
    
    public static void commitLogs(){
        if(logList.size() > 0){
            upsert logList;
        }
    }

    // Simple notification of any errors received via email
    public static void sendErrorLogEmail(String emailSubject, String emailBody) {

            // Email address from user
            Map<Id, String> usersEmail =
                    new UsersSelector().getUsersEmail(
                            new Set<Id> { UserInfo.getUserId() });

            // Send email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { 'salesforce_development_team@prudentrx.com' });
            mail.setReplyTo('salesforce_development_team@prudentrx.com');
            mail.setSenderDisplayName('salesforce_development_team');
            mail.setSubject(emailSubject);
            mail.setHtmlBody(emailBody);
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
}