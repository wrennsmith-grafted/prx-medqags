/**
 * @author Matt Gerry
 * @date 03/30/2021
 * @description This class is used to select data from the case object. It's the only place that case object queries
 * should be made
 */

//We extend the fflib_SObjectSelector class to gain access to its many useful prebuilt methods
//We extend the Task_Selector_Interface to force it to implement a particular set of methods to help with abstraction
//in the Task_Service_Impl class
public inherited sharing class CasesSelector extends fflib_SObjectSelector
		//implements Task_Selector_Interface
{
	private static List<Case> newCases = new List<Case>();
	private static List<Case> introductionCaseByClaimId = new List<Case>();
	private static List<Case> introductionCaseByContactDrug = new List<Case>();
	private static List<Case> enrollmentCaseByClaimId = new List<Case>();
	private static List<Case> enrollmentCaseByContactDrug = new List<Case>();
	private static List<Case> reimbursementCaseByClaimId = new List<Case>();

	public CasesSelector(){
		super(false, true, true, false);
	}
	/*
    public static ICasesSelector newInstance()
    {
        return (ICasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
    }
    */
	//This sets the base fields that you will ALWAYS have in your queries when calling this selector class
	public List<Schema.SObjectField> getSObjectFieldList(){
		return new List<Schema.SObjectField>{
				Case.Id,
				Case.Subject,
				Case.Status,
				Case.ContactId,
				Case.Claim_Information__c,
				Case.Most_Recent_Service_From_Date__c,
				Case.Service_Start_Date__c,
				Case.CreatedDate,
				Case.CaseNumber,
				Case.Service_Provider_Updated_By__c,
				Case.Service_Provider_Updated_Date__c,
				Case.Service_Provider_First_Name__c,
				Case.RecordTypeId
		};
	}

	//This will return your object type for this selector, useful in abstractions
	public Schema.SObjectType getSObjectType(){
		return Case.SObjectType;
	}

	//This method calls the fflib_SObjectSelector classes selectSObjectsById method and returns a list
	//of cases from the caseIds you sent in with the default fields declared in the getSObjectFieldList method above
	public List<Case> selectById(Set<Id> caseIds){
		return (List<Case>) selectSObjectsById(caseIds);
	}
/*
	//This uses the fflib_SObjectSelector class's QueryFactory inner class to create a custom query with
	//extra fields selected and conditions set
	public List<Case> selectCaseByAccount(Set<Id> acctIds){
		return (List<Case>) Database.query(
				newQueryFactory().
						selectField(Case.AccountId).
						setCondition('AccountId IN :acctIds').
						toSOQL()
		);
	}
*/
	//This allows us to select all new cases in the system using the QueryFactory in fflib_SObjectSelector
	//public List<Case> selectNewCases(){
	//return (List<Case>) Database.query(newQueryFactory().
	//		setCondition('Status = \'New\'').setLimit(1000).subselectQuery(Contact).
	//		toSOQL());
	//}

	//This allows us to select all new cases in the system using the QueryFactory in fflib_SObjectSelector
	public List<Case> selectNewCases(){


		if (newCases == null) {
			newCases = (List<Case>) Database.query(newQueryFactory().
				selectField(Case.Origin).
				setCondition('Status = \'New\'').
				setLimit(1000).
				toSOQL());
	}
		return newCases;
	}

	//This method HAS TO BE IMPLEMENTED since we are implementing the Task_Selector_Interface in this class
	//It queries for records and adds fields specific for this query
	public List<Case> selectRecordsForTasks()
	{
		return (List<SObject>) Database.query(
				newQueryFactory().
						selectField(Case.Origin).
						toSOQL()
		);
	}

	public List<Case> innerQueryExample(){
		fflib_QueryFactory caseQueryFactory = newQueryFactory();
		//fflib_QueryFactory taskSubSelectQuery = new Task_Selector().addQueryFactorySubselect(caseQueryFactory);
		System.debug('This is the query ::: ' + caseQueryFactory.toSOQL());
		return (List<Case>) Database.query(caseQueryFactory.toSOQL());
	}

	//This uses the fflib_SObjectSelector class's QueryFactory inner class to create a custom query with
	//extra fields selected and conditions set
	public List<Case> selectEnrollmentCaseByClaimId(Set<Id> claimIds){

		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');

		System.debug('selectEnrollmentCaseByClaimId = ' + newQueryFactory().
				selectField(Case.Claim_Information__c).
				selectField(Case.Contact_Drug__c).
				selectField('Claim_Information__r.Primary_Claim_Number__c').
				selectField('Contact_Drug__r.Copay_Enrollment_Status__c').
				setCondition('Claim_Information__c IN :claimIds').
				setCondition('RecordTypeId = \'' + enrollmentCaseInfo.getRecordTypeId() + '\'').
				toSOQL()
		);

		if(enrollmentCaseByClaimId == null) {
			enrollmentCaseByClaimId = (List<Case>) Database.query(
				newQueryFactory().
						selectField(Case.Claim_Information__c).
						selectField(Case.Contact_Drug__c).
						selectField('Claim_Information__r.Primary_Claim_Number__c').
						selectField('Contact_Drug__r.Copay_Enrollment_Status__c').
						setCondition('Claim_Information__c IN :claimIds').
						setCondition('RecordTypeId = \'' + enrollmentCaseInfo.getRecordTypeId() + '\'').
						toSOQL()
		);
	}
		return enrollmentCaseByClaimId;
	}

	//This uses the fflib_SObjectSelector class's QueryFactory inner class to create a custom query with
	//extra fields selected and conditions set
	public List<Case> selectIntroductionCaseByContactDrug(Set<Id> contactDrugIds){

		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo introductionCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Introduction');

		System.debug('selectIntroductionCaseByClaimId = ' + newQueryFactory().
				selectField(Case.Claim_Information__c).
				selectField(Case.Contact_Drug__c).
				selectField('Claim_Information__r.Primary_Claim_Number__c').
				selectField('Contact_Drug__r.Copay_Enrollment_Status__c').
				setCondition('Contact_Drug__c IN :contactDrugIds').
				setCondition('RecordTypeId = \'' + introductionCaseInfo.getRecordTypeId() + '\'').
				toSOQL()
		);

		if((introductionCaseByContactDrug == null || introductionCaseByContactDrug.size() == 0) && contactDrugIds.size()>0) {
			System.debug('query enrollmentCaseByContactDrug');
			introductionCaseByContactDrug = (List<Case>) Database.query(
					newQueryFactory().
							selectField(Case.Claim_Information__c).
							selectField(Case.Contact_Drug__c).
							selectField('Claim_Information__r.Primary_Claim_Number__c').
							selectField('Contact_Drug__r.Copay_Enrollment_Status__c').
							setCondition('Contact_Drug__c IN :contactDrugIds').
							setCondition('RecordTypeId = \'' + introductionCaseInfo.getRecordTypeId() + '\'').
							toSOQL()
			);
		} else {
			System.debug('no query needed introductionCaseByContactDrug.size = ' + introductionCaseByContactDrug.size());
		}
		return introductionCaseByContactDrug;
	}

	//This uses the fflib_SObjectSelector class's QueryFactory inner class to create a custom query with
	//extra fields selected and conditions set
	public List<Case> selectEnrollmentCaseByContactDrug(Set<Id> contactDrugIds){

		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');

		System.debug('selectEnrollmentCaseByClaimId = ' + newQueryFactory().
				selectField(Case.Claim_Information__c).
				selectField(Case.Contact_Drug__c).
				selectField('Claim_Information__r.Primary_Claim_Number__c').
				selectField('Contact_Drug__r.Copay_Enrollment_Status__c').
				setCondition('Contact_Drug__c IN :contactDrugIds').
				setCondition('RecordTypeId = \'' + enrollmentCaseInfo.getRecordTypeId() + '\'').
				toSOQL()
		);

		if((enrollmentCaseByContactDrug == null || enrollmentCaseByContactDrug.size() == 0) && contactDrugIds.size()>0) {
			System.debug('query enrollmentCaseByContactDrug');
			enrollmentCaseByContactDrug = (List<Case>) Database.query(
				newQueryFactory().
						selectField(Case.Claim_Information__c).
						selectField(Case.Contact_Drug__c).
						selectField('Claim_Information__r.Primary_Claim_Number__c').
						selectField('Contact_Drug__r.Copay_Enrollment_Status__c').
						setCondition('Contact_Drug__c IN :contactDrugIds').
						setCondition('RecordTypeId = \'' + enrollmentCaseInfo.getRecordTypeId() + '\'').
						toSOQL()
		);
		} else {
			System.debug('no query needed enrollmentCaseByContactDrug.size = ' + enrollmentCaseByContactDrug.size());
		}
		return enrollmentCaseByContactDrug;
	}

	//This uses the fflib_SObjectSelector class's QueryFactory inner class to create a custom query with
	//extra fields selected and conditions set
	public List<Case> selectReimbursementCaseByClaimId(Set<Id> claimIds){

		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo reimbursementCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');

		System.debug('selectReimbursementCaseByClaimId = ' + newQueryFactory().
				selectField(Case.Claim_Information__c).
				selectField(Case.Contact_Drug__c).
				selectField('Claim_Information__r.Primary_Claim_Number__c').
				selectField('Contact_Drug__r.Copay_Enrollment_Status__c').
				setCondition('Claim_Information__c IN :claimIds').
				setCondition('RecordTypeId = \'' + reimbursementCaseInfo.getRecordTypeId() + '\'').
				//setOrdering(Case.LastModifiedById, fflib_QueryFactory.SortOrder.ASCENDING).
				//setLimit(100).
				toSOQL()
		);

		if((reimbursementCaseByClaimId == null || reimbursementCaseByClaimId.size() == 0) && claimIds.size()>0) {
			System.debug('query reimbursementCaseByClaimId');
			reimbursementCaseByClaimId = (List<Case>) Database.query(
				newQueryFactory().
						selectField(Case.Claim_Information__c).
							selectField(Case.Contact_Drug__c).
						selectField('Claim_Information__r.Primary_Claim_Number__c').
						selectField('Contact_Drug__r.Copay_Enrollment_Status__c').
						setCondition('Claim_Information__c IN :claimIds').
						setCondition('RecordTypeId = \'' + reimbursementCaseInfo.getRecordTypeId() + '\'').
							//setOrdering(Case.LastModifiedById, fflib_QueryFactory.SortOrder.ASCENDING).
							//setLimit(100).
						toSOQL()
		);
		} else {
			System.debug('no query needed reimbursementCaseByClaimId.size = ' + reimbursementCaseByClaimId.size());
		}
		return reimbursementCaseByClaimId;
	}

	//This uses the fflib_SObjectSelector class's QueryFactory inner class to create a custom query with
	//extra fields selected and conditions set
	public List<Case> selectReplacementCaseByClaimId(Set<String> claimNumbers){
		return (List<Case>) Database.query(
				newQueryFactory().
						selectField(Case.Claim_Information__c).
						selectField(Case.Claim_Number__c).
						setCondition('Claim_Number__c IN :claimNumbers').
						selectField('Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c').
						toSOQL()
		);
	}

	public List<Case> selectCaseByCaseNumber(Set<String> caseNumbers){
		return (List<Case>) Database.query(
				newQueryFactory().
						selectField(Case.Claim_Information__c).
						selectField(Case.Claim_Number__c).
						setCondition('CaseNumber IN :caseNumbers').
						selectField('Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c').
						toSOQL()
		);
	}
/*
	public Map<Id, CaseHistory> selectCaseFieldHistory(Set<Id> caseIdset, String targetField) {

		Map<Id, CaseHistory> caseHistoryById = new Map<Id, CaseHistory>();

		List<CaseHistory> caseHistory = [SELECT CaseId, OldValue, NewValue, Field, CreatedById, CreatedDate FROM CaseHistory WHERE CaseId IN :caseIdset AND Field =: targetField];

		for(CaseHistory caseHistoryRecord : caseHistory){
			caseHistoryById.put(caseHistoryRecord.CaseId, caseHistoryRecord);
		}

		return caseHistoryById;
	}
/*
	/*
	//This uses the fflib_SObjectSelector class's QueryFactory inner class to create a custom query with
	//extra fields selected and conditions set
	public List<Case> selectEnrollmentCaseByHCPC_CodeIdPAId(Set<String> HCPCS_CodeIdSet, Set<String> priorAuthorizationIdSet){

		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');

		return (List<Case>) Database.query(
				newQueryFactory().
						selectField(Case.Claim_Information__c).
						selectField(Case.Prior_Authorization__c).
						selectField(Case.HCPCS_Code__c).
						setCondition('HCPCS_Code__c IN :HCPCS_CodeIdSet').
						setCondition('Prior_Authorization__c IN :priorAuthorizationIdSet').
						setCondition('RecordTypeId = \'' + enrollmentCaseInfo.getRecordTypeId() + '\'').
						toSOQL()
		);
	}
*/
	/*
	//This uses the fflib_SObjectSelector class's QueryFactory inner class to create a custom query with
	//extra fields selected and conditions set
	public List<Case> selectEnrollmentCaseByContactId(Set<Id> contactIdSet){

		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');

		return (List<Case>) Database.query(
				newQueryFactory().
						selectField(Case.ContactId).
						selectField(Case.Contact_Drug__c).
						selectField(Case.Prior_Authorization__c).
						selectField(Case.Service_Start_Date__c).
						selectField(Case.HCPCS_Code__c).
						setCondition('ContactId IN :contactIdSet').
						setCondition('RecordTypeId = \'' + enrollmentCaseInfo.getRecordTypeId() + '\'').
						toSOQL()
		);
	}
*/
	public Database.QueryLocator queryLocatorCasesOpen(Id queue)
	{
		DateTime CurrentDateValue = System.Now();
		String CurrentDateInGMT = CurrentDateValue.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
		String whereClause;
		DateTime PastDate,CurrentDate;
		DateTime currentDateTime = DateTime.now();
		System.debug('currentDateTime = '+ currentDateTime);

		if(Test.isRunningTest()){
			PastDate = currentDateTime.addhours(-24);
			CurrentDate = currentDateTime.addhours(24);
		}
		else{
			PastDate = currentDateTime.addhours(-240);
			CurrentDate = currentDateTime.addhours(2); 
		}

		//whereClause = 'Account.Allow_Case_Routing__c = True';

		whereClause = 'OwnerId = \'' + queue +
				'\' AND Contact.CSA__r.Implementation__r.Allow_Case_Routing__c = True' +
				' AND (Follow_up_Time__c = null OR Follow_up_Time__c <= ' + CurrentDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ')' +
				//' AND (EOP_Date__c = null OR EOP_Date__c >= ' + CurrentDate.formatGMT('yyyy-MM-dd') + ')' +
				' AND IsClosed = false';

		//				' AND MBR_Follow_up_Time__c >= ' + PastDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\')');
		//whereClause = 'Account.Allow_Case_Routing__c = True AND Follow_up_Time__c != null';

/*
		whereClause = //'OwnerId = \'' + queue +
				'CaseNumber = \'00003610\''; // + 'AND Account.Allow_Case_Routing__c = + True + AND (Follow_up_Time__c <= ' + CurrentDate.formatGMT('yyyy-MM
		whereClause = //'OwnerId = \'' + queue +
				'CaseNumber = \'00003825\''; // + 'AND Account.Allow_Case_Routing__c = + True + AND (Follow_up_Time__c <= ' + CurrentDate.formatGMT('yyyy-MM

		whereClause = //'OwnerId = \'' + queue +
				'CaseNumber = \'00003812\''; // + 'AND Account.Allow_Case_Routing__c = + True + AND (Follow_up_Time__c <= ' + CurrentDate.formatGMT('yyyy-MM
*/

/*
		Raw SOQL query:
		SELECT Id,CaseNumber,Type,Priority,OwnerId,Follow_up_Time__c,ContactId,Contact.Id,Contact.Name,Contact.MailingState,Contact.MailingCountry,Contact.GLOC__Location_Time_Zone__c,Contact.GLOC__Location_GMT__c,GLOC__Location_State__c
		from Case where IsClosed = false AND
		OwnerId = '00G230000016X3oEAE' AND
		Follow_up_Time__c < 2022-06-07T13:25:00Z AND
		Account.Allow_Case_Routing__c = True

*/
		System.debug('CaseRoutingJob: query = ' + whereClause);
		System.debug('newQueryFactory().setCondition(query).toSOQL() = ' + newQueryFactory().
				selectField('Contact.Name').
				selectField(Case.CaseNumber).
				selectField(Case.Status).
				selectField(Case.Follow_up_Time__c).
				selectField('Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c').
				selectField(Case.OwnerId).
				selectField(Case.Fax_Received__c).
				selectField(Case.RecordTypeId).
				selectField('RecordType.Name').
				selectField('Contact.CSA__r.Implementation__r.Allow_Case_Routing__c').
				selectField('Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c').
				selectField(Case.HCP_Enrollment_Outreach__c).
				selectField('Contact.GLOC__Location_Time_Zone__c').
				selectField('Contact.GLOC__Location_GMT__c').
				selectField('Contact.GLOC__Location_GMT_n__c').
				selectField('Contact.GLOC__Location_State__c').
				selectField('Contact.MailingState').
				selectField('Contact.MailingCountry').
				selectField('Claim_Information__r.EOP_Date__c').
				selectField(Case.EOP_Date__c).
				setCondition(whereClause).
				toSOQL()
		);

		return Database.getQueryLocator(
				newQueryFactory().
						selectField('Contact.Name').
						selectField(Case.CaseNumber).
						selectField(Case.Status).
						selectField(Case.Follow_up_Time__c).
						selectField('Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c').
						selectField(Case.OwnerId).
						selectField(Case.Fax_Received__c).
						selectField(Case.RecordTypeId).
						selectField('RecordType.Name').
						selectField(Case.RecordTypeId).
						selectField('Contact.CSA__r.Implementation__r.Allow_Case_Routing__c').
						selectField('Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c').
						selectField(Case.HCP_Enrollment_Outreach__c).
						selectField('Contact.GLOC__Location_Time_Zone__c').
						selectField('Contact.GLOC__Location_GMT__c').
						selectField('Contact.GLOC__Location_GMT_n__c').
						selectField('Contact.GLOC__Location_State__c').
						selectField('Contact.MailingState').
						selectField('Contact.MailingCountry').
						selectField('Claim_Information__r.EOP_Date__c').
						selectField(Case.EOP_Date__c).
						setCondition(whereClause).
						toSOQL());
	}

	public Database.QueryLocator queryCasesStatusTransfertoHealthPlan()
	{
		//DateTime dtNow = Datetime.newInstanceGMT(System.now().year(),System.now().month() ,System.now().day(),System.now().hour(),0,0);

		//String whereClause = 'Status = \'Transfer to Health Plan\' AND Send_to_Aetna__c != \'Sent\' AND Follow_up_Time__c <= :' +dtNow;

		String whereClause = 'Status = \'Transfer to Health Plan\' AND Send_to_Aetna__c != \'Sent\'';

/*		whereClause = 'Status = \'Transfer to Health Plan\' AND Send_to_Aetna__c != \'Sent\' AND Follow_up_Time__c <= :' +dtNow;

		whereClause = //'OwnerId = \'' + queue +
				'CaseNumber = \'00003610\''; // + 'AND Account.Allow_Case_Routing__c = + True + AND (Follow_up_Time__c <= ' + CurrentDate.formatGMT('yyyy-MM
		whereClause = //'OwnerId = \'' + queue +
				'CaseNumber = \'00003825\''; // + 'AND Account.Allow_Case_Routing__c = + True + AND (Follow_up_Time__c <= ' + CurrentDate.formatGMT('yyyy-MM

		whereClause = //'OwnerId = \'' + queue +
				'CaseNumber = \'00003812\''; // + 'AND Account.Allow_Case_Routing__c = + True + AND (Follow_up_Time__c <= ' + CurrentDate.formatGMT('yyyy-MM
*/

		System.debug('CaseRoutingJob: query = ' + whereClause);
		System.debug('newQueryFactory().setCondition(query).toSOQL() = ' + newQueryFactory().
				selectField('Contact.Name').
				selectField(Case.CaseNumber).
				selectField(Case.Status).
				selectField(Case.Follow_up_Time__c).
				selectField('Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c').
				selectField(Case.OwnerId).
				selectField(Case.Fax_Received__c).
				selectField(Case.RecordTypeId).
				selectField('RecordType.Name').
				//selectField('Account.Allow_MBR_Outreach__c').
				selectField(Case.HCP_Enrollment_Outreach__c).
				selectField(Case.Send_to_Aetna__c).
				setCondition(whereClause).
				toSOQL()
		);

		return Database.getQueryLocator(
				newQueryFactory().
						selectField('Contact.Name').
						selectField(Case.CaseNumber).
						selectField(Case.Status).
						selectField(Case.Follow_up_Time__c).
						selectField('Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c').
						selectField(Case.OwnerId).
						selectField(Case.Fax_Received__c).
						selectField(Case.RecordTypeId).
						selectField('RecordType.Name').
						selectField('Contact.CSA__r.Implementation__r.Allow_Case_Routing__c').
selectField('Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c').
						selectField(Case.HCP_Enrollment_Outreach__c).
						selectField(Case.Send_to_Aetna__c).
						setCondition(whereClause).
						toSOQL());
	}

	public Database.QueryLocator queryOpenReimbursementCases()
	{

		ID reimbursementCaseTypeId = getCaseRecordTypeId('Reimbursement');
		/*
		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo caseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');
		ID reimbursementCaseTypeId = caseInfo.getRecordTypeId();
		*/

		String whereClause = 'Status != \'Outreach Completed\' AND RecordTypeId = \'' + reimbursementCaseTypeId + '\' ';

		System.debug('CaseAgingJob: query = ' + whereClause);
		System.debug('newQueryFactory().setCondition(query).toSOQL() = ' + newQueryFactory().
				selectField('Contact.Name').
				selectField(Case.CaseNumber).
				selectField(Case.Status).
				selectField(Case.Follow_up_Time__c).
				selectField('Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c').
				selectField(Case.OwnerId).
				selectField(Case.Fax_Received__c).
				selectField(Case.RecordTypeId).
				selectField('RecordType.Name').
				selectField('Contact.CSA__r.Implementation__r.Allow_Case_Routing__c').
selectField('Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c').
				selectField(Case.HCP_Enrollment_Outreach__c).
				selectField(Case.Send_to_Aetna__c).
				setCondition(whereClause).
				toSOQL()
		);

		return Database.getQueryLocator(
				newQueryFactory().
						selectField('Contact.Name').
						selectField(Case.CaseNumber).
						selectField(Case.Status).
						selectField(Case.Follow_up_Time__c).
						selectField('Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c').
						selectField(Case.OwnerId).
						selectField(Case.Fax_Received__c).
						selectField(Case.RecordTypeId).
						selectField('RecordType.Name').
						selectField('Contact.CSA__r.Implementation__r.Allow_Case_Routing__c').
selectField('Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c').
						selectField(Case.HCP_Enrollment_Outreach__c).
						selectField(Case.Send_to_Aetna__c).
						setCondition(whereClause).
						toSOQL());
	}

	public ID getCaseRecordTypeId(String caseRecordType) {
		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo caseInfo = caseDescribe.getRecordTypeInfosByName().get(caseRecordType);
		ID caseRecordTypeId = caseInfo.getRecordTypeId();

		return caseRecordTypeId;
	}
/*
	public Database.QueryLocator queryClosedReimbursementCases()
	{

		ID reimbursementCaseTypeId = getCaseRecordTypeId('Reimbursement');
		/*
		Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
		Schema.RecordTypeInfo caseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');
		ID reimbursementCaseTypeId = caseInfo.getRecordTypeId();
		*/
/*
		String whereClause = 'Status = \'Outreach Completed\' AND RecordTypeId = \'' + reimbursementCaseTypeId + '\' ';

		System.debug('CaseClosedAgeJob: query = ' + whereClause);
		System.debug('newQueryFactory().setCondition(query).toSOQL() = ' + newQueryFactory().
				selectField('Contact.Name').
				selectField(Case.CaseNumber).
				selectField(Case.Status).
				selectField(Case.Follow_up_Time__c).
				selectField('Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c').
				selectField(Case.OwnerId).
				selectField(Case.Fax_Received__c).
				selectField(Case.RecordTypeId).
				selectField('RecordType.Name').
				selectField('Account.Allow_MBR_Outreach__c').
				selectField(Case.HCP_Enrollment_Outreach__c).
				selectField(Case.Send_to_Aetna__c).
				setCondition(whereClause).
				toSOQL()
		);
*/
	/*
		return Database.getQueryLocator(
				newQueryFactory().
						selectField('Contact.Name').
						selectField(Case.CaseNumber).
						selectField(Case.Status).
						selectField(Case.Follow_up_Time__c).
						selectField('Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c').
						selectField(Case.OwnerId).
						selectField(Case.Fax_Received__c).
						selectField(Case.RecordTypeId).
						selectField('RecordType.Name').
						selectField('Account.Allow_MBR_Outreach__c').
						selectField(Case.HCP_Enrollment_Outreach__c).
						selectField(Case.Send_to_Aetna__c).
						setCondition(whereClause).
						toSOQL());
	}
*/
}