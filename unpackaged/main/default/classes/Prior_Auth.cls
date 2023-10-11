/** 
 * @description       : Prior Auth Domain class.
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
public class Prior_Auth extends fflib_SObjectDomain
    implements IPrior_Auth, ContactsService.ISupportContacts
{
	private static Integer maxHCPCSCodeSize = 5;
	//The constructor should always accept a list of the SObject type we're creating the domain class for
	//It should then pass this list to the fflib_SObjectDomain class's constructor which is what super(cases) does.
	//This sets the records value in the fflib_SObjectDomain class which is very important
	public Prior_Auth(List<Prior_Auth__c> sObjectList)
	{
		// Domain classes are initialised with lists to enforce bulkification throughout
		super(sObjectList);
	}

    public static IPrior_Auth newInstance(List<Prior_Auth__c> recordList)
	{
		return (IPrior_Auth) PMd_Application.Domain.newInstance(recordList);
	}
/*
	public static IPrior_Auth newInstance(Prior_Auth__c record, Prior_Auth_JSONRequest request)
	{
		return (IPrior_Auth) PMd_Application.Domain.newInstance(record, request);
	}
*/
	public static IPrior_Auth newInstance(Set<Id> recordIdSet)
	{
		return (IPrior_Auth) PMd_Application.Domain.newInstance(recordIdSet);
	}


	/***************************************************************************************************************************************
     * Domain Specific Operations
     **************************************************************************************************************************************/

	private List<Contact_Drug__c> existingContact_DrugList;

    //Do Post Rest API
    public void doRestAPIPost(List<Prior_Auth__c> recordList) {

    }

	//Do Post Rest API
	void doRestAPIPost(fflib_ISObjectUnitOfWork uow) {

	}

	//Do Post Rest API
	public static Prior_Auth__c newInstance(Prior_Auth_JSONRequest request) {
		Prior_Auth__c priorAuthInstance = new Prior_Auth__c();
		//TODO: Verify all field types are correct
		priorAuthInstance.CSA_Account__c = FormatterUtilService.textFormatter(request.Account_Number);
		priorAuthInstance.Prior_Authorization__c = FormatterUtilService.textFormatter(request.Authorization_Number);
		priorAuthInstance.Service_Start_Date__c = FormatterUtilService.dateFormatter(request.Service_Start_Date);
		priorAuthInstance.Service_End_Date__c = FormatterUtilService.dateFormatter(request.Service_End_Date);
		//priorAuthInstance.Authorized_Representative__c = FormatterUtilService.textFormatter(request.Authorized_Representative);
		//priorAuthInstance.Authorized_Relationship__c = FormatterUtilService.textFormatter(request.Authorized_Representative_Relationship);
		//priorAuthInstance.Total_Copay__c = Decimal.valueOf(FormatterUtilService.numberFormatter(request.Copay_Amount));
		priorAuthInstance.CSA_Control__c = FormatterUtilService.textFormatter(request.Control_Number);
		priorAuthInstance.Diagnosis_Code__c = FormatterUtilService.textFormatter(request.Diagnosis_Code);
		priorAuthInstance.Drug_Label_Name__c = FormatterUtilService.textFormatter(request.Drug_Label_Name);
		priorAuthInstance.HCPCS_Code__c	 = FormatterUtilService.textFormatter(request.ICD9_Procedure_Code);
		priorAuthInstance.NDC__c = FormatterUtilService.textFormatter(request.National_Drug_Code);
		//priorAuthInstance.PA_Approval_Dates__c = FormatterUtilService.dateFormatter(request.PA_Approval_Dates);
		priorAuthInstance.Patient_Birth_Date__c = FormatterUtilService.dateFormatter(request.Patient_Birth_Date);
		//priorAuthInstance.Patient_Email_Address__c = FormatterUtilService.textFormatter(request.Patient_Email_Address);
		priorAuthInstance.Patient_First_Name__c = FormatterUtilService.textFormatter(request.Patient_First_Name);
		priorAuthInstance.Patient_Last_Name__c = FormatterUtilService.textFormatter(request.Patient_Last_Name);
		priorAuthInstance.Patient_Middle_Initial__c = FormatterUtilService.textFormatter(request.Patient_Middle_Initial);
		priorAuthInstance.Patient_Phone_Number__c = FormatterUtilService.phoneFormatter(request.Patient_Phone_Number);
		//priorAuthInstance.Patient_Gender__c = FormatterUtilService.genderFormatter(request.Patient_Sex);
		priorAuthInstance.Patient_Gender__c = FormatterUtilService.genderFormatter(request.Patient_Sex);
		priorAuthInstance.Plan_Sponsor_Name__c = FormatterUtilService.textFormatter(request.Policy_Holder_Name);
		priorAuthInstance.Prescriber_Address_Line_1__c = FormatterUtilService.textFormatter(request.Prescriber_Address_Line1);
		priorAuthInstance.Prescriber_City__c = FormatterUtilService.textFormatter(request.Prescriber_City);
		priorAuthInstance.Prescriber_Fax__c = FormatterUtilService.phoneFormatter(request.Prescriber_Fax);
		priorAuthInstance.Prescriber_First_Name__c = FormatterUtilService.textFormatter(request.Prescriber_First_Name);
		priorAuthInstance.Prescriber_Last_Name__c = FormatterUtilService.textFormatter(request.Prescriber_Last_Name);
		priorAuthInstance.Prescriber_Phone__c = FormatterUtilService.phoneFormatter(request.Prescriber_Phone);
		priorAuthInstance.Prescriber_Practice_Name__c = FormatterUtilService.textFormatter(request.Prescriber_Practice_Name);
		priorAuthInstance.Prescriber_NPI_Number__c = FormatterUtilService.textFormatter(request.Prescriber_NPI_Number);
		priorAuthInstance.Prescriber_Specialty__c = FormatterUtilService.textFormatter(request.Prescriber_Specialty);
		priorAuthInstance.Prescriber_State__c = FormatterUtilService.textFormatter(request.Prescriber_State);
		priorAuthInstance.Prescriber_Zip_Code__c = FormatterUtilService.textFormatter(request.Prescriber_Zip_Code);
		priorAuthInstance.Service_Provider_Fax__c = FormatterUtilService.phoneFormatter(request.Service_Provider_Fax);
		priorAuthInstance.Service_Provider_Phone__c = FormatterUtilService.phoneFormatter(request.Service_Provider_Phone);
		priorAuthInstance.Service_Provider_Address_Line_1__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Address_Line_1);
		priorAuthInstance.Service_Provider_City__c = FormatterUtilService.textFormatter(request.Servicing_Provider_City);
		priorAuthInstance.Service_Provider_First_Name__c = FormatterUtilService.textFormatter(request.Servicing_Provider_First_Name);
		priorAuthInstance.Service_Provider_Last_Name__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Last_Name);
		priorAuthInstance.Service_Provider_NPI__c = FormatterUtilService.textFormatter(request.Servicing_Provider_National_Provider_Identifier);
		priorAuthInstance.Service_Provider_Zip__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Service_Location_Zip_Code);
		priorAuthInstance.Service_Provider_Specialty_Code__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Specialty_Code);
		priorAuthInstance.Service_Provider_State__c = FormatterUtilService.textFormatter(request.Servicing_Provider_State_Code);
		priorAuthInstance.Service_Provider_Practice__c =FormatterUtilService.textFormatter(request.Servicing_Provider_Practice_Role_Name);
		priorAuthInstance.Patient_Address_Line_1__c	 = FormatterUtilService.textFormatter(request.Subscriber_Address_Line_1);
		priorAuthInstance.Patient_Address_Line_2__c = FormatterUtilService.textFormatter(request.Subscriber_Address_Line_2);
		priorAuthInstance.Patient_City__c = FormatterUtilService.textFormatter(request.Subscriber_City);
		priorAuthInstance.Patient_CUMB_ID__c = FormatterUtilService.textFormatter(request.Subscriber_CUMB_ID);
		priorAuthInstance.Relationship_Code__c = FormatterUtilService.textFormatter(request.Member_Relationship_Code);
		priorAuthInstance.Patient_State__c = FormatterUtilService.textFormatter(request.Subscriber_State_Code);
		priorAuthInstance.Patient_Zip_Code__c = FormatterUtilService.textFormatter(request.Subscriber_Zip_Code);
		priorAuthInstance.CSA_Suffix__c = FormatterUtilService.textFormatter(request.Suffix_Number);
		priorAuthInstance.Plan_Sponsor_Unique_ID__c = FormatterUtilService.textFormatter(request.Funding_Indicator);
		//priorAuthInstance.Billing_Provider_PIN__c = FormatterUtilService.textFormatter(request.Billing_Provider_PIN);
		//priorAuthInstance.Billing_Provider_Address_Line_1__c = FormatterUtilService.textFormatter(request.Billing_Provider_Street_Address_Line_1);
		//priorAuthInstance.Billing_Provider_City__c = FormatterUtilService.textFormatter(request.Billing_Provider_City);
		//priorAuthInstance.Billing_Provider_State__c = FormatterUtilService.textFormatter(request.Billing_Provider_State_Code);
		//priorAuthInstance.Billing_Provider_Zip_Code__c = FormatterUtilService.textFormatter(request.Billing_Provider_Zip_Code);

		priorAuthInstance.Prudent_In_Data_Staging_ID__c = FormatterUtilService.textFormatter(request.prudentInDataStagingId);

		//TODO: Verify the Historical_Claim unique ID can be based on 'Claim_Inicator, Claim_Line_Identifier, National_Drug_Code'
		//priorAuthInstance.External_Prior_Authorization__c = SHA1UtilService.getBase64SHA1Hash(priorAuthInstance.Claim_Code__c + priorAuthInstance.Claim_Line__c + priorAuthInstance.NDC__c);

		return priorAuthInstance;
	}

	public static List<RestAPI_JSONResponse> SaveResults(List<Prior_Auth__c> priorAuthInsertList, List<Prior_Auth__c> priorAuthUpsertList, String JSONString) {

		List<RestAPI_JSONResponse> responses = new List<RestAPI_JSONResponse>();
		/*
		Integer recordCount = 0;

		//TODO: Use UnitOfWork
		//Insert
		Database.SaveResult[] saveInsertResults = Database.insert(priorAuthInsertList, false);

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
			//responseInstance.hbsPatientId = priorAuthInsertList[recordCount].HBS_ID__c;
			//responseInstance.caremarkMemberId = priorAuthInsertList[recordCount].Patient_CUMB_ID__c;
			responseInstance.prudentInpriorAuthId = priorAuthInsertList[recordCount].Prudent_In_Data_Staging_ID__c;
			responses.add(responseInstance);
			recordCount++;
		}

		recordCount = 0;

		//Upsert
		Schema.SObjectField authNumberField = Prior_Auth__c.Fields.External_Authorization_Number__c;
		Database.UpsertResult[] saveUpsertResults = Database.upsert(priorAuthUpsertList, authNumberField, false);
		for (Database.UpsertResult sr : saveUpsertResults) {
			RestAPI_JSONResponse responseInstance = new RestAPI_JSONResponse();
			if (sr.isSuccess()) {
				responseInstance.status = 'Success';
			} else {
				responseInstance.status = 'Failure';
				if (sr.getErrors().size() > 0) {
					responseInstance.errorMessage = sr.getErrors()[0].getMessage();
					ErrorLog.log('Prior_Auth__c API PrudentRestResource', '', JSONString, '', '', sr.getErrors()[0].getMessage(), null);
				}
			}
			//responseInstance.hbsPatientId = priorAuthUpsertList[recordCount].HBS_ID__c;
			//responseInstance.caremarkMemberId = priorAuthUpsertList[recordCount].Patient_CUMB_ID__c;
			responseInstance.prudentInpriorAuthId = priorAuthUpsertList[recordCount].Prudent_In_Data_Staging_ID__c;
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
		for (Prior_Auth__c record : (List<Prior_Auth__c>) getRecords())
		{
			if (record.CSA_Account__c != null)
			{
				result.add(record.CSA_Account__c);
			}
		}
		return result;
	}

	/**
	 * Process Prior_Auth for the given source records (so long as their domain classes implement ISupportpriorAuths)
	 **/
	/*
	public void process(List<Prior_Auth__c> priorAuthList) {

		// Contact Factory helps domain classes produce Contacts
		ContactsService.ContactFactory contactFactory = new ContactsService.ContactFactory(uow);
		// Construct domain class capabile of processing Prior Auth
		fflib_IDomain domain =
				PMd_Application.Domain.newInstance(priorAuthList);
		if (domain instanceof ContactsService.ISupportContacts) {

			// Ask the domain object to process its Prior Auth
			ContactsService.ISupportContacts contacts = (ContactsService.ISupportContacts) domain;
			contacts.process(contactFactory);
		}
	}
*/
	//Use this method for clients like Batch Jobs, Controllers, etc.
	public void process(ContactsService.ContactFactory contactFactory) {

		System.debug('Start processing Contacts for Prior Auth');
/*
		Set<Decimal> cumbId = new Set<Decimal>();
		Set<Date> birthDate = new Set<Date>();
		Set<String> firstName = new Set<String>();
		Set<String> lastName = new Set<String>();
		List<Prior_Auth__c> priorAuthList = (List<Prior_Auth__c>) getRecords();

		for(Prior_Auth__c priorAuth : priorAuthList){
			//cumbId.add(priorAuth.Patient_CUMB_ID__c);
			birthDate.add(priorAuth.Patient_Birth_Date__c);
			firstName.add(priorAuth.Patient_First_Name__c);
			lastName.add(priorAuth.Patient_Last_Name__c);
		}

		// Create unit of work to capture work and commit it under one transaction
		fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

		//Get matching contacts from Prior Auth
		ContactsSelector contactsSelector = (ContactsSelector)PMd_Application.Selector.newInstance(Contact.SObjectType);
		//Use ContactSelector to get matching existing contacts

		List<Contact> existingContacts = contactsSelector.selectByCumbIdBdLnFn(cumbId, birthDate, firstName, lastName);
		Map<Id, Contact> existingpriorAuthContactsById = new Map<Id, Contact>(existingContacts);
		//Get map of existing Contacts by Prior Auth Id
		Map<Id, Contact> existingContactsBypriorAuthId = mapContactsBypriorAuthId(existingContacts, priorAuthList);

		process(contactFactory, existingContactsBypriorAuthId, uow);
*/
		System.debug('End processing Contacts for Prior Auth');
	}

	//Use this method for trigger operations
	private void process(ContactsService.ContactFactory contactFactory, Map<Id, Contact> existingContactsBypriorAuthId, fflib_ISObjectUnitOfWork uow) {
		System.debug('Start processing Contacts for Prior Auth');
		// Create Contacts from the given Prior Auth
		List<SObject> newContactsList = new List<SObject>();
		List<SObject> existingContactsList = new List<SObject>();
		for(Prior_Auth__c priorAuth : (List<Prior_Auth__c>) getRecords()) {
			/*
				If Contact does not exists based on logic above:
				Then create Contact, ContactDrug, Claim, and Enrollment Case.
				If Contact does exist based on logic above:
				Then update Contact (refer to mapping document for fields), then check ContactDrug processing logic
			*/
			Contact existingContact = existingContactsBypriorAuthId.get(priorAuth.Id);
			if(existingContact != null) {
				existingContact = mapPriorAuthToContact(priorAuth, existingContact);
				existingContactsList.add(existingContact);
			} else {
				//Create new Contact form Prior Auth
				Contact newContact = new Contact();
				newContact = mapPriorAuthToContact(priorAuth, newContact);
				newContactsList.add(newContact);
			}
		}
		uow.registerDirty(existingContactsList);
		uow.registerNew(newContactsList);

		System.debug('End processing Contacts for Prior Auth');
	}

	//TODO: Map Prior Auth fields to new Contact fields
	private Contact mapPriorAuthToContact(Prior_Auth__c priorAuth, Contact contact) {

		contact.CSA_Account__c = priorAuth.CSA_Account__c;
		contact.FirstName = priorAuth.Patient_First_Name__c;
		contact.LastName = priorAuth.Patient_Last_Name__c;
		contact.Patient_Birth_Date__c = priorAuth.Patient_Birth_Date__c;
		//contact.Patient_Address_Line_1__c = priorAuth.Patient_Address_Line_1__c;
		contact.MailingCity = priorAuth.Patient_City__c;
		contact.MailingState = priorAuth.Patient_State__c;

		return contact;
	}
/*
    public class Constructor implements fflib_IDomainConstructor
	{
		public fflib_SObjects construct(List<Object> objectList)
		{
			return new Prior_Auth((List<SObject>) objectList);
		}
/*
		public fflib_SObjects construct(SObject obj, Object objectInstance)
		{
			return new Prior_Auth((SObject) obj, (Object) objectInstance);
		}
		*/
//	}

	//The name of this inner class must always be Constructor to work appropriately. This acts as a way to use the concept of reflection when initializing
	//this class, despite the fact apex still does not support it.
	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new Prior_Auth(sObjectList);
		}
	}

	//Generate map of Contacts By Prior Auth Ids
	Map<Id, Contact> mapContactsByPriorAuthId(List<Contact> existingContactList, List<Prior_Auth__c> priorAuthList ) {
		Map<Id, Contact> existingContactsBypriorAuthId = new Map<Id, Contact>();
		for(Prior_Auth__c priorAuth : priorAuthList) {
			for(Contact contact : existingContactList) {
				if(priorAuth.Patient_First_Name__c == contact.FirstName
						&& priorAuth.Patient_Last_Name__c == contact.LastName
						&& priorAuth.Patient_Birth_Date__c == contact.Patient_Birth_Date__c)
				{
					existingContactsBypriorAuthId.put(priorAuth.id, contact);
				}
			}
		}
		return existingContactsBypriorAuthId;
	}

	/*
* Method Name: ProcesspriorAuthsBeforeInsert
* Description:
*/
	private void processPriorAuthsBeforeInsert(List<Prior_Auth__c> priorAuthList) {

		for(Prior_Auth__c priorAuth : priorAuthList){


		}
	}

	/*
    * Method Name: ProcesspriorAuthsAfterInsert
    * Description:
    */
	public void processPriorAuthsAfterInsert(List<Prior_Auth__c> priorAuthList) {
		System.debug('Start processing Prior_Auth After Insert');
		// Create unit of work to capture work and commit it under one transaction
		fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

		//Process Contacts for Prior_Auth
		processPriorAuthContacts(priorAuthList, uow);
		try {
			uow.commitWork();

			//Instantiate a new UnitOfWork
			uow = PMd_Application.UnitOfWork.newInstance();
			//Process ContactDrugs for Prior_Auth
			processPriorAuthContactDrugs(priorAuthList, uow);
		}catch(Exception e){
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Cases.process.processPriorAuthsAfterInsert.processPriorAuthContacts', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, null, priorAuthList[0].Id, null);
			ErrorLog.commitLogs();
			//throw e;
		}

		try {
			uow.commitWork();

			//Instantiate a new UnitOfWork
			uow = PMd_Application.UnitOfWork.newInstance();
			//Process Cases for Prior_Auth
			processPriorAuthCases(priorAuthList, uow);
		}catch(Exception e){
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Cases.process.processPriorAuthsAfterInsert.processPriorAuthContactDrugs', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, null, priorAuthList[0].Id, null);
			ErrorLog.commitLogs();
			//throw e;
		}

		// Commit updates to all Prior_Auth related Objects
		try {
			uow.commitWork();
		}catch(Exception e){
			System.debug('++ ' + e.getMessage());
			ErrorLog.log('Cases.process.processPriorAuthsAfterInsert.processPriorAuthCases', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, null, priorAuthList[0].Id, null);
			ErrorLog.commitLogs();
			//throw e;
		}

		System.debug('Stop processing Prior_Auth After Insert');
	}


	private void processPriorAuthContacts(List<Prior_Auth__c> priorAuthList, fflib_ISObjectUnitOfWork uow) {
		System.debug('Start processing Contacts for Prior_Auth');

		// Contact Factory helps domain classes produce Contacts
		//ContactsService.ContactFactory contactFactory = new ContactsService.ContactFactory(uow);
		List<Contact> contactList = new List<Contact>();
		IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);

		contactsDomain.process(priorAuthList, uow);

		System.debug('Stop processing Contacts for Prior_Auth');
	}

	private void processPriorAuthContactDrugs(List<Prior_Auth__c> priorAuthList, fflib_ISObjectUnitOfWork uow) {
		System.debug('Start processing Contact_Drugs for Prior_Auth');

		List<Contact_Drug__c> contact_DrugsList = new List<Contact_Drug__c>();

		// ContactDrug Factory helps domain classes produce Contact_drugs
		//Create ContactDrugsService.ContactDrugsFactory class
		//ContactDrugsService.ContactDrugsFactory contactDrugFactory = new ContactDrugsService.ContactDrugsFactory (uow);
		IContact_Drugs contact_DrugsDomain = (IContact_Drugs) PMd_Application.Domain.newInstance(contact_DrugsList);
		existingContact_DrugList = contact_DrugsDomain.process(priorAuthList, uow);

		System.debug('Stop processing Contact_Drugs for Prior_Auth');
	}

	private void processPriorAuthCases(List<Prior_Auth__c> priorAuthList, fflib_ISObjectUnitOfWork uow) {
		System.debug('Start processing Cases for Prior_Auth');

		//Claim Factory Factory helps domain classes produce Cases
		List<Case> casesList = new List<Case>();
		ICases casesDomain = (ICases) PMd_Application.Domain.newInstance(casesList);

		casesDomain.process(priorAuthList, existingContact_DrugList, uow);

		System.debug('Stop processing Cases for Prior_Auth');
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
		//List<Member_Drug__c> lstMemberDrug = Trigger.new;
		List<Prior_Auth__c> priorAuthList = Records;
		List<Prior_Auth__c> priorAuthToProcessList = new List<Prior_Auth__c>();

		//Process the criteria for Prior_Auth to Process Before Insert
		CSA__c casInstance = new CSA__c();
		Map<Id, CSA__c> csaByPriorAuthId = new Map<Id, CSA__c>();
		//Map<String, Id> priorAuthIdByCSANumber = new Map<String, Id>();
		Set<String>  priorAuthCSANumberSet = new Set<String>();
		String claim_NumberSeed;
		Set<String> priorAuthHCPCSet = new Set<String>();
		Set<String> drugHCPCSet = new Set<String>();
		Set<String> drugNDCSet = new Set<String>();
		Set<String> csaSet = new Set<String>();
		Map<String, Drug__c> drugByHCPCS = new Map<String, Drug__c>();
		Map<String, Id> drugIdByNDC = new Map<String, Id>();
		Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
		String HCPCSCodeTrunc;
		Drug__c drugRecord;

		for(Prior_Auth__c priorAuthInstance : priorAuthList){

			priorAuthInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
					priorAuthInstance.CSA_Control__c + '-' +
							priorAuthInstance.CSA_Suffix__c + '-' +
							priorAuthInstance.CSA_Account__c
			);

			System.debug('priorAuthInstance.CSA_Number__c = '+ priorAuthInstance.CSA_Number__c);
		}

		for(Prior_Auth__c priorAuthRecord : priorAuthList){
			//priorAuthCSANumberSet.put(priorAuthRecord.CSA_Number__c, priorAuthRecord.Id);
			HCPCSCodeTrunc = priorAuthRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			priorAuthCSANumberSet.add(priorAuthRecord.CSA_Number__c);
			priorAuthHCPCSet.add(HCPCSCodeTrunc);
			System.debug('priorAuthRecord.CSA_Number__c = ' + priorAuthRecord.CSA_Number__c);
			System.debug('priorAuthRecord.Id = ' + priorAuthRecord.Id);
		}

		DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
		List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(priorAuthHCPCSet);
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
		List<CSA__c> matchingCSA_NumbersList = csasSelector.selectByCSANumber(priorAuthCSANumberSet);
		for(CSA__c csaRecord : matchingCSA_NumbersList) {
			csaSet.add(csaRecord.CSA_Number__c);
			System.debug('csaRecord.CSA_Number__c = ' + csaRecord.CSA_Number__c);
		}
		System.debug('csaSet = ' + csaSet);

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


		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		csaByPriorAuthId = cSAsDomain.getCSAsById(priorAuthIdByCSANumber);
		*/

		for(Prior_Auth__c priorAuth : priorAuthList) {
			HCPCSCodeTrunc = priorAuth.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			System.debug('HCPCS_Code__c = ' +HCPCSCodeTrunc);
			System.debug('NDC__c = ' + priorAuth.NDC__c);
			System.debug('drugNDCSet = ' + drugNDCSet);
			//Error out HCPCS Mismatch claims when HCPCS drug code is not found in Drug list
			Boolean drugFound = false;
			drugRecord = drugById.get(drugIdByNDC.get(priorAuth.NDC__c));
			if(drugNDCSet.contains(priorAuth.NDC__c) && drugRecord != null && drugRecord.Coding_Level__c == 'HCPCS + NDC') {
				drugFound = true;
				drugRecord = drugById.get(drugIdByNDC.get(priorAuth.NDC__c));
			} else {
				drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
				if (drugRecord != null && drugHCPCSet.contains(HCPCSCodeTrunc) && drugRecord.Coding_Level__c == 'HCPCS') {
					drugFound = true;
					drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
				}
			}
			System.debug('drugRecord = ' + drugRecord);
			System.debug('drugFound = ' + drugFound);

			if(HCPCSCodeTrunc == null
					|| HCPCSCodeTrunc.equals('')
					//|| !drugHCPCSet.contains(priorAuth.HCPCS_Code__c)
					|| !drugFound
					)
			{
				priorAuth.Status__c = 'Error';
				priorAuth.Error_Log__c = 'HCPCS Mismatch';
			} else if(!csaSet.contains(priorAuth.CSA_Number__c)) {
				priorAuth.Status__c = 'Error';
				priorAuth.Error_Log__c = 'CSA Mismatch';
			}  else {
				priorAuth.Drug_Label_Name__c = drugRecord.Name;
				priorAuthToProcessList.add(priorAuth);
			}

		}

		if(priorAuthToProcessList.size() > 0) {
			ProcesspriorAuthsBeforeInsert(priorAuthToProcessList);
		}
	}

//    public override void processAfterInsert(){
	public override void onAfterInsert() {
		System.debug('Start Prior_Auths:onAfterInsert');
		//List<Member_Drug__c> lstMemberDrug = Trigger.new;
		List<Prior_Auth__c> priorAuthList = Records;
		List<Prior_Auth__c> priorAuthToProcessList = new List<Prior_Auth__c>();

		//Process the criteria for Prior_Auth to Process After Insert.
		//Create the CSA Domain with onBeforeInsert to generate SAH1 Hash for CSA_Number
		//Create the CAS Selector
		//Use the same code in Daily_Claims onAfterInsert
		CSA__c casInstance = new CSA__c();
		Map<Id, CSA__c> csaByPriorAuthId = new Map<Id, CSA__c>();
		//Map<String, Id> priorAuthIdByCSANumber = new Map<String, Id>();
		Set<String>  priorAuthCSANumberSet = new Set<String>();
		Set<String> priorAuthHCPCSet = new Set<String>();
		Set<String> drugHCPCSet = new Set<String>();
		Set<String> drugNDCSet = new Set<String>();
		Set<String> csaSet = new Set<String>();
		Map<String, Drug__c> drugByHCPCS = new Map<String, Drug__c>();
		Map<String, Id> drugIdByNDC = new Map<String, Id>();
		Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
		String HCPCSCodeTrunc;

		for(Prior_Auth__c priorAuthRecord : priorAuthList){
			//priorAuthIdByCSANumber.put(priorAuthRecord.CSA_Number__c, priorAuthRecord.Id);
			HCPCSCodeTrunc = priorAuthRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			priorAuthCSANumberSet.add(priorAuthRecord.CSA_Number__c);
			priorAuthHCPCSet.add(HCPCSCodeTrunc);
			System.debug('priorAuthRecord.CSA_Number__c = ' + priorAuthRecord.CSA_Number__c);
			System.debug('priorAuthRecord.HCPCS_Code__c = ' +HCPCSCodeTrunc);
			System.debug('priorAuthRecord.Id = ' + priorAuthRecord.Id);
		}

		DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
		List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(priorAuthHCPCSet);
		for(Drug__c drugRecord : drugList) {
			if(drugRecord.Coding_Level__c == 'HCPCS') {
				//HCPCSCodeTrunc = drugRecord.J_Code__c.substring(0, maxHCPCSCodeSize);
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
		List<CSA__c> matchingCSA_NumbersList = csasSelector.selectByCSANumber(priorAuthCSANumberSet);
		for(CSA__c csaRecord : matchingCSA_NumbersList) {
			csaSet.add(csaRecord.CSA_Number__c);
			System.debug('csaRecord.CSA_Number__c = ' + csaRecord.CSA_Number__c);
		}
		System.debug('csaSet = ' + csaSet);

		//Process the criteria for Daily Claims to Process After Insert.
		//Create the CSA Domain with onBeforeInsert to generate SAH1 Hash for CSA_Number
		//Create the CAS Selector
		//Create method getCSAByPriorAuthId that generates a Map of CASs by Daily_CliamId. Use the CSA_Number to match.
		/*
		If HCPCS (Drug) does not exist, then don’t process record
		If Control, Suffix, Account (CSA Object) does not exist, then don’t process record

		List<CSA__c> csaList = new List<CSA__c>();
		ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
		csaByPriorAuthId = cSAsDomain.getCSAsById(priorAuthIdByCSANumber);
		 */

		for(Prior_Auth__c priorAuth : priorAuthList) {
			//CSA__c csaRecord = csaByPriorAuthId.get(priorAuth.Id);
			HCPCSCodeTrunc = priorAuth.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
			System.debug('HCPCS_Code__c = ' + HCPCSCodeTrunc);
			System.debug('NDC__c = ' + priorAuth.NDC__c);
			System.debug('drugNDCSet = ' + drugNDCSet);
			//Don't proceess HCPCS Mismatch claims when HCPCS drug code is not found in Drug list
			Boolean drugFound = false;
			Drug__c drugRecord = drugById.get(drugIdByNDC.get(priorAuth.NDC__c));
			if(drugNDCSet.contains(priorAuth.NDC__c) && drugRecord.Coding_Level__c == 'HCPCS + NDC' && drugRecord != null) {
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

			if(HCPCSCodeTrunc == null
					|| HCPCSCodeTrunc.equals('')
					//|| !drugHCPCSet.contains(priorAuth.HCPCS_Code__c)
					|| !drugFound
				)
			{
				//HCPCS Mismatch. Don't process
			} else if(!csaSet.contains(priorAuth.CSA_Number__c)) {
				//CSA Mismatch. Don't process
			}  else {
				//Process
				priorAuthToProcessList.add(priorAuth);
				//System.debug('casRecord.CSA_Number = ' + csaRecord.CSA_Number__c);
			}
		}
		System.debug('priorAuthToProcessList Count = ' + priorAuthToProcessList.size());

		//Process priorAuths - Create Contacts, ContactDrugs, and Enrollment Cases for new members.
		if(priorAuthToProcessList.size() > 0) {
			processPriorAuthsAfterInsert(priorAuthToProcessList);
		}
		System.debug('End Prior_Auths:onAfterInsert');
	}

//public override void processAfterUpdate(){
	public override void onAfterUpdate(Map<Id, SObject> existingRecords){
		//List<Member_Drug__c> lstMemberDrug = Trigger.new;
		List<Prior_Auth__c> priorAuthList = Records;
		List<Prior_Auth__c> Prior_AuthToProcessList = new List<Prior_Auth__c>();

		//Process the criteria for Prior_Auth to Process After Insert.
		//Create the CSA Domain with onBeforeInsert to generate SAH1 Hash for CSA_Number
		//Create the CAS Selector
	
		for(Prior_Auth__c priorAuth : priorAuthList){
			//if(HCPCS (Drug) exit) && CSA Object exist
			Prior_AuthToProcessList.add(priorAuth);
		}


		if(Prior_AuthToProcessList.size() > 0) {
			//TODO: ProcessContactDrugsAfterUpdate - Create Contacts, ContactDrugs, and Enrollment Cases for new members.
			//ProcessMemberDrugsAfterUpdate(LstToProcess);
		}
	}

}