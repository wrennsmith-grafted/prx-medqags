public class Historical_ClaimsSelector extends fflib_SObjectSelector 
    implements IHistorical_ClaimsSelector 
{
    public static IHistorical_ClaimsSelector newInstance() {
        return (IHistorical_ClaimsSelector) PMd_Application.Selector.newInstance(Historical_Claim__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Historical_Claim__c.Id,
            Historical_Claim__c.Name,
            Historical_Claim__c.CSA_Account__c,
            Historical_Claim__c.Primary_Claim_Number__c,
            //Historical_Claim__c.Claim_Code__c,
           // Historical_Claim__c.Billing_Provider_First_Name__c,
            Historical_Claim__c.COB_Code__c
        };
    }

    public Schema.SObjectType getSObjectType()
    {
        return Historical_Claim__c.SObjectType;
    }

    public List<Historical_Claim__c> selectById(Set<Id> idSet)
    {
        return (List<Historical_Claim__c>) selectSObjectsById(idSet);
    }

    public List<Historical_Claim__c> selectByClaim_Number(Set<String> claim_NumberSet) {

        return (List<Historical_Claim__c>) Database.query(
                newQueryFactory().
                        selectField(Historical_Claim__c.Id).
                        selectField(Historical_Claim__c.OwnerId).
                        selectField(Historical_Claim__c.Name).
                        selectField(Historical_Claim__c.Primary_Claim_Number__c).
                        //selectField(Historical_Claim__c.Claim_Segment__c).
                        selectField(Historical_Claim__c.Primary_Claim_Number__c).
                        selectField(Historical_Claim__c.Claim_Line__c).
                        //selectField(Historical_Claim__c.Previous_Segment__c).
                        selectField(Historical_Claim__c.Claim_Number__c).
                        setCondition('Claim_Number__c IN :claim_NumberSet').
                        toSOQL()
        );
    }

}