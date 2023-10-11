/**
 * @description       : Daily_Claims Domain class.
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 06-01-2022
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   03-21-2021   Ricardy						Initial Version
 * 1.1   03-21-2021   Ricardy						Pass existingContact_DrugsList from Contact_Drug instead of querying again(1 place to get the existingContact_DrugsList. Should be in Contact_Drug domain)
 * 1.2   07-20-2022   Ricardy						MBP-607 Enrollment Case populates Service Provider fields HC, HPA, DPA
 * 1.3   07-20-2022   Ricardy						MBP-611 Most Recent Claim to show on Case
 * 1.4   07-22-2022   Ricardy						MBP-614 Update Case only for new Service From Date
 * 1.5   08-17-2022   Ricardy						MBP-708 Add field mappings from source files
 * 1.6   08-24-2022	  Ricardy						MBP-718 //When the case status is changed from “Transfer to Health Plan” to any other status, the Send to Aetna field should clear out.
 * 1.7   08-29-2022   Ricardy					    MBP-711 Only Allow Integration User to Link Downstream Objects to the Source Object
 * 1.8   05-24-2023   Arvind Mahadevan				ADO-1640 Modify the BeforeUpdate Logic to populate the Service Provider fields based on new custom logic for Pre and Post Go Live scenarios.
 **/

public inherited sharing class Cases extends fflib_SObjectDomain
		implements ICases
{
	/*
	public static ICases newInstance(List<Case> recordList)
	{
		return (ICases) PMd_Application.Domain.newInstance(recordList);
	}

	public static ICases newInstance(Set<Id> recordIdSet)
	{
		return (ICases) PMd_Application.Domain.newInstance(recordIdSet);
	}

	public Cases(List<Case> sObjectList)
	{
		super(sObjectList, Schema.Case.SObjectType);
	}
	*/
	private static Integer maxHCPCSCodeSize = 5;
	public static Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
	public static Date goLiveDate;

	//This sets up the super class (fflib_SObjectDomain) to have the records variable filled out
	public Cases(List<Case> caseRecords){
		super(caseRecords);
		//Cases.getTriggerEvent(Cases.class).disableBeforeInsert();
	}

	public List<Case> getCases()
	{
		return (List<Case>) getRecords();
	}

	//This helps allow for the fflib_SObjectDomain class to run its triggerHandler method
	//using the correct Domain class. This must be implemented in all domain classes.
	public class Constructor implements fflib_SObjectDomain.IConstructable{
		public fflib_SObjectDomain construct(List<SObject> sObjectList){
			return new Cases(sObjectList);
		}
	}
/*
	//This method is called on a beforeInsert transaction to set defaults on a record
	public override void onApplyDefaults(){
		//The records variable comes from the super class
		for(Case newCase: (List<Case>) Records){
			if(newCase.Status == 'New'){
				newCase.Status = 'Open';
			}
		}
	}
*/
	//This method is called on an afterInsert transaction to make sure all validations are being checked
	//before the record is officially committed to the database.
	public override void onValidate()
	{
		for(Case newCase : (List<Case>) records)
		{
			if(newCase.ContactId == null)
			{
				//throw new Cases_Exception();
			}
		}
	}

	public void createTasks(List<SObject> recordsToCreateTasksFor, fflib_ISObjectUnitOfWork unitOfWork)
	{
		/*
		List<Case> caseList = (List<Case>) recordsToCreateTasksFor;
		List<Task> taskList = new List<Task>();
		for(Case cs: caseList){
			Task tsk = new Task();
			tsk.Status = 'New';
			tsk.Subject = cs.Origin + cs.Subject;
			tsk.WhoId = cs.ContactId;
			tsk.ActivityDate = Date.today();
			taskList.add(tsk);
		}
		unitOfWork.registerNew(taskList);
		*/
	}

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

            Pre go-live
                Then create Enrollment Case.
                    Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
            Post go-live
                Then create Enrollment Case and Reimbursement Case.
                    Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
        If Claim unique key does exist for the ContactDrug:
            If Enrollment Case already exists:
                Then do not create a new Enrollment Case.
            If Reimbursement Case already exists:
                Then do not create a new Reimbursement Case.
                If Case is closed, then reopen Case.
                If Case is open, then flag case as “Rework Needed.”
                Acceptance Criteria
                If unique claim key exists then update claim else create a new claim.
     */
	public void process(List<Daily_Claim__c> dailyClaimsList,
			Map<String, CSA__c> csasByCSA_Number,
			Map<Id, Contact> existingContactsByDailyClaimId,
			List<Contact_Drug__c> existingContact_DrugsList,
			//List<Claim_Information__c> allClaim_InformationBeforeTxList,
			fflib_ISObjectUnitOfWork uowBeforeTx,
			fflib_ISObjectUnitOfWork uowAfterTx
	) {
		System.debug('In Cases:process - Start processing Cases for Daily Claims');

		// Create Cases from the given Daily Claims
		List<SObject> newClaimList = new List<SObject>();
		List<SObject> existingClaimList = new List<SObject>();
		List<SObject> existingReplacementClaimCasesList = new List<SObject>();
		List<SObject> existingContact_DrugList = new List<SObject>();
		List<Case> newEnrollmentCaseList = new List<Case>();
		List<Case> existingEnrollmentCaseList = new List<Case>();
		List<Case> newReimbursementCaseList = new List<Case>();
		List<SObject> existingReimbursementCaseList = new List<SObject>();

		List<Case> existingECaseList = new List<Case>();
		List<Case> existingRCaseList = new List<Case>();
		Set<String> primary_Claim_NumberSet = new Set<String>();
		Set<String> claim_NumberSet = new Set<String>();
		Set<String> claim_SegmentSet = new Set<String>();
		Set<String> claim_LineSet = new Set<String>();
		Set<String> previous_SegmentSet = new Set<String>();
		List<Claim_Information__c> originalClaim_InformationBeforeTxList; //Original Claim List before transaction is committed to DB
		List<Claim_Information__c> existingClaim_InformationBeforeTxList;//Existing Claim List before transaction is committed to DB
		List<Claim_Information__c> allClaim_InformationBeforeTxList = new List<Claim_Information__c>(); //All Claim List before transaction is committed to DB
		List<Claim_Information__c> originalClaim_InformationAfterTxList; //Original Claim List After transaction is committed to DB
		//List<Claim_Information__c> originalEnrollmentClaim_InformationAfterTxList; //Original Claim List After transaction is committed to DB
		List<Claim_Information__c> existingClaim_InformationAfterTxList;//Existing Claim List After transaction is committed to DB
		List<Claim_Information__c> existingClaimToBeReplacedList = new List<Claim_Information__c>(); //Existing LIst of Claims to be replaced
		List<Claim_Information__c> allClaim_InformationAfterTxList = new List<Claim_Information__c>(); //All Claim List After transaction is committed to DB
		List<Claim_Information__c> updatedClaim_InformationList = new List<Claim_Information__c>(); //List of Claims to Conntecdt to Contact Drug & Cases then update.
		List<Contact_Drug__c> updatedContactDrugList = new List<Contact_Drug__c>();
		//Map<String, Id> dailyClaimIdByCSANumber = new Map<String, Id>();
		Map<Id, String> csaNumberByDailyClaimId = new Map<Id, String>();
		//Map<Id, CSA__c> csaByDailyClaimId = new Map<Id, CSA__c>();
		//Map<String, CSA__c> csasByCSA_Number = new Map<String, CSA__c>();
		Map<Id, Claim_Information__c> claimByContact_DrugId = new Map<Id, Claim_Information__c>();
		Map<Id, Claim_Information__c> claimById = new Map<Id, Claim_Information__c>();
		Map<String, Id> claimIdToBeRelplacedByPrevious_Claim = new Map<String, Id>();
		Map<Id, String> claim_NumberByDailyId = new Map<Id, String>();
		Map<String, Claim_Information__c> claimBeforeTransactionByClaim_Number = new Map<String, Claim_Information__c>();
		Map<String, Claim_Information__c> claimAfterTransactionByClaim_Number = new Map<String, Claim_Information__c>();
		Map<Id, Contact_Drug__c> contact_DrugByClaim_InformationId = new Map<Id, Contact_Drug__c>();
		Case enrollmentCase, reimbursementCase;
		Map<Id, Case> existingEnrollmentCaseByClaimId = new Map<Id, Case>();
		Map<Id, Case> existingEnrollmentCaseByContactDrugId = new Map<Id, Case>();
		Map<String, Case> existingEnrollmentCaseByCPrimaryClaimNumber = new Map<String, Case>();
		Map<Id, Case> existingReimbursementCaseByClaimId = new Map<Id, Case>();
		Map<String, List<Case>> existingReplacementCaseListsByPreviousClaim = new Map<String, List<Case>>();
		Map<Id, Id> accountIdByContactId = new Map<Id, Id>();
		Map<Id, Contact> contactByContactId = new Map<Id, Contact>();
		//Map<String, Claim_Information__c> claimBeforeTxByHCPS = new Map<String, Claim_Information__c>(); //Map of Claim by HCPS code before committed to DB
		//Map<String, Claim_Information__c> claimAfterTxByHCPS = new Map<String, Claim_Information__c>(); //Map of Claim by HCPS code after committed to DB
		Map<String, Id> replacementClaimByUCKID = new Map<String, Id>(); //Map of Claim by UCK ID
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
		Map<String, Contact_Drug__c> contact_DrugByContactId = new Map<String, Contact_Drug__c>();
		Map<Id, Contact_Drug__c> contact_DrugById = new Map<Id, Contact_Drug__c>();
		Map<Id, Contact_Drug__c> contact_DrugByClaimId = new Map<Id, Contact_Drug__c>();
		List<Contact> existingSha1Hash_IdMatchedContactsList;
		String claim_NumberSeed, HCPCSCodeTrunc;
		Id generalQueue;
		Map<String, Drug__C> drugByHCPCS = new Map<String, Drug__c>();
		Map<String, Id> drugIdByNDC = new Map<String, Id>();
		Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
		Contact existingContact;
		List<Case> existingEnrollmentCases = new List<Case>();
		List<Case> existingReimbursementCases = new List<Case>();
		List<Case> existingReplacementCaseList = new List<Case>();

		System.debug('In Cases:process - dailyClaimsList Count = ' + dailyClaimsList.size());
		System.debug('In Cases:process - existingContactsByDailyClaimId = ' + existingContactsByDailyClaimId);
		System.debug('In Cases:process - existingContact_DrugsList Count = ' + existingContact_DrugsList.size());
		System.debug('In Cases:process - allClaim_InformationBeforeTxList Count = ' + allClaim_InformationBeforeTxList.size());

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
			contactSHA1HashIdSet.add(sha1Hash_Id);

			//On certain scenarios, Aetna sends the claim for Reprocessing & sends a Replacement claim with a new claim number from ACAS system to Prudent.
			// Since these claims are linked to each other our call center should be able to use the existing case for the new claim.

			//Collect all Replacement claims by UCKID
			//The original UCK ID on the replacement claim will contain the value of a claim ID for an existing claim (Use for matching).
			//  1. On the Initial claim, UCK ID will be “Blank”
			//  2. On the Replacement claim, UCK ID will be present & we need to use this UCK ID and run a match with the Initial Claim ID.
			if(dailyClaimRecord.Previous_Claim__c != null) {
				replacementClaimByUCKID.put(dailyClaimRecord.Previous_Claim__c, dailyClaimRecord.Id);
			}
		}
		System.debug('replacementClaimByUCKID = ' + replacementClaimByUCKID);

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
			System.debug('ndcRecord.Drug__r.J_Code__c = ' + HCPCSCodeTrunc);
			System.debug('ndcRecord.Name = ' + ndcRecord.Name);
			drugIdByNDC.put(ndcRecord.Name, ndcRecord.Drug__c);
		}

		//If drug Coding Level is HCPCS than we only use the HCPCS to identify the drug
		//If drug Coding Level is HCPCS + NDC we Need include the NDC as part of the key to identify the Drug
		for(Daily_Claim__c dailyClaimRecord : dailyClaimsList) {
			HCPCSCodeTrunc = dailyClaimRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			System.debug('dailyClaimRecord.HCPCS_Code__c = ' + HCPCSCodeTrunc);
			System.debug('drugByHCPCS = ' + drugByHCPCS);
			Drug__c drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
			if(drugRecord.Coding_Level__c == 'HCPCS + NDC') {
				NDCSet.add(dailyClaimRecord.NDC__c);
				System.debug('historicalClaimClaim.NDC__c = ' + dailyClaimRecord.NDC__c);
			}
		}
		System.debug('J_Code_IdSet = ' + J_Code_IdSet);
		System.debug('NDCSet = ' + NDCSet);
		System.debug('existingContactIdSet = ' + existingContactIdSet);

		//Create a DomainFactor that used the SObjectType like the Selector factory
		//IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(existingContacts);
		/*
		List<Contact> contactList = new List<Contact>();
		IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
		Map<Id, Contact> existingContactsByDailyClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimsList);
		System.debug('existingContactsByDailyClaimId Count: ' + existingContactsByDailyClaimId.size());
		*/
/*
		ContactsSelector contactsSelector = (ContactsSelector) PMd_Application.Selector.newInstance(Contact.SObjectType);
		existingSha1Hash_IdMatchedContactsList = contactsSelector.selectBySHA1Hash_ID(contactSHA1HashIdSet);
		System.debug('existingSha1Hash_IdMatchedContactsList Count: ' + existingSha1Hash_IdMatchedContactsList.size());
*/
		for(Contact contactRecord : existingContactsByDailyClaimId.values()) {
			existingContactIdSet.add(contactRecord.Id);
			accountIdByContactId.put(contactRecord.Id, contactRecord.AccountId);
			contactByContactId.put(contactRecord.Id, contactRecord);
		}



		//Get Map of CSAs By CSA_Number
		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		//csaByDailyClaimId = cSAsDomain.getCSAsById(dailyClaimIdByCSANumber);
		csasByCSA_Number = cSAsDomain.getCSAsByCSANumber(csaNumberByDailyClaimId);
		System.debug('csasByCSA_Number = ' + csasByCSA_Number);
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
		//Get all Daily_Claim  previous_Segments
		//Get matching Contact_Drugs by Daily_Claims
		for(Daily_Claim__c dailyClaim : dailyClaimsList) {
			System.debug('dailyClaim.Primary_Claim_Number__c = ' + dailyClaim.Primary_Claim_Number__c);
			System.debug('dailyClaim.Claim_Segment__c = ' + dailyClaim.Claim_Segment__c);

			primary_Claim_NumberSet.add(dailyClaim.Primary_Claim_Number__c);
			claim_SegmentSet.add(dailyClaim.Claim_Segment__c);
			claim_LineSet.add(dailyClaim.Claim_Line__c);
			previous_SegmentSet.add(dailyClaim.Previous_Segment__c);

			if(dailyClaim.Previous_Segment__c == '' || dailyClaim.Previous_Segment__c == null) {
				claim_NumberSeed = dailyClaim.Primary_Claim_Number__c + '-' +
						dailyClaim.Claim_Segment__c + '-' +
						dailyClaim.Claim_Line__c;
			} else {
				claim_NumberSeed = dailyClaim.Primary_Claim_Number__c + '-' +
						dailyClaim.Previous_Segment__c + '-' +
						dailyClaim.Claim_Line__c;
			}
			String claim_NumberHashCode =  SHA1UtilService.getBase64SHA1Hash(claim_NumberSeed);
			claim_NumberByDailyId.put(dailyClaim.Id, claim_NumberHashCode);
			claim_NumberSet.add(claim_NumberHashCode);
		}

		//I see the claim ID at this point so may not need to separate before/after commit
		//Get matching existing Claims from Daily Claims before committed to DB

		Claim_InformationsSelector claim_InformationsSelector = (Claim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);

		originalClaim_InformationBeforeTxList = claim_InformationsSelector.selectOriginalClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet);
		//existingClaim_InformationBeforeTxList = claim_InformationsSelector.selectExistingClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet, Previous_SegmentSet);
		existingClaim_InformationBeforeTxList = claim_InformationsSelector.selectExistingClaimsByUniquekey(claim_NumberSet);
		allClaim_InformationBeforeTxList.addAll(originalClaim_InformationBeforeTxList);
		allClaim_InformationBeforeTxList.addAll(existingClaim_InformationBeforeTxList);

		System.debug('BeforeTransaction: originalClaim_InformationBeforeTxList Count: ' + originalClaim_InformationBeforeTxList.size());
		System.debug('BeforeTransaction: existingClaim_InformationBeforeTxList Count: ' + existingClaim_InformationBeforeTxList.size());

		System.debug('BeforeTransaction: allClaim_InformationBeforeTxList Count: ' + allClaim_InformationBeforeTxList.size());

		for (Claim_Information__c claimRecord : allClaim_InformationBeforeTxList) {
			//claimById.put(claimRecord.Id, claimRecord);
			System.debug('BeforeTransaction: claimRecord.Id = ' + claimRecord.Id);
			claimByContact_DrugId.put(claimRecord.Contact_Drug__c, claimRecord);
			Contact_Drug__c contactDrug = contact_DrugByClaim_InformationId.get(claimRecord.Id);
			contact_DrugByClaimId.put(claimRecord.Id, contactDrug);
			claimBeforeTransactionByClaim_Number.put(claimRecord.Claim_Number__c, claimRecord);
			System.debug('In Case: claimRecord.Claim_Number__c = ' + claimRecord.Claim_Number__c);
			System.debug('In Case: claimRecord.Current_Claim_Number__c = ' + claimRecord.Current_Claim_Number__c);
			//claimBeforeTxByHCPS.put(claimRecord.HCPCS_Code__c, claimRecord);
			//System.debug('claimBeforeTxByHCPS: ' + claimBeforeTxByHCPS);
		}
		allClaim_InformationAfterTxList.addAll(allClaim_InformationBeforeTxList);

		try {
			uowBeforeTx.commitWork(); //Commit work now so the claims after transaction have Id available to link to other objects
		}catch(Exception e){
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Cases.process', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), dailyClaimsList[0].Id, null, null, null);
			ErrorLog.commitLogs();
			//throw e;
		}

		//Get matching existing Claims from Daily Claims after committed to DB
		//TODO: I believe the Original Claim is the first claim with Claim Segment 00 but this query would get the Claim that matches the Primary-Segment-Line key. Because all test are passing I don't want to change this now but will include the qury I think it should be for the Reopen Enrollment claims.
		originalClaim_InformationAfterTxList = claim_InformationsSelector.selectOriginalClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet);
		System.debug('originalClaim_InformationAfterTxList = '+ originalClaim_InformationAfterTxList);
		//originalEnrollmentClaim_InformationAfterTxList = claim_InformationsSelector.selectOriginalClaimsByPrimaryClaimNumber(Primary_Claim_NumberSet);
		//System.debug('originalEnrollmentClaim_InformationAfterTxList = '+ originalEnrollmentClaim_InformationAfterTxList);
		//existingClaim_InformationAfterTxList = claim_InformationsSelector.selectExistingClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet, Previous_SegmentSet);
		//existingClaim_InformationAfterTxList = claim_InformationsSelector.selectExistingClaimsByUniquekey(claim_NumberSet);
		existingClaim_InformationAfterTxList = claim_InformationsSelector.selectExistingClaimsByCurrentClaimNumber(claim_NumberSet); //The Claim_Number would have been updated to the next Claim_Number when the CommitWork was called. The Current_Claim_Number will still have the value of the existing Claim_Number.
		//Collect matching existing Claims that will be replaced with Replacement claims
		if(replacementClaimByUCKID.size() > 0) {
			existingClaimToBeReplacedList = claim_InformationsSelector.selectExistingClaimsByUCKID(replacementClaimByUCKID.keySet());
			allClaim_InformationAfterTxList.addAll(existingClaimToBeReplacedList);
			System.debug('AfterTransaction: existingClaimToBeReplacedList Count: ' + existingClaimToBeReplacedList.size());
		}
		allClaim_InformationAfterTxList.addAll(originalClaim_InformationAfterTxList);
		//allClaim_InformationAfterTxList.addAll(originalEnrollmentClaim_InformationAfterTxList);
		allClaim_InformationAfterTxList.addAll(existingClaim_InformationAfterTxList);
		//System.debug('AfterTransaction: originalClaim_InformationAfterTxList Count: ' + originalClaim_InformationAfterTxList.size());
		//System.debug('AfterTransaction: existingClaim_InformationAfterTxList Count: ' + existingClaim_InformationAfterTxList.size());
		//System.debug('AfterTransaction: originalEnrollmentClaim_InformationAfterTxList Count: ' + originalEnrollmentClaim_InformationAfterTxList.size());
		System.debug('AfterTransaction: allClaim_InformationAfterTxList Count: ' + allClaim_InformationAfterTxList.size());

		for (Claim_Information__c claimRecord : allClaim_InformationAfterTxList) {
			claimById.put(claimRecord.Id, claimRecord);
			System.debug('claimById = ' + claimById);
			System.debug('AfterTransaction: claimRecord.Current_Claim_Number__c = ' + claimRecord.Current_Claim_Number__c);
			//claimByContact_DrugId.put(claimRecord.Contact_Drug__c, claimRecord);
			//claimAfterTransactionByClaim_Number.put(claimRecord.Claim_Number__c, claimRecord);
			claimByContact_DrugId.put(claimRecord.Contact_Drug__c, claimRecord);
			Contact_Drug__c contactDrug = contact_DrugByClaim_InformationId.get(claimRecord.Id);
			contact_DrugByClaimId.put(claimRecord.Id, contactDrug);
			claimAfterTransactionByClaim_Number.put(claimRecord.Current_Claim_Number__c, claimRecord);
			//claimAfterTxByHCPS.put(claimRecord.HCPCS_Code__c, claimRecord);
			System.debug('In Case: contact_DrugByClaimId = ' + contact_DrugByClaimId);
			System.debug('In Case: claimAfterTransactionByClaim_Number = ' + claimAfterTransactionByClaim_Number);
		}

		for (Claim_Information__c claimRecord : existingClaimToBeReplacedList) {
			claimIdToBeRelplacedByPrevious_Claim.put(claimRecord.Primary_Claim_Number__c, claimRecord.Id);
		}
		System.debug('claimIdToBeRelplacedByPrevious_Claim = ' + claimIdToBeRelplacedByPrevious_Claim);

		for(Contact_Drug__c existingContact_Drug : existingContact_DrugsList) {
			System.debug('existingContact_Drug.Claim_Information__c = ' + existingContact_Drug.Claim_Information__c);
			contact_DrugByClaim_InformationId.put(existingContact_Drug.Claim_Information__c, existingContact_Drug);
			//contact_DrugByHCPCS_Code.put(existingContact_Drug.HCPCS_Code__c, existingContact_Drug);
			contact_DrugByContactId.put(existingContact_Drug.Contact__c, existingContact_Drug);
			contact_DrugById.put(existingContact_Drug.Id, existingContact_Drug);
			System.debug('existingContact_Drug = ' + existingContact_Drug);
		}
		System.debug('existingContact_DrugList Count = ' + existingContact_DrugsList.size());
		System.debug('contact_DrugByClaim_InformationId = ' + contact_DrugByClaim_InformationId);

		//Get matching Cases from Daily Claims
		CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
		//List<Case> existingEnrollmentCases = casesSelector.selectEnrollmentCaseByClaimId(claimById.keySet());
		if(contact_DrugById.keySet().size() > 0) {
			existingEnrollmentCases = casesSelector.selectEnrollmentCaseByContactDrug(contact_DrugById.keySet());
		}
		if(claimById.keySet().size() > 0) {
			existingReimbursementCases = casesSelector.selectReimbursementCaseByClaimId(claimById.keySet());
		}
		if(claimIdToBeRelplacedByPrevious_Claim.keySet().size() > 0) {
			existingReplacementCaseList = casesSelector.selectReplacementCaseByClaimId(claimIdToBeRelplacedByPrevious_Claim.keySet());
		}
		System.debug('existingEnrollmentCases = ' + existingEnrollmentCases);
		System.debug('existingReimbursementCases = ' + existingReimbursementCases);
		System.debug('existingReplacementCaseList = ' + existingReplacementCaseList);

		for(Case existingEnrollmentCase : existingEnrollmentCases) {
			if(existingEnrollmentCase.Claim_Information__c != null) {
				existingEnrollmentCaseByClaimId.put(existingEnrollmentCase.Claim_Information__c, existingEnrollmentCase);
			}
			if(existingEnrollmentCase.Contact_Drug__c != null) {
				existingEnrollmentCaseByContactDrugId.put(existingEnrollmentCase.Contact_Drug__c, existingEnrollmentCase);
				existingEnrollmentCaseByCPrimaryClaimNumber.put(existingEnrollmentCase.Claim_Information__r.Primary_Claim_Number__c, existingEnrollmentCase);
				System.debug('existingEnrollmentCase.Contact_Drug__c = ' + existingEnrollmentCase.Contact_Drug__c);
				System.debug('existingEnrollmentCase = ' + existingEnrollmentCase);
			}
		}
		System.debug('existingEnrollmentCaseByClaimId = ' + existingEnrollmentCaseByClaimId);
		System.debug('existingEnrollmentCaseByContactDrugId = ' + existingEnrollmentCaseByContactDrugId);
		System.debug('existingEnrollmentCaseByCPrimaryClaimNumber = ' + existingEnrollmentCaseByCPrimaryClaimNumber);

		for(Case existingReimbursementCase : existingReimbursementCases) {
			if(existingReimbursementCase.Claim_Information__c != null) {
				existingReimbursementCaseByClaimId.put(existingReimbursementCase.Claim_Information__c, existingReimbursementCase);
			}
		}
		System.debug('existingReimbursementCaseByClaimId = ' + existingReimbursementCaseByClaimId);

		//Map existing list of Replacement Cases for each Claim by their Claim ID
		List<Case> existingReplacementClaimCaseList;
		String caseClaimNumber;
		for(Case existingReplacementCase : existingReplacementCaseList) {
			if(existingReplacementCase.Claim_Information__c != null) {
				//caseClaimNumber = claimIdToBeRelplacedByPrevious_Claim.get(existingReplacementCase.Claim_Number__c);
				caseClaimNumber = existingReplacementCase.Claim_Number__c;
				if(existingReplacementCaseListsByPreviousClaim.get(caseClaimNumber) == null) {
					existingReplacementClaimCaseList = new List<Case>();
					existingReplacementClaimCaseList.add(existingReplacementCase);
					existingReplacementCaseListsByPreviousClaim.put(caseClaimNumber, existingReplacementClaimCaseList);
				} else {
					existingReplacementClaimCaseList = existingReplacementCaseListsByPreviousClaim.get(caseClaimNumber);
					existingReplacementClaimCaseList.add(existingReplacementCase);
					existingReplacementCaseListsByPreviousClaim.put(caseClaimNumber, existingReplacementClaimCaseList);
				}
			}
		}
		System.debug('existingReplacementCaseListsByPreviousClaim = ' + existingReplacementCaseListsByPreviousClaim);

		for(Daily_Claim__c dailyClaim : dailyClaimsList) {
			Contact contactRecord = existingContactsByDailyClaimId.get(dailyClaim.Id);
			existingContact = contactRecord;
			Claim_Information__c claimRecordBeforeTransaction = claimBeforeTransactionByClaim_Number.get(claim_NumberByDailyId.get(dailyClaim.Id));
			Claim_Information__c claimRecordAfterTransaction = claimAfterTransactionByClaim_Number.get(claim_NumberByDailyId.get(dailyClaim.Id));
			//Claim_Information__c claimRecordAfterTransaction = claimRecordBeforeTransaction;
			//contact_DrugRecord = contact_DrugByHCPCS_Code.get(dailyClaim.HCPCS_Code__c);

			//contact_DrugRecord = contact_DrugByClaim_InformationId.get(claimRecordAfterTransaction.Id);
			//Contact contactRecord = new Contact(Id = claimRecordAfterTransaction.Contact__c);
			//if(contact_DrugRecord != null) {
			//	contactRecord = contactByContactId.get(contact_DrugRecord.Contact__c);
			//}
			System.debug('contact_DrugByClaimId = ' + contact_DrugByClaimId);
			if(contactRecord != null) {
				System.debug('contactRecord.AccountId = ' + contactRecord.AccountId);
			}
			//TODO: Get the Contact_Drug from the existingContact_DrugsList returned after processing the Contact_Drug
			System.debug('In Case:process:HistoricalClaim: existingContact = ' + existingContact);
			if(contactRecord != null) {
				//contact_DrugRecord = contact_DrugByContactId.get(contactRecord.Id);
				//contact_DrugRecord = contact_DrugByClaimId.get(claimRecordAfterTransaction.Id);
				//contact_DrugRecord = contact_DrugById.get(claimRecordAfterTransaction.Contact_Drug__c);
				contact_DrugRecord = contact_DrugByContactId.get(existingContact.Id); //Get the Contact_Drug from the existingContact_DrugsList returned after processing the Contact_Drug
			}
			System.debug('claim_NumberByDailyId = ' + claim_NumberByDailyId);
			System.debug('claimRecordBeforeTransaction = ' + claimRecordBeforeTransaction);
			System.debug('claimRecordAfterTransaction = ' + claimRecordAfterTransaction);
			System.debug('contact_DrugRecord = ' + contact_DrugRecord);
			System.debug('contactRecord = ' + contactRecord);
			//System.debug('claimRecordAfterTransaction.Total_Drug_Cost__c = ' + claimRecordAfterTransaction.Total_Drug_Cost__c);
			/*
			//Check if this is a Replacement Claim
			if (dailyClaim.Previous_Claim__c != null && claimRecordAfterTransaction != null) {
				//Once an existing Claim Matches this Replacement Claim, then we need to link the old case number to this new (Replacement) claim.
				System.Debug('claimRecord.Previous_Claim__c = ' + claimRecordAfterTransaction.Previous_Claim__c);
				existingReplacementClaimCaseList = existingReplacementCaseListsByPreviousClaim.get(dailyClaim.Previous_Claim__c);
				for (Case existingReplacementCase : existingReplacementCaseList) {
					existingReplacementCase.Claim_Information__c = claimRecordAfterTransaction.Id;
					existingReplacementClaimCasesList.add(existingReplacementCase);
				}
			}
			*/
			//If Claim unique key does not exist for the ContactDrug:
			//CSA__c csaRecord = csaByDailyClaimId.get(dailyClaim.Id);
			CSA__c csaRecord = csasByCSA_Number.get(dailyClaim.CSA_Number__c);
			Date goLiveDate = csaRecord.Implementation__r.Contract__r.Go_Live_Date__c;
			System.debug('goLiveDate = '+ goLiveDate);
			//System.debug('claimBeforeTxByHCPS.get(dailyClaim.HCPCS_Code__c) = '+ claimBeforeTxByHCPS.get(dailyClaim.HCPCS_Code__c));
			//Multiple claims will not open multiple Enrollment Cases for matching Contact_Drug
			//if(contact_DrugRecord == null && claimByHCPS.get(dailyClaim.HCPCS_Code__c) == null) {
			if(claimRecordBeforeTransaction == null && claimRecordAfterTransaction != null) {
				System.debug('claimRecordAfterTransaction.EOP_Date__c = ' + claimRecordAfterTransaction.EOP_Date__c);
				//if(claimRecordAfterTransaction == null) {
				//Null go-live date: Set Daily Claim Status to “Go-live Date Null”
				if(goLiveDate != null) {
					//Pre go-live
					if (System.today() < goLiveDate) {
						System.debug('Pre go-live');
						//Then create Enrollment Case.
						//  Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
						//TODO: I believe the existingEnrollmentCase is the Original Enrollment case. existingEnrollmentCaseByContactDrugId could have many ContactDrugs for a Contact but by using the Primary Claim # we can get the Original Enrollment Case. Currently all test are passing so not changing for now.
						Case existingEnrollmentCase = existingEnrollmentCaseByContactDrugId.get(contact_DrugRecord.Id);
						//Case existingEnrollmentCase = existingEnrollmentCaseByCPrimaryClaimNumber.get(dailyClaim.Primary_Claim_Number__c);
						System.debug('existingEnrollmentCaseByContactDrugId = ' + existingEnrollmentCaseByContactDrugId);
						System.debug('contact_DrugRecord.Id = ' + contact_DrugRecord.Id);
						System.debug('existingEnrollmentCase = ' + existingEnrollmentCase);
						if (existingEnrollmentCase == null) {
							//Create Enrollment Case
							System.debug('Create Enrollment Case');
							enrollmentCase = createEnrollmentCaseFrom(dailyClaim,
									enrollmentCaseInfo,
									claimRecordAfterTransaction,
									contactRecord,
									contact_DrugRecord,
									csaRecord,
									goLiveDate
							);

							//enrollmentCase.Follow_up_Time__c = DateTime.now();
							//enrollmentCase.Claim_Information__r.EOP_Date__c =  dailyClaim.EOP_Date__c;
							enrollmentCase = mapDailyClaimToCase(dailyClaim, enrollmentCase);
							newEnrollmentCaseList.add(enrollmentCase);
							if (claimRecordAfterTransaction != null) {
								updatedClaim_InformationList.add(claimRecordAfterTransaction);
							}
							updatedContactDrugList.add(contact_DrugRecord);
						} else {
							System.debug('Update Existing Enrollment Case');
							existingEnrollmentCase.Daily_Claim__c = dailyClaim.Id;
							if(goLiveDate == null) {
								existingEnrollmentCase.Daily_Claim_Status__c = 'Go-live Date Null';
							} else {
								existingEnrollmentCase.Daily_Claim_Status__c = null;
							}

							//Reopen an Enrollment Case when the following is TRUE:
							//A claim has been received for a Contact that has a previous Enrollment Case (trigger) in which
							//Case “Status is “Outreach Completed”
							//The Contact Drug “CPA Enrollment Status” is "Not on File
							if(existingEnrollmentCase.Status == 'Outreach Completed'
									&& contact_DrugRecord.Copay_Enrollment_Status__c == 'Not on File'
									&& contact_DrugRecord.Member_Ineligible_for_CPA__c == FALSE){
								//Reopen an Enrollment Case
								existingEnrollmentCase.Status = 'Verify Fax Number';
							}
							existingEnrollmentCase.EOP_Date__c = claimRecordAfterTransaction.EOP_Date__c;
							existingEnrollmentCase = mapDailyClaimToCase(dailyClaim, existingEnrollmentCase);
							existingECaseList.add(existingEnrollmentCase);
						}
						//Post go-live. Check if this is a Replacement Claim
					} else if (dailyClaim.Previous_Claim__c == null) {
						System.debug('Post go-live');
						//Then create Enrollment Case and Reimbursement Case.
						//   Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for matching Contact_Drug
						System.debug('existingEnrollmentCaseByContactDrugId = ' + existingEnrollmentCaseByContactDrugId);
						//System.debug('contact_DrugRecord.Id = ' + contact_DrugRecord.Id);
						//TODO: I believe the existingEnrollmentCase is the Original Enrollment case. existingEnrollmentCaseByContactDrugId could have many ContactDrugs for a Contact but by using the Primary Claim # we can get the Original Enrollment Case. Currently all test are passing so not changing for now.
						Case existingEnrollmentCase =existingEnrollmentCaseByContactDrugId.get(contact_DrugRecord.Id);
						//Case existingEnrollmentCase = existingEnrollmentCaseByClaimId.get(claimRecordAfterTransaction.Id);
						//Case existingEnrollmentCase = existingEnrollmentCaseByCPrimaryClaimNumber.get(dailyClaim.Primary_Claim_Number__c);
						System.debug('existingEnrollmentCase = ' + existingEnrollmentCase);
						if (existingEnrollmentCase == null) {
							System.debug('Create Enrollment Case');
							enrollmentCase = createEnrollmentCaseFrom(dailyClaim,
									enrollmentCaseInfo,
									claimRecordAfterTransaction,
									contactRecord,
									contact_DrugRecord,
									csaRecord,
									goLiveDate
							);
							/*
							enrollmentCase = new Case();
							//Relate claims to other objects in the AfterInsert Case Trigger
							if (claimRecordAfterTransaction != null) {
								enrollmentCase.Claim_Information__c = claimRecordAfterTransaction.Id;
								//enrollmentCase.Drug_Cost__c = claimRecordAfterTransaction.Total_Drug_Cost__c;
								claimRecordAfterTransaction.Contact__c = contactRecord.Id;
								claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
								contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
							}
							System.debug('claimRecordAfterTransaction.Contact_Drug__c = ' + contact_DrugRecord.Id);
							//enrollmentCase.Type = 'Enrollment';
							enrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
							enrollmentCase = mapDailyClaimToCase(dailyClaim, enrollmentCase);
							enrollmentCase.Contact_Drug__c = contact_DrugRecord.Id;
							enrollmentCase.ContactId = contact_DrugRecord.Contact__c;
							enrollmentCase.AccountId = csaRecord.Account__c;
							enrollmentCase.Daily_Claim__c = dailyClaim.Id;
							if (goLiveDate == null) {
								enrollmentCase.Daily_Claim_Status__c = 'Go-live Date Null';
							}
							System.debug('enrollmentCase = ' + enrollmentCase);
							*/
							//enrollmentCase.Follow_up_Time__c = DateTime.now();
							enrollmentCase.Claim_Information__c = claimRecordAfterTransaction.Id;
							enrollmentCase.EOP_Date__c = claimRecordAfterTransaction.EOP_Date__c;
							enrollmentCase = mapDailyClaimToCase(dailyClaim, enrollmentCase);
							newEnrollmentCaseList.add(enrollmentCase);
							if (claimRecordAfterTransaction != null) {
								updatedClaim_InformationList.add(claimRecordAfterTransaction);
							}
							updatedContactDrugList.add(contact_DrugRecord);
							/*
                            //Reopen an Enrollment Case when the following is TRUE:
                            //A claim has been received for a Contact that has a previous Enrollment Case (trigger) in which
                            //Case “Status is “Outreach Completed”
                            //The Contact Drug “CPA Enrollment Status” is "Not on File
                            } else if(existingEnrollmentCase.Status == 'Outreach Completed'
                                    && existingEnrollmentCase.Contact_Drug__r.Copay_Enrollment_Status__c == 'Not on File') {
                                //Reopen Enrollment Case
                                System.debug('Reopen Enrollment Case');
                                Case reopenEnrollmentCase = createEnrollmentCaseFrom(dailyClaim,
                                        enrollmentCaseInfo,
                                        claimRecordAfterTransaction,
                                        contactRecord,
                                        contact_DrugRecord,
                                        csaRecord,
                                        goLiveDate
                                );
                                reopenEnrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
                                reopenEnrollmentCase = mapDailyClaimToCase(dailyClaim, reopenEnrollmentCase);
                                newEnrollmentCaseList.add(reopenEnrollmentCase);

                                if (claimRecordAfterTransaction != null) {
                                    updatedClaim_InformationList.add(claimRecordAfterTransaction);
                                }
                                updatedContactDrugList.add(contact_DrugRecord);

                                //Default original case to Default values
                                //Log Case Results:
                                //HCP Action required: Outreach Needed
                                //Status: Verify Fax Number
                                existingEnrollmentCase.HCP_Enrollment_Outreach__c = 'Outreach Needed';
                                existingEnrollmentCase.Status = 'Verify Fax Number';
                                existingECaseList.add(existingEnrollmentCase);
                            */
						} else {
							//Update Existing Enrollment Case.
							System.debug('Update Existing Enrollment Case');
							existingEnrollmentCase.Daily_Claim__c = dailyClaim.Id;
							if (goLiveDate == null) {
								existingEnrollmentCase.Daily_Claim_Status__c = 'Go-live Date Null';
							} else {
								existingEnrollmentCase.Daily_Claim_Status__c = null;
							}
							existingEnrollmentCase.Claim_Information__c = claimRecordAfterTransaction.Id;
							existingEnrollmentCase.EOP_Date__c = claimRecordAfterTransaction.EOP_Date__c;
							existingEnrollmentCase = mapDailyClaimToCase(dailyClaim, existingEnrollmentCase);
/*
							if (existingEnrollmentCase.Status == 'Outreach Completed'
									&& existingEnrollmentCase.Contact_Drug__r.Copay_Enrollment_Status__c == 'Not on File') {
								//Default original case to Default values
								//Log Case Results:
								//HCP Action required: Outreach Needed
								//Status: Verify Fax Number
								enrollmentCase.HCP_Enrollment_Outreach__c = 'Outreach Needed';
								enrollmentCase.Status = 'Verify Fax Number';
							}
*/
							existingECaseList.add(existingEnrollmentCase);
						}

						//Reopen an Enrollment Case when the following is TRUE:
						//A claim has been received for a Contact that has a previous Enrollment Case (trigger) in which
						//Case “Status is “Outreach Completed”
						//The Contact Drug “CPA Enrollment Status” is "Not on File and the 'Member Ineligible for CPA' is not checked.
						existingEnrollmentCase =existingEnrollmentCaseByContactDrugId.get(contact_DrugRecord.Id);
						//existingEnrollmentCase = existingEnrollmentCaseByCPrimaryClaimNumber.get(dailyClaim.Primary_Claim_Number__c);
						System.debug('existingEnrollmentCase = ' + existingEnrollmentCase);
						if(existingEnrollmentCase != null
								&& existingEnrollmentCase.Status == 'Outreach Completed'
								&& existingEnrollmentCase.Contact_Drug__r.Copay_Enrollment_Status__c == 'Not on File'
								&& contact_DrugRecord.Member_Ineligible_for_CPA__c == FALSE) {
							//Reopen Enrollment Case
							System.debug('Reopen Enrollment Case');
							/*
							Case reopenEnrollmentCase = createEnrollmentCaseFrom(dailyClaim,
									enrollmentCaseInfo,
									claimRecordAfterTransaction,
									contactRecord,
									contact_DrugRecord,
									csaRecord,
									goLiveDate
							);
							reopenEnrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
							reopenEnrollmentCase = mapDailyClaimToCase(dailyClaim, reopenEnrollmentCase);
							newEnrollmentCaseList.add(reopenEnrollmentCase);
							*/
							if (claimRecordAfterTransaction != null) {
								updatedClaim_InformationList.add(claimRecordAfterTransaction);
							}
							updatedContactDrugList.add(contact_DrugRecord);

							//Default original case to Default values
							//Log Case Results:
							//HCP Action required: Outreach Needed
							//Status: Verify Fax Number
							existingEnrollmentCase.HCP_Enrollment_Outreach__c = 'Outreach Needed';
							existingEnrollmentCase.Status = 'Verify Fax Number';
							existingEnrollmentCase.EOP_Date__c = claimRecordAfterTransaction.EOP_Date__c;
							existingECaseList.add(existingEnrollmentCase);
						}

						//Create  Reimbursement Case.
						System.debug('Create Reimbursement Case');
						reimbursementCase = new Case();
						/*
				if(claimRecord != null) {
					reimbursementCase.Claim_Information__c = claimRecord.Id;
					claimRecord.Contact__c = contactRecord.Id;
					reimbursementCase.Claim_Information__c = claimRecord.Id;
					claimRecord.Contact_Drug__c = contact_DrugRecord.Id;
				}
				*/
						//reimbursementCase.Type = 'Reimbursement';
						reimbursementCase.RecordTypeId = reimbursementCaseInfo.getRecordTypeId();
						if (claimRecordAfterTransaction != null) {
							reimbursementCase.Claim_Information__c = claimRecordAfterTransaction.Id;
							claimRecordAfterTransaction.Contact__c = contactRecord.Id;
							claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
							contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
							reimbursementCase.EOP_Date__c = claimRecordAfterTransaction.EOP_Date__c;
						}
						System.debug('claimRecordAfterTransaction.Contact_Drug__c = ' + contact_DrugRecord.Id);
						reimbursementCase.Contact_Drug__c = contact_DrugRecord.Id;
						reimbursementCase.ContactId = contact_DrugRecord.Contact__c;
						reimbursementCase.AccountId = csaRecord.Account__c;
						reimbursementCase.Daily_Claim__c = dailyClaim.Id;
						if (goLiveDate == null) {
							reimbursementCase.Daily_Claim_Status__c = 'Go-live Date Null';
						}
						System.debug('reimbursementCase = ' + reimbursementCase);
						reimbursementCase = mapDailyClaimToCase(dailyClaim, reimbursementCase);
						newReimbursementCaseList.add(reimbursementCase);
						if (claimRecordAfterTransaction != null) {
							updatedClaim_InformationList.add(claimRecordAfterTransaction);
						}
						updatedContactDrugList.add(contact_DrugRecord);
						//Check if this is a Replacement Claim
					} else if (dailyClaim.Previous_Claim__c != null && claimRecordAfterTransaction != null) {
						//Once an existing Claim Matches this Replacement Claim, then we need to link the old case number to this new (Replacement) claim.
						System.Debug('claimRecord.Previous_Claim__c = ' + claimRecordAfterTransaction.Previous_Claim__c);
						existingReplacementClaimCaseList = existingReplacementCaseListsByPreviousClaim.get(dailyClaim.Previous_Claim__c);
						for (Case existingReplacementCase : existingReplacementCaseList) {
							existingReplacementCase.Claim_Information__c = claimRecordAfterTransaction.Id;
							existingReplacementCase.EOP_Date__c = claimRecordAfterTransaction.EOP_Date__c;
							existingReplacementClaimCasesList.add(existingReplacementCase);
						}
					}
				}
				//TODO: Look into removing all code in this condition. I believe this is duplicate code & this condition should replace the previous condition. Not changing now because all test have passed.
			} else if (claimRecordAfterTransaction != null) {

				//  The old Claim, Segment, and Line will be shown from the Daily Claims related list (bottom section of this Claim).
				//  Done in Claim_Information onAfterTrigger below
				/*
                If Enrollment Case already exists:
                    Then do not create a new Enrollment Case.
                */
				//enrollmentCase = existingEnrollmentCaseByClaimId.get(claimRecordAfterTransaction.Id);
				//enrollmentCase = existingEnrollmentCaseByContactDrugId.get(contact_DrugRecord.Id);
				enrollmentCase = existingEnrollmentCaseByCPrimaryClaimNumber.get(dailyClaim.Primary_Claim_Number__c);
				Case existingEnrollmentCase = enrollmentCase;
				System.debug('existingEnrollmentCase = ' + existingEnrollmentCase);
				if(enrollmentCase == null) {
					//Create  Enrollment Case.
					System.debug('Create Enrollment Case');
					enrollmentCase = createEnrollmentCaseFrom(dailyClaim,
							enrollmentCaseInfo,
							claimRecordAfterTransaction,
							contactRecord,
							contact_DrugRecord,
							csaRecord,
							goLiveDate
					);
					/*
					enrollmentCase = new Case();
					if(claimRecordAfterTransaction != null) {
						enrollmentCase.Claim_Information__c = claimRecordAfterTransaction.Id;
						//enrollmentCase.Drug_Cost__c = claimRecordAfterTransaction.Total_Drug_Cost__c;
						claimRecordAfterTransaction.Contact__c = contactRecord.Id;
						claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
					}
					//enrollmentCase.Type = 'Enrollment';
					enrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
					enrollmentCase.Contact_Drug__c = contact_DrugRecord.Id;
					enrollmentCase.ContactId = contact_DrugRecord.Contact__c;
					enrollmentCase.AccountId = csaRecord.Account__c;
					contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
					System.debug('claimRecordAfterTransaction.Contact_Drug__c = '+ contact_DrugRecord.Id);
					contact_DrugRecord.Related_Case__c = enrollmentCase.Id;
					enrollmentCase.Daily_Claim__c = dailyClaim.Id;
					if (goLiveDate == null) {
						enrollmentCase.Daily_Claim_Status__c = 'Go-live Date Null';
					}
					*/
					enrollmentCase.EOP_Date__c = claimRecordAfterTransaction.EOP_Date__c;
					enrollmentCase = mapDailyClaimToCase(dailyClaim, enrollmentCase);
					newEnrollmentCaseList.add(enrollmentCase);
					existingContact_DrugList.add(contact_DrugRecord);
					if(claimRecordAfterTransaction != null) {
						updatedClaim_InformationList.add(claimRecordAfterTransaction);
					}
					updatedContactDrugList.add(contact_DrugRecord);

					/*
                    //Reopen an Enrollment Case when the following is TRUE:
                    //A claim has been received for a Contact that has a previous Enrollment Case (trigger) in which
                    //Case “Status is “Outreach Completed”
                    //The Contact Drug “CPA Enrollment Status” is "Not on File
                    } else if(existingEnrollmentCase.Status == 'Outreach Completed'
                            && existingEnrollmentCase.Contact_Drug__r.Copay_Enrollment_Status__c == 'Not on File') {
                        //Reopen Enrollment Case
                        System.debug('Reopen Enrollment Case');
                        Case reopenEnrollmentCase = createEnrollmentCaseFrom(dailyClaim,
                                enrollmentCaseInfo,
                                claimRecordAfterTransaction,
                                contactRecord,
                                contact_DrugRecord,
                                csaRecord,
                                goLiveDate
                        );
                        reopenEnrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
                        reopenEnrollmentCase = mapDailyClaimToCase(dailyClaim, reopenEnrollmentCase);
                        newEnrollmentCaseList.add(reopenEnrollmentCase);

                        if (claimRecordAfterTransaction != null) {
                            updatedClaim_InformationList.add(claimRecordAfterTransaction);
                        }
                        updatedContactDrugList.add(contact_DrugRecord);

                        //Update Existing Enrollment Case
                        System.debug('Update Existing Enrollment Case');
                        if(contact_DrugRecord != null) {
                            enrollmentCase.Contact_Drug__c = contact_DrugRecord.Id;
                            enrollmentCase.ContactId = contact_DrugRecord.Contact__c;
                            enrollmentCase.AccountId = csaRecord.Account__c;
                            if(claimRecordAfterTransaction != null) {
                                claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
                                if(contactRecord != null) {
                                    claimRecordAfterTransaction.Contact__c = contactRecord.Id;
                                }
                                contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
                                enrollmentCase.Claim_Information__c = claimRecordAfterTransaction.Id;
                                //enrollmentCase.Drug_Cost__c = claimRecordAfterTransaction.Total_Drug_Cost__c;
                            }
                        }
                        contact_DrugRecord.Related_Case__c = enrollmentCase.Id;
                        System.debug('claimRecordAfterTransaction.Contact_Drug__c = '+ contact_DrugRecord.Id);
                        enrollmentCase.Daily_Claim__c = dailyClaim.Id;
                        if (goLiveDate == null) {
                            enrollmentCase.Daily_Claim_Status__c = 'Go-live Date Null';
                        } else {
                            enrollmentCase.Daily_Claim_Status__c = null;
                        }
                        //Default original case to Default values
                        //Log Case Results:
                        //HCP Action required: Outreach Needed
                        //Status: Verify Fax Number
                        enrollmentCase.HCP_Enrollment_Outreach__c = 'Outreach Needed';
                        enrollmentCase.Status = 'Verify Fax Number';
                        existingECaseList.add(enrollmentCase);
                        existingContact_DrugList.add(contact_DrugRecord);
                        if(claimRecordAfterTransaction != null) {
                            updatedClaim_InformationList.add(claimRecordAfterTransaction);
                        }
                        updatedContactDrugList.add(contact_DrugRecord);
                        */
				} else {
					//Update Existing Enrollment Case
					System.debug('Update Existing Enrollment Case');
					if (contact_DrugRecord != null) {
						enrollmentCase.Contact_Drug__c = contact_DrugRecord.Id;
						enrollmentCase.ContactId = contact_DrugRecord.Contact__c;
						enrollmentCase.AccountId = csaRecord.Account__c;
						if (claimRecordAfterTransaction != null) {
							claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
							if (contactRecord != null) {
								claimRecordAfterTransaction.Contact__c = contactRecord.Id;
							}
							contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
							enrollmentCase.Claim_Information__c = claimRecordAfterTransaction.Id;
							enrollmentCase.EOP_Date__c = claimRecordAfterTransaction.EOP_Date__c;
							//enrollmentCase.Drug_Cost__c = claimRecordAfterTransaction.Total_Drug_Cost__c;
						}
					}
					contact_DrugRecord.Related_Case__c = enrollmentCase.Id;
					System.debug('claimRecordAfterTransaction.Contact_Drug__c = ' + contact_DrugRecord.Id);
					enrollmentCase.Daily_Claim__c = dailyClaim.Id;
					if (goLiveDate == null) {
						enrollmentCase.Daily_Claim_Status__c = 'Go-live Date Null';
					} else {
						enrollmentCase.Daily_Claim_Status__c = null;
					}
					/*
					if (existingEnrollmentCase.Status == 'Outreach Completed'
							&& existingEnrollmentCase.Contact_Drug__r.Copay_Enrollment_Status__c == 'Not on File') {
						//Default original case to Default values
						//Log Case Results:
						//HCP Action required: Outreach Needed
						//Status: Verify Fax Number
						enrollmentCase.HCP_Enrollment_Outreach__c = 'Outreach Needed';
						enrollmentCase.Status = 'Verify Fax Number';
					}
					*/
					if (enrollmentCase.Most_Recent_Service_From_Date__c <= dailyClaim.Date_Of_Service_From__c) {
						enrollmentCase = mapDailyClaimToCase(dailyClaim, enrollmentCase);
						existingECaseList.add(enrollmentCase);
					}
					//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
					//enrollmentCase.Service_Provider_Fax__c = getServiceProviderFax(contactRecord);

					existingContact_DrugList.add(contact_DrugRecord);
					if(claimRecordAfterTransaction != null) {
						updatedClaim_InformationList.add(claimRecordAfterTransaction);
					}
					updatedContactDrugList.add(contact_DrugRecord);
				}

				//Reopen an Enrollment Case when the following is TRUE:
				//A claim has been received for a Contact that has a previous Enrollment Case (trigger) in which
				//Case “Status is “Outreach Completed”
				//The Contact Drug “CPA Enrollment Status” is "Not on File and the 'Member Ineligible for CPA' is not checked.
				existingEnrollmentCase = existingEnrollmentCaseByCPrimaryClaimNumber.get(dailyClaim.Primary_Claim_Number__c);
				System.debug('existingEnrollmentCase = ' + existingEnrollmentCase);
				if(existingEnrollmentCase != null
						&& existingEnrollmentCase.Status == 'Outreach Completed'
						&& existingEnrollmentCase.Contact_Drug__r.Copay_Enrollment_Status__c == 'Not on File'
						&& contact_DrugRecord.Member_Ineligible_for_CPA__c == FALSE) {
					//Reopen Enrollment Case
					System.debug('Reopen Enrollment Case');
					/*
					Case reopenEnrollmentCase = createEnrollmentCaseFrom(dailyClaim,
							enrollmentCaseInfo,
							claimRecordAfterTransaction,
							contactRecord,
							contact_DrugRecord,
							csaRecord,
							goLiveDate
					);
					reopenEnrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
					reopenEnrollmentCase = mapDailyClaimToCase(dailyClaim, reopenEnrollmentCase);
					newEnrollmentCaseList.add(reopenEnrollmentCase);
					*/
					if (claimRecordAfterTransaction != null) {
						updatedClaim_InformationList.add(claimRecordAfterTransaction);
					}
					updatedContactDrugList.add(contact_DrugRecord);

					//Default original case to Default values
					//Log Case Results:
					//HCP Action required: Outreach Needed
					//Status: Verify Fax Number
					existingEnrollmentCase.HCP_Enrollment_Outreach__c = 'Outreach Needed';
					existingEnrollmentCase.Status = 'Verify Fax Number';
					if(existingEnrollmentCase.Most_Recent_Service_From_Date__c <= dailyClaim.Date_Of_Service_From__c)
						existingEnrollmentCase = mapDailyClaimToCase(dailyClaim, existingEnrollmentCase);{
						existingECaseList.add(existingEnrollmentCase);
					}

				}

				/*
                If Reimbursement Case already exists:
                    Then do not create a new Reimbursement Case.
                    and Only “Original” Claim Indicators will create new Reimbursement Cases.
                */
				reimbursementCase = existingReimbursementCaseByClaimId.get(claimRecordAfterTransaction.Id);
				System.debug('reimbursementCase = '+ reimbursementCase);
				if(reimbursementCase == null && (claimRecordAfterTransaction.Previous_Segment__c==null || claimRecordAfterTransaction.Previous_Segment__c=='')) {
					//Create Reimbursement Case.
					System.debug('Create Reimbursement Case');
					reimbursementCase = new Case();
					//reimbursementCase.Follow_up_Time__c = DateTime.now();
					reimbursementCase.Claim_Information__c = claimRecordAfterTransaction.Id;
					//reimbursementCase.Type = 'Reimbursement';
					reimbursementCase.RecordTypeId = reimbursementCaseInfo.getRecordTypeId();
					reimbursementCase.Contact_Drug__c = contact_DrugRecord.Id;
					reimbursementCase.ContactId = contact_DrugRecord.Contact__c;
					reimbursementCase.AccountId = csaRecord.Account__c;
					//reimbursementCase.Drug_Cost__c = claimRecordAfterTransaction.Total_Drug_Cost__c;
					claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
					claimRecordAfterTransaction.Contact__c = contactRecord.Id;
					reimbursementCase.Claim_Information__c = claimRecordAfterTransaction.Id;
					System.debug('claimRecordAfterTransaction.Contact_Drug__c = '+ contact_DrugRecord.Id);
					reimbursementCase.Daily_Claim__c = dailyClaim.Id;
					if (goLiveDate == null) {
						reimbursementCase.Daily_Claim_Status__c = 'Go-live Date Null';
					}

					reimbursementCase = mapDailyClaimToCase(dailyClaim, reimbursementCase);
					//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
					//reimbursementCase.Service_Provider_Fax__c = getServiceProviderFax(contactRecord);

					newReimbursementCaseList.add(reimbursementCase);
					if(claimRecordAfterTransaction != null) {
						updatedClaim_InformationList.add(claimRecordAfterTransaction);
					}
					updatedContactDrugList.add(contact_DrugRecord);
				} else if(reimbursementCase != null) {
					//Update Existing Reimbursement Case
					System.debug('Update Existing Reimbursement Case');
					//If Case is closed, then reopen Case.
					if (reimbursementCase.Status == 'Outreach Completed') {
						//reimbursementCase.Status = 'Verify Fax Number';
					}
					//If Case is open, then flag case as “Rework Needed.”
					if (reimbursementCase.Status != 'Outreach Completed') {
						//TODO: Find out how the case is flagged as 'Rework Needed'
					}

					if(contact_DrugRecord != null) {
						reimbursementCase.Contact_Drug__c = contact_DrugRecord.Id;
						reimbursementCase.ContactId = contact_DrugRecord.Contact__c;
						reimbursementCase.AccountId = csaRecord.Account__c;
						claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
						claimRecordAfterTransaction.Contact__c = contactRecord.Id;
						reimbursementCase.Claim_Information__c = claimRecordAfterTransaction.Id;
						reimbursementCase.EOP_Date__c = claimRecordAfterTransaction.EOP_Date__c;
						//reimbursementCase.Drug_Cost__c = claimRecordAfterTransaction.Total_Drug_Cost__c;

					}
					contact_DrugRecord.Related_Case__c = reimbursementCase.Id;
					System.debug('claimRecordAfterTransaction.Contact_Drug__c = '+ contact_DrugRecord.Id);

					reimbursementCase.Daily_Claim__c = dailyClaim.Id;
					if (goLiveDate == null) {
						reimbursementCase.Daily_Claim_Status__c = 'Go-live Date Null';
					} else {
						reimbursementCase.Daily_Claim_Status__c = null;
					}
					//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
					//reimbursementCase.Service_Provider_Fax__c = getServiceProviderFax(contactRecord);

					existingRCaseList.add(reimbursementCase);
					existingContact_DrugList.add(contact_DrugRecord);
					if(claimRecordAfterTransaction != null) {
						updatedClaim_InformationList.add(claimRecordAfterTransaction);
					}
					updatedContactDrugList.add(contact_DrugRecord);
				}
				/*
                Acceptance Criteria
                If unique claim key exists then update claim else create a new claim.
             */
			}

		}

		List<Case> allNewCases = new List<Case>();

		allNewCases.addAll(newEnrollmentCaseList);
		allNewCases.addAll(newReimbursementCaseList);

		if(allNewCases.size() > 0) {
			if (mapPrudentMedBenQueues.size() > 0) {
				for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
					String queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
					switch on queue {
						when 'General' { //when queue is General
							generalQueue = GroupId;
						}
					}
				}
			}

			for (Case caseRecord : allNewCases) {
				if (generalQueue != null) {
					caseRecord.OwnerId = generalQueue; //Case Owner defaults to GeneralQueue
					//caseRecord.Follow_up_Time__c = DateTime.now();
				}
			}
		}

		// Route New Cases
		//List<Case> allNewCasesRoutedList = allNewCases;
		List<Case> allNewCasesRoutedList = CaseService.reRouteNewCaseRoutingRecords(allNewCases);
		System.debug('allNewCasesRoutedList.size() = ' + allNewCasesRoutedList.size());

		uowAfterTx.registerDirty(existingContact_DrugList);
		uowAfterTx.registerDirty(existingRCaseList);
		uowAfterTx.registerDirty(existingECaseList);
		uowAfterTx.registerDirty(existingReplacementClaimCasesList);
		uowAfterTx.registerDirty(updatedClaim_InformationList);
		uowAfterTx.registerDirty(updatedContactDrugList);
		uowAfterTx.registerNew(allNewCasesRoutedList);
		//uowAfterTx.registerNew(newEnrollmentCaseList);
		//uowAfterTx.registerNew(newReimbursementCaseList);

		System.debug('In Cases:process - Stop processing Cases for Daily Claims');
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
				Create a single Enrollment Case for the latest Claim. Multiple claims will not open multiple Enrollment Cases for the same HCPCS.
			If Claim unique key does exist for the ContactDrug:
				No new Enrollment Case will be created.
     */
	public void process(List<Historical_Claim__c> historicalClaimsList,
			Map<Id, Contact> existingContactsByHistoricalClaimId,
			List<Contact_Drug__c> existingContact_DrugsList,
			fflib_ISObjectUnitOfWork uowBeforeTx,
			fflib_ISObjectUnitOfWork uowAfterTx)
	{
		System.debug('In Cases:process - Start processing Cases Historical Claims');

		// Create Claims from the given Historical Claims
		List<SObject> newClaimList = new List<SObject>();
		List<SObject> existingClaimList = new List<SObject>();
		List<SObject> existingContact_DrugList = new List<SObject>();
		List<SObject> newIntroductionCaseList = new List<SObject>();
		List<SObject> existingEnrollmentCaseList = new List<SObject>();
		List<SObject> newReimbursementCaseList = new List<SObject>();
		List<SObject> existingReimbursementCaseList = new List<SObject>();

		List<Case> existingICaseList = new List<Case>();
		List<Case> existingRCaseList = new List<Case>();
		Set<String> primary_Claim_NumberSet = new Set<String>();
		Set<String> claim_SegmentSet = new Set<String>();
		Set<String> claim_LineSet = new Set<String>();
		Set<String> previous_SegmentSet = new Set<String>();
		List<Claim_Information__c> originalClaim_InformationBeforeTxList = new List<Claim_Information__c>(); //Original Claim List before transaction is committed to DB
		List<Claim_Information__c> existingClaim_InformationBeforeTxList = new List<Claim_Information__c>();//Existing Claim List before transaction is committed to DB
		List<Claim_Information__c> allClaim_InformationBeforeTxList = new List<Claim_Information__c>(); //All Claim List before transaction is committed to DB
		List<Claim_Information__c> originalClaim_InformationAfterTxList = new List<Claim_Information__c>(); //Original Claim List After transaction is committed to DB
		//List<Claim_Information__c> originalEnrollmentClaim_InformationAfterTxList; //Original Claim List After transaction is committed to DB
		List<Claim_Information__c> existingClaim_InformationAfterTxList = new List<Claim_Information__c>();//Existing Claim List After transaction is committed to DB
		List<Claim_Information__c> allClaim_InformationAfterTxList = new List<Claim_Information__c>(); //All Claim List After transaction is committed to DB
		List<Claim_Information__c> updatedClaim_InformationList = new List<Claim_Information__c>();
		List<Contact_Drug__c> updatedContactDrugList = new List<Contact_Drug__c>();
		Map<String, Id> historicalClaimIdByCSANumber = new Map<String, Id>();
		Map<Id, String> csaNumberByHistoricalClaimId = new Map<Id, String>();
		Map<Id, CSA__c> csaByHistoricalClaimId = new Map<Id, CSA__c>();
		Map<String, CSA__c> csasByCSA_Number = new Map<String, CSA__c>();
		Map<Id, Claim_Information__c> claimByContact_DrugId = new Map<Id, Claim_Information__c>();
		Map<Id, Claim_Information__c> mostRecentClaimByContact_Drug = new Map<Id, Claim_Information__c>();
		Map<Id, Claim_Information__c> claimById = new Map<Id, Claim_Information__c>();
		Map<Id, String> claim_NumberByHistoricalId = new Map<Id, String>();
		Map<String, Claim_Information__c> claimBeforeTransactionByClaim_Number = new Map<String, Claim_Information__c>();
		Map<String, Claim_Information__c> claimAfterTransactionByClaim_Number = new Map<String, Claim_Information__c>();
		Map<Id, Contact_Drug__c> contact_DrugByClaim_InformationId = new Map<Id, Contact_Drug__c>();
		Case introductionCase, enrollmentCase, reimbursementCase;
		Map<Id, Case> existingIntroductionCaseByClaimId = new Map<Id, Case>();
		Map<Id, Case> existingIntroductionCaseByContactDrugId = new Map<Id, Case>();
		Map<Id, Case> existingEnrollmentCaseByClaimId = new Map<Id, Case>();
		Map<Id, Case> existingEnrollmentCaseByContactDrugId = new Map<Id, Case>();
		Map<Id, Case> existingReimbursementCaseByClaimId = new Map<Id, Case>();
		Map<Id, Id> accountIdByContactId = new Map<Id, Id>();
		Map<Id, Contact> contactByContactId = new Map<Id, Contact>();
		//Map<String, Claim_Information__c> claimBeforeTxByHCPS = new Map<String, Claim_Information__c>(); //Map of Claim by HCPS code before committed to DB
		//Map<String, Claim_Information__c> claimAfterTxByHCPS = new Map<String, Claim_Information__c>(); //Map of Claim by HCPS code after committed to DB
		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo introductionCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Introduction');
		Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');
		Schema.RecordTypeInfo reimbursementCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');
		String sha1Hash_Id;
		Set<String> J_Code_IdSet = new Set<String>();
		Set<String> NDCSet = new Set<String>{''};
		Set<String> contactSHA1HashIdSet = new Set<String>();
		Set<Id> existingContactIdSet = new Set<Id>();
		Set<Id> existingContactDrugIdSet = new Set<Id>();
		Contact_Drug__c contact_DrugRecord;
		Map<String, Contact_Drug__c> contact_DrugByHCPCS_Code = new Map<String, Contact_Drug__c>();
		Map<String, Contact_Drug__c> contact_DrugByContactId = new Map<String, Contact_Drug__c>();
		Map<Id, Contact_Drug__c> contact_DrugById = new Map<Id, Contact_Drug__c>();
		Map<String, Drug__C> drugByHCPCS = new Map<String, Drug__c>();
		List<Contact> existingSha1Hash_IdMatchedContactsList;
		String claim_NumberSeed, HCPCSCodeTrunc;
		Set<String> claim_NumberSet = new Set<String>();
		Contact existingContact;

		System.debug('historicalClaimsList Count = ' + historicalClaimsList.size());
		if(existingContact_DrugsList != null) {
			System.debug('In Cases:process - existingContact_DrugsList Count = ' + existingContact_DrugsList.size());
		}

		//Get csaByHistoricalClaimId to determine Pre/Post-Go-Live
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
		System.debug('existingContactIdSet = ' + existingContactIdSet);

		//Create a DomainFactor that used the SObjectType like the Selector factory
		//IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(existingContacts);
		List<Contact> contactList = new List<Contact>();
		IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
		//Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByHistoricalClaimId(historicalClaimsList);
		System.debug('In Historical_Claim:Cases:process: existingContactsByHistoricalClaimId Count: ' + existingContactsByHistoricalClaimId.size());
/*
		ContactsSelector contactsSelector = (ContactsSelector) PMd_Application.Selector.newInstance(Contact.SObjectType);
		existingSha1Hash_IdMatchedContactsList = contactsSelector.selectBySHA1Hash_ID(contactSHA1HashIdSet);
		System.debug('existingSha1Hash_IdMatchedContactsList Count: ' + existingSha1Hash_IdMatchedContactsList.size());
*/
		for(Contact contactRecord : existingContactsByHistoricalClaimId.values()) {
			existingContactIdSet.add(contactRecord.Id);
			accountIdByContactId.put(contactRecord.Id, contactRecord.AccountId);
			contactByContactId.put(contactRecord.Id, contactRecord);
		}

		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		//csaByHistoricalClaimId = cSAsDomain.getCSAsById(historicalClaimIdByCSANumber);
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
		//Get all Historical_Claim  previous_Segments
		//Get matching Contact_Drugs by Historical_Claims
		for(Historical_Claim__c historicalClaim : historicalClaimsList) {
			System.debug('historicalClaim.Primary_Claim_Number__c = ' + historicalClaim.Primary_Claim_Number__c);
			//System.debug('historicalClaim.Claim_Segment__c = ' + historicalClaim.Claim_Segment__c);
			System.debug('historicalClaim.Claim_Line__c = ' + historicalClaim.Claim_Line__c);

			primary_Claim_NumberSet.add(historicalClaim.Primary_Claim_Number__c);
			//claim_SegmentSet.add(historicalClaim.Claim_Segment__c);
			claim_LineSet.add(historicalClaim.Claim_Line__c);
			//previous_SegmentSet.add(historicalClaim.Previous_Segment__c);

			//if(historicalClaim.Previous_Segment__c == '' || historicalClaim.Previous_Segment__c == null) {
			claim_NumberSeed = historicalClaim.Primary_Claim_Number__c + '-' +
					//historicalClaim.Claim_Segment__c + '-' +
					historicalClaim.Claim_Line__c;
			/*
			} else {
				claim_NumberSeed = historicalClaim.Primary_Claim_Number__c +
						historicalClaim.Previous_Segment__c +
						historicalClaim.Claim_Line__c;
			}
			*/
			String claim_NumberHashCode =  SHA1UtilService.getBase64SHA1Hash(claim_NumberSeed);
			claim_NumberByHistoricalId.put(historicalClaim.Id, claim_NumberHashCode);
			claim_NumberSet.add(claim_NumberHashCode);
			System.debug('claim_NumberHashCode = ' + claim_NumberHashCode);
		}

		//I see the claim ID at this point so may not need to separate before/after commit
		//Get matching existing Claims from Historical Claims before committed to DB
		Claim_InformationsSelector claim_InformationsSelector = (Claim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);
		//originalClaim_InformationBeforeTxList = claim_InformationsSelector.selectOriginalClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet);
		//if(existingContactDrugIdSet.size() == 0) {
		originalClaim_InformationBeforeTxList = claim_InformationsSelector.selectOriginalClaimsByUniquekey(claim_NumberSet);
		//} else {
		//TODO This isn't doing anything because we don't have the Contact Drugs yet.
		existingClaim_InformationBeforeTxList = claim_InformationsSelector.selectExistingClaimsByContactDrugIdSet(existingContactDrugIdSet);
		//}
		//existingClaim_InformationBeforeTxList = claim_InformationsSelector.selectExistingClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet, Previous_SegmentSet);
		//existingClaim_InformationBeforeTxList = claim_InformationsSelector.selectExistingClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet, Previous_SegmentSet, existingContactIdSet);
		allClaim_InformationBeforeTxList.addAll(originalClaim_InformationBeforeTxList);
		allClaim_InformationBeforeTxList.addAll(existingClaim_InformationBeforeTxList);
		System.debug('BeforeTransaction: originalClaim_InformationBeforeTxList Count: ' + originalClaim_InformationBeforeTxList.size());
		System.debug('BeforeTransaction: existingClaim_InformationBeforeTxList Count: ' + existingClaim_InformationBeforeTxList.size());
		System.debug('BeforeTransaction: allClaim_InformationBeforeTxList Count: ' + allClaim_InformationBeforeTxList.size());

		for (Claim_Information__c claimRecord : allClaim_InformationBeforeTxList) {
			//claimById.put(claimRecord.Id, claimRecord);
			//TODO This isn't doing anything because we don't have the Contact Drugs yet.
			claimByContact_DrugId.put(claimRecord.Contact_Drug__c, claimRecord);
			claimBeforeTransactionByClaim_Number.put(claimRecord.Claim_Number__c, claimRecord);
			//claimBeforeTxByHCPS.put(claimRecord.HCPCS_Code__c, claimRecord);
		}
		existingContactDrugIdSet = claimByContact_DrugId.keySet();
		System.debug('BeforeTransaction: existingContactDrugIdSet = ' + existingContactDrugIdSet);
		try {
			uowBeforeTx.commitWork(); //Commit work now so the claims after transaction have Id available to link to other objects
		}catch(Exception e){
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Cases.process Historical_Claim', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, historicalClaimsList[0].Id, null, null);
			ErrorLog.commitLogs();
			//throw e;
		}

		//Get matching existing Claims from Historical Claims before committed to DB
		//originalClaim_InformationAfterTxList = claim_InformationsSelector.selectOriginalClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet);
		//if(existingContactDrugIdSet.size() == 0) {
		originalClaim_InformationAfterTxList = claim_InformationsSelector.selectOriginalClaimsByUniquekey(claim_NumberSet);
		//originalEnrollmentClaim_InformationAfterTxList = claim_InformationsSelector.selectOriginalClaimsByPrimaryClaimNumber(Primary_Claim_NumberSet);
		//System.debug('originalEnrollmentClaim_InformationAfterTxList = '+ originalEnrollmentClaim_InformationAfterTxList);
		//} else {
		existingClaim_InformationAfterTxList = claim_InformationsSelector.selectExistingClaimsByContactDrugIdSet(existingContactDrugIdSet);
		//	}
		//existingClaim_InformationAfterTxList = claim_InformationsSelector.selectExistingClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet, Previous_SegmentSet);
		//existingClaim_InformationAfterTxList = claim_InformationsSelector.selectExistingClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet, Previous_SegmentSet, existingContactIdSet);
		//existingClaim_InformationAfterTxList = claim_InformationsSelector.selectExistingClaimsByUniquekey(existingContactDrugIdSet);
		allClaim_InformationAfterTxList.addAll(originalClaim_InformationAfterTxList);
		//allClaim_InformationAfterTxList.addAll(originalEnrollmentClaim_InformationAfterTxList);
		allClaim_InformationAfterTxList.addAll(existingClaim_InformationAfterTxList);
		System.debug('AfterTransaction: originalClaim_InformationAfterTxList Count: ' + originalClaim_InformationAfterTxList.size());
		//System.debug('AfterTransaction: originalEnrollmentClaim_InformationAfterTxList Count: ' + originalEnrollmentClaim_InformationAfterTxList.size());
		System.debug('AfterTransaction: existingClaim_InformationAfterTxList Count: ' + existingClaim_InformationAfterTxList.size());
		System.debug('AfterTransaction: allClaim_InformationAfterTxList Count: ' + allClaim_InformationAfterTxList.size());

		//SOQL Order is not working. I believe it is because the records are being updated & inserted in the same transaction.
		//Sort record be descending Date_Of_Service_From__c
/*		for (Claim_Information__c existingClaimRecord : existingClaim_InformationAfterTxList) {
			System.debug('existingClaimRecord.Date_Of_Service_From__c = ' + existingClaimRecord.Date_Of_Service_From__c);
		}
*/
		for (Claim_Information__c claimRecord : allClaim_InformationAfterTxList) {
			claimById.put(claimRecord.Id, claimRecord);
			System.debug('AfterTransaction: claimRecord.Id = ' + claimRecord.Id);
			//claimByContact_DrugId.put(claimRecord.Contact_Drug__c, claimRecord);
			//for (Claim_Information__c claimRecordSorted : allClaim_InformationAfterTxList) {
			//	if(claimRecordSorted.Date_Of_Service_From__c > claimRecord.Date_Of_Service_From__c) {
			claimByContact_DrugId.put(claimRecord.Contact_Drug__c, claimRecord);
			System.debug('In Case: claimRecord.Contact_Drug__c = ' + claimRecord.Contact_Drug__c);
			claimAfterTransactionByClaim_Number.put(claimRecord.Claim_Number__c, claimRecord); //Needs to be the most recent Claim by Service_From_Date
			//	}
			//}
			//claimAfterTxByHCPS.put(claimRecord.HCPCS_Code__c, claimRecord);
			System.debug('In Case: claimAfterTransactionByClaim_Number = ' + claimAfterTransactionByClaim_Number);
		}

		for(Contact_Drug__c existingContact_Drug : existingContact_DrugsList) {
			//existingContactDrugIdSet.add(existingContact_Drug.Id);
			contact_DrugByClaim_InformationId.put(existingContact_Drug.Claim_Information__c, existingContact_Drug);
			//contact_DrugByHCPCS_Code.put(existingContact_Drug.HCPCS_Code__c, existingContact_Drug);
			contact_DrugByContactId.put(existingContact_Drug.Contact__c, existingContact_Drug);
			contact_DrugById.put(existingContact_Drug.Id, existingContact_Drug);
			System.debug('existingContact_Drug = ' + existingContact_Drug);
		}
		System.debug('existingContact_DrugList Count = ' + existingContact_DrugsList.size());
		System.debug('In Historical_Claim:Cases:process: existingContact_DrugList Count = ' + existingContact_DrugsList.size());

		existingClaim_InformationAfterTxList = claim_InformationsSelector.selectExistingClaimsByContactDrugIdSet(contact_DrugById.keySet());
		allClaim_InformationAfterTxList.addAll(existingClaim_InformationAfterTxList);
		System.debug('AfterTransaction: allClaim_InformationAfterTxList Count: ' + allClaim_InformationAfterTxList.size());

		//Get matching Cases from Historical Claims
		CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);

		List<Case> existingIntroductionCaseCases = casesSelector.selectIntroductionCaseByContactDrug(contact_DrugById.keySet());
		List<Case> existingReimbursementCases = casesSelector.selectReimbursementCaseByClaimId(claimById.keySet());

		for(Case existingIntroductionCase : existingIntroductionCaseCases) {
			if(existingIntroductionCase.Claim_Information__c != null) {
				existingIntroductionCaseByClaimId.put(existingIntroductionCase.Claim_Information__c, existingIntroductionCase);
			}
			if(existingIntroductionCase.Contact_Drug__c != null) {
				existingIntroductionCaseByContactDrugId.put(existingIntroductionCase.Contact_Drug__c, existingIntroductionCase);
			}
		}

		for(Case existingReimbursementCase : existingReimbursementCases) {
			if(existingReimbursementCase.Claim_Information__c != null) {
				existingReimbursementCaseByClaimId.put(existingReimbursementCase.Claim_Information__c, existingReimbursementCase);
			}
		}

		//Set<Id> contactDrugIdSet = contact_DrugById.keySet();
		//AggregateResult[] groupedMostRecentClaimResults = [SELECT Id, Max(Date_Of_Service_From__c) FROM Claim_Information__c WHERE Contact_Drug__c IN :contactDrugIdSet GROUP BY Id];
		//List<Claim_Information__c> caseClaimInformations = [SELECT Id FROM
		//Id mostRecentClaimId = (Id)groupedMostRecentClaimResults[0].get('Id');
		//Claim_Information__c mostRecentClaim =  new Claim_Information__c(Id=mostRecentClaimId);

		for(Historical_Claim__c historicalClaim : historicalClaimsList) {
			Contact contactRecord = existingContactsByHistoricalClaimId.get(historicalClaim.Id);
			existingContact = contactRecord;
			System.debug('In Case:process:HistoricalClaim: existingContact = ' + existingContact);
			Claim_Information__c claimRecordBeforeTransaction = claimBeforeTransactionByClaim_Number.get(claim_NumberByhistoricalId.get(historicalClaim.Id));
			Claim_Information__c claimRecordAfterTransaction = claimAfterTransactionByClaim_Number.get(claim_NumberByHistoricalId.get(historicalClaim.Id));
			//contact_DrugRecord = contact_DrugByHCPCS_Code.get(historicalClaim.HCPCS_Code__c);
			if(contactRecord != null) {
				//contact_DrugRecord = contact_DrugByContactId.get(contactRecord.Id);
				//contact_DrugRecord = contact_DrugById.get(claimRecordAfterTransaction.Contact_Drug__c);
				contact_DrugRecord = contact_DrugByContactId.get(existingContact.Id);
			}
			System.debug('contact_DrugRecord = ' + contact_DrugRecord);

			//Claim_Information__c mostRecentClaim = mostRecentClaimByContact_Drug.get(contact_DrugRecord.Id);
			Claim_Information__c mostRecentClaim;
			//Contact contactRecord = new Contact(Id = claimRecordAfterTransaction.Contact__c);

			if(allClaim_InformationAfterTxList.size() > 0) {
				mostRecentClaim = getMostRecentClaim(allClaim_InformationAfterTxList);
			} else {
				mostRecentClaim = claimRecordAfterTransaction;
			}


			//Claim_Information__c mostRecentClaim = (Claim_Information__c)groupedMostRecentClaimResults[0];

			//if(contact_DrugRecord != null) {
			//	contactRecord = contactByContactId.get(contact_DrugRecord.Contact__c);
			//}
			System.debug('claim_NumberByHistoricalId = ' + claim_NumberByHistoricalId);
			System.debug('claimRecordBeforeTransaction = ' + claimRecordBeforeTransaction);
			System.debug('claimRecordAfterTransaction = ' + claimRecordAfterTransaction);
			//System.debug('mostRecentClaim.Date_Of_Service_From__c = '+ mostRecentClaim.Date_Of_Service_From__c);
			System.debug('claimRecordAfterTransaction.Contact_Drug__c = ' + claimRecordAfterTransaction.Contact_Drug__c);
			System.debug('contact_DrugRecord = ' + contact_DrugRecord);
			System.debug('contactRecord = ' + contactRecord);
			System.debug('contactRecord.AccountId = ' + contactRecord.AccountId);
			//System.debug('claimRecordAfterTransaction.Total_Drug_Cost__c = ' + claimRecordAfterTransaction.Total_Drug_Cost__c);

			//If Claim unique key does not exist for the ContactDrug:
			//CSA__c csaRecord = csaByHistoricalClaimId.get(historicalClaim.Id);
			CSA__c csaRecord = csasByCSA_Number.get(historicalClaim.CSA_Number__c);
			Date goLiveDate = csaRecord.Implementation__r.Contract__r.Go_Live_Date__c;
			System.debug('goLiveDate = '+ goLiveDate);
			//System.debug('claimBeforeTxByHCPS.get(historicalClaim.HCPCS_Code__c) = '+ claimBeforeTxByHCPS.get(historicalClaim.HCPCS_Code__c));
			//Multiple claims will not open multiple Introduction Cases for the same HCPCS.
			//if(contact_DrugRecord == null && claimByHCPS.get(historicalClaim.HCPCS_Code__c) == null) {
			if(claimRecordBeforeTransaction == null) {
				//Then create Introduction Case.
				//  Create a single Introduction Case for the latest Claim. Multiple claims will not open multiple Introduction Cases for the same HCPCS.
				introductionCase = existingIntroductionCaseByContactDrugId.get(contact_DrugRecord.Id);
				System.debug('existingIntroductionCaseByContactDrugId.get(contact_DrugRecord.Id) = ' + existingIntroductionCaseByContactDrugId.get(contact_DrugRecord.Id));
				if (introductionCase == null) {
					//Create Introduction Case
					System.debug('Create Introduction Case');
					introductionCase = new Case();
					//introductionCase.Follow_up_Time__c = DateTime.now();
					if (claimRecordAfterTransaction != null) {
						//introductionCase.Claim_Information__c = claimRecordAfterTransaction.Id; //Needs to be the most recent Claim by Service_From_Date
						claimRecordAfterTransaction.Contact__c = contactRecord.Id;
						contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
					}
					System.debug('mostRecentClaim = '+ mostRecentClaim);
					System.debug('mostRecentClaim.Date_Of_Service_From__c = '+ mostRecentClaim.Date_Of_Service_From__c);
					if(mostRecentClaim != null) {
						introductionCase.Claim_Information__c = mostRecentClaim.Id; //Needs to be the most recent Claim by Service_From_Date
						mostRecentClaim.Contact__c = contactRecord.Id;
						contact_DrugRecord.Claim_Information__c = mostRecentClaim.Id;
					}

					introductionCase.RecordTypeId = introductionCaseInfo.getRecordTypeId();
					//Get contact_DrugRecord
					if (contact_DrugRecord != null && claimRecordAfterTransaction != null) {
						introductionCase.Contact_Drug__c = contact_DrugRecord.Id;
						introductionCase.ContactId = contact_DrugRecord.Contact__c;
						introductionCase.AccountId = csaRecord.Account__c;
						claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
						claimRecordAfterTransaction.Contact__c = contact_DrugRecord.Contact__c;
						contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
						System.debug('claimRecordAfterTransaction.Contact_Drug__c = '+ claimRecordAfterTransaction.Contact_Drug__c);
					}
					if(mostRecentClaim != null) {
						mostRecentClaim.Contact_Drug__c = contact_DrugRecord.Id;
						mostRecentClaim.Contact__c = contact_DrugRecord.Contact__c;
						contact_DrugRecord.Claim_Information__c = mostRecentClaim.Id;
					}

					System.debug('contact_DrugRecord.Claim_Information__c = '+ contact_DrugRecord.Claim_Information__c);
					introductionCase = mapHistoricalClaimToCase(historicalClaim, introductionCase);
					//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
					//introductionCase.Service_Provider_Fax__c = getServiceProviderFax(contactRecord);

					newIntroductionCaseList.add(introductionCase);
					if(mostRecentClaim != null) {
						updatedClaim_InformationList.add(mostRecentClaim);
					}// else {
					if(claimRecordAfterTransaction != null) {
						updatedClaim_InformationList.add(claimRecordAfterTransaction);
					}
					if(contact_DrugRecord != null) {
						updatedContactDrugList.add(contact_DrugRecord);
					}
/*
					//Reopen an Introduction Case when the following is TRUE:
					//A claim has been received for a Contact that has a previous Introduction Case (trigger) in which
					//Case “Status is “Outreach Completed”
					//The Contact Drug “CPA Entroduction Status” is "Not on File
				} else if(introductionCase.Status == 'Outreach Completed'
						&& introductionCase.Contact_Drug__r.Copay_Introduction_Status__c == 'Not on File'
						&& contact_DrugRecord.Member_Ineligible_for_CPA__c == FALSE) {
					//Reopen Introduction Case
					System.debug('Reopen Introduction Case');
					Case reopenintroductionCase = new Case();
					if (claimRecordAfterTransaction != null) {
						reopenIntroductionCase.Claim_Information__c = claimRecordAfterTransaction.Id; //Needs to be the most recent Claim by Service_From_Date
						claimRecordAfterTransaction.Contact__c = contactRecord.Id;
						contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
					}
					if(mostRecentClaim != null) {
						reopenIntroductionCase.Claim_Information__c = mostRecentClaim.Id; //Needs to be the most recent Claim by Service_From_Date
						mostRecentClaim.Contact__c = contactRecord.Id;
						contact_DrugRecord.Claim_Information__c = mostRecentClaim.Id;
					}

					reopeniIntroductionCase.RecordTypeId = introductionCaseInfo.getRecordTypeId();
					//Get contact_DrugRecord
					if (contact_DrugRecord != null && claimRecordAfterTransaction != null) {
						reopenIntroductionCase.Contact_Drug__c = contact_DrugRecord.Id;
						reopenIntroductionCase.ContactId = contact_DrugRecord.Contact__c;
						reopenIntroductionCase.AccountId = csaRecord.Account__c;
						claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
						claimRecordAfterTransaction.Contact__c = contact_DrugRecord.Contact__c;
						contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
						System.debug('claimRecordAfterTransaction.Contact_Drug__c = '+ claimRecordAfterTransaction.Contact_Drug__c);
					}
					if(mostRecentClaim != null) {
						mostRecentClaim.Contact_Drug__c = contact_DrugRecord.Id;
						mostRecentClaim.Contact__c = contact_DrugRecord.Contact__c;
						contact_DrugRecord.Claim_Information__c = mostRecentClaim.Id;
					}

					System.debug('contact_DrugRecord.Claim_Information__c = '+ contact_DrugRecord.Claim_Information__c);
					reopenIntroductionCase = mapHistoricalClaimToCase(historicalClaim, reopenIntroductionCase);
					//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone

					newIntroductionCaseList.add(reopenIntroductionCase);
					if(mostRecentClaim != null) {
						updatedClaim_InformationList.add(mostRecentClaim);
					}// else {
					if(claimRecordAfterTransaction != null) {
						updatedClaim_InformationList.add(claimRecordAfterTransaction);
					}
					if(contact_DrugRecord != null) {
						updatedContactDrugList.add(contact_DrugRecord);
					}
					//Default original case to Default values
					//Log Case Results:
					//HCP Action required: Outreach Needed
					//Status: Verify Fax Number
					introductionCase.HCP_Introduction_Outreach__c = 'Outreach Needed';
					introductiontCase.Status = 'Verify Fax Number';
					existingICaseList.add(introductionCase);
	*/
				} else {
					//Introduction Case Exist
					System.debug('Introduction Case Exist');

					if (contact_DrugRecord != null) {
						introductionCase.Contact_Drug__c = contact_DrugRecord.Id;
						introductionCase.ContactId = contact_DrugRecord.Contact__c;
						introductionCase.AccountId = csaRecord.Account__c;

						if (claimRecordAfterTransaction != null) {
							claimRecordAfterTransaction.Contact__c = contactRecord.Id;
							claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
							//claimRecordAfterTransaction.Contact__c = contact_DrugRecord.Contact__c;
							contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
							introductionCase.Claim_Information__c = claimRecordAfterTransaction.Id;
							System.debug('claimRecordAfterTransaction.Contact_Drug__c = ' + claimRecordAfterTransaction.Contact_Drug__c);
							System.debug('contact_DrugRecord.Claim_Information__c = ' + contact_DrugRecord.Claim_Information__c);
						}
						if (mostRecentClaim != null) {
							mostRecentClaim.Contact_Drug__c = contact_DrugRecord.Id;
							mostRecentClaim.Contact__c = contactRecord.Id;
							//mostRecentClaim.Contact__c = contact_DrugRecord.Contact__c;
							contact_DrugRecord.Claim_Information__c = mostRecentClaim.Id;
							introductionCase.Claim_Information__c = mostRecentClaim.Id;
							System.debug('mostRecentClaim.Contact_Drug__c = ' + mostRecentClaim.Contact_Drug__c);
							System.debug('contact_DrugRecord.Claim_Information__c = ' + contact_DrugRecord.Claim_Information__c);
							System.debug('introductionCase.Claim_Information__c = ' + introductionCase.Claim_Information__c);
						}
					}
					contact_DrugRecord.Related_Case__c = introductionCase.Id;
					if(introductionCase.Most_Recent_Service_From_Date__c <= historicalClaim.Date_Of_Service_From__c) {
						introductionCase = mapHistoricalClaimToCase(historicalClaim, introductionCase);
						existingICaseList.add(introductionCase);
					}
					//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
					//introductionCase.Service_Provider_Fax__c = getServiceProviderFax(contactRecord);

					existingContact_DrugList.add(contact_DrugRecord);

					if(mostRecentClaim != null) {
						updatedClaim_InformationList.add(mostRecentClaim);
					}
					if(claimRecordAfterTransaction != null) {
						updatedClaim_InformationList.add(claimRecordAfterTransaction);
					}
					if (contact_DrugRecord != null) {
						updatedContactDrugList.add(contact_DrugRecord);
					}
				}
			} else {

				//  The old Claim, Segment, and Line will be shown from the Historical Claims related list (bottom section of this Claim).
				//  Done in Claim_Information onAfterTrigger below
				/*
                If Introduction Case already exists:
                    Then do not create a new Introduction Case.
                */
				/*
				if(mostRecentClaim != null) {
					introductionCase = existingIntroductionCaseByClaimId.get(mostRecentClaim.Id);
				} else {
					introductionCase = existingIntroductionCaseByClaimId.get(claimRecordAfterTransaction.Id);
				}
				*/
				introductionCase = existingIntroductionCaseByContactDrugId.get(contact_DrugRecord.Id);
				System.debug('claimRecordAfterTransaction.Id = '+claimRecordAfterTransaction.Id);
				System.debug('existingIntroductionCaseByClaimId = '+existingIntroductionCaseByClaimId);
				System.debug('introductionCase = '+introductionCase);
				if(introductionCase == null) {
					//Create Introduction Case.
					System.debug('Create Introduction Case');
					introductionCase = new Case();

					if(claimRecordAfterTransaction != null) {
						introductionCase.Claim_Information__c = claimRecordAfterTransaction.Id;
						claimRecordAfterTransaction.Contact__c = contactRecord.Id;
						claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
						claimRecordAfterTransaction.Contact__c = contact_DrugRecord.Contact__c;
					}
					if(mostRecentClaim != null) {
						introductionCase.Claim_Information__c = mostRecentClaim.Id;
						mostRecentClaim.Contact__c = contactRecord.Id;
						mostRecentClaim.Contact_Drug__c = contact_DrugRecord.Id;
						mostRecentClaim.Contact__c = contact_DrugRecord.Contact__c;
					}

					introductionCase.RecordTypeId = introductionCaseInfo.getRecordTypeId();
					if(contact_DrugRecord != null) {
						introductionCase.Contact_Drug__c = contact_DrugRecord.Id;
						introductionCase.ContactId = contact_DrugRecord.Contact__c;
						introductionCase.AccountId = csaRecord.Account__c;
						if(mostRecentClaim != null) {
							contact_DrugRecord.Claim_Information__c = mostRecentClaim.Id;
						} else {
							contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
						}
						System.debug('claimRecordAfterTransaction.Contact_Drug__c = '+ claimRecordAfterTransaction.Contact_Drug__c);
						System.debug('contact_DrugRecord.Claim_Information__c = '+ contact_DrugRecord.Claim_Information__c);
					}
					contact_DrugRecord.Related_Case__c = introductionCase.Id;

					introductionCase = mapHistoricalClaimToCase(historicalClaim, introductionCase);
					//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone

					newIntroductionCaseList.add(introductionCase);
					existingContact_DrugList.add(contact_DrugRecord);

					if(mostRecentClaim != null) {
						updatedClaim_InformationList.add(mostRecentClaim);
					}
					if(claimRecordAfterTransaction != null) {
						updatedClaim_InformationList.add(claimRecordAfterTransaction);
					}
					if(contact_DrugRecord != null) {
						updatedContactDrugList.add(contact_DrugRecord);
					}
				} else {
					//Update Existing Introduction Case
					System.debug('Update Existing Introduction Case');
					if(contact_DrugRecord != null) {
						introductionCase.Contact_Drug__c = contact_DrugRecord.Id;
						introductionCase.ContactId = contact_DrugRecord.Contact__c;
						introductionCase.AccountId = csaRecord.Account__c;
						if(claimRecordAfterTransaction != null) {
							claimRecordAfterTransaction.Contact__c = contactRecord.Id;
							claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
							//claimRecordAfterTransaction.Contact__c = contact_DrugRecord.Contact__c;
							contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
							introductionCase.Claim_Information__c = claimRecordAfterTransaction.Id;
							System.debug('claimRecordAfterTransaction.Contact_Drug__c = '+ claimRecordAfterTransaction.Contact_Drug__c);
							System.debug('contact_DrugRecord.Claim_Information__c = '+ contact_DrugRecord.Claim_Information__c);
						}
						if(mostRecentClaim != null) {
							mostRecentClaim.Contact_Drug__c = contact_DrugRecord.Id;
							mostRecentClaim.Contact__c = contactRecord.Id;
							//mostRecentClaim.Contact__c = contact_DrugRecord.Contact__c;
							contact_DrugRecord.Claim_Information__c = mostRecentClaim.Id;
							introductionCase.Claim_Information__c = mostRecentClaim.Id;
							System.debug('mostRecentClaim.Contact_Drug__c = '+ mostRecentClaim.Contact_Drug__c);
							System.debug('contact_DrugRecord.Claim_Information__c = '+ contact_DrugRecord.Claim_Information__c);
						}
					}
					contact_DrugRecord.Related_Case__c = introductionCase.Id;

					if(introductionCase.Most_Recent_Service_From_Date__c <= historicalClaim.Date_Of_Service_From__c) {
						introductionCase = mapHistoricalClaimToCase(historicalClaim, introductionCase);
						existingICaseList.add(introductionCase);
					}
					//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
					//introductionCase.Service_Provider_Fax__c = getServiceProviderFax(contactRecord);
					existingContact_DrugList.add(contact_DrugRecord);

					if(mostRecentClaim != null) {
						updatedClaim_InformationList.add(mostRecentClaim);
					}
					if(claimRecordAfterTransaction != null) {
						updatedClaim_InformationList.add(claimRecordAfterTransaction);
					}
					if(contact_DrugRecord != null) {
						updatedContactDrugList.add(contact_DrugRecord);
					}
				}
				/*
                Acceptance Criteria
                If unique claim key exists then update claim else create a new claim.
             */
			}

		}

		uowAfterTx.registerDirty(existingContact_DrugList);
		uowAfterTx.registerDirty(existingRCaseList);
		uowAfterTx.registerDirty(existingICaseList);
		uowAfterTx.registerDirty(updatedClaim_InformationList);
		uowAfterTx.registerNew(newIntroductionCaseList);
		uowAfterTx.registerNew(newReimbursementCaseList);

		System.debug('In Cases:process - Stop processing Cases for Historical Claims');
	}

	private Claim_Information__c getMostRecentClaim(List<Claim_Information__c> existingClaim_InformationAfterTxList) {
		Claim_Information__c mostRecentClaim = existingClaim_InformationAfterTxList[0];
		for(Claim_Information__c claimRecord: existingClaim_InformationAfterTxList) {
			if(claimRecord.Date_Of_Service_From__c >= mostRecentClaim.Date_Of_Service_From__c) {
				mostRecentClaim = claimRecord;
			}
			System.debug('claimRecord.Date_Of_Service_From__c = ' + claimRecord.Date_Of_Service_From__c);
			System.debug('mostRecentClaim.Date_Of_Service_From__c = ' + mostRecentClaim.Date_Of_Service_From__c);
		}
		return mostRecentClaim;
	}

	/*
Summary

The next step in Daily claims is to create or update claims.

Requirements
    PA processing logic:
		Look for existing PA record linked to Contact profile.
		If PA does not exist based on logic above:
			Then create a new PA record and create new Enrollment Case.
		If PA does exist based on logic above:
			No new Enrollment Case will be created.
			Then update existing PA record with new data.
			The old PAs will be shown on the PA related list section in the bottom section of the Enrollment Case.

		Acceptance Criteria
			If PA exists then update enrollment case else create enrollment case.
     */
	public void process(List<Prior_Auth__c> priorAuthList,
			List<Contact_Drug__c> existingContact_DrugsList,
			fflib_ISObjectUnitOfWork uow)
	{
		System.debug('In Cases:process - Start processing Cases for Prior Auth');

		// Create Cases & from the given Prior Auth
		List<SObject> newPriorAuthList = new List<SObject>();
		List<SObject> existingPriorAuthList = new List<SObject>();
		List<SObject> existingContact_DrugList = new List<SObject>();
		List<SObject> newEnrollmentCaseList = new List<SObject>();
		List<SObject> existingEnrollmentCaseList = new List<SObject>();
		List<SObject> newReimbursementCaseList = new List<SObject>();
		List<SObject> existingReimbursementCaseList = new List<SObject>();

		List<Case> existingECaseList = new List<Case>();
		List<Case> existingRCaseList = new List<Case>();
		Set<String> primary_Claim_NumberSet = new Set<String>();
		Set<String> claim_SegmentSet = new Set<String>();
		Set<String> claim_LineSet = new Set<String>();
		Set<String> previous_SegmentSet = new Set<String>();
		List<Claim_Information__c> originalClaim_InformationBeforeTxList; //Original Claim List before transaction is committed to DB
		List<Claim_Information__c> existingClaim_InformationBeforeTxList;//Existing Claim List before transaction is committed to DB
		List<Claim_Information__c> allClaim_InformationBeforeTxList = new List<Claim_Information__c>(); //All Claim List before transaction is committed to DB
		List<Claim_Information__c> originalClaim_InformationAfterTxList; //Original Claim List After transaction is committed to DB
		List<Claim_Information__c> existingClaim_InformationAfterTxList;//Existing Claim List After transaction is committed to DB
		List<Claim_Information__c> allClaim_InformationAfterTxList = new List<Claim_Information__c>(); //All Claim List After transaction is committed to DB
		List<Claim_Information__c> updatedClaim_InformationList = new List<Claim_Information__c>();
		//Map<String, Id> priorAuthIdByCSANumber = new Map<String, Id>();
		Map<Id, String> csaNumberByPriorAuthId = new Map<Id, String>();
		//Map<Id, CSA__c> csaByPriorAuthId = new Map<Id, CSA__c>();
		Map<String, CSA__c> csasByCSA_Number = new Map<String, CSA__c>();
		Map<Id, Claim_Information__c> claimByContact_DrugId = new Map<Id, Claim_Information__c>();
		Map<Id, Claim_Information__c> claimById = new Map<Id, Claim_Information__c>();
		Map<Id, String> claim_NumberByDailyId = new Map<Id, String>();
		Map<String, Claim_Information__c> claimBeforeTransactionByClaim_Number = new Map<String, Claim_Information__c>();
		Map<String, Claim_Information__c> claimAfterTransactionByClaim_Number = new Map<String, Claim_Information__c>();
		Map<Id, Contact_Drug__c> contact_DrugByClaim_InformationId = new Map<Id, Contact_Drug__c>();
		Case enrollmentCase, reimbursementCase;
		Map<Id, Case> existingEnrollmentCaseByPAId = new Map<Id, Case>();
		Map<Id, Case> existingReimbursementCaseByClaimId = new Map<Id, Case>();
		//Map<String, Case> existingEnrollmentCaseByHCPS = new Map<String, Case>();
		Map<String, Case> existingEnrollmentCaseByContactDrugId = new Map<String, Case>();
		Map<Id, Id> accountIdByContactId = new Map<Id, Id>();
		Map<Id, Contact> contactByContactId = new Map<Id, Contact>();
		//Map<String, Claim_Information__c> claimBeforeTxByHCPS = new Map<String, Claim_Information__c>(); //Map of Claim by HCPS code before committed to DB
		//Map<String, Claim_Information__c> claimAfterTxByHCPS = new Map<String, Claim_Information__c>(); //Map of Claim by HCPS code after committed to DB
		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');
		Schema.RecordTypeInfo reimbursementCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');
		String sha1Hash_Id;
		Set<String> J_Code_IdSet = new Set<String>();
		Set<String> NDCSet = new Set<String>{''};
		Map<String, Drug__C> drugByHCPCS = new Map<String, Drug__c>();
		Set<String> priorAuthorizationIdSet = new Set<String>();
		Set<String> contactSHA1HashIdSet = new Set<String>();
		Set<Id> existingContactIdSet = new Set<Id>();
		Contact_Drug__c contact_DrugRecord;
		Map<String, Contact_Drug__c> contact_DrugByHCPCS_Code = new Map<String, Contact_Drug__c>();
		Map<Id, Contact_Drug__c> contact_DrugByContactId = new Map<Id, Contact_Drug__c>();
		Map<Id, Contact_Drug__c> contact_DrugById = new Map<Id, Contact_Drug__c>();
		List<Contact> existingSha1Hash_IdMatchedContactsList;
		List<Prior_Auth__c> existingSha1Hash_IdMatchedPriorAuthsList;
		String claim_NumberSee, HCPCSCodeTrunc;
		Map<String, Prior_Auth__c> exsistingPriorAuthBySHA1HashId = new Map<String, Prior_Auth__c>();

		System.debug('priorAuthList Count = ' + priorAuthList.size());

		//Get HCPCS_Code__c & Prior_Authorization__c of loaded Prior Auth to match any existing PAs
		for(Prior_Auth__c priorAuthRecord : priorAuthList){
			//HCPCS_CodeIdSet.add(priorAuthRecord.HCPCS_Code__c);
			HCPCSCodeTrunc = priorAuthRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			J_Code_IdSet.add(HCPCSCodeTrunc);
			priorAuthorizationIdSet.add(priorAuthRecord.Prior_Authorization__c);
			//priorAuthIdByCSANumber.put(priorAuthRecord.CSA_Number__c, priorAuthRecord.Id);
			csaNumberByPriorAuthId.put(priorAuthRecord.Id, priorAuthRecord.CSA_Number__c);
			//get all Prior Auth Contacts matching Sha1Had_Ids
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					priorAuthRecord.Patient_CUMB_ID__c + '-'
							+ priorAuthRecord.Patient_Birth_Date__c + '-'
							+ priorAuthRecord.Patient_First_Name__c + '-'
							+ priorAuthRecord.Patient_Last_Name__c
			);
			contactSHA1HashIdSet.add(sha1Hash_Id);
			//exsistingPriorAuthBySHA1HashId.put(sha1Hash_Id, priorAuthRecord);
		}
		System.debug('J_Code_IdSet = ' + J_Code_IdSet);
/*
		DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
		List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(J_Code_IdSet);
		for(Drug__c drugRecord : drugList) {
			drugByHCPCS.put(drugRecord.J_Code__c, drugRecord);
			System.debug('drugRecord.J_Code__c = ' + drugRecord.J_Code__c);
		}

		//If drug Coding Level is HCPCS than we only use the HCPCS to identify the drug
		//If drug Coding Level is HCPCS + NDC we Need include the NDC as part of the key to identify the Drug
		for(Prior_Auth__c priorAuth : priorAuthList) {
			Drug__c drugRecord = drugByHCPCS.get(priorAuth.HCPCS_Code__c);
			if(drugRecord.Coding_Level__c == 'HCPCS + NDC') {
				NDCSet.add(priorAuth.NDC__c);
				System.debug('priorAuth.NDC__c = ' + priorAuth.NDC__c);
			}
		}
		System.debug('J_Code_IdSet = ' + J_Code_IdSet);
		System.debug('NDCSet = ' + NDCSet);
		System.debug('existingContactIdSet = ' + existingContactIdSet);
*/
		List<Contact> contactList = new List<Contact>();
		IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
		Map<Id, Contact> existingContactsByPriorAuthId = contactsDomain.getExistingContactsByPriorAuthId(priorAuthList);
		System.debug('existingContactsByPriorAuthId Count: ' + existingContactsByPriorAuthId.size());

		for(Contact contactRecord : existingContactsByPriorAuthId.values()) {
			existingContactIdSet.add(contactRecord.Id);
			accountIdByContactId.put(contactRecord.Id, contactRecord.AccountId);
			contactByContactId.put(contactRecord.Id, contactRecord);
		}

		System.debug('existingContactIdSet = ' + existingContactIdSet);
		Prior_AuthSelector priorAuthSelector = (Prior_AuthSelector) PMd_Application.Selector.newInstance(Prior_Auth__c.SObjectType);
		existingSha1Hash_IdMatchedPriorAuthsList = priorAuthSelector.selectBySHA1Hash_ID(contactSHA1HashIdSet);
		System.debug('existingSha1Hash_IdMatchedContactsList Count: ' + existingSha1Hash_IdMatchedPriorAuthsList.size());

		for(Prior_Auth__c priorAuthRecord : existingSha1Hash_IdMatchedPriorAuthsList) {
			exsistingPriorAuthBySHA1HashId.put(priorAuthRecord.sha1Hash_Id__c, priorAuthRecord);
		}

		for(Contact_Drug__c existingContact_Drug : existingContact_DrugsList) {
			contact_DrugByClaim_InformationId.put(existingContact_Drug.Claim_Information__c, existingContact_Drug);
			//contact_DrugByHCPCS_Code.put(existingContact_Drug.HCPCS_Code__c + existingContact_Drug.Prior_Auth__c,existingContact_Drug);
			contact_DrugById.put(existingContact_Drug.Id, existingContact_Drug);
			contact_DrugByContactId.put(existingContact_Drug.Contact__c,existingContact_Drug);
		}

		System.debug('In Cases:process - existingContact_DrugList Count = ' + existingContact_DrugsList.size());

		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		//csaByPriorAuthId = cSAsDomain.getCSAsById(priorAuthIdByCSANumber);
		csasByCSA_Number = cSAsDomain.getCSAsByCSANumber(csaNumberByPriorAuthId);

		//Get matching Cases from Prior Auth
		CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
		//List<Case> existingEnrollmentCases = casesSelector.selectEnrollmentCaseByHCPC_CodeIdPAId(HCPCS_CodeIdSet, priorAuthorizationIdSet);
		//TODO: Should only have 1 Enrollment Case per ContactDrug so need to select existing Enrollment Case By ContactDrug.
		//List<Case> existingEnrollmentCases = casesSelector.selectEnrollmentCaseByContactId(existingContactIdSet);
		List<Case> existingEnrollmentCases = casesSelector.selectEnrollmentCaseByContactDrug(contact_DrugById.keySet());
		System.debug('existingEnrollmentCases.size() = ' + existingEnrollmentCases.size());

		for(Case existingEnrollmentCase : existingEnrollmentCases) {
			//if(existingEnrollmentCase.Claim_Information__c != null) {
			//	existingEnrollmentCaseByPAId.put(existingEnrollmentCase.Prior_Authorization__c, existingEnrollmentCase);
			//}
			//existingEnrollmentCaseByHCPS.put(existingEnrollmentCase.HCPCS_Code__c, existingEnrollmentCase); //Needs to be the most recent Case by PA_Approval_Date
			existingEnrollmentCaseByContactDrugId.put(existingEnrollmentCase.Contact_Drug__c, existingEnrollmentCase); //Needs to be the most recent Case by PA_Approval_Date
			System.debug('existingEnrollmentCase = ' + existingEnrollmentCase);
		}

		for(Prior_Auth__c priorAuth : priorAuthList) {
			Contact contactRecord, existingPAContact;
			Prior_Auth__c existingPriorAuth;

			//contact_DrugRecord = contact_DrugByHCPCS_Code.get(priorAuth.HCPCS_Code__c); //Issue if more that 1 PA with the same HCPCS_Code
			contactRecord =  existingContactsByPriorAuthId.get(priorAuth.Id);
			System.debug('contactRecord = ' + contactRecord);
			if(contactRecord !=  null) {
				contact_DrugRecord = contact_DrugByContactId.get(contactRecord.Id);
			}
			/*
			if(contact_DrugRecord != null) {
				contactRecord = contactByContactId.get(contact_DrugRecord.Contact__c);
				//contact_DrugRecord.Prior_Auth__c = priorAuth.Id;
			}
			*/
			System.debug('contact_DrugRecord = ' + contact_DrugRecord);
			System.debug('contactRecord = ' + contactRecord);
			System.debug('contactRecord.AccountId = ' + contactRecord.AccountId);

			//CSA__c csaRecord = csaByPriorAuthId.get(priorAuth.Id);
			CSA__c csaRecord = csasByCSA_Number.get(priorAuth.CSA_Number__c);
			Date goLiveDate = csaRecord.Implementation__r.Contract__r.Go_Live_Date__c;

			//Look for existing PA record linked to Contact profile.
			//get existing Prior Auth matching Sha1Had_Ids of this loaded Prior Auth
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					priorAuth.Patient_CUMB_ID__c + '-'
							+ priorAuth.Patient_Birth_Date__c + '-'
							+ priorAuth.Patient_First_Name__c + '-'
							+ priorAuth.Patient_Last_Name__c
			);
			//existingPriorAuth = exsistingPriorAuthBySHA1HashId.get(sha1Hash_Id);
			existingPAContact = existingContactsByPriorAuthId.get(priorAuth.Id);
			System.debug('existingPAContact = ' + existingPAContact);
			//Case existingEnrollmentCase = existingEnrollmentCaseByHCPS.get(contact_DrugRecord.HCPCS_Code__c);
			Case existingEnrollmentCase =existingEnrollmentCaseByContactDrugId.get(contact_DrugRecord.Id);

			/*
			If PA does not exist based on logic above:
				Then create a new PA record and create new Enrollment Case.
			If PA does exist based on logic above:
				No new Enrollment Case will be created.
						Then update existing PA record with new data.
						The old PAs will be shown on the PA related list section in the bottom section of the Enrollment Case.
			*/
			System.debug('existingPAContact.CreatedDate = ' +  existingPAContact.CreatedDate);
			System.debug('System.today() = ' +  System.today());
			System.debug('existingEnrollmentCase = ' + existingEnrollmentCase);
			if(existingEnrollmentCase == null) {
				//Then create a new PA record and create new Enrollment Case.
				//Prior_Auth__c newPriorAuth = new Prior_Auth__c();
				//newPriorAuth = mapLoadedPriorAuthToPriorAuth(priorAuth, newPriorAuth);
				//newPriorAuthList.add(newPriorAuth);
				System.debug('Create Enrollment Case');
				enrollmentCase = new Case();
				//enrollmentCase.Follow_up_Time__c = DateTime.now();
				//enrollmentCase.Type = 'Enrollment';
				enrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
				//TODO: Get contact_DrugRecord
				if(contact_DrugRecord != null) {
					enrollmentCase.Contact_Drug__c = contact_DrugRecord.Id;
					enrollmentCase.ContactId = contact_DrugRecord.Contact__c;
					enrollmentCase.AccountId = csaRecord.Account__c;
				}

				enrollmentCase = mapPriorAuthToCase(priorAuth, enrollmentCase);
				enrollmentCase.Prior_Auth__c = priorAuth.Id;
				//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
				//enrollmentCase.Service_Provider_Fax__c = getServiceProviderFax(contactRecord);

				newEnrollmentCaseList.add(enrollmentCase);
			} else { //If PA does exist based on logic above:
				System.debug('Update Enrollment Case');
				//No new Enrollment Case will be created.
				//Then update existing PA record with new data.
				existingPriorAuth = exsistingPriorAuthBySHA1HashId.get(existingPAContact.SHA1Hash_ID__c);
				System.debug('existingPriorAuth = ' + existingPriorAuth);

				//Reopen an Enrollment Case when the following is TRUE:
				//A claim has been received for a Contact that has a previous Enrollment Case (trigger) in which
				//Case “Status is “Outreach Completed”
				//The Contact Drug “CPA Enrollment Status” is "Not on File
				if(existingEnrollmentCase.Status == 'Outreach Completed'
						&& contact_DrugRecord.Copay_Enrollment_Status__c == 'Not on File'
						&& contact_DrugRecord.Member_Ineligible_for_CPA__c == FALSE){
					//Reopen an Enrollment Case
					existingEnrollmentCase.Status = 'Verify Fax Number';
					existingEnrollmentCase.HCP_Enrollment_Outreach__c = 'Outreach Needed';
				}

				//Update existingEnrollmentCase PA_Approval_Date to more recent PA_Approval_Date
				if(existingEnrollmentCase.Most_Recent_Service_From_Date__c <= priorAuth.Service_Start_Date__c) {
					existingEnrollmentCase = mapPriorAuthToCase(priorAuth, existingEnrollmentCase);
					existingEnrollmentCaseList.add(existingEnrollmentCase);
				}

				if(priorAuth != null && existingPriorAuth != null) {
					existingPriorAuth = mapLoadedPriorAuthToPriorAuth(priorAuth, existingPriorAuth);
					existingPriorAuthList.add(existingPriorAuth);
				}
				//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
				//existingEnrollmentCase.Service_Provider_Fax__c = getServiceProviderFax(contactRecord);

				//The old PAs will be shown on the PA related list section in the bottom section of the Enrollment Case.
				existingEnrollmentCase.Prior_Auth__c = priorAuth.Id;
				existingEnrollmentCaseList.add(existingEnrollmentCase);
				contact_DrugRecord.Prior_Auth__c = priorAuth.Id;
			}
			existingContact_DrugList.add(contact_DrugRecord);
			/*
			Acceptance Criteria
			If unique claim key exists then update claim else create a new claim.
			*/

		}

		uow.registerDirty(existingContact_DrugList);
		uow.registerDirty(existingPriorAuthList);
		uow.registerDirty(existingEnrollmentCaseList);

		//uow.registerNew(newPriorAuthList);
		uow.registerNew(newEnrollmentCaseList);


		System.debug('In Cases:process - Stop processing Cases for Prior_Auth');
	}

	/*
Summary

The next step in Daily claims is to create or update claims.

Requirements
PA processing logic:
    Look for existing PA record linked to Contact profile.
    If PA does not exist based on logic above:
        Then create a new PA record and create new Enrollment Case.
    If PA does exist based on logic above:
        No new Enrollment Case will be created.
        Then update existing PA record with new data.
        The old PAs will be shown on the PA related list section in the bottom section of the Enrollment Case.

    Acceptance Criteria
        If PA exists then update enrollment case else create enrollment case.
 */
	public void process(List<Historical_Prior_Auth__c> historicalPriorAuthList,
			List<Contact_Drug__c> existingContact_DrugsList,
			fflib_ISObjectUnitOfWork uow)
	{
		System.debug('In Cases:process - Start processing Cases for Historical_Prior_Auth');

		// Create Cases & from the given Historical Prior Auth
		List<SObject> newHistoricalPriorAuthList = new List<SObject>();
		List<SObject> existingHistoricalPriorAuthList = new List<SObject>();
		List<SObject> existingContact_DrugList = new List<SObject>();
		List<SObject> newEnrollmentCaseList = new List<SObject>();
		List<SObject> existingEnrollmentCaseList = new List<SObject>();
		List<SObject> newReimbursementCaseList = new List<SObject>();
		List<SObject> existingReimbursementCaseList = new List<SObject>();

		List<Case> existingECaseList = new List<Case>();
		List<Case> existingRCaseList = new List<Case>();
		Set<String> primary_Claim_NumberSet = new Set<String>();
		Set<String> claim_SegmentSet = new Set<String>();
		Set<String> claim_LineSet = new Set<String>();
		Set<String> previous_SegmentSet = new Set<String>();
		List<Claim_Information__c> originalClaim_InformationBeforeTxList; //Original Claim List before transaction is committed to DB
		List<Claim_Information__c> existingClaim_InformationBeforeTxList;//Existing Claim List before transaction is committed to DB
		List<Claim_Information__c> allClaim_InformationBeforeTxList = new List<Claim_Information__c>(); //All Claim List before transaction is committed to DB
		List<Claim_Information__c> originalClaim_InformationAfterTxList; //Original Claim List After transaction is committed to DB
		List<Claim_Information__c> existingClaim_InformationAfterTxList;//Existing Claim List After transaction is committed to DB
		List<Claim_Information__c> allClaim_InformationAfterTxList = new List<Claim_Information__c>(); //All Claim List After transaction is committed to DB
		List<Claim_Information__c> updatedClaim_InformationList = new List<Claim_Information__c>();
		//Map<String, Id> historicalPriorAuthIdByCSANumber = new Map<String, Id>();
		Map<Id, String> csaNumberByHistoricaPriorAuthId = new Map<Id, String>();
		//Map<Id, CSA__c> csaByHistoricalPriorAuthId = new Map<Id, CSA__c>();
		Map<String, CSA__c> csasByCSA_Number = new Map<String, CSA__c>();
		Map<Id, Claim_Information__c> claimByContact_DrugId = new Map<Id, Claim_Information__c>();
		Map<Id, Claim_Information__c> claimById = new Map<Id, Claim_Information__c>();
		Map<Id, String> claim_NumberByDailyId = new Map<Id, String>();
		Map<String, Claim_Information__c> claimBeforeTransactionByClaim_Number = new Map<String, Claim_Information__c>();
		Map<String, Claim_Information__c> claimAfterTransactionByClaim_Number = new Map<String, Claim_Information__c>();
		Map<Id, Contact_Drug__c> contact_DrugByClaim_InformationId = new Map<Id, Contact_Drug__c>();
		Case enrollmentCase, reimbursementCase;
		Map<Id, Case> existingEnrollmentCaseByHPAId = new Map<Id, Case>();
		Map<Id, Case> existingReimbursementCaseByClaimId = new Map<Id, Case>();
		//Map<String, Case> existingEnrollmentCaseByHCPS = new Map<String, Case>();
		Map<String, Case> existingEnrollmentCaseByContactDrugId = new Map<String, Case>();
		Map<Id, Contact_Drug__c> contact_DrugById = new Map<Id, Contact_Drug__c>();
		Map<Id, Id> accountIdByContactId = new Map<Id, Id>();
		Map<Id, Contact> contactByContactId = new Map<Id, Contact>();
		//Map<String, Claim_Information__c> claimBeforeTxByHCPS = new Map<String, Claim_Information__c>(); //Map of Claim by HCPS code before committed to DB
		//Map<String, Claim_Information__c> claimAfterTxByHCPS = new Map<String, Claim_Information__c>(); //Map of Claim by HCPS code after committed to DB
		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');
		Schema.RecordTypeInfo reimbursementCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');
		String sha1Hash_Id;
		Set<String> HCPCS_CodeIdSet = new Set<String>();
		Set<String> historicalPriorAuthorizationIdSet = new Set<String>();
		Set<String> contactSHA1HashIdSet = new Set<String>();
		Set<Id> existingContactIdSet = new Set<Id>();
		Contact_Drug__c contact_DrugRecord;
		Map<String, Contact_Drug__c> contact_DrugByHCPCS_Code = new Map<String, Contact_Drug__c>();
		Map<Id, Contact_Drug__c> contact_DrugByHPAId = new Map<Id, Contact_Drug__c>();
		List<Contact> existingSha1Hash_IdMatchedContactsList;
		List<Historical_Prior_Auth__c> existingSha1Hash_IdMatchedHistoricalPriorAuthsList;
		String claim_NumberSeed, HCPCSCodeTrunc;
		Map<String, Historical_Prior_Auth__c> exsistingHistoricalPriorAuthBySHA1HashId = new Map<String, Historical_Prior_Auth__c>();

		System.debug('historicalPriorAuthList Count = ' + historicalPriorAuthList.size());

		//Get HCPCS_Code__c & Prior_Authorization__c of loaded Prior Auth to match any existing PAs
		for(Historical_Prior_Auth__c historicalPriorAuthRecord : historicalPriorAuthList){
			HCPCSCodeTrunc = historicalPriorAuthRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			HCPCS_CodeIdSet.add(HCPCSCodeTrunc);
			historicalPriorAuthorizationIdSet.add(historicalPriorAuthRecord.Prior_Authorization__c);
			//historicalPriorAuthIdByCSANumber.put(historicalPriorAuthRecord.CSA_Number__c, historicalPriorAuthRecord.Id);
			csaNumberByHistoricaPriorAuthId.put(historicalPriorAuthRecord.Id, historicalPriorAuthRecord.CSA_Number__c);
			//get all Prior Auth Contacts matching Sha1Had_Ids
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					historicalPriorAuthRecord.Patient_CUMB_ID__c + '-'
							+ historicalPriorAuthRecord.Patient_Birth_Date__c + '-'
							+ historicalPriorAuthRecord.Patient_First_Name__c + '-'
							+ historicalPriorAuthRecord.Patient_Last_Name__c
			);
			contactSHA1HashIdSet.add(sha1Hash_Id);
			//exsistingPriorAuthBySHA1HashId.put(sha1Hash_Id, priorAuthRecord);
		}

		List<Contact> contactList = new List<Contact>();
		IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
		Map<Id, Contact> existingContactsByHistoricalPriorAuthId = contactsDomain.getExistingContactsByHistoricalPriorAuthId(historicalPriorAuthList);
		System.debug('existingContactsByHistoricalPriorAuthId Count: ' + existingContactsByHistoricalPriorAuthId.size());

		for(Contact contactRecord : existingContactsByHistoricalPriorAuthId.values()) {
			existingContactIdSet.add(contactRecord.Id);
			accountIdByContactId.put(contactRecord.Id, contactRecord.AccountId);
			contactByContactId.put(contactRecord.Id, contactRecord);
		}

		System.debug('existingContactIdSet = ' + existingContactIdSet);
		Historical_Prior_AuthSelector historicalPriorAuthSelector = (Historical_Prior_AuthSelector) PMd_Application.Selector.newInstance(Historical_Prior_Auth__c.SObjectType);
		existingSha1Hash_IdMatchedHistoricalPriorAuthsList = historicalPriorAuthSelector.selectBySHA1Hash_ID(contactSHA1HashIdSet);
		System.debug('existingSha1Hash_IdMatchedContactsList Count: ' + existingSha1Hash_IdMatchedHistoricalPriorAuthsList.size());

		for(Historical_Prior_Auth__c historicalPriorAuthRecord : existingSha1Hash_IdMatchedHistoricalPriorAuthsList) {
			exsistingHistoricalPriorAuthBySHA1HashId.put(historicalPriorAuthRecord.sha1Hash_Id__c, historicalPriorAuthRecord);
		}

		for(Contact_Drug__c existingContact_Drug : existingContact_DrugsList) {
			contact_DrugByClaim_InformationId.put(existingContact_Drug.Claim_Information__c, existingContact_Drug);
			//contact_DrugByHCPCS_Code.put(existingContact_Drug.HCPCS_Code__c, existingContact_Drug);
			contact_DrugById.put(existingContact_Drug.Id, existingContact_Drug);
			contact_DrugByHPAId.put(existingContact_Drug.Historical_Prior_Auth__c, existingContact_Drug);
		}

		System.debug('existingContact_DrugList Count = ' + existingContact_DrugsList.size());

		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		//csaByHistoricalPriorAuthId = cSAsDomain.getCSAsById(historicalPriorAuthIdByCSANumber);
		csasByCSA_Number = cSAsDomain.getCSAsByCSANumber(csaNumberByHistoricaPriorAuthId);

		//Get matching Cases from Prior Auth
		CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
		//List<Case> existingEnrollmentCases = casesSelector.selectEnrollmentCaseByHCPC_CodeIdPAId(HCPCS_CodeIdSet, historicalPriorAuthorizationIdSet);
		//List<Case> existingEnrollmentCases = casesSelector.selectEnrollmentCaseByContactId(existingContactIdSet);
		List<Case> existingEnrollmentCases = casesSelector.selectEnrollmentCaseByContactDrug(contact_DrugById.keySet());
		System.debug('existingEnrollmentCases.size() = ' + existingEnrollmentCases.size());

		for(Case existingEnrollmentCase : existingEnrollmentCases) {
			//for(Case existingEnrollmentCaseSorted : existingEnrollmentCases) {
			//if (existingEnrollmentCase.Claim_Information__c != null && existingEnrollmentCaseSorted.PA_Approval_Dates__c > existingEnrollmentCase.PA_Approval_Dates__c) {
			//If Contact has mulitple Contact_Drugs check if the Enrollment Case is already related to the Contact_Drug. If not will need to create a new Enrollment Case for that Contact_Drug
			//if (contact_DrugByHCPCS_Code.get(existingEnrollmentCase.HCPCS_Code__c) != null) {
			//existingEnrollmentCaseByHCPS.put(existingEnrollmentCase.HCPCS_Code__c, existingEnrollmentCase); //Needs to be the most recent Case by PA_Approval_Date
			existingEnrollmentCaseByContactDrugId.put(existingEnrollmentCase.Contact_Drug__c, existingEnrollmentCase); //Needs to be the most recent Case by PA_Approval_Date
			System.debug('existingEnrollmentCase = ' + existingEnrollmentCase);
			//}
			//}
		}

		for(Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthList) {
			Contact contactRecord, existingHPAContact;
			Historical_Prior_Auth__c existingHistoricalPriorAuth;

			//contact_DrugRecord = contact_DrugByHCPCS_Code.get(historicalPriorAuth.HCPCS_Code__c); //Issue if more that 1 HPA with the same HCPCS_Code
			contact_DrugRecord = contact_DrugByHPAId.get(historicalPriorAuth.Id);
			if(contact_DrugRecord != null) {
				contactRecord = contactByContactId.get(contact_DrugRecord.Contact__c);
				//contact_DrugRecord.Historical_Prior_Auth__c = historicalPriorAuth.Id;
			}
			System.debug('contact_DrugRecord = ' + contact_DrugRecord);
			System.debug('contactRecord = ' + contactRecord);
			System.debug('contactRecord.AccountId = ' + contactRecord.AccountId);

			//CSA__c csaRecord = csaByHistoricalPriorAuthId.get(historicalPriorAuth.Id);
			CSA__c csaRecord = csasByCSA_Number.get(historicalPriorAuth.CSA_Number__c);
			Date goLiveDate = csaRecord.Go_Live_Date__c;

			//Look for existing PA record linked to Contact profile.
			//get existing Prior Auth matching Sha1Had_Ids of this loaded Prior Auth
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					historicalPriorAuth.Patient_CUMB_ID__c + '-'
							+ historicalPriorAuth.Patient_Birth_Date__c + '-'
							+ historicalPriorAuth.Patient_First_Name__c + '-'
							+ historicalPriorAuth.Patient_Last_Name__c
			);
			existingHPAContact = existingContactsByHistoricalPriorAuthId.get(historicalPriorAuth.Id);
			System.debug('existingHPAContact = ' + existingHPAContact);
			//Case existingEnrollmentCase =  existingEnrollmentCaseByHCPS.get(contact_DrugRecord.HCPCS_Code__c);
			Case existingEnrollmentCase =existingEnrollmentCaseByContactDrugId.get(contact_DrugRecord.Id);
			/*
			If PA does not exist based on logic above:
				Then create a new PA record and create new Enrollment Case.
			If PA does exist based on logic above:
				No new Enrollment Case will be created.
						Then update existing PA record with new data.
						The old PAs will be shown on the PA related list section in the bottom section of the Enrollment Case.
			*/
			System.debug('existingHPAContact.CreatedDate = ' +  existingHPAContact.CreatedDate);
			System.debug('System.today() = ' +  System.today());
			System.debug('existingEnrollmentCase = ' + existingEnrollmentCase);
			//if(existingEnrollmentCase == null || System.today() < existingHPAContact.CreatedDate ) {
			if(existingEnrollmentCase == null) {
				//if(contact_DrugRecord == null) {
				//Then create a new PA record and create new Enrollment Case.
				//Historical_Prior_Auth__c newHistoricalPriorAuth = new Historical_Prior_Auth__c();
				//newHistoricalPriorAuth = mapLoadedHistoricalPriorAuthToHistoricalPriorAuth(historicalPriorAuth, newHistoricalPriorAuth);
				//newHistoricalPriorAuthList.add(newHistoricalPriorAuth);
				System.debug('Create Enrollment Case');
				enrollmentCase = new Case();
				//enrollmentCase.Follow_up_Time__c = DateTime.now();
				//enrollmentCase.Type = 'Enrollment';
				enrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
				//TODO: Get contact_DrugRecord
				if(contact_DrugRecord != null) {
					enrollmentCase.Contact_Drug__c = contact_DrugRecord.Id;
					enrollmentCase.ContactId = contact_DrugRecord.Contact__c;
					enrollmentCase.AccountId = csaRecord.Account__c;
				}

				enrollmentCase = mapHistoricalPriorAuthToCase(historicalPriorAuth, enrollmentCase);
				enrollmentCase.Historical_Prior_Auth__c = historicalPriorAuth.Id;
				//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
				//enrollmentCase.Service_Provider_Fax__c = getServiceProviderFax(contactRecord);

				newEnrollmentCaseList.add(enrollmentCase);
			} else { //If HPA does exist based on logic above:
				System.debug('Update Enrollment Case');
				//No new Enrollment Case will be created.
				//Then update existing PA record with new data.
				existingHistoricalPriorAuth = exsistingHistoricalPriorAuthBySHA1HashId.get(existingHPAContact.SHA1Hash_ID__c);
				System.debug('existingHistoricalPriorAuth = ' + existingHistoricalPriorAuth);
				//Update existingEnrollmentCase AP_Approval_Date to more recent AP_Approval_Date
				if(existingEnrollmentCase.Most_Recent_Service_From_Date__c <= historicalPriorAuth.Service_Start_Date__c) {
					//existingEnrollmentCase.PA_Approval_Dates__c = historicalPriorAuth.PA_Approval_Dates__c;
					existingEnrollmentCase = mapHistoricalPriorAuthToCase(historicalPriorAuth, existingEnrollmentCase);
					existingEnrollmentCaseList.add(existingEnrollmentCase);
				}

				//Reopen an Enrollment Case when the following is TRUE:
				//A claim has been received for a Contact that has a previous Enrollment Case (trigger) in which
				//Case “Status is “Outreach Completed”
				//The Contact Drug “CPA Enrollment Status” is "Not on File
				if(existingEnrollmentCase.Status == 'Outreach Completed'
						&& contact_DrugRecord.Copay_Enrollment_Status__c == 'Not on File'
						&& contact_DrugRecord.Member_Ineligible_for_CPA__c == FALSE){
					//Reopen an Enrollment Case
					existingEnrollmentCase.Status = 'Verify Fax Number';
					existingEnrollmentCase.HCP_Enrollment_Outreach__c = 'Outreach Needed';
				}
				//TODO: The HPA can't be updated in an AfterInsert trigger
				if(historicalPriorAuth != null && existingHistoricalPriorAuth != null) {
					existingHistoricalPriorAuth = mapLoadedHistoricalPriorAuthToHistoricalPriorAuth(historicalPriorAuth, existingHistoricalPriorAuth);
					existingHistoricalPriorAuthList.add(existingHistoricalPriorAuth);
				}
				//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
				//existingEnrollmentCase.Service_Provider_Fax__c = getServiceProviderFax(contactRecord);

				//The old PAs will be shown on the PA related list section in the bottom section of the Enrollment Case.
				existingEnrollmentCase.Historical_Prior_Auth__c = historicalPriorAuth.Id;
				existingEnrollmentCaseList.add(existingEnrollmentCase);
				contact_DrugRecord.Historical_Prior_Auth__c = historicalPriorAuth.Id;
			}
			existingContact_DrugList.add(contact_DrugRecord);
			/*
			Acceptance Criteria
			If unique claim key exists then update claim else create a new claim.
			*/

		}

		uow.registerDirty(existingContact_DrugList);
		uow.registerDirty(existingHistoricalPriorAuthList);
		uow.registerDirty(existingEnrollmentCaseList);

		//uow.registerNew(newHistoricalPriorAuthList);
		uow.registerNew(newEnrollmentCaseList);

		System.debug('In Cases:process - Stop processing Cases for Historical_Prior_Auth');
	}

	private Case createEnrollmentCaseFrom(Daily_Claim__c dailyClaim,
			Schema.RecordTypeInfo enrollmentCaseInfo,
			Claim_Information__c claimRecordAfterTransaction,
			Contact contactRecord,
			Contact_Drug__c contact_DrugRecord,
			CSA__c csaRecord,
			Date goLiveDate
	) {

		System.debug('Create Enrollment Case');
		Case enrollmentCase = new Case();
		//Relate claims to other objects in the AfterInsert Case Trigger
		if (claimRecordAfterTransaction != null) {
			enrollmentCase.Claim_Information__c = claimRecordAfterTransaction.Id;
			enrollmentCase.EOP_Date__c = claimRecordAfterTransaction.EOP_Date__c;
			System.debug('enrollmentCase.EOP_Date__c = ' + enrollmentCase.EOP_Date__c);
			//System.debug('enrollmentCase.Claim_Information__r.EOP_Date__c = ' + enrollmentCase.Claim_Information__r.EOP_Date__c);
			//enrollmentCase.Drug_Cost__c = claimRecordAfterTransaction.Total_Drug_Cost__c;
			claimRecordAfterTransaction.Contact__c = contactRecord.Id;
			claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
			contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
		}
		System.debug('claimRecordAfterTransaction.Contact_Drug__c = ' + contact_DrugRecord.Id);
		//enrollmentCase.Type = 'Enrollment';
		enrollmentCase.RecordTypeId = enrollmentCaseInfo.getRecordTypeId();
		//Get contact_DrugRecord
		if (contact_DrugRecord != null) {
			enrollmentCase.Contact_Drug__c = contact_DrugRecord.Id;
			enrollmentCase.ContactId = contact_DrugRecord.Contact__c;
			enrollmentCase.AccountId = csaRecord.Account__c;
			claimRecordAfterTransaction.Contact_Drug__c = contact_DrugRecord.Id;
			contact_DrugRecord.Claim_Information__c = claimRecordAfterTransaction.Id;
			System.debug('claimRecordAfterTransaction.Contact_Drug__c = '+ contact_DrugRecord.Id);
		}
		enrollmentCase.Daily_Claim__c = dailyClaim.Id;
		if(goLiveDate == null) {
			enrollmentCase.Daily_Claim_Status__c = 'Go-live Date Null';
		}

		System.debug('claimRecordAfterTransaction.Contact_Drug__c = ' + contact_DrugRecord.Id);
		System.debug('enrollmentCase = ' + enrollmentCase);

		//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
		//enrollmentCase.Service_Provider_Fax__c = getServiceProviderFax(contactRecord);

		return enrollmentCase;
	}
/*
	//Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
	public String getServiceProviderFax(Contact contactRecord) {
		String serivceProviderFax;

		System.debug('getServiceProviderFax: contactRecord.Patient_Phone_Number__c = ' + contactRecord.Patient_Phone_Number__c);
		System.debug('getServiceProviderFax: contactRecord.Alternative_Phone__c = ' + contactRecord.Alternative_Phone__c);
		//If the Patient Phone on the Contact Page is blank and the Alternative Phone is populated, map the Alternative Phone onto the outbound faxes.
		if(String.isBlank(contactRecord.Patient_Phone_Number__c)
				&& !String.isBlank(contactRecord.Alternative_Phone__c)
		) {
			serivceProviderFax = contactRecord.Alternative_Phone__c;
		//If the Alternative Phone on the Contact Page is blank and the Patient Phone is populated, map the Patient Phone onto the outbound faxes.
		} else if(!String.isBlank(contactRecord.Patient_Phone_Number__c)
				&& String.isBlank(contactRecord.Alternative_Phone__c)
				) {
			serivceProviderFax = contactRecord.Patient_Phone_Number__c;
		//If both the Patient Phone on the Contact Page and the Alternative Phone are populated, map the Alternative Phone onto the outbound faxes.
		} else if(!String.isBlank(contactRecord.Patient_Phone_Number__c)
				&& !String.isBlank(contactRecord.Alternative_Phone__c)
				) {
			serivceProviderFax = contactRecord.Alternative_Phone__c;
		}
		System.debug('getServiceProviderFax: serivceProviderFax = ' + serivceProviderFax);
		return serivceProviderFax;
	}
*/
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

	private void mapCasesToContact_Drugs(Map<Id, Case> contact_DrugIdByCase, fflib_ISObjectUnitOfWork uow) {

		List<SObject> existingContact_DrugList = new List<SObject>();

		Contact_DrugsSelector contact_DrugsSelector = (Contact_DrugsSelector)PMd_Application.Selector.newInstance(Contact_Drug__c.SObjectType);
		List<Contact_Drug__c> existingContact_DrugsList = contact_DrugsSelector.selectByContact_DrugId(contact_DrugIdByCase.keySet());

		for(Contact_Drug__c existingContact_Drug : existingContact_DrugsList) {
			Case caseRecord = contact_DrugIdByCase.get(existingContact_Drug.Id);
			existingContact_Drug.Related_Case__c = caseRecord.Id;
			existingContact_Drug.Claim_Information__c = caseRecord.Claim_Information__c;
			existingContact_DrugList.add(existingContact_Drug);
			System.debug('existingContact_Drug = ' + existingContact_Drug);
		}

		uow.registerDirty(existingContact_DrugList);

		System.debug('existingContact_DrugList Count = ' + existingContact_DrugsList.size());

	}

	private void mapCasesToHistoricalPA(Map<Id, Case> caseByHistoricalPAId, fflib_ISObjectUnitOfWork uow) {

		List<SObject> existingHistoricalPAList = new List<SObject>();

		Historical_Prior_AuthSelector historicalPriorAuthSelector = (Historical_Prior_AuthSelector) PMd_Application.Selector.newInstance(Historical_Prior_Auth__c.SObjectType);
		List<Historical_Prior_Auth__c> relatedHistoricalPriorAuthsList = historicalPriorAuthSelector.selectById(caseByHistoricalPAId.keySet());
		System.debug('relatedHistoricalPriorAuthsList Count: ' + relatedHistoricalPriorAuthsList.size());

		for(Historical_Prior_Auth__c historicalPA :relatedHistoricalPriorAuthsList) {
			Case caseRecord = caseByHistoricalPAId.get(historicalPA.Id);
			historicalPA.Case__c = caseRecord.Id;
			historicalPA.Contact_Drug__c = caseRecord.Contact_Drug__c;
			existingHistoricalPAList.add(historicalPA);
		}

		uow.registerDirty(existingHistoricalPAList);

		System.debug('existingHistoricalPAList Count = ' + existingHistoricalPAList.size());

	}

	private void mapCasesToPA(Map<Id, Case> caseByPAId, fflib_ISObjectUnitOfWork uow) {

		List<SObject> existingPAList = new List<SObject>();

		Prior_AuthSelector priorAuthSelector = (Prior_AuthSelector) PMd_Application.Selector.newInstance(Prior_Auth__c.SObjectType);
		List<Prior_Auth__c> relatedPriorAuthsList = priorAuthSelector.selectById(caseByPAId.keySet());
		System.debug('relatedPriorAuthsList Count: ' + relatedPriorAuthsList.size());

		for(Prior_Auth__c pA :relatedPriorAuthsList) {
			Case caseRecord = caseByPAId.get(pA.Id);
			pA.Case__c = caseRecord.Id;
			pA.Contact_Drug__c = caseRecord.Contact_Drug__c;
			existingPAList.add(pA);
		}

		uow.registerDirty(existingPAList);

		System.debug('existingPAList Count = ' + existingPAList.size());

	}

	private void mapCasesToDailyClaim(Map<Id, Case> caseByDailyClaimId, fflib_ISObjectUnitOfWork uow) {

		List<SObject> existingDailyClaimList = new List<SObject>();
		List<Daily_Claim__c> relatedDailyClaimsList = new List<Daily_Claim__c>();

		Daily_ClaimsSelector dailyClaimSelector = (Daily_ClaimsSelector) PMd_Application.Selector.newInstance(Daily_Claim__c.SObjectType);
		if(caseByDailyClaimId.keySet().size() > 0) {
			relatedDailyClaimsList = dailyClaimSelector.selectById(caseByDailyClaimId.keySet());
		}
		System.debug('relatedDailyClaimsList Count: ' + relatedDailyClaimsList.size());

		for(Daily_Claim__c dailyClaimRecord :relatedDailyClaimsList) {
			Case caseRecord = caseByDailyClaimId.get(dailyClaimRecord.Id);
			dailyClaimRecord.Case__c = caseRecord.Id;
			dailyClaimRecord.Status__c = caseRecord.Daily_Claim_Status__c;
			existingDailyClaimList.add(dailyClaimRecord);
		}

		uow.registerDirty(existingDailyClaimList);

		System.debug('existingDailyClaimList Count = ' + existingDailyClaimList.size());

	}

	//Map Daily Claim fields to new Case fields
	private Case mapDailyClaimToCase(Daily_Claim__c dailyClaim, Case caseRecord) {
		System.debug('Inside the mapDailyClaimToCase method on line # 2614');
		System.debug('The Go Live Date inside the mapDailyClaimToCase method is: '+goLiveDate);
		System.debug('The Case Record Type Id inside the mapDailyClaimToCase method is: '+caseRecord.RecordTypeId);
		//if(dailyClaim.HCPCS_Code__c != null || dailyClaim.HCPCS_Code__c != '') {
		caseRecord.HCPCS_Code__c = dailyClaim.HCPCS_Code__c;
		//}
		//Adding the below code logic as part of ADO-1640 to check for Go Live Date and Case Record Type
		Id ReimbursementRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reimbursement').getRecordTypeId();
		Id EnrollmentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
		if (System.today() > goLiveDate && caseRecord.RecordTypeId.Equals(EnrollmentRecordTypeId)){
			System.debug('Inside the Post Go-Live loop where the Service Provider fields get updated from the Daily Claim record');
			if(!String.isBlank(dailyClaim.Service_Provider_Address_Line_1__c)) {
				caseRecord.Service_Provider_Address_Line_1__c = dailyClaim.Service_Provider_Address_Line_1__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_City__c)) {
				caseRecord.Service_Provider_City__c = dailyClaim.Service_Provider_City__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_First_Name__c)) {
				caseRecord.Service_Provider_First_Name__c = dailyClaim.Service_Provider_First_Name__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_Last_Name__c)) {
				caseRecord.Service_Provider_Last_Name__c = dailyClaim.Service_Provider_Last_Name__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_Zip__c)) {
				caseRecord.Service_Provider_Zip__c = dailyClaim.Service_Provider_Zip__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_State__c)) {
				caseRecord.Service_Provider_State__c = dailyClaim.Service_Provider_State__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_Fax__c)) {
				caseRecord.Service_Provider_Fax__c = dailyClaim.Service_Provider_Fax__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_Phone__c)) {
				caseRecord.Service_Provider_Phone__c = dailyClaim.Service_Provider_Phone__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_NPI__c)) {
				caseRecord.Service_Provider_NPI__c = dailyClaim.Service_Provider_NPI__c;
			}
		}
		else if(System.today() < goLiveDate && caseRecord.RecordTypeId.Equals(EnrollmentRecordTypeId)){
			System.debug('Inside the Pre Go-Live loop to check for Case Enrollment Record Type');
			if(String.isBlank(caseRecord.Service_Provider_Updated_By__c) && caseRecord.Service_Provider_Updated_Date__c == null){
				if(!String.isBlank(dailyClaim.Service_Provider_Address_Line_1__c)) {
					caseRecord.Service_Provider_Address_Line_1__c = dailyClaim.Service_Provider_Address_Line_1__c;
				}
				if(!String.isBlank(dailyClaim.Service_Provider_City__c)) {
					caseRecord.Service_Provider_City__c = dailyClaim.Service_Provider_City__c;
				}
				if(!String.isBlank(dailyClaim.Service_Provider_First_Name__c)) {
					caseRecord.Service_Provider_First_Name__c = dailyClaim.Service_Provider_First_Name__c;
				}
				if(!String.isBlank(dailyClaim.Service_Provider_Last_Name__c)) {
					caseRecord.Service_Provider_Last_Name__c = dailyClaim.Service_Provider_Last_Name__c;
				}
				if(!String.isBlank(dailyClaim.Service_Provider_Zip__c)) {
					caseRecord.Service_Provider_Zip__c = dailyClaim.Service_Provider_Zip__c;
				}
				if(!String.isBlank(dailyClaim.Service_Provider_State__c)) {
					caseRecord.Service_Provider_State__c = dailyClaim.Service_Provider_State__c;
				}
				if(!String.isBlank(dailyClaim.Service_Provider_Fax__c)) {
					caseRecord.Service_Provider_Fax__c = dailyClaim.Service_Provider_Fax__c;
				}
				if(!String.isBlank(dailyClaim.Service_Provider_Phone__c)) {
					caseRecord.Service_Provider_Phone__c = dailyClaim.Service_Provider_Phone__c;
				}
				if(!String.isBlank(dailyClaim.Service_Provider_NPI__c)) {
					caseRecord.Service_Provider_NPI__c = dailyClaim.Service_Provider_NPI__c;
				}
			}
			else{
				System.debug('The Service Provider fields are not updated in Salesforce as they have been modified through User Interface by: '+caseRecord.Service_Provider_Updated_By__c);
			}
		}
		else if(caseRecord.RecordTypeId.Equals(ReimbursementRecordTypeId)){
			if(!String.isBlank(dailyClaim.Service_Provider_Address_Line_1__c)) {
				caseRecord.Service_Provider_Address_Line_1__c = dailyClaim.Service_Provider_Address_Line_1__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_City__c)) {
				caseRecord.Service_Provider_City__c = dailyClaim.Service_Provider_City__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_First_Name__c)) {
				caseRecord.Service_Provider_First_Name__c = dailyClaim.Service_Provider_First_Name__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_Last_Name__c)) {
				caseRecord.Service_Provider_Last_Name__c = dailyClaim.Service_Provider_Last_Name__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_Zip__c)) {
				caseRecord.Service_Provider_Zip__c = dailyClaim.Service_Provider_Zip__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_State__c)) {
				caseRecord.Service_Provider_State__c = dailyClaim.Service_Provider_State__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_Fax__c)) {
				caseRecord.Service_Provider_Fax__c = dailyClaim.Service_Provider_Fax__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_Phone__c)) {
				caseRecord.Service_Provider_Phone__c = dailyClaim.Service_Provider_Phone__c;
			}
			if(!String.isBlank(dailyClaim.Service_Provider_NPI__c)) {
				caseRecord.Service_Provider_NPI__c = dailyClaim.Service_Provider_NPI__c;
			}
		}
		if(caseRecord.Most_Recent_Service_From_Date__c == null || dailyClaim.Date_Of_Service_From__c > caseRecord.Most_Recent_Service_From_Date__c) {
			caseRecord.Most_Recent_Service_From_Date__c = dailyClaim.Date_Of_Service_From__c;
		}
		if(!String.isBlank(dailyClaim.Drug_Label_Name__c)) {
			caseRecord.Drug_Label_Name__c = dailyClaim.Drug_Label_Name__c;
		}
		return caseRecord;
	}

	//Map Historical Claim fields to new Case fields
	private Case mapHistoricalClaimToCase(Historical_Claim__c historicalClaim, Case caseRecord) {

		//if(historicalClaim.HCPCS_Code__c != null || historicalClaim.HCPCS_Code__c != '') {
		caseRecord.HCPCS_Code__c = historicalClaim.HCPCS_Code__c;
		
		if(!String.isBlank(historicalClaim.Drug_Label_Name__c)) {
			caseRecord.Drug_Label_Name__c = historicalClaim.Drug_Label_Name__c;
		}

		return caseRecord;
	}

	//Map locaded Prior Auth fields to new Case fields
	private Case mapPriorAuthToCase(Prior_Auth__c priorAuth, Case caseRecord) {

		if(!String.isBlank(priorAuth.Prior_Authorization__c)) {
			caseRecord.Prior_Authorization__c = priorAuth.Prior_Authorization__c;
		}
		if(!String.isBlank(priorAuth.Diagnosis_Code__c)) {
			caseRecord.Diagnosis_Code__c = priorAuth.Diagnosis_Code__c;
		}
		if(!String.isBlank(priorAuth.Drug_Label_Name__c)) {
			caseRecord.Drug_Label_Name__c = priorAuth.Drug_Label_Name__c;
		}
		caseRecord.HCPCS_Code__c = priorAuth.HCPCS_Code__c;
		//caseRecord.NDC__c = priorAuth.NDC__c;
		if(priorAuth.Service_Start_Date__c != null) {
			caseRecord.Service_Start_Date__c = priorAuth.Service_Start_Date__c;
		}
		if(priorAuth.Service_End_Date__c != null) {
			caseRecord.Service_End_Date__c = priorAuth.Service_End_Date__c;
		}
		if(!String.isBlank(priorAuth.Prescriber_Address_Line_1__c)) {
			caseRecord.Prescriber_Address_Line_1__c = priorAuth.Prescriber_Address_Line_1__c;
		}
		if(!String.isBlank(priorAuth.Prescriber_City__c)) {
			caseRecord.Prescriber_City__c = priorAuth.Prescriber_City__c;
		}
		if(!String.isBlank(priorAuth.Prescriber_Fax__c)) {
			caseRecord.Prescriber_Fax__c = priorAuth.Prescriber_Fax__c;
		}
		if(!String.isBlank(priorAuth.Prescriber_First_Name__c)) {
			caseRecord.Prescriber_First_Name__c = priorAuth.Prescriber_First_Name__c;
		}
		if(!String.isBlank(priorAuth.Prescriber_Last_Name__c)) {
			caseRecord.Prescriber_Last_Name__c = priorAuth.Prescriber_Last_Name__c;
		}
		if(!String.isBlank(priorAuth.Prescriber_Phone__c)) {
			caseRecord.Prescriber_Phone__c = priorAuth.Prescriber_Phone__c;
		}
		if(!String.isBlank(priorAuth.Prescriber_Practice_Name__c)) {
			caseRecord.Prescriber_Practice_Name__c = priorAuth.Prescriber_Practice_Name__c;
		}
		if(!String.isBlank(priorAuth.Prescriber_NPI_Number__c)) {
			caseRecord.Prescriber_NPI_Number__c = priorAuth.Prescriber_NPI_Number__c;
		}
		if(!String.isBlank(priorAuth.Prescriber_Specialty__c)) {
			caseRecord.Prescriber_Specialty__c = priorAuth.Prescriber_Specialty__c;
		}
		if(!String.isBlank(priorAuth.Prescriber_State__c)) {
			caseRecord.Prescriber_State__c = priorAuth.Prescriber_State__c;
		}
		if(!String.isBlank(priorAuth.Prescriber_Zip_Code__c)) {
			caseRecord.Prescriber_Zip_Code__c = priorAuth.Prescriber_Zip_Code__c;
		}
		if(!String.isBlank(priorAuth.Service_Provider_Fax__c)) {
			caseRecord.Service_Provider_Fax__c = priorAuth.Service_Provider_Fax__c;
		}
		if(!String.isBlank(priorAuth.Service_Provider_Phone__c)) {
			caseRecord.Service_Provider_Phone__c = priorAuth.Service_Provider_Phone__c;
		}
		if(!String.isBlank(priorAuth.Service_Provider_Address_Line_1__c)) {
			caseRecord.Service_Provider_Address_Line_1__c = priorAuth.Service_Provider_Address_Line_1__c;
		}
		if(!String.isBlank(priorAuth.Service_Provider_City__c)) {
			caseRecord.Service_Provider_City__c = priorAuth.Service_Provider_City__c;
		}
		if(!String.isBlank(priorAuth.Service_Provider_First_Name__c)) {
			caseRecord.Service_Provider_First_Name__c = priorAuth.Service_Provider_First_Name__c;
		}
		if(!String.isBlank(priorAuth.Service_Provider_Last_Name__c)) {
			caseRecord.Service_Provider_Last_Name__c = priorAuth.Service_Provider_Last_Name__c;
		}
		if(!String.isBlank(priorAuth.Service_Provider_NPI__c)) {
			caseRecord.Service_Provider_NPI__c = priorAuth.Service_Provider_NPI__c;
		}
		if(!String.isBlank(priorAuth.Service_Provider_Zip__c)) {
			caseRecord.Service_Provider_Zip__c = priorAuth.Service_Provider_Zip__c;
		}
		if(!String.isBlank(priorAuth.Service_Provider_Specialty_Code__c)) {
			caseRecord.Service_Provider_Specialty_Code__c = priorAuth.Service_Provider_Specialty_Code__c;
		}
		if(!String.isBlank(priorAuth.Service_Provider_State__c)) {
			caseRecord.Service_Provider_State__c = priorAuth.Service_Provider_State__c;
		}
		//caseRecord.Service_Provider_Practice__c = priorAuth.Service_Provider_Practice__c;
		if(caseRecord.Most_Recent_Service_From_Date__c == null || priorAuth.Service_Start_Date__c > caseRecord.Most_Recent_Service_From_Date__c) {
			caseRecord.Most_Recent_Service_From_Date__c = priorAuth.Service_Start_Date__c;
		}
		if(!String.isBlank(priorAuth.Drug_Label_Name__c)) {
			caseRecord.Drug_Label_Name__c = priorAuth.Drug_Label_Name__c;
		}

		caseRecord.Prior_Auth__c = priorAuth.Id;

		return caseRecord;
	}

	//Map locaded Historical Prior Auth fields to new Case fields
	private Case mapHistoricalPriorAuthToCase(Historical_Prior_Auth__c historicalPriorAuth, Case caseRecord) {

		caseRecord.Prior_Authorization__c = historicalPriorAuth.Prior_Authorization__c;
		if(historicalPriorAuth.Service_Start_Date__c != null) {
			caseRecord.Service_Start_Date__c = historicalPriorAuth.Service_Start_Date__c;
		}
		if(historicalPriorAuth.Service_End_Date__c != null) {
			caseRecord.Service_End_Date__c = historicalPriorAuth.Service_End_Date__c;
		}
		if(!String.isBlank(historicalPriorAuth.Diagnosis_Code__c)) {
			caseRecord.Diagnosis_Code__c = historicalPriorAuth.Diagnosis_Code__c;
		}
		if(!String.isBlank(historicalPriorAuth.Drug_Label_Name__c)) {
			caseRecord.Drug_Label_Name__c = historicalPriorAuth.Drug_Label_Name__c;
		}
		//if(historicalPriorAuth.HCPCS_Code__c != null || historicalPriorAuth.HCPCS_Code__c != '') {
		caseRecord.HCPCS_Code__c = historicalPriorAuth.HCPCS_Code__c;
		//}
		//caseRecord.NDC__c = historicalPriorAuth.NDC__c;
		//caseRecord.PA_Approval_Dates__c = historicalPriorAuth.PA_Approval_Dates__c;
		if(!String.isBlank(historicalPriorAuth.Prescriber_Address_Line_1__c)) {
			caseRecord.Prescriber_Address_Line_1__c = historicalPriorAuth.Prescriber_Address_Line_1__c;
		}
		if(!String.isBlank(historicalPriorAuth.Prescriber_City__c)) {
			caseRecord.Prescriber_City__c = historicalPriorAuth.Prescriber_City__c;
		}
		if(!String.isBlank(historicalPriorAuth.Prescriber_Fax__c)) {
			caseRecord.Prescriber_Fax__c = historicalPriorAuth.Prescriber_Fax__c;
		}
		if(!String.isBlank(historicalPriorAuth.Prescriber_First_Name__c)) {
			caseRecord.Prescriber_First_Name__c = historicalPriorAuth.Prescriber_First_Name__c;
		}
		if(!String.isBlank(historicalPriorAuth.Prescriber_Last_Name__c)) {
			caseRecord.Prescriber_Last_Name__c = historicalPriorAuth.Prescriber_Last_Name__c;
		}
		if(!String.isBlank(historicalPriorAuth.Prescriber_Phone__c)) {
			caseRecord.Prescriber_Phone__c = historicalPriorAuth.Prescriber_Phone__c;
		}
		if(!String.isBlank(historicalPriorAuth.Prescriber_Practice_Name__c)) {
			caseRecord.Prescriber_Practice_Name__c = historicalPriorAuth.Prescriber_Practice_Name__c;
		}
		if(!String.isBlank(historicalPriorAuth.Prescriber_NPI_Number__c)) {
			caseRecord.Prescriber_NPI_Number__c = historicalPriorAuth.Prescriber_NPI_Number__c;
		}
		if(!String.isBlank(historicalPriorAuth.Prescriber_Specialty__c)) {
			caseRecord.Prescriber_Specialty__c = historicalPriorAuth.Prescriber_Specialty__c;
		}
		if(!String.isBlank(historicalPriorAuth.Prescriber_State__c)) {
			caseRecord.Prescriber_State__c = historicalPriorAuth.Prescriber_State__c;
		}
		if(!String.isBlank(historicalPriorAuth.Prescriber_Zip_Code__c)) {
			caseRecord.Prescriber_Zip_Code__c = historicalPriorAuth.Prescriber_Zip_Code__c;
		}
		if(!String.isBlank(historicalPriorAuth.Service_Provider_Fax__c)) {
			caseRecord.Service_Provider_Fax__c = historicalPriorAuth.Service_Provider_Fax__c;
		}
		if(!String.isBlank(historicalPriorAuth.Service_Provider_Phone__c)) {
			caseRecord.Service_Provider_Phone__c = historicalPriorAuth.Service_Provider_Phone__c;
		}
		if(!String.isBlank(historicalPriorAuth.Service_Provider_Address_Line_1__c)) {
			caseRecord.Service_Provider_Address_Line_1__c = historicalPriorAuth.Service_Provider_Address_Line_1__c;
		}
		if(!String.isBlank(historicalPriorAuth.Service_Provider_City__c)) {
			caseRecord.Service_Provider_City__c = historicalPriorAuth.Service_Provider_City__c;
		}
		if(!String.isBlank(historicalPriorAuth.Service_Provider_First_Name__c)) {
			caseRecord.Service_Provider_First_Name__c = historicalPriorAuth.Service_Provider_First_Name__c;
		}
		if(!String.isBlank(historicalPriorAuth.Service_Provider_Last_Name__c)) {
			caseRecord.Service_Provider_Last_Name__c = historicalPriorAuth.Service_Provider_Last_Name__c;
		}
		if(!String.isBlank(historicalPriorAuth.Service_Provider_NPI__c)) {
			caseRecord.Service_Provider_NPI__c = historicalPriorAuth.Service_Provider_NPI__c;
		}
		if(!String.isBlank(historicalPriorAuth.Service_Provider_Zip__c)) {
			caseRecord.Service_Provider_Zip__c = historicalPriorAuth.Service_Provider_Zip__c;
		}
		if(!String.isBlank(historicalPriorAuth.Service_Provider_Specialty_Code__c)) {
			caseRecord.Service_Provider_Specialty_Code__c = historicalPriorAuth.Service_Provider_Specialty_Code__c;
		}
		if(!String.isBlank(historicalPriorAuth.Service_Provider_State__c)) {
			caseRecord.Service_Provider_State__c = historicalPriorAuth.Service_Provider_State__c;
		}
		//caseRecord.Service_Provider_Practice__c = historicalPriorAuth.Service_Provider_Practice__c;

		caseRecord.Historical_Prior_Auth__c = historicalPriorAuth.Id;

		if(caseRecord.Most_Recent_Service_From_Date__c == null || historicalPriorAuth.Service_Start_Date__c > caseRecord.Most_Recent_Service_From_Date__c) {
			caseRecord.Most_Recent_Service_From_Date__c = historicalPriorAuth.Service_Start_Date__c;
		}
		if(!String.isBlank(historicalPriorAuth.Drug_Label_Name__c)) {
			caseRecord.Drug_Label_Name__c = historicalPriorAuth.Drug_Label_Name__c;
		}

		return caseRecord;
	}

	//Map loaded Prior Auth fields to new Prior Auth fields
	private Prior_Auth__c mapLoadedPriorAuthToPriorAuth(Prior_Auth__c loadedPA, Prior_Auth__c newPA) {

		newPA.CSA_Account__c = loadedPA.CSA_Account__c;
		newPA.Prior_Authorization__c = loadedPA.Prior_Authorization__c;
		newPA.Service_Start_Date__c = loadedPA.Service_Start_Date__c;
		System.Debug('newPA.Service_Start_Date__c = ' + newPA.Service_Start_Date__c);
		newPA.Authorized_Representative__c = loadedPA.Authorized_Representative__c;
		newPA.Authorized_Relationship__c = loadedPA.Authorized_Relationship__c;
		//newPA.Total_Copay__c = loadedPA.Total_Copay__c;
		newPA.CSA_Control__c = loadedPA.CSA_Control__c;
		newPA.Diagnosis_Code__c = loadedPA.Diagnosis_Code__c;
		newPA.Drug_Label_Name__c = loadedPA.Drug_Label_Name__c;
		newPA.HCPCS_Code__c = loadedPA.HCPCS_Code__c;
		//newPA.NDC__c = loadedPA.NDC__c;
		//newPA.PA_Approval_Dates__c = loadedPA.PA_Approval_Dates__c;
		newPA.Patient_Birth_Date__c = loadedPA.Patient_Birth_Date__c;
		//newPA.Patient_Email_Address__c = loadedPA.Patient_Email_Address__c;
		newPA.Patient_First_Name__c = loadedPA.Patient_First_Name__c;
		newPA.Patient_Last_Name__c = loadedPA.Patient_Last_Name__c;
		newPA.Patient_Middle_Initial__c = loadedPA.Patient_Middle_Initial__c;
		newPA.Patient_Phone_Number__c = loadedPA.Patient_Phone_Number__c;
		newPA.Patient_Gender__c = loadedPA.Patient_Gender__c;
		newPA.Plan_Sponsor_Name__c = loadedPA.Plan_Sponsor_Name__c;
		newPA.Prescriber_Address_Line_1__c = loadedPA.Prescriber_Address_Line_1__c;
		newPA.Prescriber_City__c = loadedPA.Prescriber_City__c;
		newPA.Prescriber_Fax__c = loadedPA.Prescriber_Fax__c;
		newPA.Prescriber_First_Name__c = loadedPA.Prescriber_First_Name__c;
		newPA.Prescriber_Last_Name__c = loadedPA.Prescriber_Last_Name__c;
		newPA.Prescriber_Phone__c = loadedPA.Prescriber_Phone__c;
		newPA.Prescriber_Practice_Name__c = loadedPA.Prescriber_Practice_Name__c;
		newPA.Prescriber_NPI_Number__c = loadedPA.Prescriber_NPI_Number__c;
		newPA.Prescriber_Specialty__c = loadedPA.Prescriber_Specialty__c;
		newPA.Prescriber_State__c = loadedPA.Prescriber_State__c;
		newPA.Prescriber_Zip_Code__c = loadedPA.Prescriber_Zip_Code__c;

		newPA.Service_Provider_Fax__c = loadedPA.Service_Provider_Fax__c;
		newPA.Service_Provider_Phone__c = loadedPA.Service_Provider_Phone__c;
		newPA.Service_Provider_Address_Line_1__c = loadedPA.Service_Provider_Address_Line_1__c;
		newPA.Service_Provider_City__c = loadedPA.Service_Provider_City__c;
		newPA.Service_Provider_First_Name__c = loadedPA.Service_Provider_First_Name__c;
		newPA.Service_Provider_Last_Name__c = loadedPA.Service_Provider_Last_Name__c;
		newPA.Service_Provider_NPI__c = loadedPA.Service_Provider_NPI__c;
		newPA.Service_Provider_Zip__c = loadedPA.Service_Provider_Zip__c;
		newPA.Service_Provider_Specialty_Code__c = loadedPA.Service_Provider_Specialty_Code__c;
		newPA.Service_Provider_State__c = loadedPA.Service_Provider_State__c;
		newPA.Service_Provider_Practice__c = loadedPA.Service_Provider_Practice__c;

		newPA.Patient_Address_Line_1__c = loadedPA.Patient_Address_Line_1__c;
		newPA.Patient_Address_Line_2__c = loadedPA.Patient_Address_Line_2__c;
		newPA.Patient_City__c = loadedPA.Patient_City__c;
		newPA.Patient_CUMB_ID__c = loadedPA.Patient_CUMB_ID__c;
		newPA.Patient_State__c = loadedPA.Patient_State__c;
		newPA.Patient_Zip_Code__c = loadedPA.Patient_Zip_Code__c;
		newPA.CSA_Suffix__c = loadedPA.CSA_Suffix__c;

		return newPA;
	}

	//Map loaded Historical Prior Auth fields to new Historical Prior Auth fields
	private Historical_Prior_Auth__c mapLoadedHistoricalPriorAuthToHistoricalPriorAuth(Historical_Prior_Auth__c loadedHPA, Historical_Prior_Auth__c newPA) {

		newPA.Contact_Drug__c = loadedHPA.Contact_Drug__c;
		newPA.Case__c = loadedHPA.Case__c;
		newPA.CSA_Account__c = loadedHPA.CSA_Account__c;
		newPA.Prior_Authorization__c = loadedHPA.Prior_Authorization__c;
		//newPA.Authorized_Representative__c = loadedHPA.Authorized_Representative__c;
		//newPA.Authorized_Relationship__c = loadedHPA.Authorized_Relationship__c;
		//newPA.Total_Copay__c = loadedHPA.Total_Copay__c;
		newPA.CSA_Control__c = loadedHPA.CSA_Control__c;
		newPA.Diagnosis_Code__c = loadedHPA.Diagnosis_Code__c;
		newPA.Drug_Label_Name__c = loadedHPA.Drug_Label_Name__c;
		newPA.HCPCS_Code__c = loadedHPA.HCPCS_Code__c;
		//newPA.NDC__c = loadedHPA.NDC__c;
		newPA.Service_Start_Date__c = loadedHPA.Service_Start_Date__c;
		newPA.Service_End_Date__c = loadedHPA.Service_End_Date__c;
		newPA.Patient_Birth_Date__c = loadedHPA.Patient_Birth_Date__c;
		//newPA.Patient_Email_Address__c = loadedHPA.Patient_Email_Address__c;
		newPA.Patient_First_Name__c = loadedHPA.Patient_First_Name__c;
		newPA.Patient_Last_Name__c = loadedHPA.Patient_Last_Name__c;
		newPA.Patient_Middle_Initial__c = loadedHPA.Patient_Middle_Initial__c;
		newPA.Patient_Phone_Number__c = loadedHPA.Patient_Phone_Number__c;
		newPA.Patient_Gender__c = loadedHPA.Patient_Gender__c;
		newPA.Plan_Sponsor_Name__c = loadedHPA.Plan_Sponsor_Name__c;
		newPA.Prescriber_Address_Line_1__c = loadedHPA.Prescriber_Address_Line_1__c;
		newPA.Prescriber_City__c = loadedHPA.Prescriber_City__c;
		newPA.Prescriber_Fax__c = loadedHPA.Prescriber_Fax__c;
		newPA.Prescriber_First_Name__c = loadedHPA.Prescriber_First_Name__c;
		newPA.Prescriber_Last_Name__c = loadedHPA.Prescriber_Last_Name__c;
		newPA.Prescriber_Phone__c = loadedHPA.Prescriber_Phone__c;
		newPA.Prescriber_Practice_Name__c = loadedHPA.Prescriber_Practice_Name__c;
		newPA.Prescriber_NPI_Number__c = loadedHPA.Prescriber_NPI_Number__c;
		newPA.Prescriber_Specialty__c = loadedHPA.Prescriber_Specialty__c;
		newPA.Prescriber_State__c = loadedHPA.Prescriber_State__c;
		newPA.Prescriber_Zip_Code__c = loadedHPA.Prescriber_Zip_Code__c;

		newPA.Service_Provider_Fax__c = loadedHPA.Service_Provider_Fax__c;
		newPA.Service_Provider_Phone__c = loadedHPA.Service_Provider_Phone__c;
		newPA.Service_Provider_Address_Line_1__c = loadedHPA.Service_Provider_Address_Line_1__c;
		newPA.Service_Provider_City__c = loadedHPA.Service_Provider_City__c;
		newPA.Service_Provider_First_Name__c = loadedHPA.Service_Provider_First_Name__c;
		newPA.Service_Provider_Last_Name__c = loadedHPA.Service_Provider_Last_Name__c;
		newPA.Service_Provider_NPI__c = loadedHPA.Service_Provider_NPI__c;
		newPA.Service_Provider_Zip__c = loadedHPA.Service_Provider_Zip__c;
		newPA.Service_Provider_Specialty_Code__c = loadedHPA.Service_Provider_Specialty_Code__c;
		newPA.Service_Provider_State__c = loadedHPA.Service_Provider_State__c;
		newPA.Service_Provider_Practice__c = loadedHPA.Service_Provider_Practice__c;

		newPA.Patient_Address_Line_1__c = loadedHPA.Patient_Address_Line_1__c;
		newPA.Patient_Address_Line_2__c = loadedHPA.Patient_Address_Line_2__c;
		newPA.Patient_City__c = loadedHPA.Patient_City__c;
		newPA.Patient_CUMB_ID__c = loadedHPA.Patient_CUMB_ID__c;
		newPA.Relationship_Code__c = loadedHPA.Relationship_Code__c;
		newPA.Patient_State__c = loadedHPA.Patient_State__c;
		newPA.Patient_Zip_Code__c = loadedHPA.Patient_Zip_Code__c;
		newPA.CSA_Suffix__c = loadedHPA.CSA_Suffix__c;

		return newPA;
	}

	/***************************************************************************************************************************************
     * Trigger Operations
     **************************************************************************************************************************************/

	public override void onBeforeInsert() {
		System.debug('Start Case:onBeforeInsert');

		List<Case> caseList = Records;
		List<Case> casesToProcessList = new List<Case>();
		Id generalQueue, preGoLiveNewEnrollmentQueue, preGoLiveFaxValidationQueue, preGoLiveEnrollmentFollowUpQueue, postGoLiveNewEnrollmentQueue, postGoLiveFaxValidationQueue,
				postGoLiveEnrollmentFollowUpQueue, postGoLiveEnrollmentNEWQueue, postGoLiveReimbursementNEWQueue, postGoLiveReimbursementFollowUpQueue;

		if(mapPrudentMedBenQueues.size() > 0) {
			for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
				String queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
				System.debug('queue = '+queue);
				System.debug('GroupId = '+GroupId);
				switch on queue {
					when 'General' { // when queue is General
						generalQueue = GroupId;
					}
					when 'PRE_Go_Live_New_Enrollment' { // when queue is PRE-Go-Live New Enrollment
						preGoLiveNewEnrollmentQueue = GroupId;
					}
					when 'Pre_Go_Live_Fax_Validation' { // when queue is Pre-Go-Live Fax Validation
						preGoLiveFaxValidationQueue = GroupId;
					}
					when 'PRE_Go_Live_Enrollment_Follow_Up' { // when queue is PRE-Go-Live  Enrollment Follow-Up
						preGoLiveEnrollmentFollowUpQueue = GroupId;
					}
					when 'POST_Go_Live_New_Enrollment' { // when queue is POST-Go-Live New Enrollment
						postGoLiveNewEnrollmentQueue = GroupId;
					}
					when 'POST_Go_Live_Fax_Validation' { // when queue is POST-Go-Live Fax Validation
						postGoLiveFaxValidationQueue = GroupId;
					}
					when 'POST_Go_Live_Enrollment_Follow_Up' { // when queue is POST-Go-Live Enrollment Follow-Up
						postGoLiveEnrollmentFollowUpQueue = GroupId;
					}
					when 'Post_Go_Live_Enrollment_NEW_Queue' { // when queue is Post-Go-Live Enrollment - NEW Queu
						postGoLiveEnrollmentNEWQueue = GroupId;
					}
					when 'Post_Go_Live_Reimbursement_NEW_Queue' { // when queue is Post-Go-Live Reimbursement - NEW Queu
						postGoLiveReimbursementNEWQueue = GroupId;
					}
					when 'Post_Go_Live_Reimbursement_Follow_Up' { // when queue is Post-Go-Live Reimbursement - Follow-Up
						postGoLiveReimbursementFollowUpQueue = GroupId;
					}
				}
			}
		}

		for(Case caseRecord : caseList) {
			//Case oldCaseRecord = (Case) oldRecords.get(caseRecord.Id);
			//If the Follow_up_Time__c changed
			//if(caseRecord.Follow_up_Time__c != oldCaseRecord.Follow_up_Time__c
			//		&& (caseRecord.OwnerId != generalQueue
			if (caseRecord.OwnerId != generalQueue
					|| caseRecord.OwnerId != preGoLiveNewEnrollmentQueue
					|| caseRecord.OwnerId != preGoLiveFaxValidationQueue
					|| caseRecord.OwnerId != preGoLiveEnrollmentFollowUpQueue
					|| caseRecord.OwnerId != postGoLiveNewEnrollmentQueue
					|| caseRecord.OwnerId != postGoLiveFaxValidationQueue
					|| caseRecord.OwnerId != postGoLiveEnrollmentFollowUpQueue
					|| caseRecord.OwnerId != postGoLiveEnrollmentNEWQueue
					|| caseRecord.OwnerId != postGoLiveReimbursementNEWQueue
					|| caseRecord.OwnerId != postGoLiveReimbursementFollowUpQueue)
			{
				caseRecord.OwnerId = GeneralQueue; //Case Owner returns to GeneralQueue
				//caseRecord.Follow_up_Time__c = DateTime.now();
			}
		}
		if(casesToProcessList.size() > 0) {
			//ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
		}
		System.debug('End Case:onBeforeInsert');
	}

	// public override void processAfterInsert(){
	public override void onAfterInsert() {
		System.debug('Start Case:onAfterInsert');

		fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

		List<Case> caseList = Records;
		List<Case> casesToProcessList = new List<Case>();
		Map<Id, Case> caseByContact_DrugId = new Map<Id, Case>();
		Map<Id, Case> caseByHistoricalPAId = new Map<Id, Case>();
		Map<Id, Case> caseByPAId = new Map<Id, Case>();
		Map<Id, Case> caseByDailyClaimId = new Map<Id, Case>();
		Map<Id, Contact_Drug__c> contact_DrugByContactDrugId = new Map<Id, Contact_Drug__c>();

		//Get all cases by contact_DrugId
		for(Case caseRecord : caseList) {
			caseByContact_DrugId.put(caseRecord.Contact_Drug__c, caseRecord);
			caseByHistoricalPAId.put(caseRecord.Historical_Prior_Auth__c, caseRecord);
			caseByPAId.put(caseRecord.Prior_Auth__c, caseRecord);
			if(caseRecord.Daily_Claim__c != null) {
				caseByDailyClaimId.put(caseRecord.Daily_Claim__c, caseRecord);
			}
			System.debug('caseRecord.Contact_Drug__c = ' + caseRecord.Contact_Drug__c);
			System.debug('caseRecord.Historical_Prior_Auth__c = ' + caseRecord.Historical_Prior_Auth__c);
			System.debug('caseRecord.Prior_Auth__c = ' + caseRecord.Prior_Auth__c);
			System.debug('caseRecord.Daily_Claim__c = ' + caseRecord.Daily_Claim__c);
			System.debug('caseRecord = ' + caseRecord);
		}

		//Map all Case related HistoricalPAs
		if(caseByHistoricalPAId.size() > 0) {
			mapCasesToHistoricalPA(caseByHistoricalPAId, uow);
		}
		//Map all Case related PAs
		if(caseByPAId.size() > 0) {
			mapCasesToPA(caseByPAId, uow);
		}
		//Map all Case related Contact_Drugs
		if(caseByContact_DrugId.size() > 0) {
			mapCasesToContact_Drugs(caseByContact_DrugId, uow);
		}
		//Map all Case related Daily Claims
		if(caseByDailyClaimId.size() > 0) {
			mapCasesToDailyClaim(caseByDailyClaimId, uow);
		}

		if(casesToProcessList.size() > 0) {
			//ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
		}
		try {
			uow.commitWork();
		}catch(Exception e){
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Cases.onAfterInsert', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, null, null, null);
			ErrorLog.commitLogs();
			//throw e;
		}

		System.debug('End Case:onAfterInsert');
	}

	public override void onBeforeUpdate(Map<Id, SObject> oldRecords) {
		System.debug('Start Case:onBeforeUpdate');

		List<Case> casesUpdated =Records;
		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo reimbursementCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');

		System.debug('casesUpdated.size() = '+ casesUpdated.size());
		for(Case caseRecord : casesUpdated) {
			Case oldCase = (Case)oldRecords.get(caseRecord.Id);

			//When the case status is changed from âTransfer to Health Planâ to any other status, the Send to Aetna field should clear out.
			if(oldCase.Status == 'Transfer to Health Plan'
					&& caseRecord.Status != 'Transfer to Health Plan'
					&&  caseRecord.Send_to_Aetna__c == 'Queued') {
				caseRecord.Send_to_Aetna__c = null;
			}
			/* Commented the below code section as part of US-539 and moved to a Formula Field
			if(oldCase.Status != 'Outreach Completed'
					&& caseRecord.Status == 'Outreach Completed'
					&& caseRecord.RecordTypeId == reimbursementCaseInfo.getRecordTypeId()) {

				//When case is closed, capture the age of the case
				caseRecord = CaseService.captureCaseClosedAge(caseRecord);
			}
			*/
			//New code block added for ADO-1640 to populate the Service Provider Updated By and Service Provider Updated Date when any of the Service Provider fields are modified
			if((oldcase.Service_Provider_First_Name__c != caseRecord.Service_Provider_First_Name__c) || (oldcase.Service_Provider_Last_Name__c != caseRecord.Service_Provider_Last_Name__c) ||
					(oldcase.Service_Provider_Point_of_Contact__c != caseRecord.Service_Provider_Point_of_Contact__c) || (oldcase.Service_Provider_Phone__c != caseRecord.Service_Provider_Phone__c) ||
					(oldcase.Service_Provider_Fax__c != caseRecord.Service_Provider_Fax__c) || (oldcase.Service_Provider_City__c != caseRecord.Service_Provider_City__c) ||
					(oldcase.Service_Provider_State__c != caseRecord.Service_Provider_State__c) || (oldcase.Service_Provider_Zip__c != caseRecord.Service_Provider_Zip__c) ||
					(oldcase.Service_Provider_NPI__c != caseRecord.Service_Provider_NPI__c) ||
					(oldcase.Service_Provider_Address__c != caseRecord.Service_Provider_Address__c) || (oldcase.Service_Provider_Address_Line_1__c != caseRecord.Service_Provider_Address_Line_1__c) &&
					(caseRecord.RecordType.Name == 'Enrollment')){
				System.debug('Inside the loop when one of the Service Provider fields are modified');
				caseRecord.Service_Provider_Updated_By__c = UserInfo.getUserId();
				caseRecord.Service_Provider_Updated_Date__c	= System.now();
			}
		}

		List<Case> casesToProcessList = Records;

		if(casesToProcessList.size() > 0) {
			//ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
		}
		System.debug('End Case:onBeforeUpdate');
	}

	public override void onAfterUpdate(Map<Id, SObject> oldRecords) {
		System.debug('Start Case:onAfterUpdate');

		fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

		List<Case> caseList = Records;
		List<Case> casesToProcessList = new List<Case>();
		Map<Id, Case> caseByContact_DrugId = new Map<Id, Case>();
		Map<Id, Case> caseByHistoricalPAId = new Map<Id, Case>();
		Map<Id, Case> caseByPAId = new Map<Id, Case>();
		Map<Id, Case> caseByDailyClaimId = new Map<Id, Case>();
		Map<Id, Contact_Drug__c> contact_DrugByContactDrugId = new Map<Id, Contact_Drug__c>();
		API_User__mdt IntegrationUser = [SELECT Id, Username__c, Profile_Name__c, ProfileId__c FROM API_User__mdt WHERE Alias__c = 'iuser'];
		//String contextUserName = UserInfo.getUserName(); //Returns the context user's login name.
		String contextUserProfileID = UserInfo.getProfileId(); //Returns the context user's profile ID.

		//Get all cases by contact_DrugId
		for(Case caseRecord : caseList){
			Case oldcase = (Case)oldRecords.get(caseRecord.Id);
			//Only the Integration User or Users with Sys Admin Full Profiles should be able to make this
			// change so that others can update the downstream objects w/o having permission to update the Source Objects.
			if(contextUserProfileID == IntegrationUser.ProfileId__c) {
				//|| contextUserProfileID == IntegrationUser.ProfileId) {
				caseByContact_DrugId.put(caseRecord.Contact_Drug__c, caseRecord);
				caseByHistoricalPAId.put(caseRecord.Historical_Prior_Auth__c, caseRecord);
				caseByPAId.put(caseRecord.Prior_Auth__c, caseRecord);
				if(caseRecord.Daily_Claim__c != null) {
					caseByDailyClaimId.put(caseRecord.Daily_Claim__c, caseRecord);
				}
			}
			System.debug('caseRecord.Contact_Drug__c = ' + caseRecord.Contact_Drug__c);
			System.debug('caseRecord.Historical_Prior_Auth__c = ' + caseRecord.Historical_Prior_Auth__c);
			System.debug('caseRecord.Prior_Auth__c = ' + caseRecord.Prior_Auth__c);
			System.debug('caseRecord.Daily_Claim__c = ' + caseRecord.Daily_Claim__c);
			System.debug('caseRecord = ' + caseRecord);

			System.debug('caseRecord.Contact.Patient_Phone_Number__c = ' +caseRecord.Contact.Patient_Phone_Number__c);
		}

		//Map all Case related HistoricalPAs
		if(caseByHistoricalPAId.size() > 0) {
			mapCasesToHistoricalPA(caseByHistoricalPAId, uow);
		}
		//Map all Case related PAs
		if(caseByPAId.size() > 0) {
			mapCasesToPA(caseByPAId, uow);
		}
		//Map all Case related Contact_Drugs
		if(caseByContact_DrugId.size() > 0) {
			mapCasesToContact_Drugs(caseByContact_DrugId, uow);
		}

		//Map all Case related Daily Claims
		if(caseByDailyClaimId.size() > 0) {
			mapCasesToDailyClaim(caseByDailyClaimId, uow);
		}

		if(casesToProcessList.size() > 0) {
			//ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
		}
		/*
		if(EnrollmentCaseforUpdate.size() > 0){
			update EnrollmentCaseforUpdate;
		}
		*/

		try {
			uow.commitWork();
		}catch(Exception e){
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Cases.onAfterUpdate', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, null, null, null);
			ErrorLog.commitLogs();
			//throw e;
		}

		System.debug('End Case:onAfterUpdate');
	}

}