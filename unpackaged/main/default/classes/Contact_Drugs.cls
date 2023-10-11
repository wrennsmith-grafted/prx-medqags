/**
 * @description       :
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-08-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-06-2021   Ricardy Banks					   Initial Version
 * 1.1   08-29-2022   Ricardy Banks                     MBP-711 Only Allow Integration User to Link Downstream Objects to the Source Object
 *
 **/

public inherited sharing class Contact_Drugs extends fflib_SObjectDomain
        implements IContact_Drugs
{
    private static Integer maxHCPCSCodeSize = 5;
    //This sets up the super class (fflib_SObjectDomain) to have the records variable filled out
    public Contact_Drugs(List<Contact_Drug__c> contact_DrugRecords){
        super(contact_DrugRecords);
    }

    public List<Contact_Drug__c> getContact_Drugs()
    {
        return (List<Contact_Drug__c>) getRecords();
    }

    //This helps allow for the fflib_SObjectDomain class to run its triggerHandler method
    //using the correct Domain class. This must be implemented in all domain classes.
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<SObject> sObjectList){
            return new Contact_Drugs(sObjectList);
        }
    }
/*
	public class Constructor implements fflib_IDomainConstructor{
		public fflib_SObjects construct(List<Object> objectList){
			return new Contact_Drugs((List<SObject>) objectList);
		}
	}
*/
    /*
    Summary

The second step in processing the Daily claims is to create or update ContactDrugs.
Requirements
ContactDrug processing logic:
    Look at existing Contact and determine if a ContactDrug exists based on:
        HCPCS Code
    If ContactDrug does not exist for the Contact, based on logic above:
        Pre go-live
            Then create ContactDrug, Claim, and Enrollment Case.
        Post go-live
            Then create ContactDrug, Claim, Enrollment Case, and Reimbursement Case.
    If ContactDrug does exist for the Contact, based on logic above:
        Then then check Claim processing logic and create a new Claim, if needed.

    Acceptance Criteria
        If ContactDrug exists for Daily claim record then update ContactDrug else create ContactDrug.
     */
    public List<Contact_Drug__c> process(List<Daily_Claim__c> dailyClaimsList, Map<Id, Contact> existingContactsByDailyClaimId, fflib_ISObjectUnitOfWork uow)
    {
        System.debug('In Contact_Drugs:process - Start processing Contact_Drugs for Daily Claims');

        List<Contact> contactList = new List<Contact>();

        // Create Contacts from the given Daily Claims
        List<SObject> newContact_DrugsList = new List<SObject>();
        List<Contact_Drug__c> existingContact_Drugs = new List<Contact_Drug__c>();
        List<Contact_Drug__c> allContact_Drugs = new List<Contact_Drug__c>();
        Set<String> J_Code_IdSet = new Set<String>();
        Set<String> NDCSet = new Set<String>{''};
        Set<Id> existingContactIdSet = new Set<Id>();
        Contact_Drug__c existingContact_Drug;
        List<Claim_Information__c> claimList = new List<Claim_Information__c>();
        List<Case> caseList = new List<Case>();
        Map<Id, Contact_Drug__c> contact_DrugByContactId = new  Map<Id, Contact_Drug__c>();
        Map<String, Drug__C> drugByHCPCS = new Map<String, Drug__c>();
        Map<String, Drug__C> drugByNDC = new Map<String, Drug__c>();
        Map<String, Id> drugIdByNDC = new Map<String, Id>();
        Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
        Drug__c relatedDrug;
        Contact existingContact;
        String HCPCSCodeTrunc;

        /*
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        //List<Contact> existingContacts = getExistingDailyClaimContacts(dailyClaimsList);
        Map<Id, Contact> existingContactsByDailyClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimsList);
        */
        System.debug('In Contact_Drugs:process: existingContactsByDailyClaimId Count: ' + existingContactsByDailyClaimId.size());
        System.debug('In Contact_Drugs:process: existingContactsByDailyClaimId = ' + existingContactsByDailyClaimId);

        //Get all Daily_Claim J_Codes
        //Get all Daily_Claim existing Contacts
        //Get all Daily_Claim existing Contact Ids
        for(Daily_Claim__c dailyClaim : dailyClaimsList) {
            HCPCSCodeTrunc = dailyClaim.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            J_Code_IdSet.add(HCPCSCodeTrunc);
            existingContact = existingContactsByDailyClaimId.get(dailyClaim.Id);
            if(existingContact != null) {
                existingContactIdSet.add(existingContact.Id);
            }
            System.debug('dailyClaim.Id = ' + dailyClaim.Id);
            System.debug('In Contact_Drugs:process: existingContact = ' + existingContact);
        }

        DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
        List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(J_Code_IdSet);

        for(Drug__c drugRecord : drugList) {
            HCPCSCodeTrunc = drugRecord.J_Code__c.substring(0, maxHCPCSCodeSize);
            drugByHCPCS.put(HCPCSCodeTrunc, drugRecord);
            drugById.put(drugRecord.Id, drugRecord);
            System.debug('drugRecord.J_Code__c = ' + HCPCSCodeTrunc);
        }

        NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
        List<NDC__c> ndcList =  ndcsSelector.selectByDrugId(drugById.keySet());

        for(NDC__c ndcRecord : ndcList) {
            HCPCSCodeTrunc = ndcRecord.Drug__r.J_Code__c.substring(0, maxHCPCSCodeSize);
            System.debug('ndcRecord.Drug__r.J_Code__c = ' + HCPCSCodeTrunc);
            System.debug('ndcRecord.Name = ' + ndcRecord.Name);
            drugIdByNDC.put(ndcRecord.Name, ndcRecord.Drug__c);
        }

        //NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
        //List<NDC__c> ndcList = ndcsSelector.selectByDrugId(drugById.keySet());

        //If drug Coding Level is HCPCS than we only use the HCPCS to identify the drug
        //If drug Coding Level is HCPCS + NDC we Need include the NDC as part of the key to identify the Drug
        Drug__c drugRecord;
        for(Daily_Claim__c dailyClaim : dailyClaimsList) {
            drugRecord = drugById.get(drugIdByNDC.get(dailyClaim.NDC__c));
            HCPCSCodeTrunc = dailyClaim.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            if(drugRecord == null) {
                drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
            }
            System.debug('drugRecord = ' + drugRecord);
            if(drugRecord.Coding_Level__c == 'HCPCS + NDC') {
                NDCSet.add(dailyClaim.NDC__c);
                System.debug('dailyClaim.NDC__c = ' + dailyClaim.NDC__c);
            }
        }
        System.debug('J_Code_IdSet = ' + J_Code_IdSet);
        System.debug('NDCSet = ' + NDCSet);
        System.debug('existingContactIdSet = ' + existingContactIdSet);

        Contact_DrugsSelector contact_DrugsSelector = (Contact_DrugsSelector)PMd_Application.Selector.newInstance(Contact_Drug__c.SObjectType);
        List<Contact_Drug__c> existingContact_DrugsList = new List<Contact_Drug__c>();
        existingContact_DrugsList = contact_DrugsSelector.selectByJ_CodeIdContactId(J_Code_IdSet, NDCSet, existingContactIdSet);
        //List<Contact_Drug__c> existingContact_DrugsList = contact_DrugsSelector.selectByJ_CodeIdContactId(J_Code_IdSet);
        System.debug('In Daily_Claim:Contact_Drugs:process: existingContact_DrugsList Count = ' + existingContact_DrugsList.size());

        for(Contact_Drug__c contact_Drug : existingContact_DrugsList) {
            if(contact_Drug != null && contact_Drug.Contact__c != null) {
                contact_DrugByContactId.put(contact_Drug.Contact__c, contact_Drug);
            }
            System.debug('contact_Drug.Contact__c = ' + contact_Drug.Contact__c);
            System.debug('contact_Drug = ' + contact_Drug);
        }
        System.debug('ByContactId => contact_Drug = ' + contact_DrugByContactId);

        for(Daily_Claim__c dailyClaim : dailyClaimsList) {
            /*
            Look at existing Contact and determine if a ContactDrug exists based on:
                HCPCS Code
            If ContactDrug does not exist for the Contact, based on logic above:
                Pre go-live
                    Then create ContactDrug, Claim, and Enrollment Case.
                Post go-live
                    Then create ContactDrug, Claim, Enrollment Case, and Reimbursement Case.
            If ContactDrug does exist for the Contact, based on logic above:
                Then then check Claim processing logic and create a new Claim, if needed.
            */
            //relatedDrug = drugByHCPCS.get(dailyClaim.HCPCS_Code__c);
            relatedDrug = drugById.get(drugIdByNDC.get(dailyClaim.NDC__c));
            HCPCSCodeTrunc = dailyClaim.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            if(relatedDrug == null) {
                relatedDrug = drugByHCPCS.get(HCPCSCodeTrunc);
            } else if(relatedDrug.Coding_Level__c == 'HCPCS') {
                relatedDrug = drugByHCPCS.get(HCPCSCodeTrunc);
            }
            System.debug('relatedDrug = ' + relatedDrug);

            existingContact = existingContactsByDailyClaimId.get(dailyClaim.Id);
            System.debug('In Contact_Drugs:process: existingContact = ' + existingContact);
            //if(existingContact !=  null) {
            existingContact_Drug = contact_DrugByContactId.get(existingContact.Id);
            //}
            if(existingContact_Drug == null) {
                //Create new Contact_Drug
                System.debug('*** Create new Contact_Drug ***');
                Contact_Drug__c newContact_Drug = new Contact_Drug__c();
                if(existingContact != null){
                    newContact_Drug.Contact__c = existingContact.Id;

                    newContact_Drug.Drug_Name__c = relatedDrug.Id;
                    newContact_Drug = mapDailyClaimToContact_Drug(dailyClaim, newContact_Drug);
                    newContact_DrugsList.add(newContact_Drug);
                    allContact_Drugs.add(newContact_Drug);
                }
            } else {
                //Update existing Contact_Drug
                System.debug('*** Update existing Contact_Drug ***');
                existingContact_Drug = mapDailyClaimToContact_Drug(dailyClaim, existingContact_Drug);

                if(existingContact_Drug != null) {
                    existingContact_Drug.Drug_Name__c = relatedDrug.Id;
                    if(existingContact != null){
                        existingContact_Drug.Contact__c = existingContact.Id;
                    }
                    existingContact_Drugs.add(existingContact_Drug);
                    allContact_Drugs.add(existingContact_Drug);
                }
            }
        }

        uow.registerDirty(existingContact_Drugs);
        uow.registerNew(newContact_DrugsList);

        System.debug('In Contact_Drugs:process - Stop processing Contact_Drugs for Daily Claims');

        return allContact_Drugs;

    }

    /*
    Summary

    The second step in processing the Historical claims is to create or update ContactDrugs.
    Requirements
    ContactDrug processing logic:
    Look at existing Contact and determine if a ContactDrug exists based on:
        HCPCS Code
    If ContactDrug does not exist for the Contact, based on logic above:
        Then create a new ContactDrug, Enrollment Case, and Claim.
    If ContactDrug does exist for the Contact, based on logic above:
        Then then check Claim processing logic and create a new Claim, if needed.

    Acceptance Criteria
        If ContactDrug exists for Daily claim record then update ContactDrug else create ContactDrug.
     */
    public List<Contact_Drug__c> process(List<Historical_Claim__c> historicalClaimsList, fflib_ISObjectUnitOfWork uow)
    {
        System.debug('In Contact_Drugs:process - Start processing Contact_Drugs for Historical Claims');

        List<Contact> contactList = new List<Contact>();
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        //List<Contact> existingContacts = getExistingDailyClaimContacts(dailyClaimsList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByHistoricalClaimId(historicalClaimsList);
        System.debug('existingContactsByHistoricalClaimId Count: ' + existingContactsByHistoricalClaimId.size());

        // Create Contacts from the given Daily Claims
        List<SObject> newContact_DrugsList = new List<SObject>();
        List<Contact_Drug__c> existingContact_Drugs = new List<Contact_Drug__c>();
        List<Contact_Drug__c> allContact_Drugs = new List<Contact_Drug__c>();
        Set<String> J_Code_IdSet = new Set<String>();
        Set<String> NDCSet = new Set<String>{''};
        Set<Id> existingContactIdSet = new Set<Id>();
        Contact_Drug__c existingContact_Drug;
        List<Claim_Information__c> claimList = new List<Claim_Information__c>();
        List<Case> caseList = new List<Case>();
        Map<Id, Contact_Drug__c> contact_DrugByContactId = new  Map<Id, Contact_Drug__c>();
        Map<String, Drug__C> drugByHCPCS = new Map<String, Drug__c>();
        Map<String, Id> drugIdByNDC = new Map<String, Id>();
        Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
        Drug__c relatedDrug;
        Contact existingContact;
        String HCPCSCodeTrunc;

        //Get all Historical_Claim J_Codes
        //Get all Historical_Claim existing Contacts
        //Get all Historical_Claim existing Contact Ids
        for(Historical_Claim__c historicalClaim : historicalClaimsList) {
            HCPCSCodeTrunc = historicalClaim.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            J_Code_IdSet.add(HCPCSCodeTrunc);
            existingContact = existingContactsByHistoricalClaimId.get(historicalClaim.Id);
            if(existingContact != null) {
                existingContactIdSet.add(existingContact.Id);
            }
            System.debug('historicalClaim.Id = ' + historicalClaim.Id);
            System.debug('In Contact_Drugs:process: existingContact = ' + existingContact);
        }

        DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
        List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(J_Code_IdSet);

        for(Drug__c drugRecord : drugList) {
            //HCPCSCodeTrunc = drugRecord.J_Code__c.substring(0, maxHCPCSCodeSize);
            drugByHCPCS.put(drugRecord.J_Code__c, drugRecord);
            drugById.put(drugRecord.Id, drugRecord);
            System.debug('drugRecord.J_Code__c = ' + drugRecord.J_Code__c);
        }

        NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
        List<NDC__c> ndcList =  ndcsSelector.selectByDrugId(drugById.keySet());

        for(NDC__c ndcRecord : ndcList) {
            //HCPCSCodeTrunc = ndcRecord.Drug__r.J_Code__c.substring(0, maxHCPCSCodeSize);
            System.debug('ndcRecord.Drug__r.J_Code__c = ' + ndcRecord.Drug__r.J_Code__c);
            System.debug('ndcRecord.Name = ' + ndcRecord.Name);
            drugIdByNDC.put(ndcRecord.Name, ndcRecord.Drug__c);
        }

        //NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
        //List<NDC__c> ndcList = ndcsSelector.selectByDrugId(drugById.keySet());

        //If drug Coding Level is HCPCS than we only use the HCPCS to identify the drug
        //If drug Coding Level is HCPCS + NDC we Need include the NDC as part of the key to identify the Drug
        Drug__c drugRecord;
        for(Historical_Claim__c historicalClaim : historicalClaimsList) {
            drugRecord = drugById.get(drugIdByNDC.get(historicalClaim.NDC__c));
            HCPCSCodeTrunc = historicalClaim.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            if(drugRecord == null) {
                drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
            }
            System.debug('drugRecord = ' + drugRecord);
            if(drugRecord.Coding_Level__c == 'HCPCS + NDC') {
                NDCSet.add(historicalClaim.NDC__c);
                System.debug('historicalClaim.NDC__c = ' + historicalClaim.NDC__c);
            }
        }
        System.debug('J_Code_IdSet = ' + J_Code_IdSet);
        System.debug('NDCSet = ' + NDCSet);
        System.debug('existingContactIdSet = ' + existingContactIdSet);

        Contact_DrugsSelector contact_DrugsSelector = (Contact_DrugsSelector)PMd_Application.Selector.newInstance(Contact_Drug__c.SObjectType);
        List<Contact_Drug__c> existingContact_DrugsList = new List<Contact_Drug__c>();
        existingContact_DrugsList = contact_DrugsSelector.selectByJ_CodeIdContactId(J_Code_IdSet, NDCSet, existingContactIdSet);
        System.debug('In Historical_Claim:Contact_Drugs:process: existingContact_DrugsList Count = ' + existingContact_DrugsList.size());

        for(Contact_Drug__c contact_Drug : existingContact_DrugsList) {
            if(contact_Drug != null && contact_Drug.Contact__c != null) {
                contact_DrugByContactId.put(contact_Drug.Contact__c, contact_Drug);
            }
            System.debug('contact_Drug.Contact__c = ' + contact_Drug.Contact__c);
            System.debug('contact_Drug = ' + contact_Drug);
        }
        System.debug('ByContactId => contact_Drug = ' + contact_DrugByContactId);

        for(Historical_Claim__c historicalClaim : historicalClaimsList) {
            /*
              ContactDrug processing logic:
                Look at existing Contact and determine if a ContactDrug exists based on:
                    HCPCS Code
                If ContactDrug does not exist for the Contact, based on logic above:
                    Then create a new ContactDrug, Enrollment Case, and Claim.
                If ContactDrug does exist for the Contact, based on logic above:
                    Then then check Claim processing logic and create a new Claim, if needed.
            */
            //relatedDrug = drugByHCPCS.get(historicalClaim.HCPCS_Code__c);
            relatedDrug = drugById.get(drugIdByNDC.get(historicalClaim.NDC__c));
            HCPCSCodeTrunc = historicalClaim.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            if(relatedDrug == null) {
                relatedDrug = drugByHCPCS.get(HCPCSCodeTrunc);
            } else if(relatedDrug.Coding_Level__c == 'HCPCS') {
                relatedDrug = drugByHCPCS.get(HCPCSCodeTrunc);
            }
            System.debug('relatedDrug = ' + relatedDrug);

            existingContact = existingContactsByHistoricalClaimId.get(historicalClaim.Id);
            System.debug('existingContact = ' + existingContact);
            if(existingContact !=  null) {
                existingContact_Drug = contact_DrugByContactId.get(existingContact.Id);
            }
            if(existingContact_Drug == null) {
                //Create new Contact_Drug
                Contact_Drug__c newContact_Drug = new Contact_Drug__c();
                if(existingContact != null){
                    newContact_Drug.Contact__c = existingContact.Id;
                }

                newContact_Drug.Drug_Name__c = relatedDrug.Id;
                newContact_Drug = mapHistoricalClaimToContact_Drug(historicalClaim, newContact_Drug);
                newContact_DrugsList.add(newContact_Drug);
                allContact_Drugs.add(newContact_Drug);
            } else {
                existingContact_Drug = mapHistoricalClaimToContact_Drug(historicalClaim, existingContact_Drug);

                //if(existingContact_Drug != null) {
                existingContact_Drug.Drug_Name__c = relatedDrug.Id;
                if(existingContact != null){
                    existingContact_Drug.Contact__c = existingContact.Id;
                }
                existingContact_Drugs.add(existingContact_Drug);
                allContact_Drugs.add(existingContact_Drug);
                //}
            }
        }

        uow.registerDirty(existingContact_Drugs);
        uow.registerNew(newContact_DrugsList);

        System.debug('In Contact_Drugs:process - Stop processing Contact_Drugs for Historical Claims');

        return allContact_Drugs;

    }

    /*
    Summary

    The second step in processing the Prior Auth is to create or update ContactDrugs.
    Requirements
    ContactDrug processing logic:
    Look at existing Contact and determine if a ContactDrug exists based on:
    HCPCS Code
    If ContactDrug does not exist for the Contact, based on logic above:
    Then create a new ContactDrug, Enrollment Case, and Claim.
    If ContactDrug does exist for the Contact, based on logic above:
    Then then check Claim processing logic and create a new Claim, if needed.

    Acceptance Criteria
    If ContactDrug exists for Daily claim record then update ContactDrug else create ContactDrug.
    */
    public List<Contact_Drug__c> process(List<Prior_Auth__c> priorAuthList, fflib_ISObjectUnitOfWork uow)
    {
        System.debug('In Contact_Drugs:process - Start processing Contact_Drugs for Prior Auth');

        List<Contact> contactList = new List<Contact>();
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        //List<Contact> existingContacts = getExistingDailyClaimContacts(dailyClaimsList);
        Map<Id, Contact> existingContactsByPriorAuthId = contactsDomain.getExistingContactsByPriorAuthId(priorAuthList);
        System.debug('existingContactsByPriorAuthId Count: ' + existingContactsByPriorAuthId.size());

        // Create Contacts from the given Daily Claims
        List<SObject> newContact_DrugsList = new List<SObject>();
        List<Contact_Drug__c> allContact_Drugs = new List<Contact_Drug__c>();
        List<Contact_Drug__c> existingContact_Drugs = new List<Contact_Drug__c>();
        Set<String> J_Code_IdSet = new Set<String>();
        Set<String> NDCSet = new Set<String>{''};
        Set<Id> existingContactIdSet = new Set<Id>();
        Contact_Drug__c existingContact_Drug;
        List<Claim_Information__c> claimList = new List<Claim_Information__c>();
        List<Case> caseList = new List<Case>();
        Map<Id, Contact_Drug__c> contact_DrugByContactId = new  Map<Id, Contact_Drug__c>();
        Map<String, Contact_Drug__c> contact_DrugByHCPCS = new  Map<String, Contact_Drug__c>();
        Map<String, Drug__C> drugByHCPCS = new Map<String, Drug__c>();
        Map<String, Id> drugIdByNDC = new Map<String, Id>();
        Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
        Drug__c relatedDrug;
        Contact existingContact;
        String HCPCSCodeTrunc;

        //Get all Prior_Auth J_Codes
        //Get all Prior_Auth existing Contacts
        //Get all Prior_Auth existing Contact Ids
        for(Prior_Auth__c priorAuth : priorAuthList) {
            HCPCSCodeTrunc = priorAuth.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            J_Code_IdSet.add(HCPCSCodeTrunc);
            existingContact = existingContactsByPriorAuthId.get(priorAuth.Id);
            if(existingContact != null) {
                existingContactIdSet.add(existingContact.Id);
            }
            System.debug('priorAuth.Id = ' + priorAuth.Id);
            System.debug('In Contact_Drugs:process: existingContact = ' + existingContact);
        }
        System.debug('J_Code_IdSet = ' + J_Code_IdSet);

        DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
        List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(J_Code_IdSet);

        for(Drug__c drugRecord : drugList) {
            //HCPCSCodeTrunc = drugRecord.J_Code__c.substring(0, maxHCPCSCodeSize);
            drugByHCPCS.put(drugRecord.J_Code__c, drugRecord);
            System.debug('drugRecord.J_Code__c = ' + drugRecord.J_Code__c);
        }

        NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
        List<NDC__c> ndcList =  ndcsSelector.selectByDrugId(drugById.keySet());

        for(NDC__c ndcRecord : ndcList) {
            HCPCSCodeTrunc = ndcRecord.Drug__r.J_Code__c.substring(0, maxHCPCSCodeSize);
            System.debug('ndcRecord.Drug__r.J_Code__c = ' + HCPCSCodeTrunc);
            System.debug('ndcRecord.Name = ' + ndcRecord.Name);
            drugIdByNDC.put(ndcRecord.Name, ndcRecord.Drug__c);
        }

        //NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
        //List<NDC__c> ndcList = ndcsSelector.selectByDrugId(drugById.keySet());

        //If drug Coding Level is HCPCS than we only use the HCPCS to identify the drug
        //If drug Coding Level is HCPCS + NDC we Need include the NDC as part of the key to identify the Drug
        Drug__c drugRecord;
        for(Prior_Auth__c priorAuth : priorAuthList) {
            HCPCSCodeTrunc = priorAuth.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            drugRecord = drugById.get(drugIdByNDC.get(priorAuth.NDC__c));
            if(drugRecord == null) {
                drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
            }
            System.debug('drugRecord = ' + drugRecord);
            if(drugRecord.Coding_Level__c == 'HCPCS + NDC') {
                NDCSet.add(priorAuth.NDC__c);
                System.debug('priorAuth.NDC__c = ' + priorAuth.NDC__c);
            }
        }
        System.debug('J_Code_IdSet = ' + J_Code_IdSet);
        System.debug('NDCSet = ' + NDCSet);
        System.debug('existingContactIdSet = ' + existingContactIdSet);

        Contact_DrugsSelector contact_DrugsSelector = (Contact_DrugsSelector)PMd_Application.Selector.newInstance(Contact_Drug__c.SObjectType);
        List<Contact_Drug__c> existingContact_DrugsList = new List<Contact_Drug__c>();
        existingContact_DrugsList = contact_DrugsSelector.selectByJ_CodeIdContactId(J_Code_IdSet, NDCSet, existingContactIdSet);
        System.debug('existingContact_DrugsList Count = ' + existingContact_DrugsList.size());

        for(Contact_Drug__c contact_Drug : existingContact_DrugsList) {
            //contact_DrugByContactId.put(contact_Drug.Contact__c, contact_Drug);
            HCPCSCodeTrunc = contact_Drug.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            contact_DrugByHCPCS.put(HCPCSCodeTrunc, contact_Drug);
            //System.debug('ByContactId => contact_Drug = ' + contact_DrugByContactId);
            System.debug('ByHCPCS => contact_Drug = ' + contact_DrugByHCPCS);
        }

        for(Prior_Auth__c priorAuth : priorAuthList) {
            /*
              ContactDrug processing logic:
                Look at existing Contact and determine if a ContactDrug exists based on:
                    HCPCS Code
                If ContactDrug does not exist for the Contact, based on logic above:
                    Then create a new ContactDrug, Enrollment Case, and Claim.
                If ContactDrug does exist for the Contact, based on logic above:
                    Then then check Claim processing logic and create a new Claim, if needed.
            */
            //relatedDrug = drugByHCPCS.get(priorAuth.HCPCS_Code__c);
            relatedDrug = drugById.get(drugIdByNDC.get(priorAuth.NDC__c));
            HCPCSCodeTrunc = priorAuth.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            if(relatedDrug == null) {
                relatedDrug = drugByHCPCS.get(HCPCSCodeTrunc);
            } else if(relatedDrug.Coding_Level__c == 'HCPCS') {
                relatedDrug = drugByHCPCS.get(HCPCSCodeTrunc);
            }
            System.debug('relatedDrug = ' + relatedDrug);

            existingContact = existingContactsByPriorAuthId.get(priorAuth.Id);
            System.debug('existingContact = ' + existingContact);
            //if(existingContact !=  null) {
            //    existingContact_Drug = contact_DrugByContactId.get(existingContact.Id);
            //}
            existingContact_Drug = contact_DrugByHCPCS.get(HCPCSCodeTrunc);
            if(existingContact_Drug == null) {
                //Create new Contact_Drug
                Contact_Drug__c newContact_Drug = new Contact_Drug__c();
                if(existingContact != null){
                    newContact_Drug.Contact__c = existingContact.Id;
                }

                newContact_Drug.Drug_Name__c = relatedDrug.Id;
                newContact_Drug = mapPriorAuthToContact_Drug(priorAuth, newContact_Drug);
                newContact_DrugsList.add(newContact_Drug);
                allContact_Drugs.add(newContact_Drug);
            } else {
                existingContact_Drug = mapPriorAuthToContact_Drug(priorAuth, existingContact_Drug);

                //if(existingContact_Drug != null) {
                existingContact_Drug.Drug_Name__c = relatedDrug.Id;
                if(existingContact != null){
                    existingContact_Drug.Contact__c = existingContact.Id;
                }
                existingContact_Drugs.add(existingContact_Drug);
                allContact_Drugs.add(existingContact_Drug);
                //}
            }
        }

        uow.registerDirty(existingContact_Drugs);
        uow.registerNew(newContact_DrugsList);

        System.debug('In Contact_Drugs:process - Stop processing Contact_Drugs for Prior Auth');

        return allContact_Drugs;
    }

    /*
    Summary

    The second step in processing the Historical Prior Auth is to create or update ContactDrugs.
    Requirements
    ContactDrug processing logic:
        Look at existing Contact and determine if a ContactDrug exists based on: HCPCS Code
        If ContactDrug does not exist for the Contact, based on logic above:
            Then create a new ContactDrug, Enrollment Case, and Claim.
        If ContactDrug does exist for the Contact, based on logic above:
            Then then check Claim processing logic and create a new Claim, if needed.

    Acceptance Criteria
    If ContactDrug exists for Daily claim record then update ContactDrug else create ContactDrug.
    */
    public List<Contact_Drug__c> process(List<Historical_Prior_Auth__c> historicalPriorAuthList, fflib_ISObjectUnitOfWork uow)
    {
        System.debug('In Contact_Drugs:process - Start processing Contact_Drugs for Historical Prior Auth');

        List<Contact> contactList = new List<Contact>();
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        //List<Contact> existingContacts = getExistingDailyClaimContacts(dailyClaimsList);
        Map<Id, Contact> existingContactsByHistoricalPriorAuthId = contactsDomain.getExistingContactsByHistoricalPriorAuthId(historicalPriorAuthList);
        System.debug('existingContactsByHistoricalPriorAuthId Count: ' + existingContactsByHistoricalPriorAuthId.size());

        // Create Contacts from the given Daily Claims
        List<SObject> newContact_DrugsList = new List<SObject>();
        List<Contact_Drug__c> existingContact_Drugs = new List<Contact_Drug__c>();
        List<Contact_Drug__c> allContact_Drugs = new List<Contact_Drug__c>();
        Set<String> J_Code_IdSet = new Set<String>();
        Set<String> NDCSet = new Set<String>{''};
        Set<Id> existingContactIdSet = new Set<Id>();
        Contact_Drug__c existingContact_Drug;
        List<Claim_Information__c> claimList = new List<Claim_Information__c>();
        List<Case> caseList = new List<Case>();
        Map<Id, Contact_Drug__c> contact_DrugByContactId = new  Map<Id, Contact_Drug__c>();
        Map<String, Drug__C> drugByHCPCS = new Map<String, Drug__c>();
        Map<String, Id> drugIdByNDC = new Map<String, Id>();
        Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
        Drug__c relatedDrug;
        Contact existingContact;
        String HCPCSCodeTrunc;

        //Get all Prior_Auth J_Codes
        //Get all Prior_Auth existing Contacts
        //Get all Prior_Auth existing Contact Ids
        for(Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthList) {
            HCPCSCodeTrunc = historicalPriorAuth.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            J_Code_IdSet.add(HCPCSCodeTrunc);
            existingContact = existingContactsByHistoricalPriorAuthId.get(historicalPriorAuth.Id);
            if(existingContact != null) {
                existingContactIdSet.add(existingContact.Id);
            }
        }

        DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
        List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(J_Code_IdSet);
        for(Drug__c drugRecord : drugList) {
            //HCPCSCodeTrunc = drugRecord.J_Code__c.substring(0, maxHCPCSCodeSize);
            drugByHCPCS.put(drugRecord.J_Code__c, drugRecord);
            drugById.put(drugRecord.Id, drugRecord);
            System.debug('drugRecord.J_Code__c = ' + drugRecord.J_Code__c);
        }

        NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
        List<NDC__c> ndcList =  ndcsSelector.selectByDrugId(drugById.keySet());

        for(NDC__c ndcRecord : ndcList) {
            System.debug('ndcRecord.Drug__r.J_Code__c = ' + ndcRecord.Drug__r.J_Code__c);
            System.debug('ndcRecord.Name = ' + ndcRecord.Name);
            drugIdByNDC.put(ndcRecord.Name, ndcRecord.Drug__c);
        }

        //NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
        //List<NDC__c> ndcList = ndcsSelector.selectByDrugId(drugById.keySet());

        //If drug Coding Level is HCPCS than we only use the HCPCS to identify the drug
        //If drug Coding Level is HCPCS + NDC we Need include the NDC as part of the key to identify the Drug
        Drug__c drugRecord;
        for(Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthList) {
            drugRecord = drugById.get(drugIdByNDC.get(historicalPriorAuth.NDC__c));
            HCPCSCodeTrunc = historicalPriorAuth.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            if(drugRecord == null) {
                drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
            }
            if(drugRecord.Coding_Level__c == 'HCPCS + NDC') {
                NDCSet.add(historicalPriorAuth.NDC__c);
                System.debug('priorAuth.NDC__c = ' + historicalPriorAuth.NDC__c);
            }
        }
        System.debug('J_Code_IdSet = ' + J_Code_IdSet);
        System.debug('NDCSet = ' + NDCSet);
        System.debug('existingContactIdSet = ' + existingContactIdSet);

        Contact_DrugsSelector contact_DrugsSelector = (Contact_DrugsSelector)PMd_Application.Selector.newInstance(Contact_Drug__c.SObjectType);
        List<Contact_Drug__c> existingContact_DrugsList = new List<Contact_Drug__c>();
        existingContact_DrugsList = contact_DrugsSelector.selectByJ_CodeIdContactId(J_Code_IdSet, NDCSet, existingContactIdSet);
        System.debug('In Contact_Drugs:process - existingContact_DrugsList Count = ' + existingContact_DrugsList.size());

        for(Contact_Drug__c contact_Drug : existingContact_DrugsList) {
            contact_DrugByContactId.put(contact_Drug.Contact__c, contact_Drug);
            System.debug('ByContactId => contact_Drug = ' + contact_DrugByContactId);
        }

        for(Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthList) {
            /*
              ContactDrug processing logic:
                Look at existing Contact and determine if a ContactDrug exists based on:
                    HCPCS Code
                If ContactDrug does not exist for the Contact, based on logic above:
                    Then create a new ContactDrug, Enrollment Case, and Claim.
                If ContactDrug does exist for the Contact, based on logic above:
                    Then then check Claim processing logic and create a new Claim, if needed.
            */
            //relatedDrug = drugByHCPCS.get(historicalPriorAuth.HCPCS_Code__c);
            relatedDrug = drugById.get(drugIdByNDC.get(historicalPriorAuth.NDC__c));
            HCPCSCodeTrunc = historicalPriorAuth.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            if(relatedDrug == null) {
                relatedDrug = drugByHCPCS.get(HCPCSCodeTrunc);
            } else if(relatedDrug.Coding_Level__c == 'HCPCS') {
                relatedDrug = drugByHCPCS.get(HCPCSCodeTrunc);
            }
            System.debug('relatedDrug = ' + relatedDrug);

            existingContact = existingContactsByHistoricalPriorAuthId.get(historicalPriorAuth.Id);
            System.debug('existingContact = ' + existingContact);
            if(existingContact !=  null) {
                existingContact_Drug = contact_DrugByContactId.get(existingContact.Id);
            }
            System.debug('existingContact = ' + existingContact);
            if(existingContact_Drug == null) {
                //Create new Contact_Drug
                Contact_Drug__c newContact_Drug = new Contact_Drug__c();
                if(existingContact != null){
                    newContact_Drug.Contact__c = existingContact.Id;
                }

                newContact_Drug.Drug_Name__c = relatedDrug.Id;
                newContact_Drug = mapHistoricalPriorAuthToContact_Drug(historicalPriorAuth, newContact_Drug);
                newContact_DrugsList.add(newContact_Drug);
                allContact_Drugs.add(newContact_Drug);
            } else {
                existingContact_Drug = mapHistoricalPriorAuthToContact_Drug(historicalPriorAuth, existingContact_Drug);

                //if(existingContact_Drug != null) {
                existingContact_Drug.Drug_Name__c = relatedDrug.Id;
                if(existingContact != null){
                    existingContact_Drug.Contact__c = existingContact.Id;
                }
                existingContact_Drugs.add(existingContact_Drug);
                allContact_Drugs.add(existingContact_Drug);
                //}
            }
        }

        uow.registerDirty(existingContact_Drugs);
        uow.registerNew(newContact_DrugsList);

        System.debug('In Contact_Drugs:process - Stop processing Contact_Drugs for Historical Prior Auth');

        return allContact_Drugs;
    }

    //Map Daily Claim fields to new Contact fields
    private Contact_Drug__c mapDailyClaimToContact_Drug(Daily_Claim__c dailyClaim, Contact_Drug__c contact_Drug) {

        contact_Drug.Daily_Claim__c = dailyClaim.Id;
        //contact_Drug.NDC__c = dailyClaim.NDC__c;

        return contact_Drug;
    }

    //Map Historical Claim fields to new Contact fields
    private Contact_Drug__c mapHistoricalClaimToContact_Drug(Historical_Claim__c historicalClaim, Contact_Drug__c contact_Drug) {

        contact_Drug.Historical_Claim__c = historicalClaim.Id;
        //contact_Drug.NDC__c = historicalClaim.NDC__c;

        return contact_Drug;
    }

    //Map Prior Auth fields to new Contact fields
    private Contact_Drug__c mapPriorAuthToContact_Drug(Prior_Auth__c priorAuth, Contact_Drug__c contact_Drug) {

        contact_Drug.Prior_Auth__c = priorAuth.Id;
        //contact_Drug.NDC__c = priorAuth.NDC__c;

        return contact_Drug;
    }

    //Map Historical Prior Auth fields to new Contact fields
    private Contact_Drug__c mapHistoricalPriorAuthToContact_Drug(Historical_Prior_Auth__c historicalPriorAuth, Contact_Drug__c contact_Drug) {

        contact_Drug.Historical_Prior_Auth__c = historicalPriorAuth.Id;
        //contact_Drug.NDC__c = historicalPriorAuth.NDC__c;

        return contact_Drug;
    }

    private void mapContactDrugsToDailyClaim(Map<Id, Contact_Drug__c> contactDrugByDailyClaimsId, fflib_ISObjectUnitOfWork uow) {

        List<SObject> existingHDailyClaimsList = new List<SObject>();

        Daily_ClaimsSelector dailyClaimsSelector = (Daily_ClaimsSelector) PMd_Application.Selector.newInstance(Daily_Claim__c.SObjectType);
        List<Daily_Claim__c> relatedDailysClaimList = dailyClaimsSelector.selectById(contactDrugByDailyClaimsId.keySet());
        System.debug('relatedDailyClaimsList Count: ' + relatedDailysClaimList.size());

        for(Daily_Claim__c dailyClaimRecord :relatedDailysClaimList) {
            Contact_Drug__c contactDrugRecord = contactDrugByDailyClaimsId.get(dailyClaimRecord.Id);
            dailyClaimRecord.Contact_Drug__c = contactDrugRecord.Id;
            existingHDailyClaimsList.add(dailyClaimRecord);
        }

        uow.registerDirty(existingHDailyClaimsList);

        System.debug('existingHDailyClaimsList Count = ' + existingHDailyClaimsList.size());

    }

    private void mapContactDrugsToHistoricalPA(Map<Id, Contact_Drug__c> contactDrugByHistoricalPAId, fflib_ISObjectUnitOfWork uow) {

        List<SObject> existingHistoricalPAList = new List<SObject>();

        Historical_Prior_AuthSelector historicalPriorAuthSelector = (Historical_Prior_AuthSelector) PMd_Application.Selector.newInstance(Historical_Prior_Auth__c.SObjectType);
        List<Historical_Prior_Auth__c> relatedHistoricalPriorAuthsList = historicalPriorAuthSelector.selectById(contactDrugByHistoricalPAId.keySet());
        System.debug('relatedHistoricalPriorAuthsList Count: ' + relatedHistoricalPriorAuthsList.size());

        for(Historical_Prior_Auth__c historicalPA :relatedHistoricalPriorAuthsList) {
            Contact_Drug__c contactDrugRecord = contactDrugByHistoricalPAId.get(historicalPA.Id);
            historicalPA.Contact_Drug__c = contactDrugRecord.Id;
            existingHistoricalPAList.add(historicalPA);
        }

        uow.registerDirty(existingHistoricalPAList);

        System.debug('existingHistoricalPAList Count = ' + existingHistoricalPAList.size());

    }

    private void mapContactDrugsToPA(Map<Id, Contact_Drug__c> contactDrugByPAId, fflib_ISObjectUnitOfWork uow) {

        List<SObject> existingPAList = new List<SObject>();

        Prior_AuthSelector priorAuthSelector = (Prior_AuthSelector) PMd_Application.Selector.newInstance(Prior_Auth__c.SObjectType);
        List<Prior_Auth__c> relatedPriorAuthsList = priorAuthSelector.selectById(contactDrugByPAId.keySet());
        System.debug('relatedPriorAuthsList Count: ' + relatedPriorAuthsList.size());

        for(Prior_Auth__c pA :relatedPriorAuthsList) {
            Contact_Drug__c contactDrugRecord = contactDrugByPAId.get(pA.Id);
            pA.Contact_Drug__c = contactDrugRecord.Id;
            System.debug('pA.Contact_Drug__c = ' + pA.Contact_Drug__c);
            existingPAList.add(pA);
        }

        uow.registerDirty(existingPAList);

        System.debug('existingPAList Count = ' + existingPAList.size());

    }

    /***************************************************************************************************************************************
     * Trigger Operations
     **************************************************************************************************************************************/
//    public override void processAfterInsert(){
    public override void onBeforeInsert() {
        System.debug('Start Contact_Drugs:onBeforeInsert');

        List<Contact_Drug__c> contact_DrugList = Records;
        List<Contact_Drug__c> contact_DrugsToProcessList = new List<Contact_Drug__c>();

        if(contact_DrugsToProcessList.size() > 0) {
            //ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
        }
        System.debug('End Contact_Drugs:onBeforeInsert');
    }

    public override void onBeforeUpdate(Map<Id, SObject> oldRecords) {
        System.debug('Start Contact_Drugs:onBeforeUpdate');

        List<Contact_Drug__c> contact_DrugList = Records;
        List<Contact_Drug__c> contact_DrugsToProcessList = new List<Contact_Drug__c>();

        if(contact_DrugsToProcessList.size() > 0) {
            //ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
        }
        System.debug('End Contact_Drugs:onBeforeUpdate');
    }

    //    public override void processAfterInsert(){
    public override void onAfterInsert() {
        System.debug('Start Contact_Drugs:onAfterInsert');

        fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

        List<Contact_Drug__c> contactDrugsList = Records;
        List<Contact_Drug__c> contactDrugsToProcessList = new List<Contact_Drug__c>();
        Map<Id, Contact_Drug__c> contactDrugByDailyClaimId = new Map<Id, Contact_Drug__c>();
        Map<Id, Contact_Drug__c> contactDrugByHistoricalPAId = new Map<Id, Contact_Drug__c>();
        Map<Id, Contact_Drug__c> contactDrugByPAId = new Map<Id, Contact_Drug__c>();

        API_User__mdt IntegrationUser = [SELECT Id, Username__c, Profile_Name__c FROM API_User__mdt WHERE Alias__c = 'iuser'];
        String contextUserName = UserInfo.getUserName(); //Returns the context user's login name.

        //Get all Contact_Drugs by contact_DrugId
        for(Contact_Drug__c contactDrugRecord : contactDrugsList) {
            if(contextUserName == IntegrationUser.Username__c) {
                contactDrugByDailyClaimId.put(contactDrugRecord.Daily_Claim__c, contactDrugRecord);
                contactDrugByHistoricalPAId.put(contactDrugRecord.Historical_Prior_Auth__c, contactDrugRecord);
                contactDrugByPAId.put(contactDrugRecord.Prior_Auth__c, contactDrugRecord);
                System.debug('contactDrugRecord.Prior_Auth__c = ' + contactDrugRecord.Prior_Auth__c);
                System.debug('contactDrugRecord = ' + contactDrugRecord);
            }
        }
        System.debug('`contactDrugByDailyClaimId.size =` ' + contactDrugByDailyClaimId.size());
        System.debug('contactDrugByHistoricalPAId.size = ' + contactDrugByHistoricalPAId.size());
        System.debug('contactDrugByPAId.size = ' + contactDrugByPAId.size());

        //Map all Contact_Drug related DCs
        if(contactDrugByDailyClaimId.size() > 0) {
            mapContactDrugsToDailyClaim(contactDrugByDailyClaimId, uow);
        }
        //Map all Contact_Drug related HistoricalPAs
        if(contactDrugByHistoricalPAId.size() > 0) {
            mapContactDrugsToHistoricalPA(contactDrugByHistoricalPAId, uow);
        }
        //Map all Contact_Drug related PAs
        if(contactDrugByPAId.size() > 0) {
            mapContactDrugsToPA(contactDrugByPAId, uow);
        }

        if(contactDrugsToProcessList.size() > 0) {
            //ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
        }
        try {
            uow.commitWork();
        }catch(Exception e){
            System.debug('++ ' + e.getMessage());
            ErrorLog.log('Contact_Drugs.onAfterInsert', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, null, null, null);
            ErrorLog.commitLogs();
            //throw e;
        }

        System.debug('End Contact_Drugs:onAfterInsert');
    }

    public override void onAfterUpdate(Map<Id, SObject> oldRecords) {
        System.debug('Start Contact_Drugs:onAfterUpdate');

        fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

        List<Contact_Drug__c> contactDrugsList = Records;
        List<Contact_Drug__c> contactDrugsToProcessList = new List<Contact_Drug__c>();
        Map<Id, Contact_Drug__c> contactDrugByDailyClaimId = new Map<Id, Contact_Drug__c>();
        Map<Id, Contact_Drug__c> contactDrugByHistoricalPAId = new Map<Id, Contact_Drug__c>();
        Map<Id, Contact_Drug__c> contactDrugByPAId = new Map<Id, Contact_Drug__c>();
        API_User__mdt IntegrationUser = [SELECT Id, Username__c, Profile_Name__c, ProfileId__c FROM API_User__mdt WHERE Alias__c = 'iuser'];
        String contextUserName = UserInfo.getUserName(); //Returns the context user's login name.
        String contextUserProfileID = UserInfo.getProfileId(); //Returns the context user's profile ID.
        //String contextUserProfileID = UserInfo.getProfileId(); //Returns the context user's profile ID.

        //Get all Contact_Drugs by contact_DrugId
        for(Contact_Drug__c contactDrugRecord : contactDrugsList) {
            //Only the Integration User or Users with Sys Admin Full Profiles should be able to make this
            // change so that others can update the downstream objects w/o having permission to update the Source Objects.
            if(contextUserProfileID == IntegrationUser.ProfileId__c) {
                contactDrugByDailyClaimId.put(contactDrugRecord.Daily_Claim__c, contactDrugRecord);
                contactDrugByHistoricalPAId.put(contactDrugRecord.Historical_Prior_Auth__c, contactDrugRecord);
                contactDrugByPAId.put(contactDrugRecord.Prior_Auth__c, contactDrugRecord);
            }
        }
        System.debug('contactDrugByDailyClaimId.size = ' + contactDrugByDailyClaimId.size());
        System.debug('contactDrugByHistoricalPAId.size = ' + contactDrugByHistoricalPAId.size());
        System.debug('contactDrugByPAId.size = ' + contactDrugByPAId.size());

        //Map all Contact_Drug related DCs
        if(contactDrugByDailyClaimId.size() > 0) {
            mapContactDrugsToDailyClaim(contactDrugByDailyClaimId, uow);
        }
        //Map all Contact_Drug related HistoricalPAs
        if(contactDrugByHistoricalPAId.size() > 0) {
            mapContactDrugsToHistoricalPA(contactDrugByHistoricalPAId, uow);
        }
        //Map all Contact_Drug related PAs
        if(contactDrugByPAId.size() > 0) {
            mapContactDrugsToPA(contactDrugByPAId, uow);
        }

        if(contactDrugsToProcessList.size() > 0) {
            //ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
        }
        try {
            uow.commitWork();
        }catch(Exception e){
            System.debug('++ ' + e.getMessage());
            ErrorLog.log('Contact_Drugs.onAfterUpdate', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, null, null, null);
            ErrorLog.commitLogs();
            //throw e;
        }

        System.debug('End Contact_Drugs:onAfterUpdate');
    }
}