/**
 * @description       :
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 10-13-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-06-2021   Ricardy Banks					   Initial Version
 *
 **/
@IsTest
private class TestHistorical_Prior_Auth {

    //Scenario: PA doesn't exist and HCPCS doesn't exist
    //Notes: Use a drug/HCPCS that is not in Salesforce
    //Expected Results: It should create a Historical PA then error out
    @isTest
    public static void PrudentRestResourceNoDrugMatch(){

        Test.startTest();
            //Create new Account
            Account Acc = new Account();
            Acc.Name = 'Test Budding Bee Account';
            Acc.Type = 'Customer';
            Acc.Control_Number__c = '81';
            Acc.Description = 'This is a test account used on the test class';
            Acc.Go_Live_Date__c = System.today() + 20;
            Acc.PBM_Name__c = 'Caremark';
            insert Acc;

            //Create a new CSA record with Pre Go-Live Date
            CSA__c CSA = new CSA__c();
            CSA.Account__c = Acc.Id;
            CSA.CSA_Account__c = '81';
            CSA.CSA_Control__c = '900990';
            CSA.CSA_Suffix__c = '30';
            CSA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(CSA.CSA_Account__c + '-' + CSA.CSA_Control__c + '-' + CSA.CSA_Suffix__c);
            CSA.Go_Live_Date__c =  System.today() + 20; //Pre Go-Live Scenario
            CSA.Medical_Drug_List__c = 'PRUDENTMED';
            insert CSA;

            //Create a new Drug record
            Drug__c Drug = new Drug__c();
            Drug.Active_CPA__c = true;
            Drug.Copay_Assistance_Available__c = 'Yes';
            Drug.CPA_Change_Needs_Review__c = true;
            Drug.Name = 'Test Drug 30MG Injection';
            Drug.Drug_Brand_Name__c = 'MVASI';
            //Drug.NDC__c = '123456793';
            Drug.NDC_Match_Exception__c = true;
            Drug.J_Code__c = 'J1915';
            insert Drug;

            NDC__c testNDC = new NDC__c(Drug__c = Drug.Id, Name = '123456793');
            insert testNDC;

            String json =  '[{"prudentInDataStagingId": "10122021301207","Account_Number": "65","Authorization_Number": "A143","Authorized_Representative_Relationship": "7","Copay_Amount": "817.85","Control_Number": "900511","Diagnosis_Code": "12233716157","Drug_Label_Name": "Drug Thirteen","ICD9_Procedure_Code": "J5544","National_Drug_Code": "897564235","PA_Approval_Dates": "09012020","Patient_Birth_Date": "05101995","Patient_Email_Address": "AlexaKate@test.com","Patient_First_Name": "xlexx","Patient_Last_Name": "C","Patient_Middle_Initial": "R","Patient_Phone_Number": "8749986347","Patient_Sex": "F","Policy_Holder_Name": "Cigna","Prescriber_Address_Line1": "317 8th Ave NW","Prescriber_City": "Brookfield","Prescriber_Fax": "8745965874","Prescriber_First_Name": "Pearl","Prescriber_Last_Name": "Isaac","Prescriber_Phone": "8796543685","Prescriber_Practice_Name": "NONE","Prescriber_NPI_Number": "9852226592","Prescriber_Specialty": "1","Prescriber_State": "WI","Prescriber_Zip_Code": "53003","Service_Provider_Fax": "5418254452","Service_Provider_Phone": "8816510266","Servicing_Provider_Address_Line_1": "99855 Welcome Drive","Servicing_Provider_City": "Ocala","Servicing_Provider_First_Name": "Scott","Servicing_Provider_Last_Name": "Berry","Servicing_Provider_National_Provider_Identifier": "5142145551","Servicing_Provider_Service_Location_Zip_Code": "34471","Servicing_Provider_Specialty_Code": "1","Servicing_Provider_State_Code": "FL","Servicing_Provider_Practice_Role_Name": "NONE","Subscriber_Address_Line_1": "88855 Cypress Street","Subscriber_Address_Line_2": "0","Subscriber_City": "Orlando City","Subscriber_CUMB_ID": "C554775560","Member_Relationship_Code": "MRC","Subscriber_State_Code": "FL","Subscriber_Zip_Code": "33111","Suffix_Number": "65","Billing_Provider_PIN": "522925","Billing_Provider_Street_Address_Line_1": "8787 Ruler Marriott Drive","Billing_Provider_City": "Salth lake city","Billing_Provider_State_Code": "UT","Billing_Provider_Zip_Code": "84087","File_Upsert": "Historical Prior Authorization"}]';

        try {
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/PrudentMD/';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueof(json);
            RestContext.request = req;
            String responseJSON = PrudentRestAPIResource.doPost();

            //Check for expected results for Historical PA
            List<Historical_Prior_Auth__c> HPA = [SELECT Id,Status__c,Error_Log__c,Prudent_In_Data_Staging_ID__c FROM Historical_Prior_Auth__c WHERE Prudent_In_Data_Staging_ID__c = '10122021301207' LIMIT 1];
            System.debug('HPA.size = '+ HPA.size());
            if(HPA != null && HPA.size() > 0){
                System.debug('The Status value on the Historical PA record is: '+HPA[0].Status__c);
                System.debug('The Error Log value on the Historical PA record is: '+HPA[0].Error_Log__c);
                System.assertEquals('HCPCS Mismatch', HPA[0].Error_Log__c);
                System.assertEquals('Error', HPA[0].Status__c);
            }

        }
        catch(Exception e){
            System.debug('Error calling the PrudentRestResourceMissingHCPCS: '+e.getMessage());
        }
        Test.stopTest();
    }

    //Scenario: PA doesn’t exist and HCPCS exist and CSA doesn't exist
    //Notes: Use a drug/HCPCS that is in Salesforce and CSA that is not in Salesforce
    //Expected Results: It should create a Historical PA, look for a drug then error out as "CSA Mismatch"
    @isTest
    public static void PrudentRestResourceNoCSAMatch(){

        Test.startTest();
        //Create new Account
        Account Acc = new Account();
        Acc.Name = 'Test Budding Bee Account';
        Acc.Type = 'Customer';
        Acc.Control_Number__c = '81';
        Acc.Description = 'This is a test account used on the test class';
        Acc.Go_Live_Date__c = System.today() + 20;
        Acc.PBM_Name__c = 'Caremark';
        insert Acc;

        //Create a new CSA record with Pre Go-Live Date
        CSA__c CSA = new CSA__c();
        CSA.Account__c = Acc.Id;
        CSA.CSA_Account__c = '81';
        CSA.CSA_Control__c = '900990';
        CSA.CSA_Suffix__c = '30';
        CSA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(CSA.CSA_Account__c + '-' + CSA.CSA_Control__c + '-' + CSA.CSA_Suffix__c);
        CSA.Go_Live_Date__c =  System.today() + 20; //Pre Go-Live Scenario
        CSA.Medical_Drug_List__c = 'PRUDENTMED';
        insert CSA;

        //Create a new Drug record
        Drug__c Drug = new Drug__c();
        Drug.Active_CPA__c = true;
        Drug.Copay_Assistance_Available__c = 'Yes';
        Drug.CPA_Change_Needs_Review__c = true;
        Drug.Name = 'Test Drug 30MG Injection';
        Drug.Drug_Brand_Name__c = 'MVASI';
        //Drug.NDC__c = '123456793';
        Drug.NDC_Match_Exception__c = true;
        Drug.J_Code__c = 'J1234';
        Drug.Coding_Level__c = 'HCPCS';
        insert Drug;

        NDC__c testNDC = new NDC__c(Drug__c = Drug.Id, Name = '123456793');
        insert testNDC;

        String json =  '[{"prudentInDataStagingId": "10122021301212","Account_Number": "87","Authorization_Number": "C899","Authorized_Representative_Relationship": "6","Copay_Amount": "662.87","Control_Number": "900874","Diagnosis_Code": "12233716157","Drug_Label_Name": "Drug One","ICD9_Procedure_Code": "J1234","National_Drug_Code": "123456789","PA_Approval_Dates": "09302019","Patient_Birth_Date": "06081996","Patient_Email_Address": "HeJack@test.com","Patient_First_Name": "xenry","Patient_Last_Name": "C","Patient_Middle_Initial": "T","Patient_Phone_Number": "9955756521","Patient_Sex": "F","Policy_Holder_Name": "Cynosoft","Prescriber_Address_Line1": "11255 Streamdale Lane NW","Prescriber_City": "Saint Louis","Prescriber_Fax": "9986533247","Prescriber_First_Name": "Hillary","Prescriber_Last_Name": "Daniel","Prescriber_Phone": "7565896524","Prescriber_Practice_Name": "NONE","Prescriber_NPI_Number": "9861457541","Prescriber_Specialty": "1","Prescriber_State": "MO","Prescriber_Zip_Code": "66985","Service_Provider_Fax": "7466358512","Service_Provider_Phone": "9632587454","Servicing_Provider_Address_Line_1": "6598 Stringwood Street","Servicing_Provider_City": "Charlotte","Servicing_Provider_First_Name": "Karry","Servicing_Provider_Last_Name": "Ruler","Servicing_Provider_National_Provider_Identifier": "9876635851","Servicing_Provider_Service_Location_Zip_Code": "88755","Servicing_Provider_Specialty_Code": "1","Servicing_Provider_State_Code": "NC","Servicing_Provider_Practice_Role_Name": "NONE","Subscriber_Address_Line_1": "87564 Choice drive","Subscriber_Address_Line_2": "0","Subscriber_City": "Drake City","Subscriber_CUMB_ID": "C123456880","Member_Relationship_Code": "MRC","Subscriber_State_Code": "CA","Subscriber_Zip_Code": "98655","Suffix_Number": "87","Billing_Provider_PIN": "5871526","Billing_Provider_Street_Address_Line_1": "1225 State  Lane NE","Billing_Provider_City": "St. Petersburg","Billing_Provider_State_Code": "FL","Billing_Provider_Zip_Code": "35555","File_Upsert": "Historical Prior Authorization"}]';

        try {
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/PrudentMD/';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueof(json);
            RestContext.request = req;
            String responseJSON = PrudentRestAPIResource.doPost();

            //Check for expected results for Historical PA
            List<Historical_Prior_Auth__c> HPA = [SELECT Id,Status__c,Error_Log__c,Prudent_In_Data_Staging_ID__c FROM Historical_Prior_Auth__c WHERE Prudent_In_Data_Staging_ID__c = '10122021301212' LIMIT 1];
            System.debug('HPA.size = '+ HPA.size());
            if(HPA != null && HPA.size() > 0){
                System.debug('The Status value on the Historical PA record is: '+HPA[0].Status__c);
                System.debug('The Error Log value on the Historical PA record is: '+HPA[0].Error_Log__c);
                System.assertEquals('CSA Mismatch', HPA[0].Error_Log__c);
                System.assertEquals('Error', HPA[0].Status__c);
            }

        }
        catch(Exception e){
            System.debug('Error calling the PrudentRestResourceMissingHCPCS: '+e.getMessage());
        }
        Test.stopTest();
    }


    //Scenario: PA doesn't exist, Contact doesn't exist (pre go live)
    //Notes: Use a drug/HCPCS and CSA that is in Salesforce (in enrollment case)
    //Expected Results: It should create a Historical PA, Contact, ContactDrug and Enrollment Case
    @isTest
    public static void testNoPANoContactPreGoLive() {

        Test.startTest();
        //Create new Account
        Account Acc = new Account();
        Acc.Name = 'Test Budding Bee Account';
        Acc.Type = 'Customer';
        Acc.Control_Number__c = '81';
        Acc.Description = 'This is a test account used on the test class';
        Acc.Go_Live_Date__c = System.today() + 20;
        Acc.PBM_Name__c = 'Caremark';
        insert Acc;

        //Create a new CSA record with Pre Go-Live Date
        CSA__c CSA = new CSA__c();
        CSA.Account__c = Acc.Id;
        CSA.CSA_Account__c = '13';
        CSA.CSA_Control__c = '900990';
        CSA.CSA_Suffix__c = '30';
        CSA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(CSA.CSA_Account__c + '-' + CSA.CSA_Control__c + '-' + CSA.CSA_Suffix__c);
        CSA.Go_Live_Date__c = System.today() + 20; //Pre Go-Live Scenario
        CSA.Medical_Drug_List__c = 'PRUDENTMED';
        insert CSA;

        //Create a new Drug record
        Drug__c Drug = new Drug__c();
        Drug.Active_CPA__c = true;
        Drug.Copay_Assistance_Available__c = 'Yes';
        Drug.CPA_Change_Needs_Review__c = true;
        Drug.Name = 'Test Drug 30MG Injection';
        Drug.Drug_Brand_Name__c = 'MVASI';
        //Drug.NDC__c = '123456793';
        Drug.NDC_Match_Exception__c = true;
        Drug.J_Code__c = 'J1915';
        insert Drug;

        NDC__c testNDC = new NDC__c(Drug__c = Drug.Id, Name = '123456793');
        insert testNDC;

        String json =  '[{"prudentInDataStagingId": "10122021301216","Account_Number": "13","Authorization_Number": "F873","Authorized_Representative_Relationship": "9","Copay_Amount": "254.87","Control_Number": "900990","Diagnosis_Code": "12233716157","Drug_Label_Name": "Drug One","ICD9_Procedure_Code": "J1234","National_Drug_Code": "123456789","PA_Approval_Dates": "10022019","Patient_Birth_Date": "07171997","Patient_Email_Address": "PLeo@test.com","Patient_First_Name": "xexer","Patient_Last_Name": "C","Patient_Middle_Initial": "M","Patient_Phone_Number": "5566986537","Patient_Sex": "F","Policy_Holder_Name": "Microinfo","Prescriber_Address_Line1": "8745 Hugo Lane NW","Prescriber_City": "Chicago","Prescriber_Fax": "6565897815","Prescriber_First_Name": "Julia","Prescriber_Last_Name": "Cruise","Prescriber_Phone": "8875542121","Prescriber_Practice_Name": "NONE","Prescriber_NPI_Number": "7455894568","Prescriber_Specialty": "1","Prescriber_State": "IL","Prescriber_Zip_Code": "96374","Service_Provider_Fax": "2541241588","Service_Provider_Phone": "9632587454","Servicing_Provider_Address_Line_1": "6598 Stringwood Street","Servicing_Provider_City": "Charlotte","Servicing_Provider_First_Name": "Karry","Servicing_Provider_Last_Name": "Ruler","Servicing_Provider_National_Provider_Identifier": "9876635851","Servicing_Provider_Service_Location_Zip_Code": "88755","Servicing_Provider_Specialty_Code": "1","Servicing_Provider_State_Code": "NC","Servicing_Provider_Practice_Role_Name": "NONE","Subscriber_Address_Line_1": "87564 Choice drive","Subscriber_Address_Line_2": "0","Subscriber_City": "Drake City","Subscriber_CUMB_ID": "C123456880","Member_Relationship_Code": "MRC","Subscriber_State_Code": "CA","Subscriber_Zip_Code": "98655","Suffix_Number": "87","Billing_Provider_PIN": "5871526","Billing_Provider_Street_Address_Line_1": "1225 State  Lane NE","Billing_Provider_City": "St. Petersburg","Billing_Provider_State_Code": "FL","Billing_Provider_Zip_Code": "35555","File_Upsert": "Historical Prior Authorization"}]';

        try {
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/PrudentMD/';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueof(json);
            RestContext.request = req;
            String responseJSON = PrudentRestAPIResource.doPost();

            //TODO: Need to check for expected results for Historical PA
            List<Historical_Prior_Auth__c> HPA = [SELECT Id,Status__c,Error_Log__c,Prudent_In_Data_Staging_ID__c FROM Historical_Prior_Auth__c WHERE Prudent_In_Data_Staging_ID__c = '10122021301212' LIMIT 1];
            System.debug('HPA.size = '+ HPA.size());
            if(HPA != null && HPA.size() > 0){
                System.debug('The Status value on the Historical PA record is: '+HPA[0].Status__c);
                System.debug('The Error Log value on the Historical PA record is: '+HPA[0].Error_Log__c);
                System.assertEquals('CSA Mismatch', HPA[0].Error_Log__c);
                System.assertEquals('Error', HPA[0].Status__c);
            }

        }
        catch(Exception e){
            System.debug('Error calling the PrudentRestResourceMissingHCPCS: '+e.getMessage());
        }
        Test.stopTest();
    }

}