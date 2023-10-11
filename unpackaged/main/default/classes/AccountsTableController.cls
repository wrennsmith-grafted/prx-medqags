public with sharing class AccountsTableController {
    
    /*
     * Method Name: getRecords.
     * Action: Gets the Activities Related from a case.
     * Params: taskId: String.
     * Returns: a list of tasks.
     */
    @AuraEnabled
    public static List<Task> getRecords(String taskId) {
        List<Task> accs = 
            [SELECT Id, Call_Answered_At__c, Contact_Phone__c, Call_Notes__c, Call_Outcome__c FROM Task
             WHERE WhatId = :taskId order by CreatedDate desc];
        return accs;
    }
    
    /*
     * Method Name: updateRecords.
     * Action: Updates the records.
     * Params: jsonString: String.
     */
    @AuraEnabled
    public static void updateRecords(String jsonString){
        try{
            List<Task> records = (List<Task>) JSON.deserialize(jsonString, List<Task>.class);
            update records;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*
     * Method Name: getPicklistValues.
     * Action: Gets the value from an specific picklist.
     * Params: objectAPIName: String and fieldAPIName: String.
     * Return: Map with the picklist value.
     */
    @AuraEnabled        
    public static Map<String,String> getPicklistValues(String objectAPIName, String fieldAPIName){
        Map<String,String> pickListValuesMap = new Map<String,String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectAPIName);
        Schema.DescribeSObjectResult descResult = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = descResult.fields.getMap().get(fieldAPIName).getDescribe();
        Boolean isFieldNotRequired = fieldResult.isNillable();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
            if(isFieldNotRequired)
                pickListValuesMap.put('--None--', '');
            if(pickListVal.isActive())
                pickListValuesMap.put(pickListVal.getLabel(), pickListVal.getValue());
        }
        return pickListValuesMap;
    }
}