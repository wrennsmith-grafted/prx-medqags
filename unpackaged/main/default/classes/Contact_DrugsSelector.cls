/**
 * @description       : Contact_Drugs Selector Implementation
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 *
 **/

public class Contact_DrugsSelector extends fflib_SObjectSelector
        implements IContact_DrugsSelector
{

    public Contact_DrugsSelector() {
        super(false, true, true, false);
    }

    public static IContact_DrugsSelector newInstance() {
        return (IContact_DrugsSelector) PMd_Application.Selector.newInstance(Contact_Drug__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Contact_Drug__c.Id,
                Contact_Drug__c.Name,
                Contact_Drug__c.Alternative_Phone__c,
                Contact_Drug__c.Authorization_Received__c,
                Contact_Drug__c.Birthdate__c,
                Contact_Drug__c.Claim_Information__c,
                Contact_Drug__c.Contact__c,
                Contact_Drug__c.Copay_Enrollment_Status__c,
                Contact_Drug__c.Member_Ineligible_for_CPA__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Contact_Drug__c.SObjectType;
    }

    public List<Contact_Drug__c> selectById(Set<Id> idSet)
    {
        return (List<Contact_Drug__c>) selectSObjectsById(idSet);
    }

    public List<Contact_Drug__c> selectByContact_DrugId(Set<Id> contact_DrugIds) {

        return (List<Contact_Drug__c>) Database.query(
                newQueryFactory().
                        selectField(Contact_Drug__c.Phone__c).
                        selectField(Contact_Drug__c.OwnerId).
                        selectField(Contact_Drug__c.Email__c).
                        selectField(Contact_Drug__c.Birthdate__c).
                        selectField(Contact_Drug__c.Contact__c).
                        selectField(Contact_Drug__c.Claim_Information__c).
                        setCondition('Id IN :contact_DrugIds').
                        //setCondition('Patient_First_Name__c IN :firstName').
                        //setCondition('Patient_Last_Name__c IN :lastName').
                        toSOQL()
        );
    }

    public List<Contact_Drug__c> selectByJ_CodeIdContactId(Set<String> j_CodeIds, Set<String> NDCSet, Set<Id> contactIds) {

        String whereClause = 'HCPCS_Code__c IN :\'' + j_CodeIds + '\' AND NDC__c IN : \'' + NDCSet + '\' AND Contact__c IN : \'' + contactIds;
        System.debug('selectByJ_CodeIdContactId: query = ' + whereClause);

        System.debug('selectByJ_CodeIdContactId.toSOQL() = ' + newQueryFactory().
                selectField(Contact_Drug__c.Phone__c).
                selectField(Contact_Drug__c.OwnerId).
                selectField(Contact_Drug__c.Email__c).
                selectField(Contact_Drug__c.Birthdate__c).
                selectField(Contact_Drug__c.Contact__c).
                selectField(Contact_Drug__c.HCPCS_Code__c).
                selectField(Contact_Drug__c.Claim_Information__c).
                setCondition('HCPCS_Code__c IN :j_CodeIds AND Contact__c IN :contactIds').
                //setCondition('HCPCS_Code__c IN :j_CodeIds').
                //setCondition('NDC__c IN :NDCSet').
                //setCondition('Contact__c IN :contactIds').
                //setCondition('Patient_Last_Name__c IN :lastName').
                toSOQL()
        );

        return (List<Contact_Drug__c>) Database.query(
                newQueryFactory().
                        selectField(Contact_Drug__c.Phone__c).
                        selectField(Contact_Drug__c.OwnerId).
                        selectField(Contact_Drug__c.Email__c).
                        selectField(Contact_Drug__c.Birthdate__c).
                        selectField(Contact_Drug__c.Contact__c).
                        selectField(Contact_Drug__c.HCPCS_Code__c).
                        selectField(Contact_Drug__c.Claim_Information__c).
                        selectField('Drug_Name__r.Coding_Level__c').
                        setCondition('HCPCS_Code__c IN :j_CodeIds AND Contact__c IN :contactIds').
                        //setCondition('HCPCS_Code__c IN :j_CodeIds').
                        //setCondition('NDC__c IN :NDCSet').
                        //setCondition('Contact__c IN :contactIds').
                        //setCondition('Patient_Last_Name__c IN :lastName').
                        toSOQL()
        );
    }
/*
    public List<Contact_Drug__c> selectByContactId(Set<Id> contactIds) {

        return (List<Contact_Drug__c>) Database.query(
                newQueryFactory().
                        selectField(Contact_Drug__c.Phone__c).
                        selectField(Contact_Drug__c.OwnerId).
                        selectField(Contact_Drug__c.Email__c).
                        selectField(Contact_Drug__c.Birthdate__c).
                        selectField(Contact_Drug__c.Contact__c).
                        selectField(Contact_Drug__c.HCPCS_Code__c).
                        selectField(Contact_Drug__c.Historical_Prior_Auth__c).
                        setCondition('Contact__c IN :contactIds').
                        //setCondition('Contact__c IN :contactIds').
                        //setCondition('Patient_Last_Name__c IN :lastName').
                        toSOQL()
        );
    }
*/
    /*
    public List<Contact_Drug__c> selectByJ_CodeIdContactId(Set<String> j_CodeIds) {

        return (List<Contact_Drug__c>) Database.query(
                newQueryFactory().
                        selectField(Contact_Drug__c.Phone__c).
                        selectField(Contact_Drug__c.OwnerId).
                        selectField(Contact_Drug__c.Email__c).
                        selectField(Contact_Drug__c.Birthdate__c).
                        selectField(Contact_Drug__c.Contact__c).
                        selectField(Contact_Drug__c.HCPCS_Code__c).
                        setCondition('HCPCS_Code__c IN :j_CodeIds').
                        //setCondition('Patient_Last_Name__c IN :lastName').
                        toSOQL()
        );
    }
    */
}