/**
 * @description       : This is a basic selector for Daily_Claim__c for this app.
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-08-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-06-2021   Ricardy Banks					   Initial Version
 * 
 **/

public class Daily_ClaimsSelector extends fflib_SObjectSelector 
    implements IDaily_ClaimsSelector 
{

    public Daily_ClaimsSelector() {
        super(false, true, true, false);
    }

    public static IDaily_ClaimsSelector newInstance() {
        return (IDaily_ClaimsSelector) PMd_Application.Selector.newInstance(Daily_Claim__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Daily_Claim__c.Id,
            Daily_Claim__c.Name,
            Daily_Claim__c.CSA_Account__c,
            Daily_Claim__c.Primary_Claim_Number__c,
            Daily_Claim__c.Claim_Code__c,
            Daily_Claim__c.Billing_Provider_First_Name__c,
            Daily_Claim__c.COB_Code__c,
            Daily_Claim__c.Case__c,
            Daily_Claim__c.Status__c
        };
    }

    public Schema.SObjectType getSObjectType()
    {
        return Daily_Claim__c.SObjectType;
    }

    public List<Daily_Claim__c> selectById(Set<Id> idSet)
    {
        return (List<Daily_Claim__c>) selectSObjectsById(idSet);
    }

    public List<Daily_Claim__c> selectByClaim_Number(Set<String> claim_NumberSet) {

        return (List<Daily_Claim__c>) Database.query(
                newQueryFactory().
                        selectField(Daily_Claim__c.Id).
                        selectField(Daily_Claim__c.OwnerId).
                        selectField(Daily_Claim__c.Name).
                        selectField(Daily_Claim__c.Primary_Claim_Number__c).
                        selectField(Daily_Claim__c.Claim_Segment__c).
                        selectField(Daily_Claim__c.Claim_Line__c).
                        selectField(Daily_Claim__c.Previous_Segment__c).
                        selectField(Daily_Claim__c.Claim_Number__c).
                        setCondition('Claim_Number__c IN :claim_NumberSet').
                        toSOQL()
        );
    }

}