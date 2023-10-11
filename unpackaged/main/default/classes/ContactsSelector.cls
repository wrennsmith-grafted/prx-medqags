/**
 * Created by gerry on 3/29/2021.
 * Ver   Date         Author                         Modification
 * 1.0   02-26-2022   Ricardy Banks					Initial Version
 * 1.1	 04-26-2023	  Arvind Mahadevan				US-540: Added new condition to check for Authorization Received before updating the 
 * 													Authorization Representative and Authorized Relationship from Daily Claim to Contact record.
 */

public inherited sharing class ContactsSelector extends fflib_SObjectSelector
		implements IContactsSelector
{
	public ContactsSelector(){
		super(false, true, true, false);
	}

    public static IContactsSelector newInstance()
	{
		return (IContactsSelector) PMd_Application.Selector.newInstance(Contact.SObjectType);
	}

	public List<Schema.SObjectField> getSObjectFieldList(){
		return new List<Schema.SObjectField>{
				Contact.Id,
				Contact.Name,
				Contact.FirstName,
				Contact.LastName,
				Contact.CreatedDate,
				Contact.Patient_Phone_Number__c,
				Contact.Alternative_Phone__c,
				Contact.Authorization_Received__c,
				Contact.Plan_Sponsor_Unique_ID__c
		};
	}

	public Schema.SObjectType getSObjectType(){
		return Contact.SObjectType;
	}

	public List<Contact> selectById(Set<Id> contactIds){
		return (List<Contact>) selectSObjectsById(contactIds);
	}
/*
	public List<Contact> selectById(Set<String> contactIdsStr){
		/*
		Set<Id> contactIdSet = new Set<Id>();
		for(String contactIdStr :contactIdsStr) {
			contactIdSet.add(Id.valueOf(contactIdStr));
		}	
		return (List<Contact>) selectSObjectsById(contactIds);
		AssistantPhone,HomePhone,OtherPhone,Phone,OwnerId
		*/
	/*
		return (List<Contact>) Database.query(
			newQueryFactory().
					selectField(Contact.AssistantPhone).
					selectField(Contact.HomePhone).
					selectField(Contact.OtherPhone).
					selectField(Contact.Patient_Phone_Number__c).
					selectField(Contact.OwnerId).
					setCondition('Id IN :contactIdsStr').
					toSOQL()
		);
	}
	*/
/*
	public List<Contact> selectByCumbIdBdLnFn(Set<String> cumbId, Set<Date> birthDate, Set<String> firstName, Set<String> lastName){
		//TODO: Need to add the CUMB ID
		return (List<Contact>) Database.query(
				newQueryFactory().
						selectField(Contact.AssistantPhone).
						selectField(Contact.HomePhone).
						selectField(Contact.OtherPhone).
						selectField(Contact.Patient_Phone_Number__c).
						selectField(Contact.OwnerId).
						selectField(Contact.Email).
						selectField(Contact.Patient_CUMB_ID__c).
						selectField(Contact.Patient_Birth_Date__c).
						selectField(Contact.Patient_First_Name__c).
						selectField(Contact.Patient_Last_Name__c).
						setCondition('Patient_CUMB_ID__c IN :cumbId AND Patient_Birth_Date__c IN :birthDate AND Patient_First_Name__c IN :firstName AND Patient_Last_Name__c IN :lastName').
						//setCondition('Patient_Birth_Date__c IN :birthDate').
						//setCondition('Patient_First_Name__c IN :firstName').
						//setCondition('Patient_Last_Name__c IN :lastName').
						toSOQL()
		);
	}
*/
	public List<Contact> selectByCumbIdBd(Set<String> cumbId, Set<Date> birthDate){
		//TODO: Need to add the CUMB ID
		return (List<Contact>) Database.query(
				newQueryFactory().
						selectField(Contact.AccountId).
						selectField(Contact.AssistantPhone).
						selectField(Contact.HomePhone).
						selectField(Contact.OtherPhone).
						selectField(Contact.Patient_Phone_Number__c).
						selectField(Contact.OwnerId).
						selectField(Contact.Email).
						selectField(Contact.Patient_CUMB_ID__c).
						selectField(Contact.Patient_Birth_Date__c).
						selectField(Contact.Patient_First_Name__c).
						selectField(Contact.Patient_Last_Name__c).
						selectField(Contact.SHA1Hash_ID__c).
						selectField(Contact.Authorization_Received__c).
						setCondition('Patient_CUMB_ID__c IN :cumbId AND Patient_Birth_Date__c IN :birthDate').
						//setCondition('Patient_Birth_Date__c IN :birthDate').
						toSOQL()
		);
	}

	public List<Contact> selectBySHA1Hash_ID(Set<String> sha1Hash_Id){
		//TODO: Need to add the CUMB ID
		return (List<Contact>) Database.query(
				newQueryFactory().
						selectField(Contact.AccountId).
						selectField(Contact.AssistantPhone).
						selectField(Contact.HomePhone).
						selectField(Contact.OtherPhone).
						selectField(Contact.Patient_Phone_Number__c).
						selectField(Contact.OwnerId).
						selectField(Contact.Email).
						selectField(Contact.Patient_CUMB_ID__c).
						selectField(Contact.Patient_Birth_Date__c).
						selectField(Contact.Patient_First_Name__c).
						selectField(Contact.Patient_Last_Name__c).
						selectField(Contact.SHA1Hash_ID__c).
						selectField(Contact.Authorization_Received__c).
						setCondition('SHA1Hash_ID__c IN :sha1Hash_Id').
						toSOQL()
		);
	}
/*
	public List<Contact> selectByPatientCUMBId(List<String> patientCUMBId){
		//TODO: Need to add the CUMB ID
		return (List<Contact>) Database.query(
				newQueryFactory().
						selectField(Contact.AccountId).
						selectField(Contact.AssistantPhone).
						selectField(Contact.HomePhone).
						selectField(Contact.OtherPhone).
						selectField(Contact.Patient_Phone_Number__c).
						selectField(Contact.OwnerId).
						selectField(Contact.Email).
						selectField(Contact.Patient_CUMB_ID__c).
						selectField(Contact.Patient_Birth_Date__c).
						selectField(Contact.Patient_First_Name__c).
						selectField(Contact.Patient_Last_Name__c).
						selectField(Contact.SHA1Hash_ID__c).
						setCondition('Patient_CUMB_ID__c IN :patientCUMBId').
						toSOQL()
		);
	}

	public List<Contact> selectByPAId(Set<String> priorAuthorizationIdSet){
		//TODO: Need to add the CUMB ID
		return (List<Contact>) Database.query(
				newQueryFactory().
						selectField(Contact.AccountId).
						selectField(Contact.AssistantPhone).
						selectField(Contact.HomePhone).
						selectField(Contact.OtherPhone).
						selectField(Contact.Patient_Phone_Number__c).
						selectField(Contact.OwnerId).
						selectField(Contact.Email).
						selectField(Contact.Patient_CUMB_ID__c).
						selectField(Contact.Patient_Birth_Date__c).
						selectField(Contact.Patient_First_Name__c).
						selectField(Contact.Patient_Last_Name__c).
						selectField(Contact.SHA1Hash_ID__c).
						setCondition('Prior_Authorization__c IN :priorAuthorizationIdSet').
						toSOQL()
		);
	}
	*/
}