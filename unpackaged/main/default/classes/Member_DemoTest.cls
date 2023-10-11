@isTest
public class Member_DemoTest {
    @isTest
    public static void MemberDemoSuccessTest() {
        Test.startTest();

        String json = '[{"prudentInDataStagingId": "09022021565678","Subscriber_CUMB_ID": "W12345680","Patient_Email_Address": "lara@test.com","Patient_Phone_Number": "8888888890","Authorized_Representative": "Lar Res","Authorized_Representative_Relationship": "03","File_Upsert": "Member Demographic"}]';

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
    public static void MemberDemoFailureTest() {
        Test.startTest();

        String json = '[{"prudentInDataStagingId": "09022021565689","Subscriber_CUMB_ID": "456790","Patient_Email_Address": "lara@test.com","Patient_Phone_Number": "8888888890","Authorized_Representative": "Lar Res","Authorized_Representative_Relationship": "03","File_Upsert": Member Demographic"}]';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;

        String responseJSON = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> responseList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(responseJSON, List<RestAPI_JSONResponse>.class);

        // Database.SaveResult[] saveInsertResults = Database.insert(responseList, false);
        System.assertEquals('Failure', responseList.get(0).status);
        //System.debug('value is ='+responseList.get(0).errorMessage );
        //List<Member_Demographic__c> memDemoList = [SELECT id from Member_Demographic__c where Patient_CUMB_ID__c =:'456790'];
        // System.assertEquals('Failure', responseList.get(0).errorMessage );

        Test.stopTest();

    }

    @isTest
    public static void MemberDemoUpdateSuccess() {



        Member_Demographic__c memDemoInsert = new Member_Demographic__c();

        memDemoInsert.Patient_CUMB_ID__c = 'W12345680';
        memDemoInsert.Authorized_Representative__c = 'Lar Res';
        memDemoInsert.External_Authorization_Number__c='12345';
        memDemoInsert.Patient_Phone_Number__c='5678990123';

        insert memDemoInsert;

        Member_Demographic__c memDemoInsertUpdated = new Member_Demographic__c();

        memDemoInsertUpdated.Patient_CUMB_ID__c = 'W12345680';
        memDemoInsertUpdated.Authorized_Representative__c = 'Lar Res';
        memDemoInsertUpdated.External_Authorization_Number__c='12345';
        memDemoInsertUpdated.Patient_Phone_Number__c='8888888891';

        upsert memDemoInsertUpdated;
        String json = '[{"prudentInDataStagingId": "09022021565678","External_Authorization_Number":"12345",Subscriber_CUMB_ID": "W12345680","Patient_Email_Address": "lara@test.com","Patient_Phone_Number": "8888888891","Authorized_Representative": "Lar Res","Authorized_Representative_Relationship": "03","File_Upsert": "Member Demographic"}]';

         RestRequest req = new RestRequest();
         RestResponse res = new RestResponse();
         req.requestURI = '/services/apexrest/PrudentMd/';
         req.httpMethod = 'POST';
         req.requestBody = Blob.valueof(json);
         RestContext.request = req;

         Test.startTest();
         String responseJSON = PrudentRestAPIResource.doPost();
        // List<RestAPI_JSONResponse> responseList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(responseJSON, List<RestAPI_JSONResponse>.class);
        List<Member_Demographic__c> memDemoList = [SELECT id,Patient_Phone_Number__c from Member_Demographic__c where External_Authorization_Number__c=:'12345'];
        for(Member_Demographic__c memDemo :memDemoList){
        //    System.assertEquals('8888888891',memDemo.Patient_Phone_Number__c);
        }
        // System.assertEquals('failure', responseList.get(0).status);

        Test.stopTest();
    }

}