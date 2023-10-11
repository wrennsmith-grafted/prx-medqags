/**
 * @author Matt Gerry
 * @date 3/29/2021
 * @description This is the Domain Layer class for the Contact object. It extends the fflib_SObjectDomain so that we can
 * inherit the many useful pre-built functionality in it. It extends the Task_Creator_Interface to force this class into a
 * contract and make it implement the methods in that contract. It helps with abstraction in the Task_Service_Impl class
 * Modifications Log
 * Ver   Date         Author                         Modification
 * 1.0   02-26-2022   Ricardy Banks					Initial Version
 * 1.1	 04-26-2023	  Arvind Mahadevan				US-540: Added new condition to check for Authorization Received before updating the 
 * 													Authorization Representative and Authorized Relationship from Daily Claim to Contact record.
 */

public inherited sharing class Contacts extends fflib_SObjectDomain
		implements IContacts  //Task_Creator_Interface
{
	//This sets up the super class (fflib_SObjectDomain) to have the records variable filled out
	public Contacts(List<Contact> contactRecords){
		super(contactRecords);
	}

	public List<Contact> getContacts()
	{
		return (List<Contact>) getRecords();
	}

	public void setDescription(String description)
	{
		for (Contact contact : getContacts())
		{
			contact.Description = description;
		}
	}
/*
	public static IContacts newInstance(){
		return (IContacts) PMd_Application.Domain.newInstance(Contact.SObjectType);
	}
*/
	//This helps allow for the fflib_SObjectDomain class to run its triggerHandler method
	//using the correct Domain class. This must be implemented in all domain classes.
	public class Constructor implements fflib_SObjectDomain.IConstructable{
		public fflib_SObjectDomain construct(List<SObject> sObjectList){
			return new Contacts(sObjectList);
		}
	}
/*
	public class Constructor implements fflib_IDomainConstructor{
		public fflib_SObjects construct(List<Object> objectList){
			return new Contacts((List<SObject>) objectList);
		}
	}
*/
	/*
	Contact processing logic:
		Look for an existing member based on Matching Logic here.
		If Contact does not exists based on logic above:
			Then create Contact
		If Contact does exist based on logic above:
			Then update Contact (refer to mapping document for fields), then check ContactDrug processing logic.
	 */
	public Map<Id, Contact> process(List<Daily_Claim__c> dailyClaimsList, Map<String, CSA__c> csasByCSA_Number, fflib_ISObjectUnitOfWork uow)
	{
		System.debug('In Contacts:process - Start processing Contacts for Daily Claims');

		// Create Contacts from the given Daily Claims
		List<SObject> newContactsList = new List<SObject>();
		List<SObject> existingContactsList = new List<SObject>();
		Map<Id, CSA__c> csaByDailyClaimId = new Map<Id, CSA__c>();
		//Map<String, CSA__c> csasByCSA_Number = new Map<String, CSA__c>();
		Map<String, Id> dailyClaimIdByCSANumber = new Map<String, Id>();
		//Map<Id, String> csaNumberByDailyClaimId = new Map<Id, String>();

		Set<String> primary_Claim_NumberSet = new Set<String>();
		Set<String> claim_SegmentSet = new Set<String>();
		Set<String> claim_LineSet = new Set<String>();
		Set<String> previous_SegmentSet = new Set<String>();
		Map<Id, String> claim_NumberBydailyId = new Map<Id, String>();
		Map<String, Claim_Information__c> claimByClaim_Number = new Map<String, Claim_Information__c>();
		List<Claim_Information__c> originalClaim_InformationList; //Original Claim List before transaction is committed to DB
		List<Claim_Information__c> existingClaim_InformationList;//Existing Claim List before transaction is committed to DB
		List<Claim_Information__c> allClaim_InformationList = new List<Claim_Information__c>(); //All Claim List before transaction is committed to DB

		//Set<String> sha1Hash_Id = new Set<String>();
		Contact existingContact;

		// Contact Factory helps domain classes produce Contacts
		//ContactsService.ContactFactory contactFactory = new ContactsService.ContactFactory(uow);
		//TODO: Get matching contacts from Daily Claims
		//ContactsSelector contactsSelector = (ContactsSelector)PMd_Application.Selector.newInstance(Contact.SObjectType);

		//List<Contact> existingContacts = contactsSelector.selectBySHA1Hash_ID(sha1Hash_Id);
		//List<Contact> existingContacts = getContacts(); //Get list of existing contacts passed in at the instantiation of the this Domain class
		//System.debug('existingContacts Count: ' + existingContacts.size());

		//Map<Id, Contact> existingContactsByDailyClaimId = mapContactsByDailyClaimId(existingContacts, dailyClaimsList);
		Map<Id, Contact> existingContactsByDailyClaimId = getExistingContactsByDailyClaimId(dailyClaimsList);
		System.debug('In Contacts:process - existingContactsByDailyClaimId Count = ' + existingContactsByDailyClaimId.size());

		System.debug('dailyClaimsList Count: ' + dailyClaimsList.size());
		//Get csaByDailyClaimId to get Contact's Account
		for(Daily_Claim__c dailyClaimRecord : dailyClaimsList){
			//J_Code_IdSet.add(dailyClaimRecord.HCPCS_Code__c);
			//dailyClaimIdByCSANumber.put(dailyClaimRecord.CSA_Number__c, dailyClaimRecord.Id);
			//csaNumberByDailyClaimId.put(dailyClaimRecord.Id, dailyClaimRecord.CSA_Number__c);
			System.debug('dailyClaimRecord.Id = ' + dailyClaimRecord.Id);
			System.debug('dailyClaimRecord.CSA_Control__c = ' + dailyClaimRecord.CSA_Control__c);
			System.debug('dailyClaimRecord.CSA_Suffix__c = ' + dailyClaimRecord.CSA_Suffix__c);
			System.debug('dailyClaimRecord.CSA_Account__c = ' + dailyClaimRecord.CSA_Account__c);
			System.debug('dailyClaimRecord.CSA_Number__c = ' + dailyClaimRecord.CSA_Number__c);
			//get all Daily Claim Contact matching Sha1Had_Ids
			/*
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					dailyClaimRecord.Patient_CUMB_ID__c
							+ dailyClaimRecord.Patient_Birth_Date__c
							+ dailyClaimRecord.Patient_First_Name__c
							+ dailyClaimRecord.Patient_Last_Name__c
			);
			*/
			//contactSHA1HashIdSet.add(sha1Hash_Id);


			//Get all Daily_Claim Primary_Claim_Numbers
			//Get all Daily_Claim claim_Segments
			//Get all Daily_Claim Claim_Lines
			//Get all Daily_Claim  previous_Segments
			System.debug('dailyClaim.Primary_Claim_Number__c = ' +dailyClaimRecord.Primary_Claim_Number__c);
			System.debug('dailyClaim.Claim_Segment__c = ' + dailyClaimRecord.Claim_Segment__c);

			primary_Claim_NumberSet.add(dailyClaimRecord.Primary_Claim_Number__c);
			claim_SegmentSet.add(dailyClaimRecord.Claim_Segment__c);
			claim_LineSet.add(dailyClaimRecord.Claim_Line__c);
			previous_SegmentSet.add(dailyClaimRecord.Previous_Segment__c);
			/*
			if(dailyClaimRecord.Previous_Segment__c == null || dailyClaimRecord.Previous_Segment__c == '') {
				claim_NumberSeed = dailyClaim.Primary_Claim_Number__c +
						dailyClaim.Claim_Segment__c +
						dailyClaim.Claim_Line__c;
			} else {
				claim_NumberSeed = dailyClaim.Primary_Claim_Number__c +
						dailyClaim.Previous_Segment__c +
						dailyClaim.Claim_Line__c;
			}

			String claim_NumberHashCode =  SHA1UtilService.getBase64SHA1Hash(claim_NumberSeed);
			claim_NumberBydailyId.put(dailyClaimRecord.Id, claim_NumberHashCode);
			*/
		}

		/*
		//Get Map of CSAs By CSA_Number
		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		//csaByDailyClaimId = cSAsDomain.getCSAsById(dailyClaimIdByCSANumber);
		csasByCSA_Number = cSAsDomain.getCSAsByCSANumber(csaNumberByDailyClaimId);
		System.debug('csasByCSA_Number = ' +csasByCSA_Number);
		 */
		System.debug('claim_NumberBydailyId = ' +claim_NumberBydailyId);


		//Get matching existing Claims from Daily Claims
		Claim_InformationsSelector claim_InformationsSelector = (Claim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);
		originalClaim_InformationList = claim_InformationsSelector.selectOriginalClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet);
		existingClaim_InformationList = claim_InformationsSelector.selectExistingClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet, Previous_SegmentSet);
		allClaim_InformationList.addAll(originalClaim_InformationList);
		allClaim_InformationList.addAll(existingClaim_InformationList);
		System.debug('originalClaim_InformationList Count: ' + originalClaim_InformationList.size());
		System.debug('existingClaim_InformationList Count: ' + existingClaim_InformationList.size());
		System.debug('allClaim_InformationList Count: ' + allClaim_InformationList.size());
		/*
		If Claim does exist, then update Contact.
		If Claim does not exist, then look for Contact key in linked document above. Combination of:
			Subscriber CUMB ID
			Patient Birth Date
			Patient Last Name
			Patient First Name
		*/
		for (Claim_Information__c claimRecord : allClaim_InformationList) {
			claimByClaim_Number.put(claimRecord.Claim_Number__c, claimRecord);
		}
		System.debug('claimByClaim_Number = ' + claimByClaim_Number);

		for(Daily_Claim__c dailyClaim : dailyClaimsList) {
			/*
		o	If Contact does not exists based on logic above:
				Pre go-live (based on a query to the CSA object)
				•	Then create Contact, ContactDrug, Claim, and Enrollment Case.
				Post go-live (based on a query to the CSA object)
				•	Then create Contact, ContactDrug, Claim, Enrollment Case, and Reimbursement Case.
			*/
			CSA__c csaRecord = csasByCSA_Number.get(dailyClaim.CSA_Number__c);
			System.debug('csaByDailyClaimId = ' +csaByDailyClaimId);
			System.debug('dailyClaim.Id = ' + dailyClaim.Id);
			System.debug('dailyClaim.CSA_Control__c = ' + dailyClaim.CSA_Control__c);
			System.debug('dailyClaim.CSA_Suffix__c = ' + dailyClaim.CSA_Suffix__c);
			System.debug('dailyClaim.CSA_Account__c = ' + dailyClaim.CSA_Account__c);
			System.debug('dailyClaim.CSA_Number__c = ' + dailyClaim.CSA_Number__c);
			System.debug('csaRecord = ' + csaRecord);
			existingContact = existingContactsByDailyClaimId.get(dailyClaim.Id);
			System.debug('existingContact = ' + existingContact);

			System.debug('claim_NumberBydailyId.get(dailyClaim.Id) = ' + claim_NumberBydailyId.get(dailyClaim.Id));
			System.debug('claimByClaim_Number = ' + claimByClaim_Number);
			Claim_Information__c claimRecord = claimByClaim_Number.get(claim_NumberBydailyId.get(dailyClaim.Id));

			if(existingContact != null && claimRecord == null) {
				System.debug('Update Existing Contact from Daily Claim');
				existingContact = mapDailyClaimToContact(dailyClaim, existingContact);
				existingContact.AccountId = csaRecord.Account__c;
				existingContact.CSA__c = csaRecord.Id;
				existingContactsList.add(existingContact);
				System.debug('existingContact = ' + existingContact);
			} else {
				//Create new Contact fom Daily Claim
				System.debug('Create new Contact from Daily Claim');
				Contact newContact = new Contact();
				newContact = mapDailyClaimToContact(dailyClaim, newContact);
				newContact.AccountId = csaRecord.Account__c;
				newContact.CSA__c = csaRecord.Id;
				newContactsList.add(newContact);
				existingContactsByDailyClaimId.put(dailyClaim.Id, newContact);
				System.debug('newContact = ' + newContact);
			}
		}

		System.debug('existingContactsList Count: ' + existingContactsList.size());
		System.debug('newContactsList Count: ' + newContactsList.size());


		uow.registerDirty(existingContactsList);
		uow.registerNew(newContactsList);

		System.debug('In Contacts:process - Stop processing Contacts for Daily Claims');

		return existingContactsByDailyClaimId;
	}

	/*
	Contact processing logic:
		Look for an existing member based on Matching Logic here.
		If Contact does not exists based on logic above:
			Then create Contact
		If Contact does exist based on logic above:
			Then update Contact (refer to mapping document for fields), then check ContactDrug processing logic.
	 */
/*
	public class Constructor implements fflib_IDomainConstructor{
		public fflib_SObjects construct(List<Object> objectList){
			return new Contacts((List<SObject>) objectList);
		}
	}
*/
	/*
	Contact processing logic:
		Look for an existing member based on Matching Logic here.
		If Contact does not exists based on logic above:
			Then create Contact
		If Contact does exist based on logic above:
			Then update Contact (refer to mapping document for fields), then check ContactDrug processing logic.
	 */
	public Map<Id, Contact> process(List<Historical_Claim__c> historicalClaimsList, fflib_ISObjectUnitOfWork uow)
	{
		System.debug('In Contacts:process - Start processing Contacts for Historical Claims');

		// Create Contacts from the given Historical Claims
		List<SObject> newContactsList = new List<SObject>();
		List<SObject> existingContactsList = new List<SObject>();
		Map<Id, CSA__c> csaByHistoricalClaimId = new Map<Id, CSA__c>();
		Map<Id, String> csaNumberByHistoricalClaimId = new Map<Id, String>();
		Map<String, Id> historicalClaimIdByCSANumber = new Map<String, Id>();
		Map<String, CSA__c> csasByCSA_Number = new Map<String, CSA__c>();
		//Set<String> sha1Hash_Id = new Set<String>();
		Contact existingContact;

		// Contact Factory helps domain classes produce Contacts
		//ContactsService.ContactFactory contactFactory = new ContactsService.ContactFactory(uow);
		//TODO: Get matching contacts from Historical Claims
		//ContactsSelector contactsSelector = (ContactsSelector)PMd_Application.Selector.newInstance(Contact.SObjectType);

		//List<Contact> existingContacts = contactsSelector.selectBySHA1Hash_ID(sha1Hash_Id);
		//List<Contact> existingContacts = getContacts(); //Get list of existing contacts passed in at the instantiation of the this Domain class
		//System.debug('existingContacts Count: ' + existingContacts.size());

		//Get map of existing Contacts by Historical Claim Id
		//Map<Id, Contact> existingContactsByHistoricalClaimId = mapContactsByHistoricalClaimId(existingContacts, historicalClaimsList);
		Map<Id, Contact> existingContactsByHistoricalClaimId = getExistingContactsByHistoricalClaimId(historicalClaimsList);
		System.debug('existingContactsByHistoricalClaimId Count: ' + existingContactsByHistoricalClaimId.size());
		System.debug('existingContactsByHistoricalClaimId = ' + existingContactsByHistoricalClaimId);

		//Get csaByHistoricalClaimId to get Contact's Account
		for(Historical_Claim__c historicalClaimRecord : historicalClaimsList){
			//J_Code_IdSet.add(historicalClaimRecord.HCPCS_Code__c);
			//historicalClaimIdByCSANumber.put(historicalClaimRecord.CSA_Number__c, historicalClaimRecord.Id);
			csaNumberByHistoricalClaimId.put(historicalClaimRecord.Id, historicalClaimRecord.CSA_Number__c);
			//get all Historical Claim Contact matching Sha1Had_Ids
			/*
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					historicalClaimRecord.Patient_CUMB_ID__c
							+ historicalClaimRecord.Patient_Birth_Date__c
							+ historicalClaimRecord.Patient_First_Name__c
							+ historicalClaimRecord.Patient_Last_Name__c
			);
			*/
			//contactSHA1HashIdSet.add(sha1Hash_Id);
		}

		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		//csaByHistoricalClaimId = cSAsDomain.getCSAsById(historicalClaimIdByCSANumber);
		csasByCSA_Number = cSAsDomain.getCSAsByCSANumber(csaNumberByHistoricalClaimId);

		for(Historical_Claim__c historicalClaim : historicalClaimsList) {

			//CSA__c csaRecord = csaByHistoricalClaimId.get(historicalClaim.Id);
			CSA__c csaRecord = csasByCSA_Number.get(historicalClaim.CSA_Number__c);
			existingContact = existingContactsByHistoricalClaimId.get(historicalClaim.Id);
			System.debug('existingContact = ' + existingContact);

			if(existingContact != null) {
				//update existing Contact found
				existingContact = mapHistoricalClaimToContact(historicalClaim, existingContact);
				existingContact.AccountId = csaRecord.Account__c;
				existingContact.CSA__c = csaRecord.Id;
				existingContactsList.add(existingContact);
				System.debug('existingContact = ' + existingContact);
			} else {
				//Create new Contact from Historical Claim
				Contact newContact = new Contact();
				newContact = mapHistoricalClaimToContact(historicalClaim, newContact);
				newContact.AccountId = csaRecord.Account__c;
				newContact.CSA__c = csaRecord.Id;
				newContactsList.add(newContact);
				existingContactsByHistoricalClaimId.put(historicalClaim.Id, newContact);
				System.debug('newContact = ' + newContact);
			}
		}

		System.debug('existingContactsList Count: ' + existingContactsList.size());
		System.debug('newContactsList Count: ' + newContactsList.size());

		uow.registerDirty(existingContactsList);
		uow.registerNew(newContactsList);

		System.debug('existingContactsByHistoricalClaimId = ' + existingContactsByHistoricalClaimId);

		System.debug('In Contacts:process - Stop processing Contacts for Historical Claims');

		return existingContactsByHistoricalClaimId;
	}

	/*
	Contact processing logic:
		Look for an existing member based on Matching Logic here.
		If Contact does not exists based on logic above:
			Then create Contact
		If Contact does exist based on logic above:
			Then update Contact (refer to mapping document for fields), then check ContactDrug processing logic.
	*/
	public Map<Id, Contact> process(List<Prior_Auth__c> priorAuthsList, fflib_ISObjectUnitOfWork uow)
	{
		System.debug('In Contacts:process - Start processing Contacts for Prior Auth');

		// Create Contacts from the given Prior_Auths
		List<SObject> newContactsList = new List<SObject>();
		List<SObject> existingContactsList = new List<SObject>();
		//Map<Id, CSA__c> csaByPriorAuthId = new Map<Id, CSA__c>();
		Map<Id, String> csaNumberByPriorAuthId = new Map<Id, String>();
		Map<String, Id> priorAuthIdByCSANumber = new Map<String, Id>();
		Map<String, CSA__c> csasByCSA_Number = new Map<String, CSA__c>();
		//Set<String> sha1Hash_Id = new Set<String>();
		Contact existingContact;

		// Contact Factory helps domain classes produce Contacts
		//ContactsService.ContactFactory contactFactory = new ContactsService.ContactFactory(uow);
		//Get matching contacts from Prior_Auths
		//ContactsSelector contactsSelector = (ContactsSelector)PMd_Application.Selector.newInstance(Contact.SObjectType);

		//List<Contact> existingContacts = contactsSelector.selectBySHA1Hash_ID(sha1Hash_Id);
		//List<Contact> existingContacts = getContacts(); //Get list of existing contacts passed in at the instantiation of the this Domain class
		//System.debug('existingContacts Count: ' + existingContacts.size());

		//Get map of existing Contacts by Prior_Auth Id
		//Map<Id, Contact> existingContactsByPriorAuthId = mapContactsByPriorAuthId(existingContacts, priorAuthsList);
		Map<Id, Contact> existingContactsByPriorAuthId = getExistingContactsByPriorAuthId(priorAuthsList);
		System.debug('existingContactsByPriorAuthId Count: ' + existingContactsByPriorAuthId.size());

		//Get csaByPriorAuthId to get Contact's Account
		for(Prior_Auth__c priorAuthRecord : priorAuthsList){
			//J_Code_IdSet.add(priorAuthRecord.HCPCS_Code__c);
			//priorAuthIdByCSANumber.put(priorAuthRecord.CSA_Number__c, priorAuthRecord.Id);
			csaNumberByPriorAuthId.put(priorAuthRecord.Id, priorAuthRecord.CSA_Number__c);
			//get all Daily Claim Contact matching Sha1Had_Ids
			/*
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					priorAuthRecord.Patient_CUMB_ID__c
							+ priorAuthRecord.Patient_Birth_Date__c
							+ priorAuthRecord.Patient_First_Name__c
							+ priorAuthRecord.Patient_Last_Name__c
			);
			*/
			//contactSHA1HashIdSet.add(sha1Hash_Id);
		}

		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		//csaByPriorAuthId = cSAsDomain.getCSAsById(priorAuthIdByCSANumber);
		csasByCSA_Number = cSAsDomain.getCSAsByCSANumber(csaNumberByPriorAuthId);

		for(Prior_Auth__c priorAuth : priorAuthsList) {
			/*
		o	If Contact does not exists based on logic above:
				Pre go-live (based on a query to the CSA object)
				•	Then create Contact, ContactDrug, Claim, and Enrollment Case.
				Post go-live (based on a query to the CSA object)f
				•	Then create Contact, ContactDrug, Claim, Enrollment Case, and Reimbursement Case.
			*/
			//CSA__c csaRecord = csaByPriorAuthId.get(priorAuth.Id);
			CSA__c csaRecord = csasByCSA_Number.get(priorAuth.CSA_Number__c);
			existingContact = existingContactsByPriorAuthId.get(priorAuth.Id);
			System.debug('existingContact = ' + existingContact);
			if(existingContact != null) {
				//update existing Contact found
				existingContact = mapPriorAuthToContact(priorAuth, existingContact);
				existingContact.AccountId = csaRecord.Account__c;
				existingContact.CSA__c = csaRecord.Id;
				existingContactsList.add(existingContact);
			} else {
				//Create new Contact from Prior Auth
				Contact newContact = new Contact();
				newContact = mapPriorAuthToContact(priorAuth, newContact);
				newContact.AccountId = csaRecord.Account__c;
				newContact.CSA__c = csaRecord.Id;
				newContactsList.add(newContact);
			}
		}

		System.debug('existingContactsList Count: ' + existingContactsList.size());
		System.debug('newContactsList Count: ' + newContactsList.size());

		uow.registerDirty(existingContactsList);
		uow.registerNew(newContactsList);

		System.debug('In Contacts:process - Stop processing Contacts for Prior Auth');

		return existingContactsByPriorAuthId;
	}

	/*
Contact processing logic:
    Look for an existing member based on Matching Logic here.
    If Contact does not exists based on logic above:
        Then create Contact
    If Contact does exist based on logic above:
        Then update Contact (refer to mapping document for fields), then check ContactDrug processing logic.
*/
	public Map<Id, Contact> process(List<Historical_Prior_Auth__c> historicalPriorAuthsList, fflib_ISObjectUnitOfWork uow)
	{
		System.debug('In Contacts:process - Start processing Contacts for Historical Prior Auth');

		// Create Contacts from the given Historical Prior Auth
		List<SObject> newContactsList = new List<SObject>();
		List<SObject> existingContactsList = new List<SObject>();
		//Map<Id, CSA__c> csaByHistoricalPriorAuthId = new Map<Id, CSA__c>();
		Map<Id, String> csaNumberByHistoricalPriorAuthId = new Map<Id, String>();
		Map<String, Id> historicalPriorAuthIdByCSANumber = new Map<String, Id>();
		Map<String, CSA__c> csasByCSA_Number = new Map<String, CSA__c>();
		//Set<String> sha1Hash_Id = new Set<String>();
		Contact existingContact;

		// Contact Factory helps domain classes produce Contacts
		//ContactsService.ContactFactory contactFactory = new ContactsService.ContactFactory(uow);
		//Get matching contacts from Historical_Prior_Auths
		//ContactsSelector contactsSelector = (ContactsSelector)PMd_Application.Selector.newInstance(Contact.SObjectType);

		//List<Contact> existingContacts = contactsSelector.selectBySHA1Hash_ID(sha1Hash_Id);
		//List<Contact> existingContacts = getContacts(); //Get list of existing contacts passed in at the instantiation of the this Domain class
		//System.debug('existingContacts Count: ' + existingContacts.size());

		//Get map of existing Contacts by Historical_Prior_Auths Id
		//Map<Id, Contact> existingContactsByPriorAuthId = mapContactsByPriorAuthId(existingContacts, priorAuthsList);
		Map<Id, Contact> existingContactsByHistoricalPriorAuthId = getExistingContactsByHistoricalPriorAuthId(historicalPriorAuthsList);
		System.debug('existingContactsByHistoricalPriorAuthId Count: ' + existingContactsByHistoricalPriorAuthId.size());

		//Get csaByPriorAuthId to get Contact's Account
		for(Historical_Prior_Auth__c historicalpriorAuthRecord : historicalPriorAuthsList){
			//J_Code_IdSet.add(priorAuthRecord.HCPCS_Code__c);
			//historicalPriorAuthIdByCSANumber.put(historicalpriorAuthRecord.CSA_Number__c, historicalpriorAuthRecord.Id);
			csaNumberByHistoricalPriorAuthId.put(historicalpriorAuthRecord.Id, historicalpriorAuthRecord.CSA_Number__c);
			//get all Daily Claim Contact matching Sha1Had_Ids
			/*
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					priorAuthRecord.Patient_CUMB_ID__c
							+ priorAuthRecord.Patient_Birth_Date__c
							+ priorAuthRecord.Patient_First_Name__c
							+ priorAuthRecord.Patient_Last_Name__c
			);
			*/
			//contactSHA1HashIdSet.add(sha1Hash_Id);
		}

		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		//csaByHistoricalPriorAuthId = cSAsDomain.getCSAsById(historicalPriorAuthIdByCSANumber);
		csasByCSA_Number = cSAsDomain.getCSAsByCSANumber(csaNumberByHistoricalPriorAuthId);

		for(Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthsList) {
			/*
		o	If Contact does not exists based on logic above:
				Pre go-live (based on a query to the CSA object)
				•	Then create Contact, ContactDrug, Claim, and Enrollment Case.
				Post go-live (based on a query to the CSA object)
				•	Then create Contact, ContactDrug, Claim, Enrollment Case, and Reimbursement Case.
			*/
			//CSA__c csaRecord = csaByHistoricalPriorAuthId.get(historicalPriorAuth.Id);
			existingContact = existingContactsByHistoricalPriorAuthId.get(historicalPriorAuth.Id);
			CSA__c csaRecord = csasByCSA_Number.get(historicalPriorAuth.CSA_Number__c);
			System.debug('existingContact ' + existingContact);
			if(existingContact != null) {
				existingContact = mapHistoricalPriorAuthToContact(historicalPriorAuth, existingContact);
				existingContact.AccountId = csaRecord.Account__c;
				existingContact.CSA__c = csaRecord.Id;
				existingContactsList.add(existingContact);
			} else {
				//Create new Contact from Prior Auth
				Contact newContact = new Contact();
				newContact = mapHistoricalPriorAuthToContact(historicalPriorAuth, newContact);
				newContact.AccountId = csaRecord.Account__c;
				newContact.CSA__c = csaRecord.Id;
				newContactsList.add(newContact);
			}
		}

		System.debug('existingContactsList Count: ' + existingContactsList.size());
		System.debug('newContactsList Count: ' + newContactsList.size());

		uow.registerDirty(existingContactsList);
		uow.registerNew(newContactsList);

		System.debug('In Contacts:process - Stop processing Contacts for Historical Prior Auth');

		return existingContactsByHistoricalPriorAuthId;
	}

	//Look for an existing member based on Matching Logic here.
	public Map<Id, Contact> getExistingContactsByDailyClaimId(List<Daily_Claim__c> dailyClaimsList) {

		Set<Id> DailyClaimsRecordIds = new Set<Id>();
		Set<Id> existingContactRecordIds = new Set<Id>();
		String sha1Hash_Id;
		Set<String> sha1Hash_IdSet = new Set<String>();
		Map<Id, String> sha1Hash_IdByDailyClaimId = new Map<Id, String>();
		Map<Id, String> patientCUMBIdByDailyClaimId = new Map<Id, String>();
		Map<Id, String> patientCUMBIdBDByDailyClaimId = new Map<Id, String>();
		List<Claim_Information__c> existingClaim_InformationsList;
		List<Contact> existingClaim_InformationContactsList;
		Set<String> primary_Claim_NumberSet = new Set<String>();
		List<Contact> existingSha1Hash_IdMatchedContactsList;
		List<Contact> existingPatientCUMBIdMatchedContactsList;
		List<Contact> existingPatientCUMBIdBDMatchedContactsList;
		Map<Id, Contact> existingContactsById = new Map<Id, Contact>();
		Map<Id, Contact> existingContactsByDailyClaimsId = new Map<Id, Contact>();
		Set<String> patientCUMBIdSet = new Set<String>();
		Set<Date> patientBDSet = new Set<Date>();

		sha1Hash_IdByDailyClaimId = getSha1Hash_IdByDailyClaimId(dailyClaimsList);

		for (Daily_Claim__c dailyClaim : dailyClaimsList) {
			//get all Daily Claim sah1Hash_Ids that will match existing Contacts
			//get all Daily Claim Contact matching Sha1Had_Ids
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					dailyClaim.Patient_CUMB_ID__c + '-'
							+ dailyClaim.Patient_Birth_Date__c + '-'
							+ dailyClaim.Patient_First_Name__c + '-'
							+ dailyClaim.Patient_Last_Name__c
			);
			sha1Hash_IdSet.add(sha1Hash_Id);
			System.debug('dailyClaim.Patient_CUMB_ID__c = : ' + dailyClaim.Patient_CUMB_ID__c);
			System.debug('dailyClaim.Patient_Birth_Date__c = : ' + dailyClaim.Patient_Birth_Date__c);
			System.debug('dailyClaim.Patient_First_Name__c : ' + dailyClaim.Patient_First_Name__c);
			System.debug('dailyClaim.Patient_Last_Name__c : ' + dailyClaim.Patient_Last_Name__c);
			System.debug('Existing Contacts sha1Hash_Id = : ' + sha1Hash_Id);
			//get all Daily Claim Primary_Claim_Number__c that will match Claim Primary_Claim_Number__c
			primary_Claim_NumberSet.add(dailyClaim.Primary_Claim_Number__c);
			sha1Hash_IdByDailyClaimId.put(dailyClaim.Id, sha1Hash_Id); //Match Contacts based on Patient_CUMB_ID__c, Patient_Birth_Date__c, Patient_First_Name__c, Patient_Last_Name__c
			patientCUMBIdByDailyClaimId.put(dailyClaim.Id, dailyClaim.Patient_CUMB_ID__c);
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					dailyClaim.Patient_CUMB_ID__c + '-'
							+ dailyClaim.Patient_Birth_Date__c
			);
			patientCUMBIdSet.add(dailyClaim.Patient_CUMB_ID__c);
			patientBDSet.add(dailyClaim.Patient_Birth_Date__c);
			System.debug('dailyClaim.Patient_CUMB_ID__c = ' + dailyClaim.Patient_CUMB_ID__c);
			System.debug('dailyClaim.Patient_Birth_Date__c = ' + dailyClaim.Patient_Birth_Date__c);
			patientCUMBIdBDByDailyClaimId.put(dailyClaim.Id, sha1Hash_Id); //Match Contacts based on Patient_CUMB_ID__c, Patient_Birth_Date__c
			System.debug('patientCUMBIdBDByDailyClaimId = ' + patientCUMBIdBDByDailyClaimId);
			System.debug('dailyClaim.Primary_Claim_Number__c = ' + dailyClaim.Primary_Claim_Number__c);
			System.debug('dailyClaim sha1Hash_Id = ' + sha1Hash_Id);
		}

		//Get matching existing Claim Contacts from Daily Claims
		Claim_InformationsSelector claimInformationSelector = (Claim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);
		existingClaim_InformationsList = claimInformationSelector.selectByPrimary_Claim_Number(primary_Claim_NumberSet);
		System.debug('existingClaim_InformationsList Count: ' + existingClaim_InformationsList.size());

		//Get matching existing Contacts from Daily Claims
		ContactsSelector contactsSelector = (ContactsSelector) PMd_Application.Selector.newInstance(Contact.SObjectType);
		existingSha1Hash_IdMatchedContactsList = contactsSelector.selectBySHA1Hash_ID(sha1Hash_IdSet); //Match Contacts with: Patient_CUMB_ID__c, Patient_Birth_Date__c, Patient_First_Name__c, Patient_Last_Name__c
		//existingPatientCUMBIdMatchedContactsList = contactsSelector.selectByPatientCUMBId(patientCUMBIdByDailyClaimId.values()); //Match Contacts with: Patient_CUMB_ID__c
		existingPatientCUMBIdBDMatchedContactsList = contactsSelector.selectByCumbIdBd(patientCUMBIdSet, patientBDSet);
		System.debug('existingSha1Hash_IdMatchedContactsList Count: ' + existingSha1Hash_IdMatchedContactsList.size());
		//System.debug('existingPatientCUMBIdMatchedContactsList Count: ' + existingPatientCUMBIdMatchedContactsList.size());
		System.debug('existingPatientCUMBIdBDMatchedContactsList Count: ' + existingPatientCUMBIdBDMatchedContactsList.size());

		Map<String, Id> dailyClaimIdByClaim_InformationId = new Map<String, Id>();
		Map<String, Id> dailyClaimIdByContactSha1Hash_Id = new Map<String, Id>();
		Map<String, Id> dailyClaimIdByPatientCUMBId  = new Map<String, Id>();
		Map<String, Id> dailyClaimIdByPatientCUMBIdBDSha1Hash_Id  = new Map<String, Id>();
		//Map priorAuthIdByClaim_InformationId & priorAuthIdByContactSha1Hash_Id
		for (Daily_Claim__c dailyClaim : dailyClaimsList) {
			if(dailyClaim.Primary_Claim_Number__c != null) {
				dailyClaimIdByClaim_InformationId.put(dailyClaim.Primary_Claim_Number__c, dailyClaim.Id);
				System.debug('Claim_InformationId => dailyClaim = ' + dailyClaimIdByClaim_InformationId);
			}
			String contactsha1Hash_Id = sha1Hash_IdByDailyClaimId.get(dailyClaim.Id);
			if(contactsha1Hash_Id != null) {
				dailyClaimIdByContactSha1Hash_Id.put(contactsha1Hash_Id, dailyClaim.Id);
				System.debug('ContactSha1Hash_Id => dailyClaim = ' + dailyClaimIdByContactSha1Hash_Id);
			}
			String contactPatientCUMBId = patientCUMBIdByDailyClaimId.get(dailyClaim.Id);
			if(contactPatientCUMBId != null) {
				dailyClaimIdByPatientCUMBId.put(contactPatientCUMBId, dailyClaim.Id);
				System.debug('contactPatientCUMBId => dailyClaim = ' + dailyClaimIdByPatientCUMBId);
			}
			String contactPatientCUMBIdBDSha1Hash_Id = patientCUMBIdBDByDailyClaimId.get(dailyClaim.Id);
			if(contactPatientCUMBIdBDSha1Hash_Id != null) {
				dailyClaimIdByPatientCUMBIdBDSha1Hash_Id.put(contactPatientCUMBIdBDSha1Hash_Id, dailyClaim.Id);
				System.debug('contactPatientCUMBIdBD => dailyClaim = ' + dailyClaimIdByPatientCUMBIdBDSha1Hash_Id);
			}
		}

		for(Claim_Information__c existingClaim_Information : existingClaim_InformationsList) {
			System.debug('existingClaim_Information = ' + existingClaim_Information);
			if(existingClaim_Information.Contact__c != null) {
				existingContactsById.put(existingClaim_Information.Contact__c, new Contact(Id = existingClaim_Information.Contact__c));
				System.debug('ContactId => existingContacts = ' + existingContactsById);
			}
			Id dailyCliamId = dailyClaimIdByClaim_InformationId.get(existingClaim_Information.Primary_Claim_Number__c);
			if(dailyCliamId != null && existingClaim_Information.Contact__c != null) {
				existingContactsByDailyClaimsId.put(dailyCliamId, new Contact(Id = existingClaim_Information.Contact__c));
				System.debug('existingContact => dailyCliamId = ' + existingContactsByDailyClaimsId);
			}
		}

		for(Contact existingSha1Hash_IdMatchedContact : existingSha1Hash_IdMatchedContactsList) {
			//existingContactsById.put(existingSha1Hash_IdMatchedContact.Id, existingSha1Hash_IdMatchedContact);
			String contactSha1Hash_Id = existingSha1Hash_IdMatchedContact.SHA1Hash_ID__c;
			Id dailyClaimId = dailyClaimIdByContactSha1Hash_Id.get(contactSha1Hash_Id);
			If (dailyClaimId != null && existingSha1Hash_IdMatchedContact != null) {
				existingContactsByDailyClaimsId.put(dailyClaimId, existingSha1Hash_IdMatchedContact);
				System.debug('existingContact => dailyClaimId = ' + existingContactsByDailyClaimsId);
			}
		}
/*
		for(Contact existingPatientCUMBIdMatchedContact : existingPatientCUMBIdMatchedContactsList) {
			//existingContactsById.put(existingSha1Hash_IdMatchedContact.Id, existingSha1Hash_IdMatchedContact);
			String contactPatientCUMBId = existingPatientCUMBIdMatchedContact.Patient_CUMB_ID__c;
			Id dailyClaimId = dailyClaimIdByPatientCUMBId.get(contactPatientCUMBId);
			If (dailyClaimId != null && existingPatientCUMBIdMatchedContact != null) {
				existingContactsByDailyClaimsId.put(dailyClaimId, existingPatientCUMBIdMatchedContact);
				System.debug('existingContact => dailyClaimId = ' + existingContactsByDailyClaimsId);
			}
		}
*/
		for(Contact existingPatientCUMBIdBDMatchedContact : existingPatientCUMBIdBDMatchedContactsList) {
			//existingContactsById.put(existingSha1Hash_IdMatchedContact.Id, existingSha1Hash_IdMatchedContact);
			String contactPatientCUMBId = existingPatientCUMBIdBDMatchedContact.Patient_CUMB_ID__c;
			Date contactPatientBD = existingPatientCUMBIdBDMatchedContact.Patient_Birth_Date__c;
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					contactPatientCUMBId + '-'
							+ contactPatientBD
			);
			Id dailyClaimId = dailyClaimIdByPatientCUMBIdBDSha1Hash_Id.get(sha1Hash_Id);
			If (dailyClaimId != null && existingPatientCUMBIdBDMatchedContact != null) {
				existingContactsByDailyClaimsId.put(dailyClaimId, existingPatientCUMBIdBDMatchedContact);
				System.debug('existingContact => dailyClaimId = ' + existingContactsByDailyClaimsId);
			}
		}

		System.debug('existingContactsByDailyClaimsId = ' + existingContactsByDailyClaimsId);
		System.debug('Existing Contacts Count: ' + existingContactsByDailyClaimsId.values().size());
		return existingContactsByDailyClaimsId;
	}

	//Look for an existing member based on Matching Logic here.
	public Map<Id, Contact> getExistingContactsByHistoricalClaimId(List<Historical_Claim__c> HistoricalClaimsList) {

		Set<Id> historicalClaimsRecordIds = new Set<Id>();
		Set<Id> existingContactRecordIds = new Set<Id>();
		String sha1Hash_Id;
		Set<String> sha1Hash_IdSet = new Set<String>();
		Map<Id, String> sha1Hash_IdByHistoricalClaimId = new Map<Id, String>();
		Map<Id, String> patientCUMBIdByHistoricalClaimId = new Map<Id, String>();
		Map<Id, String> patientCUMBIdBDByHistoricalClaimId = new Map<Id, String>();
		List<Claim_Information__c> existingClaim_InformationsList;
		List<Contact> existingClaim_InformationContactsList;
		Set<String> primary_Claim_NumberSet = new Set<String>();
		List<Contact> existingSha1Hash_IdMatchedContactsList;
		List<Contact> existingPatientCUMBIdMatchedContactsList;
		List<Contact> existingPatientCUMBIdBDMatchedContactsList;
		Map<Id, Contact> existingContactsById = new Map<Id, Contact>();
		Map<Id, Contact> existingContactsByHistoricalClaimsId = new Map<Id, Contact>();
		Set<String> patientCUMBIdSet = new Set<String>();
		Set<Date> patientBDSet = new Set<Date>();

		/*
		o	Look for an existing member based on Matching Logic here.
				Look for existing Claim, based on claim key.
				•	Claim ID
					•	If Claim Previous Segment populated:
						o	Then Previous Segment
						o	Else Claim Segment
					•	Claim Line Identifier
					If Claim does exist, then update Contact.
		 */

		/*
			If Claim does not exist, then look for Contact key in linked document above. Combination of:
			•	Subscriber CUMB ID
			•	Patient Birth Date
			•	Patient Last Name
			•	Patient First Name
		 */
		sha1Hash_IdByHistoricalClaimId = getSha1Hash_IdByHistoricalClaimId(historicalClaimsList);

		for (Historical_Claim__c historicalClaim : historicalClaimsList) {

			//get all Historical Claim sah1Hash_Ids that will match existing Contacts
			//get all Historical Claim Contact matching Sha1Had_Ids
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					historicalClaim.Patient_CUMB_ID__c + '-'
							+ historicalClaim.Patient_Birth_Date__c + '-'
							+ historicalClaim.Patient_First_Name__c + '-'
							+ historicalClaim.Patient_Last_Name__c
			);
			sha1Hash_IdSet.add(sha1Hash_Id);
			System.debug('historicalClaim.Patient_CUMB_ID__c = : ' + historicalClaim.Patient_CUMB_ID__c);
			System.debug('historicalClaim.Patient_Birth_Date__c = : ' + historicalClaim.Patient_Birth_Date__c);
			System.debug('historicalClaim.Patient_First_Name__c : ' + historicalClaim.Patient_First_Name__c);
			System.debug('historicalClaim.Patient_Last_Name__c : ' + historicalClaim.Patient_Last_Name__c);
			System.debug('Existing Contacts sha1Hash_Id = : ' + sha1Hash_Id);
			//get all Historical Claim Primary_Claim_Number__c that will match Claim Primary_Claim_Number__c
			primary_Claim_NumberSet.add(historicalClaim.Primary_Claim_Number__c); //Match Contacts based on Patient_CUMB_ID__c, Patient_Birth_Date__c, Patient_First_Name__c, Patient_Last_Name__c
			sha1Hash_IdByHistoricalClaimId.put(historicalClaim.Id, sha1Hash_Id);
			patientCUMBIdByHistoricalClaimId.put(historicalClaim.Id, historicalClaim.Patient_CUMB_ID__c);
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					historicalClaim.Patient_CUMB_ID__c + '-'
							+ historicalClaim.Patient_Birth_Date__c
			);
			patientCUMBIdSet.add(historicalClaim.Patient_CUMB_ID__c);
			patientBDSet.add(historicalClaim.Patient_Birth_Date__c);
			System.debug('historicalClaim.Patient_CUMB_ID__c = ' + historicalClaim.Patient_CUMB_ID__c);
			System.debug('historicalClaim.Patient_Birth_Date__c = ' + historicalClaim.Patient_Birth_Date__c);
			patientCUMBIdBDByHistoricalClaimId.put(historicalClaim.Id, sha1Hash_Id); //Match Contacts based on Patient_CUMB_ID__c, Patient_Birth_Date__c
			System.debug('historicalClaim.Primary_Claim_Number__c ' + historicalClaim.Primary_Claim_Number__c);
		}

		//Get matching existing Claim Contacts from Historical Claims
		Claim_InformationsSelector claimInformationSelector = (Claim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);
		existingClaim_InformationsList = claimInformationSelector.selectByPrimary_Claim_Number(primary_Claim_NumberSet);
		System.debug('existingClaim_InformationsList Count: ' + existingClaim_InformationsList.size());

		//Get matching existing Contacts from Historical Claims
		ContactsSelector contactsSelector = (ContactsSelector) PMd_Application.Selector.newInstance(Contact.SObjectType);
		existingSha1Hash_IdMatchedContactsList = contactsSelector.selectBySHA1Hash_ID(sha1Hash_IdSet); //Match Contacts with: Patient_CUMB_ID__c, Patient_Birth_Date__c, Patient_First_Name__c, Patient_Last_Name__c
		//existingPatientCUMBIdMatchedContactsList = contactsSelector.selectByPatientCUMBId(patientCUMBIdByHistoricalClaimId.values());
		existingPatientCUMBIdBDMatchedContactsList = contactsSelector.selectByCumbIdBd(patientCUMBIdSet, patientBDSet);
		System.debug('existingSha1Hash_IdMatchedContactsList Count: ' + existingSha1Hash_IdMatchedContactsList.size());
		//System.debug('existingPatientCUMBIdMatchedContactsList Count: ' + existingPatientCUMBIdMatchedContactsList.size());
		System.debug('existingPatientCUMBIdBDMatchedContactsList Count: ' + existingPatientCUMBIdBDMatchedContactsList.size());

		Map<String, Id> historicalClaimIdByClaim_InformationId = new Map<String, Id>();
		Map<String, Id> historicalClaimIdByContactSha1Hash_Id = new Map<String, Id>();
		Map<String, Id> historicalClaimIdByPatientCUMBId = new Map<String, Id>();
		Map<String, Id> historicalClaimIdByPatientCUMBIdBDSha1Hash_Id  = new Map<String, Id>();
		//Map historicalClaimIdByClaim_InformationId & historicalClaimIdByContactSha1Hash_Id
		for (Historical_Claim__c historicalClaim : historicalClaimsList) {
			if(historicalClaim.Primary_Claim_Number__c != null) {
				historicalClaimIdByClaim_InformationId.put(historicalClaim.Primary_Claim_Number__c, historicalClaim.Id);
				System.debug('Claim_InformationId => historicalClaimId = ' + historicalClaimIdByClaim_InformationId);
			}
			String contactsha1Hash_Id = sha1Hash_IdByHistoricalClaimId.get(historicalClaim.Id);
			if(contactsha1Hash_Id != null) {
				historicalClaimIdByContactSha1Hash_Id.put(contactsha1Hash_Id, historicalClaim.Id);
				System.debug('ContactSha1Hash_Id => historicalClaimId = ' + historicalClaimIdByContactSha1Hash_Id);
			}
			String contactPatientCUMBId = patientCUMBIdByHistoricalClaimId.get(historicalClaim.Id);
			if(contactPatientCUMBId != null) {
				historicalClaimIdByPatientCUMBId.put(contactPatientCUMBId, historicalClaim.Id);
				System.debug('contactPatientCUMBId => historicalClaim = ' + historicalClaimIdByPatientCUMBId);
			}
			String contactPatientCUMBIdBDSha1Hash_Id = patientCUMBIdBDByHistoricalClaimId.get(historicalClaim.Id);
			if(contactPatientCUMBIdBDSha1Hash_Id != null) {
				historicalClaimIdByPatientCUMBIdBDSha1Hash_Id.put(contactPatientCUMBIdBDSha1Hash_Id, historicalClaim.Id);
				System.debug('contactPatientCUMBIdBD => historicalClaim = ' + historicalClaimIdByPatientCUMBIdBDSha1Hash_Id);
			}
		}

		for(Claim_Information__c existingClaim_Information : existingClaim_InformationsList) {
			System.debug('existingClaim_Information = ' + existingClaim_Information);
			if(existingClaim_Information.Contact__c != null) {
				existingContactsById.put(existingClaim_Information.Contact__c, new Contact(Id = existingClaim_Information.Contact__c));
				System.debug('ContactId => existingContacts = ' + existingContactsById);
			}
			Id historicalCliamId = historicalClaimIdByClaim_InformationId.get(existingClaim_Information.Id);
			if(historicalCliamId != null  && existingClaim_Information.Contact__c != null) {
				existingContactsByHistoricalClaimsId.put(historicalCliamId, new Contact(Id = existingClaim_Information.Contact__c));
				System.debug('existingContact => historicalCliamId = ' + existingContactsByHistoricalClaimsId);
			}
		}

		for(Contact existingSha1Hash_IdMatchedContact : existingSha1Hash_IdMatchedContactsList) {
			//existingContactsById.put(existingSha1Hash_IdMatchedContact.Id, existingSha1Hash_IdMatchedContact);
			String contactSha1Hash_Id = existingSha1Hash_IdMatchedContact.SHA1Hash_ID__c;
			Id historicalClaimId = historicalClaimIdByContactSha1Hash_Id.get(contactSha1Hash_Id);
			If (historicalClaimId != null && existingSha1Hash_IdMatchedContact != null) {
				existingContactsByHistoricalClaimsId.put(historicalClaimId, existingSha1Hash_IdMatchedContact);
				System.debug('existingContact => historicalCliamId = ' + existingContactsByHistoricalClaimsId);
			}
		}
/*
		for(Contact existingPatientCUMBIdMatchedContact : existingPatientCUMBIdMatchedContactsList) {
			//existingContactsById.put(existingSha1Hash_IdMatchedContact.Id, existingSha1Hash_IdMatchedContact);
			String contactPatientCUMBId = existingPatientCUMBIdMatchedContact.Patient_CUMB_ID__c;
			Id historicalClaimId = historicalClaimIdByPatientCUMBId.get(contactPatientCUMBId);
			If (historicalClaimId != null && existingPatientCUMBIdMatchedContact != null) {
				existingContactsByHistoricalClaimsId.put(historicalClaimId, existingPatientCUMBIdMatchedContact);
				System.debug('existingContact => historicalClaimId = ' + existingContactsByHistoricalClaimsId);
			}
		}
*/
		for(Contact existingPatientCUMBIdBDMatchedContact : existingPatientCUMBIdBDMatchedContactsList) {
			//existingContactsById.put(existingSha1Hash_IdMatchedContact.Id, existingSha1Hash_IdMatchedContact);
			String contactPatientCUMBId = existingPatientCUMBIdBDMatchedContact.Patient_CUMB_ID__c;
			Date contactPatientBD = existingPatientCUMBIdBDMatchedContact.Patient_Birth_Date__c;
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					contactPatientCUMBId + '-'
							+ contactPatientBD
			);
			Id historicalClaimId = historicalClaimIdByPatientCUMBIdBDSha1Hash_Id.get(sha1Hash_Id);
			If (historicalClaimId != null && existingPatientCUMBIdBDMatchedContact != null) {
				existingContactsByHistoricalClaimsId.put(historicalClaimId, existingPatientCUMBIdBDMatchedContact);
				System.debug('existingContact => historicalClaimId = ' + existingContactsByHistoricalClaimsId);
			}
		}

		System.debug('existingContactsByHistoricalClaimsId = ' + existingContactsByHistoricalClaimsId);
		System.debug('Existing Contacts Count: ' + existingContactsByHistoricalClaimsId.values().size());
		return existingContactsByHistoricalClaimsId;
	}

	//Look for an existing member based on Matching Logic here.
	public Map<Id, Contact> getExistingContactsByPriorAuthId(List<Prior_Auth__c> priorAuthList) {

		Set<Id> priorAuthsRecordIds = new Set<Id>();
		Set<Id> existingContactRecordIds = new Set<Id>();
		String sha1Hash_Id;
		Set<String> sha1Hash_IdSet = new Set<String>();
		Map<Id, String> sha1Hash_IdByPriorAuthId = new Map<Id, String>();
		Map<Id, String> patientCUMBIdByPriorAuthId = new Map<Id, String>();
		Map<Id, String> patientCUMBIdBDByPriorAuthId = new Map<Id, String>();
		List<Claim_Information__c> existingClaim_InformationsList;
		List<Contact> existingClaim_InformationContactsList;
		Set<String> primary_Claim_NumberSet = new Set<String>();
		List<Contact> existingSha1Hash_IdMatchedContactsList;
		List<Contact> existingPatientCUMBIdMatchedContactsList;
		List<Contact> existingPatientCUMBIdBDMatchedContactsList;
		Map<Id, Contact> existingContactsById = new Map<Id, Contact>();
		Map<Id, Contact> existingContactsByPriorAuthId = new Map<Id, Contact>();
		Set<String> patientCUMBIdSet = new Set<String>();
		Set<Date> patientBDSet = new Set<Date>();

		sha1Hash_IdByPriorAuthId = getSha1Hash_IdByPriorAuthId(priorAuthList);

		for (Prior_Auth__c priorAuth : priorAuthList) {

			//get all Prior_Aut sah1Hash_Ids that will match existing Contacts
			//get all Prior_Aut Contact matching Sha1Had_Ids
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					priorAuth.Patient_CUMB_ID__c + '-'
							+ priorAuth.Patient_Birth_Date__c + '-'
							+ priorAuth.Patient_First_Name__c + '-'
							+ priorAuth.Patient_Last_Name__c
			);
			sha1Hash_IdSet.add(sha1Hash_Id);
			System.debug('priorAuth.Patient_CUMB_ID__c = : ' + priorAuth.Patient_CUMB_ID__c);
			System.debug('priorAuth.Patient_Birth_Date__c = : ' + priorAuth.Patient_Birth_Date__c);
			System.debug('priorAuth.Patient_First_Name__c : ' + priorAuth.Patient_First_Name__c);
			System.debug('priorAuth.Patient_First_Name__c : ' + priorAuth.Patient_First_Name__c);
			System.debug('Existing Contacts sha1Hash_Id = : ' + sha1Hash_Id);
			//get all Daily Claim Primary_Claim_Number__c that will match Claim Primary_Claim_Number__c
			//primary_Claim_NumberSet.add(priorAuth.Primary_Claim_Number__c);
			sha1Hash_IdByPriorAuthId.put(priorAuth.Id, sha1Hash_Id); //Match Contacts based on Patient_CUMB_ID__c, Patient_Birth_Date__c, Patient_First_Name__c, Patient_Last_Name__c
			patientCUMBIdByPriorAuthId.put(priorAuth.Id, priorAuth.Patient_CUMB_ID__c);
			//System.debug('priorAuth.Primary_Claim_Number__c ' + priorAuth.Primary_Claim_Number__c);
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					priorAuth.Patient_CUMB_ID__c + '-'
							+ priorAuth.Patient_Birth_Date__c
			);
			patientCUMBIdSet.add(priorAuth.Patient_CUMB_ID__c);
			patientBDSet.add(priorAuth.Patient_Birth_Date__c);
			System.debug('priorAuth.Patient_CUMB_ID__c = ' + priorAuth.Patient_CUMB_ID__c);
			System.debug('priorAuth.Patient_Birth_Date__c = ' + priorAuth.Patient_Birth_Date__c);
			patientCUMBIdBDByPriorAuthId.put(priorAuth.Id, sha1Hash_Id); //Match Contacts based on Patient_CUMB_ID__c, Patient_Birth_Date__c
			System.debug('priorAuth sha1Hash_Id ' + sha1Hash_Id);
		}

		//Get matching existing Claim Contacts from Daily Claims
		Claim_InformationsSelector claimInformationSelector = (Claim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);
		existingClaim_InformationsList = claimInformationSelector.selectByPrimary_Claim_Number(primary_Claim_NumberSet);
		System.debug('existingClaim_InformationsList Count: ' + existingClaim_InformationsList.size());

		//Get matching existing Contacts from Prior_Auths
		ContactsSelector contactsSelector = (ContactsSelector) PMd_Application.Selector.newInstance(Contact.SObjectType);
		existingSha1Hash_IdMatchedContactsList = contactsSelector.selectBySHA1Hash_ID(sha1Hash_IdSet);
		//existingPatientCUMBIdMatchedContactsList = contactsSelector.selectByPatientCUMBId(patientCUMBIdByPriorAuthId.values());
		existingPatientCUMBIdBDMatchedContactsList = contactsSelector.selectByCumbIdBd(patientCUMBIdSet, patientBDSet);
		System.debug('existingSha1Hash_IdMatchedContactsList Count: ' + existingSha1Hash_IdMatchedContactsList.size());
		//System.debug('existingPatientCUMBIdMatchedContactsList Count: ' + existingPatientCUMBIdMatchedContactsList.size());
		System.debug('existingPatientCUMBIdBDMatchedContactsList Count: ' + existingPatientCUMBIdBDMatchedContactsList.size());

		Map<String, Id> priorAuthIdByClaim_InformationId = new Map<String, Id>();
		Map<String, Id> priorAuthIdByContactSha1Hash_Id = new Map<String, Id>();
		Map<String, Id> priorAuthIdByPatientCUMBId  = new Map<String, Id>();
		Map<String, Id> priorAuthIdByPatientCUMBIdBDSha1Hash_Id  = new Map<String, Id>();
		//Map priorAuthIdByClaim_InformationId & priorAuthIdByContactSha1Hash_Id
		for (Prior_Auth__c priorAuth : priorAuthList) {
			//if(priorAuth.Primary_Claim_Number__c != null) {
			//	priorAuthIdByClaim_InformationId.put(priorAuth.Primary_Claim_Number__c, priorAuth.Id);
			//	System.debug('Claim_InformationId => priorAuthId = ' + priorAuthIdByClaim_InformationId);
			//}
			String contactsha1Hash_Id = sha1Hash_IdByPriorAuthId.get(priorAuth.Id);
			if(contactsha1Hash_Id != null) {
				priorAuthIdByContactSha1Hash_Id.put(contactsha1Hash_Id, priorAuth.Id);
				System.debug('ContactSha1Hash_Id => priorAuthId = ' + priorAuthIdByContactSha1Hash_Id);
			}
			String contactPatientCUMBId = patientCUMBIdByPriorAuthId.get(priorAuth.Id);
			if(contactPatientCUMBId != null) {
				priorAuthIdByPatientCUMBId.put(contactPatientCUMBId, priorAuth.Id);
				System.debug('contactPatientCUMBId => priorAuth = ' + priorAuthIdByPatientCUMBId);
			}
			String contactPatientCUMBIdBDSha1Hash_Id = patientCUMBIdBDByPriorAuthId.get(priorAuth.Id);
			if(contactPatientCUMBIdBDSha1Hash_Id != null) {
				priorAuthIdByPatientCUMBIdBDSha1Hash_Id.put(contactPatientCUMBIdBDSha1Hash_Id, priorAuth.Id);
				System.debug('contactPatientCUMBIdBD => priorAuthId = ' + priorAuthIdByPatientCUMBIdBDSha1Hash_Id);
			}
		}

		for(Claim_Information__c existingClaim_Information : existingClaim_InformationsList) {
			System.debug('existingClaim_Information = ' + existingClaim_Information);
			if(existingClaim_Information.Contact__c != null) {
				existingContactsById.put(existingClaim_Information.Contact__c, new Contact(Id = existingClaim_Information.Contact__c));
				System.debug('ContactId => existingContacts = ' + existingContactsById);
			}
			/*
			Id priorAuthId = priorAuthIdByClaim_InformationId.get(existingClaim_Information.Id);
			if(priorAuthId != null) {
				existingContactsByPriorAuthId.put(priorAuthId, new Contact(Id = existingClaim_Information.Contact__c));
				System.debug('existingContact => priorAuthId = ' + existingContactsByPriorAuthId);
			}
			*/
		}

		for(Contact existingSha1Hash_IdMatchedContact : existingSha1Hash_IdMatchedContactsList) {
			//existingContactsById.put(existingSha1Hash_IdMatchedContact.Id, existingSha1Hash_IdMatchedContact);
			String contactSha1Hash_Id = existingSha1Hash_IdMatchedContact.SHA1Hash_ID__c;
			Id priorAuthId = priorAuthIdByContactSha1Hash_Id.get(contactSha1Hash_Id);
			If (priorAuthId != null && existingSha1Hash_IdMatchedContact != null) {
				existingContactsByPriorAuthId.put(priorAuthId, existingSha1Hash_IdMatchedContact);
				System.debug('existingContact => priorAuthId = ' + existingContactsByPriorAuthId);
			}
		}

		for(Contact existingPatientCUMBIdBDMatchedContact : existingPatientCUMBIdBDMatchedContactsList) {
			//existingContactsById.put(existingSha1Hash_IdMatchedContact.Id, existingSha1Hash_IdMatchedContact);
			String contactPatientCUMBId = existingPatientCUMBIdBDMatchedContact.Patient_CUMB_ID__c;
			Date contactPatientBD = existingPatientCUMBIdBDMatchedContact.Patient_Birth_Date__c;
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					contactPatientCUMBId + '-'
							+ contactPatientBD
			);
			Id priorAuthId = priorAuthIdByPatientCUMBIdBDSha1Hash_Id.get(sha1Hash_Id);
			If (priorAuthId != null && existingPatientCUMBIdBDMatchedContact != null) {
				existingContactsByPriorAuthId.put(priorAuthId, existingPatientCUMBIdBDMatchedContact);
				System.debug('existingContact => priorAuthId = ' + existingContactsByPriorAuthId);
			}
		}

		System.debug('existingContactsByPriorAuthId = ' + existingContactsByPriorAuthId);
		System.debug('Existing Contacts Count: ' + existingContactsByPriorAuthId.values().size());
		return existingContactsByPriorAuthId;
	}

	//Look for an existing member based on Matching Logic here.
	public Map<Id, Contact> getExistingContactsByHistoricalPriorAuthId(List<Historical_Prior_Auth__c> historicalPriorAuthList) {

		Set<Id> priorAuthsRecordIds = new Set<Id>();
		Set<Id> existingContactRecordIds = new Set<Id>();
		String sha1Hash_Id;
		Set<String> sha1Hash_IdSet = new Set<String>();
		Map<Id, String> sha1Hash_IdByHistoricalPriorAuthId = new Map<Id, String>();
		Map<Id, String> patientCUMBIdByHistoricalPriorAuthId = new Map<Id, String>();
		Map<Id, String> patientCUMBIdBDByHistoricalPriorAuthId = new Map<Id, String>();
		List<Claim_Information__c> existingClaim_InformationsList;
		List<Contact> existingClaim_InformationContactsList;
		Set<String> primary_Claim_NumberSet = new Set<String>();
		List<Contact> existingSha1Hash_IdMatchedContactsList;
		List<Contact> existingPatientCUMBIdMatchedContactsList;
		List<Contact> existingPatientCUMBIdBDMatchedContactsList;
		Map<Id, Contact> existingContactsById = new Map<Id, Contact>();
		Map<Id, Contact> existingContactsByHistoricalPriorAuthId = new Map<Id, Contact>();
		Set<String> patientCUMBIdSet = new Set<String>();
		Set<Date> patientBDSet = new Set<Date>();

		sha1Hash_IdByHistoricalPriorAuthId = getSha1Hash_IdByHistoricalPriorAuthId(historicalpriorAuthList);

		for (Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthList) {

			//get all Historical_Prior_Auth sah1Hash_Ids that will match existing Contacts
			//get all Historical_Prior_Auth Contact matching Sha1Had_Ids
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					historicalPriorAuth.Patient_CUMB_ID__c + '-'
							+ historicalPriorAuth.Patient_Birth_Date__c + '-'
							+ historicalPriorAuth.Patient_First_Name__c + '-'
							+ historicalPriorAuth.Patient_Last_Name__c
			);
			sha1Hash_IdSet.add(sha1Hash_Id);
			System.debug('historicalPriorAuth.Patient_CUMB_ID__c = : ' + historicalPriorAuth.Patient_CUMB_ID__c);
			System.debug('historicalPriorAuth.Patient_Birth_Date__c = : ' + historicalPriorAuth.Patient_Birth_Date__c);
			System.debug('historicalPriorAuth.Patient_First_Name__c : ' + historicalPriorAuth.Patient_First_Name__c);
			System.debug('historicalPriorAuth.Patient_Last_Name__c : ' + historicalPriorAuth.Patient_Last_Name__c);
			System.debug('Existing Contacts sha1Hash_Id = : ' + sha1Hash_Id);
			//get all Daily Claim Primary_Claim_Number__c that will match Claim Primary_Claim_Number__c
			//primary_Claim_NumberSet.add(priorAuth.Primary_Claim_Number__c);
			sha1Hash_IdByHistoricalPriorAuthId.put(historicalPriorAuth.Id, sha1Hash_Id); //Match Contacts based on Patient_CUMB_ID__c, Patient_Birth_Date__c, Patient_First_Name__c, Patient_Last_Name__c
			patientCUMBIdByHistoricalPriorAuthId.put(historicalPriorAuth.Id, historicalPriorAuth.Patient_CUMB_ID__c);
			//System.debug('priorAuth.Primary_Claim_Number__c ' + priorAuth.Primary_Claim_Number__c);
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					historicalPriorAuth.Patient_CUMB_ID__c + '-'
							+ historicalPriorAuth.Patient_Birth_Date__c
			);
			patientCUMBIdSet.add(historicalPriorAuth.Patient_CUMB_ID__c);
			patientBDSet.add(historicalPriorAuth.Patient_Birth_Date__c);
			System.debug('historicalPriorAuth.Patient_CUMB_ID__c = ' + historicalPriorAuth.Patient_CUMB_ID__c);
			System.debug('historicalPriorAuth.Patient_Birth_Date__c = ' + historicalPriorAuth.Patient_Birth_Date__c);
			patientCUMBIdBDByHistoricalPriorAuthId.put(historicalPriorAuth.Id, sha1Hash_Id); //Match Contacts based on Patient_CUMB_ID__c, Patient_Birth_Date__c
			System.debug('historicalPriorAuth sha1Hash_Id ' + sha1Hash_Id);
		}

		//Get matching existing Claim Contacts from Daily Claims
		Claim_InformationsSelector claimInformationSelector = (Claim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);
		existingClaim_InformationsList = claimInformationSelector.selectByPrimary_Claim_Number(primary_Claim_NumberSet);
		System.debug('existingClaim_InformationsList Count: ' + existingClaim_InformationsList.size());

		//Get matching existing Contacts from Historical_Prior_Auths
		ContactsSelector contactsSelector = (ContactsSelector) PMd_Application.Selector.newInstance(Contact.SObjectType);
		existingSha1Hash_IdMatchedContactsList = contactsSelector.selectBySHA1Hash_ID(sha1Hash_IdSet);
		//existingPatientCUMBIdMatchedContactsList = contactsSelector.selectByPatientCUMBId(patientCUMBIdByHistoricalPriorAuthId.values());
		existingPatientCUMBIdBDMatchedContactsList = contactsSelector.selectByCumbIdBd(patientCUMBIdSet, patientBDSet);
		System.debug('existingSha1Hash_IdMatchedContactsList Count: ' + existingSha1Hash_IdMatchedContactsList.size());
		//System.debug('existingPatientCUMBIdMatchedContactsList Count: ' + existingPatientCUMBIdMatchedContactsList.size());
		System.debug('existingPatientCUMBIdBDMatchedContactsList Count: ' + existingPatientCUMBIdBDMatchedContactsList.size());

		Map<String, Id> historicalPriorAuthIdByClaim_InformationId = new Map<String, Id>();
		Map<String, Id> historicalPriorAuthIdByContactSha1Hash_Id = new Map<String, Id>();
		Map<String, Id> historicalPriorAuthIdByPatientCUMBId  = new Map<String, Id>();
		Map<String, Id> historicalPriorAuthIdByPatientCUMBIdBDSha1Hash_Id  = new Map<String, Id>();
		//Map priorAuthIdByClaim_InformationId & priorAuthIdByContactSha1Hash_Id
		for (Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthList) {
			//if(priorAuth.Primary_Claim_Number__c != null) {
			//	priorAuthIdByClaim_InformationId.put(priorAuth.Primary_Claim_Number__c, priorAuth.Id);
			//	System.debug('Claim_InformationId => priorAuthId = ' + priorAuthIdByClaim_InformationId);
			//}
			String contactsha1Hash_Id = sha1Hash_IdByHistoricalPriorAuthId.get(historicalPriorAuth.Id);
			if (contactsha1Hash_Id != null) {
				historicalPriorAuthIdByContactSha1Hash_Id.put(contactsha1Hash_Id, historicalPriorAuth.Id);
				System.debug('ContactSha1Hash_Id => historicalPriorAuthId = ' + historicalPriorAuthIdByContactSha1Hash_Id);
			}
			String contactPatientCUMBId = patientCUMBIdByHistoricalPriorAuthId.get(historicalPriorAuth.Id);
			if (contactPatientCUMBId != null) {
				historicalPriorAuthIdByPatientCUMBId.put(contactPatientCUMBId, historicalPriorAuth.Id);
				System.debug('contactPatientCUMBId => historicalPriorAuth = ' + historicalPriorAuthIdByPatientCUMBId);
			}
			String contactPatientCUMBIdBDSha1Hash_Id = patientCUMBIdBDByHistoricalPriorAuthId.get(historicalPriorAuth.Id);
			if(contactPatientCUMBIdBDSha1Hash_Id != null) {
				historicalPriorAuthIdByPatientCUMBIdBDSha1Hash_Id.put(contactPatientCUMBIdBDSha1Hash_Id, historicalPriorAuth.Id);
				System.debug('contactPatientCUMBIdBD => historicalPriorAuthId = ' + historicalPriorAuthIdByPatientCUMBIdBDSha1Hash_Id);
			}
		}

		for(Claim_Information__c existingClaim_Information : existingClaim_InformationsList) {
			System.debug('existingClaim_Information = ' + existingClaim_Information);
			if(existingClaim_Information.Contact__c != null) {
				existingContactsById.put(existingClaim_Information.Contact__c, new Contact(Id = existingClaim_Information.Contact__c));
				System.debug('ContactId => existingContacts = ' + existingContactsById);
			}
			/*
			Id historicalPriorAuthId = historicalPriorAuthIdByClaim_InformationId.get(existingClaim_Information.Id);
			if(historicalPriorAuthId != null) {
				existingContactsByHistoricalPriorAuthId.put(historicalPriorAuthId, new Contact(Id = existingClaim_Information.Contact__c));
				System.debug('existingContact => historicalPriorAuthId = ' + existingContactsByHistoricalPriorAuthId);
			}
			*/
		}

		for(Contact existingSha1Hash_IdMatchedContact : existingSha1Hash_IdMatchedContactsList) {
			//existingContactsById.put(existingSha1Hash_IdMatchedContact.Id, existingSha1Hash_IdMatchedContact);
			String contactSha1Hash_Id = existingSha1Hash_IdMatchedContact.SHA1Hash_ID__c;
			Id historicalPriorAuthId = historicalPriorAuthIdByContactSha1Hash_Id.get(contactSha1Hash_Id);
			If (historicalPriorAuthId != null && existingSha1Hash_IdMatchedContact != null) {
				existingContactsByHistoricalPriorAuthId.put(historicalPriorAuthId, existingSha1Hash_IdMatchedContact);
				System.debug('existingContact => historicalPriorAuthId = ' + existingContactsByHistoricalPriorAuthId);
			}
		}

		for(Contact existingPatientCUMBIdBDMatchedContact : existingPatientCUMBIdBDMatchedContactsList) {
			//existingContactsById.put(existingSha1Hash_IdMatchedContact.Id, existingSha1Hash_IdMatchedContact);
			String contactPatientCUMBId = existingPatientCUMBIdBDMatchedContact.Patient_CUMB_ID__c;
			Date contactPatientBD = existingPatientCUMBIdBDMatchedContact.Patient_Birth_Date__c;
			System.debug('contactPatientBD = ' + contactPatientBD);
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					contactPatientCUMBId + '-'
							+ contactPatientBD
			);
			Id historicalPriorAuthId = historicalPriorAuthIdByPatientCUMBIdBDSha1Hash_Id.get(sha1Hash_Id);
			If (historicalPriorAuthId != null && existingPatientCUMBIdBDMatchedContact != null) {
				existingContactsByHistoricalPriorAuthId.put(historicalPriorAuthId, existingPatientCUMBIdBDMatchedContact);
				System.debug('existingContact => historicalPriorAuthId = ' + existingContactsByHistoricalPriorAuthId);
			}
		}

		System.debug('existingContactsByHistoricalPriorAuthId = ' + existingContactsByHistoricalPriorAuthId);
		System.debug('Existing Contacts Count: ' + existingContactsByHistoricalPriorAuthId.values().size());
		return existingContactsByHistoricalPriorAuthId;
	}

	/*
		If Claim does not exist, then look for Contact key in linked document above. Combination of:
	•	Subscriber CUMB ID
	•	Patient Birth Date
	•	Patient Last Name
	•	Patient First Name
	*/
	public static Map<Id, String> getSha1Hash_IdByDailyClaimId(List<Daily_Claim__c> dailyClaimsList){

		//Set<Id> dailyClaimsRecordIds = new Set<Id>();
		Set<Id> existingContactRecordIds = new Set<Id>();
		String sha1Hash_Id;
		Set<String> sha1Hash_IdSet = new Set<String>();

		Map<Id, String> sha1Hash_IdByDailyClaimId = new Map<Id, String>();
		for (Daily_Claim__c dailyClaim : dailyClaimsList) {

			//get all Daily Claim Contact matching Sha1Had_Ids
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					dailyClaim.Patient_CUMB_ID__c + '-'
							+ dailyClaim.Patient_Birth_Date__c + '-'
							+ dailyClaim.Patient_First_Name__c + '-'
							+ dailyClaim.Patient_Last_Name__c
			);
			sha1Hash_IdSet.add(sha1Hash_Id);
			System.debug('dailyClaim.Patient_CUMB_ID__c = : ' + dailyClaim.Patient_CUMB_ID__c);
			System.debug('dailyClaim.Patient_Birth_Date__c = : ' + dailyClaim.Patient_Birth_Date__c);
			System.debug('dailyClaim.Patient_First_Name__c : ' + dailyClaim.Patient_First_Name__c);
			System.debug('dailyClaim.Patient_First_Name__c : ' + dailyClaim.Patient_First_Name__c);
			System.debug('Existing Contacts sha1Hash_Id = : ' + sha1Hash_Id);

			sha1Hash_IdByDailyClaimId.put(dailyClaim.Id, sha1Hash_Id);
			System.debug('dailyClaim.Primary_Claim_Number__c ' + dailyClaim.Primary_Claim_Number__c);
		}

		return sha1Hash_IdByDailyClaimId;
	}

	/*
		If Claim does not exist, then look for Contact key in linked document above. Combination of:
	•	Subscriber CUMB ID
	•	Patient Birth Date
	•	Patient Last Name
	•	Patient First Name
	*/
	public static Map<Id, String> getSha1Hash_IdByHistoricalClaimId(List<Historical_Claim__c> historicalClaimsList){

		//Set<Id> dailyClaimsRecordIds = new Set<Id>();
		Set<Id> existingContactRecordIds = new Set<Id>();
		String sha1Hash_Id;
		Set<String> sha1Hash_IdSet = new Set<String>();

		Map<Id, String> sha1Hash_IdByHistoricalClaimId = new Map<Id, String>();
		for (Historical_Claim__c historicalClaim : historicalClaimsList) {

			//get all Historical Daily Claim Contact matching Sha1Had_Ids
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					historicalClaim.Patient_CUMB_ID__c + '-'
							+ historicalClaim.Patient_Birth_Date__c + '-'
							+ historicalClaim.Patient_First_Name__c + '-'
							+ historicalClaim.Patient_Last_Name__c
			);
			sha1Hash_IdSet.add(sha1Hash_Id);
			System.debug('historicalClaim.Patient_CUMB_ID__c = : ' + historicalClaim.Patient_CUMB_ID__c);
			System.debug('historicalClaim.Patient_Birth_Date__c = : ' + historicalClaim.Patient_Birth_Date__c);
			System.debug('historicalClaim.Patient_First_Name__c : ' + historicalClaim.Patient_First_Name__c);
			System.debug('historicalClaim.Patient_First_Name__c : ' + historicalClaim.Patient_First_Name__c);
			System.debug('Existing Contacts sha1Hash_Id = : ' + sha1Hash_Id);

			sha1Hash_IdByHistoricalClaimId.put(historicalClaim.Id, sha1Hash_Id);
			//System.debug('dailyClaim.Primary_Claim_Number__c ' + dailyClaim.Primary_Claim_Number__c);
		}

		return sha1Hash_IdByHistoricalClaimId;
	}

	public static Map<Id, String> getSha1Hash_IdByPriorAuthId(List<Prior_Auth__c> priorAuthList){

		//Set<Id> dailyClaimsRecordIds = new Set<Id>();
		Set<Id> existingContactRecordIds = new Set<Id>();
		String sha1Hash_Id;
		Set<String> sha1Hash_IdSet = new Set<String>();

		Map<Id, String> sha1Hash_IdByPriorAuthId = new Map<Id, String>();
		for (Prior_Auth__c priorAuth : priorAuthList) {

			//get all Prior_Auth Contact matching Sha1Had_Ids
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					priorAuth.Patient_CUMB_ID__c + '-'
							+ priorAuth.Patient_Birth_Date__c + '-'
							+ priorAuth.Patient_First_Name__c + '-'
							+ priorAuth.Patient_Last_Name__c
			);
			sha1Hash_IdSet.add(sha1Hash_Id);
			System.debug('priorAuth.Patient_CUMB_ID__c = : ' + priorAuth.Patient_CUMB_ID__c);
			System.debug('priorAuth.Patient_Birth_Date__c = : ' + priorAuth.Patient_Birth_Date__c);
			System.debug('priorAuth.Patient_First_Name__c : ' + priorAuth.Patient_First_Name__c);
			System.debug('priorAuth.Patient_First_Name__c : ' + priorAuth.Patient_First_Name__c);
			System.debug('Existing Contacts sha1Hash_Id = : ' + sha1Hash_Id);

			sha1Hash_IdByPriorAuthId.put(priorAuth.Id, sha1Hash_Id);
			//System.debug('dailyClaim.Primary_Claim_Number__c ' + dailyClaim.Primary_Claim_Number__c);
		}

		return sha1Hash_IdByPriorAuthId;
	}

	public static Map<Id, String> getSha1Hash_IdByHistoricalPriorAuthId(List<Historical_Prior_Auth__c> historicalPriorAuthList){

		//Set<Id> dailyClaimsRecordIds = new Set<Id>();
		Set<Id> existingContactRecordIds = new Set<Id>();
		String sha1Hash_Id;
		Set<String> sha1Hash_IdSet = new Set<String>();

		Map<Id, String> sha1Hash_IdByHistoricalPriorAuthId = new Map<Id, String>();
		for (Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthList) {

			//get all Historical_Prior_Auth Contact matching Sha1Had_Ids
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					historicalPriorAuth.Patient_CUMB_ID__c + '-'
							+ historicalPriorAuth.Patient_Birth_Date__c + '-'
							+ historicalPriorAuth.Patient_First_Name__c + '-'
							+ historicalPriorAuth.Patient_Last_Name__c
			);
			sha1Hash_IdSet.add(sha1Hash_Id);
			System.debug('historicalPriorAuth.Patient_CUMB_ID__c = : ' + historicalPriorAuth.Patient_CUMB_ID__c);
			System.debug('historicalPriorAuth.Patient_Birth_Date__c = : ' + historicalPriorAuth.Patient_Birth_Date__c);
			System.debug('historicalPriorAuth.Patient_First_Name__c : ' + historicalPriorAuth.Patient_First_Name__c);
			System.debug('historicalPriorAuth.Patient_First_Name__c : ' + historicalPriorAuth.Patient_First_Name__c);
			System.debug('Existing Contacts sha1Hash_Id = : ' + sha1Hash_Id);

			sha1Hash_IdByHistoricalPriorAuthId.put(historicalPriorAuth.Id, sha1Hash_Id);
			//System.debug('dailyClaim.Primary_Claim_Number__c ' + dailyClaim.Primary_Claim_Number__c);
		}

		return sha1Hash_IdByHistoricalPriorAuthId;
	}

	//Generate map of Contacts By Daily Claim Ids
	public Map<Id, Contact> mapContactsByDailyClaimId(List<Contact> existingContactList, List<Daily_Claim__c> dailyClaimsList) {
		Map<Id, Contact> existingContactsByDailyClaimId = new Map<Id, Contact>();
		for(Daily_Claim__c dailyClaim : dailyClaimsList) {
			for(Contact contact : existingContactList) {
				String sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
						dailyClaim.Patient_CUMB_ID__c + '-'
								+ dailyClaim.Patient_Birth_Date__c + '-'
								+ dailyClaim.Patient_First_Name__c + '-'
								+ dailyClaim.Patient_Last_Name__c
				);

				if(sha1Hash_Id == contact.SHA1Hash_ID__c)
				{
					existingContactsByDailyClaimId.put(dailyClaim.Id, contact);
				}
			}
		}
		return existingContactsByDailyClaimId;
	}

	//Generate map of Contacts By Historical Claim Ids
	public Map<Id, Contact> mapContactsByHistoricalClaimId(List<Contact> existingContactList, List<Historical_Claim__c> historicalClaimsList) {
		Map<Id, Contact> existingContactsByHistoricalClaimId = new Map<Id, Contact>();
		for(Historical_Claim__c historicalClaim : historicalClaimsList) {
			for(Contact contact : existingContactList) {
				String sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
						historicalClaim.Patient_CUMB_ID__c + '-'
								+ historicalClaim.Patient_Birth_Date__c + '-'
								+ historicalClaim.Patient_First_Name__c + '-'
								+ historicalClaim.Patient_Last_Name__c
				);

				if(sha1Hash_Id == contact.SHA1Hash_ID__c)
				{
					existingContactsByHistoricalClaimId.put(historicalClaim.Id, contact);
				}
			}
		}
		return existingContactsByHistoricalClaimId;
	}

	//Generate map of Contacts By PriorAuth Ids
	public Map<Id, Contact> mapContactsByPriorAuthId(List<Contact> existingContactList, List<Prior_Auth__c> priorAuthList) {
		Map<Id, Contact> existingContactsByPriorAuthId = new Map<Id, Contact>();
		for(Prior_Auth__c priorAuth : priorAuthList) {
			for(Contact contact : existingContactList) {
				String sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
						PriorAuth.Patient_CUMB_ID__c + '-'
								+ priorAuth.Patient_Birth_Date__c + '-'
								+ priorAuth.Patient_First_Name__c + '-'
								+ priorAuth.Patient_Last_Name__c
				);

				if(sha1Hash_Id == contact.SHA1Hash_ID__c)
				{
					existingContactsByPriorAuthId.put(priorAuth.Id, contact);
				}
			}
		}
		return existingContactsByPriorAuthId;
	}

	//Generate map of Contacts By PriorAuth Ids
	public Map<Id, Contact> mapContactsByHistoricalPriorAuthId(List<Contact> existingContactList, List<Historical_Prior_Auth__c> historicalPriorAuthList) {
		Map<Id, Contact> existingContactsByHistoricalPriorAuthId = new Map<Id, Contact>();
		for(Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthList) {
			for(Contact contact : existingContactList) {
				String sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
						historicalPriorAuth.Patient_CUMB_ID__c + '-'
								+ historicalPriorAuth.Patient_Birth_Date__c + '-'
								+ historicalPriorAuth.Patient_First_Name__c + '-'
								+ historicalPriorAuth.Patient_Last_Name__c
				);

				if(sha1Hash_Id == contact.SHA1Hash_ID__c)
				{
					existingContactsByHistoricalPriorAuthId.put(historicalPriorAuth.Id, contact);
				}
			}
		}
		return existingContactsByHistoricalPriorAuthId;
	}

	//Map Daily Claim fields to new Contact fields
	private Contact mapDailyClaimToContact(Daily_Claim__c dailyClaim, Contact contact) {

		contact.CSA_Account__c = dailyClaim.CSA_Account__c;
		
		//Below condition added for US-540 to first check for Authorization Received checkbox before updating the Authorized Representative and Relationship fields
		System.debug('The Contact level Auth Received value is: '+contact.Authorization_Received__c);	
		if(!contact.Authorization_Received__c){
			if(!String.isBlank(dailyClaim.Authorized_Representative__c) && (!dailyClaim.Authorized_Representative__c.containsIgnoreCase('NA'))){
				contact.Authorized_Representative__c = dailyClaim.Authorized_Representative__c;
			}
			if(!String.isBlank(dailyClaim.Authorized_Relationship__c) && (!dailyClaim.Authorized_Relationship__c.containsIgnoreCase('NA'))){
				contact.Authorized_Relationship__c = dailyClaim.Authorized_Relationship__c;
			}
		}		
		contact.CSA_Control__c = dailyClaim.CSA_Control__c;
		if(dailyClaim.Patient_Birth_Date__c != null) {
			contact.Patient_Birth_Date__c = dailyClaim.Patient_Birth_Date__c;
		}
		//contact.Birthdate = dailyClaim.Patient_Birth_Date__c;
		//contact.Patient_Email_Address__c = dailyClaim.Patient_Email_Address__c;
		if(!String.isBlank(dailyClaim.Patient_First_Name__c)) {
			contact.Patient_First_Name__c = dailyClaim.Patient_First_Name__c;
		}
		if(!String.isBlank(dailyClaim.Patient_First_Name__c)) {
			contact.FirstName = dailyClaim.Patient_First_Name__c;
		}
		if(!String.isBlank(dailyClaim.Patient_Last_Name__c)) {
			contact.LastName = dailyClaim.Patient_Last_Name__c;
		}
		if(!String.isBlank(dailyClaim.Patient_Middle_Initial__c)) {
			contact.MiddleName = dailyClaim.Patient_Middle_Initial__c;
		}
		if(!String.isBlank(dailyClaim.Patient_Phone_Number__c)) {
			contact.Patient_Phone_Number__c = dailyClaim.Patient_Phone_Number__c;
			contact.Phone = dailyClaim.Patient_Phone_Number__c;
		}
		if(!String.isBlank(dailyClaim.Patient_Gender__c)) {
			contact.Patient_Gender__c = dailyClaim.Patient_Gender__c;
		}
		//contact.Gender__c = dailyClaim.Patient_Gender__c;
		//contact.Patient_Address_Line_1__c = dailyClaim.Patient_Address_Line_1__c;
		//contact.Patient_Address_Line_2__c = dailyClaim.Patient_Address_Line_2__c;
		if(!String.isBlank(dailyClaim.Patient_Address_Line_1__c)) {
			contact.MailingStreet = FormatterUtilService.textFormatter(dailyClaim.Patient_Address_Line_1__c) + ' ' + FormatterUtilService.textFormatter(dailyClaim.Patient_Address_Line_2__c);
		}
		if(!String.isBlank(dailyClaim.Patient_City__c)) {
			contact.MailingCity = dailyClaim.Patient_City__c;
		}
		if(!String.isBlank(dailyClaim.Patient_State__c)) {
			contact.MailingState = dailyClaim.Patient_State__c;
		}
		if(!String.isBlank(dailyClaim.Patient_Zip_Code__c)) {
			contact.MailingPostalCode = dailyClaim.Patient_Zip_Code__c;
		}
		contact.MailingCountry = 'US';
		contact.Patient_CUMB_ID__c = dailyClaim.Patient_CUMB_ID__c;
		contact.CSA_Suffix__c = dailyClaim.CSA_Suffix__c;
		if(!String.isBlank(dailyClaim.Relationship_Code__c)) {
			//System.debug('(dailyClaim.Relationship_Code__c = ' + dailyClaim.Relationship_Code__c);
			contact.Relationship_Code__c = dailyClaim.Relationship_Code__c;
			//contact.Relationship_Code__c = '01';
		}
		if(!String.isBlank(dailyClaim.Plan_Sponsor_Unique_ID__c)) {
			//System.debug('dailyClaim.Plan_Sponsor_Unique_ID__c = ' + dailyClaim.Plan_Sponsor_Unique_ID__c);
			contact.Plan_Sponsor_Unique_ID__c = dailyClaim.Plan_Sponsor_Unique_ID__c;
		}

		return contact;
	}

	//Map Historical Claim fields to new Contact fields
	private Contact mapHistoricalClaimToContact(Historical_Claim__c historicalClaim, Contact contact) {

		contact.CSA_Account__c = historicalClaim.CSA_Account__c;
		//contact.Authorized_Representative__c = historicalClaim.Authorized_Representative__c;
		//contact.Authorized_Relationship__c = historicalClaim.Authorized_Relationship__c;
		contact.CSA_Control__c = historicalClaim.CSA_Control__c;
		if(historicalClaim.Patient_Birth_Date__c != null) {
			contact.Patient_Birth_Date__c = historicalClaim.Patient_Birth_Date__c;
		}
		//contact.Birthdate = historicalClaim.Patient_Birth_Date__c;
		//contact.Patient_Email_Address__c = historicalClaim.Patient_Email_Address__c;
		if(!String.isBlank(historicalClaim.Patient_First_Name__c)) {
			contact.Patient_First_Name__c = historicalClaim.Patient_First_Name__c;
		}
		if(!String.isBlank(historicalClaim.Patient_First_Name__c)) {
			contact.FirstName = historicalClaim.Patient_First_Name__c;
		}
		if(!String.isBlank(historicalClaim.Patient_Last_Name__c)) {
			contact.LastName = historicalClaim.Patient_Last_Name__c;
		}
		if(!String.isBlank(historicalClaim.Patient_Middle_Initial__c)) {
			contact.MiddleName = historicalClaim.Patient_Middle_Initial__c;
		}
		if(!String.isBlank(historicalClaim.Patient_Phone_Number__c)) {
			contact.Patient_Phone_Number__c = historicalClaim.Patient_Phone_Number__c;
			contact.Phone = historicalClaim.Patient_Phone_Number__c;
		}
		if(!String.isBlank(historicalClaim.Patient_Gender__c)) {
			contact.Patient_Gender__c = historicalClaim.Patient_Gender__c;
		}
		//contact.Gender__c = historicalClaim.Patient_Gender__c;
		//contact.Patient_Address_Line_1__c = historicalClaim.Patient_Address_Line_1__c;
		//contact.Patient_Address_Line_2__c = historicalClaim.Patient_Address_Line_2__c;
		if(!String.isBlank(historicalClaim.Patient_Address_Line_1__c)) {
			contact.MailingStreet = FormatterUtilService.textFormatter(historicalClaim.Patient_Address_Line_1__c) + ' ' + FormatterUtilService.textFormatter(historicalClaim.Patient_Address_Line_2__c);
		}
		if(!String.isBlank(historicalClaim.Patient_City__c)) {
			contact.MailingCity = historicalClaim.Patient_City__c;
		}
		if(!String.isBlank(historicalClaim.Patient_State__c)) {
			contact.MailingState = historicalClaim.Patient_State__c;
		}
		if(!String.isBlank(historicalClaim.Patient_Zip_Code__c)) {
			contact.MailingPostalCode = historicalClaim.Patient_Zip_Code__c;
		}
		contact.MailingCountry = 'US';
		if(!String.isBlank(historicalClaim.Patient_CUMB_ID__c)) {
			contact.Patient_CUMB_ID__c = historicalClaim.Patient_CUMB_ID__c;
		}
		contact.CSA_Suffix__c = historicalClaim.CSA_Suffix__c;
		if(!String.isBlank(historicalClaim.Relationship_Code__c)) {
			contact.Relationship_Code__c = historicalClaim.Relationship_Code__c;
		}
		if(!String.isBlank(historicalClaim.Primary_Subscriber_Name__c)) {
			contact.Primary_Subscriber_Name__c = historicalClaim.Primary_Subscriber_Name__c;
		}
		if(!String.isBlank(historicalClaim.Primary_Subscriber_Relationship__c)) {
			contact.Primary_Subscriber_Relationship__c = historicalClaim.Primary_Subscriber_Relationship__c;
		}
		if(!String.isBlank(historicalClaim.Plan_Sponsor_Unique_ID__c)) {
			contact.Plan_Sponsor_Unique_ID__c = historicalClaim.Plan_Sponsor_Unique_ID__c;
		}

		return contact;
	}

	//Map Prior_Auth fields to new Contact fields
	private Contact mapPriorAuthToContact(Prior_Auth__c priorAuth, Contact contact) {

		contact.CSA_Account__c = priorAuth.CSA_Account__c;
		if(!String.isBlank(priorAuth.Authorized_Representative__c)) {
			contact.Authorized_Representative__c = priorAuth.Authorized_Representative__c;
		}
		if(!String.isBlank(priorAuth.Authorized_Relationship__c)) {
			contact.Authorized_Relationship__c = priorAuth.Authorized_Relationship__c;
		}
		contact.CSA_Control__c = priorAuth.CSA_Control__c;
		if(priorAuth.Patient_Birth_Date__c != null) {
			contact.Patient_Birth_Date__c = priorAuth.Patient_Birth_Date__c;
		}
		//contact.Birthdate = priorAuth.Patient_Birth_Date__c;
		//contact.Patient_Email_Address__c = priorAuth.Patient_Email_Address__c;
		if(!String.isBlank(priorAuth.Patient_First_Name__c)) {
			contact.Patient_First_Name__c = priorAuth.Patient_First_Name__c;
		}
		if(!String.isBlank(priorAuth.Patient_First_Name__c)) {
			contact.FirstName = priorAuth.Patient_First_Name__c;
		}
		if(!String.isBlank(priorAuth.Patient_Last_Name__c)) {
			contact.Patient_Last_Name__c = priorAuth.Patient_Last_Name__c;
		}
		if(!String.isBlank(priorAuth.Patient_Last_Name__c)) {
			contact.LastName = priorAuth.Patient_Last_Name__c;
		}
		if(!String.isBlank(priorAuth.Patient_Middle_Initial__c)) {
			contact.Patient_Middle_Initial__c = priorAuth.Patient_Middle_Initial__c;
		}
		if(!String.isBlank(priorAuth.Patient_Phone_Number__c)) {
			contact.Patient_Phone_Number__c = priorAuth.Patient_Phone_Number__c;
			contact.Phone = priorAuth.Patient_Phone_Number__c;
		}
		if(!String.isBlank(priorAuth.Patient_Gender__c)) {
			contact.Patient_Gender__c = priorAuth.Patient_Gender__c;
		}
		//contact.Gender__c = priorAuth.Patient_Gender__c;
		//contact.Patient_Address_Line_1__c = priorAuth.Patient_Address_Line_1__c;
		//contact.Patient_Address_Line_2__c = priorAuth.Patient_Address_Line_2__c;
		if(!String.isBlank(priorAuth.Patient_Address_Line_1__c)) {
			contact.MailingStreet = FormatterUtilService.textFormatter(priorAuth.Patient_Address_Line_1__c) + ' ' + FormatterUtilService.textFormatter(priorAuth.Patient_Address_Line_2__c);
		}
		if(!String.isBlank(priorAuth.Patient_City__c)) {
			contact.MailingCity = priorAuth.Patient_City__c;
		}
		contact.Patient_CUMB_ID__c = priorAuth.Patient_CUMB_ID__c;
		if(!String.isBlank(priorAuth.Patient_State__c)) {
			contact.MailingState = priorAuth.Patient_State__c;
		}
		if(!String.isBlank(priorAuth.Patient_Zip_Code__c)) {
			contact.MailingPostalCode = priorAuth.Patient_Zip_Code__c;
		}
		contact.MailingCountry = 'US';
		contact.CSA_Suffix__c = priorAuth.CSA_Suffix__c;
		if(!String.isBlank(priorAuth.Relationship_Code__c)) {
			contact.Relationship_Code__c = priorAuth.Relationship_Code__c;
		}

		return contact;
	}

	//Map Historical_Prior_Auth fields to new Contact fields
	private Contact mapHistoricalPriorAuthToContact(Historical_Prior_Auth__c historicalPriorAuth, Contact contact) {

		contact.CSA_Account__c = historicalPriorAuth.CSA_Account__c;
		//contact.Authorized_Representative__c = historicalPriorAuth.Authorized_Representative__c;
		//contact.Authorized_Relationship__c = historicalPriorAuth.Authorized_Relationship__c;
		contact.CSA_Control__c = historicalPriorAuth.CSA_Control__c;
		if(historicalPriorAuth.Patient_Birth_Date__c != null) {
			contact.Patient_Birth_Date__c = historicalPriorAuth.Patient_Birth_Date__c;
		}
		//contact.Birthdate = historicalPriorAuth.Patient_Birth_Date__c;
		//contact.Patient_Email_Address__c = historicalPriorAuth.Patient_Email_Address__c;
		if(!String.isBlank(historicalPriorAuth.Patient_First_Name__c)) {
			contact.Patient_First_Name__c = historicalPriorAuth.Patient_First_Name__c;
		}
		if(!String.isBlank(historicalPriorAuth.Patient_First_Name__c)) {
			contact.FirstName = historicalPriorAuth.Patient_First_Name__c;
		}
		if(!String.isBlank(historicalPriorAuth.Patient_Last_Name__c)) {
			contact.Patient_Last_Name__c = historicalPriorAuth.Patient_Last_Name__c;
		}
		if(!String.isBlank(historicalPriorAuth.Patient_Last_Name__c)) {
			contact.LastName = historicalPriorAuth.Patient_Last_Name__c;
		}
		if(!String.isBlank(historicalPriorAuth.Patient_Middle_Initial__c)) {
			contact.Patient_Middle_Initial__c = historicalPriorAuth.Patient_Middle_Initial__c;
		}
		if(!String.isBlank(historicalPriorAuth.Patient_Phone_Number__c)) {
			contact.Patient_Phone_Number__c = historicalPriorAuth.Patient_Phone_Number__c;
			contact.Phone = historicalPriorAuth.Patient_Phone_Number__c;
		}
		if(!String.isBlank(historicalPriorAuth.Patient_Gender__c)) {
			contact.Patient_Gender__c = historicalPriorAuth.Patient_Gender__c;
		}
		//contact.Gender__c = historicalPriorAuth.Patient_Gender__c;
		//contact.Patient_Address_Line_1__c = historicalPriorAuth.Patient_Address_Line_1__c;
		//contact.Patient_Address_Line_2__c = historicalPriorAuth.Patient_Address_Line_2__c;
		if(!String.isBlank(historicalPriorAuth.Patient_Address_Line_1__c)) {
			contact.MailingStreet = FormatterUtilService.textFormatter(historicalPriorAuth.Patient_Address_Line_1__c) + ' ' + FormatterUtilService.textFormatter(historicalPriorAuth.Patient_Address_Line_2__c);
		}
		if(!String.isBlank(historicalPriorAuth.Patient_City__c)) {
			contact.MailingCity = historicalPriorAuth.Patient_City__c;
		}
		if(!String.isBlank(historicalPriorAuth.Patient_State__c)) {
			contact.MailingState = historicalPriorAuth.Patient_State__c;
		}
		if(!String.isBlank(historicalPriorAuth.Patient_Zip_Code__c)) {
			contact.MailingPostalCode = historicalPriorAuth.Patient_Zip_Code__c;
		}
		contact.MailingCountry = 'US';
		if(!String.isBlank(historicalPriorAuth.Patient_CUMB_ID__c)) {
			contact.Patient_CUMB_ID__c = historicalPriorAuth.Patient_CUMB_ID__c;
		}
		contact.CSA_Suffix__c = historicalPriorAuth.CSA_Suffix__c;
		if(!String.isBlank(historicalPriorAuth.Relationship_Code__c)) {
			contact.Relationship_Code__c = historicalPriorAuth.Relationship_Code__c;
		}
		if(!String.isBlank(historicalPriorAuth.Plan_Sponsor_Unique_ID__c)) {
			contact.Plan_Sponsor_Unique_ID__c = historicalPriorAuth.Plan_Sponsor_Unique_ID__c;
		}
		if(!String.isBlank(historicalPriorAuth.Primary_Subscriber_Name__c)) {
			contact.Primary_Subscriber_Name__c = historicalPriorAuth.Primary_Subscriber_Name__c;
		}
		if(!String.isBlank(historicalPriorAuth.Primary_Subscriber_Relationship__c)) {
			contact.Primary_Subscriber_Relationship__c = historicalPriorAuth.Primary_Subscriber_Relationship__c;
		}

		return contact;
	}
/*
	//Use this method for clients like Batch Jobs, Controllers, etc.
	public void process(ContactsService.ContactFactory contactFactory) {
		System.debug('Start processing Contacts for Daily Claims');

		String sha1Hash_Id;
		Set<String> sha1Hash_IdSet = new Set<String>();
		List<Daily_Claim__c> dailyClaimsList = (List<Daily_Claim__c>) getRecords();

		for(Daily_Claim__c dailyClaim : dailyClaimsList){
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					dailyClaim.Patient_CUMB_ID__c
							+ dailyClaim.Patient_Birth_Date__c
							+ dailyClaim.Patient_First_Name__c
							+ dailyClaim.Patient_Last_Name__c
			);
			sha1Hash_IdSet.add(sha1Hash_Id);
		}

		// Create unit of work to capture work and commit it under one transaction
		fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

		//TODO: Get matching contacts from Daily Claims
		ContactsSelector contactsSelector = (ContactsSelector)PMd_Application.Selector.newInstance(Contact.SObjectType);
		//TODO: Use ContactSelector to get matching existing contacts
		/*
			Look for an existing member based on: Add tiered matching logic.
				Subscriber CUMB ID
				Patient Birth Date
				Patient Last Name
				Patient First Name
		 */
/*
		List<Contact> existingContacts = contactsSelector.selectBySHA1Hash_ID(sha1Hash_IdSet);
		Map<Id, Contact> existingDailyClaimContactsById = new Map<Id, Contact>(existingContacts);
		//TODO: Get map of existing Contacts by Daily Claim Id
		Map<Id, Contact> existingContactsByDailyClaimId = mapContactsByDailyClaimId(existingContacts, dailyClaimsList);

		process(contactFactory, existingContactsByDailyClaimId, uow);

		System.debug('End processing Contacts for Daily Claims');
	}
*/
	/*
	//This method MUST BE IMPLEMENTED due to this class implementing the Task_Selector_Interface interface. It creates new tasks
	//and registers them in a new unit of work to be committed to the database at a later time.
	public fflib_ISObjectUnitOfWork createTasks(List<SObject> recordsToCreateTasksFor, fflib_ISObjectUnitOfWork unitOfWork)
	{
		List<Contact> contList = (List<Contact>) recordsToCreateTasksFor;
		List<Task> taskList = new List<Task>();
		for(Contact cont: contList){
			Task tsk = new Task();
			tsk.Status = 'New';
			tsk.Subject = cont.Name;
			tsk.WhoId = cont.Id;
			tsk.ActivityDate = Date.today();
			taskList.add(tsk);
		}
		unitOfWork.registerNew(taskList);
		return unitOfWork;
	}
*/
	/***************************************************************************************************************************************
     * Trigger Operations
     **************************************************************************************************************************************/
//    public override void processAfterInsert(){
	public override void onBeforeInsert() {
		System.debug('Start contact:onBeforeInsert');

		List<Contact> contactList = Records;
		List<Contact>contactToProcessList = new List<Contact>();
		String sha1Hash_Id;

		for(Contact contactRecord : contactList) {

			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					contactRecord.Patient_CUMB_ID__c + '-'
							+ contactRecord.Patient_Birth_Date__c + '-'
							+ contactRecord.FirstName + '-'
							+ contactRecord.LastName
			);
			contactRecord.SHA1Hash_ID__c = sha1Hash_Id;
			System.debug('contactRecord.Patient_CUMB_ID__c = : '+ contactRecord.Patient_CUMB_ID__c);
			System.debug('contactRecord.Patient_Birth_Date__c = : '+ contactRecord.Patient_Birth_Date__c);
			System.debug('contactRecord.FirstName : '+ contactRecord.FirstName);
			System.debug('contactRecord.LastName : '+ contactRecord.LastName);
			System.debug('Existing Contacts sha1Hash_Id = : '+ sha1Hash_Id);
		}

		if(contactToProcessList.size() > 0) {
			//ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
		}
		System.debug('End contact:onBeforeInsert');
	}

	public override void onBeforeUpdate(Map<Id, SObject> oldRecords) {
		System.debug('Start contact:onBeforeUpdate');

		List<Contact> contactList = Records;
		List<Contact>contactToProcessList = new List<Contact>();
		String sha1Hash_Id;

		for(Contact contactRecord : contactList) {

			Contact oldcontact = (Contact)oldRecords.get(contactRecord.Id);
			//TODO: Check if feilds have changed
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					contactRecord.Patient_CUMB_ID__c + '-'
							+ contactRecord.Patient_Birth_Date__c + '-'
							+ contactRecord.FirstName + '-'
							+ contactRecord.LastName
			);
			contactRecord.SHA1Hash_ID__c = sha1Hash_Id;
			System.debug('contactRecord.Patient_CUMB_ID__c = : '+ contactRecord.Patient_CUMB_ID__c);
			System.debug('contactRecord.Patient_Birth_Date__c = : '+ contactRecord.Patient_Birth_Date__c);
			System.debug('contactRecord.FirstName : '+ contactRecord.FirstName);
			System.debug('contactRecord.LastName : '+ contactRecord.LastName);
			System.debug('Existing Contacts sha1Hash_Id = : '+ sha1Hash_Id);
		}

		if(contactToProcessList.size() > 0) {
			//ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
		}
		System.debug('End contact:onBeforeUpdate');
	}
/*
	public override void onAfterUpdate(Map<Id, SObject> oldRecords) {
		System.debug('Start Contact:onAfterUpdate');

		//fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

		List<Contact> contactList = Records;

		Set<Id> contactIdSet = new Set<Id>();
		Map<Id, Contact> contactById = new Map<Id, Contact>();
		CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
		List<Case> casesList = new List<Case>();
		ICases casesDomain = (ICases) PMd_Application.Domain.newInstance(casesList);
		API_User__mdt IntegrationUser = [SELECT Id, Username__c, Profile_Name__c FROM API_User__mdt WHERE Alias__c = 'iuser'];
		String contextUserName = UserInfo.getUserName(); //Returns the context user's login name.
		//String contextUserProfileID = UserInfo.getProfileId(); //Returns the context user's profile ID.

		if(contextUserName != IntegrationUser.Username__c) {

			for (Contact contactRecord : contactList) {
				contactIdSet.add(contactRecord.Id);
				contactById.put(contactRecord.Id, contactRecord);
			}

			//Get all Cases by contactId
			List<Case> casesToUpdateOutFaxList = casesSelector.selectById(contactIdSet);

			for (Case caseRecord : casesToUpdateOutFaxList) {
				caseRecord.Service_Provider_Fax__c = casesDomain.getServiceProviderFax(contactById.get(caseRecord.ContactId));
			}
			update casesToUpdateOutFaxList;
		}

		System.debug('End Contact:onAfterUpdate');
	}
*/
}