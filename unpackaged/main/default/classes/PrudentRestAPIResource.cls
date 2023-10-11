/**
 * @description       : 
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 * 
 **/
@RestResource(urlMapping='/PrudentMd/*')//
// e.g. https://prudentrx2--RBRxDev.my.salesforce.com/services/apexrest/PrudentMd
// e.g. https://prudentrx2--dev1.my.salesforce.com/services/apexrest/PrudentMd
global with sharing class PrudentRestAPIResource {
    @HttpPost
    global static String doPost() {
        // Get RestRequest
        Map<String,String> mapAPILog = new Map<String,String>();
        Map<Id,API_Log__c> mapAPILogIds = new Map<Id,API_Log__c>();
        List<API_Log__c> ListInsertAPILogRecs = new List<API_Log__c>();
        List<String> InDataStagingValues = new List<String>();
        
        List<Daily_Claim__c> dailyClaimsInsertList = new List<Daily_Claim__c>();
        List<Daily_Claim__c> dailyClaimsUpsertList = new List<Daily_Claim__c>();
        //List<Daily_Claim_JSONResponse> responses = new List<Daily_Claim_JSONResponse>();
        List<RestAPI_JSONResponse> responses = new List<RestAPI_JSONResponse>();
        List<API_Log__c> APILogRecsForUpdate = new List<API_Log__c>();
        
        RestRequest restRequest = RestContext.request;
        
        System.debug('++ Complete Request ' + RestContext.request.toString());
        System.debug('++ Header ' + restRequest.headers.get('Authorization'));
        String fileBJSONString = RestContext.request.requestBody.toString();
		System.debug('The incoming JSON File length is: '+fileBJSONString.length());
        String file_Upsert;

        // Parse JSON
        try{
            if(fileBJSONString == null){
                System.debug('The input file is blank');
            }
            else{
                if(fileBJSONString.length() > 0){
                 	String EscapeString = '\\,\\{';
                    List<String> IndividualJSONFiles = fileBJSONString.split(EscapeString);
                    
                    if(IndividualJSONFiles.size() > 0){
                        for(Integer i=0;i<IndividualJSONFiles.size();i++){
                            System.debug('The Integer i value in the loop is: '+String.valueof(i));
                            String ModifiedJSON = '';
                            String PrudentInDataStaging = '';
                            API_Log__c APILog = new API_Log__c();
                            if(i == 0){
                                ModifiedJSON = IndividualJSONFiles[i] + ']';
                                APILog.API_Request__c = ModifiedJSON; 
                            }
                            else if(i == IndividualJSONFiles.size() - 1 && IndividualJSONFiles.size() != 1){
                                ModifiedJSON = '[{' + IndividualJSONFiles[i];
                                APILog.API_Request__c = ModifiedJSON;
                            }
                            else{
                                ModifiedJSON = '[{' + IndividualJSONFiles[i] + ']';
                                APILog.API_Request__c = ModifiedJSON;                    
                            }
                            
                            ModifiedJSON = ModifiedJSON.remove('[').removeEnd(']');
                            System.debug('The latest ModifiedJSON value before parsing is: '+ModifiedJSON);
                           
                            Daily_Claim_JSONRequest request = Daily_Claim_JSONRequest.parse(ModifiedJSON);
                            if(request != null){  
                                PrudentInDataStaging = request.prudentInDataStagingId;
                                file_Upsert = request.File_Upsert;
                                System.debug('prudentInDataStagingId = '+PrudentInDataStaging);
                                System.debug('file_Upsert = '+ file_Upsert);
                                mapAPILog.put(PrudentInDataStaging,ModifiedJSON);
                                System.debug('The Prudent In Data Staging value is: '+PrudentInDataStaging);
                                System.debug('The individual JSON input BLOB for Map--> Value is: '+ModifiedJSON);
                            } 
                                                 
                        }//end of for loop
                        
                        System.debug('The mapAPILog size is: '+mapAPILog.size());

                        //Creating the API Log record for the incoming API Log JSON File(s)
                        if(mapAPILog.size() > 0){
                            responses = RestAPIService.doRestAPIPost(mapAPILog, fileBJSONString);
                        }//end of if MapAPILog.size() > 0
                    }//end of if IndividualJSONFiles.size() > 0 loop
                }//end of fileBJSONString.length > 0 loop
             }//end of else loop
             return JSON.serialize(responses);
        }//end of try block
        catch(Exception e){
            String errorMsg = file_Upsert + ' API PrudentRestResource ' + fileBJSONString + ' ' + e.getLineNumber() + ' - ' + e.getMessage();
            ErrorLog.log(file_Upsert + ' API PrudentRestResource', '', fileBJSONString, '', '', e.getLineNumber() + ' - ' + e.getMessage(), null, null, null, null);
            //insert apiLogInstance;
            //Insert API Log records
            if(ListInsertAPILogRecs.size() > 0){
                insert ListInsertAPILogRecs;
                for(API_Log__c APILogId:ListInsertAPILogRecs){
                    mapAPILogIds.put(APILogId.Data_Staging_ID_API__c,APILogId); 
                }                                
            }
            ErrorLog.commitLogs();
            
            //Return Failure Response
            //Daily_Claim_JSONResponse responseInstance  = new Daily_Claim_JSONResponse();
            RestAPI_JSONResponse responseInstance  = new RestAPI_JSONResponse();
            responseInstance.status = 'Failure';
            responseInstance.errorMessage = e.getMessage();
            responses.add(responseInstance);
            return JSON.serialize(responses);            
        }//end of catch block
   }//EOM
}