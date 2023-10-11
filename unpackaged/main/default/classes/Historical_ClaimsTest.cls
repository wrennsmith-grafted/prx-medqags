/**
 * @description       : Test Historical Claims Domain
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             : 
 * @last modified on  : 09-17-2021
 * @last modified by  : Jyothi Gandhamaneni
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 * 
 **/
@IsTest
private class Historical_ClaimsTest {
    
    @isTest
    private static void loadingHistoricalClaimsSuccess(){
        Test.startTest();
        String json = '[{ "prudentInDataStagingId": "09032021411608","Account_Number": "18", "Adjudicated_NDC_Units_Count": "2","Allowable_Amount": "100.65", "Authorization_Number": "A131", "Authorized_Representative_Relationship": "9", "Billing_Provider_City": "New York City", "Billing_Provider_First_Name": "Test", "Billing_Provider_Last_Name": "Nine", "Billing_Provider_Specialty": "Specialty 9", "Billing_Provider_PIN": "1234575", "Billing_Provider_State_Code": "NY", "Billing_Provider_Street_Address_Line_1": "463 Test Lane", "Billing_Provider_Zip_Code": "10122", "Billing_Provider_Phone": "3333333333", "Billing_Provider_Fax": "9999999999", "Claim_Identifier": "E11111111111119", "Claim_Indicator": "Initial Claim", "Claim_Line_Identifier": "2", "Claim_Segment": "01", "COB_indicator": "Secondary", "Control_Number": "900994", "Days_Supply": "38", "Diagnosis_Code": "12345678986", "Drug_Label_Name": "Drug One", "ICD9_Procedure_Code": "J1234", "National_Drug_Code": "123456791", "PA_Approval_Dates": "11012025", "Patient_Birth_Date": "01011998", "Patient_First_Name": "jeff ", "Patient_Last_Name": "Smith", "Patient_Middle_Initial": "H", "Patient_Phone_Number": "8888888896", "Patient_Sex": "M", "Policy_Holder_Name": "Centene", "Previous_Segment_Pointer": "null", "Provider_Indicator": "Preferred", "Service_From_Date": "07012029", "Service_Provider_Fax": "5555555563", "Service_Provider_Phone": "7777777784", "Service_To_Date": "07022030", "Servicing_Provider_Address_Line_1": "464 Plane Lane", "Servicing_Provider_City": "Chicago", "Servicing_Provider_First_Name": "Jim", "Servicing_Provider_Last_Name": "Will", "Servicing_Provider_National_Provider_Identifier": "9998887784", "Servicing_Provider_Practice_Role_Name": "NONE", "Servicing_Provider_Service_Location_Zip_Code": "10131", "Servicing_Provider_Specialty_Code": "8", "Servicing_Provider_State_Code": "NY", "Subscriber_Address_Line_1": "131 Sesame Street", "Subscriber_Address_Line_2": "null", "Subscriber_City": "Los Angeles", "Subscriber_CUMB_ID": "W12345686", "Subscriber_State_Code": "NY", "Subscriber_Zip_Code": "10158", "Suffix_Number": "34", "Total_Coinsurance_Amount": "38.64", "Total_Copay_Amount": "67.65", "Total_Deductible_Amount": "507.94", "Original_UCK_ID": "null", "Person_Relationship_Code": "01", "File_Upsert": "Historical Claims" }]';
        RestRequest req = new RestRequest();
        RestResponse res= new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod='POST';
        req.requestBody= Blob.valueOf(json);
        RestContext.request = req;
        
        String jsonResponse = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> resList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(jsonResponse ,List<RestAPI_JSONResponse>.class);
        
        //System.assertEquals('Failure',resList.get(0).status);
        Test.stopTest();
    }
    
            @isTest
    private static void loadingHistoricalClaimsQA7(){
        
        // Given
        Account accountInstance = new Account(
                //Id = mockAccountId,
                Name = 'Test Account'
        );
        insert accountInstance;
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                //Id = mockCSAId,
                //Account__c = mockAccountId,
                Account__c = accountInstance.Id,
                CSA_Control__c = '900993',
                CSA_Suffix__c = '32',
                CSA_Account__c = '16'
        );
        insert csaInstance;
        Drug__c drugInstance = new Drug__c(
                Name = 'Drug Test 1',
                //NDC__c = '123456789',
                J_Code__c = 'J1234',
                Coding_Level__c = 'HCPCS'
        );
        insert drugInstance;

        NDC__c testNDC = new NDC__c(Drug__c = drugInstance.Id, Name = '123456789');
        insert testNDC;
        
        String json = '[{"prudentInDataStagingId": "09302021151414","Account_Number": "16","Adjudicated_NDC_Units_Count": "2","Allowable_Amount": "887.96","Authorization_Number": "A123","Authorized_Representative_Relationship": "1","Billing_Provider_City": "Tampa City","Billing_Provider_First_Name": "Sara","Billing_Provider_Last_Name": "Lee","Billing_Provider_Specialty": "Specialty 1","Billing_Provider_PIN": "1234567","Billing_Provider_State_Code": "FL","Billing_Provider_Street_Address_Line_1": "456 Test Lane","Billing_Provider_Zip_Code": "10123","Billing_Provider_Phone": "5555555555","Billing_Provider_Fax": "9999999999","Claim_Identifier": "K542874964","Claim_Indicator": "Initial Claim","Claim_Line_Identifier": "3","Claim_Segment": "0","COB_indicator": "Secondary","Control_Number": "900993","Days_Supply": "30","Diagnosis_Code": "12345678987","Drug_Label_Name": "Drug One","ICD9_Procedure_Code": "J1234","National_Drug_Code": "123456789","Original_UCK_ID": "null","PA_Approval_Dates": "07012027","Patient_Birth_Date": "05041995","Patient_First_Name": "Leaha","Patient_Last_Name": "Fabrya","Patient_Middle_Initial": "S","Patient_Phone_Number": "7458796541","Patient_Sex": "F","Policy_Holder_Name": "PWC","Provider_Indicator": "Preferred","Service_From_Date": "10142020","Service_Provider_Fax": "5555555555","Service_Provider_Phone": "7777777777","Service_To_Date": "10152020","Servicing_Provider_Address_Line_1": "556 Test Lane","Servicing_Provider_City": "New York City","Servicing_Provider_First_Name": "Jane ","Servicing_Provider_Last_Name": "Doe","Servicing_Provider_National_Provider_Identifier": "9998887776","Servicing_Provider_Practice_Role_Name": "NONE","Servicing_Provider_Service_Location_Zip_Code": "10123","Servicing_Provider_Specialty_Code": "1","Servicing_Provider_State_Code": "NY","Subscriber_Address_Line_1": "145 University Avenue","Subscriber_Address_Line_2": "0","Subscriber_City": "Charlotte City","Subscriber_CUMB_ID": "W77458774","Subscriber_State_Code": "NC","Subscriber_Zip_Code": "22544","Suffix_Number": "32","Total_Coinsurance_Amount": "875.54","Total_Copay_Amount": "122.74","Total_Deductible_Amount": "363.85","Person_Relationship_Code": "1","File_Upsert": "Historical Claims"}]';
        RestRequest req = new RestRequest();
        RestResponse res= new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod='POST';
        req.requestBody= Blob.valueOf(json);
        RestContext.request = req;

		Test.startTest();        
        String jsonResponse = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> resList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(jsonResponse ,List<RestAPI_JSONResponse>.class);
        Test.stopTest();
        
        //System.assertEquals('Failure',resList.get(0).status);
        
    }
    
        @isTest
    private static void loadingHistoricalClaimsQA8(){
        
                // Given
        Account accountInstance = new Account(
                //Id = mockAccountId,
                Name = 'Test Account'
        );
        insert accountInstance;
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                //Id = mockCSAId,
                //Account__c = mockAccountId,
                Account__c = accountInstance.Id,
                CSA_Control__c = 'CN0001',
                CSA_Suffix__c = 'SN0001',
                CSA_Account__c = 'AN0001'
        );
        insert csaInstance;
        Drug__c drugInstance = new Drug__c(
                Name = 'Drug Test 1',
                //NDC__c = '123456789',
                J_Code__c = 'J1234',
                Coding_Level__c = 'HCPCS'
        );
        insert drugInstance;

        NDC__c testNDC = new NDC__c(Drug__c = drugInstance.Id, Name = '123456789');
        insert testNDC;
        
        Test.startTest();
        String json = '[{"prudentInDataStagingId": "09302021341724","Account_Number": "16","Adjudicated_NDC_Units_Count": "2","Allowable_Amount": "887.96","Authorization_Number": "A123","Authorized_Representative_Relationship": "1","Billing_Provider_City": "Tampa City","Billing_Provider_First_Name": "Sara","Billing_Provider_Last_Name": "Lee","Billing_Provider_Specialty": "Specialty 1","Billing_Provider_PIN": "1234567","Billing_Provider_State_Code": "FL","Billing_Provider_Street_Address_Line_1": "456 Test Lane","Billing_Provider_Zip_Code": "10123","Billing_Provider_Phone": "5555555555","Billing_Provider_Fax": "9999999999","Claim_Identifier": "E542874962","Claim_Indicator": "Initial Claim","Claim_Line_Identifier": "3","Claim_Segment": "0","COB_indicator": "Secondary","Control_Number": "900993","Days_Supply": "30","Diagnosis_Code": "12345678987","Drug_Label_Name": "Drug Ten","ICD9_Procedure_Code": "J5678","National_Drug_Code": "87544215655","Original_UCK_ID": "null","PA_Approval_Dates": "07012027","Patient_Birth_Date": "05041995","Patient_Email_Address": "DLily@test.com","Patient_First_Name": "Eee","Patient_Last_Name": "Fab","Patient_Middle_Initial": "S","Patient_Phone_Number": "7458796541","Patient_Sex": "F","Policy_Holder_Name": "PWC","Provider_Indicator": "Preferred","Service_From_Date": "10142020","Service_Provider_Fax": "5555555555","Service_Provider_Phone": "7777777777","Service_To_Date": "10152020","Servicing_Provider_Address_Line_1": "556 Test Lane","Servicing_Provider_City": "New York City","Servicing_Provider_First_Name": "Jane ","Servicing_Provider_Last_Name": "Doe","Servicing_Provider_National_Provider_Identifier": "9998887776","Servicing_Provider_Practice_Role_Name": "NONE","Servicing_Provider_Service_Location_Zip_Code": "10123","Servicing_Provider_Specialty_Code": "1","Servicing_Provider_State_Code": "NY","Subscriber_Address_Line_1": "145 University Avenue","Subscriber_Address_Line_2": "0","Subscriber_City": "Charlotte City","Subscriber_CUMB_ID": "E77458773","Subscriber_State_Code": "NC","Subscriber_Zip_Code": "22544","Suffix_Number": "32","Total_Coinsurance_Amount": "875.54","Total_Copay_Amount": "122.74","Total_Deductible_Amount": "363.85","Person_Relationship_Code": "1","File_Upsert": "Historical Claims"}]';
        RestRequest req = new RestRequest();
        RestResponse res= new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod='POST';
        req.requestBody= Blob.valueOf(json);
        RestContext.request = req;
        
        String jsonResponse = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> resList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(jsonResponse ,List<RestAPI_JSONResponse>.class);
        
        //System.assertEquals('Failure',resList.get(0).status);
        Test.stopTest();
    }
    
    @isTest
    private static void loadingHistoricalClaimsFailure(){
        Test.startTest();
        String json = '[{ "prudentInDataStagingId": "09032021411608","Account_Number": "18", "Adjudicated_NDC_Units_Count": "2","Allowable_Amount": "100.65", "Authorization_Number": "A131", "Authorized_Representative_Relationship": "9", "Billing_Provider_City": "New York City", "Billing_Provider_First_Name": "Test", "Billing_Provider_Last_Name": "Nine", "Billing_Provider_Specialty": "Specialty 9", "Billing_Provider_PIN": "1234575", "Billing_Provider_State_Code": "NY", "Billing_Provider_Street_Address_Line_1": "463 Test Lane", "Billing_Provider_Zip_Code": "10122", "Billing_Provider_Phone": "3333333333", "Billing_Provider_Fax": "9999999999", "Claim_Identifier": "E11111111111119", "Claim_Indicator": "Initial Claim", "Claim_Line_Identifier": "2", "Claim_Segment": "01", "COB_indicator": "Secondary", "Control_Number": "900994", "Days_Supply": "38", "Diagnosis_Code": "12345678986", "Drug_Label_Name": "Drug One", "ICD9_Procedure_Code": "J1234", "National_Drug_Code": "123456791", "PA_Approval_Dates": "11012025", "Patient_Birth_Date": "01011998", "Patient_Email_Address": "jeff@test.com", "Patient_First_Name": "jeff ", "Patient_Last_Name": "Smith", "Patient_Middle_Initial": "H", "Patient_Phone_Number": "8888888896", "Patient_Sex": "M", "Policy_Holder_Name": "Centene", "Previous_Segment_Pointer": "null", "Provider_Indicator": "Preferred", "Service_From_Date": "07012029", "Service_Provider_Fax": "5555555563", "Service_Provider_Phone": "7777777784", "Service_To_Date": "07022030", "Servicing_Provider_Address_Line_1": "464 Plane Lane", "Servicing_Provider_City": "Chicago", "Servicing_Provider_First_Name": "Jim", "Servicing_Provider_Last_Name": "Will", "Servicing_Provider_National_Provider_Identifier": "9998887784", "Servicing_Provider_Practice_Role_Name": "NONE", "Servicing_Provider_Service_Location_Zip_Code": "10131", "Servicing_Provider_Specialty_Code": "8", "Servicing_Provider_State_Code": "NY", "Subscriber_Address_Line_1": "131 Sesame Street", "Subscriber_Address_Line_2": "null", "Subscriber_City": "Los Angeles", "Subscriber_CUMB_ID": "W12345686", "Subscriber_State_Code": "NY", "Subscriber_Zip_Code": "10158", "Suffix_Number": "34", "Total_Coinsurance_Amount": "38.64", "Total_Copay_Amount": "67.65", "Total_Deductible_Amount": "507.94", "Original_UCK_ID": "null", "Person_Relationship_Code": "01", "File_Upsert": Historical Claims" }]';
        RestRequest req = new RestRequest();
        RestResponse res= new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod='POST';
        req.requestBody= Blob.valueOf(json);
        RestContext.request = req;
        
        String jsonResponse = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> resList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(jsonResponse ,List<RestAPI_JSONResponse>.class);
        
        System.assertEquals('Failure',resList.get(0).status);
        Test.stopTest();
    }
    
   
    @IsTest
    private static void insertHistorical_Claims_HCPCSMismatch_IntegrationTest() {
        Historical_Claim_JSONRequest requestHistoricalClaims;

        // Given
        Historical_Claim__c HistoricalClaimInstance = new Historical_Claim__c(
                HCPCS_Code__c = 'J1234',
                Patient_CUMB_ID__c = '123',
                Patient_Birth_Date__c = System.today()
        );
        insert HistoricalClaimInstance;

        // When
        Test.startTest();

        List<Historical_Claim__c> testHistorical_ClaimList = new List<Historical_Claim__c> { HistoricalClaimInstance };

        IHistorical_Claims dailClaims =
                Historical_Claims.newInstance(testHistorical_ClaimList);

        Test.stopTest();

        // Then
        Historical_Claim__c HistoricalClaim = [SELECT Status__c, Error_Log__c FROM Historical_Claim__c WHERE Id =: HistoricalClaimInstance.Id LIMIT 1];

        System.assertEquals('Error', HistoricalClaim.Status__c);
        System.assertEquals('HCPCS Mismatch', HistoricalClaim.Error_Log__c);


    }

    @IsTest
    private static void insertHistorical_Claims_CSAMismatch_UnitTest() {
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork) mocks.mock(fflib_ISObjectUnitOfWork.class);
        // Given\
        Id mockAccountId = fflib_IDGenerator.generate(Account.SObjectType);
        Account accountInstance = new Account(
                //Id = mockAccountId,
                Name = 'Test Account'
        );
        insert accountInstance;
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                //Id = mockCSAId,
                //Account__c = mockAccountId,
                Account__c = accountInstance.Id,
                CSA_Control__c = 'CN0001',
                CSA_Suffix__c = 'SN0001',
                CSA_Account__c = 'AN0001'
        );
        insert csaInstance;
        Drug__c drugInstance = new Drug__c(
                Name = 'Drug Test 1',
                //NDC__c = '123456789',
                J_Code__c = 'IPC02',
                Coding_Level__c = 'HCPCS'
        );
        insert drugInstance;

        NDC__c testNDC = new NDC__c(Drug__c = drugInstance.Id, Name = '123456789');
        insert testNDC;

        Historical_Claim__c HistoricalClaimInstance = new Historical_Claim__c(
                //Id = fflib_IDGenerator.generate(Historical_Claim__c.SObjectType),
                HCPCS_Code__c = 'IPC02',
                //Patient_CUMB_ID__c = '123',
                Patient_Birth_Date__c = System.today(),
                CSA_Control__c = 'CN0002',
                CSA_Suffix__c = 'SN0002',
                CSA_Account__c = 'AN0002',
                CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0002' + '-' + 'SN0002' + '-' +'AN0002')
        );
        insert HistoricalClaimInstance;
        List<Historical_Claim__c> testHistorical_ClaimList = new List<Historical_Claim__c> { HistoricalClaimInstance };
        PMd_Application.UnitOfWork.setMock(uowMock);

        // When
        IHistorical_Claims dailClaims =
                Historical_Claims.newInstance(testHistorical_ClaimList);
        //dailClaims.applyDiscount(discountPercent, uowMock);
/*
        // Then
        ((fflib_ISObjectUnitOfWork)
                mocks.verify(uowMock, 1)).registerDirty(
                fflib_Match.sObjectWith(
                        new Map<SObjectField, Object>{
                                Historical_Claim__c.Status__c => 'Error',
                                Historical_Claim__c.Error_Log__c => 'HCPCS Mismatch'} ));
        */
        Historical_Claim__c HistoricalClaim = [SELECT Status__c, Error_Log__c FROM Historical_Claim__c WHERE Id =: HistoricalClaimInstance.Id LIMIT 1];

        Test.startTest();

        System.assertEquals('Error', HistoricalClaim.Status__c);
        System.assertEquals('CSA Mismatch', HistoricalClaim.Error_Log__c);

        Test.stopTest();
    }

    @IsTest
    private static void insertHistorical_Claims_CSAMismatch_IntegrationTest() {

        // Given
        Account accountInstance = new Account(
                Name = 'Test Account'
        );
        insert accountInstance;
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                CSA_Control__c = 'CN0001',
                CSA_Suffix__c = 'SN0001',
                CSA_Account__c = 'AN0001'
        );
        insert csaInstance;
        Drug__c drugInstance = new Drug__c(
                Name = 'Drug Test 1',
                //NDC__c = '123456789',
                J_Code__c = 'IPC02',
                Coding_Level__c = 'HCPCS'
        );
        insert drugInstance;

        NDC__c testNDC = new NDC__c(Drug__c = drugInstance.Id, Name = '123456789');
        insert testNDC;

        Historical_Claim__c HistoricalClaimInstance = new Historical_Claim__c(
                HCPCS_Code__c = 'IPC02',
                //Patient_CUMB_ID__c = '123',
                Patient_Birth_Date__c = System.today(),
                CSA_Control__c = 'CN0002',
                CSA_Suffix__c = 'SN0002',
                CSA_Account__c = 'AN0002',
                CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0002' + '-' + 'SN0002' + '-' +'AN0002')
        );
        insert HistoricalClaimInstance;

        List<Historical_Claim__c> testHistorical_ClaimList = new List<Historical_Claim__c> { HistoricalClaimInstance };

        Test.startTest();
        // When
        IHistorical_Claims dailClaims =
                Historical_Claims.newInstance(testHistorical_ClaimList);

        Test.stopTest();

        // Then
        Historical_Claim__c HistoricalClaim = [SELECT Status__c, Error_Log__c FROM Historical_Claim__c WHERE id =: HistoricalClaimInstance.Id LIMIT 1];

        //Expected results
        System.assertEquals('Error', HistoricalClaim.Status__c);
        System.assertEquals('CSA Mismatch', HistoricalClaim.Error_Log__c);


    }
    
    
      @isTest
    public static void updateClaims(){
        
      Drug__c testDrug = new Drug__c();
      testDrug.J_Code__c = 'J5678';
      testDrug.Coding_Level__c = 'HCPCS';
      insert testDrug;
      
      Account accountInstance = new Account();
      accountInstance.Name='Test Account';
      insert accountInstance;
      
        
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;
        
      Claim_Information__c claims = new Claim_Information__c();
      claims.Claim_Number__c='E11111111111111';
      claims.Prior_Authorization__c='B123';
      claims.Amount_Paid_By_Primary__c = 200; 
      //claims.Drug__c= testDrug.id;  
//      insert claims;
      
      Contact con = new Contact();
        con.Patient_First_Name__c= 'Sam';
        con.Patient_Last_Name__c='William';
        con.FirstName = 'Test Contact';
      	con.LastName  = 'Historical';
        con.CSA__c=csaInstance.id;
        
        insert con;
   Contact_Drug__c contactDrug = new Contact_Drug__c();
        contactDrug.Contact__c=con.id;
       // contactDrug.HCPCS_Code__c = 'J3678';
      insert contactDrug;
      
        Historical_Claim__c HistoricalClaims = new Historical_Claim__c();
        HistoricalClaims.CSA_Account__c = 'AN0003';
		HistoricalClaims.Units_Billed__c = 2;
		HistoricalClaims.Amount_Paid_By_Primary__c = 100;
		//HistoricalClaims.Prior_Authorization__c = 'A123';
		//HistoricalClaims.Authorized_Representative__c = 'Jane Smith';
		//HistoricalClaims.Authorized_Relationship__c = '1';
		HistoricalClaims.Billing_Provider_City__c = 'New York City';
		HistoricalClaims.Billing_Provider_First_Name__c = 'Test';
		HistoricalClaims.Billing_Provider_Last_Name__c = 'one';
		HistoricalClaims.Billing_Provider_Specialty__c = 'Specialty 1';
		HistoricalClaims.Billing_Provider_PIN__c = '1234567';
		HistoricalClaims.Billing_Provider_State__c = 'NY';
		HistoricalClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
		HistoricalClaims.Billing_Provider_Zip_Code__c = '10123';
        HistoricalClaims.Billing_Provider_Phone__c = '5555555555';
        HistoricalClaims.Billing_Provider_Fax__c = '9999999999';
        HistoricalClaims.Primary_Claim_Number__c = 'E11111111111111';
        //HistoricalClaims.Claim_Code__c = 'Initial Claim';
        HistoricalClaims.Claim_Line__c = '1';
        //HistoricalClaims.Claim_Segment__c = '01';
        HistoricalClaims.COB_Code__c = 'Secondary';
        HistoricalClaims.CSA_Control__c = 'CN0003';
        //HistoricalClaims.Days_Supply__c = 30;
        HistoricalClaims.Diagnosis_Code__c = '12345678987';
        HistoricalClaims.Drug_Label_Name__c = 'Drug One';
        HistoricalClaims.HCPCS_Code__c = 'J5678';
        HistoricalClaims.NDC__c = '123456789';
        HistoricalClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        HistoricalClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //HistoricalClaims.Patient_Email_Address__c = 'jsmith@test.com';
        HistoricalClaims.Patient_First_Name__c = 'Joe';
        HistoricalClaims.Patient_Last_Name__c = 'Smith';
        HistoricalClaims.Patient_Middle_Initial__c = 'H';
        HistoricalClaims.Patient_Phone_Number__c = '8888888888';
        HistoricalClaims.Patient_Gender__c = 'Male';
        HistoricalClaims.Plan_Sponsor_Name__c = 'Sample Company';
        HistoricalClaims.Preferred_Provider__c = 'Preferred';
        HistoricalClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        HistoricalClaims.Service_Provider_Fax__c = '5555555555';
        HistoricalClaims.Service_Provider_Phone__c = '7777777777';
        HistoricalClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        HistoricalClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        HistoricalClaims.Service_Provider_City__c = 'Chicago';
        HistoricalClaims.Service_Provider_First_Name__c = 'Jane';
        HistoricalClaims.Service_Provider_Last_Name__c = 'Doe';
        HistoricalClaims.Service_Provider_NPI__c = '9998887776';
        HistoricalClaims.Service_Provider_Practice__c = 'NONE';
        HistoricalClaims.Service_Provider_Zip__c = '10123';
        HistoricalClaims.Service_Provider_State__c = 'NY';
        HistoricalClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        HistoricalClaims.Patient_Address_Line_2__c = '0';
        HistoricalClaims.Patient_City__c = 'Los Angeles';
        HistoricalClaims.Patient_CUMB_ID__c = 'W12345678';
        HistoricalClaims.Patient_State__c = 'NY';
        HistoricalClaims.Patient_Zip_Code__c = '10151';
        HistoricalClaims.CSA_Suffix__c = 'SN0003';
        HistoricalClaims.Total_Coinsurance__c = 30;
        HistoricalClaims.Total_Copay__c = 30;
        HistoricalClaims.Total_Deductible__c = 500;
        //HistoricalClaims.Previous_Claim__c = '';
        HistoricalClaims.Relationship_Code__c = '01';
        HistoricalClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

       	 insert HistoricalClaims;
        
 		//Contact conList = [SELECT CSA_Account__c from Contact where id =: conRec.id];
 		//Claim_Information__c claimList = [SELECT CSA_Account__c from Claim_Information__c where id =:Claims.id ];        
   		List<Claim_Information__c> claimListCheck = [SELECT id from Claim_Information__c where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        system.assertequals(1,claimListCheck.size());
        List<Claim_Information__c> claimList = [SELECT Id, Amount_Paid_By_Primary__c from Claim_Information__c WHERE Claim_Number__c =:'E11111111111111'];
        for(Claim_Information__c claim:claimList){
            system.assertequals(100,claim.Amount_Paid_By_Primary__c);}
 		  }
    
     @isTest
	public static void missingClaimAndContactPostGoLive()
    {
    Account accountInstance = new Account(
                Name = 'Test Account'
        
        );
        
    insert accountInstance;  
        
    Drug__c testDrug = new Drug__c();
      testDrug.J_Code__c = 'J5678';
      testDrug.Coding_Level__c = 'HCPCS';
      insert testDrug;

   Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-09-17'),
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );    
      insert csaInstance;  
    
    Historical_Claim__c HistoricalClaims = new Historical_Claim__c();
        HistoricalClaims.CSA_Account__c = 'AN0003';
		HistoricalClaims.Units_Billed__c = 2;
		HistoricalClaims.Amount_Paid_By_Primary__c = 103;
		//HistoricalClaims.Prior_Authorization__c = 'A126';
		//HistoricalClaims.Authorized_Representative__c = 'Ras And';
		//HistoricalClaims.Authorized_Relationship__c = '4';
		HistoricalClaims.Billing_Provider_City__c = 'New York City';
		//HistoricalClaims.Billing_Provider_First_Name__c = 'Test';
		//HistoricalClaims.Billing_Provider_Last_Name__c = 'Four';
		//HistoricalClaims.Billing_Provider_Specialty__c = 'Specialty 4';
		HistoricalClaims.Billing_Provider_PIN__c = '1234570';
		HistoricalClaims.Billing_Provider_State__c = 'NY';
		HistoricalClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
		HistoricalClaims.Billing_Provider_Zip_Code__c = '10118';
        HistoricalClaims.Billing_Provider_Phone__c = '3333333333';
        HistoricalClaims.Billing_Provider_Fax__c = '9999999999';
        //HistoricalClaims.Primary_Claim_Number__c = 'E11111111111114';
        //HistoricalClaims.Claim_Code__c = 'Initial Claim';
        HistoricalClaims.Claim_Line__c = '3';
        //HistoricalClaims.Claim_Segment__c = '00';
        HistoricalClaims.COB_Code__c = 'Secondary';
        HistoricalClaims.CSA_Control__c = 'CN0003';
        //HistoricalClaims.Days_Supply__c = 32;
        HistoricalClaims.Diagnosis_Code__c = '12345678989';
        HistoricalClaims.Drug_Label_Name__c = 'Drug Four';
        HistoricalClaims.HCPCS_Code__c = 'J5678';
        //HistoricalClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        HistoricalClaims.NDC__c = '123456792';
        //HistoricalClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        HistoricalClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalClaims.Patient_Email_Address__c = 'lara@test.com';
        HistoricalClaims.Patient_First_Name__c = 'Lara';
        HistoricalClaims.Patient_Last_Name__c = 'Briyan';
        HistoricalClaims.Patient_Middle_Initial__c = 'B';
        HistoricalClaims.Patient_Phone_Number__c = '8888888890';
        HistoricalClaims.Patient_Gender__c = 'Male';
        HistoricalClaims.Plan_Sponsor_Name__c = 'TCS';
        HistoricalClaims.Preferred_Provider__c = 'Preferred';
        HistoricalClaims.Date_Of_Service_From__c = date.valueOf('2024-07-01');
        HistoricalClaims.Service_Provider_Fax__c = '5555555557';
        HistoricalClaims.Service_Provider_Phone__c = '7777777779';
        HistoricalClaims.Date_Of_Service_To__c = date.valueOf('2024-07-02');
        HistoricalClaims.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        HistoricalClaims.Service_Provider_City__c = 'Chicago';
        HistoricalClaims.Service_Provider_First_Name__c = 'Dave';
        HistoricalClaims.Service_Provider_Last_Name__c = 'Dle';
        HistoricalClaims.Service_Provider_NPI__c = '9998887778';
        HistoricalClaims.Service_Provider_Practice__c = 'NONE';
        HistoricalClaims.Service_Provider_Zip__c = '10125';
        HistoricalClaims.Service_Provider_Specialty_Code__c = '3';
        HistoricalClaims.Service_Provider_State__c = 'NY';
        HistoricalClaims.Patient_Address_Line_1__c = '125 Sesame Street';
        HistoricalClaims.Patient_Address_Line_2__c = 'Apt 4';
        HistoricalClaims.Patient_City__c = 'Los Angeles';
        HistoricalClaims.Patient_CUMB_ID__c = 'W12345680';
        HistoricalClaims.Patient_State__c = 'NY';
        HistoricalClaims.Patient_Zip_Code__c = '10153';
        HistoricalClaims.CSA_Suffix__c = 'SN0003';
        HistoricalClaims.Total_Coinsurance__c = 33;
        HistoricalClaims.Total_Copay__c = 72;
        HistoricalClaims.Total_Deductible__c = 502;
        //HistoricalClaims.Previous_Claim__c = '';
        HistoricalClaims.Relationship_Code__c = '01';
        HistoricalClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');
        
        insert HistoricalClaims;
        
        Test.startTest();
        List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Contact__c =:conlist[0].id ];
       
        system.assertequals(1,claimList.size());
        system.assertequals(1,conList.size());
        system.assertequals(1,contactDrugList.size());
         for (Claim_Information__c claim: claimList){
            List<Case> caseList = [SELECT id from Case where Claim_Information__c =: claim.id ];
         system.assertequals(1,caseList.size());}

        //system.assertequals(1,contactDrugList.size());
       

        
        
        Test.stopTest();
        
    }
    
    @isTest
	public static void missingClaimAndContactPreGoLive()
    {
    Account accountInstance = new Account(
                Name = 'Test Account'
        
        );
        
    insert accountInstance;  
        
    Drug__c testDrug = new Drug__c();
    testDrug.J_Code__c = 'J5678';
    testDrug.Coding_Level__c = 'HCPCS';
    insert testDrug;

   Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-09-06'),
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );    
      insert csaInstance;  
    
    Historical_Claim__c HistoricalClaims = new Historical_Claim__c();
        HistoricalClaims.CSA_Account__c = 'AN0003';
		HistoricalClaims.Units_Billed__c = 2;
		HistoricalClaims.Amount_Paid_By_Primary__c = 103;
		//HistoricalClaims.Prior_Authorization__c = 'A126';
		//HistoricalClaims.Authorized_Representative__c = 'Ras And';
		//HistoricalClaims.Authorized_Relationship__c = '4';
		HistoricalClaims.Billing_Provider_City__c = 'New York City';
		//HistoricalClaims.Billing_Provider_First_Name__c = 'Test';
		//HistoricalClaims.Billing_Provider_Last_Name__c = 'Four';
		//HistoricalClaims.Billing_Provider_Specialty__c = 'Specialty 4';
		HistoricalClaims.Billing_Provider_PIN__c = '1234570';
		HistoricalClaims.Billing_Provider_State__c = 'NY';
		HistoricalClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
		HistoricalClaims.Billing_Provider_Zip_Code__c = '10118';
        HistoricalClaims.Billing_Provider_Phone__c = '3333333333';
        HistoricalClaims.Billing_Provider_Fax__c = '9999999999';
        //HistoricalClaims.Primary_Claim_Number__c = 'E11111111111114';
        //HistoricalClaims.Claim_Code__c = 'Initial Claim';
        HistoricalClaims.Claim_Line__c = '3';
        //HistoricalClaims.Claim_Segment__c = '00';
        //HistoricalClaims.COB_Code__c = 'Secondary';
        HistoricalClaims.CSA_Control__c = 'CN0003';
        //HistoricalClaims.Days_Supply__c = 32;
        HistoricalClaims.Diagnosis_Code__c = '12345678989';
        HistoricalClaims.Drug_Label_Name__c = 'Drug Four';
        HistoricalClaims.HCPCS_Code__c = 'J5678';
        //HistoricalClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        HistoricalClaims.NDC__c = '123456792';
        //HistoricalClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        HistoricalClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalClaims.Patient_Email_Address__c = 'lara@test.com';
        HistoricalClaims.Patient_First_Name__c = 'Lara';
        HistoricalClaims.Patient_Last_Name__c = 'Briyan';
        HistoricalClaims.Patient_Middle_Initial__c = 'B';
        HistoricalClaims.Patient_Phone_Number__c = '8888888890';
        HistoricalClaims.Patient_Gender__c = 'Male';
        HistoricalClaims.Plan_Sponsor_Name__c = 'TCS';
        HistoricalClaims.Preferred_Provider__c = 'Preferred';
        HistoricalClaims.Date_Of_Service_From__c = date.valueOf('2024-07-01');
        HistoricalClaims.Service_Provider_Fax__c = '5555555557';
        HistoricalClaims.Service_Provider_Phone__c = '7777777779';
        HistoricalClaims.Date_Of_Service_To__c = date.valueOf('2024-07-02');
        HistoricalClaims.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        HistoricalClaims.Service_Provider_City__c = 'Chicago';
        HistoricalClaims.Service_Provider_First_Name__c = 'Dave';
        HistoricalClaims.Service_Provider_Last_Name__c = 'Dle';
        HistoricalClaims.Service_Provider_NPI__c = '9998887778';
        HistoricalClaims.Service_Provider_Practice__c = 'NONE';
        HistoricalClaims.Service_Provider_Zip__c = '10125';
        HistoricalClaims.Service_Provider_Specialty_Code__c = '3';
        HistoricalClaims.Service_Provider_State__c = 'NY';
        HistoricalClaims.Patient_Address_Line_1__c = '125 Sesame Street';
        HistoricalClaims.Patient_Address_Line_2__c = 'Apt 4';
        HistoricalClaims.Patient_City__c = 'Los Angeles';
        HistoricalClaims.Patient_CUMB_ID__c = 'W12345680';
        HistoricalClaims.Patient_State__c = 'NY';
        HistoricalClaims.Patient_Zip_Code__c = '10153';
        HistoricalClaims.CSA_Suffix__c = 'SN0003';
        HistoricalClaims.Total_Coinsurance__c = 33;
        HistoricalClaims.Total_Copay__c = 72;
        HistoricalClaims.Total_Deductible__c = 502;
        //HistoricalClaims.Previous_Claim__c = '';
        HistoricalClaims.Relationship_Code__c = '01';
        HistoricalClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');
        
        insert HistoricalClaims;
        
        Test.startTest();
        List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Contact__c =:conlist[0].id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(1,claimList.size());
        system.assertequals(1,conList.size());
        system.assertequals(1,contactDrugList.size());
         for (Claim_Information__c claim: claimList){
            List<Case> caseList = [SELECT id from Case where Claim_Information__c =: claim.id ];
         system.assertequals(1,caseList.size());}

        //system.assertequals(1,contactDrugList.size());
       

        
        
        Test.stopTest();
        
    }
    
     
    @isTest
    public static void missingClaimAndContactDrugPreGoLive()
    {
    Account accountInstance = new Account(
                Name = 'Test Account'
        
        );
        
    insert accountInstance;  
        
    Drug__c testDrug = new Drug__c();
    testDrug.J_Code__c = 'J5678';
    testDrug.Coding_Level__c = 'HCPCS';
    insert testDrug;
    
    Drug__c testDrug1 = new Drug__c();
    testDrug1.J_Code__c = 'J6783';
    testDrug1.Coding_Level__c = 'HCPCS';
    insert testDrug1;
      
   Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-09-09'),
                CSA_Control__c = 'CN0010',
                CSA_Suffix__c = 'SN0010',
                CSA_Account__c = 'AN0010'
        );    
      insert csaInstance;  
        
   Contact con = new Contact();
        con.Patient_First_Name__c= 'Sam';
        con.Patient_Last_Name__c='William';
        con.FirstName = 'Test Contact';
      	con.LastName  = 'Historical';
        con.CSA_Account__c='AN0010';
        con.CSA__c=csaInstance.id;
        
        insert con;
   Contact_Drug__c conDrug = new Contact_Drug__c();
        conDrug.Contact__c = con.id;
        conDrug.Drug_Name__c = testDrug1.id;
        
        insert conDrug;
  
    Historical_Claim__c HistoricalClaims = new Historical_Claim__c();
        HistoricalClaims.CSA_Account__c = 'AN0010';
		HistoricalClaims.Units_Billed__c = 2;
		HistoricalClaims.Amount_Paid_By_Primary__c = 103;
		//HistoricalClaims.Prior_Authorization__c = 'A127';
		//HistoricalClaims.Authorized_Representative__c = 'Ras And';
		//HistoricalClaims.Authorized_Relationship__c = '4';
		HistoricalClaims.Billing_Provider_City__c = 'New York City';
		//HistoricalClaims.Billing_Provider_First_Name__c = 'Test';
		//HistoricalClaims.Billing_Provider_Last_Name__c = 'Four';
		//HistoricalClaims.Billing_Provider_Specialty__c = 'Specialty 4';
		HistoricalClaims.Billing_Provider_PIN__c = '1234570';
		HistoricalClaims.Billing_Provider_State__c = 'NY';
		HistoricalClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
		HistoricalClaims.Billing_Provider_Zip_Code__c = '10118';
        HistoricalClaims.Billing_Provider_Phone__c = '3333333333';
        HistoricalClaims.Billing_Provider_Fax__c = '9999999999';
        //HistoricalClaims.Primary_Claim_Number__c = 'E11111111111114';
        //HistoricalClaims.Claim_Code__c = 'Initial Claim';
        HistoricalClaims.Claim_Line__c = '3';
        //HistoricalClaims.Claim_Segment__c = '00';
        HistoricalClaims.COB_Code__c = 'Secondary';
        HistoricalClaims.CSA_Control__c = 'CN0010';
        //HistoricalClaims.Days_Supply__c = 32;
        HistoricalClaims.Diagnosis_Code__c = '12345678989';
        HistoricalClaims.Drug_Label_Name__c = 'Drug Four';
        HistoricalClaims.HCPCS_Code__c = 'J5678';
        //HistoricalClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        HistoricalClaims.NDC__c = '123456792';
        //HistoricalClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        HistoricalClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalClaims.Patient_Email_Address__c = 'lara@test.com';
        HistoricalClaims.Patient_First_Name__c = 'Sam';
        HistoricalClaims.Patient_Last_Name__c = 'William';
        HistoricalClaims.Patient_Middle_Initial__c = 'B';
        HistoricalClaims.Patient_Phone_Number__c = '8888888890';
        HistoricalClaims.Patient_Gender__c = 'Male';
        HistoricalClaims.Plan_Sponsor_Name__c = 'TCS';
        HistoricalClaims.Preferred_Provider__c = 'Preferred';
        HistoricalClaims.Date_Of_Service_From__c = date.valueOf('2024-07-01');
        HistoricalClaims.Service_Provider_Fax__c = '5555555557';
        HistoricalClaims.Service_Provider_Phone__c = '7777777779';
        HistoricalClaims.Date_Of_Service_To__c = date.valueOf('2024-07-02');
        HistoricalClaims.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        HistoricalClaims.Service_Provider_City__c = 'Chicago';
        HistoricalClaims.Service_Provider_First_Name__c = 'Dave';
        HistoricalClaims.Service_Provider_Last_Name__c = 'Dle';
        HistoricalClaims.Service_Provider_NPI__c = '9998887778';
        HistoricalClaims.Service_Provider_Practice__c = 'NONE';
        HistoricalClaims.Service_Provider_Zip__c = '10125';
        HistoricalClaims.Service_Provider_Specialty_Code__c = '3';
        HistoricalClaims.Service_Provider_State__c = 'NY';
        HistoricalClaims.Patient_Address_Line_1__c = '125 Sesame Street';
        HistoricalClaims.Patient_Address_Line_2__c = 'Apt 4';
        HistoricalClaims.Patient_City__c = 'Los Angeles';
        HistoricalClaims.Patient_CUMB_ID__c = 'W12345680';
        HistoricalClaims.Patient_State__c = 'NY';
        HistoricalClaims.Patient_Zip_Code__c = '10153';
        HistoricalClaims.CSA_Suffix__c = 'SN0010';
        HistoricalClaims.Total_Coinsurance__c = 33;
        HistoricalClaims.Total_Copay__c = 72;
        HistoricalClaims.Total_Deductible__c = 502;
        //HistoricalClaims.Previous_Claim__c = '';
        HistoricalClaims.Relationship_Code__c = '01';
        HistoricalClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0010' + 'SN0010' +'AN0010');
        
        insert HistoricalClaims;
        
        Test.startTest();
        List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Contact__c =:conlist[0].id ];
        system.assertequals(1,contactDrugList.size());
        //List<Case> caseList = [SELECT id from Case where Contact_Drug__c=: contactDrug.id ];

        system.assertequals(1,claimList.size());
        //system.assertequals(1,conList.size());
        system.assertequals(1,contactDrugList.size());
        //system.assertequals(1,caseList.size());
         for (Claim_Information__c claim: claimList){
            List<Case> caseList = [SELECT id from Case where Claim_Information__c =: claim.id ];
         system.assertequals(1,caseList.size());}


        Test.stopTest();
        
    }
	@isTest
    public static void missingClaimAndContactDrugPostGoLive()
    {
    Account accountInstance = new Account(
                Name = 'Test Account'
        
        );
        
    insert accountInstance;  
        
    Drug__c testDrug = new Drug__c();
      testDrug.J_Code__c = 'J5678';
    testDrug.Coding_Level__c = 'HCPCS';
      insert testDrug;
    Drug__c testDrug1 = new Drug__c();
        testDrug1.J_Code__c = 'J6783';
        testDrug1.Coding_Level__c = 'HCPCS';
        insert testDrug1;  
    Drug__c testDrug2 = new Drug__c();
        testDrug2.J_Code__c = 'J6784';
        testDrug2.Coding_Level__c = 'HCPCS';
        insert testDrug2;    
   Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2030-09-17'),
                CSA_Control__c = 'CN0006',
                CSA_Suffix__c = 'SN0006',
                CSA_Account__c = 'AN0006'
        );    
      insert csaInstance;  
        
   Contact con = new Contact();
        con.Patient_First_Name__c= 'Sam';
        con.Patient_Last_Name__c='William';
        con.FirstName = 'Test Contact';
      	con.LastName  = 'Historical';
        con.CSA__c=csaInstance.id;
        
        insert con;
   Contact_Drug__c contactDrug1 = new Contact_Drug__c();
        contactDrug1.Contact__c=con.id;
        contactDrug1.Drug_Name__c= testDrug1.id;
       // contactDrug.HCPCS_Code__c = 'J3678';
      insert contactDrug1;
        
   Contact_Drug__c contactDrug2 = new Contact_Drug__c();
        contactDrug1.Contact__c=con.id;
        contactDrug2.Drug_Name__c= testDrug2.id;
       // contactDrug.HCPCS_Code__c = 'J3678';
      insert contactDrug2;    
        
        
    Historical_Claim__c HistoricalClaims = new Historical_Claim__c();
        HistoricalClaims.CSA_Account__c = 'AN0006';
		HistoricalClaims.Units_Billed__c = 2;
		HistoricalClaims.Amount_Paid_By_Primary__c = 103;
		//HistoricalClaims.Prior_Authorization__c = 'A127';
		//HistoricalClaims.Authorized_Representative__c = 'Ras And';
		//HistoricalClaims.Authorized_Relationship__c = '4';
		HistoricalClaims.Billing_Provider_City__c = 'New York City';
		//HistoricalClaims.Billing_Provider_First_Name__c = 'Test';
		//HistoricalClaims.Billing_Provider_Last_Name__c = 'Four';
		//HistoricalClaims.Billing_Provider_Specialty__c = 'Specialty 4';
		HistoricalClaims.Billing_Provider_PIN__c = '1234570';
		HistoricalClaims.Billing_Provider_State__c = 'NY';
		HistoricalClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
		HistoricalClaims.Billing_Provider_Zip_Code__c = '10118';
        HistoricalClaims.Billing_Provider_Phone__c = '3333333333';
        HistoricalClaims.Billing_Provider_Fax__c = '9999999999';
        //HistoricalClaims.Primary_Claim_Number__c = 'E11111111111114';
        //HistoricalClaims.Claim_Code__c = 'Initial Claim';
        HistoricalClaims.Claim_Line__c = '3';
        //HistoricalClaims.Claim_Segment__c = '00';
        HistoricalClaims.COB_Code__c = 'Secondary';
        HistoricalClaims.CSA_Control__c = 'CN0006';
        //HistoricalClaims.Days_Supply__c = 32;
        HistoricalClaims.Diagnosis_Code__c = '12345678989';
        HistoricalClaims.Drug_Label_Name__c = 'Drug Four';
        HistoricalClaims.HCPCS_Code__c = 'J5678';
        //HistoricalClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        HistoricalClaims.NDC__c = '123456792';
        //HistoricalClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        HistoricalClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalClaims.Patient_Email_Address__c = 'lara@test.com';
        HistoricalClaims.Patient_First_Name__c = 'Sam';
        HistoricalClaims.Patient_Last_Name__c = 'William';
        HistoricalClaims.Patient_Middle_Initial__c = 'B';
        HistoricalClaims.Patient_Phone_Number__c = '8888888890';
        HistoricalClaims.Patient_Gender__c = 'Male';
        HistoricalClaims.Plan_Sponsor_Name__c = 'TCS';
        HistoricalClaims.Preferred_Provider__c = 'Preferred';
        HistoricalClaims.Date_Of_Service_From__c = date.valueOf('2024-07-01');
        HistoricalClaims.Service_Provider_Fax__c = '5555555557';
        HistoricalClaims.Service_Provider_Phone__c = '7777777779';
        HistoricalClaims.Date_Of_Service_To__c = date.valueOf('2024-07-02');
        HistoricalClaims.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        HistoricalClaims.Service_Provider_City__c = 'Chicago';
        HistoricalClaims.Service_Provider_First_Name__c = 'Dave';
        HistoricalClaims.Service_Provider_Last_Name__c = 'Dle';
        HistoricalClaims.Service_Provider_NPI__c = '9998887778';
        HistoricalClaims.Service_Provider_Practice__c = 'NONE';
        HistoricalClaims.Service_Provider_Zip__c = '10125';
        HistoricalClaims.Service_Provider_Specialty_Code__c = '3';
        HistoricalClaims.Service_Provider_State__c = 'NY';
        HistoricalClaims.Patient_Address_Line_1__c = '125 Sesame Street';
        HistoricalClaims.Patient_Address_Line_2__c = 'Apt 4';
        HistoricalClaims.Patient_City__c = 'Los Angeles';
        HistoricalClaims.Patient_CUMB_ID__c = 'W12345680';
        HistoricalClaims.Patient_State__c = 'NY';
        HistoricalClaims.Patient_Zip_Code__c = '10153';
        HistoricalClaims.CSA_Suffix__c = 'SN0006';
        HistoricalClaims.Total_Coinsurance__c = 33;
        HistoricalClaims.Total_Copay__c = 72;
        HistoricalClaims.Total_Deductible__c = 502;
        //HistoricalClaims.Previous_Claim__c = '';
        HistoricalClaims.Relationship_Code__c = '01';
        HistoricalClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0006' + 'SN0006' +'AN0006');
        
        insert HistoricalClaims;
        
        Test.startTest();
        List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Contact__c =:conlist[0].id ];
        
        
        //List<Case> caseList = [SELECT id from Case where Contact_Drug__c=: contactDrug.id ];

        system.assertequals(1,claimList.size());
        //system.assertequals(1,conList.size());
        system.assertequals(1,contactDrugList.size());
        //system.assertequals(1,caseList.size());
         for (Claim_Information__c claim: claimList){
            List<Case> caseList = [SELECT id from Case where Claim_Information__c =: claim.id ];
         system.assertequals(1,caseList.size());}

        Test.stopTest();
        
    }
  
   @isTest
    public static void missingClaimPostGoLive()
    {
    Account accountInstance = new Account(
                Name = 'Test Account'
        
        );
        
    insert accountInstance;  
        
    Drug__c testDrug = new Drug__c();
      testDrug.J_Code__c = 'J5678';
    testDrug.Coding_Level__c = 'HCPCS';
      insert testDrug;
     
   Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2030-09-17'),
                CSA_Control__c = 'CN0006',
                CSA_Suffix__c = 'SN0006',
                CSA_Account__c = 'AN0006'
        );    
      insert csaInstance;  
        
   Contact con = new Contact();
        con.Patient_First_Name__c= 'Sam';
        con.Patient_Last_Name__c='William';
        con.FirstName = 'Test Contact';
      	con.LastName  = 'Historical';
        con.CSA__c=csaInstance.id;
        
        insert con;
   Contact_Drug__c contactDrug1 = new Contact_Drug__c();
        contactDrug1.Contact__c=con.id;
      contactDrug1.Drug_Name__c= testDrug.id;
      insert contactDrug1;
        
    Historical_Claim__c HistoricalClaims = new Historical_Claim__c();
        HistoricalClaims.CSA_Account__c = 'AN0006';
		HistoricalClaims.Units_Billed__c = 2;
		HistoricalClaims.Amount_Paid_By_Primary__c = 103;
		//HistoricalClaims.Prior_Authorization__c = 'A127';
		//HistoricalClaims.Authorized_Representative__c = 'Ras And';
		//HistoricalClaims.Authorized_Relationship__c = '4';
		HistoricalClaims.Billing_Provider_City__c = 'New York City';
		//HistoricalClaims.Billing_Provider_First_Name__c = 'Test';
		//HistoricalClaims.Billing_Provider_Last_Name__c = 'Four';
		//HistoricalClaims.Billing_Provider_Specialty__c = 'Specialty 4';
		HistoricalClaims.Billing_Provider_PIN__c = '1234570';
		HistoricalClaims.Billing_Provider_State__c = 'NY';
		HistoricalClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
		HistoricalClaims.Billing_Provider_Zip_Code__c = '10118';
        HistoricalClaims.Billing_Provider_Phone__c = '3333333333';
        HistoricalClaims.Billing_Provider_Fax__c = '9999999999';
        //HistoricalClaims.Primary_Claim_Number__c = 'E11111111111114';
        //HistoricalClaims.Claim_Code__c = 'Initial Claim';
        HistoricalClaims.Claim_Line__c = '3';
        //HistoricalClaims.Claim_Segment__c = '00';
        HistoricalClaims.COB_Code__c = 'Secondary';
        HistoricalClaims.CSA_Control__c = 'CN0006';
        //HistoricalClaims.Days_Supply__c = 32;
        HistoricalClaims.Diagnosis_Code__c = '12345678989';
        HistoricalClaims.Drug_Label_Name__c = 'Drug Four';
        HistoricalClaims.HCPCS_Code__c = 'J5678';
        //HistoricalClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        HistoricalClaims.NDC__c = '123456792';
        //HistoricalClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        HistoricalClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalClaims.Patient_Email_Address__c = 'lara@test.com';
        HistoricalClaims.Patient_First_Name__c = 'Sam';
        HistoricalClaims.Patient_Last_Name__c = 'William';
        HistoricalClaims.Patient_Middle_Initial__c = 'B';
        HistoricalClaims.Patient_Phone_Number__c = '8888888890';
        HistoricalClaims.Patient_Gender__c = 'Male';
        HistoricalClaims.Plan_Sponsor_Name__c = 'TCS';
        HistoricalClaims.Preferred_Provider__c = 'Preferred';
        HistoricalClaims.Date_Of_Service_From__c = date.valueOf('2024-07-01');
        HistoricalClaims.Service_Provider_Fax__c = '5555555557';
        HistoricalClaims.Service_Provider_Phone__c = '7777777779';
        HistoricalClaims.Date_Of_Service_To__c = date.valueOf('2024-07-02');
        HistoricalClaims.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        HistoricalClaims.Service_Provider_City__c = 'Chicago';
        HistoricalClaims.Service_Provider_First_Name__c = 'Dave';
        HistoricalClaims.Service_Provider_Last_Name__c = 'Dle';
        HistoricalClaims.Service_Provider_NPI__c = '9998887778';
        HistoricalClaims.Service_Provider_Practice__c = 'NONE';
        HistoricalClaims.Service_Provider_Zip__c = '10125';
        HistoricalClaims.Service_Provider_Specialty_Code__c = '3';
        HistoricalClaims.Service_Provider_State__c = 'NY';
        HistoricalClaims.Patient_Address_Line_1__c = '125 Sesame Street';
        HistoricalClaims.Patient_Address_Line_2__c = 'Apt 4';
        HistoricalClaims.Patient_City__c = 'Los Angeles';
        HistoricalClaims.Patient_CUMB_ID__c = 'W12345680';
        HistoricalClaims.Patient_State__c = 'NY';
        HistoricalClaims.Patient_Zip_Code__c = '10153';
        HistoricalClaims.CSA_Suffix__c = 'SN0006';
        HistoricalClaims.Total_Coinsurance__c = 33;
        HistoricalClaims.Total_Copay__c = 72;
        HistoricalClaims.Total_Deductible__c = 502;
        //HistoricalClaims.Previous_Claim__c = '';
        HistoricalClaims.Relationship_Code__c = '01';
        HistoricalClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0006' + 'SN0006' +'AN0006');
        
        insert HistoricalClaims;
        
        Test.startTest();
        List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where CSA_Account__c=: HistoricalClaims.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Contact__c =: conList[0].id ];
        //List<Case> caseList = [SELECT id from Case where Contact_Drug__c=: contactDrug.id ];

        system.assertequals(1,claimList.size());
        //system.assertequals(1,conList.size());
        system.assertequals(1,contactDrugList.size());
        //system.assertequals(1,caseList.size());
         for (Claim_Information__c claim: claimList){
            List<Case> caseList = [SELECT id from Case where Claim_Information__c =: claim.id ];
         system.assertequals(1,caseList.size());}

        Test.stopTest();
        
    }
    
    @isTest
    public static void existingContactDrug(){
        Account accountInstance = new Account(
                Name = 'Test Account'
        
        );
        
    insert accountInstance;  
        
    Drug__c testDrug = new Drug__c();
      testDrug.J_Code__c = 'J0789';
      testDrug.Name='TestDrug';
    testDrug.Coding_Level__c = 'HCPCS';
      insert testDrug;
     
   Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2030-09-17'),
                CSA_Control__c = 'CN0006',
                CSA_Suffix__c = 'SN0006',
                CSA_Account__c = 'AN0006'
        );    
      insert csaInstance;  
        
   Contact con = new Contact();
        con.Patient_First_Name__c= 'Sam';
        con.Patient_Last_Name__c='William';
        con.FirstName = 'Test Contact';
      	con.LastName  = 'Historical';
        con.CSA__c=csaInstance.id;
        
        insert con;
   Contact_Drug__c contactDrug1 = new Contact_Drug__c();
      contactDrug1.Contact__c = con.id;
      insert contactDrug1;
        
    Historical_Claim__c HistoricalClaims = new Historical_Claim__c();
        HistoricalClaims.CSA_Account__c = 'AN0006';
		HistoricalClaims.Units_Billed__c = 2;
		HistoricalClaims.Amount_Paid_By_Primary__c = 103;
		//HistoricalClaims.Prior_Authorization__c = 'A127';
		//HistoricalClaims.Authorized_Representative__c = 'Ras And';
		//HistoricalClaims.Authorized_Relationship__c = '4';
		HistoricalClaims.Billing_Provider_City__c = 'New York City';
		//HistoricalClaims.Billing_Provider_First_Name__c = 'Test';
		//HistoricalClaims.Billing_Provider_Last_Name__c = 'Four';
		//HistoricalClaims.Billing_Provider_Specialty__c = 'Specialty 4';
		HistoricalClaims.Billing_Provider_PIN__c = '1234570';
		HistoricalClaims.Billing_Provider_State__c = 'NY';
		HistoricalClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
		HistoricalClaims.Billing_Provider_Zip_Code__c = '10118';
        HistoricalClaims.Billing_Provider_Phone__c = '3333333333';
        HistoricalClaims.Billing_Provider_Fax__c = '9999999999';
        HistoricalClaims.Primary_Claim_Number__c = 'E11111111111114';
        //HistoricalClaims.Claim_Code__c = 'Initial Claim';
        HistoricalClaims.Claim_Line__c = '3';
        //HistoricalClaims.Claim_Segment__c = '00';
        HistoricalClaims.COB_Code__c = 'Secondary';
        HistoricalClaims.CSA_Control__c = 'CN0006';
        //HistoricalClaims.Days_Supply__c = 32;
        HistoricalClaims.Diagnosis_Code__c = '12345678989';
        HistoricalClaims.Drug_Label_Name__c = 'Drug Four';
        HistoricalClaims.HCPCS_Code__c = 'J0789';
        //HistoricalClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        HistoricalClaims.NDC__c = '123456792';
        //HistoricalClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        HistoricalClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalClaims.Patient_Email_Address__c = 'lara@test.com';
        HistoricalClaims.Patient_First_Name__c = 'Sam';
        HistoricalClaims.Patient_Last_Name__c = 'William';
        HistoricalClaims.Patient_Middle_Initial__c = 'B';
        HistoricalClaims.Patient_Phone_Number__c = '8888888890';
        HistoricalClaims.Patient_Gender__c = 'Male';
        HistoricalClaims.Plan_Sponsor_Name__c = 'TCS';
        HistoricalClaims.Preferred_Provider__c = 'Preferred';
        HistoricalClaims.Date_Of_Service_From__c = date.valueOf('2024-07-01');
        HistoricalClaims.Service_Provider_Fax__c = '5555555557';
        HistoricalClaims.Service_Provider_Phone__c = '7777777779';
        HistoricalClaims.Date_Of_Service_To__c = date.valueOf('2024-07-02');
        HistoricalClaims.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        HistoricalClaims.Service_Provider_City__c = 'Chicago';
        HistoricalClaims.Service_Provider_First_Name__c = 'Dave';
        HistoricalClaims.Service_Provider_Last_Name__c = 'Dle';
        HistoricalClaims.Service_Provider_NPI__c = '9998887778';
        HistoricalClaims.Service_Provider_Practice__c = 'NONE';
        HistoricalClaims.Service_Provider_Zip__c = '10125';
        HistoricalClaims.Service_Provider_Specialty_Code__c = '3';
        HistoricalClaims.Service_Provider_State__c = 'NY';
        HistoricalClaims.Patient_Address_Line_1__c = '125 Sesame Street';
        HistoricalClaims.Patient_Address_Line_2__c = 'Apt 4';
        HistoricalClaims.Patient_City__c = 'Los Angeles';
        HistoricalClaims.Patient_CUMB_ID__c = 'W12345680';
        HistoricalClaims.Patient_State__c = 'NY';
        HistoricalClaims.Patient_Zip_Code__c = '10153';
        HistoricalClaims.CSA_Suffix__c = 'SN0006';
        HistoricalClaims.Total_Coinsurance__c = 33;
        HistoricalClaims.Total_Copay__c = 72;
        HistoricalClaims.Total_Deductible__c = 502;
        //HistoricalClaims.Previous_Claim__c = '';
        HistoricalClaims.Relationship_Code__c = '01';
        HistoricalClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0006' + 'SN0006' +'AN0006');
        
        insert HistoricalClaims;
        
        Test.startTest();
        List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        List<Drug__c> drugList =[SELECT id from Drug__c where J_Code__c =: 'J0789' ];
        List<Contact_Drug__c> contactDrugList = [SELECT id,Drug_Name__c,Contact__c from Contact_Drug__c where Contact__c =: conList[0].id ];
        //List<Case> caseList = [SELECT id from Case where Contact_Drug__c=: contactDrug.id ];
		//List<Contact_Drug__c> contactDrugListNew = [SELECT id,Drug_Name__c from Contact_Drug__c where Drug_Name__c =: drugList[0].id];

        Set<Id>  contactDrugIdSet = new Set<Id>();
        for(Contact_Drug__c conDrug: contactDrugList){
            system.assertEquals(conList[0].id, conDrug.Contact__c);
            system.assertEquals(drugList[0].id, conDrug.Drug_Name__c);
            contactDrugIdSet.add(conDrug.Id);
        }

        system.assertequals(1,contactDrugList.size());
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where Contact_Drug__c IN :contactDrugIdSet];
        system.assertequals(1,claimList.size());
        //system.assertequals(1,caseList.size());
        Set<Id>  claimIdSet = new Set<Id>();
        for (Claim_Information__c claim: claimList) {
            claimIdSet.add(claim.Id);
        }
        List<Case> caseList = [SELECT Id FROM Case WHERE Contact_Drug__c IN :contactDrugIdSet];
        system.assertequals(1,caseList.size());

        Test.stopTest();
        
    
    
    }
    @isTest(SeeAllData=false)
    public static void HistoricalClaimCreateNewClaimRecord(){
        Test.startTest();
        //Create new Account for Historical Claim
        Account accountInstance = new Account(
                Name = 'Test Account',
                AccountNumber = 'Acc001',
            	AccountSource = 'Website',
            	Control_Number__c = '900994',
            	Go_Live_Date__c = System.today() + 30,
            	Type = 'Customer'        
        );
        
    	insert accountInstance;  
        
        //Create a new Drug Record
        Drug__c testDrug = new Drug__c(
            J_Code__c = 'J1234',
            Active_CPA__c = true,
            Drug_Brand_Name__c = 'MVASI',
            Drug_Generic_Name__c = 'Devacizumab-Awwb 900mg Injection',
            Name = 'Devacizumab-Awwb 900mg Injection',
            Coding_Level__c = 'HCPCS + NDC'
            //NDC__c = '123456791'
        );
        insert testDrug;

        NDC__c testNDC = new NDC__c(Drug__c = testDrug.Id, Name = '123456791');
        insert testNDC;
     
   		//Create a new CSA record with a Pre Go Live Date 
   		Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = System.today() + 30,
                CSA_Control__c = '900994',
                CSA_Suffix__c = '34',
                CSA_Account__c = '18',
            	CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('18' + '900994' + '34')
        );    
      insert csaInstance; 
        
        Historical_Claim__c HistoricalClaimInstance = new Historical_Claim__c(
            //Prudent_In_Data_Staging_ID__c = '09032021411710',
            NDC__c = '123456791',
            HCPCS_Code__c = 'J1234',
            //Patient_CUMB_ID__c = '123',
            CSA_Control__c = '900994',
            CSA_Suffix__c = '34',
            CSA_Account__c = '18',
            CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('900994' + '34' +'18'),
            Patient_Birth_Date__c = date.valueOf('1998-01-01'),
        	//Patient_Email_Address__c = 'jsmith@test.com',
        	Patient_First_Name__c = 'Joe',
        	Patient_Last_Name__c = 'Smith',
        	Patient_Middle_Initial__c = 'H',
            Primary_Claim_Number__c = 'E11111111111119',
            //Claim_Code__c = 'Initial Claim',
            Claim_Line__c = '1',
            //Claim_Segment__c = '01',
            COB_Code__c = 'Secondary',
            //Days_Supply__c = 30,
            Diagnosis_Code__c = '12345678986',
            Drug_Label_Name__c = 'Drug One',
            //PA_Approval_Dates__c = date.valueOf('2021-07-01'),
            Plan_Sponsor_Name__c = 'Sample Company',
            Preferred_Provider__c = 'Preferred',
            Date_Of_Service_From__c = date.valueOf('2021-07-01'),
            Service_Provider_Fax__c = '5555555555',
            Service_Provider_Phone__c = '7777777777',
            Date_Of_Service_To__c = date.valueOf('2021-07-02'),
            Service_Provider_Address_Line_1__c = '456 plane Lane',
            Service_Provider_City__c = 'Chicago',
            Service_Provider_First_Name__c = 'Jane',
            Service_Provider_Last_Name__c = 'Doe',
            Service_Provider_NPI__c = '9998887776',
            Service_Provider_Practice__c = 'NONE',
            Service_Provider_Zip__c = '10123',
            Service_Provider_State__c = 'NY',
            Patient_Address_Line_1__c = '123 Sesame Street',
            Patient_Address_Line_2__c = '0',
            Patient_City__c = 'Los Angeles',
            Patient_CUMB_ID__c = 'W12345678',
            Patient_State__c = 'NY',
            Patient_Zip_Code__c = '10151',
            Total_Coinsurance__c = 30,
            Total_Copay__c = 30,
            Total_Deductible__c = 500,
            //Previous_Claim__c = '',
            Relationship_Code__c = '01'
        );
        insert HistoricalClaimInstance;
      
       //Create a new Contact record
       Contact con = new Contact();
            con.Patient_First_Name__c= 'Jeff';
            con.Patient_Last_Name__c='Smith';
            con.Patient_Birth_Date__c = date.valueof('1998-01-01');
            con.FirstName = 'Jeff';
            con.LastName  = 'Smith';
            con.Email = 'jeff@test.com';
            con.MobilePhone = '2513336565';
            //con.Person_Code__c = '01';
            con.AccountId = accountInstance.Id;
            con.CSA__c=csaInstance.id;        
            insert con;
            
        //Create a new Contact Drug record   
        Contact_Drug__c contactDrug1 = new Contact_Drug__c();
        contactDrug1.Contact__c=con.id;
        contactDrug1.Drug_Name__c= testDrug.id;
        insert contactDrug1;
        
        /*
        Claim_Information__c claims = new Claim_Information__c();
        claims.Claim_Number__c='E11111111111119';
        claims.Primary_Claim_Number__c = 'E11111111111119';
        claims.Prior_Authorization__c='B123'; 
        claims.Amount_Paid_By_Primary__c = 200; 
        claims.CSA_Suffix__c = '34';
        claims.CSA_Control__c = '900994';
        claims.CSA_Account__c = '18';
        claims.Drug__c = testDrug.Id;
        //claims.Drug__c= testDrug.id;  
        insert claims;
		*/
        
    	String json = '[{"prudentInDataStagingId": "09032021411710","Account_Number": "18", "Adjudicated_NDC_Units_Count": "2","Allowable_Amount": "100.65", "Authorization_Number": "A131", "Authorized_Representative": "Jeff Smith", "Authorized_Representative_Relationship": "9", "Billing_Provider_City": "New York City", "Billing_Provider_First_Name": "Test", "Billing_Provider_Last_Name": "Nine", "Billing_Provider_Specialty": "Specialty 9", "Billing_Provider_PIN": "1234575", "Billing_Provider_State_Code": "NY", "Billing_Provider_Street_Address_Line_1": "463 Test Lane", "Billing_Provider_Zip_Code": "10122", "Billing_Provider_Phone": "3333333333", "Billing_Provider_Fax": "9999999999", "Claim_Identifier": "E11111111111119", "Claim_Indicator": "Initial Claim", "Claim_Line_Identifier": "2", "Claim_Segment": "01", "COB_indicator": "Secondary", "Control_Number": "900994", "Days_Supply": "38", "Diagnosis_Code": "12345678986", "Drug_Label_Name": "Drug One", "ICD9_Procedure_Code": "J1234", "National_Drug_Code": "123456791", "PA_Approval_Dates": "11012025", "Patient_Birth_Date": "01011998", "Patient_Email_Address": "jeff@test.com", "Patient_First_Name": "jeff ", "Patient_Last_Name": "Smith", "Patient_Middle_Initial": "H", "Patient_Phone_Number": "8888888896", "Patient_Sex": "M", "Policy_Holder_Name": "Centene", "Previous_Segment_Pointer": "null", "Provider_Indicator": "Preferred", "Service_From_Date": "07012029", "Service_Provider_Fax": "5555555563", "Service_Provider_Phone": "7777777784", "Service_To_Date": "07022030", "Servicing_Provider_Address_Line_1": "464 Plane Lane", "Servicing_Provider_City": "Chicago", "Servicing_Provider_First_Name": "Jim", "Servicing_Provider_Last_Name": "Will", "Servicing_Provider_National_Provider_Identifier": "9998887784", "Servicing_Provider_Practice_Role_Name": "NONE", "Servicing_Provider_Service_Location_Zip_Code": "10131", "Servicing_Provider_Specialty_Code": "8", "Servicing_Provider_State_Code": "NY", "Subscriber_Address_Line_1": "131 Sesame Street", "Subscriber_Address_Line_2": "null", "Subscriber_City": "Los Angeles", "Subscriber_CUMB_ID": "W12345686", "Subscriber_State_Code": "NY", "Subscriber_Zip_Code": "10158", "Suffix_Number": "34", "Total_Coinsurance_Amount": "38.64", "Total_Copay_Amount": "67.65", "Total_Deductible_Amount": "507.94", "Original_UCK_ID": "null", "Person_Relationship_Code": "01", "File_Upsert": "Historical Claims" }]';
        RestRequest req = new RestRequest();
        RestResponse res= new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod='POST';
        req.requestBody= Blob.valueOf(json);
        RestContext.request = req;
        
        //String jsonResponse = PrudentRestAPIResource.doPost();
        //List<RestAPI_JSONResponse> resList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(jsonResponse ,List<RestAPI_JSONResponse>.class);
        
        //System.debug('The API Response for Historical Claims is: '+resList.get(0).status);
        //System.assertEquals('Success',resList.get(0).status);
        
        List<Historical_Claim__c> HC = [SELECT Id,Status__c,Error_Log__c,HCPCS_Code__c,Primary_Claim_Number__c from Historical_Claim__c where HCPCS_Code__c = 'J1234' LIMIT 1];
        System.debug('The Historical Claims records created are: '+HC.size());
        
        if(HC != null && HC.size() > 0){
            System.debug('The Status value on the Historical Claim record is: '+HC[0].Status__c);
            System.debug('The Error Log value on the Historical Claim record is: '+HC[0].Error_Log__c);
            System.debug('The HCPCS Code or J Code value on Historical Claim is: '+HC[0].HCPCS_Code__c);
            System.debug('The Primary_Claim_Number value on Historical Claim is: '+HC[0].Primary_Claim_Number__c);
            System.assertEquals(null, HC[0].Error_Log__c);
            System.assertEquals(null, HC[0].Status__c);
            List<Contact> LstContact = new List<Contact>([SELECT Id,Name,FirstName,LastName from Contact where Patient_First_Name__c = 'Jeff']);
            System.debug('The list of contact records retrieved are: '+LstContact);
            if(LstContact.size() > 0){
                System.assertEquals(1,LstContact.size());
            }
            List<Claim_Information__c> LstClaimInfo = new List<Claim_Information__c>([SELECT Id,Name,Claim_Segment__c,Previous_Segment__c,Claim_Line__c,Previous_Claim__c from Claim_Information__c where Primary_Claim_Number__c = 'E11111111111119']);
            System.debug('The newly created Claim Information record is: '+LstClaimInfo);
            //System.debug('The J Code value is: '+LstClaimInfo[0].J_Code__c);
            System.debug('The Previous Claim value is: '+LstClaimInfo[0].Previous_Claim__c);
            //System.debug('The Claim Segment value is: '+LstClaimInfo[0].Claim_Segment__c);
            System.debug('The Previous Claim Segment value is: '+LstClaimInfo[0].Previous_Segment__c);
            System.debug('The Claim Line value is: '+LstClaimInfo[0].Claim_Line__c);
            System.assertEquals(1,LstClaimInfo.size());
            //System.assertEquals('J1234',LstClaimInfo[0].J_Code__c);
        }
        
        Test.stopTest();
    }
    
    @isTest(SeeAllData=false)
    public static void HistoricalClaimUpdateExistingClaimRecord(){
        Test.startTest();
        //Create new Account for Historical Claim
        Account accountInstance = new Account(
                Name = 'Test Account',
                AccountNumber = 'Acc001',
            	AccountSource = 'Website',
            	Control_Number__c = '900994',
            	Go_Live_Date__c = System.today() + 30,
            	Type = 'Customer'        
        );
        
    	insert accountInstance;  
        
        //Create a new Drug Record
        Drug__c testDrug = new Drug__c(
            J_Code__c = 'J1234',
            Active_CPA__c = true,
            Drug_Brand_Name__c = 'MVASI',
            Drug_Generic_Name__c = 'Devacizumab-Awwb 900mg Injection',
            Name = 'Devacizumab-Awwb 900mg Injection',
            Coding_Level__c = 'HCPCS + NDC'
            //NDC__c = '123456791'
        );
        insert testDrug;

        NDC__c testNDC = new NDC__c(Drug__c = testDrug.Id, Name = '123456791');
        insert testNDC;
     
   		//Create a new CSA record with a Pre Go Live Date 
   		Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = System.today() + 30,
                CSA_Control__c = '900994',
                CSA_Suffix__c = '34',
                CSA_Account__c = '18',
            	CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('18' + '900994' + '34')
        );    
      insert csaInstance; 

       //Create a new Contact record
       Contact con = new Contact();
            con.Patient_First_Name__c= 'Jeff';
            con.Patient_Last_Name__c='Smith';
            con.Patient_Birth_Date__c = date.valueof('1998-01-01');
            con.FirstName = 'Jeff';
            con.LastName  = 'Smith';
            con.Email = 'jeff@test.com';
            con.MobilePhone = '2513336565';
            //con.Person_Code__c = '01';
            con.AccountId = accountInstance.Id;
            con.CSA__c=csaInstance.id;        
            insert con;
            
        //Create a new Contact Drug record   
        Contact_Drug__c contactDrug1 = new Contact_Drug__c();
        contactDrug1.Contact__c=con.id;
        contactDrug1.Drug_Name__c= testDrug.id;
        insert contactDrug1;
        
        
        Claim_Information__c claims = new Claim_Information__c();
        claims.Claim_Number__c='E11111111111119';
        claims.Primary_Claim_Number__c = 'E11111111111119';
        claims.Prior_Authorization__c='B123'; 
        claims.Amount_Paid_By_Primary__c = 200; 
        claims.CSA_Suffix__c = '34';
        claims.CSA_Control__c = '900994';
        claims.CSA_Account__c = '18';
        claims.Drug__c = testDrug.Id;
        claims.Previous_Claim__c= '01';
        claims.Claim_Line__c = '01';
        claims.Previous_Segment__c = '01';
        //claims.Claim_Segment__c = '01';
//        insert claims;
		
        Historical_Claim__c HistoricalClaimInstance = new Historical_Claim__c(
            //Prudent_In_Data_Staging_ID__c = '09032021411710',
            NDC__c = '123456791',
            HCPCS_Code__c = 'J1234',
            //Patient_CUMB_ID__c = '123',
            CSA_Control__c = '900994',
            CSA_Suffix__c = '34',
            CSA_Account__c = '18',
            CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('900994' + '34' +'18'),
            Patient_Birth_Date__c = date.valueOf('1998-01-01'),
        	//Patient_Email_Address__c = 'jsmith@test.com',
        	Patient_First_Name__c = 'Joe',
        	Patient_Last_Name__c = 'Smith',
        	Patient_Middle_Initial__c = 'H',
            Primary_Claim_Number__c = 'E11111111111119',
            //Claim_Code__c = 'Initial Claim',
            Claim_Line__c = '01',
            //Claim_Segment__c = '01',
            COB_Code__c = 'Secondary',
            //Days_Supply__c = 30,
            Diagnosis_Code__c = '12345678986',
            Drug_Label_Name__c = 'Drug One',
            //PA_Approval_Dates__c = date.valueOf('2021-07-01'),
            Plan_Sponsor_Name__c = 'Sample Company',
            Preferred_Provider__c = 'Preferred',
            Date_Of_Service_From__c = date.valueOf('2021-07-01'),
            Service_Provider_Fax__c = '5555555555',
            Service_Provider_Phone__c = '7777777777',
            Date_Of_Service_To__c = date.valueOf('2021-07-02'),
            Service_Provider_Address_Line_1__c = '456 plane Lane',
            Service_Provider_City__c = 'Chicago',
            Service_Provider_First_Name__c = 'Jane',
            Service_Provider_Last_Name__c = 'Doe',
            Service_Provider_NPI__c = '9998887776',
            Service_Provider_Practice__c = 'NONE',
            Service_Provider_Zip__c = '10123',
            Service_Provider_State__c = 'NY',
            Patient_Address_Line_1__c = '123 Sesame Street',
            Patient_Address_Line_2__c = '0',
            Patient_City__c = 'Los Angeles',
            Patient_CUMB_ID__c = 'W12345678',
            Patient_State__c = 'NY',
            Patient_Zip_Code__c = '10151',
            Total_Coinsurance__c = 30,
            Total_Copay__c = 30,
            Total_Deductible__c = 500,
            //Previous_Claim__c = '01',
            Relationship_Code__c = '01'
        );
        insert HistoricalClaimInstance;
        
    	String json = '[{"prudentInDataStagingId": "09032021411710","Account_Number": "18", "Adjudicated_NDC_Units_Count": "2","Allowable_Amount": "100.65", "Authorization_Number": "A131", "Authorized_Representative": "Jeff Smith", "Authorized_Representative_Relationship": "9", "Billing_Provider_City": "New York City", "Billing_Provider_First_Name": "Test", "Billing_Provider_Last_Name": "Nine", "Billing_Provider_Specialty": "Specialty 9", "Billing_Provider_PIN": "1234575", "Billing_Provider_State_Code": "NY", "Billing_Provider_Street_Address_Line_1": "463 Test Lane", "Billing_Provider_Zip_Code": "10122", "Billing_Provider_Phone": "3333333333", "Billing_Provider_Fax": "9999999999", "Claim_Identifier": "E11111111111119", "Claim_Indicator": "Initial Claim", "Claim_Line_Identifier": "2", "Claim_Segment": "01", "COB_indicator": "Secondary", "Control_Number": "900994", "Days_Supply": "38", "Diagnosis_Code": "12345678986", "Drug_Label_Name": "Drug One", "ICD9_Procedure_Code": "J1234", "National_Drug_Code": "123456791", "PA_Approval_Dates": "11012025", "Patient_Birth_Date": "01011998", "Patient_Email_Address": "jeff@test.com", "Patient_First_Name": "jeff ", "Patient_Last_Name": "Smith", "Patient_Middle_Initial": "H", "Patient_Phone_Number": "8888888896", "Patient_Sex": "M", "Policy_Holder_Name": "Centene", "Previous_Segment_Pointer": "null", "Provider_Indicator": "Preferred", "Service_From_Date": "07012029", "Service_Provider_Fax": "5555555563", "Service_Provider_Phone": "7777777784", "Service_To_Date": "07022030", "Servicing_Provider_Address_Line_1": "464 Plane Lane", "Servicing_Provider_City": "Chicago", "Servicing_Provider_First_Name": "Jim", "Servicing_Provider_Last_Name": "Will", "Servicing_Provider_National_Provider_Identifier": "9998887784", "Servicing_Provider_Practice_Role_Name": "NONE", "Servicing_Provider_Service_Location_Zip_Code": "10131", "Servicing_Provider_Specialty_Code": "8", "Servicing_Provider_State_Code": "NY", "Subscriber_Address_Line_1": "131 Sesame Street", "Subscriber_Address_Line_2": "null", "Subscriber_City": "Los Angeles", "Subscriber_CUMB_ID": "W12345686", "Subscriber_State_Code": "NY", "Subscriber_Zip_Code": "10158", "Suffix_Number": "34", "Total_Coinsurance_Amount": "38.64", "Total_Copay_Amount": "67.65", "Total_Deductible_Amount": "507.94", "Original_UCK_ID": "null", "Person_Relationship_Code": "01", "File_Upsert": "Historical Claims" }]';
        RestRequest req = new RestRequest();
        RestResponse res= new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod='POST';
        req.requestBody= Blob.valueOf(json);
        RestContext.request = req;
        
        //String jsonResponse = PrudentRestAPIResource.doPost();
        //List<RestAPI_JSONResponse> resList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(jsonResponse ,List<RestAPI_JSONResponse>.class);
        
        //System.debug('The API Response for Historical Claims is: '+resList.get(0).status);
        //System.assertEquals('Success',resList.get(0).status);
        
        List<Historical_Claim__c> HC = [SELECT Id,Status__c,Error_Log__c,HCPCS_Code__c,Primary_Claim_Number__c from Historical_Claim__c where NDC__c = '1234567' LIMIT 1];
        System.debug('The Historical Claims records created are: '+HC.size());
        
        if(HC != null && HC.size() > 0){
            System.debug('The Status value on the Historical Claim record is: '+HC[0].Status__c);
            System.debug('The Error Log value on the Historical Claim record is: '+HC[0].Error_Log__c);
            System.debug('The HCPCS Code or J Code value on Historical Claim is: '+HC[0].Primary_Claim_Number__c);
            System.assertEquals(null, HC[0].Error_Log__c);
            System.assertEquals(null, HC[0].Status__c);
            List<Contact> LstContact = new List<Contact>([SELECT Id,Name,FirstName,LastName from Contact where Patient_First_Name__c = 'Jeff']);
            System.debug('The list of contact records retrieved are: '+LstContact);
            if(LstContact.size() > 0){
                System.assertEquals(1,LstContact.size());
            }
            List<Claim_Information__c> LstClaimInfo = new List<Claim_Information__c>([SELECT Id,Name,Claim_Segment__c,Previous_Segment__c,Claim_Line__c from Claim_Information__c where Primary_Claim_Number__c = 'E11111111111119']);
            System.debug('The newly created Claim Information record is: '+LstClaimInfo);
            //System.debug('The J Code value is: '+LstClaimInfo[0].J_Code__c);
            System.debug('The Previous Claim value is: '+LstClaimInfo[0].Previous_Claim__c);
            System.debug('The Claim Segment value is: '+LstClaimInfo[0].Claim_Segment__c);
            System.debug('The Previous Claim Segment value is: '+LstClaimInfo[0].Previous_Segment__c);
            System.debug('The Claim Line value is: '+LstClaimInfo[0].Claim_Line__c);
            System.assertEquals(1,LstClaimInfo.size());
            //System.assertEquals('J1234',LstClaimInfo[0].J_Code__c);
            System.debug('The Claim Information Id of the newly created Claim Information record is: '+LstClaimInfo[0].Id);
            
            if(LstClaimInfo[0].Id != null){
                List<Case> LstCaseRecords = new List<Case>([SELECT Id,AccountId,ContactId,CaseNumber,Reason,Claim_Information__c,Claim_Number__c,RecordType.Name from Case where Claim_Information__c =:LstClaimInfo[0].Id]);
                System.debug('The newly created Case record is: '+LstCaseRecords);
            }
            
        }
        Test.stopTest();
        
    }

    @isTest(SeeAllData=false)
    public static void historicalClaimMostRecentClaimonCaseRecord(){
        Test.startTest();
        //Create new Account for Historical Claim
        Account accountInstance = new Account(
                Name = 'Test Account',
                AccountNumber = 'Acc001',
                AccountSource = 'Website',
                Control_Number__c = '900994',
                Go_Live_Date__c = System.today() + 30,
                Type = 'Customer'
        );

        insert accountInstance;

        //Create a new Drug Record
        Drug__c testDrug = new Drug__c(
                J_Code__c = 'J1234',
                Active_CPA__c = true,
                Drug_Brand_Name__c = 'MVASI',
                Drug_Generic_Name__c = 'Devacizumab-Awwb 900mg Injection',
                Name = 'Devacizumab-Awwb 900mg Injection',
                Coding_Level__c = 'HCPCS + NDC'
                //NDC__c = '123456791'
        );
        insert testDrug;

        NDC__c testNDC = new NDC__c(Drug__c = testDrug.Id, Name = '123456791');
        insert testNDC;

        //Create a new CSA record with a Pre Go Live Date
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = System.today() + 30,
                CSA_Control__c = '900994',
                CSA_Suffix__c = '34',
                CSA_Account__c = '18',
                CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('18' + '900994' + '34')
        );
        insert csaInstance;

        Historical_Claim__c HistoricalClaimInstance = new Historical_Claim__c(
                //Prudent_In_Data_Staging_ID__c = '09032021411710',
                NDC__c = '123456791',
                HCPCS_Code__c = 'J1234',
                //Patient_CUMB_ID__c = '123',
                CSA_Control__c = '900994',
                CSA_Suffix__c = '34',
                CSA_Account__c = '18',
                CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('900994' + '34' +'18'),
                Patient_Birth_Date__c = date.valueOf('1998-01-01'),
                //Patient_Email_Address__c = 'jsmith@test.com',
                Patient_First_Name__c = 'Joe',
                Patient_Last_Name__c = 'Smith',
                Patient_Middle_Initial__c = 'H',
                Primary_Claim_Number__c = 'E11111111111119',
                //Claim_Code__c = 'Initial Claim',
                Claim_Line__c = '1',
                //Claim_Segment__c = '01',
                COB_Code__c = 'Secondary',
                //Days_Supply__c = 30,
                Diagnosis_Code__c = '12345678986',
                Drug_Label_Name__c = 'Drug One',
                //PA_Approval_Dates__c = date.valueOf('2021-07-01'),
                Plan_Sponsor_Name__c = 'Sample Company',
                Preferred_Provider__c = 'Preferred',
                Date_Of_Service_From__c = date.valueOf('2021-07-01'),
                Service_Provider_Fax__c = '5555555555',
                Service_Provider_Phone__c = '7777777777',
                Date_Of_Service_To__c = date.valueOf('2021-07-02'),
                Service_Provider_Address_Line_1__c = '456 plane Lane',
                Service_Provider_City__c = 'Chicago',
                Service_Provider_First_Name__c = 'Jane',
                Service_Provider_Last_Name__c = 'Doe',
                Service_Provider_NPI__c = '9998887776',
                Service_Provider_Practice__c = 'NONE',
                Service_Provider_Zip__c = '10123',
                Service_Provider_State__c = 'NY',
                Patient_Address_Line_1__c = '123 Sesame Street',
                Patient_Address_Line_2__c = '0',
                Patient_City__c = 'Los Angeles',
                Patient_CUMB_ID__c = 'W12345678',
                Patient_State__c = 'NY',
                Patient_Zip_Code__c = '10151',
                Total_Coinsurance__c = 30,
                Total_Copay__c = 30,
                Total_Deductible__c = 500,
                //Previous_Claim__c = '',
                Relationship_Code__c = '01'
        );
        insert HistoricalClaimInstance;

        //Create a new Contact record
        Contact con = new Contact();
        con.Patient_First_Name__c= 'Jeff';
        con.Patient_Last_Name__c='Smith';
        con.Patient_Birth_Date__c = date.valueof('1998-01-01');
        con.FirstName = 'Jeff';
        con.LastName  = 'Smith';
        con.Email = 'jeff@test.com';
        con.MobilePhone = '2513336565';
        //con.Person_Code__c = '01';
        con.AccountId = accountInstance.Id;
        con.CSA__c=csaInstance.id;
        insert con;

        //Create a new Contact Drug record
        Contact_Drug__c contactDrug1 = new Contact_Drug__c();
        contactDrug1.Contact__c=con.id;
        contactDrug1.Drug_Name__c= testDrug.id;
        insert contactDrug1;

        /*
        Claim_Information__c claims = new Claim_Information__c();
        claims.Claim_Number__c='E11111111111119';
        claims.Primary_Claim_Number__c = 'E11111111111119';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        claims.CSA_Suffix__c = '34';
        claims.CSA_Control__c = '900994';
        claims.CSA_Account__c = '18';
        claims.Drug__c = testDrug.Id;
        //claims.Drug__c= testDrug.id;
        insert claims;
		*/

        String json = '[{"prudentInDataStagingId": "09032021411710","Account_Number": "18", "Adjudicated_NDC_Units_Count": "2","Allowable_Amount": "100.65", "Authorization_Number": "A131", "Authorized_Representative": "Jeff Smith", "Authorized_Representative_Relationship": "9", "Billing_Provider_City": "New York City", "Billing_Provider_First_Name": "Test", "Billing_Provider_Last_Name": "Nine", "Billing_Provider_Specialty": "Specialty 9", "Billing_Provider_PIN": "1234575", "Billing_Provider_State_Code": "NY", "Billing_Provider_Street_Address_Line_1": "463 Test Lane", "Billing_Provider_Zip_Code": "10122", "Billing_Provider_Phone": "3333333333", "Billing_Provider_Fax": "9999999999", "Claim_Identifier": "E11111111111119", "Claim_Indicator": "Initial Claim", "Claim_Line_Identifier": "2", "Claim_Segment": "01", "COB_indicator": "Secondary", "Control_Number": "900994", "Days_Supply": "38", "Diagnosis_Code": "12345678986", "Drug_Label_Name": "Drug One", "ICD9_Procedure_Code": "J1234", "National_Drug_Code": "123456791", "PA_Approval_Dates": "11012025", "Patient_Birth_Date": "01011998", "Patient_Email_Address": "jeff@test.com", "Patient_First_Name": "jeff ", "Patient_Last_Name": "Smith", "Patient_Middle_Initial": "H", "Patient_Phone_Number": "8888888896", "Patient_Sex": "M", "Policy_Holder_Name": "Centene", "Previous_Segment_Pointer": "null", "Provider_Indicator": "Preferred", "Service_From_Date": "07012029", "Service_Provider_Fax": "5555555563", "Service_Provider_Phone": "7777777784", "Service_To_Date": "07022030", "Servicing_Provider_Address_Line_1": "464 Plane Lane", "Servicing_Provider_City": "Chicago", "Servicing_Provider_First_Name": "Jim", "Servicing_Provider_Last_Name": "Will", "Servicing_Provider_National_Provider_Identifier": "9998887784", "Servicing_Provider_Practice_Role_Name": "NONE", "Servicing_Provider_Service_Location_Zip_Code": "10131", "Servicing_Provider_Specialty_Code": "8", "Servicing_Provider_State_Code": "NY", "Subscriber_Address_Line_1": "131 Sesame Street", "Subscriber_Address_Line_2": "null", "Subscriber_City": "Los Angeles", "Subscriber_CUMB_ID": "W12345686", "Subscriber_State_Code": "NY", "Subscriber_Zip_Code": "10158", "Suffix_Number": "34", "Total_Coinsurance_Amount": "38.64", "Total_Copay_Amount": "67.65", "Total_Deductible_Amount": "507.94", "Original_UCK_ID": "null", "Person_Relationship_Code": "01", "File_Upsert": "Historical Claims" }]';
        RestRequest req = new RestRequest();
        RestResponse res= new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod='POST';
        req.requestBody= Blob.valueOf(json);
        RestContext.request = req;

        //String jsonResponse = PrudentRestAPIResource.doPost();
        //List<RestAPI_JSONResponse> resList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(jsonResponse ,List<RestAPI_JSONResponse>.class);

        //System.debug('The API Response for Historical Claims is: '+resList.get(0).status);
        //System.assertEquals('Success',resList.get(0).status);

        List<Historical_Claim__c> HC = [SELECT Id,Status__c,Error_Log__c,HCPCS_Code__c,Primary_Claim_Number__c from Historical_Claim__c where HCPCS_Code__c = 'J1234' LIMIT 1];
        System.debug('The Historical Claims records created are: '+HC.size());

        if(HC != null && HC.size() > 0){
            System.debug('The Status value on the Historical Claim record is: '+HC[0].Status__c);
            System.debug('The Error Log value on the Historical Claim record is: '+HC[0].Error_Log__c);
            System.debug('The HCPCS Code or J Code value on Historical Claim is: '+HC[0].Primary_Claim_Number__c);
            System.assertEquals(null, HC[0].Error_Log__c);
            System.assertEquals(null, HC[0].Status__c);
            List<Contact> LstContact = new List<Contact>([SELECT Id,Name,FirstName,LastName from Contact where Patient_First_Name__c = 'Jeff']);
            System.debug('The list of contact records retrieved are: '+LstContact);
            if(LstContact.size() > 0){
                System.assertEquals(1,LstContact.size());
            }
            List<Claim_Information__c> LstClaimInfo = new List<Claim_Information__c>([SELECT Id,Name,Claim_Segment__c,Previous_Segment__c,Claim_Line__c,Previous_Claim__c from Claim_Information__c where Primary_Claim_Number__c = 'E11111111111119']);
            System.debug('The newly created Claim Information record is: '+LstClaimInfo);
            //System.debug('The J Code value is: '+LstClaimInfo[0].J_Code__c);
            System.debug('The Previous Claim value is: '+LstClaimInfo[0].Previous_Claim__c);
            //System.debug('The Claim Segment value is: '+LstClaimInfo[0].Claim_Segment__c);
            System.debug('The Previous Claim Segment value is: '+LstClaimInfo[0].Previous_Segment__c);
            System.debug('The Claim Line value is: '+LstClaimInfo[0].Claim_Line__c);
            System.assertEquals(1,LstClaimInfo.size());
            //System.assertEquals('J1234',LstClaimInfo[0].J_Code__c);
        }

        Test.stopTest();
    }
}