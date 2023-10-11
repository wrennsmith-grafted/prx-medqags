public with sharing class SendFaxController {
    @AuraEnabled
    public static String sendFaxProcess(String caseId) {
        return FaxService.processFaxOnCase(caseId);
    }
}