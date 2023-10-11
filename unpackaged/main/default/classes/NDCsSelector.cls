/**
 * @description       : NDC__c Selector Implementation
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 05-24-2022
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   05-24-2022   Ricardy Banks					   Initial Version: MBP-458 Business Logic: Update logic to match the correct Contact Drug based on inbound files
 *
 **/

public class NDCsSelector extends fflib_SObjectSelector
        implements INDCsSelector
{

    public NDCsSelector() {
        super(false, true, true, false);
    }

    public static NDCsSelector newInstance() {
        return (NDCsSelector) PMd_Application.Selector.newInstance(NDC__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                NDC__c.Id,
                NDC__c.Name,
                NDC__c.Drug__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return NDC__c.SObjectType;
    }

    public List<NDC__c> selectById(Set<Id> idSet)
    {
        return (List<NDC__c>) selectSObjectsById(idSet);
    }

    public List<NDC__c> selectByDrugId(Set<Id> drugIds) {

        System.debug('drugIds = ' + drugIds);

        return (List<NDC__c>) Database.query(
                newQueryFactory().
                        selectField(NDC__c.Id).
                        selectField(NDC__c.Name).
                        selectField('Drug__r.J_Code__c').
                        selectField('Drug__r.Coding_Level__c').
                        setCondition('Drug__c IN :drugIds').
                        toSOQL()
        );
    }
}