/**
 * @description       : Daily Claims Service Implementaion
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 * 
 **/
public class RestAPIsServiceceImpl 
    implements IRestAPIService
{

    Map<Id,API_Log__c> mapAPILogIds = new Map<Id,API_Log__c>();

    List<API_Log__c> ListInsertAPILogRecs = new List<API_Log__c>();
    List<Daily_Claim__c> dailyClaimsInsertList = new List<Daily_Claim__c>();
    List<Daily_Claim__c> dailyClaimsUpsertList = new List<Daily_Claim__c>();
    List<Historical_Claim__c> historicalClaimsInsertList = new List<Historical_Claim__c>();
    List<Historical_Claim__c> historicalClaimsUpsertList = new List<Historical_Claim__c>();
    List<Member_Demographic__c> memberDemographicInsertList = new List<Member_Demographic__c>();
    List<Member_Demographic__c> memberDemographicUpsertList = new List<Member_Demographic__c>();
    List<Provider_Demographic__c> providerDemographicInsertList = new List<Provider_Demographic__c>();
    List<Provider_Demographic__c> providerDemographicUpsertList = new List<Provider_Demographic__c>();
    List<Prior_Auth__c> priorAuthInsertList = new List<Prior_Auth__c>();
    List<Prior_Auth__c> priorAuthUpsertList = new List<Prior_Auth__c>();
    List<Historical_Prior_Auth__c> historicalPriorAuthInsertList = new List<Historical_Prior_Auth__c>();
    List<Prior_Auth__c> historicalPriorAuthUpsertList = new List<Prior_Auth__c>();
    List<SObject> sObjectInsertList = new List<SObject>();
    List<SObject> sSObjectUpsertList = new List<SObject>();

    public List<RestAPI_JSONResponse> doRestAPIPost(Map<String,String> mapAPILog, String JSONString) {

        // Create unit of work to capture work and commit it under one transaction
	    fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

        for(String APIId:mapAPILog.keyset())
        {
            API_Log__c apiLogInstance = new API_Log__c();
            if(mapAPILog.get(APIId).length() > 2309){
                apiLogInstance.API_Request__c = mapAPILog.get(APIId).substring(0, 2309);
            }
            else{
                apiLogInstance.API_Request__c = mapAPILog.get(APIId).substring(0, mapAPILog.get(APIId).length());
            }
            apiLogInstance.Data_Staging_ID_API__c = APIId;
            ListInsertAPILogRecs.add(apiLogInstance);
            
            //Code to parse JSON file
            RestAPI_JSONRequest request = RestAPI_JSONRequest.parse(mapAPILog.get(APIId));
            Daily_Claim_JSONRequest requestDailyClaims;
            Historical_Claim_JSONRequest requestHistoricalClaims;
            Member_Demo_JSONRequest requestMemberDemographics;
            Provider_Demographic_JSONRequest requestProviderDemographics;
            Provider_Demographic_JSONRequest historicalRequestProviderDemographics;
            Prior_Auth_JSONRequest requestPriorAuths;
            Historical_Prior_Auth_JSONRequest historicalRequestPriorAuths;
            //System.debug('The parsed JSON output file is: '+request);
            //Use the File_Upsert field from Jitterbit to determine the File Type to process
            // request.File_Upsert is the File Type {Daily Claim,  Prior Auth (PA), ...)

            //Use a SOC Selector for each sObject to process via a Service based on the sObject Type 
            SObject recordInstance;
            switch on request.File_Upsert {
                when 'Daily Claims' {
                    requestDailyClaims = Daily_Claim_JSONRequest.parse(mapAPILog.get(APIId));
                    //Create Daily_Claim
                    Daily_Claim__c dailyClaimInstance = Daily_Claims.newInstance(requestDailyClaims);

                    //if(String.isEmpty(dailyClaimInstance.External_Prior_Authorization__c)){
                        dailyClaimsInsertList.add(dailyClaimInstance);
                    //}
                    //else{
                    //    dailyClaimsUpsertList.add(dailyClaimInstance);
                    // }
                }
                when 'Historical Claims' {
                    requestHistoricalClaims = Historical_Claim_JSONRequest.parse(mapAPILog.get(APIId));
                    //Create Daily_Claim
                    Historical_Claim__c historicalClaimInstance = Historical_Claims.newInstance(requestHistoricalClaims);
                    //if(String.isEmpty(historicalClaimInstance.External_Prior_Authorization__c)){
                        historicalClaimsInsertList.add(historicalClaimInstance);
                    //}
                    //else{
                    //    historicalClaimsUpsertList.add(historicalClaimInstance);
                    //}
                }
                when 'Member Demographic' {
                    requestMemberDemographics = Member_Demo_JSONRequest.parse(mapAPILog.get(APIId));
                    //Create Daily_Claim
                    Member_Demographic__c memberDemographicInstance = Member_Demo.newInstance(requestMemberDemographics);
                    //if(String.isEmpty(historicalClaimInstance.External_Prior_Authorization__c)){
                    memberDemographicInsertList.add(memberDemographicInstance);
                    //}
                    //else{
                    //    historicalClaimsUpsertList.add(historicalClaimInstance);
                    //}
                }
                when 'Provider Demographic' {
                    requestProviderDemographics = Provider_Demographic_JSONRequest.parse(mapAPILog.get(APIId));
                    //Create Daily_Claim
                    Provider_Demographic__c  providerDemographicInstance = Provider_Demographic.newInstance(requestProviderDemographics);
                    //if(String.isEmpty(historicalClaimInstance.External_Prior_Authorization__c)){
                    providerDemographicInsertList.add(providerDemographicInstance);
                    //}
                    //else{
                    //    historicalClaimsUpsertList.add(historicalClaimInstance);
                    //}
                }
                when 'Prior Authorization' {
                    requestPriorAuths = Prior_Auth_JSONRequest.parse(mapAPILog.get(APIId));
                    //Create Prior_Auth
                    Prior_Auth__c priorAuthInstance = Prior_Auth.newInstance(requestPriorAuths);
                    //if(String.isEmpty(historicalClaimInstance.External_Prior_Authorization__c)){
                    priorAuthInsertList.add(priorAuthInstance);
                    //}
                    //else{
                    //    historicalClaimsUpsertList.add(historicalClaimInstance);
                    //}
                }
                //Create Historical Prior Authorization REST API listener
                when 'Historical Prior Authorization' {
                    historicalRequestPriorAuths = Historical_Prior_Auth_JSONRequest.parse(mapAPILog.get(APIId));
                    //Create Prior_Auth
                    Historical_Prior_Auth__c historicalPriorAuthInstance = Historical_Prior_Auth.newInstance(historicalRequestPriorAuths);
                    //if(String.isEmpty(historicalClaimInstance.External_Prior_Authorization__c)){
                    historicalPriorAuthInsertList.add(historicalPriorAuthInstance);
                    //}
                    //else{
                    //    historicalClaimsUpsertList.add(historicalClaimInstance);
                    //}
                }
            }

        }//end of for mapPILog loop                             
        
        //Insert API Log records
        if(ListInsertAPILogRecs.size() > 0){
            insert ListInsertAPILogRecs;
            for(API_Log__c APILogId:ListInsertAPILogRecs){
                mapAPILogIds.put(APILogId.Id,APILogId); 
            }                                
        }
        //TODO: Need to use UnitOfWork
        List<RestAPI_JSONResponse> responses = new List<RestAPI_JSONResponse>();
        //List<Daily_Claim_JSONResponse> responses = new List<Daily_Claim_JSONResponse>();

        if(dailyClaimsInsertList.size() > 0 || dailyClaimsUpsertList.size() > 0) {
            responses = Daily_Claims.SaveResults(dailyClaimsInsertList, dailyClaimsUpsertList, JSONString);
        }

        if(historicalClaimsInsertList.size() > 0 || historicalClaimsUpsertList.size() > 0) {
            responses = Historical_Claims.SaveResults(historicalClaimsInsertList, historicalClaimsUpsertList, JSONString);
        }

        if(memberDemographicInsertList.size() > 0 || memberDemographicUpsertList.size() > 0) {
            responses = Member_Demo.SaveResults(memberDemographicInsertList, memberDemographicUpsertList, JSONString);
        }

        if(providerDemographicInsertList.size() > 0 || providerDemographicUpsertList.size() > 0) {
            responses = Provider_Demographic.SaveResults(providerDemographicInsertList, providerDemographicUpsertList, JSONString);
        }

        if(priorAuthInsertList.size() > 0 || priorAuthUpsertList.size() > 0) {
            responses = Prior_Auth.SaveResults(priorAuthInsertList, priorAuthUpsertList, JSONString);
        }

        if(historicalPriorAuthInsertList.size() > 0 || historicalPriorAuthUpsertList.size() > 0) {
            responses = Historical_Prior_Auth.SaveResults(historicalPriorAuthInsertList, historicalPriorAuthInsertList, JSONString);
        }

        ErrorLog.commitLogs();
        return responses;
    }

}