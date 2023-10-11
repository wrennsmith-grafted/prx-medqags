/**
 * @description       : Test Daily Claims Domain
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
private class Daily_ClaimsTest {

    private static Implementation__c implementationInstance;
    private static Contract contractInstance;
    private static Account accountInstance;
    private static CSA__c csaInstance;
    private static Datetime mbrFollowupTime;
    private static List<Case> followUpCaseList = new List<Case>();

    private static void dailyClaimsTestSetup(Boolean preGoLive, Boolean allowCaseRouting, Boolean allowMBROutreach) {
        system.debug('caseRoutingTestSetup');

        List<Drug__c> testDrugList = new List<Drug__c>();
        List<CSA__c> csaList = new List<CSA__c>();
        Date goLiveDate;

        if(preGoLive) {
            goLiveDate = date.today().addDays(20);
        } else {
            goLiveDate = date.today().addDays(-60);
        }

        system.debug('Setup Accounts');
        accountInstance = new Account(
                Name = 'Model Office Test-Integration',
                Medical_Drug_List__c = 'PRUDENTMED',
                Go_Live_Date__c = goLiveDate
                //Allow_Case_Routing__c = allowCaseRouting,
                //Allow_MBR_Outreach__c = allowMBROutreach
        );
        insert accountInstance;

        system.debug('Setup Contracts');
        contractInstance = new Contract(
                Name = 'Model Office Test-Integration Contract',
                Go_Live_Date__c = goLiveDate,
                AccountId = accountInstance.Id
        );
        insert contractInstance;

        system.debug('Setup Implementation__c');
        implementationInstance =  new Implementation__c(
                Account__c = accountInstance.Id,
                Contract__c = contractInstance.Id
        );
        insert implementationInstance;

        system.debug('Setup Drugs');
        Drug__c testDrug = new Drug__c(
                J_Code__c = 'J9023',
                Coding_Level__c = 'HCPCS',
                Name = 'BAVENCIO',
                Therapy_Class__c = 'ONCOLOGY',
                PRx_Program_Description__c = 'Non-Essential',
                Pronunciation__c = 'bah-VEN-see-oh',
                Annual_Max__c = 300000.00,
                Reimbursement_Vehicle__c = 'False debit card',
                Member_Minimum_Per_Claim__c = 0,
                PRx_Website__c = 'https://www.coverone.com/en/Co-Pay_Assistance.html',
                Program_Fax__c = '1-800-214-7295',
                PRx_Help_Line_Number__c = '1-844-826-8371',
                PRx_Enrollment_Process__c = 'HCP and member fax CoverOne Enrollment Form to 1-800-214-7295. If using renal : use combination form. All other indications use single agent form.',
                Re_Imbursement_Deadline__c = '180',
                Re_Enrollment_Date_Eligibility__c = '12 Months',
                When_Re_Enrollment_Action_Is_Needed__c = '12 Months'

        );
        testDrugList.add(testDrug);

        testDrug = new Drug__c(
                J_Code__c = 'J9035',
                Name = 'AVASTIN',
                Therapy_Class__c = 'ONCOLOGY',
                PRx_Program_Description__c = 'Non-Essential',
                Pronunciation__c = 'uh-VAH-stin',
                Copay_Assistance_Available__c = 'No',
                Annual_Max__c = 0.00,
                //Reimbursement_Vehicle__c = 'False debit card',
                Member_Minimum_Per_Claim__c = 0
                //PRx_Website__c = 'https://www.coverone.com/en/Co-Pay_Assistance.html',
                //Program_Fax__c = '1-800-214-7295',
                //PRx_Help_Line_Number__c = '1-844-826-8371',
                //PRx_Enrollment_Process__c = 'HCP and member fax CoverOne Enrollment Form to 1-800-214-7295. If using renal : use combination form. All other indications use single agent form.',
                //Re_Imbursement_Deadline__c = '180',
                //Re_Enrollment_Date_Eligibility__c = '12 Months',
                //When_Re_Enrollment_Action_Is_Needed__c = '12 Months'

        );
        testDrugList.add(testDrug);

        testDrug = new Drug__c(
                J_Code__c = 'J0179',
                Name = 'BEOVU',
                Therapy_Class__c = 'OCULAR DISORDERS',
                PRx_Program_Description__c = 'Non-Essential',
                Pronunciation__c = 'Bay-u',
                Copay_Assistance_Available__c = 'No',
                Annual_Max__c = 0.00,
                //Reimbursement_Vehicle__c = 'False debit card',
                Member_Minimum_Per_Claim__c = 0
                //PRx_Website__c = 'https://www.coverone.com/en/Co-Pay_Assistance.html',
                //Program_Fax__c = '1-800-214-7295',
                //PRx_Help_Line_Number__c = '1-844-826-8371',
                //PRx_Enrollment_Process__c = 'HCP and member fax CoverOne Enrollment Form to 1-800-214-7295. If using renal : use combination form. All other indications use single agent form.',
                //Re_Imbursement_Deadline__c = '180',
                //Re_Enrollment_Date_Eligibility__c = '12 Months',
                //When_Re_Enrollment_Action_Is_Needed__c = '12 Months'

        );
        testDrugList.add(testDrug);

        testDrug = new Drug__c(
                J_Code__c = 'J0178',
                Name = 'EYLEA',
                Therapy_Class__c = 'OCULAR DISORDERS',
                PRx_Program_Description__c = 'Non-Essential',
                Pronunciation__c = 'eye-LEE-uh',
                Copay_Assistance_Available__c = 'No',
                Annual_Max__c = 15000.00,
                //Reimbursement_Vehicle__c = 'False debit card',
                Member_Minimum_Per_Claim__c = 0,
                PRx_Website__c = 'https://eylea.us/support/co-pay-card',
                Program_Fax__c = '1-888-335-3264',
                PRx_Help_Line_Number__c = '1-855-395-324871',
                PRx_Enrollment_Process__c = 'HCP can enroll member online ; PRx can 3-way call the patient and program to enroll them, card details can be provided at the end, for immediate use',
                Retroactive_Backdates__c = '120 Days',
                Re_Imbursement_Deadline__c = '365 Days'
                //Re_Enrollment_Date_Eligibility__c = '12 Months',
                //When_Re_Enrollment_Action_Is_Needed__c = '12 Months'

        );
        testDrugList.add(testDrug);

        testDrug = new Drug__c(
                J_Code__c = 'J9173',
                Name = 'IMFINZI',
                Therapy_Class__c = 'OCULAR DISORDERS',
                PRx_Program_Description__c = 'Non-Essential',
                Pronunciation__c = 'im-FIN-zee',
                TAT__c = '3 Days',
                //Copay_Assistance_Available__c = 'No',
                Annual_Max__c = 26000.00,
                //Reimbursement_Vehicle__c = 'False debit card',
                Member_Minimum_Per_Claim__c = 0,
                PRx_Website__c = 'https://www.astrazenecaspecialtysavings.com/pdf/IMFINZI_Affordability_Brochure.pdf',
                Program_Fax__c = '844-329-2360',
                PRx_Help_Line_Number__c = '844-275-2360',
                PRx_Enrollment_Process__c = 'Members HCP must enroll patient online to receive medication, with "IMFINZI" Access360. Once members are approved, they can call 1.844.275.2360 to verify/ or enroll.',
                Retroactive_Backdates__c = '120 Days',
                Re_Imbursement_Deadline__c = '180 Days',
                Re_Enrollment_Date_Eligibility__c = 'Calendar Year',
                When_Re_Enrollment_Action_Is_Needed__c = 'Calendar Year'

        );
        testDrugList.add(testDrug);
        insert testDrugList;

        system.debug('Setup CSAs');

        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = goLiveDate,
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-' +
                        csaInstance.CSA_Suffix__c + '-' +
                        csaInstance.CSA_Account__c
        );
        //insert csaInstance;
        //System.debug('csaInstance.CSA_Number__c = ' + csaInstance.CSA_Number__c);
        csaList.add(csaInstance);

        System.debug('accountInstance.Id = ' + accountInstance.Id);
        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = goLiveDate,
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '757',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-' +
                        csaInstance.CSA_Suffix__c + '-' +
                        csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = goLiveDate,
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '911',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-' +
                        csaInstance.CSA_Suffix__c + '-' +
                        csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = goLiveDate,
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '777',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-' +
                        csaInstance.CSA_Suffix__c + '-' +
                        csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        insert csaList;
        System.Debug(' csaList[0].CSA_Number__c = ' + csaList[0].CSA_Number__c);
    }

    @isTest
    private static void insertDailyClaims(){
        Test.startTest();
        String json = '[{ "prudentInDataStagingId": "09032021411608","Account_Number": "18", "Adjudicated_NDC_Units_Count": "2","Allowable_Amount": "100.65", "Authorization_Number": "A131", "Authorized_Representative_Relationship": "9", "Billing_Provider_City": "New York City", "Billing_Provider_PIN": "1234575", "Billing_Provider_State_Code": "NY", "Billing_Provider_Street_Address_Line_1": "463 Test Lane", "Billing_Provider_Zip_Code": "10122", "Billing_Provider_Phone": "3333333333", "Billing_Provider_Fax": "9999999999", "Claim_Identifier": "E11111111111119", "Claim_Indicator": "Initial Claim", "Claim_Line_Identifier": "2", "Claim_Segment": "01", "COB_indicator": "Secondary", "Control_Number": "900994", "Days_Supply": "38", "Diagnosis_Code": "12345678986", "Drug_Label_Name": "Drug One", "ICD9_Procedure_Code": "J1234", "National_Drug_Code": "123456791", "PA_Approval_Dates": "11012025", "Patient_Birth_Date": "01011998", "Patient_First_Name": "jeff ", "Patient_Last_Name": "Smith", "Patient_Middle_Initial": "H", "Patient_Phone_Number": "8888888896", "Patient_Sex": "M", "Policy_Holder_Name": "Centene", "Previous_Segment_Pointer": "null", "Provider_Indicator": "Preferred", "Service_From_Date": "07012029", "Service_Provider_Fax": "5555555563", "Service_Provider_Phone": "7777777784", "Service_To_Date": "07022030", "Servicing_Provider_Address_Line_1": "464 Plane Lane", "Servicing_Provider_City": "Chicago", "Servicing_Provider_First_Name": "Jim", "Servicing_Provider_Last_Name": "Will", "Servicing_Provider_National_Provider_Identifier": "9998887784", "Servicing_Provider_Practice_Role_Name": "NONE", "Servicing_Provider_Service_Location_Zip_Code": "10131", "Servicing_Provider_Specialty_Code": "8", "Servicing_Provider_State_Code": "NY", "Subscriber_Address_Line_1": "131 Sesame Street", "Subscriber_Address_Line_2": "null", "Subscriber_City": "Los Angeles", "Subscriber_CUMB_ID": "W12345686", "Subscriber_State_Code": "NY", "Subscriber_Zip_Code": "10158", "Suffix_Number": "34", "Total_Coinsurance_Amount": "38.64", "Total_Copay_Amount": "67.65", "Total_Deductible_Amount": "507.94", "Original_UCK_ID": "null", "Person_Relationship_Code": "01", "File_Upsert": "Daily Claims" }]';
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
    private static void insertDaily_Claims_HCPCSMismatch_UnitTest() {
        Daily_Claim_JSONRequest requestDailyClaims;

        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork) mocks.mock(fflib_ISObjectUnitOfWork.class);
        Daily_Claim_JSONRequest dailyClaimAIPRequest = (Daily_Claim_JSONRequest) mocks.mock(Daily_Claim_JSONRequest.class);
        Daily_Claims mockDaily_ClaimsDomain = (Daily_Claims) mocks.mock(Daily_Claims.class);
        // Given
        Id mockDaily_ClaimId =  fflib_IDGenerator.generate(Daily_Claim__c.SObjectType);
        Daily_Claim__c dailyClaimInstance = new Daily_Claim__c(
                Id = mockDaily_ClaimId,
                HCPCS_Code__c = 'IPC01',
                Patient_CUMB_ID__c = '123',
                Patient_Birth_Date__c = System.today()
        );

        List<Daily_Claim__c> testDaily_ClaimList = new List<Daily_Claim__c>{dailyClaimInstance};

        //Use the setMock method in the fflib_Application class to set our mock class for unit tests.
        PMd_Application.UnitOfWork.setMock(uowMock);
        PMd_Application.domain.setMock((fflib_ISObjectDomain) mockDaily_ClaimsDomain);

        mocks.startStubbing();
        //mocks.when(mockDaily_ClaimsDomain.newInstance(dailyClaimAIPRequest)).thenReturn(dailyClaimInstance);
        mocks.stopStubbing();

        // When
        Test.startTest();

        mockDaily_ClaimsDomain.processDailyClaimContacts(testDaily_ClaimList, uowMock);

        Test.stopTest();

        // Then
        //Here we are using the fflib_Match class to create a new sobject to match against to verify the subject field was actually changed in the above method //call.
        List<Daily_Claim__c> dailyClaimMatchingList = (List<Daily_Claim__c>)fflib_Match.sObjectsWith(new List<Map<Schema.SObjectField, Object>>{new Map<SObjectField, Object>{
                Daily_Claim__c.Id => mockDaily_ClaimId,
                Daily_Claim__c.Status__c => 'Error',
                Daily_Claim__c.Error_Log__c => 'HCPCS Mismatch'}
        });

//        ((Daily_Claims)mocks.verify(mockDaily_ClaimsDomain, mocks.never().description('This method was called but it shouldn\'t have been'))).handleAfterInsert();
        /*
((fflib_ISObjectUnitOfWork)
        mocks.verify(uowMock, 1)).registerNew(
        fflib_Match.sObjectWith(
                new Map<SObjectField, Object>{
                        Daily_Claim__c.Id => mockDaily_ClaimId,
                        Daily_Claim__c.Status__c => 'Error',
                        Daily_Claim__c.Error_Log__c => 'HCPCS Mismatch'} ));
*/
//Here we are verifying that our unit of works registerDirty method was indeed called with the updated data we expected by using a matcher. This should //return true pending your code actually did update the cases prior to calling this method as you intended.
//        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock)).registerNew(dailyClaimMatchingList);

//This also works (confusing right)... but it proves a lot less, it simply proves your method was called with that list of cases, but it doesn't prove it //updated those cases prior to calling it.
//        ((Daily_Claims)mocks.verify(mockDaily_ClaimsDomain, 1)).processDailyClaimContacts(testDaily_ClaimList, uowMock);
        //Daily_Claim__c dailyClaim = [SELECT Status__c, Error_Log__c FROM Daily_Claim__c WHERE id =: dailyClaimInstance.Id LIMIT 1];
/*
        Test.startTest();

        System.assertEquals('Error', dailyClaims.Status__c);
        System.assertEquals('HCPCS Mismatch', dailyClaims.Error_Log__c);

        Test.stopTest();
        */
    }

    @IsTest
    private static void insertDaily_Claims_HCPCSMismatch_IntegrationTest() {
        Daily_Claim_JSONRequest requestDailyClaims;

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
                Coding_Level__c = 'HCPCS + NDC',
                //NDC__c = '123456789',
                J_Code__c = 'IPC01'
        );
        insert drugInstance;

        NDC__c testNDC = new NDC__c(Drug__c = drugInstance.Id, Name = '012345678');
        insert testNDC;

        // Given
        Daily_Claim__c dailyClaimInstance = new Daily_Claim__c(
                HCPCS_Code__c = 'IPC02',
                Patient_CUMB_ID__c = '123',
                Patient_Birth_Date__c = System.today(),
                CSA_Control__c = 'CN0001',
                CSA_Suffix__c = 'SN0001',
                CSA_Account__c = 'AN0001'
        );
        insert dailyClaimInstance;

        // When
        Test.startTest();

        List<Daily_Claim__c> testDaily_ClaimList = new List<Daily_Claim__c> { dailyClaimInstance };

        IDaily_Claims dailClaims =
                Daily_Claims.newInstance(testDaily_ClaimList);

        Test.stopTest();

        // Then
        Daily_Claim__c dailyClaim = [SELECT Status__c, Error_Log__c FROM Daily_Claim__c WHERE Id =: dailyClaimInstance.Id LIMIT 1];

        System.assertEquals('Error', dailyClaim.Status__c);
        System.assertEquals('HCPCS Mismatch', dailyClaim.Error_Log__c);
    }

    @IsTest
    private static void insertDaily_Claims_HCPCSNDCMismatch_Test() {
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
                Coding_Level__c = 'HCPCS + NDC',
                //NDC__c = '123456789',
                J_Code__c = 'IPC02'
        );
        insert drugInstance;

        NDC__c testNDC = new NDC__c(Drug__c = drugInstance.Id, Name = '012345678');
        insert testNDC;

        Daily_Claim__c dailyClaimInstance = new Daily_Claim__c(
                //Id = fflib_IDGenerator.generate(Daily_Claim__c.SObjectType),
                HCPCS_Code__c = 'IPC01',
                NDC__c  = '123456789',
                //Patient_CUMB_ID__c = '123',
                Patient_Birth_Date__c = System.today(),
                CSA_Control__c = 'CN0001',
                CSA_Suffix__c = 'SN0001',
                CSA_Account__c = 'AN0001',
                CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0001' + '-' + 'SN0001' + '-' +'AN0001')
        );
        insert dailyClaimInstance;

        // When
        Test.startTest();

        List<Daily_Claim__c> testDaily_ClaimList = new List<Daily_Claim__c> { dailyClaimInstance };

        IDaily_Claims dailClaims =
                Daily_Claims.newInstance(testDaily_ClaimList);

        Test.stopTest();

        // Then
        Daily_Claim__c dailyClaim = [SELECT Status__c, Error_Log__c FROM Daily_Claim__c WHERE Id =: dailyClaimInstance.Id LIMIT 1];

        System.assertEquals('Error', dailyClaim.Status__c);
        System.assertEquals('HCPCS Mismatch', dailyClaim.Error_Log__c);
    }

    @IsTest
    private static void insertDaily_Claims_CSAMismatch_UnitTest() {
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

        Daily_Claim__c dailyClaimInstance = new Daily_Claim__c(
                //Id = fflib_IDGenerator.generate(Daily_Claim__c.SObjectType),
                HCPCS_Code__c = 'IPC02',
                //Patient_CUMB_ID__c = '123',
                Patient_Birth_Date__c = System.today(),
                CSA_Control__c = 'CN0002',
                CSA_Suffix__c = 'SN0002',
                CSA_Account__c = 'AN0002',
                CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0002' + '-' + 'SN0002' + '-' +'AN0002')
        );
        insert dailyClaimInstance;
        List<Daily_Claim__c> testDaily_ClaimList = new List<Daily_Claim__c> { dailyClaimInstance };
        PMd_Application.UnitOfWork.setMock(uowMock);

        // When
        IDaily_Claims dailClaims =
                Daily_Claims.newInstance(testDaily_ClaimList);
        //dailClaims.applyDiscount(discountPercent, uowMock);
/*
        // Then
        ((fflib_ISObjectUnitOfWork)
                mocks.verify(uowMock, 1)).registerDirty(
                fflib_Match.sObjectWith(
                        new Map<SObjectField, Object>{
                                Daily_Claim__c.Status__c => 'Error',
                                Daily_Claim__c.Error_Log__c => 'HCPCS Mismatch'} ));
        */
        Daily_Claim__c dailyClaim = [SELECT Status__c, Error_Log__c FROM Daily_Claim__c WHERE Id =: dailyClaimInstance.Id LIMIT 1];

        Test.startTest();

        System.assertEquals('Error', dailyClaim.Status__c);
        System.assertEquals('CSA Mismatch', dailyClaim.Error_Log__c);

        Test.stopTest();
    }

    @IsTest
    private static void insertDaily_Claims_CSAMismatch_IntegrationTest() {

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

        Daily_Claim__c dailyClaimInstance = new Daily_Claim__c(
                HCPCS_Code__c = 'IPC02',
                //Patient_CUMB_ID__c = '123',
                Patient_Birth_Date__c = System.today(),
                CSA_Control__c = 'CN0002',
                CSA_Suffix__c = 'SN0002',
                CSA_Account__c = 'AN0002',
                CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0002' + '-' + 'SN0002' + '-' +'AN0002')
        );
        insert dailyClaimInstance;

        List<Daily_Claim__c> testDaily_ClaimList = new List<Daily_Claim__c> { dailyClaimInstance };

        Test.startTest();
        // When
        IDaily_Claims dailClaims =
                Daily_Claims.newInstance(testDaily_ClaimList);

        Test.stopTest();

        // Then
        Daily_Claim__c dailyClaim = [SELECT Status__c, Error_Log__c FROM Daily_Claim__c WHERE id =: dailyClaimInstance.Id LIMIT 1];

        //Expected results
        System.assertEquals('Error', dailyClaim.Status__c);
        System.assertEquals('CSA Mismatch', dailyClaim.Error_Log__c);


    }

    //Error out claims when received out of order
    @IsTest
    private static void insertDaily_Claims_PreviousSegmentNotFound_IntegrationTest() {
        Daily_Claim_JSONRequest requestDailyClaims;

        // Given
        Account accountInstance = new Account(
                //Id = mockAccountId,
                Name = 'Test Account'
        );
        insert accountInstance;
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);

        Drug__c drugInstance = new Drug__c(
                Name = 'Drug Test 1',
                //NDC__c = '123456789',
                J_Code__c = 'IPC02',
                Coding_Level__c = 'HCPCS'
        );
        insert drugInstance;

        NDC__c testNDC = new NDC__c(Drug__c = drugInstance.Id, Name = '123456789');
        insert testNDC;

        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Line__c = '1';
        claims.Claim_Segment__c = '01';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        //claims.Drug__c= testDrug.id;
        //insert claims;
        // List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c];
        //  system.assertEquals(1,claimList.size());

        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;
        Daily_Claim__c dailyClaims1 = new Daily_Claim__c();
        dailyClaims1.CSA_Account__c = 'AN0003';
        dailyClaims1.Units_Billed__c = 2;
        dailyClaims1.Amount_Paid_By_Primary__c = 100;
        dailyClaims1.Prior_Authorization__c = 'A123';
        dailyClaims1.Authorized_Representative__c = 'Jane Smith';
        dailyClaims1.Authorized_Relationship__c = '1';
        dailyClaims1.Billing_Provider_City__c = 'New York City';
        dailyClaims1.Billing_Provider_First_Name__c = 'Test';
        dailyClaims1.Billing_Provider_Last_Name__c = 'one';
        dailyClaims1.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims1.Billing_Provider_PIN__c = '1234567';
        dailyClaims1.Billing_Provider_State__c = 'NY';
        dailyClaims1.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims1.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims1.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims1.Billing_Provider_Phone__c = '5555555555';
        dailyClaims1.Billing_Provider_Fax__c = '9999999999';
        dailyClaims1.Primary_Claim_Number__c = 'JG12380';
        dailyClaims1.Claim_Code__c = 'Initial Claim';
        dailyClaims1.Claim_Line__c = '1';
        dailyClaims1.Claim_Segment__c = '01';
        dailyClaims1.Previous_Segment__c = '03'; //The previous segment is out of order & there was no original claim created
        dailyClaims1.COB_Code__c = 'Secondary';
        dailyClaims1.CSA_Control__c = 'CN0003';
        dailyClaims1.Days_Supply__c = 30;
        dailyClaims1.Diagnosis_Code__c = '12345678987';
        dailyClaims1.Drug_Label_Name__c = 'Drug One';
        dailyClaims1.HCPCS_Code__c = 'IPC02';
        dailyClaims1.NDC__c = '123456789';
        dailyClaims1.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims1.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims1.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims1.Patient_First_Name__c = 'Jane';
        dailyClaims1.Patient_Last_Name__c = 'Doe';
        dailyClaims1.Patient_Middle_Initial__c = 'H';
        dailyClaims1.Patient_Phone_Number__c = '8888888888';
        dailyClaims1.Patient_Gender__c = 'M';
        dailyClaims1.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims1.Preferred_Provider__c = 'Preferred';
        dailyClaims1.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims1.Service_Provider_Fax__c = '5555555555';
        dailyClaims1.Service_Provider_Phone__c = '7777777777';
        dailyClaims1.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims1.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims1.Service_Provider_City__c = 'Chicago';
        dailyClaims1.Service_Provider_First_Name__c = 'Jane';
        dailyClaims1.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims1.Service_Provider_NPI__c = '9998887776';
        //dailyClaims1.Service_Provider_Practice__c = 'NONE';
        dailyClaims1.Service_Provider_Zip__c = '10123';
        dailyClaims1.Service_Provider_State__c = 'NY';
        dailyClaims1.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims1.Patient_Address_Line_2__c = '0';
        dailyClaims1.Patient_City__c = 'Los Angeles';
        dailyClaims1.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims1.Patient_State__c = 'NY';
        dailyClaims1.Patient_Zip_Code__c = '10151';
        dailyClaims1.CSA_Suffix__c = 'SN0003';
        dailyClaims1.Total_Coinsurance__c = 30;
        dailyClaims1.Total_Copay__c = 30;
        dailyClaims1.Total_Deductible__c = 500;
        dailyClaims1.Previous_Claim__c = '';
        dailyClaims1.Relationship_Code__c = '01';
        //dailyClaims1.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims1;

        Daily_Claim__c dailyClaims2 = new Daily_Claim__c();
        dailyClaims2.CSA_Account__c = 'AN0003';
        dailyClaims2.Units_Billed__c = 2;
        dailyClaims2.Amount_Paid_By_Primary__c = 100;
        dailyClaims2.Prior_Authorization__c = 'A123';
        dailyClaims2.Authorized_Representative__c = 'Jane Smith';
        dailyClaims2.Authorized_Relationship__c = '1';
        dailyClaims2.Billing_Provider_City__c = 'New York City';
        dailyClaims2.Billing_Provider_First_Name__c = 'Test';
        dailyClaims2.Billing_Provider_Last_Name__c = 'one';
        dailyClaims2.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims2.Billing_Provider_PIN__c = '1234567';
        dailyClaims2.Billing_Provider_State__c = 'NY';
        dailyClaims2.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims2.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims2.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims2.Billing_Provider_Phone__c = '5555555555';
        dailyClaims2.Billing_Provider_Fax__c = '9999999999';
        dailyClaims2.Primary_Claim_Number__c = 'JG12380';
        dailyClaims2.Claim_Code__c = 'Initial Claim';
        dailyClaims2.Claim_Line__c = '1';
        dailyClaims2.Claim_Segment__c = '00';
        dailyClaims2.Previous_Segment__c = ''; //The claim is the original claim
        dailyClaims2.COB_Code__c = 'Secondary';
        dailyClaims2.CSA_Control__c = 'CN0003';
        dailyClaims2.Days_Supply__c = 30;
        dailyClaims2.Diagnosis_Code__c = '12345678987';
        dailyClaims2.Drug_Label_Name__c = 'Drug One';
        dailyClaims2.HCPCS_Code__c = 'IPC02';
        dailyClaims2.NDC__c = '123456789';
        dailyClaims2.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims2.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims2.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims2.Patient_First_Name__c = 'Jane';
        dailyClaims2.Patient_Last_Name__c = 'Doe';
        dailyClaims2.Patient_Middle_Initial__c = 'H';
        dailyClaims2.Patient_Phone_Number__c = '8888888888';
        dailyClaims2.Patient_Gender__c = 'M';
        dailyClaims2.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims2.Preferred_Provider__c = 'Preferred';
        dailyClaims2.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims2.Service_Provider_Fax__c = '5555555555';
        dailyClaims2.Service_Provider_Phone__c = '7777777777';
        dailyClaims2.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims2.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims2.Service_Provider_City__c = 'Chicago';
        dailyClaims2.Service_Provider_First_Name__c = 'Jane';
        dailyClaims2.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims2.Service_Provider_NPI__c = '9998887776';
        //dailyClaims2.Service_Provider_Practice__c = 'NONE';
        dailyClaims2.Service_Provider_Zip__c = '10123';
        dailyClaims2.Service_Provider_State__c = 'NY';
        dailyClaims2.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims2.Patient_Address_Line_2__c = '0';
        dailyClaims2.Patient_City__c = 'Los Angeles';
        dailyClaims2.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims2.Patient_State__c = 'NY';
        dailyClaims2.Patient_Zip_Code__c = '10151';
        dailyClaims2.CSA_Suffix__c = 'SN0003';
        dailyClaims2.Total_Coinsurance__c = 30;
        dailyClaims2.Total_Copay__c = 30;
        dailyClaims2.Total_Deductible__c = 500;
        dailyClaims2.Previous_Claim__c = '';
        dailyClaims2.Relationship_Code__c = '01';
        //dailyClaims2.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims2;

        // When
        Test.startTest();

        Daily_Claim__c dailyClaims3 = new Daily_Claim__c();
        dailyClaims3.CSA_Account__c = 'AN0003';
        dailyClaims3.Units_Billed__c = 2;
        dailyClaims3.Amount_Paid_By_Primary__c = 100;
        dailyClaims3.Prior_Authorization__c = 'A123';
        dailyClaims3.Authorized_Representative__c = 'Jane Smith';
        dailyClaims3.Authorized_Relationship__c = '1';
        dailyClaims3.Billing_Provider_City__c = 'New York City';
        dailyClaims3.Billing_Provider_First_Name__c = 'Test';
        dailyClaims3.Billing_Provider_Last_Name__c = 'one';
        dailyClaims3.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims3.Billing_Provider_PIN__c = '1234567';
        dailyClaims3.Billing_Provider_State__c = 'NY';
        dailyClaims3.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims3.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims3.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims3.Billing_Provider_Phone__c = '5555555555';
        dailyClaims3.Billing_Provider_Fax__c = '9999999999';
        dailyClaims3.Primary_Claim_Number__c = 'JG12380';
        dailyClaims3.Claim_Code__c = 'Initial Claim';
        dailyClaims3.Claim_Line__c = '1';
        dailyClaims3.Claim_Segment__c = '00';
        dailyClaims3.Previous_Segment__c = '03'; //The previous claim seg should be 00 (the original claim)
        dailyClaims3.COB_Code__c = 'Secondary';
        dailyClaims3.CSA_Control__c = 'CN0003';
        dailyClaims3.Days_Supply__c = 30;
        dailyClaims3.Diagnosis_Code__c = '12345678987';
        dailyClaims3.Drug_Label_Name__c = 'Drug One';
        dailyClaims3.HCPCS_Code__c = 'IPC02';
        dailyClaims3.NDC__c = '123456789';
        dailyClaims3.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims3.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims3.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims3.Patient_First_Name__c = 'Jane';
        dailyClaims3.Patient_Last_Name__c = 'Doe';
        dailyClaims3.Patient_Middle_Initial__c = 'H';
        dailyClaims3.Patient_Phone_Number__c = '8888888888';
        dailyClaims3.Patient_Gender__c = 'M';
        dailyClaims3.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims3.Preferred_Provider__c = 'Preferred';
        dailyClaims3.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims3.Service_Provider_Fax__c = '5555555555';
        dailyClaims3.Service_Provider_Phone__c = '7777777777';
        dailyClaims3.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims3.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims3.Service_Provider_City__c = 'Chicago';
        dailyClaims3.Service_Provider_First_Name__c = 'Jane';
        dailyClaims3.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims3.Service_Provider_NPI__c = '9998887776';
        //dailyClaims3.Service_Provider_Practice__c = 'NONE';
        dailyClaims3.Service_Provider_Zip__c = '10123';
        dailyClaims3.Service_Provider_State__c = 'NY';
        dailyClaims3.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims3.Patient_Address_Line_2__c = '0';
        dailyClaims3.Patient_City__c = 'Los Angeles';
        dailyClaims3.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims3.Patient_State__c = 'NY';
        dailyClaims3.Patient_Zip_Code__c = '10151';
        dailyClaims3.CSA_Suffix__c = 'SN0003';
        dailyClaims3.Total_Coinsurance__c = 30;
        dailyClaims3.Total_Copay__c = 30;
        dailyClaims3.Total_Deductible__c = 500;
        dailyClaims3.Previous_Claim__c = '';
        dailyClaims3.Relationship_Code__c = '01';
        //dailyClaims3.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims3;

        // Then
        //The previous segment is out of order & there was no original claim created
        Daily_Claim__c dailyClaim = [SELECT Status__c, Error_Log__c FROM Daily_Claim__c WHERE Id =: dailyClaims1.Id LIMIT 1];

        System.assertEquals('Error', dailyClaim.Status__c);
        System.assertEquals('Previous segment not found', dailyClaim.Error_Log__c);

        //The claim is the original claim
        dailyClaim = [SELECT Status__c, Error_Log__c FROM Daily_Claim__c WHERE Id =: dailyClaims2.Id LIMIT 1];

        System.assertEquals(null, dailyClaim.Status__c);
        System.assertEquals(null, dailyClaim.Error_Log__c);

        //The previous claim seg should be 00 (the original claim)
        dailyClaim = [SELECT Status__c, Error_Log__c FROM Daily_Claim__c WHERE Id =: dailyClaims3.Id LIMIT 1];

        System.assertEquals('Error', dailyClaim.Status__c);
        System.assertEquals('Previous segment not found', dailyClaim.Error_Log__c);


        Test.stopTest();
    }

    @isTest
    public static void existingClaim()
    {
        Drug__c testDrug = new Drug__c();
        testDrug.J_Code__c = 'J5679';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;

        Account accountInstance = new Account();
        accountInstance.Name='Test Account';
        insert accountInstance;

        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Line__c = '1';
        claims.Claim_Segment__c = '01';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        //claims.Drug__c= testDrug.id;
        //insert claims;
        // List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c];
        //  system.assertEquals(1,claimList.size());


        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;
        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'JG12380';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '1';
        dailyClaims.Claim_Segment__c = '01';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5679';
        dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Jane';
        dailyClaims.Patient_Last_Name__c = 'Doe';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Previous_Claim__c = '';
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims;

        Test.startTest();
        //
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where Primary_Claim_Number__c =:'JG12380'];
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);

        }
        system.assertEquals(1,claimList.size());
        Test.stopTest();
    }

    @isTest
    public static void updateClaims(){

        Drug__c testDrug = new Drug__c();
        testDrug.J_Code__c = 'J5678';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;
/*
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
*/
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        dailyClaimsTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        Claim_Information__c claims = new Claim_Information__c();
        claims.Claim_Number__c='E11111111111111';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Line__c = '1';
        claims.Claim_Segment__c = '01';
        //claims.Drug__c= testDrug.id;
        //insert claims;

        Contact con = new Contact();
        con.Patient_First_Name__c= 'Sam';
        con.Patient_Last_Name__c='William';
        con.FirstName = 'Test Contact';
        con.LastName  = 'Daily';
        con.CSA__c=csaInstance.id;

        insert con;
        Contact_Drug__c contactDrug = new Contact_Drug__c();
        contactDrug.Contact__c=con.id;
        // contactDrug.HCPCS_Code__c = 'J3678';
        insert contactDrug;

        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        //dailyClaims.Billing_Provider_First_Name__c = 'Test';
        //dailyClaims.Billing_Provider_Last_Name__c = 'one';
        //dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'E11111111111111';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '1';
        dailyClaims.Claim_Segment__c = '01';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5678';
        dailyClaims.NDC__c = '123456789';
        //dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Joe';
        dailyClaims.Patient_Last_Name__c = 'Smith';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Previous_Claim__c = '';
        dailyClaims.Relationship_Code__c = '01';
        dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert dailyClaims;

        //Contact conList = [SELECT CSA_Account__c from Contact where id =: conRec.id];
        //Claim_Information__c claimList = [SELECT CSA_Account__c from Claim_Information__c where id =:Claims.id ];
        List<Claim_Information__c> claimListCheck = [SELECT id from Claim_Information__c where CSA_Account__c =: dailyClaims.CSA_Account__c];
        system.assertequals(1,claimListCheck.size());
        List<Claim_Information__c> claimList = [SELECT Id, Amount_Paid_By_Primary__c from Claim_Information__c WHERE Claim_Number__c =:'E11111111111111'];
        for(Claim_Information__c claim:claimList){
            system.assertequals(100,claim.Amount_Paid_By_Primary__c);}
    }

    @isTest
    public static void missingClaimAndContactPostGoLive()
    {
/*
        Account accountInstance = new Account(
                Name = 'Test Account'

        );

        insert accountInstance;
*/
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        dailyClaimsTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        Drug__c testDrug = new Drug__c();
        testDrug.J_Code__c = 'J5678';
        testDRug.Coding_Level__c = 'HCPCS';
        insert testDrug;
/*
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-09-17'),
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;
*/
        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 103;
        dailyClaims.Prior_Authorization__c = 'A126';
        dailyClaims.Authorized_Representative__c = 'Ras And';
        dailyClaims.Authorized_Relationship__c = '4';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        //dailyClaims.Billing_Provider_First_Name__c = 'Test';
        //dailyClaims.Billing_Provider_Last_Name__c = 'Four';
        //dailyClaims.Billing_Provider_Specialty__c = 'Specialty 4';
        dailyClaims.Billing_Provider_PIN__c = '1234570';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        dailyClaims.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims.Billing_Provider_Zip_Code__c = '10118';
        dailyClaims.Billing_Provider_Phone__c = '3333333333';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'E11111111111114';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '3';
        dailyClaims.Claim_Segment__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.Days_Supply__c = 32;
        dailyClaims.Diagnosis_Code__c = '12345678989';
        dailyClaims.Drug_Label_Name__c = 'Drug Four';
        dailyClaims.HCPCS_Code__c = 'J5678';
        //dailyClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaims.NDC__c = '123456792';
        //dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //dailyClaims.Patient_Email_Address__c = 'lara@test.com';
        dailyClaims.Patient_First_Name__c = 'Lara';
        dailyClaims.Patient_Last_Name__c = 'Briyan';
        dailyClaims.Patient_Middle_Initial__c = 'B';
        dailyClaims.Patient_Phone_Number__c = '8888888890';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'TCS';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2024-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555557';
        dailyClaims.Service_Provider_Phone__c = '7777777779';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2024-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Dave';
        dailyClaims.Service_Provider_Last_Name__c = 'Dle';
        dailyClaims.Service_Provider_NPI__c = '9998887778';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10125';
        dailyClaims.Service_Provider_Specialty_Code__c = '3';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '125 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = 'Apt 4';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345680';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10153';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.Total_Coinsurance__c = 33;
        dailyClaims.Total_Copay__c = 72;
        dailyClaims.Total_Deductible__c = 502;
        dailyClaims.Previous_Claim__c = '';
        dailyClaims.Relationship_Code__c = '01';
        dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert dailyClaims;

        Test.startTest();
        List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: dailyClaims.CSA_Account__c];
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where CSA_Account__c =: dailyClaims.CSA_Account__c];
        // List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Claim_Information__c =: claims.id ];

        system.assertequals(1,claimList.size());
        system.assertequals(1,conList.size());
        for (Claim_Information__c claim: claimList){
            List<Case> caseList = [SELECT id from Case where Claim_Information__c =: claim.id ];
            system.assertequals(2,caseList.size());}

        //system.assertequals(1,contactDrugList.size());

        Test.stopTest();

    }

    @isTest
    public static void missingClaimAndContactPreGoLive()
    {
/*
        Account accountInstance = new Account(
                Name = 'Test Account'

        );

        insert accountInstance;
*/
        Boolean preGoLive = True;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        dailyClaimsTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        Drug__c testDrug = new Drug__c();
        testDrug.J_Code__c = 'J5678';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;
/*
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-09-06'),
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;
*/
        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 103;
        dailyClaims.Prior_Authorization__c = 'A126';
        dailyClaims.Authorized_Representative__c = 'Ras And';
        dailyClaims.Authorized_Relationship__c = '4';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        //dailyClaims.Billing_Provider_First_Name__c = 'Test';
        //dailyClaims.Billing_Provider_Last_Name__c = 'Four';
        //dailyClaims.Billing_Provider_Specialty__c = 'Specialty 4';
        dailyClaims.Billing_Provider_PIN__c = '1234570';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        dailyClaims.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims.Billing_Provider_Zip_Code__c = '10118';
        dailyClaims.Billing_Provider_Phone__c = '3333333333';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'E11111111111114';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '3';
        dailyClaims.Claim_Segment__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.Days_Supply__c = 32;
        dailyClaims.Diagnosis_Code__c = '12345678989';
        dailyClaims.Drug_Label_Name__c = 'Drug Four';
        dailyClaims.HCPCS_Code__c = 'J5678';
        //dailyClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaims.NDC__c = '123456792';
        //dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //dailyClaims.Patient_Email_Address__c = 'lara@test.com';
        dailyClaims.Patient_First_Name__c = 'Lara';
        dailyClaims.Patient_Last_Name__c = 'Briyan';
        dailyClaims.Patient_Middle_Initial__c = 'B';
        dailyClaims.Patient_Phone_Number__c = '8888888890';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'TCS';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2024-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555557';
        dailyClaims.Service_Provider_Phone__c = '7777777779';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2024-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Dave';
        dailyClaims.Service_Provider_Last_Name__c = 'Dle';
        dailyClaims.Service_Provider_NPI__c = '9998887778';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10125';
        dailyClaims.Service_Provider_Specialty_Code__c = '3';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '125 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = 'Apt 4';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345680';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10153';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.Total_Coinsurance__c = 33;
        dailyClaims.Total_Copay__c = 72;
        dailyClaims.Total_Deductible__c = 502;
        dailyClaims.Previous_Claim__c = '';
        dailyClaims.Relationship_Code__c = '01';
        dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert dailyClaims;

        Test.startTest();
        List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: dailyClaims.CSA_Account__c];
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where CSA_Account__c =: dailyClaims.CSA_Account__c];
        // List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Claim_Information__c =: claims.id ];

        system.assertequals(1,claimList.size());
        system.assertequals(1,conList.size());
        for (Claim_Information__c claim: claimList){
            List<Case> caseList = [SELECT id from Case where Claim_Information__c =: claim.id ];
            system.assertequals(1,caseList.size());}

        //system.assertequals(1,contactDrugList.size());

        Test.stopTest();

    }


    @isTest
    public static void missingClaimAndContactDrugPreGoLive()
    {
/*
        Account accountInstance = new Account(
                Name = 'Test Account'

        );

        insert accountInstance;
*/
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        dailyClaimsTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        Drug__c testDrug = new Drug__c();
        testDrug.J_Code__c = 'J5678';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;

        Drug__c testDrug1 = new Drug__c();
        testDrug1.J_Code__c = 'J6783';
        testDrug1.Coding_Level__c = 'HCPCS';
        insert testDrug1;
/*
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-09-09'),
                CSA_Control__c = 'CN0010',
                CSA_Suffix__c = 'SN0010',
                CSA_Account__c = 'AN0010'
        );
        insert csaInstance;
*/
        Contact con = new Contact();
        con.Patient_First_Name__c= 'Sam';
        con.Patient_Last_Name__c='William';
        con.FirstName = 'Test Contact';
        con.LastName  = 'Daily';
        con.CSA_Account__c='AN0010';
        con.CSA__c=csaInstance.id;

        insert con;
        Contact_Drug__c conDrug = new Contact_Drug__c();
        conDrug.Contact__c = con.id;
        conDrug.Drug_Name__c = testDrug1.id;

        insert conDrug;

        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 103;
        dailyClaims.Prior_Authorization__c = 'A127';
        dailyClaims.Authorized_Representative__c = 'Ras And';
        dailyClaims.Authorized_Relationship__c = '4';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        //dailyClaims.Billing_Provider_First_Name__c = 'Test';
        //dailyClaims.Billing_Provider_Last_Name__c = 'Four';
        //dailyClaims.Billing_Provider_Specialty__c = 'Specialty 4';
        dailyClaims.Billing_Provider_PIN__c = '1234570';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        dailyClaims.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims.Billing_Provider_Zip_Code__c = '10118';
        dailyClaims.Billing_Provider_Phone__c = '3333333333';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'E11111111111114';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '3';
        dailyClaims.Claim_Segment__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.Days_Supply__c = 32;
        dailyClaims.Diagnosis_Code__c = '12345678989';
        dailyClaims.Drug_Label_Name__c = 'Drug Four';
        dailyClaims.HCPCS_Code__c = 'J5678';
        //dailyClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaims.NDC__c = '123456792';
        //dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //dailyClaims.Patient_Email_Address__c = 'lara@test.com';
        dailyClaims.Patient_First_Name__c = 'Sam';
        dailyClaims.Patient_Last_Name__c = 'William';
        dailyClaims.Patient_Middle_Initial__c = 'B';
        dailyClaims.Patient_Phone_Number__c = '8888888890';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'TCS';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2024-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555557';
        dailyClaims.Service_Provider_Phone__c = '7777777779';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2024-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Dave';
        dailyClaims.Service_Provider_Last_Name__c = 'Dle';
        dailyClaims.Service_Provider_NPI__c = '9998887778';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10125';
        dailyClaims.Service_Provider_Specialty_Code__c = '3';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '125 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = 'Apt 4';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345680';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10153';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.Total_Coinsurance__c = 33;
        dailyClaims.Total_Copay__c = 72;
        dailyClaims.Total_Deductible__c = 502;
        dailyClaims.Previous_Claim__c = '';
        dailyClaims.Relationship_Code__c = '01';
        dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert dailyClaims;

        Test.startTest();
        //List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: dailyClaims.CSA_Account__c];
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where CSA_Account__c =: dailyClaims.CSA_Account__c];
        //List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Contact__c =: con.id ];
        //List<Case> caseList = [SELECT id from Case where Contact_Drug__c=: contactDrug.id ];

        system.assertequals(1,claimList.size());
        //system.assertequals(1,conList.size());
        //system.assertequals(1,contactDrugList.size());
        //system.assertequals(1,caseList.size());
        for (Claim_Information__c claim: claimList){
            List<Case> caseList = [SELECT id from Case where Claim_Information__c =: claim.id ];
            system.assertequals(2,caseList.size());}

        Test.stopTest();

    }
    @isTest
    public static void missingClaimAndContactDrugPostGoLive()
    {
        /*
        Account accountInstance = new Account(
                Name = 'Test Account'

        );

        insert accountInstance;
*/
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        dailyClaimsTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        Drug__c testDrug = new Drug__c();
        testDrug.J_Code__c = 'J5678';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;

        Drug__c testDrug1 = new Drug__c();
        testDrug1.J_Code__c = 'J6783';
        testDrug1.Coding_Level__c = 'HCPCS';
        insert testDrug1;

        Drug__c testDrug2 = new Drug__c();
        testDrug1.J_Code__c = 'J6784';
        testDrug1.Coding_Level__c = 'HCPCS';
        insert testDrug2;
/*
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2030-09-17'),
                CSA_Control__c = 'CN0006',
                CSA_Suffix__c = 'SN0006',
                CSA_Account__c = 'AN0006'
        );
        insert csaInstance;
*/
        Contact con = new Contact();
        con.Patient_First_Name__c= 'Sam';
        con.Patient_Last_Name__c='William';
        con.FirstName = 'Test Contact';
        con.LastName  = 'Daily';
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


        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 103;
        dailyClaims.Prior_Authorization__c = 'A127';
        dailyClaims.Authorized_Representative__c = 'Ras And';
        dailyClaims.Authorized_Relationship__c = '4';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        //dailyClaims.Billing_Provider_First_Name__c = 'Test';
        //dailyClaims.Billing_Provider_Last_Name__c = 'Four';
        //dailyClaims.Billing_Provider_Specialty__c = 'Specialty 4';
        dailyClaims.Billing_Provider_PIN__c = '1234570';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        dailyClaims.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims.Billing_Provider_Zip_Code__c = '10118';
        dailyClaims.Billing_Provider_Phone__c = '3333333333';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'E11111111111114';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '3';
        dailyClaims.Claim_Segment__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.Days_Supply__c = 32;
        dailyClaims.Diagnosis_Code__c = '12345678989';
        dailyClaims.Drug_Label_Name__c = 'Drug Four';
        dailyClaims.HCPCS_Code__c = 'J5678';
        //dailyClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaims.NDC__c = '123456792';
        //dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //dailyClaims.Patient_Email_Address__c = 'lara@test.com';
        dailyClaims.Patient_First_Name__c = 'Sam';
        dailyClaims.Patient_Last_Name__c = 'William';
        dailyClaims.Patient_Middle_Initial__c = 'B';
        dailyClaims.Patient_Phone_Number__c = '8888888890';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'TCS';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2024-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555557';
        dailyClaims.Service_Provider_Phone__c = '7777777779';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2024-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Dave';
        dailyClaims.Service_Provider_Last_Name__c = 'Dle';
        dailyClaims.Service_Provider_NPI__c = '9998887778';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10125';
        dailyClaims.Service_Provider_Specialty_Code__c = '3';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '125 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = 'Apt 4';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345680';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10153';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.Total_Coinsurance__c = 33;
        dailyClaims.Total_Copay__c = 72;
        dailyClaims.Total_Deductible__c = 502;
        dailyClaims.Previous_Claim__c = '';
        dailyClaims.Relationship_Code__c = '01';
        dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert dailyClaims;

        Test.startTest();
        //List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: dailyClaims.CSA_Account__c];
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where CSA_Account__c =: dailyClaims.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Contact__c =: con.id ];
        //List<Case> caseList = [SELECT id from Case where Contact_Drug__c=: contactDrug.id ];

        system.assertequals(1,claimList.size());
        //system.assertequals(1,conList.size());
        system.assertequals(1,contactDrugList.size());
        //system.assertequals(1,caseList.size());
        for (Claim_Information__c claim: claimList){
            List<Case> caseList = [SELECT id from Case where Claim_Information__c =: claim.id ];
            system.assertequals(2,caseList.size());}

        Test.stopTest();

    }

    @isTest
    public static void missingClaimPostGoLive() {

/*
        Account accountInstance = new Account(
                Name = 'Test Account'

        );

        insert accountInstance;
*/
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        dailyClaimsTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        Drug__c testDrug = new Drug__c();
        testDrug.J_Code__c = 'J5678';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;
/*
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2030-09-17'),
                CSA_Control__c = 'CN0006',
                CSA_Suffix__c = 'SN0006',
                CSA_Account__c = 'AN0006'
        );
        insert csaInstance;
*/
        Contact con = new Contact();
        con.Patient_First_Name__c= 'Sam';
        con.Patient_Last_Name__c='William';
        con.FirstName = 'Test Contact';
        con.LastName  = 'Daily';
        con.CSA__c=csaInstance.id;

        insert con;
        Contact_Drug__c contactDrug1 = new Contact_Drug__c();
        contactDrug1.Contact__c=con.id;
        contactDrug1.Drug_Name__c= testDrug.id;
        insert contactDrug1;

        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 103;
        dailyClaims.Prior_Authorization__c = 'A127';
        dailyClaims.Authorized_Representative__c = 'Ras And';
        dailyClaims.Authorized_Relationship__c = '4';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        //dailyClaims.Billing_Provider_First_Name__c = 'Test';
        //dailyClaims.Billing_Provider_Last_Name__c = 'Four';
        //dailyClaims.Billing_Provider_Specialty__c = 'Specialty 4';
        dailyClaims.Billing_Provider_PIN__c = '1234570';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        dailyClaims.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims.Billing_Provider_Zip_Code__c = '10118';
        dailyClaims.Billing_Provider_Phone__c = '3333333333';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'E11111111111114';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '3';
        dailyClaims.Claim_Segment__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.Days_Supply__c = 32;
        dailyClaims.Diagnosis_Code__c = '12345678989';
        dailyClaims.Drug_Label_Name__c = 'Drug Four';
        dailyClaims.HCPCS_Code__c = 'J5678';
        //dailyClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaims.NDC__c = '123456792';
        //dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //dailyClaims.Patient_Email_Address__c = 'lara@test.com';
        dailyClaims.Patient_First_Name__c = 'Sam';
        dailyClaims.Patient_Last_Name__c = 'William';
        dailyClaims.Patient_Middle_Initial__c = 'B';
        dailyClaims.Patient_Phone_Number__c = '8888888890';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'TCS';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2024-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555557';
        dailyClaims.Service_Provider_Phone__c = '7777777779';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2024-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Dave';
        dailyClaims.Service_Provider_Last_Name__c = 'Dle';
        dailyClaims.Service_Provider_NPI__c = '9998887778';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10125';
        dailyClaims.Service_Provider_Specialty_Code__c = '3';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '125 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = 'Apt 4';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345680';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10153';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.Total_Coinsurance__c = 33;
        dailyClaims.Total_Copay__c = 72;
        dailyClaims.Total_Deductible__c = 502;
        dailyClaims.Previous_Claim__c = '';
        dailyClaims.Relationship_Code__c = '01';
        dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0006' + '-' + 'SN0006' + '-' +'AN0006');

        insert dailyClaims;

        Test.startTest();
        //List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: dailyClaims.CSA_Account__c];
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where CSA_Account__c=: dailyClaims.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Contact__c =: con.id ];
        //List<Case> caseList = [SELECT id from Case where Contact_Drug__c=: contactDrug.id ];

        system.assertequals(1,claimList.size());
        //system.assertequals(1,conList.size());
        system.assertequals(1,contactDrugList.size());
        //system.assertequals(1,caseList.size());
        for (Claim_Information__c claim: claimList){
            List<Case> caseList = [SELECT id from Case where Claim_Information__c =: claim.id ];
            system.assertequals(2,caseList.size());}

        Test.stopTest();

    }

    //SAL-1351 Replacement Claim to be associated with previously adjudicated claim's case number
    @isTest
    public static void replacementClaim()
    {
        //On certain scenarios, Aetna sends the claim for Reprocessing & sends a Replacement claim with a new claim number from ACAS system to Prudent.
        // Since these claims are linked to each other our call center should be able to use the existing case for the new claim.

        //Collect all Replacement claims by UCKID(Previous_Claim__c field)
        //The original UCK ID on the replacement claim will contain the value of a claim ID for an existing claim (Use for matching).
        //  1. On the Initial claim, UCK ID will be “Blank”
        //  2. On the Replacement claim, UCK ID will be present & we need to use this UCK ID and run a match with the Initial Claim ID.

        Drug__c testDrug = new Drug__c();
        testDrug.J_Code__c = 'J5679';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;
/*
        Account accountInstance = new Account();
        accountInstance.Name='Test Account';
        insert accountInstance;
*/
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        dailyClaimsTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Line__c = '1';
        claims.Claim_Segment__c = '01';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        //claims.Drug__c= testDrug.id;
        //insert claims;
        // List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c];
        //  system.assertEquals(1,claimList.size());
/*
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-09-17'),
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;
*/
        //Insert the initial claim that will be replaced.
        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'JG12380';
        dailyClaims.Claim_Code__c = 'O';
        dailyClaims.Claim_Line__c = '1';
        dailyClaims.Claim_Segment__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5679';
        dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Jane';
        dailyClaims.Patient_Last_Name__c = 'Doe';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Previous_Claim__c = ''; //On the Initial claim, UCK ID will be “Blank”
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');
        insert dailyClaims;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);

        }
        system.assertEquals(1,claimList.size());

        List<Case> caseList = [SELECT Id FROM Case WHERE Claim_Information__c =: claimList[0].Id];
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);

        }
        //Cases from old claim should move to the new replacement claim
        system.assertEquals(2,caseList.size());

        //Replacement Daily Claim.
        dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'JG12380';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '1';
        dailyClaims.Claim_Segment__c = '01';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5679';
        dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Jane';
        dailyClaims.Patient_Last_Name__c = 'Doe';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Previous_Claim__c = 'JG12380'; //On the Replacement claim, UCK ID will be present & we need to use this UCK ID and run a match with the Initial Claim ID.
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims;

        claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        caseList = [SELECT Id FROM Case WHERE Claim_Information__c =: claimList[0].Id];

        //Cases from old claim should move to the new replacement claim
        system.assertEquals(0,caseList.size());

        //A new replacement claim should be created
        claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);

        }
        system.assertEquals(2,claimList.size());


        caseList = [SELECT Id FROM Case WHERE Claim_Information__c =: claimList[1].Id];
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);

        }
        //Cases from old claim should move to the new replacement claim
        system.assertEquals(2,caseList.size());
        Test.stopTest();
    }

    //MBP-468 Reopening an Enrollment Case created from a Daily Claim Source file
    @isTest
    public static void reopenDailyClaimEnrollmentCaseTest()
    {
        /*
        Post Go-live we will likely receive claims for Members that we were previously NOT able to confirm CPA enrollment for prior to Go Live.
        The original Enrollment Case will have been closed with “Outreach Completed”. BUT the Contact Drug “CPA Enrollment Status” will be marked CPA “Not on File”.
        When we receive a claim for these members we will automatically open a Reimbursement Case. To ensure that each member is able to take advantage of the
        available CPA benefit, we will need to Reopen the Enrollment Case so that the Call Center can attempt again to obtain CPA information from the HCP and/or Member.

        Business logic should be added to Salesforce to Reopen an Enrollment Case when the following is TRUE:
            A claim has been received for a Contact that has a previous Enrollment Case (trigger) in which
                Case “Status is “Outreach Completed”
                The Contact Drug “CPA Enrollment Status” is "Not on File

        Default original case to Default values
            Log Case Results:
                HCP Action required: Outreach Needed
                Status: Verify Fax Number

        Acceptance Criteria

        Submit a claim for a Contact that has a completed Enrollment Case in which
        - Case “Status is “Outreach Completed”
        - Contact Drug “CPA Enrollment Status” is "Not on File
        - Verify the system automatically creates a new Enrollment Case
         */

        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
        Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');

        Drug__c testDrug = new Drug__c();
        testDrug.J_Code__c = 'J5679';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;
/*
        Account accountInstance = new Account();
        accountInstance.Name='Test Account';
        insert accountInstance;

        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c =  System.today() - 20, //Post Go-Live Scenario
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;
*/
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        dailyClaimsTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        //Insert the initial claim that will be replaced.
        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'JG12380';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '1';
        dailyClaims.Claim_Segment__c = '00';
        //dailyClaims.Previous_Claim__c = ''; //On the Initial claim, UCK ID will be “Blank”
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5679';
        //dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Jane';
        dailyClaims.Patient_Last_Name__c = 'Doe';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');
        insert dailyClaims;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        Set<Id> claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        system.assertEquals(1,claimList.size());

        List<Case> originalEnrollmentCaseList = new List<Case>();
        List<Case> caseList = [SELECT Id, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name FROM Case WHERE Claim_Information__c IN : claimIdset];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Id =: caseList[0].Contact_Drug__c];
        for(Case caseRec: caseList)
        {
            //Update original Enrollment Case
            if(caseRec.RecordType.Name == 'Enrollment') {
                caseRec.Status = 'Outreach Completed';
                caseRec.HCP_Enrollment_Outreach__c = 'Outreach Complete';
                caseRec.Contact_Drug__r.Copay_Enrollment_Status__c = 'Not on File';
            }
            originalEnrollmentCaseList.add(caseRec);
            system.debug('Case records='+caseRec);

        }
        List<Contact_Drug__c> contactDrugListUpdated = new List<Contact_Drug__c>();
        for(Contact_Drug__c contactDrugRec: contactDrugList) {
            contactDrugRec.Copay_Enrollment_Status__c = 'Not on File';
            contactDrugListUpdated.add(contactDrugRec);
        }
        update contactDrugListUpdated;
        system.assertEquals(1,contactDrugList.size());
        //Cases from old claim should move to the new replacement claim
        system.assertEquals(2,caseList.size());

        update originalEnrollmentCaseList;

        List<Contact_Drug__c> enrollmentCaseContactDrugList = new List<Contact_Drug__c>();
        for(Contact_Drug__c contactDrgRec: contactDrugList) {
            contactDrgRec.Copay_Enrollment_Status__c = 'Not on File';
            enrollmentCaseContactDrugList.add(contactDrgRec);
        }

        update enrollmentCaseContactDrugList;

        //Replacement Daily Claim.
        dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Address_Line_2__c = 'BP Add L2';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'JG12380';
        //dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '1';
        dailyClaims.Claim_Segment__c = '01';
        //dailyClaims.Previous_Claim__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5679';
        //dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Jane';
        dailyClaims.Patient_Last_Name__c = 'Doe';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims;

        claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        caseList = [SELECT Id, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c FROM Case WHERE Claim_Information__c IN : claimIdset];
        Set<Id> contactDrugIds = new Set<Id>();
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                system.assertEquals('Outreach Needed',caseRec.HCP_Enrollment_Outreach__c);
                system.assertEquals('Verify Fax Number',caseRec.Status);
            }

        }
        contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Id IN :contactDrugIds];

        system.assertEquals(1,contactDrugList.size());
        system.assertEquals(2,claimList.size());

        //Cases from old claim should move to the new replacement claim
        system.assertEquals(3,caseList.size());
        Test.stopTest();
    }

    //Blank or null fields should be propagate downstream from Source Files.
    @IsTest
    private static void nullBlankFieldsTest() {
        Daily_Claim_JSONRequest requestDailyClaims;

        // Given
        Account accountInstance = new Account(
                //Id = mockAccountId,
                Name = 'Test Account'
        );
        insert accountInstance;
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);

        Drug__c drugInstance = new Drug__c(
                Name = 'Drug Test 1',
                //NDC__c = '123456789',
                J_Code__c = 'IPC02',
                Coding_Level__c = 'HCPCS'
        );
        insert drugInstance;

        NDC__c testNDC = new NDC__c(Drug__c = drugInstance.Id, Name = '123456789');
        insert testNDC;

        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Line__c = '1';
        claims.Claim_Segment__c = '01';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        //claims.Drug__c= testDrug.id;
        //insert claims;
        // List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c];
        //  system.assertEquals(1,claimList.size());

        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;

        Daily_Claim__c dailyClaims1 = new Daily_Claim__c();
        dailyClaims1.CSA_Account__c = 'AN0003';
        dailyClaims1.Units_Billed__c = 2;
        dailyClaims1.Amount_Paid_By_Primary__c = 100;
        dailyClaims1.Prior_Authorization__c = 'A123';
        dailyClaims1.Authorized_Representative__c = 'Jane Smith';
        dailyClaims1.Authorized_Relationship__c = '1';
        dailyClaims1.Billing_Provider_City__c = 'New York City';
        dailyClaims1.Billing_Provider_First_Name__c = 'Test';
        dailyClaims1.Billing_Provider_Last_Name__c = 'one';
        dailyClaims1.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims1.Billing_Provider_PIN__c = '1234567';
        dailyClaims1.Billing_Provider_State__c = 'NY';
        dailyClaims1.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims1.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims1.Billing_Provider_Phone__c = '5555555555';
        dailyClaims1.Billing_Provider_Fax__c = '9999999999';
        dailyClaims1.Primary_Claim_Number__c = 'JG12380';
        dailyClaims1.Claim_Code__c = 'Initial Claim';
        dailyClaims1.Claim_Line__c = '1';
        dailyClaims1.Claim_Segment__c = '00';
        dailyClaims1.Previous_Segment__c = ''; //The claim is the original claim
        dailyClaims1.COB_Code__c = 'Secondary';
        dailyClaims1.CSA_Control__c = 'CN0003';
        dailyClaims1.Days_Supply__c = 30;
        dailyClaims1.Diagnosis_Code__c = '12345678987';
        dailyClaims1.Drug_Label_Name__c = 'Drug One';
        dailyClaims1.HCPCS_Code__c = 'IPC02';
        dailyClaims1.NDC__c = '123456789';
        dailyClaims1.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims1.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims1.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims1.Patient_First_Name__c = 'Jane';
        dailyClaims1.Patient_Last_Name__c = 'Doe';
        dailyClaims1.Patient_Middle_Initial__c = 'H';
        dailyClaims1.Patient_Phone_Number__c = '8888888888';
        dailyClaims1.Patient_Gender__c = 'M';
        dailyClaims1.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims1.Preferred_Provider__c = 'Preferred';
        dailyClaims1.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims1.Service_Provider_Fax__c = '5555555555';
        dailyClaims1.Service_Provider_Phone__c = '7777777777';
        dailyClaims1.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims1.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims1.Service_Provider_City__c = 'Chicago';
        dailyClaims1.Service_Provider_First_Name__c = 'Jane';
        dailyClaims1.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims1.Service_Provider_NPI__c = '9998887776';
        //dailyClaims1.Service_Provider_Practice__c = 'NONE';
        dailyClaims1.Service_Provider_Zip__c = '10123';
        dailyClaims1.Service_Provider_State__c = 'NY';
        dailyClaims1.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims1.Patient_Address_Line_2__c = '';
        dailyClaims1.Patient_City__c = 'Los Angeles';
        dailyClaims1.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims1.Patient_State__c = 'NY';
        dailyClaims1.Patient_Zip_Code__c = '10151';
        dailyClaims1.CSA_Suffix__c = 'SN0003';
        dailyClaims1.Total_Coinsurance__c = 30;
        dailyClaims1.Total_Copay__c = 30;
        dailyClaims1.Total_Deductible__c = 500;
        dailyClaims1.Previous_Claim__c = '';
        dailyClaims1.Relationship_Code__c = 'M';
        //dailyClaims1.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims1;

        // When
        Test.startTest();

        Daily_Claim__c dailyClaims2 = new Daily_Claim__c();
        dailyClaims2.CSA_Account__c = 'AN0003';
        dailyClaims2.Units_Billed__c = 2;
        dailyClaims2.Amount_Paid_By_Primary__c = 100;
        dailyClaims2.Prior_Authorization__c = 'A123';
        dailyClaims2.Authorized_Representative__c = 'Jane Smith';
        dailyClaims2.Authorized_Relationship__c = '1';
        dailyClaims2.Billing_Provider_City__c = 'New York City';
        dailyClaims2.Billing_Provider_First_Name__c = 'Test';
        dailyClaims2.Billing_Provider_Last_Name__c = 'one';
        dailyClaims2.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims2.Billing_Provider_PIN__c = '1234567';
        dailyClaims2.Billing_Provider_State__c = 'NY';
        dailyClaims2.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims2.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims2.Billing_Provider_Phone__c = '5555555555';
        dailyClaims2.Billing_Provider_Fax__c = '9999999999';
        dailyClaims2.Primary_Claim_Number__c = 'JG12380';
        dailyClaims2.Claim_Code__c = '';
        dailyClaims2.Claim_Line__c = '1';
        dailyClaims2.Claim_Segment__c = '01';
        dailyClaims2.Previous_Segment__c = '00';
        dailyClaims2.COB_Code__c = 'Secondary';
        dailyClaims2.CSA_Control__c = 'CN0003';
        dailyClaims2.Days_Supply__c = 30;
        dailyClaims2.Diagnosis_Code__c = '12345678987';
        dailyClaims2.Drug_Label_Name__c = 'Drug One';
        dailyClaims2.HCPCS_Code__c = 'IPC02';
        dailyClaims2.NDC__c = '123456789';
        dailyClaims2.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims2.Patient_Birth_Date__c = null;
        //dailyClaims2.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims2.Patient_First_Name__c = '';
        dailyClaims2.Patient_Last_Name__c = '';
        dailyClaims2.Patient_Middle_Initial__c = '';
        dailyClaims2.Patient_Phone_Number__c = '';
        dailyClaims2.Patient_Gender__c = 'M';
        dailyClaims2.Plan_Sponsor_Name__c = '';
        dailyClaims2.Preferred_Provider__c = 'Preferred';
        dailyClaims2.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims2.Service_Provider_Fax__c = '5555555555';
        dailyClaims2.Service_Provider_Phone__c = '7777777777';
        dailyClaims2.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims2.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims2.Service_Provider_City__c = 'Chicago';
        dailyClaims2.Service_Provider_First_Name__c = 'Jane';
        dailyClaims2.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims2.Service_Provider_NPI__c = '9998887776';
        //dailyClaims2.Service_Provider_Practice__c = 'NONE';
        dailyClaims2.Service_Provider_Zip__c = '10123';
        dailyClaims2.Service_Provider_State__c = 'NY';
        dailyClaims2.Patient_Address_Line_1__c = '';
        dailyClaims2.Patient_Address_Line_2__c = '';
        dailyClaims2.Patient_City__c = '';
        dailyClaims2.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims2.Patient_State__c = '';
        dailyClaims2.Patient_Zip_Code__c = '';
        dailyClaims2.CSA_Suffix__c = 'SN0003';
        dailyClaims2.Total_Coinsurance__c = 30;
        dailyClaims2.Total_Copay__c = 30;
        dailyClaims2.Total_Deductible__c = 500;
        dailyClaims2.Previous_Claim__c = '';
        dailyClaims2.Relationship_Code__c = '';
        //dailyClaims2.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims2;

        // Then
        //The Relationship_Code, Plan Sppon
        Contact contactRec = [SELECT Id, Relationship_Code__c, Relationship__c, Plan_Sponsor_Unique_ID__c, Patient_Birth_Date__c, FirstName,
                                LastName, MiddleName, Patient_Phone_Number__c, Patient_Gender__c, MailingStreet,
                                MailingCity, MailingState, MailingPostalCode FROM Contact LIMIT 1];

        System.assertEquals(date.valueOf('1990-01-01'), contactRec.Patient_Birth_Date__c);
        System.assertEquals('Jane', contactRec.FirstName);
        System.assertEquals('Doe', contactRec.LastName);
        System.assertEquals('H', contactRec.MiddleName);
        System.assertEquals('8888888888', contactRec.Patient_Phone_Number__c);
        System.assertEquals('M', contactRec.Patient_Gender__c);
        System.assertEquals('123 Sesame Street', contactRec.MailingStreet);
        System.assertEquals('Los Angeles', contactRec.MailingCity);
        System.assertEquals('NY', contactRec.MailingState);
        System.assertEquals('10151', contactRec.MailingPostalCode);
        System.assertEquals('M', contactRec.Relationship_Code__c);

        Test.stopTest();
    }

    //MBP-614 Update Case only for new Service From Date
    @IsTest
    private static void mostRecentServiceFromDateDailyClaimTest() {
        Daily_Claim_JSONRequest requestDailyClaims;

        // Given
        Account accountInstance = new Account(
                //Id = mockAccountId,
                Name = 'Test Account'
        );
        insert accountInstance;
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);

        Drug__c drugInstance = new Drug__c(
                Name = 'Drug Test 1',
                //NDC__c = '123456789',
                J_Code__c = 'IPC02',
                Coding_Level__c = 'HCPCS'
        );
        insert drugInstance;

        NDC__c testNDC = new NDC__c(Drug__c = drugInstance.Id, Name = '123456789');
        insert testNDC;

        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Line__c = '1';
        claims.Claim_Segment__c = '01';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        //claims.Drug__c= testDrug.id;
        //insert claims;
        // List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c];
        //  system.assertEquals(1,claimList.size());

        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;

        Daily_Claim__c dailyClaims1 = new Daily_Claim__c();
        dailyClaims1.CSA_Account__c = 'AN0003';
        dailyClaims1.Units_Billed__c = 2;
        dailyClaims1.Amount_Paid_By_Primary__c = 100;
        dailyClaims1.Prior_Authorization__c = 'A123';
        dailyClaims1.Authorized_Representative__c = 'Jane Smith';
        dailyClaims1.Authorized_Relationship__c = '1';
        dailyClaims1.Billing_Provider_City__c = 'New York City';
        dailyClaims1.Billing_Provider_First_Name__c = 'Test';
        dailyClaims1.Billing_Provider_Last_Name__c = 'one';
        dailyClaims1.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims1.Billing_Provider_PIN__c = '1234567';
        dailyClaims1.Billing_Provider_State__c = 'NY';
        dailyClaims1.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims1.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims1.Billing_Provider_Phone__c = '5555555555';
        dailyClaims1.Billing_Provider_Fax__c = '9999999999';
        dailyClaims1.Primary_Claim_Number__c = 'JG12380';
        dailyClaims1.Claim_Code__c = 'Initial Claim';
        dailyClaims1.Claim_Line__c = '1';
        dailyClaims1.Claim_Segment__c = '00';
        dailyClaims1.Previous_Segment__c = ''; //The claim is the original claim
        dailyClaims1.COB_Code__c = 'Secondary';
        dailyClaims1.CSA_Control__c = 'CN0003';
        dailyClaims1.Days_Supply__c = 30;
        dailyClaims1.Diagnosis_Code__c = '12345678987';
        dailyClaims1.Drug_Label_Name__c = 'Drug One';
        dailyClaims1.HCPCS_Code__c = 'IPC02';
        dailyClaims1.NDC__c = '123456789';
        dailyClaims1.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims1.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims1.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims1.Patient_First_Name__c = 'Jane';
        dailyClaims1.Patient_Last_Name__c = 'Doe';
        dailyClaims1.Patient_Middle_Initial__c = 'H';
        dailyClaims1.Patient_Phone_Number__c = '8888888888';
        dailyClaims1.Patient_Gender__c = 'M';
        dailyClaims1.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims1.Preferred_Provider__c = 'Preferred';
        dailyClaims1.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims1.Service_Provider_Fax__c = '5555555555';
        dailyClaims1.Service_Provider_Phone__c = '7777777777';
        dailyClaims1.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims1.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims1.Service_Provider_City__c = 'Chicago';
        dailyClaims1.Service_Provider_First_Name__c = 'Jane';
        dailyClaims1.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims1.Service_Provider_NPI__c = '9998887776';
        //dailyClaims1.Service_Provider_Practice__c = 'NONE';
        dailyClaims1.Service_Provider_Zip__c = '10123';
        dailyClaims1.Service_Provider_State__c = 'NY';
        dailyClaims1.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims1.Patient_Address_Line_2__c = '';
        dailyClaims1.Patient_City__c = 'Los Angeles';
        dailyClaims1.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims1.Patient_State__c = 'NY';
        dailyClaims1.Patient_Zip_Code__c = '10151';
        dailyClaims1.CSA_Suffix__c = 'SN0003';
        dailyClaims1.Total_Coinsurance__c = 30;
        dailyClaims1.Total_Copay__c = 30;
        dailyClaims1.Total_Deductible__c = 500;
        dailyClaims1.Previous_Claim__c = '';
        dailyClaims1.Relationship_Code__c = 'M';
        //dailyClaims1.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims1;

        // When
        Test.startTest();

        Daily_Claim__c dailyClaims2 = new Daily_Claim__c();
        dailyClaims2.CSA_Account__c = 'AN0003';
        dailyClaims2.Units_Billed__c = 2;
        dailyClaims2.Amount_Paid_By_Primary__c = 100;
        dailyClaims2.Prior_Authorization__c = 'A123';
        dailyClaims2.Authorized_Representative__c = 'Jane Smith';
        dailyClaims2.Authorized_Relationship__c = '1';
        dailyClaims2.Billing_Provider_City__c = 'New York City';
        dailyClaims2.Billing_Provider_First_Name__c = 'Test';
        dailyClaims2.Billing_Provider_Last_Name__c = 'one';
        dailyClaims2.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims2.Billing_Provider_PIN__c = '1234567';
        dailyClaims2.Billing_Provider_State__c = 'NY';
        dailyClaims2.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims2.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims2.Billing_Provider_Phone__c = '5555555555';
        dailyClaims2.Billing_Provider_Fax__c = '9999999999';
        dailyClaims2.Primary_Claim_Number__c = 'JG12380';
        dailyClaims2.Claim_Code__c = '';
        dailyClaims2.Claim_Line__c = '1';
        dailyClaims2.Claim_Segment__c = '01';
        dailyClaims2.Previous_Segment__c = '00';
        dailyClaims2.COB_Code__c = 'Secondary';
        dailyClaims2.CSA_Control__c = 'CN0003';
        dailyClaims2.Days_Supply__c = 30;
        dailyClaims2.Diagnosis_Code__c = '12345678987';
        dailyClaims2.Drug_Label_Name__c = 'Drug One';
        dailyClaims2.HCPCS_Code__c = 'IPC02';
        dailyClaims2.NDC__c = '123456789';
        dailyClaims2.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims2.Patient_Birth_Date__c = null;
        //dailyClaims2.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims2.Patient_First_Name__c = '';
        dailyClaims2.Patient_Last_Name__c = '';
        dailyClaims2.Patient_Middle_Initial__c = '';
        dailyClaims2.Patient_Phone_Number__c = '';
        dailyClaims2.Patient_Gender__c = 'M';
        dailyClaims2.Plan_Sponsor_Name__c = '';
        dailyClaims2.Preferred_Provider__c = 'Preferred';
        dailyClaims2.Date_Of_Service_From__c = date.valueOf('2022-07-21');
        dailyClaims2.Service_Provider_Fax__c = '5555555555';
        dailyClaims2.Service_Provider_Phone__c = '7777777777';
        dailyClaims2.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims2.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims2.Service_Provider_City__c = 'Chicago';
        dailyClaims2.Service_Provider_First_Name__c = 'Jane';
        dailyClaims2.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims2.Service_Provider_NPI__c = '9998887776';
        //dailyClaims2.Service_Provider_Practice__c = 'NONE';
        dailyClaims2.Service_Provider_Zip__c = '10123';
        dailyClaims2.Service_Provider_State__c = 'NY';
        dailyClaims2.Patient_Address_Line_1__c = '';
        dailyClaims2.Patient_Address_Line_2__c = '';
        dailyClaims2.Patient_City__c = '';
        dailyClaims2.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims2.Patient_State__c = '';
        dailyClaims2.Patient_Zip_Code__c = '';
        dailyClaims2.CSA_Suffix__c = 'SN0003';
        dailyClaims2.Total_Coinsurance__c = 30;
        dailyClaims2.Total_Copay__c = 30;
        dailyClaims2.Total_Deductible__c = 500;
        dailyClaims2.Previous_Claim__c = '';
        dailyClaims2.Relationship_Code__c = '';
        //dailyClaims2.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims2;

        // Then
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        Set<Id> claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId,
                                        RecordType.Name, HCP_Enrollment_Outreach__c, Claim_Information__r.Date_Of_Service_From__c
                                FROM Case WHERE Claim_Information__c IN : claimIdset];
        Set<Id> contactDrugIds = new Set<Id>();
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
                system.assertEquals(date.valueOf('2022-07-21'),caseRec.Claim_Information__r.Date_Of_Service_From__c, 'Case linked to Most Recent Claim is not correct');
            }

        }

    }

    //MBP-907: Claim Status equals "Adjustment" and the claim doesn’t have a CPA Indicator or a CPA amount. - Error Log Description "Claim Adjustment error"
    @IsTest
    private static void errorLogClaimAdjustmentErrorTest() {
        Daily_Claim_JSONRequest requestDailyClaims;

        // Given
        Account accountInstance = new Account(
                //Id = mockAccountId,
                Name = 'Test Account'
        );
        insert accountInstance;
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);

        Drug__c drugInstance = new Drug__c(
                Name = 'Drug Test 1',
                //NDC__c = '123456789',
                J_Code__c = 'IPC02',
                Coding_Level__c = 'HCPCS'
        );
        insert drugInstance;

        NDC__c testNDC = new NDC__c(Drug__c = drugInstance.Id, Name = '123456789');
        insert testNDC;

        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Line__c = '1';
        claims.Claim_Segment__c = '01';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        //claims.Drug__c= testDrug.id;
        //insert claims;
        // List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c];
        //  system.assertEquals(1,claimList.size());

        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;

        Daily_Claim__c dailyClaims1 = new Daily_Claim__c();
        dailyClaims1.CSA_Account__c = 'AN0003';
        dailyClaims1.Units_Billed__c = 2;
        dailyClaims1.Amount_Paid_By_Primary__c = 100;
        dailyClaims1.Prior_Authorization__c = 'A123';
        dailyClaims1.Authorized_Representative__c = 'Jane Smith';
        dailyClaims1.Authorized_Relationship__c = '1';
        dailyClaims1.Billing_Provider_City__c = 'New York City';
        dailyClaims1.Billing_Provider_First_Name__c = 'Test';
        dailyClaims1.Billing_Provider_Last_Name__c = 'one';
        dailyClaims1.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims1.Billing_Provider_PIN__c = '1234567';
        dailyClaims1.Billing_Provider_State__c = 'NY';
        dailyClaims1.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims1.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims1.Billing_Provider_Phone__c = '5555555555';
        dailyClaims1.Billing_Provider_Fax__c = '9999999999';
        dailyClaims1.Primary_Claim_Number__c = 'JG12380';
        dailyClaims1.Claim_Code__c = 'A';
        dailyClaims1.Claim_Line__c = '1';
        dailyClaims1.Claim_Segment__c = '00';
        dailyClaims1.Previous_Segment__c = ''; //The claim is the original claim
        dailyClaims1.COB_Code__c = 'Secondary';
        dailyClaims1.CSA_Control__c = 'CN0003';
        dailyClaims1.Days_Supply__c = 30;
        dailyClaims1.Diagnosis_Code__c = '12345678987';
        dailyClaims1.Drug_Label_Name__c = 'Drug One';
        dailyClaims1.HCPCS_Code__c = 'IPC02';
        dailyClaims1.NDC__c = '123456789';
        dailyClaims1.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims1.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims1.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims1.Patient_First_Name__c = 'Jane';
        dailyClaims1.Patient_Last_Name__c = 'Doe';
        dailyClaims1.Patient_Middle_Initial__c = 'H';
        dailyClaims1.Patient_Phone_Number__c = '8888888888';
        dailyClaims1.Patient_Gender__c = 'M';
        dailyClaims1.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims1.Preferred_Provider__c = 'Preferred';
        dailyClaims1.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims1.Service_Provider_Fax__c = '5555555555';
        dailyClaims1.Service_Provider_Phone__c = '7777777777';
        dailyClaims1.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims1.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims1.Service_Provider_City__c = 'Chicago';
        dailyClaims1.Service_Provider_First_Name__c = 'Jane';
        dailyClaims1.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims1.Service_Provider_NPI__c = '9998887776';
        //dailyClaims1.Service_Provider_Practice__c = 'NONE';
        dailyClaims1.Service_Provider_Zip__c = '10123';
        dailyClaims1.Service_Provider_State__c = 'NY';
        dailyClaims1.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims1.Patient_Address_Line_2__c = '';
        dailyClaims1.Patient_City__c = 'Los Angeles';
        dailyClaims1.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims1.Patient_State__c = 'NY';
        dailyClaims1.Patient_Zip_Code__c = '10151';
        dailyClaims1.CSA_Suffix__c = 'SN0003';
        dailyClaims1.Total_Coinsurance__c = 30;
        dailyClaims1.Total_Copay__c = 30;
        dailyClaims1.Total_Deductible__c = 500;
        dailyClaims1.Previous_Claim__c = '';
        dailyClaims1.Relationship_Code__c = 'M';
        //dailyClaims1.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims1;

        // When
        Test.startTest();

        Daily_Claim__c dailyClaims2 = new Daily_Claim__c();
        dailyClaims2.CSA_Account__c = 'AN0003';
        dailyClaims2.Units_Billed__c = 2;
        dailyClaims2.Amount_Paid_By_Primary__c = 100;
        dailyClaims2.Prior_Authorization__c = 'A123';
        dailyClaims2.Authorized_Representative__c = 'Jane Smith';
        dailyClaims2.Authorized_Relationship__c = '1';
        dailyClaims2.Billing_Provider_City__c = 'New York City';
        dailyClaims2.Billing_Provider_First_Name__c = 'Test';
        dailyClaims2.Billing_Provider_Last_Name__c = 'one';
        dailyClaims2.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims2.Billing_Provider_PIN__c = '1234567';
        dailyClaims2.Billing_Provider_State__c = 'NY';
        dailyClaims2.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims2.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims2.Billing_Provider_Phone__c = '5555555555';
        dailyClaims2.Billing_Provider_Fax__c = '9999999999';
        dailyClaims2.Primary_Claim_Number__c = 'JG12380';
        dailyClaims2.Claim_Code__c = 'A';
        dailyClaims2.Claim_Line__c = '1';
        dailyClaims2.Claim_Segment__c = '01';
        dailyClaims2.Previous_Segment__c = '00';
        dailyClaims2.COB_Code__c = 'Secondary';
        dailyClaims2.CSA_Control__c = 'CN0003';
        dailyClaims2.Days_Supply__c = 30;
        dailyClaims2.Diagnosis_Code__c = '12345678987';
        dailyClaims2.Drug_Label_Name__c = 'Drug One';
        dailyClaims2.HCPCS_Code__c = 'IPC02';
        dailyClaims2.NDC__c = '123456789';
        dailyClaims2.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims2.Patient_Birth_Date__c = null;
        //dailyClaims2.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims2.Patient_First_Name__c = '';
        dailyClaims2.Patient_Last_Name__c = '';
        dailyClaims2.Patient_Middle_Initial__c = '';
        dailyClaims2.Patient_Phone_Number__c = '';
        dailyClaims2.Patient_Gender__c = 'M';
        dailyClaims2.Plan_Sponsor_Name__c = '';
        dailyClaims2.Preferred_Provider__c = 'Preferred';
        dailyClaims2.Date_Of_Service_From__c = date.valueOf('2022-07-21');
        dailyClaims2.Service_Provider_Fax__c = '5555555555';
        dailyClaims2.Service_Provider_Phone__c = '7777777777';
        dailyClaims2.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims2.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims2.Service_Provider_City__c = 'Chicago';
        dailyClaims2.Service_Provider_First_Name__c = 'Jane';
        dailyClaims2.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims2.Service_Provider_NPI__c = '9998887776';
        //dailyClaims2.Service_Provider_Practice__c = 'NONE';
        dailyClaims2.Service_Provider_Zip__c = '10123';
        dailyClaims2.Service_Provider_State__c = 'NY';
        dailyClaims2.Patient_Address_Line_1__c = '';
        dailyClaims2.Patient_Address_Line_2__c = '';
        dailyClaims2.Patient_City__c = '';
        dailyClaims2.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims2.Patient_State__c = '';
        dailyClaims2.Patient_Zip_Code__c = '';
        dailyClaims2.CSA_Suffix__c = 'SN0003';
        dailyClaims2.Total_Coinsurance__c = 30;
        dailyClaims2.Total_Copay__c = 30;
        dailyClaims2.Total_Deductible__c = 500;
        dailyClaims2.Previous_Claim__c = '';
        dailyClaims2.Relationship_Code__c = '';
        //dailyClaims2.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims2;

        // Then
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        Set<Id> claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId,
                RecordType.Name, HCP_Enrollment_Outreach__c, Claim_Information__r.Date_Of_Service_From__c
        FROM Case WHERE Claim_Information__c IN : claimIdset];
        Set<Id> contactDrugIds = new Set<Id>();
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
                //system.assertEquals(date.valueOf('2022-07-21'),caseRec.Claim_Information__r.Date_Of_Service_From__c, 'Case linked to Most Recent Claim is not correct');
            }

        }

        // Run ErrorLogJob
        ErrorLogJob job = new ErrorLogJob();
        Id jobid= Database.executeBatch(job, 200);

        Test.stopTest();

        /*
        List<Error_Log__c> errorLogs = [SELECT Id, Method__c, Daily_Claim__c, Historical_Claim__c, Prior_Auth__c, Historical_Prior_Auth__c FROM Error_Log__c];
        List<Daily_Claim__c> dailyClaimsList = [SELECT Id, Status__c, Error_Log__c FROM Daily_Claim__c WHERE Id =: errorLogs[0].Daily_Claim__c LIMIT 1];
        System.debug('dailyClaimsList[0].Id = ' + dailyClaimsList[0].Id);
        system.assertequals('Error', dailyClaimsList[0].Status__c);
        system.assertequals('Claim Adjustment Error.', dailyClaimsList[0].Error_Log__c);
        */
    }

    @IsTest
    private static void mostRecentServiceFromDateHistoricalClaimTest() {
        Daily_Claim_JSONRequest requestDailyClaims;

        // Given
        Account accountInstance = new Account(
                //Id = mockAccountId,
                Name = 'Test Account'
        );
        insert accountInstance;
        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);

        Drug__c drugInstance = new Drug__c(
                Name = 'Drug Test 1',
                //NDC__c = '123456789',
                J_Code__c = 'IPC02',
                Coding_Level__c = 'HCPCS'
        );
        insert drugInstance;

        NDC__c testNDC = new NDC__c(Drug__c = drugInstance.Id, Name = '123456789');
        insert testNDC;

        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Line__c = '1';
        claims.Claim_Segment__c = '01';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        //claims.Drug__c= testDrug.id;
        //insert claims;
        // List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c];
        //  system.assertEquals(1,claimList.size());

        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;

        Historical_Claim__c historicalClaimClaim1 = new Historical_Claim__c();
        historicalClaimClaim1.CSA_Account__c = 'AN0003';
        historicalClaimClaim1.Units_Billed__c = 2;
        historicalClaimClaim1.Amount_Paid_By_Primary__c = 100;
        //historicalClaimClaim1.Prior_Authorization__c = 'A123';
        //historicalClaimClaim1.Authorized_Representative__c = 'Jane Smith';
        //historicalClaimClaim1.Authorized_Relationship__c = '1';
        historicalClaimClaim1.Billing_Provider_City__c = 'New York City';
        historicalClaimClaim1.Billing_Provider_First_Name__c = 'Test';
        historicalClaimClaim1.Billing_Provider_Last_Name__c = 'one';
        historicalClaimClaim1.Billing_Provider_Specialty__c = 'Specialty 1';
        historicalClaimClaim1.Billing_Provider_PIN__c = '1234567';
        historicalClaimClaim1.Billing_Provider_State__c = 'NY';
        historicalClaimClaim1.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        historicalClaimClaim1.Billing_Provider_Zip_Code__c = '10123';
        historicalClaimClaim1.Billing_Provider_Phone__c = '5555555555';
        historicalClaimClaim1.Billing_Provider_Fax__c = '9999999999';
        historicalClaimClaim1.Primary_Claim_Number__c = 'JG12380';
        //historicalClaimClaim1.Claim_Code__c = 'Initial Claim';
        historicalClaimClaim1.Claim_Line__c = '1';
        //historicalClaimClaim1.Claim_Segment__c = '00';
        //historicalClaimClaim1.Previous_Segment__c = ''; //The claim is the original claim
        historicalClaimClaim1.COB_Code__c = 'Secondary';
        historicalClaimClaim1.CSA_Control__c = 'CN0003';
        //historicalClaimClaim1.Days_Supply__c = 30;
        historicalClaimClaim1.Diagnosis_Code__c = '12345678987';
        historicalClaimClaim1.Drug_Label_Name__c = 'Drug One';
        historicalClaimClaim1.HCPCS_Code__c = 'IPC02';
        historicalClaimClaim1.NDC__c = '123456789';
        historicalClaimClaim1.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        historicalClaimClaim1.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //historicalClaimClaim1.Patient_Email_Address__c = 'jsmith@test.com';
        historicalClaimClaim1.Patient_First_Name__c = 'Jane';
        historicalClaimClaim1.Patient_Last_Name__c = 'Doe';
        historicalClaimClaim1.Patient_Middle_Initial__c = 'H';
        historicalClaimClaim1.Patient_Phone_Number__c = '8888888888';
        historicalClaimClaim1.Patient_Gender__c = 'M';
        historicalClaimClaim1.Plan_Sponsor_Name__c = 'Sample Company';
        historicalClaimClaim1.Preferred_Provider__c = 'Preferred';
        historicalClaimClaim1.Date_Of_Service_From__c = date.valueOf('2022-07-21');
        historicalClaimClaim1.Service_Provider_Fax__c = '5555555555';
        historicalClaimClaim1.Service_Provider_Phone__c = '7777777777';
        historicalClaimClaim1.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        historicalClaimClaim1.Service_Provider_Address_Line_1__c = '456 plane Lane';
        historicalClaimClaim1.Service_Provider_City__c = 'Chicago';
        historicalClaimClaim1.Service_Provider_First_Name__c = 'Jane';
        historicalClaimClaim1.Service_Provider_Last_Name__c = 'Doe';
        historicalClaimClaim1.Service_Provider_NPI__c = '9998887776';
        //historicalClaimClaim1.Service_Provider_Practice__c = 'NONE';
        historicalClaimClaim1.Service_Provider_Zip__c = '10123';
        historicalClaimClaim1.Service_Provider_State__c = 'NY';
        historicalClaimClaim1.Patient_Address_Line_1__c = '123 Sesame Street';
        historicalClaimClaim1.Patient_Address_Line_2__c = '';
        historicalClaimClaim1.Patient_City__c = 'Los Angeles';
        historicalClaimClaim1.Patient_CUMB_ID__c = 'W12345678';
        historicalClaimClaim1.Patient_State__c = 'NY';
        historicalClaimClaim1.Patient_Zip_Code__c = '10151';
        historicalClaimClaim1.CSA_Suffix__c = 'SN0003';
        historicalClaimClaim1.Total_Coinsurance__c = 30;
        historicalClaimClaim1.Total_Copay__c = 30;
        historicalClaimClaim1.Total_Deductible__c = 500;
        //historicalClaimClaim1.Previous_Claim__c = '';
        historicalClaimClaim1.Relationship_Code__c = 'M';
        //historicalClaimClaim1.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert historicalClaimClaim1;

        // When
        Test.startTest();
/*
        Daily_Claim__c historicalClaimClaim2 = new Daily_Claim__c();
        historicalClaimClaim2.CSA_Account__c = 'AN0003';
        historicalClaimClaim2.Units_Billed__c = 2;
        historicalClaimClaim2.Amount_Paid_By_Primary__c = 100;
        historicalClaimClaim2.Prior_Authorization__c = 'A123';
        historicalClaimClaim2.Authorized_Representative__c = 'Jane Smith';
        historicalClaimClaim2.Authorized_Relationship__c = '1';
        historicalClaimClaim2.Billing_Provider_City__c = 'New York City';
        historicalClaimClaim2.Billing_Provider_First_Name__c = 'Test';
        historicalClaimClaim2.Billing_Provider_Last_Name__c = 'one';
        historicalClaimClaim2.Billing_Provider_Specialty__c = 'Specialty 1';
        historicalClaimClaim2.Billing_Provider_PIN__c = '1234567';
        historicalClaimClaim2.Billing_Provider_State__c = 'NY';
        historicalClaimClaim2.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        historicalClaimClaim2.Billing_Provider_Zip_Code__c = '10123';
        historicalClaimClaim2.Billing_Provider_Phone__c = '5555555555';
        historicalClaimClaim2.Billing_Provider_Fax__c = '9999999999';
        historicalClaimClaim2.Primary_Claim_Number__c = 'JG12380';
        historicalClaimClaim2.Claim_Code__c = '';
        historicalClaimClaim2.Claim_Line__c = '1';
        historicalClaimClaim2.Claim_Segment__c = '01';
        historicalClaimClaim2.Previous_Segment__c = '00';
        historicalClaimClaim2.COB_Code__c = 'Secondary';
        historicalClaimClaim2.CSA_Control__c = 'CN0003';
        historicalClaimClaim2.Days_Supply__c = 30;
        historicalClaimClaim2.Diagnosis_Code__c = '12345678987';
        historicalClaimClaim2.Drug_Label_Name__c = 'Drug One';
        historicalClaimClaim2.HCPCS_Code__c = 'IPC02';
        historicalClaimClaim2.NDC__c = '123456789';
        historicalClaimClaim2.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        historicalClaimClaim2.Patient_Birth_Date__c = null;
        //historicalClaimClaim2.Patient_Email_Address__c = 'jsmith@test.com';
        historicalClaimClaim2.Patient_First_Name__c = '';
        historicalClaimClaim2.Patient_Last_Name__c = '';
        historicalClaimClaim2.Patient_Middle_Initial__c = '';
        historicalClaimClaim2.Patient_Phone_Number__c = '';
        historicalClaimClaim2.Patient_Gender__c = 'Male';
        historicalClaimClaim2.Plan_Sponsor_Name__c = '';
        historicalClaimClaim2.Preferred_Provider__c = 'Preferred';
        historicalClaimClaim2.Date_Of_Service_From__c = date.valueOf('2022-07-21');
        historicalClaimClaim2.Service_Provider_Fax__c = '5555555555';
        historicalClaimClaim2.Service_Provider_Phone__c = '7777777777';
        historicalClaimClaim2.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        historicalClaimClaim2.Service_Provider_Address_Line_1__c = '456 plane Lane';
        historicalClaimClaim2.Service_Provider_City__c = 'Chicago';
        historicalClaimClaim2.Service_Provider_First_Name__c = 'Jane';
        historicalClaimClaim2.Service_Provider_Last_Name__c = 'Doe';
        historicalClaimClaim2.Service_Provider_NPI__c = '9998887776';
        //historicalClaimClaim2.Service_Provider_Practice__c = 'NONE';
        historicalClaimClaim2.Service_Provider_Zip__c = '10123';
        historicalClaimClaim2.Service_Provider_State__c = 'NY';
        historicalClaimClaim2.Patient_Address_Line_1__c = '';
        historicalClaimClaim2.Patient_Address_Line_2__c = '';
        historicalClaimClaim2.Patient_City__c = '';
        historicalClaimClaim2.Patient_CUMB_ID__c = 'W12345678';
        historicalClaimClaim2.Patient_State__c = '';
        historicalClaimClaim2.Patient_Zip_Code__c = '';
        historicalClaimClaim2.CSA_Suffix__c = 'SN0003';
        historicalClaimClaim2.Total_Coinsurance__c = 30;
        historicalClaimClaim2.Total_Copay__c = 30;
        historicalClaimClaim2.Total_Deductible__c = 500;
        historicalClaimClaim2.Previous_Claim__c = '';
        historicalClaimClaim2.Relationship_Code__c = '';
        //historicalClaimClaim2.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert historicalClaimClaim2;
*/
        // Then
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        Set<Id> claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId,
                                        RecordType.Name, HCP_Enrollment_Outreach__c, Claim_Information__r.Date_Of_Service_From__c
                                FROM Case WHERE Claim_Information__c IN : claimIdset];
        Set<Id> contactDrugIds = new Set<Id>();
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
                system.assertEquals(date.valueOf('2022-07-21'),caseRec.Claim_Information__r.Date_Of_Service_From__c, 'Case linked to Most Recent Claim is not correct');
            }

        }

        Test.stopTest();
    }

    //MBP-776 Duplicate Enrollment Case
    @isTest
    public static void DC_OneEnrollmentCase()
    {
        /*

         */

        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
        Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');

        Drug__c testDrug = new Drug__c();
        testDrug.Name = 'Test Drug 1';
        testDrug.J_Code__c = 'J5679';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;
/*
        Account accountInstance = new Account();
        accountInstance.Name='Test Account';
        insert accountInstance;

        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c =  System.today() - 20, //Post Go-Live Scenario
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;
*/
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        dailyClaimsTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        //Insert the initial claim that will be replaced.
        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Claim_Code__c = 'O';
        dailyClaims.Primary_Claim_Number__c = 'JG12380';
        dailyClaims.Claim_Line__c = '1';
        dailyClaims.Claim_Segment__c = '00';
        //dailyClaims.Previous_Claim__c = ''; //On the Initial claim, UCK ID will be “Blank”
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5679RT';
        //dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Jane';
        dailyClaims.Patient_Last_Name__c = 'Doe';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');
        insert dailyClaims;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        Set<Id> claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        system.assertEquals(1,claimList.size());

        List<Case> originalEnrollmentCaseList = new List<Case>();
        List<Case> caseList = [SELECT Id, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name FROM Case WHERE Claim_Information__c IN : claimIdset];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Id =: caseList[0].Contact_Drug__c];
        for(Case caseRec: caseList)
        {
            //Update original Enrollment Case
            if(caseRec.RecordType.Name == 'Enrollment') {
                caseRec.Status = 'Outreach Completed';
                caseRec.HCP_Enrollment_Outreach__c = 'Outreach Complete';
                caseRec.Contact_Drug__r.Copay_Enrollment_Status__c = 'Not on File';
            }
            originalEnrollmentCaseList.add(caseRec);
            system.debug('Case records='+caseRec);

        }
        List<Contact_Drug__c> contactDrugListUpdated = new List<Contact_Drug__c>();
        for(Contact_Drug__c contactDrugRec: contactDrugList) {
            contactDrugRec.Copay_Enrollment_Status__c = 'Not on File';
            contactDrugListUpdated.add(contactDrugRec);
        }
        update contactDrugListUpdated;
        system.assertEquals(1,contactDrugList.size());
        //Cases from old claim should move to the new replacement claim
        system.assertEquals(2,caseList.size());

        update originalEnrollmentCaseList;

        List<Contact_Drug__c> enrollmentCaseContactDrugList = new List<Contact_Drug__c>();
        for(Contact_Drug__c contactDrgRec: contactDrugList) {
            contactDrgRec.Copay_Enrollment_Status__c = 'Not on File';
            enrollmentCaseContactDrugList.add(contactDrgRec);
        }

        update enrollmentCaseContactDrugList;

        Daily_Claim__c dailyClaim = [SELECT Status__c, Drug_Label_Name__c FROM Daily_Claim__c WHERE Id =: dailyClaims.Id LIMIT 1];
        //System.assertEquals(testDrug.Name, dailyClaim.Drug_Label_Name__c, 'Drug label name should match test drug name.');

                //Replacement Daily Claim.
        dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'JG12380';
        //dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '3';
        dailyClaims.Claim_Segment__c = '00';
        //dailyClaims.Previous_Claim__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5679RT';
        //dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Jane';
        dailyClaims.Patient_Last_Name__c = 'Doe';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims;

        claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        caseList = [SELECT Id, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
                    FROM Case
                    WHERE RecordType.Name = 'Enrollment' AND Claim_Information__c IN : claimIdset];
        Set<Id> contactDrugIds = new Set<Id>();
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                system.assertEquals('Outreach Needed',caseRec.HCP_Enrollment_Outreach__c);
                system.assertEquals('Verify Fax Number',caseRec.Status);
            }

        }
        contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Id IN :contactDrugIds];

        system.assertEquals(1,contactDrugList.size());
        system.assertEquals(2,claimList.size());

        //Should only have 1 Enrollment Cases
        system.assertEquals(1,caseList.size());
        Test.stopTest();
    }

    //MBP-953: Create SF logic to ingest claims marked as Original as they are regardless of segment
    /*
    ADO-678: Removing this test method as this logic no longer exists as per this story
    @isTest
    public static void DC_NoPreviousSegButCreateNewClaim()
    {
        
        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
        Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');

        Drug__c testDrug = new Drug__c();
        testDrug.Name = 'Test Drug 1';
        testDrug.J_Code__c = 'J5679';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;

        Account accountInstance = new Account();
        accountInstance.Name='Test Account';
        insert accountInstance;

        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c =  System.today() - 20, //Post Go-Live Scenario
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;

        //Insert the initial claim that will be replaced.
        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Claim_Code__c = 'O';
        dailyClaims.Primary_Claim_Number__c = 'JG12380';
        dailyClaims.Claim_Line__c = '1';
        dailyClaims.Claim_Segment__c = '05';
        dailyClaims.Previous_Segment__c = '04';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5679RT';
        //dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Jane';
        dailyClaims.Patient_Last_Name__c = 'Doe';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');
        insert dailyClaims;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        Set<Id> claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        system.assertEquals(1,claimList.size());

        List<Case> originalEnrollmentCaseList = new List<Case>();
        List<Case> caseList = [SELECT Id, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name FROM Case WHERE Claim_Information__c IN : claimIdset];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Id =: caseList[0].Contact_Drug__c];
        for(Case caseRec: caseList)
        {
            //Update original Enrollment Case
            if(caseRec.RecordType.Name == 'Enrollment') {
                caseRec.Status = 'Outreach Completed';
                caseRec.HCP_Enrollment_Outreach__c = 'Outreach Complete';
                caseRec.Contact_Drug__r.Copay_Enrollment_Status__c = 'Not on File';
            }
            originalEnrollmentCaseList.add(caseRec);
            system.debug('Case records='+caseRec);

        }
        List<Contact_Drug__c> contactDrugListUpdated = new List<Contact_Drug__c>();
        for(Contact_Drug__c contactDrugRec: contactDrugList) {
            contactDrugRec.Copay_Enrollment_Status__c = 'Not on File';
            contactDrugListUpdated.add(contactDrugRec);
        }
        update contactDrugListUpdated;
        system.assertEquals(1,contactDrugList.size());
        //Cases from old claim should move to the new replacement claim
        system.assertEquals(2,caseList.size());

        update originalEnrollmentCaseList;

        List<Contact_Drug__c> enrollmentCaseContactDrugList = new List<Contact_Drug__c>();
        for(Contact_Drug__c contactDrgRec: contactDrugList) {
            contactDrgRec.Copay_Enrollment_Status__c = 'Not on File';
            enrollmentCaseContactDrugList.add(contactDrgRec);
        }

        update enrollmentCaseContactDrugList;

        Daily_Claim__c dailyClaim = [SELECT Status__c, Drug_Label_Name__c FROM Daily_Claim__c WHERE Id =: dailyClaims.Id LIMIT 1];
        //System.assertEquals(testDrug.Name, dailyClaim.Drug_Label_Name__c, 'Drug label name should match test drug name.');

        //Replacement Daily Claim.
        dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'JG12380';
        //dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '3';
        dailyClaims.Claim_Segment__c = '00';
        //dailyClaims.Previous_Claim__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5679RT';
        //dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Jane';
        dailyClaims.Patient_Last_Name__c = 'Doe';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims;

        claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        caseList = [SELECT Id, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
        FROM Case
        WHERE RecordType.Name = 'Enrollment' AND Claim_Information__c IN : claimIdset];
        Set<Id> contactDrugIds = new Set<Id>();
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                system.assertEquals('Outreach Needed',caseRec.HCP_Enrollment_Outreach__c);
                system.assertEquals('Verify Fax Number',caseRec.Status);
            }

        }
        contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Id IN :contactDrugIds];

        system.assertEquals(1,contactDrugList.size());
        system.assertEquals(2,claimList.size());

        //Should only have 1 Enrollment Cases
        system.assertEquals(1,caseList.size());

        Test.stopTest();
    }
    */

    //MED-1853: Ingest New Claims with O Status and 01 Segment if they have 00 previous segment as new claims
    @isTest
    public static void DC_OrgClaim01PreSeg00SegButCreateNewClaim()
    {

        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
        Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');

        Drug__c testDrug = new Drug__c();
        testDrug.Name = 'Test Drug 1';
        testDrug.J_Code__c = 'J5679';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;
/*
        Account accountInstance = new Account();
        accountInstance.Name='Test Account';
        insert accountInstance;

        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c =  System.today() - 20, //Post Go-Live Scenario
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;
*/
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        dailyClaimsTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        //Insert the initial claim that will be replaced.
        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Claim_Code__c = 'O';
        dailyClaims.Primary_Claim_Number__c = 'JG12380';
        dailyClaims.Claim_Line__c = '1';
        dailyClaims.Claim_Segment__c = '01';
        dailyClaims.Previous_Segment__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5679RT';
        //dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Jane';
        dailyClaims.Patient_Last_Name__c = 'Doe';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');
        insert dailyClaims;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        Set<Id> claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        system.assertEquals(1,claimList.size());

        List<Case> originalEnrollmentCaseList = new List<Case>();
        List<Case> caseList = [SELECT Id, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name FROM Case WHERE Claim_Information__c IN : claimIdset];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Id =: caseList[0].Contact_Drug__c];
        for(Case caseRec: caseList)
        {
            //Update original Enrollment Case
            if(caseRec.RecordType.Name == 'Enrollment') {
                caseRec.Status = 'Outreach Completed';
                caseRec.HCP_Enrollment_Outreach__c = 'Outreach Complete';
                caseRec.Contact_Drug__r.Copay_Enrollment_Status__c = 'Not on File';
            }
            originalEnrollmentCaseList.add(caseRec);
            system.debug('Case records='+caseRec);

        }
        List<Contact_Drug__c> contactDrugListUpdated = new List<Contact_Drug__c>();
        for(Contact_Drug__c contactDrugRec: contactDrugList) {
            contactDrugRec.Copay_Enrollment_Status__c = 'Not on File';
            contactDrugListUpdated.add(contactDrugRec);
        }
        update contactDrugListUpdated;
        system.assertEquals(1,contactDrugList.size());
        //Cases from old claim should move to the new replacement claim
        system.assertEquals(2,caseList.size());

        update originalEnrollmentCaseList;

        List<Contact_Drug__c> enrollmentCaseContactDrugList = new List<Contact_Drug__c>();
        for(Contact_Drug__c contactDrgRec: contactDrugList) {
            contactDrgRec.Copay_Enrollment_Status__c = 'Not on File';
            enrollmentCaseContactDrugList.add(contactDrgRec);
        }

        update enrollmentCaseContactDrugList;

        Daily_Claim__c dailyClaim = [SELECT Status__c, Drug_Label_Name__c FROM Daily_Claim__c WHERE Id =: dailyClaims.Id LIMIT 1];
        //System.assertEquals(testDrug.Name, dailyClaim.Drug_Label_Name__c, 'Drug label name should match test drug name.');

        //Replacement Daily Claim.
        dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'JG12380';
        //dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '3';
        dailyClaims.Claim_Segment__c = '00';
        //dailyClaims.Previous_Claim__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5679RT';
        //dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Jane';
        dailyClaims.Patient_Last_Name__c = 'Doe';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims;

        claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        caseList = [SELECT Id, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
        FROM Case
        WHERE RecordType.Name = 'Enrollment' AND Claim_Information__c IN : claimIdset];
        Set<Id> contactDrugIds = new Set<Id>();
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                system.assertEquals('Outreach Needed',caseRec.HCP_Enrollment_Outreach__c);
                system.assertEquals('Verify Fax Number',caseRec.Status);
            }

        }
        contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Id IN :contactDrugIds];

        system.assertEquals(1,contactDrugList.size());
        system.assertEquals(2,claimList.size());

        //Should only have 1 Enrollment Cases
        system.assertEquals(1,caseList.size());

        Test.stopTest();
    }

    //MBP-776 Duplicate Enrollment Case
    @isTest
    public static void HPA_DC_OneEnrollmentCase()
    {
        /*

         */

        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
        Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');

        Drug__c testDrug = new Drug__c();
        testDrug.Name = 'Test Drug 1';
        testDrug.J_Code__c = 'J5679';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;
/*
        Account accountInstance = new Account();
        accountInstance.Name='Test Account';
        insert accountInstance;

        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c =  System.today() - 20, //Post Go-Live Scenario
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;
*/
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        dailyClaimsTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        Historical_Prior_Auth__c HistoricalPA = new Historical_Prior_Auth__c();
        HistoricalPA.CSA_Account__c = 'AN0003';
        HistoricalPA.Prior_Authorization__c = 'A126';
        //HistoricalPA.Authorized_Representative__c = 'Ras And';
        //HistoricalPA.Authorized_Relationship__c = '4';
        //HistoricalPA.Billing_Provider_City__c = 'New York City';
        //HistoricalPA.Billing_Provider_PIN__c = '1234570';
        //HistoricalPA.Billing_Provider_State__c = 'NY';
        //HistoricalPA.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        //HistoricalPA.Billing_Provider_Zip_Code__c = '10118';
        HistoricalPA.CSA_Control__c = 'CN0003';
        HistoricalPA.Diagnosis_Code__c = '12345678989';
        HistoricalPA.Drug_Label_Name__c = 'Drug Four';
        HistoricalPA.HCPCS_Code__c = 'J5679RT';  //TODO: Breaks when more than 5 char
        HistoricalPA.NDC__c = '123456792';
        HistoricalPA.Service_Start_Date__c = date.valueOf('2021-10-01');
        HistoricalPA.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //HistoricalPA.Patient_Email_Address__c = 'lara@test.com';
        HistoricalPA.Patient_First_Name__c = 'Jane';
        HistoricalPA.Patient_Last_Name__c = 'Doe';
        HistoricalPA.Patient_Middle_Initial__c = 'H';
        HistoricalPA.Patient_Phone_Number__c = '8888888888';
        HistoricalPA.Patient_Gender__c = 'Male';
        HistoricalPA.Plan_Sponsor_Name__c = 'TCS';
        HistoricalPA.Service_Provider_Fax__c = '5555555557';
        HistoricalPA.Service_Provider_Phone__c = '7777777779';
        HistoricalPA.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        HistoricalPA.Service_Provider_City__c = 'Chicago';
        HistoricalPA.Service_Provider_First_Name__c = 'Dave';
        HistoricalPA.Service_Provider_Last_Name__c = 'Dle';
        HistoricalPA.Service_Provider_NPI__c = '9998887778';
        HistoricalPA.Service_Provider_Practice__c = 'NONE';
        HistoricalPA.Service_Provider_Zip__c = '10125';
        HistoricalPA.Service_Provider_Specialty_Code__c = '3';
        HistoricalPA.Service_Provider_State__c = 'NY';
        HistoricalPA.Patient_Address_Line_1__c = '125 Sesame Street';
        HistoricalPA.Patient_Address_Line_2__c = 'Apt 4';
        HistoricalPA.Patient_City__c = 'Los Angeles';
        HistoricalPA.Patient_CUMB_ID__c = 'W12345678';
        HistoricalPA.Patient_State__c = 'NY';
        HistoricalPA.Patient_Zip_Code__c = '10153';
        HistoricalPA.CSA_Suffix__c = 'SN0003';
        //HistoricalPA.Total_Copay__c = 72;
        HistoricalPA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert HistoricalPA;

        Test.startTest();

        List<Case> originalEnrollmentCaseList = new List<Case>();
        List<Case> caseList = [SELECT Id, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name FROM Case];
        system.assertEquals(1,caseList.size(), 'Should be 1 Enrollment Case');

        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Id =: caseList[0].Contact_Drug__c];
        for(Case caseRec: caseList)
        {
            //Update original Enrollment Case
            if(caseRec.RecordType.Name == 'Enrollment') {
                caseRec.Status = 'Outreach Completed';
                caseRec.HCP_Enrollment_Outreach__c = 'Outreach Complete';
                caseRec.Contact_Drug__r.Copay_Enrollment_Status__c = 'Not on File';
            }
            originalEnrollmentCaseList.add(caseRec);
            system.debug('Case records='+caseRec);

        }

        List<Contact_Drug__c> contactDrugListUpdated = new List<Contact_Drug__c>();
        for(Contact_Drug__c contactDrugRec: contactDrugList) {
            contactDrugRec.Copay_Enrollment_Status__c = 'Not on File';
            contactDrugListUpdated.add(contactDrugRec);
        }
        update contactDrugListUpdated;
        system.assertEquals(1,contactDrugList.size());

        update originalEnrollmentCaseList;

        List<Contact_Drug__c> enrollmentCaseContactDrugList = new List<Contact_Drug__c>();
        for(Contact_Drug__c contactDrgRec: contactDrugList) {
            contactDrgRec.Copay_Enrollment_Status__c = 'Not on File';
            enrollmentCaseContactDrugList.add(contactDrgRec);
        }

        update enrollmentCaseContactDrugList;

        //Replacement Daily Claim.
        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.CSA_Suffix__c = 'SN0003';
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'JG12380';
        //dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '3';
        dailyClaims.Claim_Segment__c = '00';
        //dailyClaims.Previous_Claim__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5679RT';
        //dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Jane';
        dailyClaims.Patient_Last_Name__c = 'Doe';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims;

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c =:'JG12380'];
        Set<Id> claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        caseList = [SELECT Id, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
        FROM Case
        WHERE RecordType.Name = 'Enrollment'];
        Set<Id> contactDrugIds = new Set<Id>();
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                system.assertEquals('Outreach Needed',caseRec.HCP_Enrollment_Outreach__c);
                system.assertEquals('Verify Fax Number',caseRec.Status);
            }

        }
        contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Id IN :contactDrugIds];

        system.assertEquals(1,contactDrugList.size());
        system.assertEquals(1,claimList.size());

        //Should only have 1 Enrollment Cases
        system.assertEquals(1,caseList.size(), 'Should be 1 Enrollment Case');

        Test.stopTest();
    }
}