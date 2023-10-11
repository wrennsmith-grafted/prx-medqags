/**
 * Created by gerry on 3/29/2021.
 */

public inherited sharing class Contact_Selector extends fflib_SObjectSelector
{
	public Contact_Selector(){
		super(false, true, true, false);
	}
/*
    public static IContactsSelector newInstance()
	{
		return (IContactsSelector) Application.Selector.newInstance(Contact.SObjectType);
	}
*/
	public List<Schema.SObjectField> getSObjectFieldList(){
		return new List<Schema.SObjectField>{
				Contact.Id,
				Contact.Name,
				Contact.FirstName,
				Contact.LastName
		};
	}

	public Schema.SObjectType getSObjectType(){
		return Contact.SObjectType;
	}

	public List<Contact> selectById(Set<Id> contactIds){
		return (List<Contact>) selectSObjectsById(contactIds);
	}

	public List<Contact> selectById(Set<String> contactIdsStr){
		/*
		Set<Id> contactIdSet = new Set<Id>();
		for(String contactIdStr :contactIdsStr) {
			contactIdSet.add(Id.valueOf(contactIdStr));
		}	
		return (List<Contact>) selectSObjectsById(contactIds);
		AssistantPhone,HomePhone,OtherPhone,Phone,OwnerId
		*/
		return (List<Contact>) Database.query(
			newQueryFactory().
					selectField(Contact.AssistantPhone).
					selectField(Contact.HomePhone).
					selectField(Contact.OtherPhone).
					selectField(Contact.Phone).
					selectField(Contact.OwnerId).
					setCondition('Id IN :contactIdsStr').
					toSOQL()
		);
	}
}