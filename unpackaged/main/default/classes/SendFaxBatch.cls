global without sharing class SendFaxBatch implements Schedulable, Database.Batchable<sObject>,Database.AllowsCallouts{
    private String strFaxType;
    
    //Constructor 
    public SendFaxBatch(String faxType) {
        strFaxType = faxType; 
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String caseQueryString, batchCaseQueryString; 

        if (strFaxType == 'Final Notice') {
            Id finalNoticeRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reimbursement').getRecordTypeId();
            caseQueryString = 'SELECT Id, Status, Claim_Information__c FROM Case WHERE Status != \'Transfer to Health Plan\' AND Status != \'Outreach Completed\' AND RecordTypeId = :finalNoticeRecordTypeId';

            try {
                List<Case> caseList = Database.query(caseQueryString);
                List<String> caseIds = getCaseIds(caseList); 

                batchCaseQueryString = 'SELECT Id FROM Case WHERE Id = :caseIds';

                if (caseIds == null || caseIds.size() == 0) {
                    System.debug('@No cases found with matching criteria.');
                    //set the LIMIT to 0 to prevent execute() method
                    batchCaseQueryString = 'SELECT Id FROM Case LIMIT 0';
                }
            } 
            catch(Exception ex) {
                System.debug('@Exception Encountered: ' + ex.getMessage()); 
            }
        } // end if 'Final Notice'
        //TODO: else if statements to handle other fax types
        return Database.getQueryLocator(batchCaseQueryString);
    }

    private List<String> getCaseIds(List<Case> caseList) {
        List<String> caseIds = new List<String>(); 
        List<String> claimIds = new List<String>(); 
        List<String> validClaims = new List<String>(); 

        for (Case c : caseList) { 
            claimIds.add(c.Claim_Information__c);
        }

        validClaims = getValidClaims(claimIds);

        for (Case c : [SELECT Id FROM Case WHERE Claim_Information__c = :validClaims]) {
            caseIds.add(c.Id);
        }

        return caseIds; 
    }

    private List<String> getValidClaims(List<String> claimIds) {
        List<String> validClaims = new List<String>(); 

        for (Claim_Information__c c : [SELECT Id, EOP_Date__c FROM Claim_Information__c WHERE Id = :claimIds]) {
            if (c.EOP_Date__c == Date.today().addDays(-75)) {
                validClaims.add(c.Id); 
            }
        }

        return validClaims;
    }

    global void execute(Database.BatchableContext BC, List<Case> lstCases) {
        FaxService.processFaxOnCase(lstCases, strFaxType);
    } 

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new SendFaxBatch('Final Notice')); 
    }

    global void finish(Database.BatchableContext BC){
    }//end finish
}