/** 
 * @description       : Historical_Claims Domain class.
 * @author            : jyothi.gandhamaneni@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-18-2021
 * @last modified by  : Jyothi Gandhamaneni
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-18-2021   Jyothi Gandhamaneni			   Initial Version
 * 
 **/

//All domain classes should utilize inherited sharing so that the caller determines whether it should operate in system context or not. The should
//also extend the fflib_SObjectDomain class
public class Historical_Claims extends fflib_SObjectDomain
    implements IHistorical_Claims
{
	private static Integer maxHCPCSCodeSize = 5;
	//The constructor should always accept a list of the SObject type we're creating the domain class for
	//It should then pass this list to the fflib_SObjectDomain class's constructor which is what super(cases) does.
	//This sets the records value in the fflib_SObjectDomain class which is very important
	public Historical_Claims(List<Historical_Claim__c> sObjectList)
	{
		// Domain classes are initialised with lists to enforce bulkification throughout
		super(sObjectList);
	}

    public static IHistorical_Claims newInstance(List<Historical_Claim__c> recordList)
	{
		return (IHistorical_Claims) PMd_Application.Domain.newInstance(recordList);
	}
/*
	public static IHistorical_Claims newInstance(Historical_Claim__c record, Historical_Claim_JSONRequest request)
	{
		return (IHistorical_Claims) PMd_Application.Domain.newInstance(record, request);
	}
*/
	public static IHistorical_Claims newInstance(Set<Id> recordIdSet)
	{
		return (IHistorical_Claims) PMd_Application.Domain.newInstance(recordIdSet);
	}


	/***************************************************************************************************************************************
     * Domain Specific Operations
     **************************************************************************************************************************************/

	private List<Contact_Drug__c> existingContact_DrugList;
	private Map<Id, Contact> existingContactsByHistoricalClaimId;

    //Do Post Rest API
    public void doRestAPIPost(List<Historical_Claim__c> recordList) {

    }

	//Do Post Rest API
	void doRestAPIPost(fflib_ISObjectUnitOfWork uow) {

	}

	//Do Post Rest API
	public static Historical_Claim__c newInstance(Historical_Claim_JSONRequest request) {
		Historical_Claim__c historicalClaimInstance = new Historical_Claim__c();
		//TODO: Verify all field types are correct
		historicalClaimInstance.CSA_Account__c = FormatterUtilService.textFormatter(request.Account_Number);
		if(request.Adjudicated_NDC_Units_Count != 'null') {
			historicalClaimInstance.Units_Billed__c = Decimal.valueOf(request.Adjudicated_NDC_Units_Count.equals('null') ? '0' : request.Adjudicated_NDC_Units_Count);
		}
		if(request.Allowable_Amount != 'null') {
			historicalClaimInstance.Amount_Paid_By_Primary__c = Decimal.valueOf(request.Allowable_Amount);
		}
		//historicalClaimInstance.Prior_Authorization__c = FormatterUtilService.textFormatter(request.Authorization_Number);
		//historicalClaimInstance.Authorized_Representative__c =  FormatterUtilService.textFormatter(request.Authorized_Representative);
		//historicalClaimInstance.Authorized_Relationship__c = FormatterUtilService.textFormatter(request.Authorized_Representative_Relationship);
		historicalClaimInstance.Billing_Provider_City__c = FormatterUtilService.textFormatter(request.Billing_Provider_City);
		historicalClaimInstance.Billing_Provider_First_Name__c = FormatterUtilService.textFormatter(request.Billing_Provider_First_Name);
		historicalClaimInstance.Billing_Provider_Last_Name__c = FormatterUtilService.textFormatter(request.Billing_Provider_Last_Name);
		historicalClaimInstance.Billing_Provider_Specialty__c = FormatterUtilService.textFormatter(request.Billing_Provider_Specialty);
		historicalClaimInstance.Place_of_Service__c = FormatterUtilService.textFormatter(request.Place_of_Service);
		/*
		historicalClaimInstance.Billing_Provider_PIN__c = FormatterUtilService.textFormatter(request.Billing_Provider_PIN);
		historicalClaimInstance.Billing_Provider_State__c = FormatterUtilService.textFormatter(request.Billing_Provider_State_Code);
		historicalClaimInstance.Billing_Provider_Address_Line_1__c = FormatterUtilService.textFormatter(request.Billing_Provider_Street_Address_Line_1);
		historicalClaimInstance.Billing_Provider_Zip_Code__c = FormatterUtilService.textFormatter(request.Billing_Provider_Zip_Code);
		historicalClaimInstance.Billing_Provider_Phone__c = FormatterUtilService.phoneFormatter(request.Billing_Provider_Phone);
		historicalClaimInstance.Billing_Provider_Fax__c = FormatterUtilService.phoneFormatter(request.Billing_Provider_Fax);
		historicalClaimInstance.Primary_Claim_Number__c =  FormatterUtilService.textFormatter(request.Claim_Identifier);
		//historicalClaimInstance.Claim_Code__c = FormatterUtilService.textFormatter(request.Claim_Indicator);
		historicalClaimInstance.Claim_Line__c =  FormatterUtilService.textFormatter(request.Claim_Line_Identifier);
		//historicalClaimInstance.Claim_Segment__c = FormatterUtilService.textFormatter(request.Claim_Segment);
		historicalClaimInstance.COB_Code__c =  FormatterUtilService.textFormatter(request.COB_Indicator);
		historicalClaimInstance.CSA_Control__c =  FormatterUtilService.textFormatter(request.Control_Number);
		//if(request.Days_Supply != 'null') {
		//	historicalClaimInstance.Days_Supply__c = Decimal.valueOf(request.Days_Supply);
		//}
		historicalClaimInstance.Diagnosis_Code__c = FormatterUtilService.textFormatter(request.Diagnosis_Code);
		historicalClaimInstance.Drug_Label_Name__c = FormatterUtilService.textFormatter(request.Drug_Label_Name);
		historicalClaimInstance.HCPCS_Code__c = FormatterUtilService.textFormatter(request.ICD9_Procedure_Code);
		historicalClaimInstance.NDC__c = FormatterUtilService.textFormatter(request.National_Drug_Code);
		//historicalClaimInstance.Previous_Claim__c = FormatterUtilService.textFormatter(request.Original_UCK_ID);
		//historicalClaimInstance.PA_Approval_Dates__c = FormatterUtilService.dateFormatter(request.PA_Approval_Dates);
		historicalClaimInstance.Patient_Birth_Date__c = FormatterUtilService.dateFormatter(request.Patient_Birth_Date);
		//historicalClaimInstance.Patient_Email_Address__c = FormatterUtilService.textFormatter(request.Patient_Email_Address);
		historicalClaimInstance.Patient_First_Name__c = FormatterUtilService.textFormatter(request.Patient_First_Name);
		historicalClaimInstance.Patient_Last_Name__c = FormatterUtilService.textFormatter(request.Patient_Last_Name);
		historicalClaimInstance.Patient_Middle_Initial__c = FormatterUtilService.textFormatter(request.Patient_Middle_Initial);
		historicalClaimInstance.Patient_Phone_Number__c = FormatterUtilService.phoneFormatter(request.Patient_Phone_Number);
		historicalClaimInstance.Patient_Gender__c = FormatterUtilService.genderFormatter(request.Patient_Sex);
		historicalClaimInstance.Plan_Sponsor_Name__c = FormatterUtilService.textFormatter(request.Policy_Holder_Name);
		historicalClaimInstance.Preferred_Provider__c = FormatterUtilService.textFormatter(request.Provider_Indicator);
		//if(request.Claim_Adjusted_Amount != 'null') {
		//	historicalClaimInstance.Claim_Adjustment_Amount__c = Decimal.valueOf(request.Claim_Adjusted_Amount);
		//}
		//historicalClaimInstance.Coverage_Code_Indicator__c = FormatterUtilService.textFormatter(request.Coverage_Code_Indicator);
		historicalClaimInstance.Date_Of_Service_From__c = FormatterUtilService.dateFormatter(request.Service_From_Date);
		historicalClaimInstance.Service_Provider_Fax__c = FormatterUtilService.phoneFormatter(request.Service_Provider_Fax);
		historicalClaimInstance.Service_Provider_Phone__c = FormatterUtilService.phoneFormatter(request.Service_Provider_Phone);
		historicalClaimInstance.Date_Of_Service_To__c = FormatterUtilService.dateFormatter(request.Service_To_Date);
		historicalClaimInstance.Service_Provider_Address_Line_1__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Address_Line_1);
		historicalClaimInstance.Service_Provider_City__c = FormatterUtilService.textFormatter(request.Servicing_Provider_City);
		historicalClaimInstance.Service_Provider_First_Name__c = FormatterUtilService.textFormatter(request.Servicing_Provider_First_Name);
		historicalClaimInstance.Service_Provider_Last_Name__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Last_Name);
		historicalClaimInstance.Service_Provider_NPI__c = FormatterUtilService.textFormatter(request.Servicing_Provider_National_Provider_Identifier);
		historicalClaimInstance.Service_Provider_Practice__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Practice_Role_Name);
		historicalClaimInstance.Service_Provider_Zip__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Service_Location_Zip_Code);
		historicalClaimInstance.Service_Provider_Specialty_Code__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Specialty_Code);
		//historicalClaimInstance.Service_Provider_State__c =  FormatterUtilService.truncate(request.Servicing_Provider_State_Code, 2);
		historicalClaimInstance.Service_Provider_State__c =  FormatterUtilService.textFormatter(request.Servicing_Provider_State_Code);
		historicalClaimInstance.Patient_Address_Line_1__c = FormatterUtilService.textFormatter(request.Subscriber_Address_Line_1);
		historicalClaimInstance.Patient_Address_Line_2__c = FormatterUtilService.textFormatter(request.Subscriber_Address_Line_2);
		historicalClaimInstance.Patient_City__c = FormatterUtilService.textFormatter(request.Subscriber_City);
		historicalClaimInstance.Patient_CUMB_ID__c = FormatterUtilService.textFormatter(request.Subscriber_CUMB_ID);
		historicalClaimInstance.Relationship_Code__c = FormatterUtilService.textFormatter(request.Person_Relationship_Code);
		//historicalClaimInstance.Patient_State__c = FormatterUtilService.truncate(request.Subscriber_State_Code, 2);
		historicalClaimInstance.Patient_State__c = FormatterUtilService.textFormatter(request.Subscriber_State_Code);
		historicalClaimInstance.Patient_Zip_Code__c = FormatterUtilService.textFormatter(request.Subscriber_Zip_Code);
		historicalClaimInstance.CSA_Suffix__c = FormatterUtilService.textFormatter(request.Suffix_Number);
		if(request.Total_Coinsurance_Amount != 'null') {
			historicalClaimInstance.Total_Coinsurance__c = Decimal.valueOf(request.Total_Coinsurance_Amount);
		}
		if(request.Total_Copay_Amount != 'null') {
			historicalClaimInstance.Total_Copay__c = Decimal.valueOf(request.Total_Copay_Amount);
		}
		if(request.Total_Deductible_Amount != 'null') {
			historicalClaimInstance.Total_Deductible__c = Decimal.valueOf(request.Total_Deductible_Amount);
		}

		historicalClaimInstance.Plan_Sponsor_Unique_ID__c = FormatterUtilService.textFormatter(request.Plan_Sponsor_Unique_ID_Account_ID);
		//historicalClaimInstance.Plan_Letter__c = FormatterUtilService.textFormatter(request.Plan_Letter);
		//historicalClaimInstance.Funding_Indicator__c = FormatterUtilService.textFormatter(request.Funding_Indicator);
		//historicalClaimInstance.Adjudication_Date__c = FormatterUtilService.dateFormatter(request.Adjudication_Date);
		historicalClaimInstance.Primary_Subscriber_Name__c = FormatterUtilService.textFormatter(request.Subscriber_Name);
		historicalClaimInstance.Primary_Subscriber_Relationship__c = FormatterUtilService.textFormatter(request.Subscriber_Relationship);

		//TODO: Verify the Historical_Claim unique ID can be based on 'Claim_Inicator, Claim_Line_Identifier, National_Drug_Code'
		historicalClaimInstance.External_Prior_Authorization__c = SHA1UtilService.getBase64SHA1Hash(
				//historicalClaimInstance.Claim_Code__c + '-' +
				historicalClaimInstance.Claim_Line__c + '-' +
				historicalClaimInstance.NDC__c
		);
		//historicalClaimInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(historicalClaimInstance.CSA_Control__c + historicalClaimInstance.CSA_Suffix__c + historicalClaimInstance.CSA_Account__c);
		*/
		return historicalClaimInstance;
	}

	public static List<RestAPI_JSONResponse> SaveResults(List<Historical_Claim__c> historicalClaimsInsertList, List<Historical_Claim__c> historicalClaimsUpsertList, String JSONString) {

		List<RestAPI_JSONResponse> responses = new List<RestAPI_JSONResponse>();
		/*
		Integer recordCount = 0;

		//TODO: Use UnitOfWork
		//Insert
		Database.SaveResult[] saveInsertResults = Database.insert(historicalClaimsInsertList, false);

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
			//responseInstance.hbsPatientId = historicalClaimsInsertList[recordCount].HBS_ID__c;
			//responseInstance.caremarkMemberId = historicalClaimsInsertList[recordCount].Patient_CUMB_ID__c;
			//responseInstance.prudentInHistoricalClaimId = historicalClaimsInsertList[recordCount].Prudent_In_Data_Staging_ID__c;
			responses.add(responseInstance);
			recordCount++;
		}

		recordCount = 0;

		//Upsert
		//Schema.SObjectField authNumberField = Historical_Claim__c.Fields.External_Authorization_Number__c;
		//Database.UpsertResult[] saveUpsertResults = Database.upsert(historicalClaimsUpsertList, authNumberField, false);
		Database.UpsertResult[] saveUpsertResults = Database.upsert(historicalClaimsUpsertList, false);
		for (Database.UpsertResult sr : saveUpsertResults) {
			RestAPI_JSONResponse responseInstance = new RestAPI_JSONResponse();
			if (sr.isSuccess()) {
				responseInstance.status = 'Success';
			} else {
				responseInstance.status = 'Failure';
				if (sr.getErrors().size() > 0) {
					responseInstance.errorMessage = sr.getErrors()[0].getMessage();
					ErrorLog.log('Historical_Claim__c API PrudentRestResource', '', JSONString, '', '', sr.getErrors()[0].getMessage(), null);
				}
			}
			//responseInstance.hbsPatientId = historicalClaimsUpsertList[recordCount].HBS_ID__c;
			//responseInstance.caremarkMemberId = historicalClaimsUpsertList[recordCount].Patient_CUMB_ID__c;
			//responseInstance.prudentInHistoricalClaimId = historicalClaimsUpsertList[recordCount].Prudent_In_Data_Staging_ID__c;
			responses.add(responseInstance);
			recordCount++;
		}
*/
		return responses;
	}

    //Get set of all Historical_Claim AccountNumbers
    public Set<String> getAccountNumbers()
	{
		Set<String> result = new Set<String>();
		for (Historical_Claim__c record : (List<Historical_Claim__c>) getRecords())
		{
			/*
			if (record.CSA_Account__c != null)
			{
				result.add(record.CSA_Account__c);
			}
			*/
		}
		return result;
	}

	/**
	 * Process Historical_Claims for the given source records (so long as their domain classes implement ISupporthistoricalClaims)
	 **/
	/*
	public void process(List<Historical_Claim__c> historicalClaimList) {

		// Contact Factory helps domain classes produce Contacts
		ContactsService.ContactFactory contactFactory = new ContactsService.ContactFactory(uow);
		// Construct domain class capabile of processing Historical Claim
		fflib_IDomain domain =
				PMd_Application.Domain.newInstance(historicalClaimList);
		if (domain instanceof ContactsService.ISupportContacts) {

			// Ask the domain object to process its Historical Claim
			ContactsService.ISupportContacts contacts = (ContactsService.ISupportContacts) domain;
			contacts.process(contactFactory);
		}
	}
*/
	/*
	//Use this method for clients like Batch Jobs, Controllers, etc.
	public void process(ContactsService.ContactFactory contactFactory) {
		System.debug('Start processing Contacts for Historical Claim');

		Set<String> cumbId = new Set<String>();
		Set<Date> birthDate = new Set<Date>();
		Set<String> firstName = new Set<String>();
		Set<String> lastName = new Set<String>();
		List<Historical_Claim__c> historicalClaimList = (List<Historical_Claim__c>) getRecords();

		for(Historical_Claim__c historicalClaim : historicalClaimList){
			//cumbId.add(historicalClaim.Patient_CUMB_ID__c);
			birthDate.add(historicalClaim.Patient_Birth_Date__c);
			firstName.add(historicalClaim.Patient_First_Name__c);
			lastName.add(historicalClaim.Patient_Last_Name__c);
		}

		// Create unit of work to capture work and commit it under one transaction
		fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

		//Get matching contacts from Historical Claim
		ContactsSelector contactsSelector = (ContactsSelector)PMd_Application.Selector.newInstance(Contact.SObjectType);
		//Use ContactSelector to get matching existing contacts
		//
			Look for an existing member based on: Add tiered matching logic.
				Subscriber CUMB ID
				Patient Birth Date
				Patient Last Name
				Patient First Name
		 //

		List<Contact> existingContacts = contactsSelector.selectByCumbIdBdLnFn(cumbId, birthDate, firstName, lastName);
		Map<Id, Contact> existinghistoricalClaimContactsById = new Map<Id, Contact>(existingContacts);
		//Get map of existing Contacts by Historical Claim Id
		Map<Id, Contact> existingContactsByhistoricalClaimId = mapContactsByhistoricalClaimId(existingContacts, historicalClaimList);

		process(contactFactory, existingContactsByhistoricalClaimId, uow);

		System.debug('End processing Contacts for Historical Claim');
	}

	//Use this method for trigger operations
	private void process(ContactsService.ContactFactory contactFactory, Map<Id, Contact> existingContactsByhistoricalClaimId, fflib_ISObjectUnitOfWork uow) {
		System.debug('Start processing Contacts for Historical Claim');
		// Create Contacts from the given Historical Claim
		List<SObject> newContactsList = new List<SObject>();
		List<SObject> existingContactsList = new List<SObject>();
		for(Historical_Claim__c historicalClaim : (List<Historical_Claim__c>) getRecords()) {
			//
				If Contact does not exists based on logic above:
				Then create Contact, ContactDrug, Claim, and Enrollment Case.
				If Contact does exist based on logic above:
				Then update Contact (refer to mapping document for fields), then check ContactDrug processing logic
			//
			Contact existingContact = existingContactsByhistoricalClaimId.get(historicalClaim.Id);
			if(existingContact != null) {
				existingContact = maphistoricalClaimToContact(historicalClaim, existingContact);
				existingContactsList.add(existingContact);
			} else {
				//Create new Contact form Historical Claim
				Contact newContact = new Contact();
				newContact = maphistoricalClaimToContact(historicalClaim, newContact);
				newContactsList.add(newContact);
			}
		}
		uow.registerDirty(existingContactsList);
		uow.registerNew(newContactsList);

		System.debug('End processing Contacts for Historical Claim');
	}

	//Map Historical Claim fields to new Contact fields
	private Contact maphistoricalClaimToContact(Historical_Claim__c historicalClaim, Contact contact) {

		//contact.CSA_Account__c = historicalClaim.CSA_Account__c;
		contact.FirstName = historicalClaim.Patient_First_Name__c;
		contact.LastName = historicalClaim.Patient_Last_Name__c;
		contact.Patient_Birth_Date__c = historicalClaim.Patient_Birth_Date__c;
		//contact.Patient_Address_Line_1__c = historicalClaim.Patient_Address_Line_1__c;
		contact.MailingCity = historicalClaim.Patient_City__c;
		contact.MailingState = historicalClaim.Patient_State__c;

		return contact;
	}
	*/
/*
    public class Constructor implements fflib_IDomainConstructor
	{
		public fflib_SObjects construct(List<Object> objectList)
		{
			return new Historical_Claims((List<SObject>) objectList);
		}

		public fflib_SObjects construct(SObject obj, Object objectInstance)
		{
			return new Historical_Claims((SObject) obj, (Object) objectInstance);
		}
		*/
//	}

	//The name of this inner class must always be Constructor to work appropriately. This acts as a way to use the concept of reflection when initializing
	//this class, despite the fact apex still does not support it.
	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new Historical_Claims(sObjectList);
		}
	}
/*
	//Generate map of Contacts By Historical Claim Ids
	Map<Id, Contact> mapContactsByhistoricalClaimId(List<Contact> existingContactList, List<Historical_Claim__c> historicalClaimList ) {
		Map<Id, Contact> existingContactsByhistoricalClaimId = new Map<Id, Contact>();
		for(Historical_Claim__c historicalClaim : historicalClaimList) {
			for(Contact contact : existingContactList) {
				if(historicalClaim.Patient_First_Name__c == contact.FirstName
						&& historicalClaim.Patient_Last_Name__c == contact.LastName
						&& historicalClaim.Patient_Birth_Date__c == contact.Patient_Birth_Date__c)
				{
					existingContactsByhistoricalClaimId.put(historicalClaim.id, contact);
				}
			}
		}
		return existingContactsByhistoricalClaimId;
	}
*/
	/*
* Method Name: ProcesshistoricalClaimsBeforeInsert
* Description:
*/
	private void ProcessHistoricalClaimsBeforeInsert(List<Historical_Claim__c> historicalClaimList) {
/*
		for(Historical_Claim__c historicalClaim : historicalClaimList){


		}
		*/
	}

	/*
    * Method Name: ProcesshistoricalClaimsAfterInsert
    * Description:
    */
	public void ProcessHistoricalClaimsAfterInsert(List<Historical_Claim__c> historicalClaimList) {
		System.debug('Start processing Historical Claim After Insert');
		// Create unit of work to capture work and commit it under one transaction
		fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();
		//Instantiate a new UnitOfWork
		fflib_ISObjectUnitOfWork uowAfterTx = PMd_Application.UnitOfWork.newInstance();

		processHistoricalClaimContacts(historicalClaimList, uow);
		try {
			uow.commitWork();

			//Instantiate a new UnitOfWork
			uow = PMd_Application.UnitOfWork.newInstance();
			//Process ContactDrugs for Dail Claims
			processHistoricalClaimContactDrugs(historicalClaimList, uow);
		}catch(Exception e){
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Cases.process.ProcessHistoricalClaimsAfterInsert.processHistoricalClaimContacts', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, historicalClaimList[0].Id, null, null);
			ErrorLog.commitLogs();
			//throw e;
		}

		try {
			uow.commitWork();

			//Instantiate a new UnitOfWork
			uow = PMd_Application.UnitOfWork.newInstance();

			processHistoricalClaimClaim_Informations(historicalClaimList, uow);
			//Comment the work now so we can get the Contact_Drug & Claim Ids to relate the objects
			//uow.commitWork();
		}catch(Exception e){
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Cases.process.ProcessHistoricalClaimsAfterInsert.processHistoricalClaimCases', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, historicalClaimList[0].Id, null, null);
			ErrorLog.commitLogs();
			//throw e;
		}

		processHistoricalClaimCases(historicalClaimList, uow, uowAfterTx);

		try {
			// Commit updates to all Daily Claim related Objects
			uowAfterTx.commitWork();
		}catch(Exception e){
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Cases.process.ProcessHistoricalClaimsAfterInsert.processHistoricalClaimCases', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, historicalClaimList[0].Id, null, null);
			ErrorLog.commitLogs();
			//throw e;
		}

		System.debug('Stop processing Historical Claim After Insert');
	}

	private void processHistoricalClaimContacts(List<Historical_Claim__c> historicalClaimList, fflib_ISObjectUnitOfWork uow) {
		System.debug('Start processing Contacts for Historical Claim');
		// Contact Factory helps domain classes produce Contacts
		//ContactsService.ContactFactory contactFactory = new ContactsService.ContactFactory(uow);

		// Construct domain class capable of processing contacts for Historical Claim
		/*
		fflib_IDomain domain =
				PMd_Application.Domain.newInstance(existinghistoricalClaimContactsById.values());
		// Ask the domain object to process its Historical Claim
		ContactsService.ISupportContacts contacts = (ContactsService.ISupportContacts) domain;
		contacts.process(contactFactory);
		*/
		List<Contact> contactList = new List<Contact>();
		IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
		existingContactsByHistoricalClaimId = contactsDomain.process(historicalClaimList, uow);
		System.debug('existingContactsByHistoricalClaimId = ' + existingContactsByHistoricalClaimId);
		System.debug('Stop processing Contacts for Historical Claim');
	}

	private void processHistoricalClaimContactDrugs(List<Historical_Claim__c> historicalClaimList,
			fflib_ISObjectUnitOfWork uow) {
		System.debug('Start processing Contact_Drugs for Historical Claim');

		// ContactDrug Factory helps domain classes produce Contactdrugs
		//TODO: Create ContactDrugsService.ContactDrugsFactory class
		//ContactDrugsService.ContactDrugsFactory contactDrugFactory = new ContactDrugsService.ContactDrugsFactory (uow);
		List<Contact_Drug__c> contact_DrugsList = new List<Contact_Drug__c>();
		IContact_Drugs contact_DrugsDomain = (IContact_Drugs) PMd_Application.Domain.newInstance(contact_DrugsList);

		//TODO: Create process method to process ContactDrugs
		//process(contactDrugFactory, existingContactsByhistoricalClaimId, uow);
		existingContact_DrugList = contact_DrugsDomain.process(historicalClaimList, uow);

		System.debug('Stop processing Contact_Drugs for Historical Claim');
	}

	private void processHistoricalClaimClaim_Informations(List<Historical_Claim__c> historicalClaimList, fflib_ISObjectUnitOfWork uow) {

		System.debug('In Historical_Claims:processHistoricalClaimClaim_Informations - Start processing Claim_Informations for Historical Claims');

		List<Claim_Information__c> claim_InformationsList = new List<Claim_Information__c>();
		IClaim_Informations claim_InformationsDomain = (IClaim_Informations) PMd_Application.Domain.newInstance(claim_InformationsList);

		System.debug('historicalClaimList Count = ' + historicalClaimList.size());
		System.debug('existingContact_DrugList Count = ' + existingContact_DrugList.size());
		List<Claim_Information__c> existingClaim_InformationList = claim_InformationsDomain.process(historicalClaimList,
																									existingContactsByHistoricalClaimId,
																									existingContact_DrugList,
																									uow
		);

		System.debug('In Historical_Claims:processHistoricalClaimClaim_Informations - Stop processing Claim_Informations for Historical Claims');
	}

	public void processHistoricalClaimCases(List<Historical_Claim__c> historicalClaimsList, fflib_ISObjectUnitOfWork uowBeforeTx, fflib_ISObjectUnitOfWork uowAfterTx) {

		System.debug('In Historical_Claims:processDailyClaimCases - Start processing Cases for Historical Claims');

		System.debug('historicalClaimsList Count = ' + historicalClaimsList.size());

		List<Case> casesList = new List<Case>();
		ICases casesDomain = (ICases) PMd_Application.Domain.newInstance(casesList);

		casesDomain.process(historicalClaimsList,
							existingContactsByHistoricalClaimId,
							existingContact_DrugList,
							uowBeforeTx,
							uowAfterTx);

		System.debug('In Historical_Claims:Daily_Claims:processDailyClaimCases - Stop processing Cases for Historical Claims');
	}

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
		System.debug('Start Historical_Claims:onBeforeInsert');
		//List<Member_Drug__c> lstMemberDrug = Trigger.new;
		List<Historical_Claim__c> historicalClaimsList = Records;
		List<Historical_Claim__c> historicalClaimsToProcessList = new List<Historical_Claim__c>();
		CSA__c casInstance = new CSA__c();
		Map<Id, CSA__c> csaByHistoricalClaimId = new Map<Id, CSA__c>();
		//Map<String, Id> historicalClaimIdByCSANumber = new Map<String, Id>();
		String claim_NumberSeed;
		Set<String> historicalClaimCSANumberSet = new Set<String>();
		Set<String> historicalClaimHCPCSet = new Set<String>();
		Set<String> drugHCPCSet = new Set<String>();
		Set<String> drugNDCSet = new Set<String>();
		Set<String> csaSet = new Set<String>();
		Map<String, Drug__c> drugByHCPCS = new Map<String, Drug__c>();
		Map<String, Id> drugIdByNDC = new Map<String, Id>();
		Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
		String HCPCSCodeTrunc;
		Drug__c drugRecord;
		String HCPCSCode;

		//Process the criteria for Historical Claim to Process Before Insert
		/*
		If HCPCS (Drug) does not exist, then don’t process record and set:
		Status [NEW FIELD] to “Error”
		Error Log [NEW FIELD] to “HCPCS Mismatch.” Dependent and connected to the Status field.
		If Control, Suffix, Account (CSA Object) does not exist, then don’t process record and set:
		Status [NEW FIELD] to “Error”
		Error Log [NEW FIELD] to “CSA Mismatch.” Dependent and connected to the Status field.
		*/

		for(Historical_Claim__c historicalClaimInstance : historicalClaimsList){

			//NOTE: I don't believe this is used anywhere & is replaced by the Claim_Number__c
			historicalClaimInstance.External_Prior_Authorization__c = SHA1UtilService.getBase64SHA1Hash(
							//historicalClaimInstance.Claim_Code__c + '-' +
							historicalClaimInstance.Claim_Line__c + '-' +
							historicalClaimInstance.NDC__c
			);
			historicalClaimInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
					historicalClaimInstance.CSA_Control__c + '-' +
							historicalClaimInstance.CSA_Suffix__c + '-' +
							historicalClaimInstance.CSA_Account__c
			);

			//if(historicalClaimInstance.Previous_Segment__c == null || historicalClaimInstance.Previous_Segment__c == '') {
				claim_NumberSeed = historicalClaimInstance.Primary_Claim_Number__c + '-' +
						//historicalClaimInstance.Claim_Segment__c + '-' +
						historicalClaimInstance.Claim_Line__c;
			/* } else
				claim_NumberSeed = historicalClaimInstance.Primary_Claim_Number__c +
						historicalClaimInstance.Previous_Segment__c +
						historicalClaimInstance.Claim_Line__c;
			}
			*/
			historicalClaimInstance.Claim_Number__c = SHA1UtilService.getBase64SHA1Hash(claim_NumberSeed);
			System.debug('historicalClaimInstance.CSA_Number__c = '+ historicalClaimInstance.CSA_Number__c);
			System.debug('historicalClaimInstance.Claim_Number__c = '+ historicalClaimInstance.Claim_Number__c);
		}

		for(Historical_Claim__c historicalClaimRecord : historicalClaimsList){
			//historicalClaimIdByCSANumber.put(historicalClaimRecord.CSA_Number__c, historicalClaimRecord.Id);
			System.debug('historicalClaimRecord.HCPCS_Code__c = '+ historicalClaimRecord.HCPCS_Code__c);
			//if(String.isBlank(historicalClaimRecord.HCPCS_Code__c)) {
			HCPCSCodeTrunc = historicalClaimRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			historicalClaimHCPCSet.add(HCPCSCodeTrunc);
			//}
			historicalClaimCSANumberSet.add(historicalClaimRecord.CSA_Number__c);
			System.debug('historicalClaimRecord.CSA_Number__c = ' + historicalClaimRecord.CSA_Number__c);
			//System.debug('historicalClaimRecord.Id = ' + historicalClaimRecord.Id);
		}
		System.debug('historicalClaimCSANumberSet = ' + historicalClaimCSANumberSet);
		System.debug('historicalClaimHCPCSet = ' + historicalClaimHCPCSet);

		DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
		List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(historicalClaimHCPCSet);
		for(Drug__c drug : drugList) {
			if(drug.Coding_Level__c == 'HCPCS') {
				HCPCSCodeTrunc = drug.J_Code__c.substring(0, maxHCPCSCodeSize);
				drugByHCPCS.put(HCPCSCodeTrunc, drug);
			}
			drugHCPCSet.add(drug.J_Code__c);
			drugById.put(drug.Id, drug);
			System.debug('drug.J_Code__c = ' + drug.J_Code__c);
		}
		System.debug('drugHCPCSet = ' + drugHCPCSet);

		NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
		List<NDC__c> ndcList =  ndcsSelector.selectByDrugId(drugById.keySet());

		for(NDC__c ndcRecord : ndcList) {
			//if(!String.isBlank(ndcRecord.Drug__r.J_Code__c)) {
			//	HCPCSCodeTrunc = ndcRecord.Drug__r.J_Code__c.substring(0, maxHCPCSCodeSize);
			//}
			HCPCSCodeTrunc = ndcRecord.Drug__r.J_Code__c.substring(0, maxHCPCSCodeSize);
			System.debug('ndcRecord.Drug__r.Coding_Level__c = ' + ndcRecord.Drug__r.Coding_Level__c);
			System.debug('ndcRecord.Drug__r.J_Code__c = ' + ndcRecord.Drug__r.J_Code__c);
			System.debug('ndcRecord.Name = ' + ndcRecord.Name);
			drugIdByNDC.put(ndcRecord.Name, ndcRecord.Drug__c);
			if(ndcRecord.Name != '') {
				drugNDCSet.add(ndcRecord.Name);
			}
		}

		CSAsSelector csasSelector = (CSAsSelector)PMd_Application.Selector.newInstance(CSA__c.SObjectType);
		List<CSA__c> matchingCSA_NumbersList = csasSelector.selectByCSANumber(historicalClaimCSANumberSet);
		for(CSA__c csaRecord : matchingCSA_NumbersList) {
			csaSet.add(csaRecord.CSA_Number__c);
			System.debug('csaRecord.CSA_Number__c = ' + csaRecord.CSA_Number__c);
		}
		System.debug('csaSet = ' + csaSet);

		//Process the criteria for Historical Claims to Process Before Insert
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
		//Get map of CSA_Number by Historical Claim Id
		///csaByHistoricalClaimId = cSAsDomain.getCSAsById(historicalClaimIdByCSANumber);

		for(Historical_Claim__c historicalClaim : historicalClaimsList) {
			/*
			if(!String.isBlank(historicalClaim.HCPCS_Code__c)) {
				HCPCSCodeTrunc = historicalClaim.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			}
			*/
			HCPCSCode = historicalClaim.HCPCS_Code__c;
			if(HCPCSCode != null
			) {
				HCPCSCodeTrunc = HCPCSCode.substring(0, maxHCPCSCodeSize);
			}
			System.debug('HCPCS_Code__c = ' + HCPCSCodeTrunc);
			System.debug('CSA_Number__c = ' + historicalClaim.CSA_Number__c);
			System.debug('NDC__c = ' + historicalClaim.NDC__c);
			//Error out HCPCS Mismatch claims when HCPCS drug code is not found in Drug list
			Boolean drugFound = false;
			drugRecord = drugById.get(drugIdByNDC.get(historicalClaim.NDC__c));
			if(drugNDCSet.contains(historicalClaim.NDC__c) && drugRecord != null && drugRecord.Coding_Level__c == 'HCPCS + NDC') {
				drugRecord = drugById.get(drugIdByNDC.get(historicalClaim.NDC__c));
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

			if(historicalClaim.HCPCS_Code__c == null
					|| historicalClaim.HCPCS_Code__c.equals('')
					//|| !drugHCPCSet.contains(historicalClaim.HCPCS_Code__c)
					|| !drugFound
				)
			{
				//HCPCS Mismatch. Set error.
				historicalClaim.Status__c = 'Error';
				historicalClaim.Error_Log__c = 'HCPCS Mismatch';
				System.debug('HCPCS Mismatch');
			} else if(!csaSet.contains(historicalClaim.CSA_Number__c)) {
				//CSA Mismatch. Set error.
				historicalClaim.Status__c = 'Error';
				historicalClaim.Error_Log__c = 'CSA Mismatch';
				System.debug('CSA Mismatch');
			}  else {
				//Map the Daily Claim Drug_Label_Name from the Drug Name
				historicalClaim.Drug_Label_Name__c = drugRecord.Name;
				historicalClaimsToProcessList.add(historicalClaim);
			}

		}

		System.debug('historicalClaimsToProcessList.size() = '+historicalClaimsToProcessList.size());
		if(historicalClaimsToProcessList.size() > 0) {
			ProcessHistoricalClaimsBeforeInsert(historicalClaimsToProcessList);
		}

		System.debug('End Historical_Claims:onBeforeInsert');
	}

//    public override void processAfterInsert(){
	public override void onAfterInsert() {
		System.debug('Start Historical_Claims:onAfterInsert');
		//List<Member_Drug__c> lstMemberDrug = Trigger.new;
		List<Historical_Claim__c> historicalClaimsList = Records;
		List<Historical_Claim__c> historicalClaimsToProcessList = new List<Historical_Claim__c>();

		CSA__c casInstance = new CSA__c();
		Map<Id, CSA__c> csaByHistoricalClaimId = new Map<Id, CSA__c>();
		//Map<String, Id> historicalClaimIdByCSANumber = new Map<String, Id>();
		Set<String> historicalClaimCSANumberSet = new Set<String>();
		Set<String> historicalClaimHCPCSet = new Set<String>();
		Set<String> drugHCPCSet = new Set<String>();
		Set<String> drugNDCSet = new Set<String>();
		Set<String> csaSet = new Set<String>();
		Map<String, Drug__c> drugByHCPCS = new Map<String, Drug__c>();
		Map<String, Id> drugIdByNDC = new Map<String, Id>();
		Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
		String HCPCSCodeTrunc;

		for(Historical_Claim__c historicalClaimRecord : historicalClaimsList){
			//historicalClaimIdByCSANumber.put(historicalClaimRecord.CSA_Number__c, historicalClaimRecord.Id);
			if(!String.isBlank(historicalClaimRecord.HCPCS_Code__c)) {
				HCPCSCodeTrunc = historicalClaimRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			}
			historicalClaimCSANumberSet.add(historicalClaimRecord.CSA_Number__c);
			historicalClaimHCPCSet.add(HCPCSCodeTrunc);
			System.debug('historicalClaimRecord.CSA_Number__c = ' + historicalClaimRecord.CSA_Number__c);
			System.debug('historicalClaimRecord.HCPCS_Code__c = ' + historicalClaimRecord.HCPCS_Code__c);
			System.debug('historicalClaimRecord.Id = ' + historicalClaimRecord.Id);
		}

		DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
		System.debug('historicalClaimCSANumberSet = ' + historicalClaimHCPCSet);
		List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(historicalClaimHCPCSet);
		for(Drug__c drugRecord : drugList) {
			if(drugRecord.Coding_Level__c == 'HCPCS') {
				drugByHCPCS.put(drugRecord.J_Code__c, drugRecord);
			}
			drugHCPCSet.add(drugRecord.J_Code__c);
			drugById.put(drugRecord.Id, drugRecord);
			System.debug('drugRecord.J_Code__c = ' + drugRecord.J_Code__c);
		}
		System.debug('drugHCPCSet = ' + drugHCPCSet);

		NDCsSelector ndcsSelector = (NDCsSelector)PMd_Application.Selector.newInstance(NDC__c.SObjectType);
		List<NDC__c> ndcList =  ndcsSelector.selectByDrugId(drugById.keySet());

		for(NDC__c ndcRecord : ndcList) {
			System.debug('ndcRecord.Drug__r.Coding_Level__c = ' + ndcRecord.Drug__r.Coding_Level__c);
			System.debug('ndcRecord.Drug__r.J_Code__c = ' + ndcRecord.Drug__r.J_Code__c);
			System.debug('ndcRecord.Name = ' + ndcRecord.Name);
			drugIdByNDC.put(ndcRecord.Name, ndcRecord.Drug__c);
			drugNDCSet.add(ndcRecord.Name);
		}

		//Process the criteria for Daily Claims to Process After Insert.
		//Create the CSA Domain with onBeforeInsert to generate SAH1 Hash for CSA_Number
		//Create the CAS Selector
		//Create method getCSAByDailyClaimId that generates a Map of CASs by Daily_CliamId. Use the CSA_Number to match.
		/*
		If HCPCS (Drug) does not exist, then don’t process record
		If Control, Suffix, Account (CSA Object) does not exist, then don’t process record
		*/

		//List<CSA__c> csaList = new List<CSA__c>();
		//ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		//csaByHistoricalClaimId = cSAsDomain.getCSAsById(historicalClaimIdByCSANumber);
		CSAsSelector csasSelector = (CSAsSelector)PMd_Application.Selector.newInstance(CSA__c.SObjectType);
		System.debug('historicalClaimCSANumberSet = ' + historicalClaimCSANumberSet);
		List<CSA__c> matchingCSA_NumbersList = csasSelector.selectByCSANumber(historicalClaimCSANumberSet);
		for(CSA__c csaRecord : matchingCSA_NumbersList) {
			csaSet.add(csaRecord.CSA_Number__c);
			System.debug('csaRecord.CSA_Number__c = ' + csaRecord.CSA_Number__c);
		}
		System.debug('csaSet = ' + csaSet);

		for(Historical_Claim__c historicalClaim : historicalClaimsList) {
			//CSA__c csaRecord = csaByHistoricalClaimId.get(historicalClaim.Id);
			HCPCSCodeTrunc = historicalClaim.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			System.debug('HCPCS_Code__c = ' + HCPCSCodeTrunc);
			System.debug('CSA_Number__c = ' + historicalClaim.CSA_Number__c);
			System.debug('NDC__c = ' + historicalClaim.NDC__c);
			//Don't proceess HCPCS Mismatch claims when HCPCS drug code is not found in Drug list
			Boolean drugFound = false;
			Drug__c drugRecord = drugById.get(drugIdByNDC.get(historicalClaim.NDC__c));
			if(drugNDCSet.contains(historicalClaim.NDC__c) && drugRecord.Coding_Level__c == 'HCPCS + NDC' && drugRecord != null) {
				drugFound = true;
			} else {
				drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
				if (drugRecord != null && drugHCPCSet.contains(HCPCSCodeTrunc) && drugRecord.Coding_Level__c == 'HCPCS') {
					drugFound = true;
				}
			}
			System.debug('drugRecord = ' + drugRecord);
			System.debug('drugFound = ' + drugFound);

			if(historicalClaim.HCPCS_Code__c == null
					|| historicalClaim.HCPCS_Code__c.equals('')
					//|| !drugHCPCSet.contains(historicalClaim.HCPCS_Code__c)
					|| !drugFound
					)
			{
				//HCPCS Mismatch. Don't process
			} else if(!csaSet.contains(historicalClaim.CSA_Number__c)) {
				//CSA Mismatch. Don't process
			}  else {
				//Process
				historicalClaimsToProcessList.add(historicalClaim);
				//System.debug('casRecord.CSA_Number = ' + csaRecord.CSA_Number__c);
			}

			System.debug('csaByHistoricalClaimId.get(historicalCLaim.Id) = ' +csaByHistoricalClaimId.get(historicalCLaim.Id));
			System.debug('Primary_Claim_Number__c = ' + historicalClaim.Primary_Claim_Number__c);
		}
		System.debug('historicalClaimsToProcessList Count = ' + historicalClaimsToProcessList.size());

		//Process HistoricalClaims - Create Contacts, ContactDrugs, and Enrollment Cases for new members.
		if(historicalClaimsToProcessList.size() > 0) {
			ProcessHistoricalClaimsAfterInsert(historicalClaimsToProcessList);
		}
		System.debug('End Historical_Claims:onAfterInsert');
	}
/*
//public override void processAfterUpdate(){
	public override void onAfterUpdate(Map<Id, SObject> existingRecords){
		//List<Member_Drug__c> lstMemberDrug = Trigger.new;
		List<Historical_Claim__c> historicalClaimList = Records;
		List<Historical_Claim__c> Historical_ClaimsToProcessList = new List<Historical_Claim__c>();

		//Process the criteria for Historical Claim to Process After Insert.
		//Create the CSA Domain with onBeforeInsert to generate SAH1 Hash for CSA_Number
		//Create the CAS Selector
	
		for(Historical_Claim__c historicalClaim : historicalClaimList){
			//if(HCPCS (Drug) exit) && CSA Object exist
			Historical_ClaimsToProcessList.add(historicalClaim);

		}


		if(Historical_ClaimsToProcessList.size() > 0) {
			//ProcessContactDrugsAfterUpdate - Create Contacts, ContactDrugs, and Enrollment Cases for new members.
			//ProcessMemberDrugsAfterUpdate(LstToProcess);
		}
	}
*/
}