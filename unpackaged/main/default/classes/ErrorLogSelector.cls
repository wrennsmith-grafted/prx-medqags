/**
 * @author Ricardy Banks
 * @date 02/15/2023
 * @description This class is used to select data from the ErrorLog object. It's the only place that case object queries
 * should be made
 */

//We extend the fflib_SObjectSelector class to gain access to its many useful prebuilt methods
//We extend the Task_Selector_Interface to force it to implement a particular set of methods to help with abstraction
//in the Task_Service_Impl class
public inherited sharing class ErrorLogSelector extends fflib_SObjectSelector
{

    public ErrorLogSelector(){
        super(false, true, true, false);
    }
    /*
    public static ICasesSelector newInstance()
    {
        return (ICasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
    }
    */
    //This sets the base fields that you will ALWAYS have in your queries when calling this selector class
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField>{
                Error_Log__c.Id,
                Error_Log__c.Name,
                Error_Log__c.Error_Message__c,
                Error_Log__c.Daily_Claim__c,
                Error_Log__c.Historical_Claim__c,
                Error_Log__c.Historical_Prior_Auth__c,
                Error_Log__c.Prior_Auth__c,
                Error_Log__c.CreatedDate
        };
    }

    //This will return your object type for this selector, useful in abstractions
    public Schema.SObjectType getSObjectType(){
        return Error_Log__c.SObjectType;
    }

    //This method calls the fflib_SObjectSelector classes selectSObjectsById method and returns a list
    //of cases from the caseIds you sent in with the default fields declared in the getSObjectFieldList method above
    public List<Error_Log__c> selectById(Set<Id> errorLogIds){
        return (List<Error_Log__c>) selectSObjectsById(errorLogIds);
    }

    //This uses the fflib_SObjectSelector class's QueryFactory inner class to create a custom query with
    //extra fields selected and conditions set
    public Database.QueryLocator selectErrorLogsByCreatedDate(Date createdDate){

        System.debug('selectErrorLogsByDailyClaimId = ' + newQueryFactory().
                setCondition('CreatedDate = TODAY').
                toSOQL()
        );

        return Database.getQueryLocator(
                newQueryFactory().
                        setCondition('CreatedDate = TODAY').
                        toSOQL()
        );
    }
/*
    //This uses the fflib_SObjectSelector class's QueryFactory inner class to create a custom query with
    //extra fields selected and conditions set
    public Database.QueryLocator selectErrorLogsByDailyClaimId(Set<Id> dailyClaimIds){

        System.debug('selectErrorLogsByDailyClaimId = ' + newQueryFactory().
                setCondition('Id IN :dailyClaimIds').
                toSOQL()
        );

        return Database.getQueryLocator(
                newQueryFactory().
                        setCondition('Claim_Information__c IN :dailyClaimIds').
                        toSOQL()
        );
    }
*/
}