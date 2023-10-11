/**
 * @description       :
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 12-01-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author            Modification
 * 1.0   08-06-2021   Ricardy Banks		Initial Version
 * 1.1   12-01-2021   Ricardy Banks     MED-114 Queue the Claim to Send: Send to ACAS (Claim) is set to "Queued" when either CPA Funds Paid or CPA Indicator is modified AND both fields are populated.
 * 1.2   01-08-2022   Ricardy Banks     SAL-1012 MED: Daily Claim Key Matching Creating Duplicate Claims
 * 1.3   01-12-2022   Ricardy Banks     SAL-1298 MED: Historical Claim Key Matching Creating Duplicate Claims
 * 1.4   01-14-2022   Ricardy Banks     SAL-1296 Don't create Orphan claims if there is no initial claim.
 * 1.5   01-14-2022   Ricardy Banks     SAL-1297 Daily claim link added to the updated claim.
 * 1.6   02-07-2022   Ricardy Banks     SAL-1351 Replacement Claim to be associated with previously adjudicated claim's case number
 * 1.7   04-28-2022	  Ricardy Banks		Optimized Daily Claim by passing existingContactsByDailyClaimId, existingContact_DrugsList, allClaim_InformationList from previously processed objects instead of querying the same records multiple times.
 * 1.8   08-29-2022   Ricardy Banks     MBP-711 Only Allow Integration User to Link Downstream Objects to the Source Object
 * 1.9   02-16-2023   Ricardy Banks     MBP-907 Error Log: Claim Information Object
 *
 **/

public inherited sharing class Claim_Informations extends fflib_SObjectDomain
        implements IClaim_Informations
{
    private static Integer maxHCPCSCodeSize = 5;
    //This sets up the super class (fflib_SObjectDomain) to have the records variable filled out
    public Claim_Informations(List<Claim_Information__c> claim_InformationRecords) {
        super(claim_InformationRecords);
    }

    public List<Claim_Information__c> getClaim_Informations()
    {
        return (List<Claim_Information__c>) getRecords();
    }

    //This helps allow for the fflib_SObjectDomain class to run its triggerHandler method
    //using the correct Domain class. This must be implemented in all domain classes.
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Claim_Informations(sObjectList);
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

The next step in Daily claims is to create or update claims.

Requirements
    Claim processing logic:
        Rule: Only “Original” Claim Indicators will create new Reimbursement Cases.
            This should be addressed via the matching logic below.
        Look for an existing Claim based on unique key (Example here)
            Claim ID
            If Claim Previous Segment populated:
                Then Previous Segment
                Else Claim Segment
            Claim Line Identifier
        If Claim unique key does not exist for the ContactDrug:
            Create Daily Claim for each Claim record. The related Claim, Segment, and Line will be shown from the Daily Claims related list (bottom section of this Claim).
            Pre go-live
                Then create Enrollment Case.
                    Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
            Post go-live
                Then create Enrollment Case and Reimbursement Case.
                    Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
        If Claim unique key does exist for the ContactDrug:
            Then update existing Claim record with new data.
            The old Claim, Segment, and Line will be shown from the Daily Claims related list (bottom section of this Claim).
            If Enrollment Case already exists:
                Then do not create a new Enrollment Case.
            If Reimbursement Case already exists:
                Then do not create a new Reimbursement Case.
                If Case is closed, then reopen Case.
                If Case is open, then flag case as “Rework Needed.”
                Acceptance Criteria
                If unique claim key exists then update claim else create a new claim.
     */
    public List<Claim_Information__c> process(List<Daily_Claim__c> dailyClaimsList,
                                                Map<Id, Contact> existingContactsByDailyClaimId,
                                                List<Contact_Drug__c> existingContact_DrugsList,
                                                fflib_ISObjectUnitOfWork uow)
    {
        System.debug('In Claim_Informations:process - Start processing Claim_Information for Daily Claims');

        // Create Claims from the given Daily Claims
        List<SObject> newClaimList = new List<SObject>();
        List<SObject> existingClaimList = new List<SObject>();
       //List<SObject> existingReplacementClaimCasesList = new List<SObject>();
        List<SObject> existingContact_DrugList = new List<SObject>();
        List<SObject> newEnrollmentCaseList = new List<SObject>();
        List<SObject> newReimbursementCaseList = new List<SObject>();

        Set<String> primary_Claim_NumberSet = new Set<String>();
        Set<String> claim_SegmentSet = new Set<String>();
        Set<String> claim_LineSet = new Set<String>();
        Set<String> previous_SegmentSet = new Set<String>();
        Set<String> claim_NumberSet = new Set<String>();

        List<Claim_Information__c> originalClaim_InformationList;
        List<Claim_Information__c> existingClaim_InformationList;
        List<Claim_Information__c> existingClaimToBeReplacedList;
        List<Claim_Information__c> allClaim_InformationList = new List<Claim_Information__c>();
        Map<String, Id> dailyClaimIdByCSANumber = new Map<String, Id>();
        Map<Id, String> csaNumberByDailyClaimId = new Map<Id, String>();
        Map<Id, CSA__c> csaByDailyClaimId = new Map<Id, CSA__c>();
        Map<String, CSA__c> csasByCSA_Number = new Map<String, CSA__c>();
        Map<Id, Claim_Information__c> claimByContact_DrugId = new Map<Id, Claim_Information__c>();
        Map<Id, Claim_Information__c> claimById = new Map<Id, Claim_Information__c>();
        Map<String, Claim_Information__c> claimIdToBeRelplacedByPrevious_Claim = new Map<String, Claim_Information__c>();
        Map<Id, String> claim_NumberByDailyClaimId = new Map<Id, String>();
        Map<Id, String> newPrevious_SegmentByClaimId = new Map<Id, String>();
        Map<String, Claim_Information__c> claimByClaim_Number = new Map<String, Claim_Information__c>();
        Map<Id, Contact_Drug__c> contact_DrugByClaim_InformationId = new Map<Id, Contact_Drug__c>();
        Map<Id, Contact_Drug__c> contact_DrugByContactId = new Map<Id, Contact_Drug__c>();
        Case enrollmentCase, reimbursementCase;
        Map<Id, Case> existingEnrollmentCaseByClaimId = new Map<Id, Case>();
        Map<Id, Case> existingReimbursementCaseByClaimId = new Map<Id, Case>();
        Map<String, List<Case>> existingReplacementCaseListsByPreviousClaim = new Map<String, List<Case>>();
        //Map<String, Claim_Information__c> claimByHCPS = new Map<String, Claim_Information__c>();
        Map<String, Id> replacementClaimByUCKID = new Map<String, Id>();
        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
        Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');
        Schema.RecordTypeInfo reimbursementCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');
        String sha1Hash_Id;
        Set<String> J_Code_IdSet = new Set<String>();
        Set<String> contactSHA1HashIdSet = new Set<String>();
        Set<Id> existingContactIdSet = new Set<Id>();
        Contact_Drug__c contact_DrugRecord;
        Map<String, Contact_Drug__c> contact_DrugByHCPCS_Code = new Map<String, Contact_Drug__c>();
        List<Contact> existingSha1Hash_IdMatchedContactsList;
        String claim_NumberSeed, HCPCSCodeTrunc;
        Map<String, Drug__C> drugByHCPCS = new Map<String, Drug__c>();
        Map<String, Id> drugIdByNDC = new Map<String, Id>();
        Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
        Drug__c relatedDrug;
        List<Contact> contactList = new List<Contact>();

        System.debug('dailyClaimsList Count = ' + dailyClaimsList.size());

        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        //List<Contact> existingContacts = getExistingDailyClaimContacts(dailyClaimsList);
        /*
        Map<Id, Contact> existingContactsByDailyClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimsList);
        System.debug('In Contact_Drugs:process: existingContactsByDailyClaimId Count: ' + existingContactsByDailyClaimId.size());
        System.debug('In Contact_Drugs:process: existingContactsByDailyClaimId = ' + existingContactsByDailyClaimId);
        */
        //Get csaByDailyClaimId to determine Pre/Post-Go-Live
        for(Daily_Claim__c dailyClaimRecord : dailyClaimsList){
            HCPCSCodeTrunc = dailyClaimRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            J_Code_IdSet.add(HCPCSCodeTrunc);
            //dailyClaimIdByCSANumber.put(dailyClaimRecord.CSA_Number__c, dailyClaimRecord.Id);
            csaNumberByDailyClaimId.put(dailyClaimRecord.Id, dailyClaimRecord.CSA_Number__c);
            //get all Daily Claim Contact matching Sha1Had_Ids
            sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
                    dailyClaimRecord.Patient_CUMB_ID__c + '-'
                            + dailyClaimRecord.Patient_Birth_Date__c + '-'
                            + dailyClaimRecord.Patient_First_Name__c + '-'
                            + dailyClaimRecord.Patient_Last_Name__c
            );

            //On certain scenarios, Aetna sends the claim for Reprocessing & sends a Replacement claim with a new claim number from ACAS system to Prudent.
            // Since these claims are linked to each other our call center should be able to use the existing case for the new claim.

            //Collect all Replacement claims by UCKID
            //The original UCK ID on the replacement claim will contain the value of a claim ID for an existing claim (Use for matching).
            //  1. On the Initial claim, UCK ID will be “Blank”
            //  2. On the Replacement claim, UCK ID will be present & we need to use this UCK ID and run a match with the Initial Claim ID.
            if(dailyClaimRecord.Previous_Claim__c != null) {
                replacementClaimByUCKID.put(dailyClaimRecord.Previous_Claim__c, dailyClaimRecord.Id);
            }
            contactSHA1HashIdSet.add(sha1Hash_Id);
            System.debug('sha1Hash_Id = ' + sha1Hash_Id);
        }
        System.debug('replacementClaimByUCKID = ' + replacementClaimByUCKID);

        DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
        List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(J_Code_IdSet);
        for(Drug__c drugRecord : drugList) {
            //HCPCSCodeTrunc = drugRecord.J_Code__c.substring(0, maxHCPCSCodeSize);
            drugByHCPCS.put( drugRecord.J_Code__c, drugRecord);
            drugById.put(drugRecord.Id, drugRecord);
            System.debug('drugRecord.J_Code__c = ' +  drugRecord.J_Code__c);
        }

        NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
        List<NDC__c> ndcList =  ndcsSelector.selectByDrugId(drugById.keySet());

        for(NDC__c ndcRecord : ndcList) {
            //HCPCSCodeTrunc = ndcRecord.Drug__r.J_Code__c.substring(0, maxHCPCSCodeSize);
            System.debug('ndcRecord.Drug__r.J_Code__c = ' + ndcRecord.Drug__r.J_Code__c);
            System.debug('ndcRecord.Name = ' + ndcRecord.Name);
            drugIdByNDC.put(ndcRecord.Name, ndcRecord.Drug__c);
        }
        /*
        ContactsSelector contactsSelector = (ContactsSelector) PMd_Application.Selector.newInstance(Contact.SObjectType);
        existingSha1Hash_IdMatchedContactsList = contactsSelector.selectBySHA1Hash_ID(contactSHA1HashIdSet);
        System.debug('existingSha1Hash_IdMatchedContactsList Count: ' + existingSha1Hash_IdMatchedContactsList.size());

        //for(Contact contactRecord : existingSha1Hash_IdMatchedContactsList) {
        for(Contact contactRecord : existingContactsByDailyClaimId.values()) {
            existingContactIdSet.add(contactRecord.Id);
            System.debug('contactRecord = ' + contactRecord);
        }
        */
        //Query all Contact_Drugs by the Contact & HCPCS_Code. I don't think this is needed as I am getting all existing claims for the Contacts associated with these Daily Claims
        //Contact_Drug__c contact_DrugRecord = contact_DrugByClaim_InformationId.get(claimRecord.Id);
        /*
        Contact_DrugsSelector contact_DrugsSelector = (Contact_DrugsSelector)PMd_Application.Selector.newInstance(Contact_Drug__c.SObjectType);
        List<Contact_Drug__c> existingContact_DrugsList = contact_DrugsSelector.selectByJ_CodeIdContactId(J_Code_IdSet, existingContactIdSet);
        */
        System.debug('In DailyClaim process: existingContact_DrugsList Count: ' + existingContact_DrugsList.size());

        for(Contact_Drug__c existingContact_Drug : existingContact_DrugsList) {
            System.debug('existingContact_Drug.HCPCS_Code__c = ' + existingContact_Drug.HCPCS_Code__c);
            //HCPCSCodeTrunc = existingContact_Drug.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            contact_DrugByClaim_InformationId.put(existingContact_Drug.Claim_Information__c, existingContact_Drug);
            contact_DrugByHCPCS_Code.put(HCPCSCodeTrunc, existingContact_Drug);
            contact_DrugByContactId.put(existingContact_Drug.Contact__c, existingContact_Drug);
            System.debug('existingContact_Drug.Claim_Information__c = ' + existingContact_Drug.Claim_Information__c);
            System.debug('existingContact_Drug.HCPCS_Code__c = ' + existingContact_Drug.HCPCS_Code__c);
            System.debug('existingContact_Drug.Contact__c = ' + existingContact_Drug.Contact__c);
        }

        System.debug('existingContact_DrugList Count = ' + existingContact_DrugsList.size());

        //Get Map of CSAs By CSA_Number
        List<CSA__c> csaList = new List<CSA__c>();
        ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
        //csaByDailyClaimId = cSAsDomain.getCSAsById(dailyClaimIdByCSANumber);
        csasByCSA_Number = cSAsDomain.getCSAsByCSANumber(csaNumberByDailyClaimId);
        System.debug('csaByDailyClaimId = ' +csaByDailyClaimId);
        /*
        Claim processing logic:
            Rule: Only “Original” Claim Indicators will create new Reimbursement Cases.
                This should be addressed via the matching logic below.
            Look for an existing Claim based on unique key (Example here)
                Claim ID
                If Claim Previous Segment populated:
                    Then Previous Segment
                    Else Claim Segment
                Claim Line Identifier
         */

        //Get all Daily_Claim Primary_Claim_Numbers
        //Get all Daily_Claim claim_Segments
        //Get all Daily_Claim Claim_Lines
        //Get all Daily_Claim previous_Segments
        for(Daily_Claim__c dailyClaim : dailyClaimsList) {
            System.debug('dailyClaim.Primary_Claim_Number__c = ' +dailyClaim.Primary_Claim_Number__c);
            System.debug('dailyClaim.Claim_Segment__c = ' + dailyClaim.Claim_Segment__c);
            System.debug('dailyClaim.Claim_Line__c = ' + dailyClaim.Claim_Line__c);
            System.debug('dailyClaim.Previous_Segment__c = ' + dailyClaim.Previous_Segment__c);
            System.debug('dailyClaim.Claim_Number__c = ' + dailyClaim.Claim_Number__c);

            primary_Claim_NumberSet.add(dailyClaim.Primary_Claim_Number__c);
            claim_SegmentSet.add(dailyClaim.Claim_Segment__c);
            claim_LineSet.add(dailyClaim.Claim_Line__c);
            previous_SegmentSet.add(dailyClaim.Previous_Segment__c);

            if(dailyClaim.Previous_Segment__c == null
                    || dailyClaim.Previous_Segment__c == '') {
                claim_NumberSeed = dailyClaim.Primary_Claim_Number__c + '-' +
                        dailyClaim.Claim_Segment__c + '-' +
                        dailyClaim.Claim_Line__c;
            } else {
                claim_NumberSeed = dailyClaim.Primary_Claim_Number__c + '-' +
                        dailyClaim.Previous_Segment__c + '-' +
                        dailyClaim.Claim_Line__c;
                newPrevious_SegmentByClaimId.put(dailyClaim.Id, dailyClaim.Previous_Segment__c);
            }

            //claim_NumberSeed = dailyClaim.Claim_Number__c;
            System.debug('claim_NumberSeed = ' +claim_NumberSeed);
            String claim_NumberHashCode = SHA1UtilService.getBase64SHA1Hash(claim_NumberSeed);
            System.debug('claim_NumberHashCode = ' + claim_NumberHashCode);
            claim_NumberByDailyClaimId.put(dailyClaim.Id, claim_NumberHashCode);
            claim_NumberSet.add(claim_NumberHashCode);
        }
        System.debug('claim_NumberByDailyClaimId = ' +claim_NumberByDailyClaimId);

        //Get matching existing Claims from Daily Claims
        Claim_InformationsSelector claim_InformationsSelector = (Claim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);
        originalClaim_InformationList = claim_InformationsSelector.selectOriginalClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet);
        //existingClaim_InformationList = claim_InformationsSelector.selectExistingClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet, Previous_SegmentSet);
        existingClaim_InformationList = claim_InformationsSelector.selectExistingClaimsByUniquekey(claim_NumberSet);
        //Collect matching existing Claims that will be replaced with Replacement claims
        existingClaimToBeReplacedList = claim_InformationsSelector.selectExistingClaimsByUCKID(replacementClaimByUCKID.keySet());
        allClaim_InformationList.addAll(originalClaim_InformationList);
        allClaim_InformationList.addAll(existingClaim_InformationList);
        //allClaim_InformationList.addAll(existingClaimToBeReplacedList);
        System.debug('originalClaim_InformationList Count: ' + originalClaim_InformationList.size());
        System.debug('existingClaim_InformationList Count: ' + existingClaim_InformationList.size());
        System.debug('existingClaimToBeReplacedList Count: ' + existingClaimToBeReplacedList.size());
        System.debug('In Claim_Informations:process - allClaim_InformationList Count: ' + allClaim_InformationList.size());

        for (Claim_Information__c claimRecord : allClaim_InformationList) {
            claimById.put(claimRecord.Id, claimRecord);
            claimByContact_DrugId.put(claimRecord.Contact_Drug__c, claimRecord);
            //claimByClaim_Number.put(claimRecord.Claim_Number__c, claimRecord);
            //if(claimRecord.Current_Claim_Number__c != null) {
            //    claimByClaim_Number.put(claimRecord.Current_Claim_Number__c, claimRecord);
            //} else {
            claimByClaim_Number.put(claimRecord.Claim_Number__c, claimRecord);
            //}
            //claimByHCPS.put(claimRecord.HCPCS_Code__c, claimRecord);
            /*
            for(Daily_Claim__c dailyClaim : dailyClaimsList) {
                if(dailyClaim.Previous_Segment__c == null
                        || dailyClaim.Previous_Segment__c == '') {
                    claim_NumberSeed = dailyClaim.Primary_Claim_Number__c + '-' +
                            dailyClaim.Claim_Segment__c + '-' +
                            dailyClaim.Claim_Line__c;
                } else {
                    claim_NumberSeed = dailyClaim.Primary_Claim_Number__c + '-' +
                            dailyClaim.Previous_Segment__c + '-' +
                            dailyClaim.Claim_Line__c;
                    newPrevious_SegmentByClaimId.put(dailyClaim.Id, dailyClaim.Previous_Segment__c);
                }

                //claim_NumberSeed = dailyClaim.Claim_Number__c;
                System.debug('claim_NumberSeed = ' +claim_NumberSeed);
                String claim_NumberHashCode = SHA1UtilService.getBase64SHA1Hash(claim_NumberSeed);
                System.debug('claim_NumberHashCode = ' + claim_NumberHashCode);
                //Because the Claim_number on the Claim will change state only when updated, the claims after segment 01 will not be
                //added to the claimByClaim_Number mapping. We'll need to add them here.
                Claim_Information__c claimAfterSeg02 = claimByClaim_Number.get(claim_NumberByDailyClaimId.get(dailyClaim.Id));
                if(dailyClaim.Primary_Claim_Number__c == claimRecord.Primary_Claim_Number__c
                        && claimAfterSeg02 == null) {
                    claimByClaim_Number.put(dailyClaim.Claim_Number__c, claimRecord);
                }
            }
            */
        }

        for (Claim_Information__c claimRecord : existingClaimToBeReplacedList) {
            claimIdToBeRelplacedByPrevious_Claim.put(claimRecord.Primary_Claim_Number__c, claimRecord);
        }

        System.debug('claimByClaim_Number = ' + claimByClaim_Number);
        //System.debug('claimByHCPS = ' + claimByHCPS);
        System.debug('claimIdToBeRelplacedByPrevious_Claim = ' + claimIdToBeRelplacedByPrevious_Claim);

        //Get matching Cases from Daily Claims
        CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
        List<Case> existingEnrollmentCaseList = casesSelector.selectEnrollmentCaseByClaimId(claimById.keySet());
        List<Case> existingReimbursementCaseList = casesSelector.selectReimbursementCaseByClaimId(claimById.keySet());
        //List<Case> existingReplacementCaseList = casesSelector.selectReplacementCaseByClaimId(claimIdToBeRelplacedByPrevious_Claim.keySet());
        //System.debug('existingReplacementCaseList = ' + existingReplacementCaseList);

        //Map existing Enrollment Cases by their Claim ID
        for(Case existingEnrollmentCase : existingEnrollmentCaseList) {
            if(existingEnrollmentCase.Claim_Information__c != null) {
                existingEnrollmentCaseByClaimId.put(existingEnrollmentCase.Claim_Information__c, existingEnrollmentCase);
            }
        }

        //Map existing Reimbursement Cases by their Claim ID
        for(Case existingReimbursementCase : existingReimbursementCaseList) {
            if(existingReimbursementCase.Claim_Information__c != null) {
                existingReimbursementCaseByClaimId.put(existingReimbursementCase.Claim_Information__c, existingReimbursementCase);
            }
        }
        /*
        //Map existing list of Replacement Cases for each Claim by their Claim ID
        List<Case> existingReplacementClaimCaseList;
        String claimNumber;
        for(Case existingReplacementCase : existingReplacementCaseList) {
            if(existingReplacementCase.Claim_Information__c != null) {
                claimNumber = claimIdToBeRelplacedByPrevious_Claim.get(existingReplacementCase.Claim_Number__c);
                if(existingReplacementCaseListsByPreviousClaim.get(claimNumber) == null) {
                    existingReplacementClaimCaseList = new List<Case>();
                    existingReplacementClaimCaseList.add(existingReplacementCase);
                    existingReplacementCaseListsByPreviousClaim.put(claimNumber, existingReplacementClaimCaseList);
                } else {
                    existingReplacementClaimCaseList = existingReplacementCaseListsByPreviousClaim.get(claimNumber);
                    existingReplacementClaimCaseList.add(existingReplacementCase);
                    existingReplacementCaseListsByPreviousClaim.put(claimNumber, existingReplacementClaimCaseList);
                }
            }
        }
        System.debug('existingReplacementCaseListsByPreviousClaim = ' + existingReplacementCaseListsByPreviousClaim);
        */

        for(Daily_Claim__c dailyClaim : dailyClaimsList) {
            //relatedDrug = drugByHCPCS.get(dailyClaim.HCPCS_Code__c);
            HCPCSCodeTrunc = dailyClaim.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            relatedDrug = drugById.get(drugIdByNDC.get(dailyClaim.NDC__c));
            if(relatedDrug == null) {
                relatedDrug = drugByHCPCS.get(HCPCSCodeTrunc);
            } else if(relatedDrug.Coding_Level__c == 'HCPCS') {
                relatedDrug = drugByHCPCS.get(HCPCSCodeTrunc);
            }
            System.debug('relatedDrug = ' + relatedDrug);

            System.debug('claim_NumberByDailyClaimId.get(dailyClaim.Id) = ' + claim_NumberByDailyClaimId.get(dailyClaim.Id));
            System.debug('claimByClaim_Number = ' + claimByClaim_Number);
            Claim_Information__c claimRecord = claimByClaim_Number.get(claim_NumberByDailyClaimId.get(dailyClaim.Id));
            //contact_DrugRecord = contact_DrugByHCPCS_Code.get(dailyClaim.HCPCS_Code__c);
            Contact existingContact = existingContactsByDailyClaimId.get(dailyClaim.Id);
            contact_DrugRecord = contact_DrugByContactId.get(existingContact.Id);
            System.Debug('contact_DrugRecord = ' + contact_DrugRecord);
            //System.debug('claim_NumberByDailyClaimId = ' + claim_NumberByDailyClaimId);
            //System.debug('claimByClaim_Number = ' + claimByClaim_Number);
            //System.debug('claimRecord = ' + claimRecord);
            //If Claim unique key does not exist for the ContactDrug:
            //CSA__c csaRecord = csaByDailyClaimId.get(dailyClaim.Id);
            CSA__c csaRecord = csasByCSA_Number.get(dailyClaim.CSA_Number__c);
            Date goLiveDate = csaRecord.Implementation__r.Contract__r.Go_Live_Date__c;

            //Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
            //if(contact_DrugRecord == null && claimByHCPS.get(dailyClaim.HCPCS_Code__c) == null) {
            System.Debug('claimRecord = ' + claimRecord);
            //System.Debug('claimByHCPS.get(dailyClaim.HCPCS_Code__c) = ' + claimByHCPS.get(dailyClaim.HCPCS_Code__c));
            System.Debug('dailyClaim.Previous_Segment__c = ' + dailyClaim.Previous_Segment__c);

            Claim_Information__c claimToBeReplaced = claimIdToBeRelplacedByPrevious_Claim.get(dailyClaim.Previous_Claim__c);

            if(claimRecord == null
                    && String.isBlank(dailyClaim.Previous_Segment__c) //Avoid any orphan Claims when daily claim attempting to update a claim & the member had no initial claim where Previous_Segment was null
                    || (dailyClaim.Claim_Code__c == 'O'
                        && dailyClaim.Previous_Segment__c =='00'
                        && dailyClaim.Claim_Segment__c == '01') //MED-1853: Ingest New Claims with O Status and 01 Segment if they have 00 previous segment as new claims
            ) {
                System.debug('Create new claim.');
                //Create Daily Claim for each Claim record. The related Claim, Segment, and Line will be shown from the
                //     Done OnBeforeInsert Trigger below
                Claim_Information__c newClaim = new Claim_Information__c();
                newClaim = mapDailyClaimToClam(dailyClaim, newClaim);
                newClaim.Drug__c = relatedDrug.Id;
                if(contact_DrugRecord != null) {
                    newClaim.Contact_Drug__c = contact_DrugRecord.Id;
                    newClaim.Contact__c = contact_DrugRecord.Contact__c;
                }
                newClaim.Current_Claim_Number__c = dailyClaim.Claim_Number__c;

                //    contact_DrugRecord.Claim_Information__c = newClaim.Id;

                /*
                //Check if this is a Replacement Claim
                if(dailyClaim.Previous_Claim__c != null) {
                    //Once an existing Claim Matches this Replacement Claim, then we need to link the old case number to this new (Replacement) claim.
                    System.Debug('claimRecord.Previous_Claim__c = ' + claimRecord.Previous_Claim__c);
                    existingReplacementClaimCaseList = existingReplacementCaseListsByPreviousClaim.get(dailyClaim.Previous_Claim__c);
                    for(Case existingReplacementCase : existingReplacementCaseList) {
                        existingReplacementCase.Claim_Information__c = claimRecord.Id;
                        existingReplacementClaimCasesList.add(existingReplacementCase);
                    }
                }
                existingClaimList.add(claimRecord);
                */
                newClaimList.add(newClaim);
                allClaim_InformationList.add(newClaim);
                // Daily Claims related list (bottom section of this Claim).
                //  Done in Claim_Information onAfterTrigger below
                //dailyClaim.Claim_Information__c = newClaim.Id;
/*
                //Pre go-live
                if (System.today() < goLiveDate) {
                    //Then create Enrollment Case.
                    //  Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
                    enrollmentCase = new Case();
                    enrollmentCase.Claim_Information__c = newClaim.Id;
                    enrollmentCase.Type = 'Enrollment';
                    enrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
                    if(contact_DrugRecord != null) {
                        enrollmentCase.Contact_Drug__c = contact_DrugRecord.Id;
                    }
                    enrollmentCase = mapDailyClaimToCase(dailyClaim, enrollmentCase);
                    newEnrollmentCaseList.add(enrollmentCase);
                } else { //Post go-live
                    //Then create Enrollment Case and Reimbursement Case.
                    //   Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
                    enrollmentCase = new Case();
                    enrollmentCase.Claim_Information__c = newClaim.Id;
                    enrollmentCase.Type = 'Enrollment';
                    enrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
                    enrollmentCase = mapDailyClaimToCase(dailyClaim, enrollmentCase);
                    if(contact_DrugRecord != null) {
                        enrollmentCase.Contact_Drug__c = contact_DrugRecord.Id;
                    }
                    newEnrollmentCaseList.add(enrollmentCase);
                    //Create  Reimbursement Case.
                    reimbursementCase = new Case();
                    reimbursementCase.Claim_Information__c = newClaim.Id;
                    reimbursementCase.Type = 'Reimbursement';
                    reimbursementCase.RecordTypeId = reimbursementCaseInfo.getRecordTypeId();
                    if(contact_DrugRecord != null) {
                        reimbursementCase.Contact_Drug__c = contact_DrugRecord.Id;
                    }
                    reimbursementCase = mapDailyClaimToCase(dailyClaim, reimbursementCase);
                    newReimbursementCaseList.add(reimbursementCase);
                }
                */
            //Check if this is a Replacement Claim
            } else if (claimRecord != null) { // if (dailyClaim.Previous_Claim__c == null) {
                System.debug('Update existing claim.');
                //If Claim unique key does exist for the ContactDrug:
                //   Then update existing Claim record with new data.
                //System.Debug('claimRecord = ' + claimRecord);
                //if (claimRecord != null) {historicalClaim
                System.Debug('claimRecord = ' + claimRecord);
                claimRecord = mapDailyClaimToClam(dailyClaim, claimRecord);
                claimRecord.Drug__c = relatedDrug.Id;
                claimRecord.Contact_Drug__c = contact_DrugRecord.Id;
                claimRecord.Contact__c = contact_DrugRecord.Contact__c;
                claimRecord.Current_Claim_Number__c = dailyClaim.Claim_Number__c;
                claimRecord.Previous_Segment__c = dailyClaim.Previous_Segment__c;
                //MBP-907: Claim Status equals "Adjustment" and the claim doesn’t have a CPA Indicator or a CPA amount. - Error Log Description "Claim Adjustment error"
                if(claimRecord.Claim_Status__c == 'Adjustment'
                && (claimRecord.CPA_Indicator__c == null
                || claimRecord.CPA_Funds_Paid__c == null)) {
                    ErrorLog.log('Claim_Informations:Processing Daily_Claims', '', '', '', '', 'Claim Adjustment Error', dailyClaim.Id, null, null, null);
                    ErrorLog.commitLogs();
                }
                //MBP-907: Claim Status equals "Adjustment" where the Claim Adjustment Amount does not match the CPA Funds Paid - Error Log Description "CPA Paid Amount Mismatch."
                if(claimRecord.Claim_Status__c == 'Adjustment'
                        && claimRecord.Claim_Adjustment_Amount__c != claimRecord.CPA_Funds_Paid__c) {
                    ErrorLog.log('Claim_Informations:Processing Daily_Claims', '', '', '', '', 'CPA Paid Amount Mismatch',  dailyClaim.Id, null, null, null);
                    ErrorLog.commitLogs();
                }
                existingClaimList.add(claimRecord);
                allClaim_InformationList.add(claimRecord);
                //}
            }
            //Check if this is a Replacement Claim
            //*** Because the Replacement Daily Claim will be a new claim, it will be created above as a new claim & this code will never run ***////
            //*** Because the change has passed QA, I'll leave it in for now ***//
            /*
            } else if (dailyClaim.Previous_Claim__c != null && claimIdToBeRelplacedByPrevious_Claim.get(dailyClaim.Previous_Claim__c) != null) {
                //Once an existing Claim Matches this Replacement Claim, then create the new (Replacement) claim.
                System.debug('Create new replacement claim.');
                System.Debug('claimToBeReplaced.Previous_Claim__c = ' + claimToBeReplaced.Previous_Claim__c);
                //Create Daily Claim for each Claim record. The related Claim, Segment, and Line will be shown from the
                Claim_Information__c newClaim = new Claim_Information__c();
                newClaim = mapDailyClaimToClam(dailyClaim, newClaim);
                newClaim.Drug__c = relatedDrug.Id;
                newClaim.Contact_Drug__c = claimToBeReplaced.Contact_Drug__c;
                newClaim.Current_Claim_Number__c = dailyClaim.Claim_Number__c;
                newClaimList.add(newClaim);
            }
            */
        }

        uow.registerNew(newClaimList);
        uow.registerDirty(existingClaimList);
        //uow.registerDirty(existingReplacementClaimCasesList);
        /*
        uow.registerDirty(existingContact_DrugList);
        uow.registerDirty(existingReimbursementCaseList);
        uow.registerNew(newEnrollmentCaseList);
        uow.registerNew(newReimbursementCaseList);
*/
        System.debug('In Claim_Informations:process - allClaim_InformationList Count: ' + allClaim_InformationList.size());

        System.debug('In Claim_Informations:process - Stop processing Claim_Information for Daily Claims');

        return allClaim_InformationList;

    }

    /*
Summary

The next step in Historical claims is to create or update claims.

Requirements
Claim processing logic:
    Rule: Only “Original” Claim Indicators will create new Reimbursement Cases.
        This should be addressed via the matching logic below.
    Look for an existing Claim based on unique key (Example here)
        Claim ID
        If Claim Previous Segment populated:
            Then Previous Segment
            Else Claim Segment
        Claim Line Identifier
    If Claim unique key does not exist for the ContactDrug:
        Create Daily Claim for each Claim record. The related Claim, Segment, and Line will be shown from the Daily Claims related list (bottom section of this Claim).
        Pre go-live
            Then create Enrollment Case.
                Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
        Post go-live
            Then create Enrollment Case and Reimbursement Case.
                Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
    If Claim unique key does exist for the ContactDrug:
        Then update existing Claim record with new data.
        The old Claim, Segment, and Line will be shown from the Daily Claims related list (bottom section of this Claim).
        If Enrollment Case already exists:
            Then do not create a new Enrollment Case.
        If Reimbursement Case already exists:
            Then do not create a new Reimbursement Case.
            If Case is closed, then reopen Case.
            If Case is open, then flag case as “Rework Needed.”
            Acceptance Criteria
            If unique claim key exists then update claim else create a new claim.
 */
    public List<Claim_Information__c> process(List<Historical_Claim__c> historicalClaimsList,
                                                Map<Id, Contact> existingContactsByHistoricalClaimId,
                                                List<Contact_Drug__c> existingContact_DrugsList,
                                                fflib_ISObjectUnitOfWork uow)
    {
        System.debug('In Claim_Informations:process - Start processing Claim_Information for Historical Claims');

        // Create Claims from the given Historical Claims
        List<SObject> newClaimList = new List<SObject>();
        List<SObject> existingClaimList = new List<SObject>();
        List<SObject> existingContact_DrugList = new List<SObject>();
        List<SObject> newEnrollmentCaseList = new List<SObject>();
        List<SObject> newReimbursementCaseList = new List<SObject>();

        Set<String> primary_Claim_NumberSet = new Set<String>();
        Set<String> claim_SegmentSet = new Set<String>();
        Set<String> claim_LineSet = new Set<String>();
        Set<String> previous_SegmentSet = new Set<String>();
        List<Claim_Information__c> originalClaim_InformationList;
        List<Claim_Information__c> existingClaim_InformationList;
        List<Claim_Information__c> allClaim_InformationList = new List<Claim_Information__c>();
        Map<String, Id> historicalClaimIdByCSANumber = new Map<String, Id>();
        Map<Id, String> csaNumberByHistoricalClaimId = new Map<Id, String>();
        Map<Id, CSA__c> csaByDailyClaimId = new Map<Id, CSA__c>();
        Map<String, CSA__c> csasByCSA_Number = new Map<String, CSA__c>();
        Map<Id, Claim_Information__c> claimByContact_DrugId = new Map<Id, Claim_Information__c>();
        Map<Id, Claim_Information__c> claimById = new Map<Id, Claim_Information__c>();
        Map<Id, String> claim_NumberByHistoricalClaimId = new Map<Id, String>();
        Map<String, Claim_Information__c> claimByClaim_Number = new Map<String, Claim_Information__c>();
        Map<Id, Contact_Drug__c> contact_DrugByClaim_InformationId = new Map<Id, Contact_Drug__c>();
        Map<Id, Contact_Drug__c> contact_DrugByContactId = new Map<Id, Contact_Drug__c>();
        Case enrollmentCase, reimbursementCase;
        Map<Id, Case> existingEnrollmentCaseByClaimId = new Map<Id, Case>();
        Map<Id, Case> existingReimbursementCaseByClaimId = new Map<Id, Case>();
        //Map<String, Claim_Information__c> claimByHCPS = new Map<String, Claim_Information__c>();
        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
        Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');
        Schema.RecordTypeInfo reimbursementCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');
        String sha1Hash_Id;
        Set<String> J_Code_IdSet = new Set<String>();
        Set<String> NDCSet = new Set<String>{''};
        Set<String> contactSHA1HashIdSet = new Set<String>();
        Set<Id> existingContactIdSet = new Set<Id>();
        Contact_Drug__c contact_DrugRecord;
        Map<String, Contact_Drug__c> contact_DrugByHCPCS_Code = new Map<String, Contact_Drug__c>();
        List<Contact> existingSha1Hash_IdMatchedContactsList;
        String claim_NumberSeed,HCPCSCodeTrunc;
        Map<String, Drug__C> drugByHCPCS = new Map<String, Drug__c>();
        Map<String, Id> drugIdByNDC = new Map<String, Id>();
        Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
        Drug__c relatedDrug;

        System.debug('historicalClaimsList Count = ' + historicalClaimsList.size());

        for(Historical_Claim__c historicalClaimRecord : historicalClaimsList){
            HCPCSCodeTrunc = historicalClaimRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            J_Code_IdSet.add(HCPCSCodeTrunc);
            //NDCSet.add(historicalClaimRecord.NDC__c);
            //historicalClaimIdByCSANumber.put(historicalClaimRecord.CSA_Number__c, historicalClaimRecord.Id);
            csaNumberByHistoricalClaimId.put(historicalClaimRecord.Id, historicalClaimRecord.CSA_Number__c);
            //get all Historical Claim Contact matching Sha1Had_Ids
            sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
                    historicalClaimRecord.Patient_CUMB_ID__c + '-'
                            + historicalClaimRecord.Patient_Birth_Date__c + '-'
                            + historicalClaimRecord.Patient_First_Name__c + '-'
                            + historicalClaimRecord.Patient_Last_Name__c
            );
            contactSHA1HashIdSet.add(sha1Hash_Id);
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

        //If drug Coding Level is HCPCS than we only use the HCPCS to identify the drug
        //If drug Coding Level is HCPCS + NDC we Need include the NDC as part of the key to identify the Drug
        for(Historical_Claim__c historicalClaimClaim : historicalClaimsList) {
            HCPCSCodeTrunc = historicalClaimClaim.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            Drug__c drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
            if(drugRecord.Coding_Level__c == 'HCPCS + NDC') {
                NDCSet.add(historicalClaimClaim.NDC__c);
                System.debug('historicalClaimClaim.NDC__c = ' + historicalClaimClaim.NDC__c);
            }
        }
        System.debug('J_Code_IdSet = ' + J_Code_IdSet);
        System.debug('NDCSet = ' + NDCSet);

        ContactsSelector contactsSelector = (ContactsSelector) PMd_Application.Selector.newInstance(Contact.SObjectType);
        existingSha1Hash_IdMatchedContactsList = contactsSelector.selectBySHA1Hash_ID(contactSHA1HashIdSet);
        System.debug('existingSha1Hash_IdMatchedContactsList Count: ' + existingSha1Hash_IdMatchedContactsList.size());

        for(Contact contactRecord : existingSha1Hash_IdMatchedContactsList) {
            existingContactIdSet.add(contactRecord.Id);
        }
        System.debug('existingContactIdSet = ' + existingContactIdSet);

        //Query all Contact_Drugs by the Contact & HCPCS_Code. I don't think this is needed as I am getting all exisiting claims for the Contacts associated with these Daily Claims
        //Contact_Drug__c contact_DrugRecord = contact_DrugByClaim_InformationId.get(claimRecord.Id);
        //Contact_DrugsSelector contact_DrugsSelector = (Contact_DrugsSelector)PMd_Application.Selector.newInstance(Contact_Drug__c.SObjectType);
        //List<Contact_Drug__c> existingContact_DrugsList = new List<Contact_Drug__c>();
        //existingContact_DrugsList = contact_DrugsSelector.selectByJ_CodeIdContactId(J_Code_IdSet, NDCSet, existingContactIdSet);

        for(Contact_Drug__c existingContact_Drug : existingContact_DrugsList) {
            //HCPCSCodeTrunc = existingContact_Drug.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            contact_DrugByClaim_InformationId.put(existingContact_Drug.Claim_Information__c, existingContact_Drug);
            contact_DrugByHCPCS_Code.put(existingContact_Drug.HCPCS_Code__c, existingContact_Drug);
            contact_DrugByContactId.put(existingContact_Drug.Contact__c, existingContact_Drug);
            System.debug('existingContact_Drug.Claim_Information__c = ' + existingContact_Drug.Claim_Information__c);
            System.debug('existingContact_Drug.HCPCS_Code__c = ' + existingContact_Drug.HCPCS_Code__c);
            System.debug('existingContact_Drug.Contact__c = ' + existingContact_Drug.Contact__c);
        }

        System.debug('existingContact_DrugList Count = ' + existingContact_DrugsList.size());

        List<CSA__c> csaList = new List<CSA__c>();
        ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
        //csaByDailyClaimId = cSAsDomain.getCSAsById(historicalClaimIdByCSANumber);
        csasByCSA_Number = cSAsDomain.getCSAsByCSANumber(csaNumberByHistoricalClaimId);

        /*
        Claim processing logic:
            Rule: Only “Original” Claim Indicators will create new Reimbursement Cases.
                This should be addressed via the matching logic below.
            Look for an existing Claim based on unique key (Example here)
                Claim ID
                If Claim Previous Segment populated:
                    Then Previous Segment
                    Else Claim Segment
                Claim Line Identifier
         */

        //Get all Historical_Claim Primary_Claim_Numbers
        //Get all Historical_Claim claim_Segments
        //Get all Historical_Claim Claim_Lines
        //Get all Historical_Claim previous_Segments
        for(Historical_Claim__c historicalClaim : historicalClaimsList) {
            System.debug('historicalClaim.Primary_Claim_Number__c = ' +historicalClaim.Primary_Claim_Number__c);
            //System.debug('historicalClaim.Claim_Segment__c = ' + historicalClaim.Claim_Segment__c);

            primary_Claim_NumberSet.add(historicalClaim.Primary_Claim_Number__c);
            //claim_SegmentSet.add(historicalClaim.Claim_Segment__c);
            claim_LineSet.add(historicalClaim.Claim_Line__c);
            //previous_SegmentSet.add(historicalClaim.Previous_Segment__c);

            //if(dailyClaim.Previous_Segment__c == null || dailyClaim.Previous_Segment__c == '') {
                claim_NumberSeed = historicalClaim.Primary_Claim_Number__c + '-' +
                        //historicalClaim.Claim_Segment__c + '-' +
                        historicalClaim.Claim_Line__c;
            /*
            } else {
                claim_NumberSeed = dailyClaim.Primary_Claim_Number__c +
                        dailyClaim.Previous_Segment__c +
                        dailyClaim.Claim_Line__c;
            }
            */
            String claim_NumberHashCode =  SHA1UtilService.getBase64SHA1Hash(claim_NumberSeed);
            claim_NumberByHistoricalClaimId.put(historicalClaim.Id, claim_NumberHashCode);
        }
        System.debug('claim_NumberByHistoricalClaimId = ' +claim_NumberByHistoricalClaimId);

        //Get matching existing Claims from Historical Claims
        Claim_InformationsSelector claim_InformationsSelector = (Claim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);
        originalClaim_InformationList = claim_InformationsSelector.selectOriginalClaimsByUniquekey(Primary_Claim_NumberSet, Claim_LineSet);
        //existingClaim_InformationList = originalClaim_InformationList; //claim_InformationsSelector.selectExistingClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet);
        allClaim_InformationList.addAll(originalClaim_InformationList);
        //allClaim_InformationList.addAll(existingClaim_InformationList);
        System.debug('originalClaim_InformationList Count: ' + originalClaim_InformationList.size());
        //System.debug('existingClaim_InformationList Count: ' + existingClaim_InformationList.size());
        System.debug('allClaim_InformationList Count: ' + allClaim_InformationList.size());

        for (Claim_Information__c claimRecord : allClaim_InformationList) {
            claimById.put(claimRecord.Id, claimRecord);
            claimByContact_DrugId.put(claimRecord.Contact_Drug__c, claimRecord);
            claimByClaim_Number.put(claimRecord.Claim_Number__c, claimRecord);
            //claimByHCPS.put(claimRecord.HCPCS_Code__c, claimRecord);
        }
        System.debug('claimByClaim_Number = ' + claimByClaim_Number);
        //System.debug('claimByHCPS = ' + claimByHCPS);

        //Get matching Cases from Historical Claims
        CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
        List<Case> existingEnrollmentCaseList = casesSelector.selectEnrollmentCaseByClaimId(claimById.keySet());
        List<Case> existingReimbursementCaseList = casesSelector.selectReimbursementCaseByClaimId(claimById.keySet());

        for(Case existingEnrollmentCase : existingEnrollmentCaseList) {
            if(existingEnrollmentCase.Claim_Information__c != null) {
                existingEnrollmentCaseByClaimId.put(existingEnrollmentCase.Claim_Information__c, existingEnrollmentCase);
            }
        }

        for(Case existingReimbursementCase : existingReimbursementCaseList) {
            if(existingReimbursementCase.Claim_Information__c != null) {
                existingReimbursementCaseByClaimId.put(existingReimbursementCase.Claim_Information__c, existingReimbursementCase);
            }
        }

        for(Historical_Claim__c historicalClaim : historicalClaimsList) {
            //relatedDrug = drugByHCPCS.get(historicalClaim.HCPCS_Code__c);
            HCPCSCodeTrunc = historicalClaim.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
            relatedDrug = drugById.get(drugIdByNDC.get(historicalClaim.NDC__c));
            if(relatedDrug == null) {
                relatedDrug = drugByHCPCS.get(HCPCSCodeTrunc);
            } else if(relatedDrug.Coding_Level__c == 'HCPCS') {
                relatedDrug = drugByHCPCS.get(HCPCSCodeTrunc);
            }
            System.debug('relatedDrug = ' + relatedDrug);

            System.debug('claim_NumberByDailyClaimId.get(historicalClaim.Id) = ' + claim_NumberByHistoricalClaimId.get(historicalClaim.Id));
            System.debug('claimByClaim_Number = ' + claimByClaim_Number);
            Claim_Information__c claimRecord = claimByClaim_Number.get(claim_NumberByHistoricalClaimId.get(historicalClaim.Id));
            System.debug('existingContactsByHistoricalClaimId = ' + existingContactsByHistoricalClaimId);
            Contact existingContact = existingContactsByHistoricalClaimId.get(historicalClaim.Id);
            System.debug('existingContact = ' + existingContact);
            //contact_DrugRecord = contact_DrugByHCPCS_Code.get(HCPCSCodeTrunc);
            contact_DrugRecord = contact_DrugByContactId.get(existingContact.Id);
            System.Debug('contact_DrugRecord = ' + contact_DrugRecord);
            //System.debug('claim_NumberByDailyClaimId = ' + claim_NumberByDailyClaimId);
            //System.debug('claimByClaim_Number = ' + claimByClaim_Number);
            //System.debug('claimRecord = ' + claimRecord);
            //If Claim unique key does not exist for the ContactDrug:
            //CSA__c csaRecord = csaByDailyClaimId.get(historicalClaim.Id);
            CSA__c csaRecord = csasByCSA_Number.get(historicalClaim.CSA_Number__c);
            Date goLiveDate = csaRecord.Implementation__r.Contract__r.Go_Live_Date__c;

            //Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
            //if(contact_DrugRecord == null && claimByHCPS.get(dailyClaim.HCPCS_Code__c) == null) {
            //System.Debug('claimRecord = ' + claimRecord);
            //System.Debug('claimByHCPS.get(dailyClaim.HCPCS_Code__c) = ' + claimByHCPS.get(dailyClaim.HCPCS_Code__c));
            System.debug('claimRecord = ' + claimRecord);
            //System.debug('claimByHCPS.get(historicalClaim.HCPCS_Code__c) = ' + claimByHCPS.get(historicalClaim.HCPCS_Code__c));
            //if(claimRecord == null && claimByHCPS.get(historicalClaim.HCPCS_Code__c) == null)
            if(claimRecord == null
                    //&& (historicalClaim.Previous_Segment__c == null) //Avoid any orphan Claims historical claim attempting to update a claim & the member had no inital claim where Previous_Segment was null
                   //|| historicalClaim.Previous_Segment__c == ''
                    ) {
                System.debug('Create new claim.');
                //Create Daily Claim for each Claim record. The related Claim, Segment, and Line will be shown from the
                //     Done OnBeforeInsert Trigger below
                Claim_Information__c newClaim = new Claim_Information__c();
                newClaim = mapHistoricalClaimToClam(historicalClaim, newClaim);
                newClaim.Drug__c = relatedDrug.Id;
                if(contact_DrugRecord != null) {
                    newClaim.Contact_Drug__c = contact_DrugRecord.Id;
                    newClaim.Contact__c = contact_DrugRecord.Contact__c;
                }

                //    contact_DrugRecord.Claim_Information__c = newClaim.Id;

                newClaimList.add(newClaim);
                allClaim_InformationList.add(newClaim);
                // Daily Claims related list (bottom section of this Claim).
                //  Done in Claim_Information onAfterTrigger below
                //dailyClaim.Claim_Information__c = newClaim.Id;
/*
                //Pre go-live
                if (System.today() < goLiveDate) {
                    //Then create Enrollment Case.
                    //  Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
                    enrollmentCase = new Case();
                    enrollmentCase.Claim_Information__c = newClaim.Id;
                    enrollmentCase.Type = 'Enrollment';
                    enrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
                    if(contact_DrugRecord != null) {
                        enrollmentCase.Contact_Drug__c = contact_DrugRecord.Id;
                    }
                    enrollmentCase = mapDailyClaimToCase(dailyClaim, enrollmentCase);
                    newEnrollmentCaseList.add(enrollmentCase);
                } else { //Post go-live
                    //Then create Enrollment Case and Reimbursement Case.
                    //   Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
                    enrollmentCase = new Case();
                    enrollmentCase.Claim_Information__c = newClaim.Id;
                    enrollmentCase.Type = 'Enrollment';
                    enrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
                    enrollmentCase = mapDailyClaimToCase(dailyClaim, enrollmentCase);
                    if(contact_DrugRecord != null) {
                        enrollmentCase.Contact_Drug__c = contact_DrugRecord.Id;
                    }
                    newEnrollmentCaseList.add(enrollmentCase);
                    //Create  Reimbursement Case.
                    reimbursementCase = new Case();
                    reimbursementCase.Claim_Information__c = newClaim.Id;
                    reimbursementCase.Type = 'Reimbursement';
                    reimbursementCase.RecordTypeId = reimbursementCaseInfo.getRecordTypeId();
                    if(contact_DrugRecord != null) {
                        reimbursementCase.Contact_Drug__c = contact_DrugRecord.Id;
                    }
                    reimbursementCase = mapDailyClaimToCase(dailyClaim, reimbursementCase);
                    newReimbursementCaseList.add(reimbursementCase);
                }
                */
            } else {
                System.debug('Update existing claim.');
                //If Claim unique key does exist for the ContactDrug:
                //   Then update existing Claim record with new data.
                //System.Debug('claimRecord = ' + claimRecord);
                if(claimRecord != null) {
                    claimRecord = mapHistoricalClaimToClam(historicalClaim, claimRecord);
                    claimRecord.Drug__c = relatedDrug.Id;
                    claimRecord.Contact_Drug__c = contact_DrugRecord.Id;
                    claimRecord.Contact__c = contact_DrugRecord.Contact__c;
                    existingClaimList.add(claimRecord);
                    allClaim_InformationList.add(claimRecord);
                }
            }

        }

        uow.registerNew(newClaimList);
        uow.registerDirty(existingClaimList);
        /*
        uow.registerDirty(existingContact_DrugList);
        uow.registerDirty(existingReimbursementCaseList);
        uow.registerNew(newEnrollmentCaseList);
        uow.registerNew(newReimbursementCaseList);
*/
        System.debug('In Claim_Informations:process - allClaim_InformationList Count: ' + allClaim_InformationList.size());
        System.debug('In Claim_Informations:process - Stop processing Claim_Information for Historical Claims');

        return allClaim_InformationList;

    }

    //Map Daily Claim fields to new Claim_Information__c fields
    private Claim_Information__c mapDailyClaimToClam(Daily_Claim__c dailyClaim, Claim_Information__c claimRecord) {

        //System.Debug('claimRecord = ' + claimRecord);
        //System.Debug('dailyClaim = ' + dailyClaim);
        //System.Debug('dailyClaim.CSA_Account__c = ' + dailyClaim.CSA_Account__c);
        claimRecord.Source_File_Type__c = 'Daily Claims';
        claimRecord.CSA_Account__c = dailyClaim.CSA_Account__c;
        if(dailyClaim.Units_Billed__c != null) {
            claimRecord.Units_Billed__c = dailyClaim.Units_Billed__c;
        }
        if(dailyClaim.Amount_Paid_By_Primary__c != null) {
            claimRecord.Amount_Paid_By_Primary__c = dailyClaim.Amount_Paid_By_Primary__c;
        }
        if(!String.isBlank(dailyClaim.Prior_Authorization__c)) {
            claimRecord.Prior_Authorization__c = dailyClaim.Prior_Authorization__c;
        }
        if(!String.isBlank(dailyClaim.Billing_Provider_City__c)) {
            claimRecord.Billing_Provider_City__c = dailyClaim.Billing_Provider_City__c;
        }
        if(!String.isBlank(dailyClaim.Billing_Provider_First_Name__c)) {
            claimRecord.Billing_Provider_First_Name__c = dailyClaim.Billing_Provider_First_Name__c;
        }
        if(!String.isBlank(dailyClaim.Billing_Provider_Last_Name__c)) {
            claimRecord.Billing_Provider_Last_Name__c = dailyClaim.Billing_Provider_Last_Name__c;
        }
        if(!String.isBlank(dailyClaim.Billing_Provider_Specialty__c)) {
            claimRecord.Billing_Provider_Specialty__c = dailyClaim.Billing_Provider_Specialty__c;
        }
        if(!String.isBlank(dailyClaim.Billing_Provider_PIN__c)) {
            claimRecord.Billing_Provider_PIN__c = dailyClaim.Billing_Provider_PIN__c;
        }
        if(!String.isBlank(dailyClaim.Billing_Provider_State__c)) {
            claimRecord.Billing_Provider_State_Code__c = dailyClaim.Billing_Provider_State__c;
        }
        if(!String.isBlank(dailyClaim.Billing_Provider_Zip_Code__c)) {
            claimRecord.Billing_Provider_Zip_Code__c = dailyClaim.Billing_Provider_Zip_Code__c;
        }
        if(!String.isBlank(dailyClaim.Billing_Provider_Phone__c)) {
            claimRecord.Billing_Provider_Phone__c = dailyClaim.Billing_Provider_Phone__c;
        }
        if(!String.isBlank(dailyClaim.Billing_Provider_Fax__c)) {
            claimRecord.Billing_Provider_Fax__c = dailyClaim.Billing_Provider_Fax__c;
        }
        claimRecord.Primary_Claim_Number__c = dailyClaim.Primary_Claim_Number__c;
        if(!String.isBlank(dailyClaim.Claim_Code__c)) {
            claimRecord.Claim_Code__c = dailyClaim.Claim_Code__c;
            //System.debug('dailyClaim.Claim_Code__c  = ' + dailyClaim.Claim_Code__c);
        }
        //System.debug('dailyClaim.Claim_Code__c  = ' + dailyClaim.Claim_Code__c);
        //claimRecord.Claim_Indicator__c = dailyClaim.Claim_Indicator__c;
        if(!String.isBlank(dailyClaim.Claim_Line__c)) {
            claimRecord.Claim_Line__c = dailyClaim.Claim_Line__c;
        }
        if(!String.isBlank(dailyClaim.Claim_Segment__c)) {
            claimRecord.Claim_Segment__c = dailyClaim.Claim_Segment__c;
        }
        //claimRecord.COB_Indicator__c = dailyClaim.COB_Indicator__c;
        claimRecord.CSA_Control__c = dailyClaim.CSA_Control__c;
        if(dailyClaim.Days_Supply__c != null) {
            claimRecord.Total_Days_Supply__c = dailyClaim.Days_Supply__c;
        }
        if(!String.isBlank(dailyClaim.Diagnosis_Code__c)) {
            claimRecord.Diagnosis_Code__c = dailyClaim.Diagnosis_Code__c;
        }
        //claimRecord.Drug_Label_Name__c = dailyClaim.Drug_Label_Name__c;
        claimRecord.HCPCS_Code__c = dailyClaim.HCPCS_Code__c;
        claimRecord.NDC__c = dailyClaim.NDC__c;
        //claimRecord.PA_Approval_Dates__c = dailyClaim.PA_Approval_Dates__c;
        claimRecord.Previous_Segment__c = dailyClaim.Previous_Segment__c;
        if(!String.isBlank(dailyClaim.Preferred_Provider__c)) {
            claimRecord.Preferred_Provider__c = dailyClaim.Preferred_Provider__c;
        }
        if(dailyClaim.Claim_Adjustment_Amount__c != null) {
            claimRecord.Claim_Adjustment_Amount__c = dailyClaim.Claim_Adjustment_Amount__c;
        }
        if(!String.isBlank(dailyClaim.Coverage_Code_Indicator__c)) {
            claimRecord.Coverage_Code_Indicator__c = dailyClaim.Coverage_Code_Indicator__c;
        }
        if(dailyClaim.Date_Of_Service_From__c != null) {
            claimRecord.Date_Of_Service_From__c = dailyClaim.Date_Of_Service_From__c;
        }
        if(!String.isBlank(dailyClaim.Service_Provider_Fax__c)) {
            claimRecord.Service_Provider_Fax__c = dailyClaim.Service_Provider_Fax__c;
        }
        if(!String.isBlank(dailyClaim.Service_Provider_Phone__c)) {
            claimRecord.Service_Provider_Phone__c = dailyClaim.Service_Provider_Phone__c;
        }
        if(dailyClaim.Date_Of_Service_To__c != null) {
            claimRecord.Date_Of_Service_To__c = dailyClaim.Date_Of_Service_To__c;
        }
        if(!String.isBlank(dailyClaim.Service_Provider_Address_Line_1__c)) {
            claimRecord.Service_Provider_Address_Line_1__c = dailyClaim.Service_Provider_Address_Line_1__c;
        }
        if(!String.isBlank(dailyClaim.Service_Provider_City__c)) {
            claimRecord.Service_Provider_City__c = dailyClaim.Service_Provider_City__c;
        }
        if(!String.isBlank(dailyClaim.Service_Provider_First_Name__c)) {
            claimRecord.Service_Provider_First_Name__c = dailyClaim.Service_Provider_First_Name__c;
        }
        if(!String.isBlank(dailyClaim.Service_Provider_Last_Name__c)) {
            claimRecord.Service_Provider_Last_Name__c = dailyClaim.Service_Provider_Last_Name__c;
        }
        if(!String.isBlank(dailyClaim.Service_Provider_NPI__c)) {
            claimRecord.Service_Provider_NPI__c = dailyClaim.Service_Provider_NPI__c;
        }
        if(!String.isBlank(dailyClaim.Place_of_Service__c)) {
            claimRecord.Place_of_Service__c = dailyClaim.Place_of_Service__c;
        }
        if(!String.isBlank(dailyClaim.Billing_Provider_Address_Line_1__c)) {
            claimRecord.Billing_Provider_Address_Line_1__c = dailyClaim.Billing_Provider_Address_Line_1__c;
        }
        if(!String.isBlank(dailyClaim.Billing_Provider_Address_Line_2__c)) {
            claimRecord.Billing_Provider_Address_Line_2__c = dailyClaim.Billing_Provider_Address_Line_2__c;
        }
        //claimRecord.Service_Provider_Practice__c = dailyClaim.Service_Provider_Practice__c;
        if(!String.isBlank(dailyClaim.Service_Provider_Zip__c)) {
            claimRecord.Service_Provider_Zip__c = dailyClaim.Service_Provider_Zip__c;
        }
        //claimRecord.Service_Provider_Specialty__c = dailyClaim.Service_Provider_Specialty__c;
        if(!String.isBlank(dailyClaim.Service_Provider_State__c)) {
            claimRecord.Service_Provider_State__c = dailyClaim.Service_Provider_State__c;
        }
        if(!String.isBlank(dailyClaim.Patient_CUMB_ID__c)) {
            claimRecord.Patient_CUMB_ID__c = dailyClaim.Patient_CUMB_ID__c;
        }
        if(!String.isBlank(dailyClaim.CSA_Suffix__c)) {
            claimRecord.CSA_Suffix__c = dailyClaim.CSA_Suffix__c;
        }
        if(dailyClaim.Total_Coinsurance__c != null) {
            claimRecord.Total_Coinsurance__c = dailyClaim.Total_Coinsurance__c;
        }
        if(dailyClaim.Total_Copay__c != null) {
            claimRecord.Total_Copay__c = dailyClaim.Total_Copay__c;
        }
        if(dailyClaim.Total_Deductible__c != null) {
            claimRecord.Total_Deductible__c = dailyClaim.Total_Deductible__c;
        }
        if(dailyClaim.Previous_Claim__c != null) {
            claimRecord.Previous_Claim__c = dailyClaim.Previous_Claim__c;
        }
        if(dailyClaim.Adjudication_Date__c != null) {
            claimRecord.Adjudication_Date__c = dailyClaim.Adjudication_Date__c;
        }
        claimRecord.Name_Type_Code__c = dailyClaim.Name_Type_Code__c;
        //claimRecord.Plan_Sponsor_Unique_ID__c = dailyClaim.Plan_Sponsor_Unique_ID__c;
        if(!String.isBlank(dailyClaim.Funding_Indicator__c)) {
            claimRecord.Funding_Indicator__c = dailyClaim.Funding_Indicator__c;
        }
        if(!String.isBlank(dailyClaim.Plan_Letter__c)) {
            claimRecord.Plan_Letter__c = dailyClaim.Plan_Letter__c;
        }
        System.Debug('dailyClaim.EOP_Date__c = ' + dailyClaim.EOP_Date__c);
        if(dailyClaim.EOP_Date__c != null) {
            claimRecord.EOP_Date__c = dailyClaim.EOP_Date__c;
        }

        return claimRecord;
    }

    //Map Historical Claim fields to new Claim_Information__c fields
    private Claim_Information__c mapHistoricalClaimToClam(Historical_Claim__c historicalClaim, Claim_Information__c claimRecord) {

        //System.Debug('claimRecord = ' + claimRecord);
        //System.Debug('dailyClaim = ' + dailyClaim);
        //System.Debug('dailyClaim.CSA_Account__c = ' + dailyClaim.CSA_Account__c);
        claimRecord.Source_File_Type__c = 'Historical Claims';
        claimRecord.CSA_Account__c = historicalClaim.CSA_Account__c;
        if(historicalClaim.Units_Billed__c != null) {
            claimRecord.Units_Billed__c = historicalClaim.Units_Billed__c;
        }
        if(historicalClaim.Amount_Paid_By_Primary__c != null) {
            claimRecord.Amount_Paid_By_Primary__c = historicalClaim.Amount_Paid_By_Primary__c;
        }
        //claimRecord.Prior_Authorization__c = historicalClaim.Prior_Authorization__c;
        if(!String.isBlank(historicalClaim.Billing_Provider_City__c)) {
            claimRecord.Billing_Provider_City__c = historicalClaim.Billing_Provider_City__c;
        }
        if(!String.isBlank(historicalClaim.Billing_Provider_First_Name__c)) {
            claimRecord.Billing_Provider_First_Name__c = historicalClaim.Billing_Provider_First_Name__c;
        }
        if(!String.isBlank(historicalClaim.Billing_Provider_Last_Name__c)) {
            claimRecord.Billing_Provider_Last_Name__c = historicalClaim.Billing_Provider_Last_Name__c;
        }
        if(!String.isBlank(historicalClaim.Billing_Provider_Specialty__c)) {
            claimRecord.Billing_Provider_Specialty__c = historicalClaim.Billing_Provider_Specialty__c;
        }
        if(!String.isBlank(historicalClaim.Place_of_Service__c)) {
            claimRecord.Place_of_Service__c = historicalClaim.Place_of_Service__c;
        }
        if(!String.isBlank(historicalClaim.Billing_Provider_PIN__c)) {
            claimRecord.Billing_Provider_PIN__c = historicalClaim.Billing_Provider_PIN__c;
        }
        if(!String.isBlank(historicalClaim.Billing_Provider_State__c)) {
            claimRecord.Billing_Provider_State_Code__c = historicalClaim.Billing_Provider_State__c;
        }
        if(!String.isBlank(historicalClaim.Billing_Provider_Address_Line_1__c)) {
            claimRecord.Billing_Provider_Address_Line_1__c = historicalClaim.Billing_Provider_Address_Line_1__c;
        }
        if(!String.isBlank(historicalClaim.Billing_Provider_Zip_Code__c)) {
            claimRecord.Billing_Provider_Zip_Code__c = historicalClaim.Billing_Provider_Zip_Code__c;
        }
        if(!String.isBlank(historicalClaim.Billing_Provider_Phone__c)) {
            claimRecord.Billing_Provider_Phone__c = historicalClaim.Billing_Provider_Phone__c;
        }
        if(!String.isBlank(historicalClaim.Billing_Provider_Fax__c)) {
            claimRecord.Billing_Provider_Fax__c = historicalClaim.Billing_Provider_Fax__c;
        }
        claimRecord.Primary_Claim_Number__c = historicalClaim.Primary_Claim_Number__c;
        //claimRecord.Claim_Code__c = historicalClaim.Claim_Code__c;
        //claimRecord.Claim_Indicator__c = dailyClaim.Claim_Indicator__c;
        if(!String.isBlank(historicalClaim.Claim_Line__c)) {
            claimRecord.Claim_Line__c = historicalClaim.Claim_Line__c;
        }
        //claimRecord.Claim_Segment__c = historicalClaim.Claim_Segment__c;
        //claimRecord.COB_Indicator__c = dailyClaim.COB_Indicator__c;
        claimRecord.CSA_Control__c = historicalClaim.CSA_Control__c;
        //claimRecord.Days_Supply__c = historicalClaim.Days_Supply__c;
        if(!String.isBlank(historicalClaim.Diagnosis_Code__c)) {
            claimRecord.Diagnosis_Code__c = historicalClaim.Diagnosis_Code__c;
        }
        //claimRecord.Drug_Label_Name__c = dailyClaim.Drug_Label_Name__c;
        if(!String.isBlank(historicalClaim.HCPCS_Code__c)) {
            claimRecord.HCPCS_Code__c = historicalClaim.HCPCS_Code__c;
        }
        claimRecord.NDC__c = historicalClaim.NDC__c;
        //claimRecord.PA_Approval_Dates__c = historicalClaim.PA_Approval_Dates__c;
        //claimRecord.Previous_Segment__c = historicalClaim.Previous_Segment__c;
        if(!String.isBlank(historicalClaim.Preferred_Provider__c)) {
            claimRecord.Preferred_Provider__c = historicalClaim.Preferred_Provider__c;
        }
        //claimRecord.Claim_Adjustment_Amount__c = historicalClaim.Claim_Adjustment_Amount__c;
        //claimRecord.Coverage_Code_Indicator__c = historicalClaim.Coverage_Code_Indicator__c;
        if(historicalClaim.Date_Of_Service_From__c != null) {
            claimRecord.Date_Of_Service_From__c = historicalClaim.Date_Of_Service_From__c;
        }
        if(!String.isBlank(historicalClaim.Service_Provider_Fax__c)) {
            claimRecord.Service_Provider_Fax__c = historicalClaim.Service_Provider_Fax__c;
        }
        if(!String.isBlank(historicalClaim.Service_Provider_Phone__c)) {
            claimRecord.Service_Provider_Phone__c = historicalClaim.Service_Provider_Phone__c;
        }
        if(historicalClaim.Date_Of_Service_To__c != null) {
            claimRecord.Date_Of_Service_To__c = historicalClaim.Date_Of_Service_To__c;
        }
        if(!String.isBlank(historicalClaim.Service_Provider_Address_Line_1__c)) {
            claimRecord.Service_Provider_Address_Line_1__c = historicalClaim.Service_Provider_Address_Line_1__c;
        }
        if(!String.isBlank(historicalClaim.Service_Provider_City__c)) {
            claimRecord.Service_Provider_City__c = historicalClaim.Service_Provider_City__c;
        }
        if(!String.isBlank(historicalClaim.Service_Provider_First_Name__c)) {
            claimRecord.Service_Provider_First_Name__c = historicalClaim.Service_Provider_First_Name__c;
        }
        if(!String.isBlank(historicalClaim.Service_Provider_Last_Name__c)) {
            claimRecord.Service_Provider_Last_Name__c = historicalClaim.Service_Provider_Last_Name__c;
        }
        if(!String.isBlank(historicalClaim.Service_Provider_NPI__c)) {
            claimRecord.Service_Provider_NPI__c = historicalClaim.Service_Provider_NPI__c;
        }
        if(!String.isBlank(historicalClaim.Service_Provider_Practice__c)) {
            claimRecord.Service_Provider_Practice__c = historicalClaim.Service_Provider_Practice__c;
        }
        if(!String.isBlank(historicalClaim.Service_Provider_Zip__c)) {
            claimRecord.Service_Provider_Zip__c = historicalClaim.Service_Provider_Zip__c;
        }
        //claimRecord.Service_Provider_Specialty__c = dailyClaim.Service_Provider_Specialty__c;
        if(!String.isBlank(historicalClaim.Service_Provider_State__c)) {
            claimRecord.Service_Provider_State__c = historicalClaim.Service_Provider_State__c;
        }
        if(!String.isBlank(historicalClaim.Patient_CUMB_ID__c)) {
            claimRecord.Patient_CUMB_ID__c = historicalClaim.Patient_CUMB_ID__c;
        }
        claimRecord.CSA_Suffix__c = historicalClaim.CSA_Suffix__c;
        if(historicalClaim.Total_Coinsurance__c != null) {
            claimRecord.Total_Coinsurance__c = historicalClaim.Total_Coinsurance__c;
        }
        if(historicalClaim.Total_Copay__c != null) {
            claimRecord.Total_Copay__c = historicalClaim.Total_Copay__c;
        }
        if(historicalClaim.Total_Deductible__c != null) {
            claimRecord.Total_Deductible__c = historicalClaim.Total_Deductible__c;
        }
        //claimRecord.Previous_Claim__c = historicalClaim.Previous_Claim__c;
        //claimRecord.Total_Days_Supply__c = historicalClaim.Days_Supply__c;
        //claimRecord.Plan_Sponsor_Unique_ID__c = historicalClaim.Plan_Sponsor_Unique_ID__c;
        claimRecord.Name_Type_Code__c = historicalClaim.Name_Type_Code__c;

        return claimRecord;
    }


    //Return Map of CSAs by Daily Claim Ids given a Map of DailyClaim Ids By CSANumbers
    /*
    private Map<Id, CSA__c> getCSAsByDailyClaimId(Map<String, Id> dailyClaimIdByCSANumber) {
        Map<Id, CSA__c> csasByDailyClaimIds = new Map<Id, CSA__c>();

        CSAsSelector csasSelector = (CSAsSelector)PMd_Application.Selector.newInstance(CSA__c.SObjectType);
        List<CSA__c> matchingDailyClaimCSA_NumbersList = csasSelector.selectByCSANumber(dailyClaimIdByCSANumber.keySet());
        for(CSA__c csaRecord : matchingDailyClaimCSA_NumbersList) {
            csasByDailyClaimIds.put(dailyClaimIdByCSANumber.get(csaRecord.CSA_Number__c), csaRecord);
        }

        return csasByDailyClaimIds;
    }
*/
    //Map Daily Claim fields to new Contact fields
    /*  private Claim_Information__c mapDailyClaimToContact_Drug(Daily_Claim__c dailyClaim, Contact_Drug__c contact_Drug) {

        return contact_Drug;
    }
*/
/***************************************************************************************************************************************
 * Trigger Operations
 **************************************************************************************************************************************/

    public override void onBeforeInsert() {
        System.debug('Start Claim_Information__c:onBeforeInsert');

        List<Claim_Information__c> claimsList = Records;
        List<Claim_Information__c> claimsToProcessList = new List<Claim_Information__c>();
        //Claim Key Matching Logic: https://prudentrx1.sharepoint.com/:x:/r/_layouts/15/Doc.aspx?sourcedoc=%7BF2D723D1-28B7-42ED-A519-2F23CD78C4E9%7D&file=Claim%20Key%20Matching%20Logic.xlsx&action=default&mobileredirect=true
        String claim_NumberSeed;

        for(Claim_Information__c claimRecord : claimsList) {
            //Claim Key Matching Logic: https://prudentrx1.sharepoint.com/:x:/r/_layouts/15/Doc.aspx?sourcedoc=%7BF2D723D1-28B7-42ED-A519-2F23CD78C4E9%7D&file=Claim%20Key%20Matching%20Logic.xlsx&action=default&mobileredirect=true
            //claim_NumberSeed = getClaimKey(claimRecord);

            switch on claimRecord.Source_File_Type__c {
                when 'Daily Claims' { // when source File_Upsert is 'Daily Claims'
                    if (claimRecord.Previous_Segment__c == null
                            || claimRecord.Previous_Segment__c == '')
                    {
                        claim_NumberSeed = claimRecord.Primary_Claim_Number__c + '-' +
                                claimRecord.Claim_Segment__c + '-' +
                                claimRecord.Claim_Line__c;
                    } else {
                        claim_NumberSeed = claimRecord.Primary_Claim_Number__c + '-' +
                                claimRecord.Previous_Segment__c + '-' +
                                claimRecord.Claim_Line__c;
                    }
                }
                when 'Historical Claims' { // when source File_Upsert is 'Historical Claims'
                    claim_NumberSeed = claimRecord.Primary_Claim_Number__c + '-' +
                            //claimRecord.Claim_Segment__c + '-' +
                            claimRecord.Claim_Line__c;
                }

            }
            System.debug('claim_NumberSeed = ' +claimRecord.Claim_Number__c);

            claimRecord.Claim_Number__c = SHA1UtilService.getBase64SHA1Hash(claim_NumberSeed);
            System.debug('claimRecord.Claim_Number__c = ' +claimRecord.Claim_Number__c);
        }

        if(claimsToProcessList.size() > 0) {
            //ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
        }
        System.debug('End Claim_Information__c:onBeforeInsert');
    }

    //    public override void processAfterInsert(){
    public override void onAfterInsert() {
        System.debug('Start Claim_Information__c:onAfterInsert');

        List<Claim_Information__c> claimsList = Records;
        List<Claim_Information__c> claimsToProcessList = new List<Claim_Information__c>();
        Map<String, Claim_Information__c> claimByClaim_Number = new Map<String, Claim_Information__c>();
        List<Daily_Claim__c> updatedDaily_ClaimsList = new List<Daily_Claim__c>();
        List<Historical_Claim__c> updatedHistorical_ClaimsList = new List<Historical_Claim__c>();
        List<Historical_Prior_Auth__c> updatedHistorical_PAList = new List<Historical_Prior_Auth__c>();
        List<Prior_Auth__c> updatedPAList = new List<Prior_Auth__c>();
        List<Daily_Claim__c> daily_ClaimsList = new List<Daily_Claim__c>();
        List<Historical_Claim__c> historical_ClaimsList = new List<Historical_Claim__c>();
        List<Prior_Auth__c> paList = new List<Prior_Auth__c>();
        List<Historical_Prior_Auth__c> historical_PAList = new List<Historical_Prior_Auth__c>();


        // Create unit of work to capture work and commit it under one transaction
        fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();
        API_User__mdt IntegrationUser = [SELECT Id, Username__c, Profile_Name__c, ProfileId__c FROM API_User__mdt WHERE Alias__c = 'iuser'];
         // Query for Sr. Management Profile_Name__c to allow them to update claims
        User SrManagement = [SELECT Id, Profile.Name, Profile.Id FROM User WHERE Profile.Name = 'Sr. Management' LIMIT 1];
        //String contextUserName = UserInfo.getUserName(); //Returns the context user's login name.
        String contextUserProfileID = UserInfo.getProfileId(); //Returns the context user's profile ID.

        for(Claim_Information__c claimRecord : claimsList) {

            System.debug('claimRecord.Source_File_Type__c = ' + claimRecord.Source_File_Type__c);
            System.debug('claimRecord.Current_Claim_Number__c = ' + claimRecord.Current_Claim_Number__c);
            System.debug('claimRecord.Claim_Number__c = ' + claimRecord.Claim_Number__c);
            switch on claimRecord.Source_File_Type__c {
                when 'Daily Claims' { // when source File_Upsert is 'Daily Claims'
                    claimByClaim_Number.put(claimRecord.Current_Claim_Number__c, claimRecord);
                }
                when 'Historical Claims' { // when source File_Upsert is 'Historical Claims'
                    claimByClaim_Number.put(claimRecord.Claim_Number__c, claimRecord);
                }
            }
        }

        //Only the Integration User or Users with Sys Admin Full Profiles should be able to make this
        // change so that others can update the downstream objects w/o having permission to update the Source Objects.
        if(contextUserProfileID == IntegrationUser.ProfileId__c || contextUserProfileID == SrManagement.Profile.Id)  {
                //|| contextUserProfileID == IntegrationUser.ProfileId) {
            // Daily Claims related list (bottom section of this Claim).
            //   The old Claim, Segment, and Line will be shown from the Daily Claims related list (bottom section of this Claim).
            //Update all related Daily Claim Claim_Information__c with corresponding claim.Id
            Daily_ClaimsSelector daily_ClaimsSelector = (Daily_ClaimsSelector) PMd_Application.Selector.newInstance(Daily_Claim__c.SObjectType);
            daily_ClaimsList = daily_ClaimsSelector.selectByClaim_Number(claimByClaim_Number.keySet());
            System.debug('daily_ClaimsList Count = ' + daily_ClaimsList.size());

            for (Daily_Claim__c daily_ClaimRecord : daily_ClaimsList) {
                Claim_Information__c claimRecord = claimByClaim_Number.get(daily_ClaimRecord.Claim_Number__c);
                System.debug('daily_ClaimRecord.Claim_Number__c = ' + daily_ClaimRecord.Claim_Number__c);
                System.debug('claimRecord.Current_Claim_Number__c = ' + claimRecord.Current_Claim_Number__c);
                daily_ClaimRecord.Claim_Information__c = claimRecord.Id;
                updatedDaily_ClaimsList.add(daily_ClaimRecord);
            }

            // Historical Claims related list (bottom section of this Claim).
            //   The old Claim, Segment, and Line will be shown from the Daily Claims related list (bottom section of this Claim).
            //Update all related Historical Claim Claim_Information__c with corresponding claim.Id
            Historical_ClaimsSelector historical_ClaimsSelector = (Historical_ClaimsSelector) PMd_Application.Selector.newInstance(Historical_Claim__c.SObjectType);
            historical_ClaimsList = historical_ClaimsSelector.selectByClaim_Number(claimByClaim_Number.keySet());
            System.debug('historical_ClaimsList Count = ' + historical_ClaimsList.size());

            for (Historical_Claim__c historical_ClaimRecord : historical_ClaimsList) {
                Claim_Information__c claimRecord = claimByClaim_Number.get(historical_ClaimRecord.Claim_Number__c);
                System.debug('historical_ClaimRecord.Claim_Number__c = ' + historical_ClaimRecord.Claim_Number__c);
                System.debug('claimRecord.Claim_Number__c = ' + claimRecord.Claim_Number__c);
                historical_ClaimRecord.Claim_Information__c = claimRecord.Id;
                updatedHistorical_ClaimsList.add(historical_ClaimRecord);
            }

            // Historical PA related list (bottom section of this Claim).
            //   The old Claim, Segment, and Line will be shown from the Daily Claims related list (bottom section of this Claim).
            //Update all related Daily Claim Claim_Information__c with corresponding claim.Id
            Historical_Prior_AuthSelector historical_PASelector = (Historical_Prior_AuthSelector) PMd_Application.Selector.newInstance(Historical_Prior_Auth__c.SObjectType);
            historical_PAList = historical_PASelector.selectByClaim_Number(claimByClaim_Number.keySet());
            System.debug('historical_PAList Count = ' + historical_PAList.size());

            for (Historical_Prior_Auth__c historical_PARecord : historical_PAList) {
                Claim_Information__c claimRecord = claimByClaim_Number.get(historical_PARecord.Claim_Number__c);
                System.debug('historical_PARecord.Claim_Number__c = ' + historical_PARecord.Claim_Number__c);
                System.debug('claimRecord.Claim_Number__c = ' + claimRecord.Claim_Number__c);
                historical_PARecord.Claim_Information__c = claimRecord.Id;
                updatedHistorical_PAList.add(historical_PARecord);
            }

            // PA related list (bottom section of this Claim).
            // The old Claim, Segment, and Line will be shown from the Daily Claims related list (bottom section of this Claim).
            //Update all related Daily Claim Claim_Information__c with corresponding claim.Id
            Prior_AuthSelector paSelector = (Prior_AuthSelector) PMd_Application.Selector.newInstance(Prior_Auth__c.SObjectType);
            paList = paSelector.selectByClaim_Number(claimByClaim_Number.keySet());
            System.debug('paList Count = ' + paList.size());

            for (Prior_Auth__c paRecord : paList) {
                Claim_Information__c claimRecord = claimByClaim_Number.get(paRecord.Claim_Number__c);
                System.debug('paRecord.Claim_Number__c = ' + paRecord.Claim_Number__c);
                System.debug('claimRecord.Claim_Number__c = ' + claimRecord.Claim_Number__c);
                paRecord.Claim_Information__c = claimRecord.Id;
                updatedPAList.add(paRecord);
            }
        }

        if(claimsToProcessList.size() > 0) {
            //ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
        }

        uow.registerDirty(updatedDaily_ClaimsList);
        uow.registerDirty(updatedHistorical_ClaimsList);
        uow.registerDirty(updatedHistorical_PAList);
        uow.registerDirty(updatedPAList);
        try {
            uow.commitWork();
        }catch(Exception e){
            System.debug('++ ' + e.getMessage());
            if(daily_ClaimsList.size()>0) {
                ErrorLog.log('Claim_Informations.onAfterInsert', '', '', '', '', e.getLineNumber() + ' ' + e.getMessage(), daily_ClaimsList[0].Id, null, null, null);
            }
            if(historical_ClaimsList.size()>0) {
                ErrorLog.log('Claim_Informations.onAfterInsert', '', '', '', '', e.getLineNumber() + ' ' + e.getMessage(), null, historical_ClaimsList[0].Id, null, null);
            }
            if(paList.size()>0) {
                ErrorLog.log('Claim_Informations.onAfterInsert', '', '', '', '', e.getLineNumber() + ' ' + e.getMessage(), null, null, paList[0].Id, null);
            }
            if(historical_PAList.size()>0) {
                ErrorLog.log('Claim_Informations.onAfterInsert', '', '', '', '', e.getLineNumber() + ' ' + e.getMessage(), null, null, null, historical_PAList[0].Id);
            }
            ErrorLog.commitLogs();
        }

        System.debug('End Claim_Information__c:onAfterInsert');
    }


    public override void onBeforeUpdate(Map<Id, SObject> oldRecords) {
        System.debug('Start Claim_Information__c:onBeforeUpdate');

        List<Claim_Information__c> claimsList = Records;
        List<Claim_Information__c> claimsToProcessList = new List<Claim_Information__c>();
        String claim_NumberSeed;

        for(Claim_Information__c claimRecord : claimsList) {

            Claim_Information__c oldCLaim = (Claim_Information__c)oldRecords.get(claimRecord.Id);

            //If initial Claim
            /*
            if (claimRecord.Previous_Segment__c == null
                    || claimRecord.Previous_Segment__c == '')
            {
                claim_NumberSeed = claimRecord.Primary_Claim_Number__c + '-' +
                        claimRecord.Claim_Segment__c + '-' +
                        claimRecord.Claim_Line__c;
            } else {
                */
            /*
                claim_NumberSeed = claimRecord.Primary_Claim_Number__c + '-' +
                        claimRecord.Claim_Segment__c + '-' +
                        claimRecord.Claim_Line__c;
            (/)
            */
           // }
            //claimRecord.Current_Claim_Number__c = claimRecord.Claim_Number__c;
            claim_NumberSeed = getClaimKey(claimRecord);
            claimRecord.Claim_Number__c = SHA1UtilService.getBase64SHA1Hash(claim_NumberSeed);

            //SAL-1035 Queue the Claim to Send
            //Create a rule that sets the Send to ACAS(Aetna) field to “Queued” when ALL of the following conditions are met:
            //   a. CPA Funds Paid OR CPA Indicator fields are modified
            //   b. Both CPA Funds Paid AND CPA Indicator fields are populated
            if(claimRecord.CPA_Funds_Paid__c != null
                    && claimRecord.CPA_Indicator__c  != null
                    && (claimRecord.CPA_Funds_Paid__c != oldCLaim.CPA_Funds_Paid__c || claimRecord.CPA_Indicator__c != oldCLaim.CPA_Indicator__c) ) {
                // claimRecord.Send_to_ACAS__c = 'Queued';
                claimRecord.Send_to_ACAS__c = claimRecord.Send_to_ACAS__c == 'Sent' || claimRecord.Send_to_ACAS__c == 'Re-sent' ? 'Requeued' : 'Queued'; 
            }

            //US-536: Reverses the trigger if either required field is blanked out so that we don’t accidentally send a claim back to ACAS with a blanked out field.
            if((claimRecord.CPA_Funds_Paid__c == null
                    || claimRecord.CPA_Indicator__c  == null)
                    && (claimRecord.CPA_Funds_Paid__c != oldCLaim.CPA_Funds_Paid__c || claimRecord.CPA_Indicator__c != oldCLaim.CPA_Indicator__c) ) {
                claimRecord.Send_to_ACAS__c = '';
            }
        }

        if(claimsToProcessList.size() > 0) {
            //ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
        }

        System.debug('End Claim_Information__c:onBeforeUpdate');

    }

    //public override void processAfterUpdate(){
    public override void onAfterUpdate(Map<Id, SObject> existingRecords){
        System.debug('Start Claim_Information__c:onAfterUpdate');

        List<Claim_Information__c> claimsList = Records;
        List<Claim_Information__c> claimsToProcessList = new List<Claim_Information__c>();
        Map<String, Claim_Information__c> claimByClaim_Number = new Map<String, Claim_Information__c>();
        List<Daily_Claim__c> updatedDaily_ClaimsList = new List<Daily_Claim__c>();
        List<Historical_Claim__c> updatedHistorical_ClaimsList = new List<Historical_Claim__c>();
        LIst<Historical_Prior_Auth__c> updatedHistorical_PAList = new List<Historical_Prior_Auth__c>();
        List<Daily_Claim__c> daily_ClaimsList = new List<Daily_Claim__c>();
        List<Historical_Claim__c> historical_ClaimsList = new List<Historical_Claim__c>();

        // Create unit of work to capture work and commit it under one transaction
        fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();
        API_User__mdt IntegrationUser = [SELECT Id, Username__c, Profile_Name__c, ProfileId__c FROM API_User__mdt WHERE Alias__c = 'iuser'];
        //String contextUserName = UserInfo.getUserName(); //Returns the context user's login name.
        String contextUserProfileID = UserInfo.getProfileId(); //Returns the context user's profile ID.
        System.debug('contextUserProfileID = ' + contextUserProfileID);

        for(Claim_Information__c claimRecord : claimsList) {
            if(claimRecord.Current_Claim_Number__c != null) {
                claimByClaim_Number.put(claimRecord.Current_Claim_Number__c, claimRecord);
            } else {
                claimByClaim_Number.put(claimRecord.Claim_Number__c, claimRecord);
            }
        }

        if(contextUserProfileID == IntegrationUser.ProfileId__c) {
            // Daily Claims related list (bottom section of this Claim).
            //   The old Claim, Segment, and Line will be shown from the Daily Claims related list (bottom section of this Claim).
            //Update all related Daily Claim Claim_Information__c with corresponding claim.Id
            Daily_ClaimsSelector daily_ClaimsSelector = (Daily_ClaimsSelector) PMd_Application.Selector.newInstance(Daily_Claim__c.SObjectType);
            daily_ClaimsList = daily_ClaimsSelector.selectByClaim_Number(claimByClaim_Number.keySet());
            System.debug('daily_ClaimsList Count = ' + daily_ClaimsList.size());

            for (Daily_Claim__c daily_ClaimRecord : daily_ClaimsList) {
                Claim_Information__c claimRecord = claimByClaim_Number.get(daily_ClaimRecord.Claim_Number__c);
                System.debug('daily_ClaimRecord.Claim_Number__c = ' + daily_ClaimRecord.Claim_Number__c);
                System.debug('claimRecord.Current_Claim_Number__c = ' + claimRecord.Current_Claim_Number__c);
                daily_ClaimRecord.Claim_Information__c = claimRecord.Id;
                updatedDaily_ClaimsList.add(daily_ClaimRecord);
            }

            // Historical Claims related list (bottom section of this Claim).
            //   The old Claim, Segment, and Line will be shown from the Historical Claims related list (bottom section of this Claim).
            //Update all related Historical Claim Claim_Information__c with corresponding claim.Id
            Historical_ClaimsSelector historical_ClaimsSelector = (Historical_ClaimsSelector) PMd_Application.Selector.newInstance(Historical_Claim__c.SObjectType);
            historical_ClaimsList = historical_ClaimsSelector.selectByClaim_Number(claimByClaim_Number.keySet());
            System.debug('historical_ClaimsList Count = ' + historical_ClaimsList.size());

            for (Historical_Claim__c historical_ClaimRecord : historical_ClaimsList) {
                Claim_Information__c claimRecord = claimByClaim_Number.get(historical_ClaimRecord.Claim_Number__c);
                System.debug('historical_ClaimRecord.Claim_Number__c = ' + historical_ClaimRecord.Claim_Number__c);
                System.debug('claimRecord.Claim_Number__c = ' + claimRecord.Claim_Number__c);
                historical_ClaimRecord.Claim_Information__c = claimRecord.Id;
                updatedHistorical_ClaimsList.add(historical_ClaimRecord);
            }
        }

        // Historical PA related list (bottom section of this Claim).
        //   The old Claim, Segment, and Line will be shown from the Daily Claims related list (bottom section of this Claim).
        //Update all related Daily Claim Claim_Information__c with corresponding claim.Id
/*        Historical_Prior_AuthSelector historical_PASelector = (Historical_Prior_AuthSelector)PMd_Application.Selector.newInstance(Historical_Prior_Auth__c.SObjectType);
        List<Historical_Prior_Auth__c> historical_PAList = historical_PASelector.selectByClaim_Number(claimByClaim_Number.keySet());
        System.debug('historical_PAList Count = ' + historical_PAList.size());

        for(Historical_Prior_Auth__c historical_PARecord : historical_PAList) {
            Claim_Information__c claimRecord = claimByClaim_Number.get(historical_PARecord.Claim_Number__c);
            historical_PARecord.Claim_Information__c = claimRecord.Id;
            updatedHistorical_PAList.add(historical_PARecord);
        }
*/
        if(claimsToProcessList.size() > 0) {
            //ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
        }

        uow.registerDirty(updatedDaily_ClaimsList);
        uow.registerDirty(updatedHistorical_ClaimsList);
        //uow.registerDirty(updatedHistorical_PAList);
        try {
            uow.commitWork();
        }catch(Exception e){
            System.debug('++ ' + e.getMessage());
            if(daily_ClaimsList.size()>0) {
                ErrorLog.log('Claim_Informations.onAfterInsert', '', '', '', '', e.getLineNumber() + ' ' + e.getMessage(), daily_ClaimsList[0].Id, null, null, null);
            }
            if(historical_ClaimsList.size()>0) {
                ErrorLog.log('Claim_Informations.onAfterInsert', '', '', '', '', e.getLineNumber() + ' ' + e.getMessage(), null, historical_ClaimsList[0].Id, null, null);
            }
            ErrorLog.commitLogs();
        }

        System.debug('End Claim_Information__c:onAfterUpdate');
    }

    public String getClaimKey(Claim_Information__c claimRecord) {

        String claim_NumberSeed;

        //Claim Key Matching Logic: https://prudentrx1.sharepoint.com/:x:/r/_layouts/15/Doc.aspx?sourcedoc=%7BF2D723D1-28B7-42ED-A519-2F23CD78C4E9%7D&file=Claim%20Key%20Matching%20Logic.xlsx&action=default&mobileredirect=true
        switch on claimRecord.Source_File_Type__c {
            when 'Daily Claims' { // when source File_Upsert is 'Daily Claims'
                /*
                if (claimRecord.Previous_Segment__c == null
                        || claimRecord.Previous_Segment__c == '')
                {
                 */
                    claim_NumberSeed = claimRecord.Primary_Claim_Number__c + '-' +
                            claimRecord.Claim_Segment__c + '-' +
                            claimRecord.Claim_Line__c;
                /*
                } else {
                    claim_NumberSeed = claimRecord.Primary_Claim_Number__c + '-' +
                            claimRecord.Previous_Segment__c + '-' +
                            claimRecord.Claim_Line__c;
                }
                */
            }
            when 'Historical Claims' { // when source File_Upsert is 'Historical Claims'
                claim_NumberSeed = claimRecord.Primary_Claim_Number__c + '-' +
                        //claimRecord.Claim_Segment__c + '-' +
                        claimRecord.Claim_Line__c;
            }
        }
        System.debug('claim_NumberSeed = ' +claimRecord.Claim_Number__c);

        return claim_NumberSeed;
    }

}