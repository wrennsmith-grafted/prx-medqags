/** 
 * @description       : Member_Demo Domain class.
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
public class Provider_Demographic extends fflib_SObjectDomain
    implements IProvider_Demographic, ContactsService.ISupportContacts
{
	//The constructor should always accept a list of the SObject type we're creating the domain class for
	//It should then pass this list to the fflib_SObjectDomain class's constructor which is what super(cases) does.
	//This sets the records value in the fflib_SObjectDomain class which is very important
	public Provider_Demographic(List<Provider_Demographic__c> sObjectList)
	{
		// Domain classes are initialised with lists to enforce bulkification throughout
		super(sObjectList);
	}

    public static IProvider_Demographic newInstance(List<Provider_Demographic__c> recordList)
	{
		return (IProvider_Demographic) PMd_Application.Domain.newInstance(recordList);
	}
/*
	public static IProvider_Demographic newInstance(Provider_Demographic__c record, Provider_Demographic_JSONRequest request)
	{
		return (IProvider_Demographic) PMd_Application.Domain.newInstance(record, request);
	}
*/
	public static IProvider_Demographic newInstance(Set<Id> recordIdSet)
	{
		return (IProvider_Demographic) PMd_Application.Domain.newInstance(recordIdSet);
	}


	/***************************************************************************************************************************************
     * Domain Specific Operations
     **************************************************************************************************************************************/

    //Do Post Rest API
    public void doRestAPIPost(List<Provider_Demographic__c> recordList) {

    }

	//Do Post Rest API
	void doRestAPIPost(fflib_ISObjectUnitOfWork uow) {

	}

	//Do Post Rest API
	public static Provider_Demographic__c newInstance(Provider_Demographic_JSONRequest request) {
		Provider_Demographic__c ProviderDemographicInstance = new Provider_Demographic__c();
		//TODO: Verify all field types are correcct
		
		
		//Provider_Demographic__c ProviderDemographicInstance = new Provider_Demographic__c();

		ProviderDemographicInstance.Service_Provider_NPI__c = FormatterUtilService.textFormatter(request.Provider_NPI);
		ProviderDemographicInstance.Service_Provider_Phone__c = FormatterUtilService.phoneFormatter(request.Service_Provider_Phone);
		ProviderDemographicInstance.Service_Provider_Fax__c = FormatterUtilService.phoneFormatter(request.Service_Provider_Fax);
		ProviderDemographicInstance.Billing_Provider_Phone__c = FormatterUtilService.phoneFormatter(request.Billing_Provider_Phone);
		ProviderDemographicInstance.Billing_Provider_Fax__c = FormatterUtilService.phoneFormatter(request.Billing_Provider_Fax);

		ProviderDemographicInstance.Prudent_In_Data_Staging_ID__c = request.prudentInDataStagingId;
        
       
		//TODO: Verify the Member_Demo unique ID can be based on 'Claim_Indicator, Claim_Line_Identifier, National_Drug_Code'
		//ProviderDemographicInstance.External_Prior_Authorization__c = SHA1UtilService.getBase64SHA1Hash(ProviderDemographicInstance.Claim_Code__c + ProviderDemographicInstance.Claim_Line__c + ProviderDemographicInstance.NDC__c);
		//ProviderDemographicInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(ProviderDemographicInstance.CSA_Control__c + ProviderDemographicInstance.CSA_Suffix__c + ProviderDemographicInstance.CSA_Account__c);

		return ProviderDemographicInstance;
	}

	public static List<RestAPI_JSONResponse> SaveResults(List<Provider_Demographic__c> ProviderDemographicInsertList, List<Provider_Demographic__c> ProviderDemographicUpsertList, String JSONString) {

		List<RestAPI_JSONResponse> responses = new List<RestAPI_JSONResponse>();
		Integer recordCount = 0;

		//TODO: Use UnitOfWork
		//Insert
		Database.SaveResult[] saveInsertResults = Database.insert(ProviderDemographicInsertList, false);

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
			//responseInstance.hbsPatientId = ProviderDemographicInsertList[recordCount].HBS_ID__c;
			//responseInstance.caremarkMemberId = ProviderDemographicInsertList[recordCount].Patient_CUMB_ID__c;
			responseInstance.prudentInProviderDemographicId = ProviderDemographicInsertList[recordCount].Prudent_In_Data_Staging_ID__c;
			responses.add(responseInstance);
			recordCount++;
		}

		recordCount = 0;

		//Upsert
		Schema.SObjectField authNumberField = Provider_Demographic__c.Fields.External_Authorization_Number__c;
		Database.UpsertResult[] saveUpsertResults = Database.upsert(ProviderDemographicUpsertList, authNumberField, false);
		for (Database.UpsertResult sr : saveUpsertResults) {
			RestAPI_JSONResponse responseInstance = new RestAPI_JSONResponse();
			if (sr.isSuccess()) {
				responseInstance.status = 'Success';
			} else {
				responseInstance.status = 'Failure';
				if (sr.getErrors().size() > 0) {
					responseInstance.errorMessage = sr.getErrors()[0].getMessage();
					ErrorLog.log('Provider_Demographic__c API PrudentRestResource', '', JSONString, '', '', sr.getErrors()[0].getMessage(), null);
				}
			}
			//responseInstance.hbsPatientId = ProviderDemographicUpsertList[recordCount].HBS_ID__c;
			//responseInstance.caremarkMemberId = ProviderDemographicUpsertList[recordCount].Patient_CUMB_ID__c;
			responseInstance.prudentInProviderDemographicId = ProviderDemographicUpsertList[recordCount].Prudent_In_Data_Staging_ID__c;
			responses.add(responseInstance);
			recordCount++;
		}

		return responses;
	}

			//Use this method for clients like Batch Jobs, Controllers, etc.
	public void process(ContactsService.ContactFactory contactFactory) {
		System.debug('Start processing Contacts for Provider Demographic');

		//Set<Decimal> cumbId = new Set<Decimal>();
		//Set<Date> birthDate = new Set<Date>();
		//Set<String> firstName = new Set<String>();
		//Set<String> lastName = new Set<String>();
		//List<Prior_Auth__c> priorAuthList = (List<Prior_Auth__c>) getRecords();

		

		// Create unit of work to capture work and commit it under one transaction
		fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

		//TODO: Get matching contacts from PriorAuth Claim
		ContactsSelector contactsSelector = (ContactsSelector)PMd_Application.Selector.newInstance(Contact.SObjectType);
		//TODO: Use ContactSelector to get matching existing contacts
		/*
			Look for an existing member based on: Add tiered matching logic.
				Subscriber CUMB ID
				Patient Birth Date
				Patient Last Name
				Patient First Name
		 */
		//List<Contact> existingContacts = contactsSelector.selectByCumbIdBdLnFn(cumbId, birthDate, firstName, lastName);
		//Map<Id, Contact> existingpriorAuthContactsById = new Map<Id, Contact>(existingContacts);
		//TODO: Get map of existing Contacts by PriorAuth Claim Id
		//Map<Id, Contact> existingContactsBypriorAuthId = mapContactsBypriorAuthId(existingContacts, priorAuthList);

		//process(contactFactory, existingContactsBypriorAuthId, uow);

		System.debug('End processing Contacts for Provider Demographic');
	}

	//The name of this inner class must always be Constructor to work appropriately. This acts as a way to use the concept of reflection when initializing
	//this class, despite the fact apex still does not support it.
	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new Provider_Demographic(sObjectList);
		}
	}
}