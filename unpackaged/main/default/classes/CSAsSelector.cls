/**
 * @description       : CSA__c Selector Implementation
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 *
 **/

public class CSAsSelector extends fflib_SObjectSelector
        implements ICSAsSelector
{

    public CSAsSelector() {
        super(false, true, true, false);
    }

    public static ICSAsSelector newInstance() {
        return (ICSAsSelector) PMd_Application.Selector.newInstance(CSA__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                CSA__c.Id,
                CSA__c.Name,
                CSA__c.Account__c,
                CSA__c.CSA_Account__c,
                CSA__c.CSA_Control__c,
                CSA__c.CreatedById,
                CSA__c.CSA_Number__c,
                CSA__c.Go_Live_Date__c,
                CSA__c.LastModifiedById,
                CSA__c.Medical_Drug_List__c,
                CSA__c.CSA_Suffix__c,
                CSA__c.LastModifiedById
        };
    }

    public Schema.SObjectType getSObjectType() {
        return CSA__c.SObjectType;
    }

    public List<CSA__c> selectById(Set<Id> idSet)
    {
        return (List<CSA__c>) selectSObjectsById(idSet);
    }

    public List<CSA__c> selectByCSANumber(Set<String> csaNumbers) {

        return (List<CSA__c>) Database.query(
                newQueryFactory().
                        selectField(CSA__c.Id).
                        selectField(CSA__c.Name).
                        selectField(CSA__c.Account__c).
                        selectField(CSA__c.CSA_Account__c).
                        selectField(CSA__c.CSA_Control__c).
                        selectField(CSA__c.CSA_Number__c).
                        selectField('Implementation__r.Contract__r.Go_Live_Date__c').
                        setCondition('CSA_Number__c IN :csaNumbers').
                        //setCondition('Patient_First_Name__c IN :firstName').
                        //setCondition('Patient_Last_Name__c IN :lastName').
                        toSOQL()
        );
    }

}