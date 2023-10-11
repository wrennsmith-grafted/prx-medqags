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
public class Historical_Prior_AuthSelector extends fflib_SObjectSelector
        implements IHistorical_Prior_AuthSelector
{
    public static IHistorical_Prior_AuthSelector newInstance() {
        return (IHistorical_Prior_AuthSelector) PMd_Application.Selector.newInstance(Historical_Prior_Auth__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
                Historical_Prior_Auth__c.Id,
                Historical_Prior_Auth__c.Name,
                Historical_Prior_Auth__c.CSA_Account__c
                //Prior_Auth__c.Primary_Claim_Number__c,
                //Prior_Auth__c.Claim_Code__c,
                // Prior_Auth__c.Billing_Provider_First_Name__c,
                //Prior_Auth__c.COB_Code__c
        };
    }

    public Schema.SObjectType getSObjectType()
    {
        return Historical_Prior_Auth__c.SObjectType;
    }

    public List<Historical_Prior_Auth__c> selectById(Set<Id> idSet)
    {
        return (List<Historical_Prior_Auth__c>) selectSObjectsById(idSet);
    }

    public List<Historical_Prior_Auth__c> selectBySHA1Hash_ID(Set<String> sha1Hash_Id){
        //TODO: Need to add the CUMB ID
        return (List<Historical_Prior_Auth__c>) Database.query(
                newQueryFactory().

                        selectField(Historical_Prior_Auth__c.Patient_Phone_Number__c).
                        selectField(Historical_Prior_Auth__c.OwnerId).
                        selectField(Historical_Prior_Auth__c.Patient_CUMB_ID__c).
                        selectField(Historical_Prior_Auth__c.Patient_Birth_Date__c).
                        selectField(Historical_Prior_Auth__c.Patient_First_Name__c).
                        selectField(Historical_Prior_Auth__c.Patient_Last_Name__c).
                        selectField(Historical_Prior_Auth__c.SHA1Hash_ID__c).
                        setCondition('SHA1Hash_ID__c IN :sha1Hash_Id').
                        toSOQL()
        );
    }

    public List<Historical_Prior_Auth__c> selectByClaim_Number(Set<String> claim_NumberSet) {

        return (List<Historical_Prior_Auth__c>) Database.query(
                newQueryFactory().
                        selectField(Historical_Prior_Auth__c.Id).
                        selectField(Historical_Prior_Auth__c.OwnerId).
                        selectField(Historical_Prior_Auth__c.Name).
                        setCondition('Claim_Number__c IN :claim_NumberSet').
                        toSOQL()
        );
    }

}