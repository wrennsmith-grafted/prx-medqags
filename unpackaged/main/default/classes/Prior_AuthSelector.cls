/** 
 * @description       : prior_AuthSelector class.
 * @author            : jyothi.gandhamaneni@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-18-2021
 * @last modified by  : Jyothi Gandhamaneni
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-18-2021   Jyothi Gandhamaneni			   Initial Version
 * 
 **/
public class Prior_AuthSelector extends fflib_SObjectSelector 
    implements Iprior_AuthSelector 
{
    public static Iprior_AuthSelector newInstance() {
        return (Iprior_AuthSelector) PMd_Application.Selector.newInstance(Prior_Auth__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Prior_Auth__c.Id,
            Prior_Auth__c.Name,
            Prior_Auth__c.CSA_Account__c
            //Prior_Auth__c.Primary_Claim_Number__c,
            //Prior_Auth__c.Claim_Code__c,
           // Prior_Auth__c.Billing_Provider_First_Name__c,
            //Prior_Auth__c.COB_Code__c
        };
    }

    public Schema.SObjectType getSObjectType()
    {
        return Prior_Auth__c.SObjectType;
    }

    public List<Prior_Auth__c> selectById(Set<Id> idSet)
    {
        return (List<Prior_Auth__c>) selectSObjectsById(idSet);
    }

    public List<Prior_Auth__c> selectBySHA1Hash_ID(Set<String> sha1Hash_Id){
        //TODO: Need to add the CUMB ID
        return (List<Prior_Auth__c>) Database.query(
                newQueryFactory().

                        selectField(Prior_Auth__c.Patient_Phone_Number__c).
                        selectField(Prior_Auth__c.OwnerId).
                        selectField(Prior_Auth__c.Patient_CUMB_ID__c).
                        selectField(Prior_Auth__c.Patient_Birth_Date__c).
                        selectField(Prior_Auth__c.Patient_First_Name__c).
                        selectField(Prior_Auth__c.Patient_Last_Name__c).
                        selectField(Prior_Auth__c.SHA1Hash_ID__c).
                        setCondition('SHA1Hash_ID__c IN :sha1Hash_Id').
                        toSOQL()
        );
    }

    public List<Prior_Auth__c> selectByClaim_Number(Set<String> claim_NumberSet) {

        return (List<Prior_Auth__c>) Database.query(
                newQueryFactory().
                        selectField(Prior_Auth__c.Id).
                        selectField(Prior_Auth__c.OwnerId).
                        selectField(Prior_Auth__c.Name).
                        setCondition('Claim_Number__c IN :claim_NumberSet').
                        toSOQL()
        );
    }

}