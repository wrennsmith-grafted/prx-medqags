/**
 * @description       : Daily_Claims Domain class.
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-11-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 * 1.1   04-28-2022	  Ricardy Banks					   MBP-377 Error out claims when received out of order
 * 1.2   05-02-2022	  Ricardy Banks					   MBP-399 Case Routing Business Logic. Default Case owner to General
 * 
 **/

//All domain classes should utilize inherited sharing so that the caller determines whether it should operate in system context or not. The should
//also extend the fflib_SObjectDomain class
public class Daily_Claims extends fflib_SObjectDomain
		implements IDaily_Claims
//    implements IDaily_Claims, ContactsService.ISupportContacts
{
	private static Integer maxHCPCSCodeSize = 5;
	//The constructor should always accept a list of the SObject type we're creating the domain class for
	//It should then pass this list to the fflib_SObjectDomain class's constructor which is what super(cases) does.
	//This sets the records value in the fflib_SObjectDomain class which is very important
	public Daily_Claims(List<Daily_Claim__c> sObjectList) {
		// Domain classes are initialised with lists to enforce bulkification throughout
		super(sObjectList);
	}

	public static IDaily_Claims newInstance(List<Daily_Claim__c> recordList) {
		return (IDaily_Claims) PMd_Application.Domain.newInstance(recordList);
	}
/*
	public static IDaily_Claims newInstance(Daily_Claim__c record, Daily_Claim_JSONRequest request)
	{
		return (IDaily_Claims) PMd_Application.Domain.newInstance(record, request);
	}
*/
	public static IDaily_Claims newInstance(Set<Id> recordIdSet) {
		return (IDaily_Claims) PMd_Application.Domain.newInstance(recordIdSet);
	}


	/***************************************************************************************************************************************
     * Domain Specific Operations
     **************************************************************************************************************************************/

	private Map<String, CSA__c> csasByCSA_Number = new Map<String, CSA__c>();
	private Map<Id, Contact> existingContactsByDailyClaimId = new Map<Id, Contact>();
	private List<Contact_Drug__c> existingContact_DrugsList = new List<Contact_Drug__c>();
	private List<Claim_Information__c> existingClaim_InformationList = new List<Claim_Information__c>();
	private List<Claim_Information__c> allClaim_InformationList = new List<Claim_Information__c>();
/*
	//Do Post Rest API
	public void doRestAPIPost(List<Daily_Claim__c> recordList) {

	}

	//Do Post Rest API
	void doRestAPIPost(fflib_ISObjectUnitOfWork uow) {

	}
*/
	//Do Post Rest API
	public static Daily_Claim__c newInstance(Daily_Claim_JSONRequest request) {
		Daily_Claim__c dailyClaimInstance = new Daily_Claim__c();

		dailyClaimInstance.CSA_Account__c = FormatterUtilService.textFormatter(request.Account_Number);
		if(request.Adjudicated_NDC_Units_Count != 'null') {
			dailyClaimInstance.Units_Billed__c = Decimal.valueOf(request.Adjudicated_NDC_Units_Count.equals('null') ? '0' : request.Adjudicated_NDC_Units_Count);
		}
		if(request.Allowable_Amount != 'null') {
			dailyClaimInstance.Amount_Paid_By_Primary__c = Decimal.valueOf(request.Allowable_Amount);
		}
		//dailyClaimInstance.Prior_Authorization__c = FormatterUtilService.textFormatter(request.Authorization_Number);
		dailyClaimInstance.Authorized_Representative__c =  FormatterUtilService.textFormatter(request.Authorized_Representative);
		dailyClaimInstance.Authorized_Relationship__c = FormatterUtilService.textFormatter(request.Authorized_Representative_Relationship);
		dailyClaimInstance.Billing_Provider_City__c = FormatterUtilService.textFormatter(request.Billing_Provider_City);
		dailyClaimInstance.Billing_Provider_First_Name__c = FormatterUtilService.textFormatter(request.Billing_Provider_First_Name);
		dailyClaimInstance.Billing_Provider_Last_Name__c = FormatterUtilService.textFormatter(request.Billing_Provider_Last_Name);
		dailyClaimInstance.Billing_Provider_Specialty__c = FormatterUtilService.textFormatter(request.Billing_Provider_Specialty);
		dailyClaimInstance.Billing_Provider_PIN__c = FormatterUtilService.textFormatter(request.Billing_Provider_PIN);
		dailyClaimInstance.Billing_Provider_State__c = FormatterUtilService.textFormatter(request.Billing_Provider_State_Code);
		dailyClaimInstance.Billing_Provider_Address_Line_1__c = FormatterUtilService.textFormatter(request.Billing_Provider_Street_Address_Line_1);
		dailyClaimInstance.Billing_Provider_Zip_Code__c = FormatterUtilService.textFormatter(request.Billing_Provider_Zip_Code);
		dailyClaimInstance.Billing_Provider_Phone__c = FormatterUtilService.phoneFormatter(request.Billing_Provider_Phone);
		dailyClaimInstance.Billing_Provider_Fax__c = FormatterUtilService.phoneFormatter(request.Billing_Provider_Fax);
		dailyClaimInstance.Primary_Claim_Number__c =  FormatterUtilService.textFormatter(request.Claim_Identifier);
		dailyClaimInstance.Claim_Code__c = FormatterUtilService.textFormatter(request.Claim_Indicator);
		dailyClaimInstance.Claim_Line__c =  FormatterUtilService.textFormatter(request.Claim_Line_Identifier);
		dailyClaimInstance.Claim_Segment__c = FormatterUtilService.textFormatter(request.Claim_Segment);
		dailyClaimInstance.COB_Code__c = FormatterUtilService.textFormatter(request.COB_Indicator);
		dailyClaimInstance.CSA_Control__c =  FormatterUtilService.textFormatter(request.Control_Number);
		if(request.Days_Supply != 'null') {
			dailyClaimInstance.Days_Supply__c = Decimal.valueOf(request.Days_Supply);
		}
		dailyClaimInstance.Diagnosis_Code__c = FormatterUtilService.textFormatter(request.Diagnosis_Code);
		dailyClaimInstance.Drug_Label_Name__c = FormatterUtilService.textFormatter(request.Drug_Label_Name);
		dailyClaimInstance.HCPCS_Code__c = FormatterUtilService.textFormatter(request.ICD9_Procedure_Code);
		dailyClaimInstance.NDC__c = FormatterUtilService.textFormatter(request.National_Drug_Code);
		//dailyClaimInstance.PA_Approval_Dates__c = FormatterUtilService.dateFormatter(request.PA_Approval_Dates);
		dailyClaimInstance.Patient_Birth_Date__c = FormatterUtilService.dateFormatter(request.Patient_Birth_Date);
		//dailyClaimInstance.Patient_Email_Address__c = FormatterUtilService.textFormatter(request.Patient_Email_Address);
		dailyClaimInstance.Patient_First_Name__c = FormatterUtilService.textFormatter(request.Patient_First_Name);
		dailyClaimInstance.Patient_Last_Name__c = FormatterUtilService.textFormatter(request.Patient_Last_Name);
		dailyClaimInstance.Patient_Middle_Initial__c = FormatterUtilService.textFormatter(request.Patient_Middle_Initial);
		dailyClaimInstance.Patient_Phone_Number__c = FormatterUtilService.phoneFormatter(request.Patient_Phone_Number);
		dailyClaimInstance.Patient_Gender__c = FormatterUtilService.genderFormatter(request.Patient_Sex);
		dailyClaimInstance.Plan_Sponsor_Name__c = FormatterUtilService.textFormatter(request.Policy_Holder_Name);
		dailyClaimInstance.Previous_Segment__c = FormatterUtilService.textFormatter(request.Previous_Segment_Pointer);
		dailyClaimInstance.Preferred_Provider__c = FormatterUtilService.textFormatter(request.Provider_Indicator);
		if(request.Claim_Adjusted_Amount != 'null') {
			dailyClaimInstance.Claim_Adjustment_Amount__c = Decimal.valueOf(request.Claim_Adjusted_Amount);
		}
		dailyClaimInstance.Coverage_Code_Indicator__c = FormatterUtilService.textFormatter(request.Coverage_Code_Indicator);
		dailyClaimInstance.Date_Of_Service_From__c = FormatterUtilService.dateFormatter(request.Service_From_Date);
		dailyClaimInstance.Service_Provider_Fax__c = FormatterUtilService.phoneFormatter(request.Service_Provider_Fax);
		dailyClaimInstance.Service_Provider_Phone__c = FormatterUtilService.phoneFormatter(request.Service_Provider_Phone);
		dailyClaimInstance.Date_Of_Service_To__c = FormatterUtilService.dateFormatter(request.Service_To_Date);
		dailyClaimInstance.Service_Provider_Address_Line_1__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Address_Line_1);
		dailyClaimInstance.Service_Provider_City__c = FormatterUtilService.textFormatter(request.Servicing_Provider_City);
		dailyClaimInstance.Service_Provider_First_Name__c = FormatterUtilService.textFormatter(request.Servicing_Provider_First_Name);
		dailyClaimInstance.Service_Provider_Last_Name__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Last_Name);
		dailyClaimInstance.Service_Provider_NPI__c = FormatterUtilService.textFormatter(request.Servicing_Provider_National_Provider_Identifier);
		//dailyClaimInstance.Service_Provider_Practice__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Practice_Role_Name);

		System.debug('FormatterUtilService.textFormatter(request.Place_of_Service) = ' + FormatterUtilService.textFormatter(request.Place_of_Service));
		dailyClaimInstance.Place_of_Service__c = FormatterUtilService.textFormatter(request.Place_of_Service);

		dailyClaimInstance.Service_Provider_Zip__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Service_Location_Zip_Code);
		dailyClaimInstance.Service_Provider_Specialty_Code__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Specialty_Code);
		//dailyClaimInstance.Service_Provider_State__c =  FormatterUtilService.truncate(request.Servicing_Provider_State_Code, 2);
		dailyClaimInstance.Service_Provider_State__c =  FormatterUtilService.textFormatter(request.Servicing_Provider_State_Code);
		dailyClaimInstance.Patient_Address_Line_1__c = FormatterUtilService.textFormatter(request.Subscriber_Address_Line_1);
		dailyClaimInstance.Patient_Address_Line_2__c = FormatterUtilService.textFormatter(request.Subscriber_Address_Line_2);
		dailyClaimInstance.Patient_City__c = FormatterUtilService.textFormatter(request.Subscriber_City);
		dailyClaimInstance.Patient_CUMB_ID__c = FormatterUtilService.textFormatter(request.Subscriber_CUMB_ID);
		//dailyClaimInstance.Patient_State__c = FormatterUtilService.truncate(request.Subscriber_State_Code, 2);
		dailyClaimInstance.Patient_State__c = FormatterUtilService.textFormatter(request.Subscriber_State_Code);
		dailyClaimInstance.Patient_Zip_Code__c = FormatterUtilService.textFormatter(request.Subscriber_Zip_Code);
		dailyClaimInstance.CSA_Suffix__c = FormatterUtilService.textFormatter(request.Suffix_Number);
		if(request.Total_Coinsurance_Amount != 'null') {
			dailyClaimInstance.Total_Coinsurance__c = Decimal.valueOf(request.Total_Coinsurance_Amount);
		}
		if(request.Total_Copay_Amount != 'null') {
			dailyClaimInstance.Total_Copay__c = Decimal.valueOf(request.Total_Copay_Amount);
		}
		if(request.Total_Deductible_Amount != 'null') {
			dailyClaimInstance.Total_Deductible__c = Decimal.valueOf(request.Total_Deductible_Amount);
		}
		dailyClaimInstance.Previous_Claim__c = FormatterUtilService.textFormatter(request.Original_UCK_ID);
		dailyClaimInstance.Relationship_Code__c = FormatterUtilService.textFormatter(request.Person_Relationship_Code);

		dailyClaimInstance.Relationship_Code__c = FormatterUtilService.textFormatter(request.Person_Relationship_Code);

		dailyClaimInstance.Plan_Sponsor_Unique_ID__c = FormatterUtilService.textFormatter(request.Plan_Sponsor_Unique_ID);
		dailyClaimInstance.Plan_Letter__c = FormatterUtilService.textFormatter(request.Plan_Letter);
		dailyClaimInstance.Funding_Indicator__c = FormatterUtilService.textFormatter(request.Funding_Indicator);
		dailyClaimInstance.Adjudication_Date__c = FormatterUtilService.dateFormatter(request.Adjudication_Date);
		dailyClaimInstance.Name_Type_Code__c = FormatterUtilService.textFormatter(request.Name_Type_Code);

		System.debug('request.Claim_Identifier = ' + request.Claim_Identifier);
		System.debug('dailyClaimInstance.Primary_Claim_Number__c = ' + dailyClaimInstance.Primary_Claim_Number__c);

		return dailyClaimInstance;
	}

	public static List<RestAPI_JSONResponse> SaveResults(List<Daily_Claim__c> dailyClaimsInsertList, List<Daily_Claim__c> dailyClaimsUpsertList, String JSONString) {

		List<RestAPI_JSONResponse> responses = new List<RestAPI_JSONResponse>();
		Integer recordCount = 0;

		System.debug('dailyClaimsInsertList Count = '+ dailyClaimsInsertList.size());
		//TODO: Use UnitOfWork
		//Insert
		Database.SaveResult[] saveInsertResults = Database.insert(dailyClaimsInsertList, false);

		for (Database.SaveResult sr : saveInsertResults) {
			RestAPI_JSONResponse responseInstance = new RestAPI_JSONResponse();
			if (sr.isSuccess()) {
				responseInstance.status = 'Success';
			} else {
				responseInstance.status = 'Failure';
				if (sr.getErrors().size() > 0) {
					responseInstance.errorMessage = sr.getErrors()[0].getMessage();
				}
			}
			//responseInstance.hbsPatientId = dailyClaimsInsertList[recordCount].HBS_ID__c;
			//responseInstance.caremarkMemberId = dailyClaimsInsertList[recordCount].Patient_CUMB_ID__c;
			responseInstance.prudentInDailyClaimId = dailyClaimsInsertList[recordCount].Prudent_In_Data_Staging_ID__c;
			responses.add(responseInstance);
			recordCount++;
		}

		recordCount = 0;

		//Upsert
		//Schema.SObjectField authNumberField = Daily_Claim__c.Fields.External_Authorization_Number__c;
		//Database.UpsertResult[] saveUpsertResults = Database.upsert(dailyClaimsUpsertList, authNumberField, false);
		Database.UpsertResult[] saveUpsertResults = Database.upsert(dailyClaimsUpsertList, false);
		for (Database.UpsertResult sr : saveUpsertResults) {
			RestAPI_JSONResponse responseInstance = new RestAPI_JSONResponse();
			if (sr.isSuccess()) {
				responseInstance.status = 'Success';
			} else {
				responseInstance.status = 'Failure';
				if (sr.getErrors().size() > 0) {
					responseInstance.errorMessage = sr.getErrors()[0].getMessage();
					ErrorLog.log('Daily_Claim__c API PrudentRestResource', '', JSONString, '', '', sr.getErrors()[0].getMessage(), null, null, null, null);
				}
			}
			//responseInstance.hbsPatientId = dailyClaimsUpsertList[recordCount].HBS_ID__c;
			//responseInstance.caremarkMemberId = dailyClaimsUpsertList[recordCount].Patient_CUMB_ID__c;
			responseInstance.prudentInDailyClaimId = dailyClaimsUpsertList[recordCount].Prudent_In_Data_Staging_ID__c;
			responses.add(responseInstance);
			recordCount++;
		}

		return responses;
	}

	//Get set of all Daily_Claim AccountNumbers
	public Set<String> getAccountNumbers() {
		Set<String> result = new Set<String>();
		for (Daily_Claim__c record : (List<Daily_Claim__c>) getRecords()) {
			if (record.CSA_Account__c != null) {
				result.add(record.CSA_Account__c);
			}
		}
		return result;
	}

	/**
	 * Process Daily_Claims for the given source records (so long as their domain classes implement ISupportDailyClaims)
	 **/
	/*
	public void process(List<Daily_Claim__c> dailyClaimsList) {

		// Contact Factory helps domain classes produce Contacts
		ContactsService.ContactFactory contactFactory = new ContactsService.ContactFactory(uow);
		// Construct domain class capabile of processing Daily Claims
		fflib_IDomain domain =
				PMd_Application.Domain.newInstance(dailyClaimsList);
		if (domain instanceof ContactsService.ISupportContacts) {

			// Ask the domain object to process its Daily Claims
			ContactsService.ISupportContacts contacts = (ContactsService.ISupportContacts) domain;
			contacts.process(contactFactory);
		}
	}
*/
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

		//Get matching contacts from Daily Claims
		ContactsSelector contactsSelector = (ContactsSelector)PMd_Application.Selector.newInstance(Contact.SObjectType);
		// Use ContactSelector to get matching existing contacts
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
		//Get map of existing Contacts by Daily Claim Id
		Map<Id, Contact> existingContactsByDailyClaimId = mapContactsByDailyClaimId(existingContacts, dailyClaimsList);

		process(contactFactory, existingContactsByDailyClaimId, uow);

		System.debug('End processing Contacts for Daily Claims');
	}
*/
/*
	//Use this method for trigger operations.
	private void process(ContactsService.ContactFactory contactFactory, Map<Id, Contact> existingContactsByDailyClaimId, fflib_ISObjectUnitOfWork uow) {
		System.debug('Start processing Contacts for Daily Claims');
		// Create Contacts from the given Daily Claims
		List<SObject> newContactsList = new List<SObject>();
		List<SObject> existingContactsList = new List<SObject>();
		for(Daily_Claim__c dailyClaim : (List<Daily_Claim__c>) getRecords()) {
			/*
				If Contact does not exists based on logic above:
				Then create Contact, ContactDrug, Claim, and Enrollment Case.
				If Contact does exist based on logic above:
				Then update Contact (refer to mapping document for fields), then check ContactDrug processing logic
			*/
/*			Contact existingContact = existingContactsByDailyClaimId.get(dailyClaim.Id);
			if(existingContact != null) {
				existingContact = mapDailyClaimToContact(dailyClaim, existingContact);
				existingContactsList.add(existingContact);
			} else {
				//Create new Contact form Daily Claim
				Contact newContact = new Contact();
				newContact = mapDailyClaimToContact(dailyClaim, newContact);
				newContactsList.add(newContact);
			}
		}
		uow.registerDirty(existingContactsList);
		uow.registerNew(newContactsList);

		System.debug('End processing Contacts for Daily Claims');
	}

	//Map Daily Claim fields to new Contact fields
	private Contact mapDailyClaimToContact(Daily_Claim__c dailyClaim, Contact contact) {

		contact.CSA_Account__c = dailyClaim.CSA_Account__c;
		contact.FirstName = dailyClaim.Patient_First_Name__c;
		contact.LastName = dailyClaim.Patient_Last_Name__c;
		contact.Patient_Birth_Date__c = dailyClaim.Patient_Birth_Date__c;
		//contact.Patient_Address_Line_1__c = dailyClaim.Patient_Address_Line_1__c;
		contact.MailingCity = dailyClaim.Patient_City__c;
		contact.MailingState = dailyClaim.Patient_State__c;
		contact.Patient_CUMB_ID__c = dailyClaim.Patient_CUMB_ID__c;
		contact.Patient_Gender__c = dailyClaim.Patient_Gender__c;
		contact.Phone = dailyClaim.Patient_Phone_Number__c;

		return contact;
	}
	*/
/*
    public class Constructor implements fflib_IDomainConstructor
	{
		public fflib_SObjects construct(List<Object> objectList)
		{
			return new Daily_Claims((List<SObject>) objectList);
		}
/*
		public fflib_SObjects construct(SObject obj, Object objectInstance)
		{
			return new Daily_Claims((SObject) obj, (Object) objectInstance);
		}
		*/
//	}

	//The name of this inner class must always be Constructor to work appropriately. This acts as a way to use the concept of reflection when initializing
	//this class, despite the fact apex still does not support it.
	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Daily_Claims(sObjectList);
		}
	}
/*
	//Generate map of Contacts By Daily Claim Ids
	Map<Id, Contact> mapContactsByDailyClaimId(List<Contact> existingContactList, List<Daily_Claim__c> dailyClaimsList ) {
		Map<Id, Contact> existingContactsByDailyClaimId = new Map<Id, Contact>();
		for(Daily_Claim__c dailyClaim : dailyClaimsList) {
			for(Contact contact : existingContactList) {
				if(dailyClaim.Patient_First_Name__c == contact.FirstName
						&& dailyClaim.Patient_Last_Name__c == contact.LastName
						&& dailyCLaim.Patient_Birth_Date__c == contact.Patient_Birth_Date__c)
				{
					existingContactsByDailyClaimId.put(dailyClaim.id, contact);
				}
			}
		}
		return existingContactsByDailyClaimId;
	}
*/
	/*
* Method Name: ProcessDailyClaimsBeforeInsert
* Description:
*/
	private void ProcessDailyClaimsBeforeInsert(List<Daily_Claim__c> dailyClaimsList) {
		System.debug('Start processing Daily Claims Before Insert');
		for (Daily_Claim__c dailyClaim : dailyClaimsList) {


		}
		System.debug('Stop processing Daily Claims Before Insert');
	}

	/*
    * Method Name: ProcessDailyClaimsAfterInsert
    * Description:
    */
	public void ProcessDailyClaimsAfterInsert(List<Daily_Claim__c> dailyClaimsList, Map<Id, CSA__c> csaByDailyClaimId) {
		System.debug('Start processing Daily Claims After Insert');

		Map<Id, String> csaNumberByDailyClaimId = new Map<Id, String>();

		// Create unit of work to capture work and commit it under one transaction
		fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();
		//Instantiate a new UnitOfWork
		fflib_ISObjectUnitOfWork uowAfterTx = PMd_Application.UnitOfWork.newInstance();

		for(Daily_Claim__c dailyClaimRecord : dailyClaimsList) {
			csaNumberByDailyClaimId.put(dailyClaimRecord.Id, dailyClaimRecord.CSA_Number__c);
		}

		//Get Map of CSAs By CSA_Number
		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		//csaByDailyClaimId = cSAsDomain.getCSAsById(dailyClaimIdByCSANumber);
		csasByCSA_Number = cSAsDomain.getCSAsByCSANumber(csaNumberByDailyClaimId);
		System.debug('csasByCSA_Number = ' +csasByCSA_Number);

		//Return the Map<Id, Contact> existingContactsByDailyClaimId so getExistingContactsByDailyClaimId won't need to be call more than once. This will reduce the SOQL calls & increase performance.
		processDailyClaimContacts(dailyClaimsList, uow);
		try {
			uow.commitWork();

			//Instantiate a new UnitOfWork
			uow = PMd_Application.UnitOfWork.newInstance();
			//Process ContactDrugs for Daily Claims
			processDailyClaimContactDrugs(dailyClaimsList, uow);
		}catch(Exception e){
			/*
			Integer numErrors = e.getNumDml();
			System.debug('getNumDml=' + numErrors);
			for(Integer i=0;i<numErrors;i++) {
				System.debug('getDmlId=' + e.getDmlId(i));
				System.debug('getDmlFieldNames=' + e.getDmlFieldNames(i));
				System.debug('getDmlMessage=' + e.getDmlMessage(i));
			}
			*/
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Daily_Claims.ProcessDailyClaimsAfterInsert.processDailyClaimContacts', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), dailyClaimsList[0].Id, null, null, null);
			ErrorLog.commitLogs();
			//throw e;
		}

		try {
			uow.commitWork();

			//Instantiate a new UnitOfWork
			uow = PMd_Application.UnitOfWork.newInstance();
			//Process Claims for Daily Claims
			processDailyClaimClaim_Informations(dailyClaimsList, uow);
			//Comment the work now so we can get the Contact_Drug & Claim Ids to relate the objects
			//uow.commitWork();
		}catch(Exception e){
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Daily_Claims.ProcessDailyClaimsAfterInsert.processDailyClaimContactDrugs', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), dailyClaimsList[0].Id, null, null, null);
			ErrorLog.commitLogs();
			//throw e;
		}

		processDailyClaimCases(dailyClaimsList, uow, uowAfterTx);

		// Commit updates to all Daily Claim related Objects
		try {
			uowAfterTx.commitWork();
		}catch(Exception e){
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Daily_Claims.ProcessDailyClaimsAfterInsert.processDailyClaimCases', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), dailyClaimsList[0].Id, null, null, null);
			ErrorLog.commitLogs();
			//throw e;
		}
		System.debug('Stop processing Daily Claims After Insert');
	}

	public void processDailyClaimContacts(List<Daily_Claim__c> dailyClaimsList, fflib_ISObjectUnitOfWork uow) {
		System.debug('In Daily_Claims:processDailyClaimContacts - Start processing Contacts for Daily Claims');

		//IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
		//List<Contact> existingContacts = getExistingDailyClaimContacts(dailyClaimsList);
		//Map<Id, Contact> existingContactsByDailyClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimsList);
		//System.debug('existingContactsByDailyClaimId Count: ' + existingContactsByDailyClaimId.size());
		//List<Contact> existingContacts = existingContactsByDailyClaimId.values();
/*
		for (Contact contactRecord : existingContacts) {
			existingContactRecordIds.add(contactRecord.Id);
		}
		*/
		//Create a DomainFactor that used the SObjectType like the Selector factory
		//IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(existingContacts);
		List<Contact> contactList = new List<Contact>();
		IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
		//Use ContactSelector to get matching existing contacts
		/*
			Look for an existing member based on: Add tiered matching logic.
				Subscriber CUMB ID
				Patient Birth Date
				Patient Last Name
				Patient First Name
		 */
		//Map<Id, Contact> existingDailyClaimContactsById = new Map<Id, Contact>(existingContacts);
		//Get map of existing Contacts by Daily Claim Id
		//Map<Id, Contact> existingContactsByDailyClaimId = mapContactsByDailyClaimId(existingContacts, dailyClaimsList);
		//Map<Id, Contact> existingContactsByDailyClaimId = contactsDomain.mapContactsByDailyClaimId(existingContacts, dailyClaimsList);

		//Process Contacts for Daily Claims
		//processDailyClaimContacts(dailyClaimsList, existingContactsByDailyClaimId, uow);

		existingContactsByDailyClaimId = contactsDomain.process(dailyClaimsList, csasByCSA_Number, uow);
		System.debug('existingContactsByDailyClaimId = ' + existingContactsByDailyClaimId);

		System.debug('In Daily_Claims:processDailyClaimContacts - Stop processing Contacts for Daily Claims');
	}

	public void processDailyClaimContactDrugs(List<Daily_Claim__c> dailyClaimsList, fflib_ISObjectUnitOfWork uow) {

		System.debug('In Daily_Claims:processDailyClaimContactDrugs - Start processing Contact_Drugs for Daily Claims');

		//List<Contact> contactList = new List<Contact>();
		//IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
		//List<Contact> existingContacts = getExistingDailyClaimContacts(dailyClaimsList);
		//Map<Id, Contact> existingContactsByDailyClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimsList);
		//System.debug('existingContactsByDailyClaimId Count: ' + existingContactsByDailyClaimId.size());
		//List<Contact> existingContacts = existingContactsByDailyClaimId.values();
		List<Contact_Drug__c> contact_DrugsList = new List<Contact_Drug__c>();

		// ContactDrug Factory helps domain classes produce Contact_drugs
		//Create ContactDrugsService.ContactDrugsFactory class
		//ContactDrugsService.ContactDrugsFactory contactDrugFactory = new ContactDrugsService.ContactDrugsFactory (uow);
		IContact_Drugs contact_DrugsDomain = (IContact_Drugs) PMd_Application.Domain.newInstance(contact_DrugsList);

		//Process Contacts for Daily Claims
		//processDailyClaimContacts(dailyClaimsList, existingContactsByDailyClaimId, uow);

		//process(contactDrugFactory, existingContactsByDailyClaimId, uow);
		existingContact_DrugsList = contact_DrugsDomain.process(dailyClaimsList, existingContactsByDailyClaimId, uow);
		System.debug('processDailyClaimContactDrugs: existingContact_DrugsList Count = ' + existingContact_DrugsList.size());

		System.debug('In Daily_Claims:processDailyClaimContactDrugs - Stop processing Contact_Drugs for Daily Claims');
	}

	public void processDailyClaimClaim_Informations(List<Daily_Claim__c> dailyClaimsList, fflib_ISObjectUnitOfWork uow) {

		System.debug('In Daily_Claims:processDailyClaimClaim_Informations - Start processing Claim_Informations for Daily Claims');

		List<Claim_Information__c> claim_InformationsList = new List<Claim_Information__c>();
		IClaim_Informations claim_InformationsDomain = (IClaim_Informations) PMd_Application.Domain.newInstance(claim_InformationsList);

		System.debug('dailyClaimsList Count = ' + dailyClaimsList.size());
		System.debug('processDailyClaimClaim_Informations: existingContact_DrugsList Count = ' + existingContact_DrugsList.size());
		existingClaim_InformationList = claim_InformationsDomain.process(dailyClaimsList,
																			existingContactsByDailyClaimId,
																			existingContact_DrugsList,
																			uow
		);
		System.debug('processDailyClaimClaim_Informations: existingClaim_InformationList Count = ' + existingClaim_InformationList.size());

		System.debug('In Daily_Claims:processDailyClaimClaim_Informations - Stop processing Claim_Informations for Daily Claims');
	}

	public void processDailyClaimCases(List<Daily_Claim__c> dailyClaimsList, fflib_ISObjectUnitOfWork uowBeforeTx, fflib_ISObjectUnitOfWork uowAfterTx) {

		System.debug('In Daily_Claims:processDailyClaimCases - Start processing Cases for Daily Claims');

		System.debug('processDailyClaimCases: dailyClaimsList Count = ' + dailyClaimsList.size());
		//System.debug('processDailyClaimCases: existingClaim_InformationList Count = ' + existingClaim_InformationList.size());

		List<Case> casesList = new List<Case>();
		ICases casesDomain = (ICases) PMd_Application.Domain.newInstance(casesList);

		casesDomain.process(dailyClaimsList,
							csasByCSA_Number,
							existingContactsByDailyClaimId,
							existingContact_DrugsList,
							//existingClaim_InformationList,
							uowBeforeTx,
							uowAfterTx
		);

		System.debug('In Daily_Claims:Daily_Claims:processDailyClaimCases - Stop processing Cases for Daily Claims');
	}
/*
	private Map<Id, Contact> getExistingContactsByDailyClaimId(List<Daily_Claim__c> dailyClaimsList) {

		Set<Id> dailyClaimsRecordIds = new Set<Id>();
		Set<Id> existingContactRecordIds = new Set<Id>();
		String sha1Hash_Id;
		Set<String> sha1Hash_IdSet = new Set<String>();
		List<Claim_Information__c> existingClaim_InformationsList;
		List<Contact> existingClaim_InformationContactsList;
		Set<String> primary_Claim_NumberSet = new Set<String>();
		List<Contact> existingSha1Hash_IdMatchedContactsList;
		Map<Id, Contact> existingContactsById = new Map<Id, Contact>();
		Map<Id, Contact> existingContactsByDailyClaimsId = new Map<Id, Contact>();

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
	/*
		Map<Id, String> sha1Hash_IdByDailyClaimId = new Map<Id, String>();
		for (Daily_Claim__c dailyClaim : dailyClaimsList) {
			//get all Daily Claim Ids
			dailyClaimsRecordIds.add(dailyClaim.Id);
			//get all Daily Claim Contact matching Sha1Had_Ids
			sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
					dailyClaim.Patient_CUMB_ID__c
							+ dailyClaim.Patient_Birth_Date__c
							+ dailyClaim.Patient_First_Name__c
							+ dailyClaim.Patient_Last_Name__c
			);
			sha1Hash_IdSet.add(sha1Hash_Id);
			System.debug('dailyClaim.Patient_CUMB_ID__c = : ' + dailyClaim.Patient_CUMB_ID__c);
			System.debug('dailyClaim.Patient_Birth_Date__c = : ' + dailyClaim.Patient_Birth_Date__c);
			System.debug('dailyClaim.Patient_First_Name__c : ' + dailyClaim.Patient_First_Name__c);
			System.debug('dailyClaim.Patient_First_Name__c : ' + dailyClaim.Patient_First_Name__c);
			System.debug('Existing Contacts sha1Hash_Id = : ' + sha1Hash_Id);
			//get all Daily Claim Primary_Claim_Number__c that will match Claim Primary_Claim_Number__c
			primary_Claim_NumberSet.add(dailyClaim.Primary_Claim_Number__c);
			sha1Hash_IdByDailyClaimId.put(dailyClaim.Id, sha1Hash_Id);
			System.debug('dailyClaim.Primary_Claim_Number__c ' + dailyClaim.Primary_Claim_Number__c);
		}

		Claim_InformationsSelector claimInformationSelector = (Claim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);
		existingClaim_InformationsList = claimInformationSelector.selectByPrimary_Claim_Number(primary_Claim_NumberSet);
		System.debug('existingClaim_InformationsList Count: ' + existingClaim_InformationsList.size());

		ContactsSelector contactsSelector = (ContactsSelector) PMd_Application.Selector.newInstance(Contact.SObjectType);
		existingSha1Hash_IdMatchedContactsList = contactsSelector.selectBySHA1Hash_ID(sha1Hash_IdSet);
		System.debug('existingSha1Hash_IdMatchedContactsList Count: ' + existingSha1Hash_IdMatchedContactsList.size());

		Map<String, Id> dailyClaimIdByClaim_InformationId = new Map<String, Id>();
		Map<String, Id> dailyClaimIdByContactSha1Hash_Id = new Map<String, Id>();
		//Map dailyClaimIdByClaim_InformationId & dailyClaimIdByContactSha1Hash_Id
		for (Daily_Claim__c dailyClaim : dailyClaimsList) {
			if(dailyClaim.Primary_Claim_Number__c != null) {
				dailyClaimIdByClaim_InformationId.put(dailyClaim.Primary_Claim_Number__c, dailyClaim.Id);
				System.debug('Claim_InformationId => dailyClaimId = ' + dailyClaimIdByClaim_InformationId);
			}
			String contactsha1Hash_Id = sha1Hash_IdByDailyClaimId.get(dailyClaim.Id);
			if(contactsha1Hash_Id != null) {
				dailyClaimIdByContactSha1Hash_Id.put(contactsha1Hash_Id, dailyClaim.Id);
				System.debug('ContactSha1Hash_Id => dailyClaimId = ' + dailyClaimIdByContactSha1Hash_Id);
			}
		}

		for(Claim_Information__c existingClaim_Information : existingClaim_InformationsList) {
			if(existingClaim_Information.Contact__c != null) {
				existingContactsById.put(existingClaim_Information.Contact__c, new Contact(Id = existingClaim_Information.Contact__c));
				System.debug('ContactId => existingContacts = ' + existingContactsById);
			}
			Id dailyCliamId = dailyClaimIdByClaim_InformationId.get(existingClaim_Information.Id);
			existingContactsByDailyClaimsId.put(dailyCliamId, new Contact(Id = existingClaim_Information.Contact__c));
			System.debug('existingContact => dailyCliamId = ' + existingContactsByDailyClaimsId);
		}

		for(Contact existingSha1Hash_IdMatchedContact : existingSha1Hash_IdMatchedContactsList) {
			//existingContactsById.put(existingSha1Hash_IdMatchedContact.Id, existingSha1Hash_IdMatchedContact);
			String contactSha1Hash_Id = existingSha1Hash_IdMatchedContact.SHA1Hash_ID__c;
			Id dailyClaimId = dailyClaimIdByContactSha1Hash_Id.get(contactSha1Hash_Id);
			existingContactsByDailyClaimsId.put(dailyClaimId, existingSha1Hash_IdMatchedContact);
			System.debug('existingContact => dailyCliamId = ' + existingContactsByDailyClaimsId);
		}

		System.debug('Existing Contacts Count: ' + existingContactsByDailyClaimsId.values().size());
		return existingContactsByDailyClaimsId;
	}
*/
/*
	private void processDailyClaimContacts(List<Daily_Claim__c> dailyClaimsList,
			Map<Id, Contact> existingContactsByDailyClaimId, fflib_ISObjectUnitOfWork uow) {
		System.debug('Start processing Contacts for Daily Claims');
		// Contact Factory helps domain classes produce Contacts
		ContactsService.ContactFactory contactFactory = new ContactsService.ContactFactory(uow);

		// Construct domain class capable of processing contacts for Daily Claims
		/*
		fflib_IDomain domain =
				PMd_Application.Domain.newInstance(existingDailyClaimContactsById.values());
		// Ask the domain object to process its Daily Claims
		ContactsService.ISupportContacts contacts = (ContactsService.ISupportContacts) domain;
		contacts.process(contactFactory);
		*/
/*
		process(contactFactory, existingContactsByDailyClaimId, uow);
		System.debug('Stop processing Contacts for Daily Claims');
	}
*/
/*
	private void processDailyClaimClaims(List<Daily_Claim__c> dailyClaimsList, fflib_ISObjectUnitOfWork uow) {

		// Claim Factory Factory helps domain classes produce Claims
		//Create ClaimsService.ClaimsFactory class
		//CliamsService.ClaimFactory claimFactory = new ClaimsService.ClaimFactory (uow);

		//Create process method to process Claims
		//process(claimFactory, uow);
	}
*/
	/*
	public Map<Id, CSA__c> getCSAsByDailyClaimId(Map<String, Id> dailyClaimIdByCSANumber) {
		Map<Id, CSA__c> csasByDailyClaimIds = new Map<Id, CSA__c>();

		CSAsSelector csasSelector = (CSAsSelector)PMd_Application.Selector.newInstance(CSA__c.SObjectType);
		List<CSA__c> matchingDailyClaimCSA_NumbersList = csasSelector.selectByCSANumber(dailyClaimIdByCSANumber.keySet());
		System.debug('matchingDailyClaimCSA_NumbersList Count = ' + matchingDailyClaimCSA_NumbersList.size());
		for(CSA__c csaRecord : matchingDailyClaimCSA_NumbersList) {
			csasByDailyClaimIds.put(dailyClaimIdByCSANumber.get(csaRecord.CSA_Number__c), csaRecord);
			System.debug('csaRecord.CSA_Number__c = ' + csaRecord.CSA_Number__c);
			System.debug('dailyClaimIdByCSANumber.get(csaRecord.CSA_Number__c) = ' + dailyClaimIdByCSANumber.get(csaRecord.CSA_Number__c));
		}

		return csasByDailyClaimIds;
	}
*/
/*
* Method Name: ProcessMemberDrugsAfterUpdate
* Description:
*/
	/*
	public static void ProcessContactDrugsAfterUpdate(List<Contacts> LstToProcess) {
		for(Contacts contactInstance : LstToProcess){

		}
	}
*/

	/***************************************************************************************************************************************
     * Trigger Operations
     **************************************************************************************************************************************/
//    public override void processAfterInsert(){
	public override void onBeforeInsert() {
		System.debug('Start Daily_Claims:onBeforeInsert');
		//List<Member_Drug__c> lstMemberDrug = Trigger.new;
		List<Daily_Claim__c> dailyClaimsList = Records;
		List<Daily_Claim__c> daily_ClaimsToProcessList = new List<Daily_Claim__c>();
		CSA__c casInstance = new CSA__c();
		Map<Id, CSA__c> csaByDailyClaimId = new Map<Id, CSA__c>();
		//Map<String, Id> dailyClaimIdByCSANumber = new Map<String, Id>();
		String claim_NumberSeed, HCPCSCodeTrunc;
		Set<String>  dailyClaimCSANumberSet = new Set<String>();
		Set<String> dailyClaimHCPCSet = new Set<String>();
		Set<String> drugHCPCSet = new Set<String>();
		Set<String> drugNDCSet = new Set<String>();
		Set<String> csaSet = new Set<String>();

		Set<String> primary_Claim_NumberSet = new Set<String>();
		Set<String> claim_SegmentSet = new Set<String>();
		Set<String> claim_LineSet = new Set<String>();
		Set<String> previous_SegmentSet = new Set<String>();
		Set<String> claim_NumberSet = new Set<String>();

		List<Claim_Information__c> originalClaim_InformationList;
		List<Claim_Information__c> existingClaim_InformationList;
		//List<Claim_Information__c> existingClaimToBeReplacedList;
		//List<Claim_Information__c> allClaim_InformationList = new List<Claim_Information__c>();
		Map<String, Claim_Information__c> claimByClaim_Number = new Map<String, Claim_Information__c>();
		Map<Id, String> claim_NumberByDailyClaimId = new Map<Id, String>();
		Map<String, Drug__c> drugByHCPCS = new Map<String, Drug__c>();
		Map<String, Id> drugIdByNDC = new Map<String, Id>();
		Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
		Drug__c drugRecord;

		for(Daily_Claim__c dailyClaimInstance : dailyClaimsList){

			//NOTE: I don't believe this is used anywhere & is replaced by the Claim_Number__c
			dailyClaimInstance.External_Prior_Authorization__c = SHA1UtilService.getBase64SHA1Hash(
					dailyClaimInstance.Claim_Code__c + '-' +
							dailyClaimInstance.Claim_Line__c + '-' +
							dailyClaimInstance.NDC__c
			);
			dailyClaimInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
					dailyClaimInstance.CSA_Control__c + '-' +
							dailyClaimInstance.CSA_Suffix__c + '-' +
							dailyClaimInstance.CSA_Account__c
			);
			if(dailyClaimInstance.Previous_Segment__c == null || dailyClaimInstance.Previous_Segment__c == '') {
				claim_NumberSeed = dailyClaimInstance.Primary_Claim_Number__c + '-' +
						dailyClaimInstance.Claim_Segment__c + '-' +
						dailyClaimInstance.Claim_Line__c;
			} else {
				claim_NumberSeed = dailyClaimInstance.Primary_Claim_Number__c + '-' +
						dailyClaimInstance.Previous_Segment__c + '-' +
						dailyClaimInstance.Claim_Line__c;
			}
			dailyClaimInstance.Claim_Number__c = SHA1UtilService.getBase64SHA1Hash(claim_NumberSeed);
			System.debug('dailyClaimInstance.CSA_Number__c = '+ dailyClaimInstance.CSA_Number__c);
			System.debug('dailyClaimInstance.Claim_Number__c = '+ dailyClaimInstance.Claim_Number__c);
		}

		for(Daily_Claim__c dailyClaimRecord : dailyClaimsList){
			//dailyClaimIdByCSANumber.put(dailyClaimRecord.CSA_Number__c, dailyClaimRecord.Id);
			System.debug('dailyClaimRecord.HCPCS_Code__c = '+ dailyClaimRecord.HCPCS_Code__c);
			dailyClaimCSANumberSet.add(dailyClaimRecord.CSA_Number__c);
			HCPCSCodeTrunc = dailyClaimRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			dailyClaimHCPCSet.add(HCPCSCodeTrunc);
			System.debug('dailyClaimRecord.CSA_Number__c = ' + dailyClaimRecord.CSA_Number__c);
			System.debug('dailyClaimRecord.Id = ' + dailyClaimRecord.Id);
		}
		System.debug('dailyClaimCSANumberSet = ' + dailyClaimCSANumberSet);
		System.debug('dailyClaimHCPCSet = ' + dailyClaimHCPCSet);

		DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
		List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(dailyClaimHCPCSet);
		for(Drug__c drug : drugList) {
			if(drug.Coding_Level__c == 'HCPCS') {
				HCPCSCodeTrunc = drug.J_Code__c.substring(0, maxHCPCSCodeSize);
				drugByHCPCS.put(HCPCSCodeTrunc, drug);
			}
			drugHCPCSet.add(drug.J_Code__c);
			drugById.put(drug.Id, drug);
			System.debug('drugRecord.J_Code__c = ' + drug.J_Code__c);
		}
		System.debug('drugHCPCSet = ' + drugHCPCSet);

		NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
		List<NDC__c> ndcList =  ndcsSelector.selectByDrugId(drugById.keySet());

		for(NDC__c ndcRecord : ndcList) {
			HCPCSCodeTrunc = ndcRecord.Drug__r.J_Code__c.substring(0, maxHCPCSCodeSize);
			System.debug('ndcRecord.Drug__r.Coding_Level__c = ' + ndcRecord.Drug__r.Coding_Level__c);
			System.debug('ndcRecord.Drug__r.J_Code__c = ' + HCPCSCodeTrunc);
			System.debug('ndcRecord.Name = ' + ndcRecord.Name);
			drugIdByNDC.put(ndcRecord.Name, ndcRecord.Drug__c);
			if(ndcRecord.Name != '') {
				drugNDCSet.add(ndcRecord.Name);
			}
		}

		CSAsSelector csasSelector = (CSAsSelector)PMd_Application.Selector.newInstance(CSA__c.SObjectType);
		List<CSA__c> matchingCSA_NumbersList = csasSelector.selectByCSANumber(dailyClaimCSANumberSet);
		for(CSA__c csaRecord : matchingCSA_NumbersList) {
			csaSet.add(csaRecord.CSA_Number__c);
			System.debug('csaRecord.CSA_Number__c = ' + csaRecord.CSA_Number__c);
		}
		System.debug('csaSet = ' + csaSet);

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
				//newPrevious_SegmentByClaimId.put(dailyClaim.Id, dailyClaim.Previous_Segment__c);
			}

			//claim_NumberSeed = dailyClaim.Claim_Number__c;
			System.debug('claim_NumberSeed = ' +claim_NumberSeed);
			String claim_NumberHashCode = SHA1UtilService.getBase64SHA1Hash(claim_NumberSeed);
			System.debug('claim_NumberHashCode = ' + claim_NumberHashCode);
			claim_NumberByDailyClaimId.put(dailyClaim.Id, claim_NumberHashCode);
			claim_NumberSet.add(claim_NumberHashCode);
		}

		//Get matching existing Claims from Daily Claims
		Claim_InformationsSelector claim_InformationsSelector = (Claim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);
		originalClaim_InformationList = claim_InformationsSelector.selectOriginalClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet);
		//existingClaim_InformationList = claim_InformationsSelector.selectExistingClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet, Previous_SegmentSet);
		existingClaim_InformationList = claim_InformationsSelector.selectExistingClaimsByUniquekey(claim_NumberSet);
		//Collect matching existing Claims that will be replaced with Replacement claims
		//existingClaimToBeReplacedList = claim_InformationsSelector.selectExistingClaimsByUCKID(replacementClaimByUCKID.keySet());
		allClaim_InformationList.addAll(originalClaim_InformationList);
		allClaim_InformationList.addAll(existingClaim_InformationList);
		//allClaim_InformationList.addAll(existingClaimToBeReplacedList);
		System.debug('originalClaim_InformationList Count: ' + originalClaim_InformationList.size());
		System.debug('existingClaim_InformationList Count: ' + existingClaim_InformationList.size());
		//System.debug('existingClaimToBeReplacedList Count: ' + existingClaimToBeReplacedList.size());
		//System.debug('allClaim_InformationList Count: ' + allClaim_InformationList.size());

		for (Claim_Information__c claimRecord : allClaim_InformationList) {
			claimByClaim_Number.put(claimRecord.Claim_Number__c, claimRecord);
		}

		//Process the criteria for Daily Claims to Process Before Insert
		//Create CSA__c Selector
		//Create CAS__c Selector method that returns a Map of CAS__c records by dailyCliamIds
		/*
		If HCPCS (Drug) does not exist, then don’t process record and set:
		Status [NEW FIELD] to “Error”
		Error Log [NEW FIELD] to “HCPCS Mismatch.” Dependent and connected to the Status field.
		If Control, Suffix, Account (CSA Object) does not exist, then don’t process record and set:
		Status [NEW FIELD] to “Error”
		Error Log [NEW FIELD] to “CSA Mismatch.” Dependent and connected to the Status field.
		*/
		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		String HCPCSCode;
		Integer maxHCPCSCodeSize = 5;
		//csaByDailyClaimId = cSAsDomain.getCSAsById(dailyClaimIdByCSANumber);

		for(Daily_Claim__c dailyClaim : dailyClaimsList) {

			Claim_Information__c claimRecord = claimByClaim_Number.get(claim_NumberByDailyClaimId.get(dailyClaim.Id));
			HCPCSCode = dailyClaim.HCPCS_Code__c;
			if(HCPCSCode != null
					) {
				HCPCSCodeTrunc = HCPCSCode.substring(0, maxHCPCSCodeSize);
			}
			System.debug('HCPCS_Code__c = ' + HCPCSCode);
			System.debug('HCPCSCodeTrunc = ' + HCPCSCodeTrunc);
			System.debug('NDC__c = ' + dailyClaim.NDC__c);
			System.debug('drugNDCSet = ' + drugNDCSet);
			//Error out HCPCS Mismatch claims when HCPCS drug code is not found in Drug list
			Boolean drugFound = false;
			drugRecord = drugById.get(drugIdByNDC.get(dailyClaim.NDC__c));
			if(drugNDCSet.contains(dailyClaim.NDC__c) && drugRecord != null && drugRecord.Coding_Level__c == 'HCPCS + NDC') {
				drugRecord = drugById.get(drugIdByNDC.get(dailyClaim.NDC__c));
				drugFound = true;
			} else {
				drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
				if (drugRecord != null && drugHCPCSet.contains(HCPCSCodeTrunc) && drugRecord.Coding_Level__c == 'HCPCS') {
					drugFound = true;
					drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
				}
			}
			System.debug('drugRecord = ' + drugRecord);
			System.debug('drugFound = ' + drugFound);

			if(dailyClaim.HCPCS_Code__c == null
					|| dailyClaim.HCPCS_Code__c.equals('')
					|| !drugFound
				)
			{
				dailyClaim.Status__c = 'Error';
				dailyClaim.Error_Log__c = 'HCPCS Mismatch';
			//Error out CSA Mismatch claims when CSA is not found in CSA list
			} else if(!csaSet.contains(dailyClaim.CSA_Number__c)) {
				dailyClaim.Status__c = 'Error';
				dailyClaim.Error_Log__c = 'CSA Mismatch';
			}  else {
				//Map the Daily Claim Drug_Label_Name from the Drug Name
				dailyClaim.Drug_Label_Name__c = drugRecord.Name;
				//Error out claims when received out of order
				if(claimRecord == null
						&& String.isBlank(dailyClaim.Previous_Segment__c) //Avoid any orphan Claims when daily claim attempting to update a claim & the member had no initial claim where Previous_Segment was null
						|| (dailyClaim.Claim_Code__c == 'O'
							&& dailyClaim.Previous_Segment__c =='00'
							&& dailyClaim.Claim_Segment__c == '01') //MED-1853: Ingest New Claims with O Status and 01 Segment if they have 00 previous segment as new claims
				) {
					System.debug('A new claim will be created.');
					daily_ClaimsToProcessList.add(dailyClaim);
				} else if (claimRecord != null) { // if (dailyClaim.Previous_Claim__c == null) {
					System.debug('An existing claim will be updated.');
					System.debug('dailyClaim.Drug_Label_Name__c = ' + dailyClaim.Drug_Label_Name__c);
					daily_ClaimsToProcessList.add(dailyClaim);
				} else {
					dailyClaim.Status__c = 'Error';
					dailyClaim.Error_Log__c = 'Previous segment not found';
				}
			}
			System.debug('dailyClaim.Status__c = ' + dailyClaim.Status__c);
			System.debug('dailyClaim.Error_Log__c = ' + dailyClaim.Error_Log__c);
		}

		if(daily_ClaimsToProcessList.size() > 0) {
			ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
		}
		System.debug('End Daily_Claims:onBeforeInsert');
	}

//    public override void processAfterInsert(){
	public override void onAfterInsert() {
		System.debug('Start Daily_Claims:onAfterInsert');
		//List<Member_Drug__c> lstMemberDrug = Trigger.new;
		List<Daily_Claim__c> dailyClaimsList = Records;
		List<Daily_Claim__c> daily_ClaimsToProcessList = new List<Daily_Claim__c>();
		CSA__c casInstance = new CSA__c();
		Map<Id, CSA__c> csaByDailyClaimId = new Map<Id, CSA__c>();
		//Map<String, Id> dailyClaimIdByCSANumber = new Map<String, Id>();
		String claim_NumberSeed, HCPCSCodeTrunc;
		Set<String>  dailyClaimCSANumberSet = new Set<String>();
		Set<String> dailyClaimHCPCSet = new Set<String>();
		Set<String> drugHCPCSet = new Set<String>();
		Set<String> drugNDCSet = new Set<String>();
		Set<String> csaSet = new Set<String>();

		Set<String> primary_Claim_NumberSet = new Set<String>();
		Set<String> claim_SegmentSet = new Set<String>();
		Set<String> claim_LineSet = new Set<String>();
		Set<String> previous_SegmentSet = new Set<String>();
		Set<String> claim_NumberSet = new Set<String>();

		List<Claim_Information__c> originalClaim_InformationList;
		List<Claim_Information__c> existingClaim_InformationList;
		//List<Claim_Information__c> existingClaimToBeReplacedList;
		//List<Claim_Information__c> allClaim_InformationList = new List<Claim_Information__c>();
		Map<String, Claim_Information__c> claimByClaim_Number = new Map<String, Claim_Information__c>();
		Map<Id, String> claim_NumberByDailyClaimId = new Map<Id, String>();
		Map<String, Drug__c> drugByHCPCS = new Map<String, Drug__c>();
		Map<String, Id> drugIdByNDC = new Map<String, Id>();
		Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();

		for(Daily_Claim__c dailyClaimRecord : dailyClaimsList){
			//dailyClaimIdByCSANumber.put(dailyClaimRecord.CSA_Number__c, dailyClaimRecord.Id);
			dailyClaimCSANumberSet.add(dailyClaimRecord.CSA_Number__c);
			HCPCSCodeTrunc = dailyClaimRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			dailyClaimHCPCSet.add(HCPCSCodeTrunc);
			System.debug('dailyClaimRecord.CSA_Number__c = ' + dailyClaimRecord.CSA_Number__c);
			System.debug('dailyClaimRecord.Id = ' + dailyClaimRecord.Id);
		}

		DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
		List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(dailyClaimHCPCSet);
		for(Drug__c drugRecord : drugList) {
			HCPCSCodeTrunc = drugRecord.J_Code__c.substring(0, maxHCPCSCodeSize);
			if(drugRecord.Coding_Level__c == 'HCPCS') {
				drugByHCPCS.put( drugRecord.J_Code__c, drugRecord);
			}
			drugHCPCSet.add( drugRecord.J_Code__c);
			drugById.put(drugRecord.Id, drugRecord);
			System.debug('drugHCPCSet = ' + drugHCPCSet);
		}
		System.debug('drugHCPCSet = ' + drugHCPCSet);

		NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
		List<NDC__c> ndcList =  ndcsSelector.selectByDrugId(drugById.keySet());

		for(NDC__c ndcRecord : ndcList) {
			HCPCSCodeTrunc = ndcRecord.Drug__r.J_Code__c.substring(0, maxHCPCSCodeSize);
			System.debug('ndcRecord.Drug__r.Coding_Level__c = ' + ndcRecord.Drug__r.Coding_Level__c);
			System.debug('ndcRecord.Drug__r.J_Code__c = ' + HCPCSCodeTrunc);
			System.debug('ndcRecord.Name = ' + ndcRecord.Name);
			drugIdByNDC.put(ndcRecord.Name, ndcRecord.Drug__c);
			if(ndcRecord.Name != '') {
				drugNDCSet.add(ndcRecord.Name);
			}
		}

		CSAsSelector csasSelector = (CSAsSelector)PMd_Application.Selector.newInstance(CSA__c.SObjectType);
		List<CSA__c> matchingCSA_NumbersList = csasSelector.selectByCSANumber(dailyClaimCSANumberSet);
		for(CSA__c csaRecord : matchingCSA_NumbersList) {
			csaSet.add(csaRecord.CSA_Number__c);
			System.debug('csaRecord.CSA_Number__c = ' + csaRecord.CSA_Number__c);
		}
		System.debug('csaSet = ' + csaSet);

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
				//newPrevious_SegmentByClaimId.put(dailyClaim.Id, dailyClaim.Previous_Segment__c);
			}

			//claim_NumberSeed = dailyClaim.Claim_Number__c;
			System.debug('claim_NumberSeed = ' +claim_NumberSeed);
			String claim_NumberHashCode = SHA1UtilService.getBase64SHA1Hash(claim_NumberSeed);
			System.debug('claim_NumberHashCode = ' + claim_NumberHashCode);
			claim_NumberByDailyClaimId.put(dailyClaim.Id, claim_NumberHashCode);
			claim_NumberSet.add(claim_NumberHashCode);
		}

		//Get matching existing Claims from Daily Claims
		Claim_InformationsSelector claim_InformationsSelector = (Claim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);
		originalClaim_InformationList = claim_InformationsSelector.selectOriginalClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet);
		//existingClaim_InformationList = claim_InformationsSelector.selectExistingClaimsByUniquekey(Primary_Claim_NumberSet, claim_SegmentSet, Claim_LineSet, Previous_SegmentSet);
		existingClaim_InformationList = claim_InformationsSelector.selectExistingClaimsByUniquekey(claim_NumberSet);
		//Collect matching existing Claims that will be replaced with Replacement claims
		//existingClaimToBeReplacedList = claim_InformationsSelector.selectExistingClaimsByUCKID(replacementClaimByUCKID.keySet());
		allClaim_InformationList.addAll(originalClaim_InformationList);
		allClaim_InformationList.addAll(existingClaim_InformationList);
		//allClaim_InformationList.addAll(existingClaimToBeReplacedList);
		System.debug('originalClaim_InformationList Count: ' + originalClaim_InformationList.size());
		System.debug('existingClaim_InformationList Count: ' + existingClaim_InformationList.size());
		//System.debug('existingClaimToBeReplacedList Count: ' + existingClaimToBeReplacedList.size());
		//System.debug('allClaim_InformationList Count: ' + allClaim_InformationList.size());

		for (Claim_Information__c claimRecord : allClaim_InformationList) {
			claimByClaim_Number.put(claimRecord.Claim_Number__c, claimRecord);
		}

		//Process the criteria for Daily Claims to Process After Insert.
		//Create the CSA Domain with onBeforeInsert to generate SAH1 Hash for CSA_Number
		//Create the CAS Selector
		//Create method getCSAByDailyClaimId that generates a Map of CASs by Daily_CliamId. Use the CSA_Number to match.
		/*
		If HCPCS (Drug) does not exist, then don’t process record
		If Control, Suffix, Account (CSA Object) does not exist, then don’t process record
		*/

		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		//Get map of CSA_Number by Daily Claim Id
		//csaByDailyClaimId = cSAsDomain.getCSAsById(dailyClaimIdByCSANumber);

		for(Daily_Claim__c dailyClaim : dailyClaimsList) {
			Claim_Information__c claimRecord = claimByClaim_Number.get(claim_NumberByDailyClaimId.get(dailyClaim.Id));
			HCPCSCodeTrunc = dailyClaim.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			System.debug('HCPCSCodeTrunc = ' + HCPCSCodeTrunc);
			//CSA__c csaRecord = csaBydailyClaimId.get(dailyCLaim.Id);

			System.debug('NDC__c = ' + dailyClaim.NDC__c);
			System.debug('drugNDCSet = ' + drugNDCSet);
			//Don't process HCPCS Mismatch claims when HCPCS drug code is not found in Drug list
			Boolean drugFound = false;
			Drug__c drugRecord = drugById.get(drugIdByNDC.get(dailyClaim.NDC__c));
			if(drugNDCSet.contains(dailyClaim.NDC__c) && drugRecord.Coding_Level__c == 'HCPCS + NDC' && drugRecord != null) {
				drugFound = true;
				System.debug('drugRecord.Coding_Level__c = ' + drugRecord.Coding_Level__c);
			} else {
				drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
				if (drugRecord != null && drugHCPCSet.contains(HCPCSCodeTrunc) && drugRecord.Coding_Level__c == 'HCPCS') {
					drugFound = true;
				}
			}
			System.debug('drugRecord = ' + drugRecord);
			System.debug('drugFound = ' + drugFound);

			if(dailyClaim.HCPCS_Code__c == null
					|| dailyClaim.HCPCS_Code__c.equals('')
					//|| !drugHCPCSet.contains(dailyClaim.HCPCS_Code__c)
					|| !drugFound
				)
			{
				//HCPCS Mismatch. Don't process
			} else if(!csaSet.contains(dailyClaim.CSA_Number__c)) {
				//CSA Mismatch. Don't process
			}  else {
				//System.debug('casRecord.CSA_Number = ' + csaRecord.CSA_Number__c);
				if(claimRecord == null
						&& String.isBlank(dailyClaim.Previous_Segment__c) //Avoid any orphan Claims when daily claim attempting to update a claim & the member had no initial claim where Previous_Segment was null
						|| (dailyClaim.Claim_Code__c == 'O'
							&& dailyClaim.Previous_Segment__c =='00'
							&& dailyClaim.Claim_Segment__c == '01') //MED-1853: Ingest New Claims with O Status and 01 Segment if they have 00 previous segment as new claims
				) {
					System.debug('A new claim will be created.');
					daily_ClaimsToProcessList.add(dailyClaim);
				} else if (claimRecord != null) { // if (dailyClaim.Previous_Claim__c == null) {
					System.debug('An existing claim will be updated.');
					daily_ClaimsToProcessList.add(dailyClaim);
				} else {
					//Do not process claims when received out of order
				}
				System.debug('dailyClaim.Status__c = ' + dailyClaim.Status__c);
				System.debug('dailyClaim.Error_Log__c = ' + dailyClaim.Error_Log__c);
			}

			System.debug('Primary_Claim_Number__c = ' + dailyClaim.Primary_Claim_Number__c);
		}
		System.debug('daily_ClaimsToProcessList Count = ' + daily_ClaimsToProcessList.size());

		//Process DailyClaims - Create Contacts, ContactDrugs, and Enrollment Cases for new members.
		if(daily_ClaimsToProcessList.size() > 0) {
			ProcessDailyClaimsAfterInsert(daily_ClaimsToProcessList, csaByDailyClaimId);
		}
		System.debug('End Daily_Claims:onAfterInsert');
	}
/*
	public override void onAfterUpdate(Map<Id, SObject> existingRecords){
		System.debug('Start Daily_Claims:onAfterUpdate');
		//List<Member_Drug__c> lstMemberDrug = Trigger.new;
		List<Daily_Claim__c> dailyClaimsList = Records;
		List<Daily_Claim__c> daily_ClaimsToProcessList = new List<Daily_Claim__c>();

		//TProcess the criteria for Daily Claims to Process After Insert.
		//Create the CSA Domain with onBeforeInsert to generate SAH1 Hash for CSA_Number
		//Create the CAS Selector

		for(Daily_Claim__c dailyClaim : dailyClaimsList){
			//if(HCPCS (Drug) exit) && CSA Object exist
			daily_ClaimsToProcessList.add(dailyClaim);

		}


		if(daily_ClaimsToProcessList.size() > 0) {
			//ProcessContactDrugsAfterUpdate - Create Contacts, ContactDrugs, and Enrollment Cases for new members.
			//ProcessMemberDrugsAfterUpdate(daily_ClaimsToProcessList);
		}
		System.debug('End Daily_Claims:onAfterUpdate');
	}
*/
}