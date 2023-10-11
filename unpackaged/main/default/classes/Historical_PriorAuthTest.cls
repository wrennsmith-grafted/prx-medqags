@isTest
public class Historical_PriorAuthTest {

    //TODO: Retire Rest API test. We are using Jitterbit Connect now so the Rest API fields may be out of sync
     @isTest
    public static void HistoricalPASuccessTest() {
        Test.startTest();

        String json = '[{"prudentInDataStagingId": "09022021591307","Account_Number": "013","Authorization_Number": "A126","Authorized_Representative_Relationship": "04","Copay_Amount": "33","Control_Number": "900990","Diagnosis_Code": "12345678989","Drug_Label_Name": "Drug four","ICD9_Procedure_Code": "J1237","National_Drug_Code": "123456792","PA_Approval_Dates": "10012021","Patient_Birth_Date": "01011993","Patient_First_Name": "Rasul","Patient_Last_Name": "Adnre","Patient_Middle_Initial": "A","Patient_Phone_Number": "8888888891","Patient_Sex": "M","Policy_Holder_Name": "Wipro","Prescriber_Address_Line1": "792 Test Lane","Prescriber_City": "New York City","Prescriber_Fax": "6666666669","Prescriber_First_Name": "Gare","Prescriber_Last_Name": "Rod","Prescriber_Phone": "9999999993","Prescriber_Practice_Name": "Test4","Prescriber_NPI_Number": "9998887779","Prescriber_Specialty": "NONE","Prescriber_State": "NY","Prescriber_Zip_Code": "10126","Service_Provider_Fax": "5555555558","Service_Provider_Phone": "7777777780","Servicing_Provider_Address_Line_1": "459 Test Lane","Servicing_Provider_City": "New York City","Servicing_Provider_First_Name": "Gare","Servicing_Provider_Last_Name": "Rod","Servicing_Provider_National_Provider_Identifier": "9998887778","Servicing_Provider_Service_Location_Zip_Code": "10126","Servicing_Provider_Specialty_Code": "04","Servicing_Provider_State_Code": "NY","Servicing_Provider_Practice_Role_Name": "NONE","Subscriber_Address_Line_1": "126 Sesame Street","Subscriber_Address_Line_2": "0","Subscriber_City": "New York City","Subscriber_CUMB_ID": "W12345681","Subscriber_State_Code": "NY","Subscriber_Zip_Code": "10126","Suffix_Number": "29","Billing_Provider_PIN": "1234570","Billing_Provider_Street_Address_Line_1": "459 Test Lane","Billing_Provider_City": "New York City","Billing_Provider_State_Code": "NY","Billing_Provider_Zip_Code": "10126","File_Upsert": "Historical Prior Authorization"}]';

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
    public static void HistoricalPAFailureTest() {
        Test.startTest();

        String json = '[{"prudentInDataStagingId": "09022021591307","Account_Number": "013","Authorization_Number": "A126","Authorized_Representative_Relationship": "04","Copay_Amount": "33","Control_Number": "900990","Diagnosis_Code": "12345678989","Drug_Label_Name": "Drug four","ICD9_Procedure_Code": "J1237","National_Drug_Code": "123456792","PA_Approval_Dates": "10012021","Patient_Birth_Date": "01011993","Patient_First_Name": "Rasul","Patient_Last_Name": "Adnre","Patient_Middle_Initial": "A","Patient_Phone_Number": "8888888891","Patient_Sex": "M","Policy_Holder_Name": "Wipro","Prescriber_Address_Line1": "792 Test Lane","Prescriber_City": "New York City","Prescriber_Fax": "6666666669","Prescriber_First_Name": "Gare","Prescriber_Last_Name": "Rod","Prescriber_Phone": "9999999993","Prescriber_Practice_Name": "Test4","Prescriber_NPI_Number": "9998887779","Prescriber_Specialty": "NONE","Prescriber_State": "NY","Prescriber_Zip_Code": "10126","Service_Provider_Fax": "5555555558","Service_Provider_Phone": "7777777780","Servicing_Provider_Address_Line_1": "459 Test Lane","Servicing_Provider_City": "New York City","Servicing_Provider_First_Name": "Gare","Servicing_Provider_Last_Name": "Rod","Servicing_Provider_National_Provider_Identifier": "9998887778","Servicing_Provider_Service_Location_Zip_Code": "10126","Servicing_Provider_Specialty_Code": "04","Servicing_Provider_State_Code": "NY","Servicing_Provider_Practice_Role_Name": "NONE","Subscriber_Address_Line_1": "126 Sesame Street","Subscriber_Address_Line_2": "0","Subscriber_City": "New York City","Subscriber_CUMB_ID": "W12345681","Subscriber_State_Code": "NY","Subscriber_Zip_Code": "10126","Suffix_Number": "29","Billing_Provider_PIN": "1234570","Billing_Provider_Street_Address_Line_1": "459 Test Lane","Billing_Provider_City": "New York City","Billing_Provider_State_Code": "NY","Billing_Provider_Zip_Code": "10126","File_Upsert":Historical Prior Authorization"}]';

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