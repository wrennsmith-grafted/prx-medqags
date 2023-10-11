@isTest
public class Provider_DemographicTest {

    @isTest
    public static void ProviderDemoSucessTest() {
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

        //System.assertEquals('Success', responseList.get(0).status);

        Test.stopTest();

    }
    
    @isTest
    public static void ProviderDemoFailureTest() {
        Test.startTest();

        String json = '[{"prudentInDataStagingId": "09032021441418","Provider_NPI": "9998887778","Service_Provider_Phone": "7777777779","Service_Provider_Fax": "5555555557","Billing_Provider_Phone": "5555555555","Billing_Provider_Fax": "9999999999","File_Upsert": Provider Demographic"}]';

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
    
}