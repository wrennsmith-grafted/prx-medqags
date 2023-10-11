/**
 * @description       : Test RestAPI resource
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 * 
 **/
@isTest
public with sharing class PrudentRestAPIResourceTest {
    @testSetup static void setup() {
        //insert new Key_Value__c(Name = 'Default Queue', Value__c = UserInfo.getUserId());
        //insert new Trigger_Activation_Control__c(Name = 'CETStagingTrigger', Active__c = true);
    }

    @isTest
    public static void PrudentRestAPIResourceInsertDailyClaimSuccessTest() {
        Test.startTest();
        String json = '[{"prudentInDataStagingId": "09032021411557",\n' +
                '  "Account_Number": "010",\n' +
                '  "Adjudicated_NDC_Units_Count": "2",\n' +
                '  "Allowable_Amount": "100",\n' +
                '  "Authorization_Number": "A123",\n' +
                '  "Authorized_Representative": "Jane Smith",\n' +
                '  "Authorized_Representative_Relationship": "01",\n' +
                '  "Billing_Provider_City": "New York City",\n' +
                '  "Billing_Provider_First_Name": "Test",\n' +
                '  "Billing_Provider_Last_Name": "One",\n' +
                '  "Billing_Provider_Specialty": "Specialty 1",\n' +
                '  "Billing_Provider_PIN": "1234567",\n' +
                '  "Billing_Provider_State_Code": "NY",\n' +
                '  "Billing_Provider_Street_Address_Line_1": "456 Test Lane",\n' +
                '  "Billing_Provider_Zip_Code": "10123",\n' +
                '  "Billing_Provider_Phone": "5555555555",\n' +
                '  "Billing_Provider_Fax": "9999999999",\n' +
                '  "Claim_Identifier": "E11111111111111",\n' +
                '  "Claim_Indicator": "Initial Claim",\n' +
                '  "Claim_Line_Identifier": "1",\n' +
                '  "Claim_Segment": "00",\n' +
                '  "COB_indicator": "Secondary",\n' +
                '  "Control_Number": "900987",\n' +
                '  "Days_Supply": "30",\n' +
                '  "Diagnosis_Code": "12345678987",\n' +
                '  "Drug_Label_Name": "Drug One",\n' +
                '  "ICD9_Procedure_Code": "J1234",\n' +
                '  "National_Drug_Code": "123456789",\n' +
                '  "PA_Approval_Dates": "07012021",\n' +
                '  "Patient_Birth_Date": "01011990",\n' +
                //'  "Patient_Email_Address": "jsmith@test.com",\n' +
                '  "Patient_First_Name": "Joe",\n' +
                '  "Patient_Last_Name": "Smith",\n' +
                '  "Patient_Middle_Initial": "H",\n' +
                '  "Patient_Phone_Number": "8888888888",\n' +
                '  "Patient_Sex": "M",\n' +
                '  "Policy_Holder_Name": "Sample Company",\n' +
                '  "Previous_Segment_Pointer": "0",\n' +
                '  "Provider_Indicator": "Preferred",\n' +
                '  "Claim_Adjusted_Amount": "100.25",\n' +
                '  "Coverage_Code_Indicator": "CDI001",\n' +
                '  "Service_From_Date": "07012021",\n' +
                '  "Service_Provider_Fax": "5555555555",\n' +
                '  "Service_Provider_Phone": "7777777777",\n' +
                '  "Service_To_Date": "07012021",\n' +
                '  "Servicing_Provider_Address_Line_1": "456 Test Lane",\n' +
                '  "Servicing_Provider_City": "New York City",\n' +
                '  "Servicing_Provider_First_Name": "Jane",\n' +
                '  "Servicing_Provider_Last_Name": "Doe",\n' +
                '  "Servicing_Provider_National_Provider_Identifier": "9998887776",\n' +
                '  "Servicing_Provider_Practice_Role_Name": "NONE",\n' +
                '  "Place_of_Service": "TAMPA",\n' +
                '  "Servicing_Provider_Service_Location_Zip_Code": "10123",\n' +
                '  "Servicing_Provider_Specialty_Code": "01",\n' +
                '  "Servicing_Provider_State_Code": "NY",\n' +
                '  "Subscriber_Address_Line_1": "123 Sesame Street",\n' +
                '  "Subscriber_Address_Line_2": "0",\n' +
                '  "Subscriber_City": "New York City",\n' +
                '  "Subscriber_CUMB_ID": "W12345678",\n' +
                '  "Subscriber_State_Code": "NY",\n' +
                '  "Subscriber_Zip_Code": "10123",\n' +
                '  "Suffix_Number": "26",\n' +
                '  "Total_Coinsurance_Amount": "30",\n' +
                '  "Total_Copay_Amount": "30",\n' +
                '  "Total_Deductible_Amount": "500",\n' +
                '  "Original_UCK_ID": "null",\n' +
                '  "Person_Relationship_Code": "01",\n' +
                '  "File_Upsert": "Daily Claims"\n' +
                '}]';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;

        String responseJSON = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> responseList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(responseJSON, List<RestAPI_JSONResponse>.class);

        //System.assertEquals('Success', responseList.get(0).status);

        Test.stopTest();
    }
    /*
    @isTest
    public static void PrudentRestAPIResourceUpsertSuccessTest() {
        String json = '[{"prudentInDataStagingId": "345682","Policy_Holder_Name": "Policy_Holder_Name","Control_Number": "54321","Suffix_Number": "null","Account_Number": "null","Subscriber_CUMB_ID": "123","Patient_First_Name": "null","Patient_Middle_Initial": "null","Patient_Last_Name": "null","Patient_Email_Address": "null","Patient_Birth_Date": "09191997","Patient_Sex": "Male","Subscriber_Address_Line_1": "null","Subscriber_Address_Line_2": "null","Subscriber_City": "null","Subscriber_State_Code": "null","Subscriber_Zip_Code": "null","Patient_Phone_Number": "null","Authorized_Representative": "null","Authorized_Representative_Relationship": "null","Service_From_Date": "09192021","Service_To_Date": "09192021","PA_Approval_Dates": "09192021","Authorization_Number": "123","Claim_Identifier": "null","Drug_Label_Name": "null","National_Drug_Code": "null","ICD9_Procedure_Code": "null","Diagnosis_Code": "null","Adjudicated_NDC_Units_Count": "null","Days_Supply": "null","Allowable_Amount": "null","Total_Copay_Amount": "null","Total_Deductible_Amount": "123","Total_Coinsurance_Amount": "123","Servicing_Provider_First_Name": "null","Servicing_Provider_Last_Name": "null","Servicing_Provider_Specialty_Code": "null","Servicing_Provider_National_Provider_Identifier": "null","Service_Provider_Phone": "null","Service_Provider_Fax": "null","Servicing_Provider_Address_Line_1": "null","Servicing_Provider_City": "null","Servicing_Provider_State_Code": "null","Servicing_Provider_Service_Location_Zip_Code": "null","Servicing_Provider_Practice_Role_Name": "null","Billing_Provider_First_Name": "null","Billing_Provider_PIN": "null","Billing_Provider_Street_Address_Line_1": "null","Billing_Provider_City": "null","Billing_Provider_State_Code": "null","Billing_Provider_Zip_Code": "null","Claim_Indicator": "null","Previous_Segment_Pointer": "null","Claim_Line_Identifier": "null","COB_indicator": "null","Provider_Indicator": "null","Claim_Segment": "null","File_Upsert": "Daily Claims"}]';

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        String responseJSON = PrudentRestAPIResource.doPost();
        List<Daily_Claim_JSONResponse> responseList = (List<Daily_Claim_JSONResponse>)System.JSON.deserialize(responseJSON, List<Daily_Claim_JSONResponse>.class);
        System.assertEquals('Success', responseList.get(0).status);
    }
    */

/*
    @isTest
    public static void PrudentRestAPIResourceFailureTest() {
        String json = '[{"prudentInDataStagingId": "345682","Policy_Holder_Name": "Policy_Holder_Name","Control_Number": "54321","Suffix_Number": "null","Account_Number": "null","Subscriber_CUMB_ID": "123","Patient_First_Name": "null","Patient_Middle_Initial": "null","Patient_Last_Name": "null","Patient_Email_Address": "null","Patient_Birth_Date": "09191997","Patient_Sex": "Male","Subscriber_Address_Line_1": "null","Subscriber_Address_Line_2": "null","Subscriber_City": "null","Subscriber_State_Code": "null","Subscriber_Zip_Code": "null","Patient_Phone_Number": "null","Authorized_Representative": "null","Authorized_Representative_Relationship": "null","Service_From_Date": "09192021","Service_To_Date": "09192021","PA_Approval_Dates": "09192021","Authorization_Number": "123","Claim_Identifier": "null","Drug_Label_Name": "null","National_Drug_Code": "null","ICD9_Procedure_Code": "null","Diagnosis_Code": "null","Adjudicated_NDC_Units_Count": "null","Days_Supply": "null","Allowable_Amount": "null","Total_Copay_Amount": "null","Total_Deductible_Amount": "123","Total_Coinsurance_Amount": "123","Servicing_Provider_First_Name": "null","Servicing_Provider_Last_Name": "null","Servicing_Provider_Specialty_Code": "null","Servicing_Provider_National_Provider_Identifier": "null","Service_Provider_Phone": "null","Service_Provider_Fax": "null","Servicing_Provider_Address_Line_1": "null","Servicing_Provider_City": "null","Servicing_Provider_State_Code": "null","Servicing_Provider_Service_Location_Zip_Code": "null","Servicing_Provider_Practice_Role_Name": "null","Billing_Provider_First_Name": "null","Billing_Provider_PIN": "null","Billing_Provider_Street_Address_Line_1": "null","Billing_Provider_City": "null","Billing_Provider_State_Code": "null","Billing_Provider_Zip_Code": "null","Claim_Indicator": "null","Previous_Segment_Pointer": "null","Claim_Line_Identifier": "null","COB_indicator": "null","Provider_Indicator": "null","Claim_Segment": "null","File_Upsert": "Daily Claims"}]';


        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/PrudentRMd/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        String responseJSON = PrudentRestAPIResource.doPost();
        System.debug('++ response ' + responseJSON);
        List<Daily_Claim_JSONResponse> responseList = (List<Daily_Claim_JSONResponse>)System.JSON.deserialize(responseJSON, List<Daily_Claim_JSONResponse>.class);
        //System.assertEquals('Failure', responseList.get(0).status);
    }
    */

    @isTest
    public static void PrudentRestAPIResourceInsertHistoricalClaimSuccessTest() {
        Test.startTest();

        String json = '[{\n' +
                '  "prudentInDataStagingId": "09032021141646",\n' +
                '  "Account_Number": "010",\n' +
                '  "Adjudicated_NDC_Units_Count": "2",\n' +
                '  "Allowable_Amount": "100",\n' +
                '  "Authorization_Number": "A123",\n' +
                '  "Authorized_Representative": "Jane Smith",\n' +
                '  "Authorized_Representative_Relationship": "01",\n' +
                '  "Billing_Provider_City": "New York City",\n' +
                '  "Billing_Provider_First_Name": "Testing",\n' +
                '  "Billing_Provider_Last_Name": "One",\n' +
                '  "Billing_Provider_Specialty": "Specialty 1",\n' +
                '  "Place_of_Service__c": "PLS001",\n' +
                '  "Billing_Provider_PIN": "1234567",\n' +
                '  "Billing_Provider_State_Code": "NY",\n' +
                '  "Billing_Provider_Street_Address_Line_1": "456 Test Lane",\n' +
                '  "Billing_Provider_Zip_Code": "10123",\n' +
                '  "Billing_Provider_Phone": "5555555555",\n' +
                '  "Billing_Provider_Fax": "9999999999",\n' +
                '  "Claim_Identifier": "E11111111111111",\n' +
                '  "Claim_Indicator": "Initial Claim",\n' +
                '  "Claim_Line_Identifier": "1",\n' +
                '  "Claim_Segment": "00",\n' +
                '  "COB_indicator": "Secondary",\n' +
                '  "Control_Number": "900987",\n' +
                '  "Days_Supply": "30",\n' +
                '  "Diagnosis_Code": "12345678987",\n' +
                '  "Drug_Label_Name": "Drug One",\n' +
                '  "ICD9_Procedure_Code": "J1234",\n' +
                '  "National_Drug_Code": "1234567895",\n' +
                '  "Original_UCK_ID": "E11111111111123",\n' +
                '  "PA_Approval_Dates": "06012021",\n' +
                '  "Patient_Birth_Date": "01011990",\n' +
                //'  "Patient_Email_Address": "jsmith@test.com",\n' +
                '  "Patient_First_Name": "Joe",\n' +
                '  "Patient_Last_Name": "Smith",\n' +
                '  "Patient_Middle_Initial": "H",\n' +
                '  "Patient_Phone_Number": "8888888888",\n' +
                '  "Patient_Sex": "M",\n' +
                '  "Policy_Holder_Name": "Sample Company",\n' +
                '  "Provider_Indicator": "Preferred",\n' +
                '  "Claim_Adjusted_Amount": "100.25",\n' +
                '  "Coverage_Code_Indicator": "CDI001",\n' +
                '  "Service_From_Date": "3012021",\n' +
                '  "Service_Provider_Fax": "5555555555",\n' +
                '  "Service_Provider_Phone": "7777777777",\n' +
                '  "Service_To_Date": "3012021",\n' +
                '  "Servicing_Provider_Address_Line_1": "456 Test Lane",\n' +
                '  "Servicing_Provider_City": "New York City",\n' +
                '  "Servicing_Provider_First_Name": "Jane",\n' +
                '  "Servicing_Provider_Last_Name": "Doe",\n' +
                '  "Servicing_Provider_National_Provider_Identifier": "9998887776",\n' +
                '  "Servicing_Provider_Practice_Role_Name": "NONE",\n' +
                '  "Servicing_Provider_Service_Location_Zip_Code": "10123",\n' +
                '  "Servicing_Provider_Specialty_Code": "01",\n' +
                '  "Servicing_Provider_State_Code": "NY",\n' +
                '  "Subscriber_Address_Line_1": "123 Sesame Street",\n' +
                '  "Subscriber_Address_Line_2": "0",\n' +
                '  "Subscriber_City": "New York City",\n' +
                '  "Subscriber_CUMB_ID": "W12345678",\n' +
                '  "Subscriber_State_Code": "NY",\n' +
                '  "Subscriber_Zip_Code": "10123",\n' +
                '  "Suffix_Number": "26",\n' +
                '  "Total_Coinsurance_Amount": "30",\n' +
                '  "Total_Copay_Amount": "30",\n' +
                '  "Total_Deductible_Amount": "500",\n' +
                '  "Person_Relationship_Code": "01",\n' +
                '  "File_Upsert": "Historical Claims"\n' +
                '}]';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;

        String responseJSON = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> responseList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(responseJSON, List<RestAPI_JSONResponse>.class);

       //System.assertEquals('Success', responseList.get(0).status);

        Test.stopTest();

    }

    @isTest
    public static void PrudentRestAPIResourceInsertMemberDemographicSuccessTest() {
        Test.startTest();

        String json = '[{"prudentInDataStagingId": "09022021561335","Subscriber_CUMB_ID": "W12345680","Patient_Phone_Number": "8888888890","Authorized_Representative": "Lar Res","Authorized_Representative_Relationship": "03","File_Upsert": "Member Demographic"}]';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;

        String responseJSON = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> responseList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(responseJSON, List<RestAPI_JSONResponse>.class);

        System.assertEquals('Success', responseList.get(0).status);

        Test.stopTest();

    }

    @isTest
    public static void PrudentRestAPIResourceInsertProviderDemographicSuccessTest() {
        Test.startTest();

        String json = '[{"prudentInDataStagingId": "09032021441418","Provider_NPI": "9998887778","Service_Provider_Phone": "7777777779","Service_Provider_Fax": "5555555557","Billing_Provider_Phone": "5555555555","Billing_Provider_Fax": "9999999999","File_Upsert": "Provider Demographic"}]';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;

        String responseJSON = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> responseList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(responseJSON, List<RestAPI_JSONResponse>.class);

        System.assertEquals('Success', responseList.get(0).status);

        Test.stopTest();

    }


    @isTest
    public static void PrudentRestAPIResourceInsertPriorAuthSuccessTest() {
        Test.startTest();

        //String json = '[{"prudentInDataStagingId": "34568004","Account_Number":"013","Authorization_Number":"A126","Authorized_Representative":"Rasu And","Authorized_Representative_Relationship":"04","Billing_Provider_City":"New York City","Billing_Provider_PIN":"1234570","Billing_Provider_State_Code":"NY","Billing_Provider_Street_Address_Line_1":"459 Test Lane","Billing_Provider_Zip_Code":"10126","Control_Number":"900990","Diagnosis_Code":"12345678989","Drug_Label_Name":"Drug four","ICD9_Procedure_Code":"J1237","National_Drug_Code":"123456792","PA_Approval_Dates":"10012021","Patient_Birth_Date":"01011993","Patient_Email_Address":"resul@test.com","Patient_First_Name":"Rasul","Patient_Last_Name":"Adnre","Patient_Middle_Initial":"A","Patient_Phone_Number":"8888888891","Patient_Sex":"M","Policy_Holder_Name":"Wipro","Service_Provider_Fax":"5555555558","Service_Provider_Phone":"7777777780","Servicing_Provider_Address_Line_1":"459 Test Lane","Servicing_Provider_City":"New York City","Servicing_Provider_First_Name":"Gare","Servicing_Provider_Last_Name":"Rod","Servicing_Provider_National_Provider_Identifier":"9998887778","Servicing_Provider_Practice_Role_Name":"NONE","Servicing_Provider_Service_Location_Zip_Code":"10126","Servicing_Provider_State_Code":"NY","Subscriber_Address_Line_1":"126 Sesame Street","Subscriber_Address_Line_2":"0","Subscriber_City":"New York City","Subscriber_CUMB_ID":"W12345681","Subscriber_State_Code":"NY","Subscriber_Zip_Code":"10126","Suffix_Number":"29","File_Upsert": "Prior Authorization" }]';
        String json = '[{"prudentInDataStagingId": "09022021591307","Account_Number": "013","Authorization_Number": "A126","Authorized_Representative": "Rasu And","Authorized_Representative_Relationship": "04","Copay_Amount": "33","Control_Number": "900990","Diagnosis_Code": "12345678989","Drug_Label_Name": "Drug four","ICD9_Procedure_Code": "J1237","National_Drug_Code": "123456792","Service_Start_Date": "10012021","Service_End_Date": "12012021","Patient_Birth_Date": "01011993","Patient_First_Name": "Rasul","Patient_Last_Name": "Adnre","Patient_Middle_Initial": "A","Patient_Phone_Number": "8888888891","Patient_Sex": "M","Policy_Holder_Name": "Wipro","Prescriber_Address_Line1": "792 Test Lane","Prescriber_City": "New York City","Prescriber_Fax": "6666666669","Prescriber_First_Name": "Gare","Prescriber_Last_Name": "Rod","Prescriber_Phone": "9999999993","Prescriber_Practice_Name": "Test4","Prescriber_NPI_Number": "9998887779","Prescriber_Specialty": "NONE","Prescriber_State": "NY","Prescriber_Zip_Code": "10126","Service_Provider_Fax": "5555555558","Service_Provider_Phone": "7777777780","Servicing_Provider_Address_Line_1": "459 Test Lane","Servicing_Provider_City": "New York City","Servicing_Provider_First_Name": "Gare","Servicing_Provider_Last_Name": "Rod","Servicing_Provider_National_Provider_Identifier": "9998887778","Servicing_Provider_Service_Location_Zip_Code": "10126","Servicing_Provider_Specialty_Code": "04","Servicing_Provider_State_Code": "NY","Servicing_Provider_Practice_Role_Name": "NONE","Subscriber_Address_Line_1": "126 Sesame Street","Subscriber_Address_Line_2": "0","Subscriber_City": "New York City","Subscriber_CUMB_ID": "W12345681","Member_Relationship_Code":"MRC001","Subscriber_State_Code": "NY","Subscriber_Zip_Code": "10126","Suffix_Number": "29","Billing_Provider_PIN": "1234570","Billing_Provider_Street_Address_Line_1": "459 Test Lane","Billing_Provider_City": "New York City","Billing_Provider_State_Code": "NY","Billing_Provider_Zip_Code": "10126","File_Upsert": "Prior Authorization"}]';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;

        String responseJSON = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> responseList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(responseJSON, List<RestAPI_JSONResponse>.class);

        //System.assertEquals('Failure', responseList.get(0).status);

        Test.stopTest();

    }

    @isTest
    public static void PrudentRestAPIResourceInsertPriorAuthFailureTest() {
        Test.startTest();

        //String json = '[{"prudentInDataStagingId": "34568004","Account_Number":"013","Authorization_Number":"A126","Authorized_Representative":"Rasu And","Authorized_Representative_Relationship":"04","Billing_Provider_City":"New York City","Billing_Provider_PIN":"1234570","Billing_Provider_State_Code":"NY","Billing_Provider_Street_Address_Line_1":"459 Test Lane","Billing_Provider_Zip_Code":"10126","Control_Number":"900990","Diagnosis_Code":"12345678989","Drug_Label_Name":"Drug four","ICD9_Procedure_Code":"J1237","National_Drug_Code":"123456792","PA_Approval_Dates":"10012021","Patient_Birth_Date":"01011993","Patient_Email_Address":"resul@test.com","Patient_First_Name":"Rasul","Patient_Last_Name":"Adnre","Patient_Middle_Initial":"A","Patient_Phone_Number":"8888888891","Patient_Sex":"M","Policy_Holder_Name":"Wipro","Service_Provider_Fax":"5555555558","Service_Provider_Phone":"7777777780","Servicing_Provider_Address_Line_1":"459 Test Lane","Servicing_Provider_City":"New York City","Servicing_Provider_First_Name":"Gare","Servicing_Provider_Last_Name":"Rod","Servicing_Provider_National_Provider_Identifier":"9998887778","Servicing_Provider_Practice_Role_Name":"NONE","Servicing_Provider_Service_Location_Zip_Code":"10126","Servicing_Provider_State_Code":"NY","Subscriber_Address_Line_1":"126 Sesame Street","Subscriber_Address_Line_2":"0","Subscriber_City":"New York City","Subscriber_CUMB_ID":"W12345681","Subscriber_State_Code":"NY","Subscriber_Zip_Code":"10126","Suffix_Number":"29","File_Upsert": "Prior Authorization" }]';
        String json = '[{"prudentInDataStagingId": "09022021591307","Account_Number": "013","Authorization_Number": "A126","Authorized_Representative": "Rasu And","Authorized_Representative_Relationship": "04","Copay_Amount": "33","Control_Number": "900990","Diagnosis_Code": "12345678989","Drug_Label_Name": "Drug four","ICD9_Procedure_Code": "J1237","National_Drug_Code": "123456792","Service_Start_Date": "null","Service_End_Date": "12012021",,"Patient_Birth_Date": "01011993","Patient_First_Name": "Rasul","Patient_Last_Name": "Adnre","Patient_Middle_Initial": "A","Patient_Phone_Number": "8888888891","Patient_Sex": "M","Policy_Holder_Name": "Wipro","Prescriber_Address_Line1": "792 Test Lane","Prescriber_City": "New York City","Prescriber_Fax": "6666666669","Prescriber_First_Name": "Gare","Prescriber_Last_Name": "Rod","Prescriber_Phone": "9999999993","Prescriber_Practice_Name": "Test4","Prescriber_NPI_Number": "9998887779","Prescriber_Specialty": "NONE","Prescriber_State": "NY","Prescriber_Zip_Code": "10126","Service_Provider_Fax": "5555555558","Service_Provider_Phone": "7777777780","Servicing_Provider_Address_Line_1": "459 Test Lane","Servicing_Provider_City": "New York City","Servicing_Provider_First_Name": "Gare","Servicing_Provider_Last_Name": "Rod","Servicing_Provider_National_Provider_Identifier": "9998887778","Servicing_Provider_Service_Location_Zip_Code": "10126","Servicing_Provider_Specialty_Code_": "04","Member_Relationship_Code":"MRC001","Servicing_Provider_State_Code": "NY","Servicing_Provider_Practice_Role_Name": "NONE","Subscriber_Address_Line_1": "126 Sesame Street","Subscriber_Address_Line_2": "0","Subscriber_City": "New York City","Subscriber_CUMB_ID": "W12345681","Subscriber_State_Code": "NY","Subscriber_Zip_Code": "10126","Suffix_Number": "29","Billing_Provider_PIN": "1234570","Billing_Provider_Street_Address_Line_1": "459 Test Lane","Billing_Provider_City": "New York City","Billing_Provider_State_Code": "NY","Billing_Provider_Zip_Code": "10126","File_Upsert": "Prior Authorization"}]';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;

        String responseJSON = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> responseList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(responseJSON, List<RestAPI_JSONResponse>.class);

        System.assertEquals('Failure', responseList.get(0).status);

        Test.stopTest();

    }

}