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
public class Daily_ClaimsServiceImpl
    //implements IDaily_ClaimsService
{

    //Daily_Claim_JSONResponse responseInstance  = new Daily_Claim_JSONResponse();
    //List<Daily_Claim_JSONResponse> responses = new List<Daily_Claim_JSONResponse>();
    /*
    Map<Id,API_Log__c> mapAPILogIds = new Map<Id,API_Log__c>();

    List<API_Log__c> ListInsertAPILogRecs = new List<API_Log__c>();
    List<Daily_Claim__c> dailyClaimsInsertList = new List<Daily_Claim__c>();
    List<Daily_Claim__c> dailyClaimsUpsertList = new List<Daily_Claim__c>();
    Map<String, List<Daily_Claim__c>> dailyClaimsListByName = new Map<String, List<Daily_Claim__c>>();
    */
    /*
    public List<Daily_Claim_JSONResponse> doRestAPIPost(Map<String,String> mapAPILog, String JSONString) {

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
            Daily_Claim_JSONRequest request = Daily_Claim_JSONRequest.parse(mapAPILog.get(APIId));
            //System.debug('The parsed JSON output file is: '+request);
            //Use the File_Upsert field from Jittbit to determine the File Type to process
            // request.File_Upsert is the File Type {Daily Claim,  Prior Auth (PA), ...)

            //Use a SOC Selector for each sObject to process via a Service based on the sObject Type 
            //Create Daily_Claim
            Daily_Claim__c dailyClaimInstance = new Daily_Claim__c();
/*
            dailyClaimInstance.Plan_Sponsor_Name__c = request.Policy_Holder_Name;
            dailyClaimInstance.CSA_Control__c = request.Control_Number;
            dailyClaimInstance.CSA_Suffix__c = request.Suffix_Number;
            //dailyClaimInstance.CSA_Account__c = request.Account_Number;
            dailyClaimInstance.Patient_CUMB_ID__c = request.Subscriber_CUMB_ID;
            dailyClaimInstance.Patient_First_Name__c = request.Patient_First_Name;
            dailyClaimInstance.Patient_Middle_Initial__c = request.Patient_Middle_Initial;
            dailyClaimInstance.Patient_Last_Name__c = request.Patient_Last_Name;
            dailyClaimInstance.Patient_Email_Address__c = request.Patient_Email_Address;
            dailyClaimInstance.Patient_Birth_Date__c = FormatterUtilService.dateFormatter(request.Patient_Birth_Date);
            dailyClaimInstance.Patient_Gender__c = request.Patient_Sex;
            dailyClaimInstance.Patient_Address_Line_1__c	 = request.Subscriber_Address_Line_1;
            dailyClaimInstance.Patient_Address_Line_2__c = request.Subscriber_Address_Line_2;
            dailyClaimInstance.Patient_City__c = request.Subscriber_City;
            dailyClaimInstance.Patient_State__c = request.Subscriber_State_Code;
            //dailyClaimInstance.Patient_Zip_Code__c = FormatterUtilService.dateFormatter(request.Subscriber_Zip_Code);
            //dailyClaimInstance.Patient_Phone_Number__c = phoneFormatter(request.Patient_Phone_Number);
            dailyClaimInstance.Authorized_Representative__c = request.Authorized_Representative;
            dailyClaimInstance.Authorized_Relationship__c = request.Authorized_Representative_Relationship;
            dailyClaimInstance.Date_Of_Service_From__c = FormatterUtilService.dateFormatter(request.Service_From_Date);
            dailyClaimInstance.Date_Of_Service_To__c = FormatterUtilService.dateFormatter(request.Service_To_Date);
            dailyClaimInstance.PA_Approval_Dates__c = FormatterUtilService.dateFormatter(request.PA_Approval_Dates);
            dailyClaimInstance.Prior_Authorization__c = Decimal.valueOf(request.Authorization_Number);
            dailyClaimInstance.Primary_Claim_Number__c = request.Claim_Identifier;
            dailyClaimInstance.Drug_Label_Name__c = request.Drug_Label_Name;
            dailyClaimInstance.NDC__c = request.National_Drug_Code;
            dailyClaimInstance.HCPCS_Code__c	 = request.ICD9_Procedure_Code;
            dailyClaimInstance.Diagnosis_Code__c = request.Diagnosis_Code;
            dailyClaimInstance.Units_Billed__c = request.Adjudicated_NDC_Units_Count;
            dailyClaimInstance.Days_Supply__c = request.Days_Supply;
            dailyClaimInstance.Amount_Paid_By_Primary__c = request.Allowable_Amount;
            dailyClaimInstance.Total_Copay__c = request.Total_Copay_Amount;
            dailyClaimInstance.Total_Deductible__c = Decimal.valueOf(request.Total_Deductible_Amount);
            dailyClaimInstance.Total_Coinsurance__c =  Decimal.valueOf(request.Total_Coinsurance_Amount);
            dailyClaimInstance.Service_Provider_First_Name__c = request.Servicing_Provider_First_Name;
            dailyClaimInstance.Service_Provider_Last_Name__c = request.Servicing_Provider_Last_Name;
            dailyClaimInstance.Service_Provider_Specialty_Code__c = request.Servicing_Provider_Specialty_Code;
            dailyClaimInstance.Service_Provider_NPI__c = request.Servicing_Provider_National_Provider_Identifier;
            dailyClaimInstance.Service_Provider_Phone__c = FormatterUtilService.phoneFormatter(request.Service_Provider_Phone);
            dailyClaimInstance.Service_Provider_Fax__c = request.Service_Provider_Fax;
            dailyClaimInstance.Service_Provider_Address_Line_1__c = request.Servicing_Provider_Address_Line_1;
            dailyClaimInstance.Service_Provider_City__c = request.Servicing_Provider_City;
            dailyClaimInstance.Service_Provider_State__c = request.Servicing_Provider_State_Code;
            dailyClaimInstance.Service_Provider_Zip__c = request.Servicing_Provider_Service_Location_Zip_Code;
            dailyClaimInstance.Service_Provider_Practice__c = request.Servicing_Provider_Practice_Role_Name;
            dailyClaimInstance.Billing_Provider_First_Name__c = request.Billing_Provider_First_Name;
            dailyClaimInstance.Billing_Provider_PIN__c = request.Billing_Provider_PIN;
            dailyClaimInstance.Billing_Provider_Address_Line_1__c = request.Billing_Provider_Street_Address_Line_1;
            dailyClaimInstance.Billing_Provider_City__c	 = request.Billing_Provider_City;
            dailyClaimInstance.Billing_Provider_State__c = request.Billing_Provider_State_Code;
            dailyClaimInstance.Billing_Provider_Zip_Code__c = request.Billing_Provider_Zip_Code;
            dailyClaimInstance.Claim_Code__c = request.Claim_Indicator;
            dailyClaimInstance.Previous_Segment__c = request.Previous_Segment_Pointer;
            dailyClaimInstance.Claim_Line__c = request.Claim_Line_Identifier;
            dailyClaimInstance.COB_Code__c = request.COB_indicator;
            dailyClaimInstance.Preferred_Provider__c = request.Provider_Indicator;
            dailyClaimInstance.Claim_Segment__c = request.Claim_Segment;
            dailyClaimInstance.External_Prior_Authorization__c = SHA1UtilService.getBase64SHA1Hash(
                    dailyClaimInstance.Claim_Code__c +
                    dailyClaimInstance.Claim_Line__c +
                    dailyClaimInstance.NDC__c
            );
*/
        /*
            //Load into [data log] object exactly as the record comes in.
           if(String.isEmpty(dailyClaimInstance.External_Prior_Authorization__c)){
                dailyClaimsInsertList.add(dailyClaimInstance);
            }
            else{
                dailyClaimsUpsertList.add(dailyClaimInstance);
            }

            dailyClaimsListByName.put('dailyClaimsUpsertList', dailyClaimsUpsertList);
            //return dailyClaimsListByName;
        }//end of for mapPILog loop                             
        
        //Insert API Log records
        if(ListInsertAPILogRecs.size() > 0){
            insert ListInsertAPILogRecs;
            for(API_Log__c APILogId:ListInsertAPILogRecs){
                mapAPILogIds.put(APILogId.Id,APILogId); 
            }                                
        }
        
        Integer recordCount = 0;

        //Insert
        Database.SaveResult[] saveInsertResults = Database.insert(dailyClaimsInsertList, false);
        
        for (Database.SaveResult sr : saveInsertResults){
            if (sr.isSuccess()) {
                responseInstance.status = 'Success';
            }
            else {
                responseInstance.status = 'Failure';
                if(sr.getErrors().size() > 0){
                    responseInstance.errorMessage = sr.getErrors()[0].getMessage();
                }
            }
            //responseInstance.hbsPatientId = dailyClaimsInsertList[recordCount].HBS_ID__c;
            //responseInstance.caremarkMemberId = dailyClaimsInsertList[recordCount].Patient_CUMB_ID__c;
            responseInstance.prudentInDataStagingId = dailyClaimsInsertList[recordCount].Prudent_In_Data_Staging_ID__c;
            responses.add(responseInstance);
            recordCount ++;
        }
        
        recordCount = 0;

        //Upsert
        Schema.SObjectField authNumberField = Daily_Claim__c.Fields.External_Prior_Authorization__c;
        Database.UpsertResult[] saveUpsertResults = Database.upsert(dailyClaimsUpsertList, authNumberField, false);
        for (Database.UpsertResult sr : saveUpsertResults){
            Daily_Claim_JSONResponse responseInstance  = new Daily_Claim_JSONResponse();
            if (sr.isSuccess()) {
                responseInstance.status = 'Success';
            }
            else {
                responseInstance.status = 'Failure';
                if(sr.getErrors().size() > 0){
                    responseInstance.errorMessage = sr.getErrors()[0].getMessage();
                    ErrorLog.log('Daily_Claim__c API PrudentRestResource', '', JSONString, '', '', sr.getErrors()[0].getMessage(), null, null, null, null);
                }
            }
            //responseInstance.hbsPatientId = dailyClaimsUpsertList[recordCount].HBS_ID__c;
            //responseInstance.caremarkMemberId = dailyClaimsUpsertList[recordCount].Patient_CUMB_ID__c;
            responseInstance.prudentInDataStagingId = dailyClaimsUpsertList[recordCount].Prudent_In_Data_Staging_ID__c;
            responses.add(responseInstance);
            recordCount ++;
        }
            
        ErrorLog.commitLogs();

        return responses;
    }
*/
}