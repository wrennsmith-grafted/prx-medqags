/**
 * @description       : Drug__c Selector Implementation
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 *
 **/
public class DrugsSelector extends fflib_SObjectSelector
        implements IDrugsSelector
{

    public DrugsSelector() {
        super(false, true, true, false);
    }

    public static DrugsSelector newInstance() {
        return (DrugsSelector) PMd_Application.Selector.newInstance(Drug__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Drug__c.Id,
                Drug__c.Name,
                Drug__c.J_Code__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Drug__c.SObjectType;
    }

    public List<Drug__c> selectById(Set<Id> idSet)
    {
        return (List<Drug__c>) selectSObjectsById(idSet);
    }

    public List<Drug__c> selectByHCPCSNumber(Set<String> hcpcsNumbers) {

        System.debug('hcpcsNumbers = ' + hcpcsNumbers);

        return (List<Drug__c>) Database.query(
                newQueryFactory().
                        selectField(Drug__c.Id).
                        selectField(Drug__c.Name).
                        selectField(Drug__c.J_Code__c).
                        selectField(Drug__c.Coding_Level__c).
                        setCondition('J_Code__c IN :hcpcsNumbers').
                        //setCondition('Patient_First_Name__c IN :firstName').
                        //setCondition('Patient_Last_Name__c IN :lastName').
                        toSOQL()
        );
    }
}