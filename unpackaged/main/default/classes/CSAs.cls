/**
 * @description       : CSAs Domain class.
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-11-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 *
 **/

//All domain classes should utilize inherited sharing so that the caller determines whether it should operate in system context or not. The should
//also extend the fflib_SObjectDomain class
public inherited sharing class CSAs extends fflib_SObjectDomain
       implements ICSAs  //Task_Creator_Interface
{
    //This sets up the super class (fflib_SObjectDomain) to have the records variable filled out
    public CSAs(List<CSA__c> csaRecords){
        super(csaRecords);
    }
/*
    public List<CSA__c> getCSAs()
    {
        return (List<CSA__c>) getRecords();
    }

    public void setGoLiveDate(Date goLiveDate)
    {
        for (CSA__c csaRecord : getCSAs())
        {
            csaRecord.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
        }
    }

    //Return Map of CSAs by Daily Claim Ids given a Map of DailyClaim Ids By CSANumbers
    public Map<Id, CSA__c> getCSAsById(Map<String, Id> csaIdByCSANumber) {
        Map<Id, CSA__c> csasByDailyClaimIds = new Map<Id, CSA__c>();

        CSAsSelector csasSelector = (CSAsSelector)PMd_Application.Selector.newInstance(CSA__c.SObjectType);
        List<CSA__c> matchingCSA_NumbersList = csasSelector.selectByCSANumber(csaIdByCSANumber.keySet());
        for(CSA__c csaRecord : matchingCSA_NumbersList) {
            csasByDailyClaimIds.put(csaIdByCSANumber.get(csaRecord.CSA_Number__c), csaRecord);
            System.debug('csasByDailyClaimIds = ' + csasByDailyClaimIds);
        }

        return csasByDailyClaimIds;
    }
*/
    //Return Map of CSAs by CSA_Number__c Ids given a Map of DailyClaim Ids By CSANumbers
    public Map<String, CSA__c> getCSAsByCSANumber(Map<Id, String> idByCSANumber) {
        Map<String, CSA__c> csasByCSA_Number = new Map<String, CSA__c>();
        Set<String> csaNumberSet = new Set<String>(idByCSANumber.values());

        CSAsSelector csasSelector = (CSAsSelector)PMd_Application.Selector.newInstance(CSA__c.SObjectType);
        List<CSA__c> matchingCSA_NumbersList = csasSelector.selectByCSANumber(csaNumberSet);
        for(CSA__c csaRecord : matchingCSA_NumbersList) {
            csasByCSA_Number.put(csaRecord.CSA_Number__c, csaRecord);
            System.debug('csasByCSA_Number = ' + csasByCSA_Number);
        }

        return csasByCSA_Number;
    }
/*
    //Return Map of CSAs by Daily Claim Ids given a Map of DailyClaim Ids By CSANumbers
    public Set<String> getCSAsById(Set<String> historicalClaimHCPCSet) {
       Set<String> csaSet = new Set<String>();

        CSAsSelector csasSelector = (CSAsSelector)PMd_Application.Selector.newInstance(CSA__c.SObjectType);
        List<CSA__c> matchingCSA_NumbersList = csasSelector.selectByCSANumber(historicalClaimHCPCSet);
        for(CSA__c csaRecord : matchingCSA_NumbersList) {
            csaSet.add(csaRecord.CSA_Number__c);
        }

        return csaSet;
    }

    //Return Map of CSAs by Historical Claim Ids given a Map of DailyClaim Ids By CSANumbers
    public Map<Id, CSA__c> getCSAsByHistoricalClaimId(Map<String, Id> historicalClaimIdByCSANumber) {
        Map<Id, CSA__c> csasByHistoricalClaimIds = new Map<Id, CSA__c>();

        CSAsSelector csasSelector = (CSAsSelector)PMd_Application.Selector.newInstance(CSA__c.SObjectType);
        List<CSA__c> matchingHistoricalClaimCSA_NumbersList = csasSelector.selectByCSANumber(historicalClaimIdByCSANumber.keySet());
        for(CSA__c csaRecord : matchingHistoricalClaimCSA_NumbersList) {
            csasByHistoricalClaimIds.put(historicalClaimIdByCSANumber.get(csaRecord.CSA_Number__c), csaRecord);
        }

        return csasByHistoricalClaimIds;
    }
*/
    //This helps allow for the fflib_SObjectDomain class to run its triggerHandler method
    //using the correct Domain class. This must be implemented in all domain classes.
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<SObject> sObjectList){
            return new CSAs(sObjectList);
        }
    }

/***************************************************************************************************************************************
 * Trigger Operations
 **************************************************************************************************************************************/
//    public override void processAfterInsert(){
    public override void onBeforeInsert() {
        System.debug('Start CSAs:onBeforeInsert');

        List<CSA__c> csaList = Records;
        List<CSA__c>csaToProcessList = new List<CSA__c>();

        for(CSA__c csaRecord : csaList) {

            csaRecord.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                    csaRecord.CSA_Control__c + '-'+
                            csaRecord.CSA_Suffix__c + '-' +
                            csaRecord.CSA_Account__c
            );
            System.debug('csaRecord.CSA_Number__c = ' + csaRecord.CSA_Number__c);
        }

        if(csaToProcessList.size() > 0) {
            //ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
        }
        System.debug('End CSAs:onBeforeInsert');
    }

    public override void onBeforeUpdate(Map<Id, SObject> oldRecords) {
        System.debug('Start CSAs:onBeforeUpdate');

        List<CSA__c> csaList = Records;
        List<CSA__c>csaToProcessList = new List<CSA__c>();

        for(CSA__c csaRecord : csaList) {

            CSA__c oldCSA = (CSA__c)oldRecords.get(csaRecord.Id);

            csaRecord.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                    csaRecord.CSA_Control__c + '-' +
                            csaRecord.CSA_Suffix__c + '-' +
                            csaRecord.CSA_Account__c
            );
            /*
            System.debug('csaRecord.CSA_Control__c = '+csaRecord.CSA_Control__c);
            System.debug('csaRecord.CSA_Suffix__c = '+csaRecord.CSA_Suffix__c);
            System.debug('csaRecord.CSA_Account__c = '+csaRecord.CSA_Account__c);
            System.debug('csaRecord.CSA_Control__c+CSA_Suffix__c+CSA_Account__c = '+csaRecord.CSA_Control__c +
                    csaRecord.CSA_Suffix__c +
                    csaRecord.CSA_Account__c);
            System.debug('csaRecord.CSA_Number__c = '+csaRecord.CSA_Number__c);
            */
        }

        if(csaToProcessList.size() > 0) {
            //ProcessDailyClaimsBeforeInsert(daily_ClaimsToProcessList);
        }
        System.debug('End CSAs:onBeforeUpdate');
    }
}