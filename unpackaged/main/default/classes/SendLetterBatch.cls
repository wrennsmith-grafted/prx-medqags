global without sharing class SendLetterBatch implements Schedulable, Database.Batchable<sObject>,Database.AllowsCallouts {
    private String strCommunicationType; 
    private String strLetterType; 
    private date dtSendFromDate; 
    private date dtSendToDate; 
    private String sSendFromDate; 
    private String sSendToDate; 
    private DateTime dtSendFromDateTime; 
    private DateTime dtSendToDateTime; 
    
    //Constructor
    global SendLetterBatch(String letterType, String sendDate) {
        Map<String,String> mapLetterToCommunicationType = new Map<String,String>(); 

        mapLetterToCommunicationType.put('Send Final Notice', 'Final Notice'); 
        mapLetterToCommunicationType.put('Send Welcome', 'Welcome Letter'); 

        strCommunicationType = mapLetterToCommunicationType.get(letterType); 

        strLetterType = letterType; 

        if (sendDate != null && sendDate != '') {
            Date LetterDate = date.parse(sendDate);
            
            dtSendFromDate = LetterDate.addDays(-1);
            dtSendToDate = LetterDate.addDays(1);
            sSendFromDate = dtSendFromDate.year() + '-' + dtSendFromDate.month() + '-' + dtSendFromDate.day();
            sSendToDate = dtSendToDate.year() + '-' + dtSendToDate.month() + '-' + dtSendToDate.day();
            dtSendFromDateTime = datetime.newinstanceGmt(dtSendFromDate.year(), dtSendFromDate.month(), dtSendFromDate.day(), 24, 59, 59);
            dtSendToDateTime = datetime.newinstanceGmt(dtSendToDate.year(), dtSendToDate.month(), dtSendToDate.day(), 0, 0, 0);
        }// end if
    } //end SendLetterBatch

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String contactQueryString, caseQueryString; 
        Set<Id> contactIds = new Set<Id>(); 

        if (strLetterType == 'Send Final Notice') {
            Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
            caseQueryString = 'SELECT Id, Latest_PRx_Outreach_Attempt__c, ContactID, Contact_Drug__c FROM Case WHERE Status = \'Transfer to Health Plan\' AND RecordTypeId = :devRecordTypeId';

            if(dtSendFromDate != null && dtSendToDate != null) {
                caseQueryString += ' AND Latest_PRx_Outreach_Attempt__c = ' + dtSendFromDateTime.format('yyyy-MM-dd');
            }//end if (manual batch - specified date) 
            else {
                caseQueryString += ' AND (Latest_PRx_Outreach_Attempt__c = YESTERDAY OR Latest_PRx_Outreach_Attempt__c = N_DAYS_AGO:7)';
            }//end else (automated batch - YESTERDAY)
            
            try {
                System.debug('@Case Query: ' + caseQueryString);
                List<Case> caseList = Database.query(caseQueryString);
                
                contactIds = getContactsFinalNotice(caseList);                

                //Build Contact query by getting the ContactIDs from the cases returned in the caseQuery
                contactQueryString = 'SELECT Id FROM CONTACT WHERE Id IN :contactIds';   
                System.debug('@Contact IDs Size: ' + contactIds.size());
                if (contactIds == null || contactIds.size() == 0) {
                    System.debug('@No cases found with matching criteria.');
                    //set the LIMIT to 0 to prevent execute() method
                    contactQueryString = 'SELECT Id FROM CONTACT LIMIT 0';
                }
                System.debug('@Contact IDs Final Notice: ' + contactIds);
            } // end try 
            catch(Exception ex) {
                System.debug('@Exception Encountered: ' + ex.getMessage()); 
            }// end catch 
        }//end if (final notice) 
        else {
            Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
            caseQueryString = 'SELECT Id, ContactID, Latest_PRx_Outreach_Attempt__c FROM Case WHERE CreatedDate = YESTERDAY AND  RecordTypeId = :devRecordTypeId';

            try {
                System.debug('@Case Query: ' + caseQueryString);
                List<Case> caseList = Database.query(caseQueryString);

                contactIds = getContactsWelcomeLetter(caseList); 

                //Build Contact query by getting the ContactIDs from the cases returned in the caseQuery
                contactQueryString = 'SELECT Id FROM CONTACT WHERE Id = :contactIds';                

                if (contactIds == null || contactIds.size() == 0) {
                    System.debug('@No cases found with matching criteria.');
                    //set the LIMIT to 0 to prevent execute() method
                    contactQueryString = 'SELECT Id FROM CONTACT LIMIT 0';
                }
            }// end try
            catch(Exception ex) {
                System.debug('@Exception Encountered: ' + ex.getMessage()); 
            }// end catch 

        }//end else (welcome letter )
        
        System.debug('@Contact Query: ' + contactQueryString); 
        System.debug('@Contact Query Locator: ' + Database.getQueryLocator(contactQueryString)); 
        return Database.getQueryLocator(contactQueryString); 
    }//end start

    private Set<Id> getContactsWelcomeLetter(List<Case> caseList) {
        Set<Id> contactIds = new Set<Id>(); 

        for (Case c : caseList) { 
            contactIds.add(c.ContactID);
        }
        return contactIds; 
    }

    private Set<Id> getContactsFinalNotice(List<Case> caseList) {
        List<String> cdIdLists = new List<String>();
        Set<Id> contactIds = new Set<Id>();
        List<Case> caseUpdateList = new List<Case>(); 
        
        for (Case c : caseList) {
            if (c.Latest_PRx_Outreach_Attempt__c != Date.today().addDays(-1)) {
                caseUpdateList.add(c); 
                cdIdLists.add(string.valueOf(c.Contact_Drug__c));
                continue; 
            } 
            System.debug('@Contact ID: ' + string.valueOf(c.ContactID));
            contactIds.add(c.ContactID);
        }
        // update all contact drugs that need "not on file" 
        for (Contact_Drug__c cd : [SELECT Id FROM Contact_Drug__c WHERE Id = :cdIdLists]) {
            cd.Copay_Enrollment_Status__c = 'Not on File';  
            update cd; 
        }
        // update all cases that need "outreach complete" 
         caseForDrug(caseUpdateList);
        System.debug('@Contact ID Size in method: ' + contactIds.size());
        return contactIds;
    }

    private void caseForDrug(List<Case> caseList) {
        // Case resultCase = new Case(); 
        for (Case c : caseList) {
            c.Status = 'Outreach Completed';
            c.HCP_Enrollment_Outreach__c = 'Outreach Complete';
            update c;
        }
    }    

    global void execute(Database.BatchableContext BC, List<Contact> lstContacts) {
        System.debug('@List of Contacts: ' + lstContacts); 
        LetterService.processLetterForContact(lstContacts, strLetterType);
    }//end execute 

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new SendLetterBatch('Send Final Notice', null)); 
    }

    global void finish(Database.BatchableContext BC){
    }//end finish
}