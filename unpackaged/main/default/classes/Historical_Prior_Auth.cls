/**
     * @description       : Historical Prior Auth Domain class.
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
    public class Historical_Prior_Auth extends fflib_SObjectDomain
            implements IHistorical_Prior_Auth, ContactsService.ISupportContacts
    {
        private static Integer maxHCPCSCodeSize = 5;
        //The constructor should always accept a list of the SObject type we're creating the domain class for
        //It should then pass this list to the fflib_SObjectDomain class's constructor which is what super(cases) does.
        //This sets the records value in the fflib_SObjectDomain class which is very important
        public Historical_Prior_Auth(List<Historical_Prior_Auth__c> sObjectList)
        {
            // Domain classes are initialised with lists to enforce bulkification throughout
            super(sObjectList);
        }

        public static IHistorical_Prior_Auth newInstance(List<Historical_Prior_Auth__c> recordList)
        {
            return (IHistorical_Prior_Auth) PMd_Application.Domain.newInstance(recordList);
        }
/*
	public static IHistorical_Prior_Auth newInstance(Historical_Prior_Auth__c record, Historical_Prior_Auth_JSONRequest request)
	{
		return (IHistorical_Prior_Auth) PMd_Application.Domain.newInstance(record, request);
	}
*/
        public static IHistorical_Prior_Auth newInstance(Set<Id> recordIdSet)
        {
            return (IHistorical_Prior_Auth) PMd_Application.Domain.newInstance(recordIdSet);
        }


        /***************************************************************************************************************************************
         * Domain Specific Operations
         **************************************************************************************************************************************/

        private List<Contact_Drug__c> existingContact_DrugList;

        //Do Post Rest API
        public void doRestAPIPost(List<Historical_Prior_Auth__c> recordList) {

        }

        //Do Post Rest API
        void doRestAPIPost(fflib_ISObjectUnitOfWork uow) {

        }

        //Do Post Rest API
        public static Historical_Prior_Auth__c newInstance(Historical_Prior_Auth_JSONRequest request) {
            Historical_Prior_Auth__c historicalPriorAuthInstance = new Historical_Prior_Auth__c();
            //TODO: Verify all field types are correcct
            historicalPriorAuthInstance.CSA_Account__c = FormatterUtilService.textFormatter(request.Account_Number);
            historicalPriorAuthInstance.Prior_Authorization__c = FormatterUtilService.textFormatter(request.Authorization_Number);
            historicalPriorAuthInstance.Service_Start_Date__c = FormatterUtilService.dateFormatter(request.Service_Start_Date);
            historicalPriorAuthInstance.Service_End_Date__c = FormatterUtilService.dateFormatter(request.Service_End_Date);
            //historicalPriorAuthInstance.Authorized_Representative__c = FormatterUtilService.textFormatter(request.Authorized_Representative);
            //historicalPriorAuthInstance.Authorized_Relationship__c = FormatterUtilService.textFormatter(request.Authorized_Representative_Relationship);
            //historicalPriorAuthInstance.Total_Copay__c = Decimal.valueOf(FormatterUtilService.numberFormatter(request.Copay_Amount));
            historicalPriorAuthInstance.CSA_Control__c = FormatterUtilService.textFormatter(request.Control_Number);
            historicalPriorAuthInstance.Diagnosis_Code__c = FormatterUtilService.textFormatter(request.Diagnosis_Code);
            historicalPriorAuthInstance.Drug_Label_Name__c = FormatterUtilService.textFormatter(request.Drug_Label_Name);
            historicalPriorAuthInstance.HCPCS_Code__c	 = FormatterUtilService.textFormatter(request.ICD9_Procedure_Code);
            historicalPriorAuthInstance.NDC__c = FormatterUtilService.textFormatter(request.National_Drug_Code);
            //historicalPriorAuthInstance.PA_Approval_Dates__c = FormatterUtilService.dateFormatter(request.PA_Approval_Dates);
            //System.Debug('historicalPriorAuthInstance.PA_Approval_Dates__c = ' + historicalPriorAuthInstance.PA_Approval_Dates__c);
            historicalPriorAuthInstance.Patient_Birth_Date__c = FormatterUtilService.dateFormatter(request.Patient_Birth_Date);
            //historicalPriorAuthInstance.Patient_Email_Address__c = FormatterUtilService.textFormatter(request.Patient_Email_Address);
            historicalPriorAuthInstance.Patient_First_Name__c = FormatterUtilService.textFormatter(request.Patient_First_Name);
            historicalPriorAuthInstance.Patient_Last_Name__c = FormatterUtilService.textFormatter(request.Patient_Last_Name);
            historicalPriorAuthInstance.Patient_Middle_Initial__c = FormatterUtilService.textFormatter(request.Patient_Middle_Initial);
            historicalPriorAuthInstance.Patient_Phone_Number__c = FormatterUtilService.phoneFormatter(request.Patient_Phone_Number);
            //historicalPriorAuthInstance.Patient_Gender__c = FormatterUtilService.genderFormatter(request.Patient_Sex);
            historicalPriorAuthInstance.Patient_Gender__c = FormatterUtilService.genderFormatter(request.Patient_Sex);
            historicalPriorAuthInstance.Plan_Sponsor_Name__c = FormatterUtilService.textFormatter(request.Policy_Holder_Name);
            historicalPriorAuthInstance.Prescriber_Address_Line_1__c = FormatterUtilService.textFormatter(request.Prescriber_Address_Line1);
            historicalPriorAuthInstance.Prescriber_City__c = FormatterUtilService.textFormatter(request.Prescriber_City);
            historicalPriorAuthInstance.Prescriber_Fax__c = FormatterUtilService.phoneFormatter(request.Prescriber_Fax);
            historicalPriorAuthInstance.Prescriber_First_Name__c = FormatterUtilService.textFormatter(request.Prescriber_First_Name);
            historicalPriorAuthInstance.Prescriber_Last_Name__c = FormatterUtilService.textFormatter(request.Prescriber_Last_Name);
            historicalPriorAuthInstance.Prescriber_Phone__c = FormatterUtilService.phoneFormatter(request.Prescriber_Phone);
            historicalPriorAuthInstance.Prescriber_Practice_Name__c = FormatterUtilService.textFormatter(request.Prescriber_Practice_Name);
            historicalPriorAuthInstance.Prescriber_NPI_Number__c = FormatterUtilService.textFormatter(request.Prescriber_NPI_Number);
            historicalPriorAuthInstance.Prescriber_Specialty__c = FormatterUtilService.textFormatter(request.Prescriber_Specialty);
            historicalPriorAuthInstance.Prescriber_State__c = FormatterUtilService.textFormatter(request.Prescriber_State);
            historicalPriorAuthInstance.Prescriber_Zip_Code__c = FormatterUtilService.textFormatter(request.Prescriber_Zip_Code);
            historicalPriorAuthInstance.Service_Provider_Fax__c = FormatterUtilService.phoneFormatter(request.Service_Provider_Fax);
            historicalPriorAuthInstance.Service_Provider_Phone__c = FormatterUtilService.phoneFormatter(request.Service_Provider_Phone);
            historicalPriorAuthInstance.Service_Provider_Address_Line_1__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Address_Line_1);
            historicalPriorAuthInstance.Service_Provider_City__c = FormatterUtilService.textFormatter(request.Servicing_Provider_City);
            historicalPriorAuthInstance.Service_Provider_First_Name__c = FormatterUtilService.textFormatter(request.Servicing_Provider_First_Name);
            historicalPriorAuthInstance.Service_Provider_Last_Name__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Last_Name);
            historicalPriorAuthInstance.Service_Provider_NPI__c = FormatterUtilService.textFormatter(request.Servicing_Provider_National_Provider_Identifier);
            historicalPriorAuthInstance.Service_Provider_Zip__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Service_Location_Zip_Code);
            historicalPriorAuthInstance.Service_Provider_Specialty_Code__c = FormatterUtilService.textFormatter(request.Servicing_Provider_Specialty_Code);
            historicalPriorAuthInstance.Service_Provider_State__c = FormatterUtilService.textFormatter(request.Servicing_Provider_State_Code);
            historicalPriorAuthInstance.Service_Provider_Practice__c =FormatterUtilService.textFormatter(request.Servicing_Provider_Practice_Role_Name);
            historicalPriorAuthInstance.Patient_Address_Line_1__c	 = FormatterUtilService.textFormatter(request.Subscriber_Address_Line_1);
            historicalPriorAuthInstance.Patient_Address_Line_2__c = FormatterUtilService.textFormatter(request.Subscriber_Address_Line_2);
            historicalPriorAuthInstance.Patient_City__c = FormatterUtilService.textFormatter(request.Subscriber_City);
            historicalPriorAuthInstance.Patient_CUMB_ID__c = FormatterUtilService.textFormatter(request.Subscriber_CUMB_ID);
            historicalPriorAuthInstance.Relationship_Code__c = FormatterUtilService.textFormatter(request.Member_Relationship_Code);
            historicalPriorAuthInstance.Patient_State__c = FormatterUtilService.textFormatter(request.Subscriber_State_Code);
            historicalPriorAuthInstance.Patient_Zip_Code__c = FormatterUtilService.textFormatter(request.Subscriber_Zip_Code);
            historicalPriorAuthInstance.CSA_Suffix__c = FormatterUtilService.textFormatter(request.Suffix_Number);
            historicalPriorAuthInstance.Plan_Sponsor_Unique_ID__c = FormatterUtilService.textFormatter(request.Funding_Indicator);
            historicalPriorAuthInstance.Primary_Subscriber_Name__c = FormatterUtilService.textFormatter(request.Subscriber_Name);
            historicalPriorAuthInstance.Primary_Subscriber_Relationship__c = FormatterUtilService.textFormatter(request.Subscriber_Relationship);
            //historicalPriorAuthInstance.Billing_Provider_PIN__c = FormatterUtilService.textFormatter(request.Billing_Provider_PIN);
            //historicalPriorAuthInstance.Billing_Provider_Address_Line_1__c = FormatterUtilService.textFormatter(request.Billing_Provider_Street_Address_Line_1);
            //historicalPriorAuthInstance.Billing_Provider_City__c = FormatterUtilService.textFormatter(request.Billing_Provider_City);
            //historicalPriorAuthInstance.Billing_Provider_State__c = FormatterUtilService.textFormatter(request.Billing_Provider_State_Code);
            //historicalPriorAuthInstance.Billing_Provider_Zip_Code__c = FormatterUtilService.textFormatter(request.Billing_Provider_Zip_Code);

            historicalPriorAuthInstance.Prudent_In_Data_Staging_ID__c = FormatterUtilService.textFormatter(request.prudentInDataStagingId);

            //TODO: Verify the Historical_Claim unique ID can be based on 'Claim_Inicator, Claim_Line_Identifier, National_Drug_Code'
            //historicalPriorAuthInstance.External_Prior_Authorization__c = SHA1UtilService.getBase64SHA1Hash(historicalPriorAuthInstance.Claim_Code__c + historicalPriorAuthInstance.Claim_Line__c + historicalPriorAuthInstance.NDC__c);

            return historicalPriorAuthInstance;
        }

        public static List<RestAPI_JSONResponse> SaveResults(List<Historical_Prior_Auth__c> historicalPriorAuthInsertList, List<Historical_Prior_Auth__c> historicalPriorAuthUpsertList, String JSONString) {

            List<RestAPI_JSONResponse> responses = new List<RestAPI_JSONResponse>();
            Integer recordCount = 0;

            //TODO: Use UnitOfWork
            //Insert
            Database.SaveResult[] saveInsertResults = Database.insert(historicalPriorAuthInsertList, false);

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
                responseInstance.prudentInHistoricalPriorAuthId = historicalPriorAuthInsertList[recordCount].Prudent_In_Data_Staging_ID__c;
                responses.add(responseInstance);
                recordCount++;
            }
/*
            recordCount = 0;

            //Upsert
            Schema.SObjectField authNumberField = Historical_Prior_Auth__c.Fields.External_Authorization_Number__c;
            Database.UpsertResult[] saveUpsertResults = Database.upsert(historicalPriorAuthUpsertList, authNumberField, false);
            for (Database.UpsertResult sr : saveUpsertResults) {
                RestAPI_JSONResponse responseInstance = new RestAPI_JSONResponse();
                if (sr.isSuccess()) {
                    responseInstance.status = 'Success';
                } else {
                    responseInstance.status = 'Failure';
                    if (sr.getErrors().size() > 0) {
                        responseInstance.errorMessage = sr.getErrors()[0].getMessage();
                        ErrorLog.log('Historical_Prior_Auth__c API PrudentRestResource', '', JSONString, '', '', sr.getErrors()[0].getMessage(), null);
                    }
                }
                //responseInstance.hbsPatientId = priorAuthUpsertList[recordCount].HBS_ID__c;
                //responseInstance.caremarkMemberId = priorAuthUpsertList[recordCount].Patient_CUMB_ID__c;
                responseInstance.prudentInHistoricalPriorAuthId = historicalPriorAuthUpsertList[recordCount].Prudent_In_Data_Staging_ID__c;
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
            for (Historical_Prior_Auth__c record : (List<Historical_Prior_Auth__c>) getRecords())
            {
                if (record.CSA_Account__c != null)
                {
                    result.add(record.CSA_Account__c);
                }
            }
            return result;
        }

        /**
         * Process Historical_Prior_Auth for the given source records (so long as their domain classes implement ISupportpriorAuths)
         **/
        /*
        public void process(List<Historical_Prior_Auth__c> priorAuthList) {

            // Contact Factory helps domain classes produce Contacts
            ContactsService.ContactFactory contactFactory = new ContactsService.ContactFactory(uow);
            // Construct domain class capabile of processing Historical Claim
            fflib_IDomain domain =
                    PMd_Application.Domain.newInstance(priorAuthList);
            if (domain instanceof ContactsService.ISupportContacts) {

                // Ask the domain object to process its Historical Claim
                ContactsService.ISupportContacts contacts = (ContactsService.ISupportContacts) domain;
                contacts.process(contactFactory);
            }
        }
    */
        //Use this method for clients like Batch Jobs, Controllers, etc.
        public void process(ContactsService.ContactFactory contactFactory) {

            System.debug('Start processing Contacts for Historical Claim');
/*
		Set<Decimal> cumbId = new Set<Decimal>();
		Set<Date> birthDate = new Set<Date>();
		Set<String> firstName = new Set<String>();
		Set<String> lastName = new Set<String>();
		List<Historical_Prior_Auth__c> priorAuthList = (List<Historical_Prior_Auth__c>) getRecords();

		for(Historical_Prior_Auth__c priorAuth : priorAuthList){
			//cumbId.add(priorAuth.Patient_CUMB_ID__c);
			birthDate.add(priorAuth.Patient_Birth_Date__c);
			firstName.add(priorAuth.Patient_First_Name__c);
			lastName.add(priorAuth.Patient_Last_Name__c);
		}

		// Create unit of work to capture work and commit it under one transaction
		fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

		//TODO: Get matching contacts from Historical Claim
		ContactsSelector contactsSelector = (ContactsSelector)PMd_Application.Selector.newInstance(Contact.SObjectType);
		//TODO: Use ContactSelector to get matching existing contacts

		List<Contact> existingContacts = contactsSelector.selectByCumbIdBdLnFn(cumbId, birthDate, firstName, lastName);
		Map<Id, Contact> existingpriorAuthContactsById = new Map<Id, Contact>(existingContacts);
		//TODO: Get map of existing Contacts by Historical Claim Id
		Map<Id, Contact> existingContactsBypriorAuthId = mapContactsBypriorAuthId(existingContacts, priorAuthList);

		process(contactFactory, existingContactsBypriorAuthId, uow);
*/
            System.debug('End processing Contacts for Historical Claim');
        }

        //Use this method for trigger operations
        private void process(ContactsService.ContactFactory contactFactory, Map<Id, Contact> existingContactsBypriorAuthId, fflib_ISObjectUnitOfWork uow) {
            System.debug('Start processing Contacts for Historical Claim');
            // Create Contacts from the given Historical Claim
            List<SObject> newContactsList = new List<SObject>();
            List<SObject> existingContactsList = new List<SObject>();
            for(Historical_Prior_Auth__c historicalPriorAuth : (List<Historical_Prior_Auth__c>) getRecords()) {
                /*
                    If Contact does not exists based on logic above:
                    Then create Contact, ContactDrug, Claim, and Enrollment Case.
                    If Contact does exist based on logic above:
                    Then update Contact (refer to mapping document for fields), then check ContactDrug processing logic
                */
                Contact existingContact = existingContactsBypriorAuthId.get(historicalPriorAuth.Id);
                if(existingContact != null) {
                    existingContact = mappriorAuthToContact(historicalPriorAuth, existingContact);
                    existingContactsList.add(existingContact);
                } else {
                    //Create new Contact form Historical Claim
                    Contact newContact = new Contact();
                    newContact = mappriorAuthToContact(historicalPriorAuth, newContact);
                    newContactsList.add(newContact);
                }
            }
            uow.registerDirty(existingContactsList);
            uow.registerNew(newContactsList);

            System.debug('End processing Contacts for Historical Claim');
        }

        //TODO: Map Historical Claim fields to new Contact fields
        private Contact mappriorAuthToContact(Historical_Prior_Auth__c historicalPriorAuth, Contact contact) {

            contact.CSA_Account__c = historicalPriorAuth.CSA_Account__c;
            contact.FirstName = historicalPriorAuth.Patient_First_Name__c;
            contact.LastName = historicalPriorAuth.Patient_Last_Name__c;
            contact.Patient_Birth_Date__c = historicalPriorAuth.Patient_Birth_Date__c;
            //contact.Patient_Address_Line_1__c = historicalPriorAuth.Patient_Address_Line_1__c;
            contact.MailingCity = historicalPriorAuth.Patient_City__c;
            contact.MailingState = historicalPriorAuth.Patient_State__c;

            return contact;
        }
/*
    public class Constructor implements fflib_IDomainConstructor
	{
		public fflib_SObjects construct(List<Object> objectList)
		{
			return new Historical_Prior_Auth((List<SObject>) objectList);
		}
/*
		public fflib_SObjects construct(SObject obj, Object objectInstance)
		{
			return new Historical_Prior_Auth((SObject) obj, (Object) objectInstance);
		}
		*/
//	}

        //The name of this inner class must always be Constructor to work appropriately. This acts as a way to use the concept of reflection when initializing
        //this class, despite the fact apex still does not support it.
        public class Constructor implements fflib_SObjectDomain.IConstructable
        {
            public fflib_SObjectDomain construct(List<SObject> sObjectList)
            {
                return new Historical_Prior_Auth(sObjectList);
            }
        }

        //Generate map of Contacts By Historical Claim Ids
        Map<Id, Contact> mapContactsBypriorAuthId(List<Contact> existingContactList, List<Historical_Prior_Auth__c> historicalPriorAuthList ) {
            Map<Id, Contact> existingContactsByHistoricalPAId = new Map<Id, Contact>();
            for(Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthList) {
                for(Contact contact : existingContactList) {
                    if(historicalPriorAuth.Patient_First_Name__c == contact.FirstName
                            && historicalPriorAuth.Patient_Last_Name__c == contact.LastName
                            && historicalPriorAuth.Patient_Birth_Date__c == contact.Patient_Birth_Date__c)
                    {
                        existingContactsByHistoricalPAId.put(historicalPriorAuth.id, contact);
                    }
                }
            }
            return existingContactsByHistoricalPAId;
        }

        /*
    * Method Name: processHistoricalPriorAuthsBeforeInsert
    * Description:
    */
        private void processHistoricalPriorAuthsBeforeInsert(List<Historical_Prior_Auth__c> priorAuthList) {

            for(Historical_Prior_Auth__c priorAuth : priorAuthList){


            }
        }

        /*
        * Method Name: processHistoricalPriorAuthsAfterInsert
        * Description:
        */
        public void processHistoricalPriorAuthsAfterInsert(List<Historical_Prior_Auth__c> historicalPriorAuthList) {
            System.debug('Start processing Historical_Prior_Auth After Insert');
            // Create unit of work to capture work and commit it under one transaction
            fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

            //Process Contacts for Historical_Prior_Auth
            processHistoricalPriorAuthContacts(historicalPriorAuthList, uow);

            try {
                uow.commitWork();

                //Instantiate a new UnitOfWork
                uow = PMd_Application.UnitOfWork.newInstance();
                //Process ContactDrugs for Historical_Prior_Auth
                processHistoricalPriorAuthContactDrugs(historicalPriorAuthList, uow);
            }catch(DmlException e){
                Integer numErrors = e.getNumDml();
                System.debug('getNumDml=' + numErrors);
                for(Integer i=0;i<numErrors;i++) {
                    System.debug('getDmlId=' + e.getDmlId(i));
                    System.debug('getDmlFieldNames=' + e.getDmlFieldNames(i));
                    System.debug('getDmlMessage=' + e.getDmlMessage(i));
                }
                System.debug('++ ' + e.getMessage());
                ErrorLog.log('Cases.process.processHistoricalPriorAuthsAfterInsert.processHistoricalPriorAuthContacts', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, null, null, historicalPriorAuthList[0].Id);
                ErrorLog.commitLogs();
                //throw e;
            }

            try {
                uow.commitWork();

                //Instantiate a new UnitOfWork
                uow = PMd_Application.UnitOfWork.newInstance();
                //Process Cases for Historical_Prior_Auth
                processHistoricalPriorAuthCases(historicalPriorAuthList, uow);
            }catch(Exception e){
                System.debug('++ ' + e.getMessage());
                ErrorLog.log('Cases.process.processHistoricalPriorAuthsAfterInsert.processHistoricalPriorAuthContactDrugs', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, null, null, historicalPriorAuthList[0].Id);
                ErrorLog.commitLogs();
                //throw e;
            }

            // Commit updates to all Historical_Prior_Auth related Objects
            try {
                uow.commitWork();
            }catch(Exception e){
                System.debug('++ ' + e.getMessage());
                ErrorLog.log('Cases.process.processHistoricalPriorAuthsAfterInsert.processHistoricalPriorAuthCases', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, null, null, historicalPriorAuthList[0].Id);
                ErrorLog.commitLogs();
                ///throw e;
            }

            System.debug('Stop processing Historical_Prior_Auth After Insert');
        }


        private void processHistoricalPriorAuthContacts(List<Historical_Prior_Auth__c> historicalPriorAuthList, fflib_ISObjectUnitOfWork uow) {
            System.debug('Start processing Contacts for Historical_Prior_Auth');

            // Contact Factory helps domain classes produce Contacts
            //ContactsService.ContactFactory contactFactory = new ContactsService.ContactFactory(uow);
            List<Contact> contactList = new List<Contact>();
            IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);

            contactsDomain.process(historicalPriorAuthList, uow);

            System.debug('Stop processing Contacts for Historical_Prior_Auth');
        }

        private void processHistoricalPriorAuthContactDrugs(List<Historical_Prior_Auth__c> historicalPriorAuthList, fflib_ISObjectUnitOfWork uow) {
            System.debug('Start processing Contact_Drugs for Historical_Prior_Auth');

            List<Contact_Drug__c> contact_DrugsList = new List<Contact_Drug__c>();

            // ContactDrug Factory helps domain classes produce Contact_drugs
            //Create ContactDrugsService.ContactDrugsFactory class
            //ContactDrugsService.ContactDrugsFactory contactDrugFactory = new ContactDrugsService.ContactDrugsFactory (uow);
            IContact_Drugs contact_DrugsDomain = (IContact_Drugs) PMd_Application.Domain.newInstance(contact_DrugsList);
            existingContact_DrugList = contact_DrugsDomain.process(historicalPriorAuthList, uow);

            System.debug('Stop processing Contact_Drugs for Historical_Prior_Auth');
        }

        private void processHistoricalPriorAuthCases(List<Historical_Prior_Auth__c> historicalPriorAuthList, fflib_ISObjectUnitOfWork uow) {
            System.debug('Start processing Cases for Historical_Prior_Auth');

            //Claim Factory Factory helps domain classes produce Cases
            List<Case> casesList = new List<Case>();
            ICases casesDomain = (ICases) PMd_Application.Domain.newInstance(casesList);

            casesDomain.process(historicalPriorAuthList, existingContact_DrugList, uow);

            System.debug('Stop processing Cases for Historical_Prior_Auth');
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
            System.debug('Start Historical_Prior_Auth:onBeforeInsert');
            //List<Member_Drug__c> lstMemberDrug = Trigger.new;
            List<Historical_Prior_Auth__c> historicalPriorAuthList = Records;
            List<Historical_Prior_Auth__c> historicalPriorAuthToProcessList = new List<Historical_Prior_Auth__c>();

            //Process the criteria for Historical_Prior_Auth to Process Before Insert
            CSA__c casInstance = new CSA__c();
            Map<Id, CSA__c> csaByHistoricalPriorAuthId = new Map<Id, CSA__c>();
           //Map<String, Id> historicalPriorAuthIdByCSANumber = new Map<String, Id>();
            Set<String>  historicalPriorAuthCSANumberSet = new Set<String>();
            String claim_NumberSeed;
            Set<String> historicalPriorAuthHCPCSet = new Set<String>();
            Set<String> drugHCPCSet = new Set<String>();
            Set<String> drugNDCSet = new Set<String>();
            String sha1Hash_Id, HCPCSCodeTrunc;
            Set<String> csaSet = new Set<String>();
            Map<String, Drug__c> drugByHCPCS = new Map<String, Drug__c>();
            Map<String, Id> drugIdByNDC = new Map<String, Id>();
            Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
            Drug__c drugRecord;

            for(Historical_Prior_Auth__c historicalPriorAuthInstance : historicalPriorAuthList){

                historicalPriorAuthInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                        historicalPriorAuthInstance.CSA_Control__c + '-' +
                                historicalPriorAuthInstance.CSA_Suffix__c + '-' +
                                historicalPriorAuthInstance.CSA_Account__c
                );

                System.debug('historicalhistoricalPriorAuthInstance.CSA_Number__c = '+ historicalPriorAuthInstance.CSA_Number__c);

                sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
                        historicalPriorAuthInstance.Patient_CUMB_ID__c + '-'
                                + historicalPriorAuthInstance.Patient_Birth_Date__c + '-'
                                + historicalPriorAuthInstance.Patient_First_Name__c + '-'
                                + historicalPriorAuthInstance.Patient_Last_Name__c
                );
                historicalPriorAuthInstance.SHA1Hash_ID__c = sha1Hash_Id;
                System.debug('historicalPriorAuthInstance.Patient_CUMB_ID__c = : '+ historicalPriorAuthInstance.Patient_CUMB_ID__c);
                System.debug('historicalPriorAuthInstance.Patient_Birth_Date__c = : '+ historicalPriorAuthInstance.Patient_Birth_Date__c);
                System.debug('historicalPriorAuthInstance.Patient_First_Name__c : '+ historicalPriorAuthInstance.Patient_First_Name__c);
                System.debug('historicalPriorAuthInstance.Patient_Last_Name__c : '+ historicalPriorAuthInstance.Patient_Last_Name__c);
                System.debug('Existing Contacts sha1Hash_Id = : '+ sha1Hash_Id);
            }

            for(Historical_Prior_Auth__c historicalPriorAuthRecord : historicalPriorAuthList){
                //historicalPriorAuthIdByCSANumber.put(historicalPriorAuthRecord.CSA_Number__c, historicalPriorAuthRecord.Id);
                HCPCSCodeTrunc = historicalPriorAuthRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
                historicalPriorAuthCSANumberSet.add(historicalPriorAuthRecord.CSA_Number__c);
                historicalPriorAuthHCPCSet.add(HCPCSCodeTrunc);
                System.debug('historicalPriorAuthRecord.CSA_Number__c = ' + historicalPriorAuthRecord.CSA_Number__c);
                System.debug('historicalPriorAuthRecord.HCPCS_Code__c = ' + HCPCSCodeTrunc);
                System.debug('historicalPriorAuthRecord.Id = ' + historicalPriorAuthRecord.Id);
            }

            DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
            List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(historicalPriorAuthHCPCSet);
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
                System.debug('ndcRecord.Drug__r.Coding_Level__c = ' + ndcRecord.Drug__r.Coding_Level__c);
                System.debug('ndcRecord.Drug__r.J_Code__c = ' + ndcRecord.Drug__r.J_Code__c);
                System.debug('ndcRecord.Name = ' + ndcRecord.Name);
                drugIdByNDC.put(ndcRecord.Name, ndcRecord.Drug__c);
                if(ndcRecord.Name != '') {
                    drugNDCSet.add(ndcRecord.Name);
                }
            }

            CSAsSelector csasSelector = (CSAsSelector)PMd_Application.Selector.newInstance(CSA__c.SObjectType);
            List<CSA__c> matchingCSA_NumbersList = csasSelector.selectByCSANumber(historicalPriorAuthCSANumberSet);
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
            csaByhistoricalPriorAuthId = cSAsDomain.getCSAsById(historicalPriorAuthIdByCSANumber);
             */

            for(Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthList) {
                HCPCSCodeTrunc = historicalPriorAuth.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
                System.debug('HCPCS_Code__c = ' + HCPCSCodeTrunc);
                System.debug('NDC__c = ' + historicalPriorAuth.NDC__c);
                System.debug('drugNDCSet = ' + drugNDCSet);
                //Error out HCPCS Mismatch claims when HCPCS drug code is not found in Drug list
                Boolean drugFound = false;
                drugRecord = drugById.get(drugIdByNDC.get(historicalPriorAuth.NDC__c));
                if(drugNDCSet.contains(historicalPriorAuth.NDC__c) && drugRecord != null && drugRecord.Coding_Level__c == 'HCPCS + NDC') {
                    drugFound = true;
                    drugRecord = drugById.get(drugIdByNDC.get(historicalPriorAuth.NDC__c));
                } else {
                    drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
                    if (drugRecord != null && drugHCPCSet.contains(HCPCSCodeTrunc) && drugRecord.Coding_Level__c == 'HCPCS') {
                        drugFound = true;
                        drugRecord = drugByHCPCS.get(HCPCSCodeTrunc);
                    }
                }
                System.debug('drugRecord = ' + drugRecord);
                System.debug('drugFound = ' + drugFound);

                if(HCPCSCodeTrunc== null
                        || HCPCSCodeTrunc.equals('')
                        //|| !drugHCPCSet.contains(historicalPriorAuth.HCPCS_Code__c)
                        || !drugFound
                    )
                {
                    historicalPriorAuth.Status__c = 'Error';
                    historicalPriorAuth.Error_Log__c = 'HCPCS Mismatch';
                } else if(!csaSet.contains(historicalPriorAuth.CSA_Number__c)) {
                    historicalPriorAuth.Status__c = 'Error';
                    historicalPriorAuth.Error_Log__c = 'CSA Mismatch';
                }  else {
                    historicalPriorAuth.Drug_Label_Name__c = drugRecord.Name;
                    historicalPriorAuthToProcessList.add(historicalPriorAuth);
                }

            }

            if(historicalPriorAuthToProcessList.size() > 0) {
                processHistoricalPriorAuthsBeforeInsert(historicalPriorAuthToProcessList);
            }
            System.debug('Stop Historical_Prior_Auth:onBeforeInsert');
        }

        public override void onBeforeUpdate(Map<Id, SObject> oldRecords) {
            System.debug('Start Historical_Prior_Auth:onBeforeUpdate');

            List<Historical_Prior_Auth__c> historicalPriorAuthList = Records;
            List<Historical_Prior_Auth__c> historicalPriorAuthToProcessList = new List<Historical_Prior_Auth__c>();
            String sha1Hash_Id;

            for(Historical_Prior_Auth__c historicalPriorAuthInstance : historicalPriorAuthList){

                sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
                        historicalPriorAuthInstance.Patient_CUMB_ID__c + '-'
                                + historicalPriorAuthInstance.Patient_Birth_Date__c + '-'
                                + historicalPriorAuthInstance.Patient_First_Name__c + '-'
                                + historicalPriorAuthInstance.Patient_Last_Name__c
                );
                historicalPriorAuthInstance.SHA1Hash_ID__c = sha1Hash_Id;
                System.debug('historicalPriorAuthInstance.Patient_CUMB_ID__c = : '+ historicalPriorAuthInstance.Patient_CUMB_ID__c);
                System.debug('historicalPriorAuthInstance.Patient_Birth_Date__c = : '+ historicalPriorAuthInstance.Patient_Birth_Date__c);
                System.debug('historicalPriorAuthInstance.Patient_First_Name__c : '+ historicalPriorAuthInstance.Patient_First_Name__c);
                System.debug('historicalPriorAuthInstance.Patient_Last_Name__c : '+ historicalPriorAuthInstance.Patient_Last_Name__c);
                System.debug('Existing Contacts sha1Hash_Id = : '+ sha1Hash_Id);
            }

            if(historicalPriorAuthToProcessList.size() > 0) {
                //ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
            }
            System.debug('End Historical_Prior_Auth:onBeforeUpdate');
        }

//    public override void processAfterInsert(){
        public override void onAfterInsert() {
            System.debug('Start Historical_Prior_Auths:onAfterInsert');
            //List<Member_Drug__c> lstMemberDrug = Trigger.new;
            List<Historical_Prior_Auth__c> historicalPriorAuthList = Records;
            List<Historical_Prior_Auth__c> historicalPriorAuthToProcessList = new List<Historical_Prior_Auth__c>();

            //Process the criteria for Historical_Prior_Auth to Process After Insert.
            //Create the CSA Domain with onBeforeInsert to generate SAH1 Hash for CSA_Number
            //Create the CAS Selector
            //Use the same code in Daily_Claims onAfterInsert
            CSA__c casInstance = new CSA__c();
            Map<Id, CSA__c> csaByHistoricalPriorAuthId = new Map<Id, CSA__c>();
            //Map<String, Id> historicalPriorAuthIdByCSANumber = new Map<String, Id>();
            Set<String>  historicalPriorAuthCSANumberSet = new Set<String>();
            Set<String> historicalPriorAuthHCPCSet = new Set<String>();
            Set<String> drugHCPCSet = new Set<String>();
            Set<String> drugNDCSet = new Set<String>();
            Set<String> csaSet = new Set<String>();
            Map<String, Drug__c> drugByHCPCS = new Map<String, Drug__c>();
            Map<String, Id> drugIdByNDC = new Map<String, Id>();
            Map<Id, Drug__C> drugById = new Map<Id, Drug__c>();
            String HCPCSCodeTrunc;

            for(Historical_Prior_Auth__c historicalPriorAuthRecord : historicalPriorAuthList){
                //historicalPriorAuthIdByCSANumber.put(historicalPriorAuthRecord.CSA_Number__c, historicalPriorAuthRecord.Id);
                HCPCSCodeTrunc = historicalPriorAuthRecord.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
                historicalPriorAuthCSANumberSet.add(historicalPriorAuthRecord.CSA_Number__c);
                historicalPriorAuthHCPCSet.add(HCPCSCodeTrunc);
                System.debug('historicalPriorAuthRecord.CSA_Number__c = ' + historicalPriorAuthRecord.CSA_Number__c);
                System.debug('historicalPriorAuthRecord.HCPCS_Code__c = ' + historicalPriorAuthRecord.HCPCS_Code__c);
                System.debug('historicalPriorAuthRecord.Id = ' + historicalPriorAuthRecord.Id);
            }

            DrugsSelector drugsSelector = (DrugsSelector)PMd_Application.Selector.newInstance(Drug__c.SObjectType);
            System.debug('historicalPriorAuthHCPCSet = ' + historicalPriorAuthHCPCSet);
            List<Drug__c> drugList =  drugsSelector.selectByHCPCSNumber(historicalPriorAuthHCPCSet);
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
                if(ndcRecord.Name != '') {
                    drugNDCSet.add(ndcRecord.Name);
                }
            }

            CSAsSelector csasSelector = (CSAsSelector)PMd_Application.Selector.newInstance(CSA__c.SObjectType);
            List<CSA__c> matchingCSA_NumbersList = csasSelector.selectByCSANumber(historicalPriorAuthCSANumberSet);
            for(CSA__c csaRecord : matchingCSA_NumbersList) {
                csaSet.add(csaRecord.CSA_Number__c);
                System.debug('csaRecord.CSA_Number__c = ' + csaRecord.CSA_Number__c);
            }
            System.debug('csaSet = ' + csaSet);

            //Process the criteria for Daily Claims to Process After Insert.
            //Create the CSA Domain with onBeforeInsert to generate SAH1 Hash for CSA_Number
            //Create the CAS Selector
            //Create method getCSAByhistoricalPriorAuthId that generates a Map of CASs by Daily_CliamId. Use the CSA_Number to match.
            /*
            If HCPCS (Drug) does not exist, then don’t process record
            If Control, Suffix, Account (CSA Object) does not exist, then don’t process record


            List<CSA__c> csaList = new List<CSA__c>();
            ICSAs cSAsDomain = (ICSAs) PMd_Application.Domain.newInstance(csaList);
            csaByHistoricalPriorAuthId = cSAsDomain.getCSAsById(historicalPriorAuthIdByCSANumber);
            */

            for(Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthList) {
                CSA__c csaRecord = csaByHistoricalPriorAuthId.get(historicalPriorAuth.Id);
                HCPCSCodeTrunc = historicalPriorAuth.HCPCS_Code__c.substring(0, maxHCPCSCodeSize);
                System.debug('HCPCS_Code__c = ' + HCPCSCodeTrunc);
                System.debug('NDC__c = ' + historicalPriorAuth.NDC__c);
                System.debug('drugNDCSet = ' + drugNDCSet);
                //Don't process HCPCS Mismatch claims when HCPCS drug code is not found in Drug list
                Boolean drugFound = false;
                Drug__c drugRecord = drugById.get(drugIdByNDC.get(historicalPriorAuth.NDC__c));
                if(drugNDCSet.contains(historicalPriorAuth.NDC__c) && drugRecord.Coding_Level__c == 'HCPCS + NDC' && drugRecord != null) {
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
                        //|| !drugHCPCSet.contains(historicalPriorAuth.HCPCS_Code__c)
                        || !drugFound
                        )
                {
                    //HCPCS Mismatch. Don't process
                } else if(!csaSet.contains(historicalPriorAuth.CSA_Number__c)) {
                    //CSA Mismatch. Don't process
                }  else {
                    //Process
                    historicalPriorAuthToProcessList.add(historicalPriorAuth);
                    //System.debug('casRecord.CSA_Number = ' + csaRecord.CSA_Number__c);
                }
            }
            System.debug('historicalPriorAuthToProcessList Count = ' + historicalPriorAuthToProcessList.size());

            //Process historicalPriorAuths - Create Contacts, ContactDrugs, and Enrollment Cases for new members.
            if(historicalPriorAuthToProcessList.size() > 0) {
                processHistoricalPriorAuthsAfterInsert(historicalPriorAuthToProcessList);
            }
            System.debug('End Historical_Prior_Auths:onAfterInsert');
        }

//public override void processAfterUpdate(){
        public override void onAfterUpdate(Map<Id, SObject> existingRecords){
            //List<Member_Drug__c> lstMemberDrug = Trigger.new;
            List<Historical_Prior_Auth__c> historicalPriorAuthList = Records;
            List<Historical_Prior_Auth__c> historical_Prior_AuthToProcessList = new List<Historical_Prior_Auth__c>();

            //TODO: Process the criteria for Historical Claim to Process After Insert.
            //TODO: Create the CSA Domain with onBeforeInsert to generate SAH1 Hash for CSA_Number
            //TODO: Create the CAS Selector

            for(Historical_Prior_Auth__c historicalPriorAuth : historicalPriorAuthList){
                //if(HCPCS (Drug) exit) && CSA Object exist
                historical_Prior_AuthToProcessList.add(historicalPriorAuth);
            }

            if(Historical_Prior_AuthToProcessList.size() > 0) {
                //TODO: ProcessContactDrugsAfterUpdate - Create Contacts, ContactDrugs, and Enrollment Cases for new members.
                //ProcessMemberDrugsAfterUpdate(LstToProcess);
            }
        }

    }