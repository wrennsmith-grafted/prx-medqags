public class Historical_ClaimsServiceImpl
    //implements IHistorical_ClaimsService
{

    //Historical_Claim_JSONResponse responseInstance  = new Historical_Claim_JSONResponse();
    //List<Historical_Claim_JSONResponse> responses = new List<Historical_Claim_JSONResponse>();
    /*
    Map<Id,API_Log__c> mapAPILogIds = new Map<Id,API_Log__c>();
    List<API_Log__c> ListInsertAPILogRecs = new List<API_Log__c>();
    List<Historical_Claim__c> HistoricalClaimsInsertList = new List<Historical_Claim__c>();
    List<Historical_Claim__c> HistoricalClaimsUpsertList = new List<Historical_Claim__c>();
    Map<String, List<Historical_Claim__c>> HistoricalClaimsListByName = new Map<String, List<Historical_Claim__c>>();
    */
    /*
    public static List<Historical_Claim_JSONResponse> doRestAPIPost(Map<String,String> mapAPILog, String JSONString) {

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
            Historical_Claim_JSONRequest request = Historical_Claim_JSONRequest.parse(mapAPILog.get(APIId));
            //System.debug('The parsed JSON output file is: '+request);
            //Use the File_Upsert field from Jittbit to determine the File Type to process
            // request.File_Upsert is the File Type {Historical Claim,  Prior Auth (PA), ...)

            //Use a SOC Selector for each sObject to process via a Service based on the sObject Type 
            //Create Historical_Claim
            Historical_Claim__c HistoricalClaimInstance = new Historical_Claim__c();
/*

            HistoricalClaimInstance.Plan_Sponsor_Name__c = request.Policy_Holder_Name;
            HistoricalClaimInstance.CSA_Control__c = request.Control_Number;
            HistoricalClaimInstance.CSA_Suffix__c = request.Suffix_Number;
            //HistoricalClaimInstance.CSA_Account__c = request.Account_Number;
            HistoricalClaimInstance.Patient_CUMB_ID__c = request.Subscriber_CUMB_ID;
            HistoricalClaimInstance.Patient_First_Name__c = request.Patient_First_Name;
            HistoricalClaimInstance.Patient_Middle_Initial__c = request.Patient_Middle_Initial;
            HistoricalClaimInstance.Patient_Last_Name__c = request.Patient_Last_Name;
            HistoricalClaimInstance.Patient_Email_Address__c = request.Patient_Email_Address;
            HistoricalClaimInstance.Patient_Birth_Date__c = FormatterUtilService.dateFormatter(request.Patient_Birth_Date);
            HistoricalClaimInstance.Patient_Gender__c = request.Patient_Sex;
            HistoricalClaimInstance.Patient_Address_Line_1__c	 = request.Subscriber_Address_Line_1;
            HistoricalClaimInstance.Patient_Address_Line_2__c = request.Subscriber_Address_Line_2;
            HistoricalClaimInstance.Patient_City__c = request.Subscriber_City;
            HistoricalClaimInstance.Patient_State__c = request.Subscriber_State_Code;
            //HistoricalClaimInstance.Patient_Zip_Code__c = FormatterUtilService.dateFormatter(request.Subscriber_Zip_Code);
            //HistoricalClaimInstance.Patient_Phone_Number__c = phoneFormatter(request.Patient_Phone_Number);
            HistoricalClaimInstance.Authorized_Representative__c = request.Authorized_Representative;
            HistoricalClaimInstance.Authorized_Relationship__c = request.Authorized_Representative_Relationship;
            HistoricalClaimInstance.Date_Of_Service_From__c = FormatterUtilService.dateFormatter(request.Service_From_Date);
            HistoricalClaimInstance.Date_Of_Service_To__c = FormatterUtilService.dateFormatter(request.Service_To_Date);
            HistoricalClaimInstance.PA_Approval_Dates__c = FormatterUtilService.dateFormatter(request.PA_Approval_Dates);
            HistoricalClaimInstance.Prior_Authorization__c = request.Authorization_Number;
            HistoricalClaimInstance.Primary_Claim_Number__c = request.Claim_Identifier;
            HistoricalClaimInstance.Drug_Label_Name__c = request.Drug_Label_Name;
            HistoricalClaimInstance.NDC__c = request.National_Drug_Code;
            HistoricalClaimInstance.HCPCS_Code__c	 = request.ICD9_Procedure_Code;
            HistoricalClaimInstance.Diagnosis_Code__c = request.Diagnosis_Code;
            HistoricalClaimInstance.Units_Billed__c =  Decimal.valueOf(request.Adjudicated_NDC_Units_Count);
            HistoricalClaimInstance.Days_Supply__c =  Decimal.valueOf(request.Days_Supply);
            HistoricalClaimInstance.Amount_Paid_By_Primary__c =  Decimal.valueOf(request.Allowable_Amount);
            HistoricalClaimInstance.Total_Copay__c =  Decimal.valueOf(request.Total_Copay_Amount);
            HistoricalClaimInstance.Total_Deductible__c =  Decimal.valueOf(request.Total_Deductible_Amount);
            HistoricalClaimInstance.Total_Coinsurance__c =   Decimal.valueOf(request.Total_Coinsurance_Amount);
            HistoricalClaimInstance.Service_Provider_First_Name__c = request.Servicing_Provider_First_Name;
            HistoricalClaimInstance.Service_Provider_Last_Name__c = request.Servicing_Provider_Last_Name;
            HistoricalClaimInstance.Service_Provider_Specialty_Code__c = request.Servicing_Provider_Specialty_Code;
            HistoricalClaimInstance.Service_Provider_NPI__c = request.Servicing_Provider_National_Provider_Identifier;
            HistoricalClaimInstance.Service_Provider_Phone__c = FormatterUtilService.phoneFormatter(request.Service_Provider_Phone);
            HistoricalClaimInstance.Service_Provider_Fax__c = request.Service_Provider_Fax;
            HistoricalClaimInstance.Service_Provider_Address_Line_1__c = request.Servicing_Provider_Address_Line_1;
            HistoricalClaimInstance.Service_Provider_City__c = request.Servicing_Provider_City;
            HistoricalClaimInstance.Service_Provider_State__c = request.Servicing_Provider_State_Code;
            HistoricalClaimInstance.Service_Provider_Zip__c = request.Servicing_Provider_Service_Location_Zip_Code;
            HistoricalClaimInstance.Service_Provider_Practice__c = request.Servicing_Provider_Practice_Role_Name;
            HistoricalClaimInstance.Billing_Provider_First_Name__c = request.Billing_Provider_First_Name;
            HistoricalClaimInstance.Billing_Provider_PIN__c = request.Billing_Provider_PIN;
            HistoricalClaimInstance.Billing_Provider_Address_Line_1__c = request.Billing_Provider_Street_Address_Line_1;
            HistoricalClaimInstance.Billing_Provider_City__c	 = request.Billing_Provider_City;
            HistoricalClaimInstance.Billing_Provider_State__c = request.Billing_Provider_State_Code;
            HistoricalClaimInstance.Billing_Provider_Zip_Code__c = request.Billing_Provider_Zip_Code;
            HistoricalClaimInstance.Claim_Code__c = request.Claim_Indicator;
           // HistoricalClaimInstance.Previous_Segment__c = request.Previous_Segment_Pointer;
            HistoricalClaimInstance.Claim_Line__c = request.Claim_Line_Identifier;
            HistoricalClaimInstance.COB_Code__c = request.COB_indicator;
            HistoricalClaimInstance.Preferred_Provider__c = request.Provider_Indicator;
            HistoricalClaimInstance.Claim_Segment__c = request.Claim_Segment;
            HistoricalClaimInstance.External_Prior_Authorization__c = SHA1UtilService.getBase64SHA1Hash(
                    HistoricalClaimInstance.Claim_Code__c +
                            HistoricalClaimInstance.Claim_Line__c +
                            HistoricalClaimInstance.NDC__c
            );

            //Load into [data log] object exactly as the record comes in.
           //if(String.isEmpty(HistoricalClaimInstance.External_Prior_Authorization__c)){
                HistoricalClaimsInsertList.add(HistoricalClaimInstance);
            //}
            //else{
            //    HistoricalClaimsUpsertList.add(HistoricalClaimInstance);
            //}

            HistoricalClaimsListByName.put('HistoricalClaimsUpsertList', HistoricalClaimsUpsertList);
            //return HistoricalClaimsListByName;
            */
        /*
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
        Database.SaveResult[] saveInsertResults = Database.insert(HistoricalClaimsInsertList, false);
        
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
            //responseInstance.hbsPatientId = HistoricalClaimsInsertList[recordCount].HBS_ID__c;
            //responseInstance.caremarkMemberId = HistoricalClaimsInsertList[recordCount].Patient_CUMB_ID__c;
            //responseInstance.prudentInDataStagingId = HistoricalClaimsInsertList[recordCount].Prudent_In_Data_Staging_ID__c;
            responses.add(responseInstance);
            recordCount ++;
        }
        
        recordCount = 0;

        //Upsert
        Schema.SObjectField authNumberField = Historical_Claim__c.Fields.External_Prior_Authorization__c;
        Database.UpsertResult[] saveUpsertResults = Database.upsert(HistoricalClaimsUpsertList, authNumberField, false);
        for (Database.UpsertResult sr : saveUpsertResults){
            Historical_Claim_JSONResponse responseInstance  = new Historical_Claim_JSONResponse();
            if (sr.isSuccess()) {
                responseInstance.status = 'Success';
            }
            else {
                responseInstance.status = 'Failure';
                if(sr.getErrors().size() > 0){
                    responseInstance.errorMessage = sr.getErrors()[0].getMessage();
                    ErrorLog.log('Historical_Claim__c API PrudentRestResource', '', JSONString, '', '', sr.getErrors()[0].getMessage(), null, null, null, null);
                }
            }
            //responseInstance.hbsPatientId = HistoricalClaimsUpsertList[recordCount].HBS_ID__c;
            //responseInstance.caremarkMemberId = HistoricalClaimsUpsertList[recordCount].Patient_CUMB_ID__c;
            //responseInstance.prudentInDataStagingId = HistoricalClaimsUpsertList[recordCount].Prudent_In_Data_Staging_ID__c;
            responses.add(responseInstance);
            recordCount ++;
        }
            
        ErrorLog.commitLogs();

        return responses;
    }
*/
}