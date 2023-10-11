@isTest
public class casesTest {

    @isTest
    public static void getPreviousSegmentClaim(){

        /*  Daily_Claim__c dailyClaim = new Daily_claim__c();
          String claim_NumberSeed;
          dailyClaim.Previous_Segment__c = 'PreviousSeg';
          dailyClaim.Claim_Segment__c='currentSeg';
          dailyClaim.Primary_Claim_Number__c='12345';
          dailyClaim.Claim_Line__c='ClaimLine'; */
        String claim_NumberSeed;

        Drug__c testDrug = new Drug__c();
        testDrug.J_Code__c = 'J5679';
        testDrug.Coding_Level__c = 'HCPCS';
        insert testDrug;

        Account accountInstance = new Account();
        accountInstance.Name='Test Account';
        insert accountInstance;

        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Segment__c='0';
        claims.Claim_Line__c='3';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        claims.Source_File_Type__c = 'Historical Claims';
        //claims.Drug__c= testDrug.id;
        insert claims;
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
        dailyClaims.Previous_Segment__c = 'PreviousSeg';
        dailyClaims.Claim_Segment__c='currentSeg';
        dailyClaims.Primary_Claim_Number__c='12345';
        dailyClaims.Claim_Line__c='ClaimLine';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        //dailyClaims.Billing_Provider_First_Name__c = 'Test';
        //dailyClaims.Billing_Provider_Last_Name__c = 'one';
        //dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
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
        //dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
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
        //dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert dailyClaims;

        test.startTest();
        system.assertEquals(null,claim_NumberSeed);
        test.stopTest();
    }
    //This test method is for Historical PA creates the Case scenario
    @isTest
    public static void HistoricalPA_NewCases()
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
        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Segment__c='0';
        claims.Claim_Line__c='3';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        claims.Source_File_Type__c = 'Historical Claims';
        insert claims;

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
        HistoricalPA.HCPCS_Code__c = 'J5678';
        HistoricalPA.NDC__c = '123456792';
        HistoricalPA.Service_Start_Date__c = date.valueOf('2021-10-01');
        HistoricalPA.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalPA.Patient_Email_Address__c = 'lara@test.com';
        HistoricalPA.Patient_First_Name__c = 'Lara';
        HistoricalPA.Patient_Last_Name__c = 'Briyan';
        HistoricalPA.Patient_Middle_Initial__c = 'B';
        HistoricalPA.Patient_Phone_Number__c = '8888888890';
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
        HistoricalPA.Patient_CUMB_ID__c = 'W12345680';
        HistoricalPA.Patient_State__c = 'NY';
        HistoricalPA.Patient_Zip_Code__c = '10153';
        HistoricalPA.CSA_Suffix__c = 'SN0003';
        //HistoricalPA.Total_Copay__c = 72;
        HistoricalPA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert HistoricalPA;

        Test.startTest();
        List<Case> caselst = [SELECT id from Case];
        system.assertequals(1,caselst.size());
        Test.stopTest();

    }
    //This test method is for Whichever(Historical PA) is processed first creates the Case, the other stands down scenario
    //This is to test existing Case scenario from Historical PA
    @isTest
    public static void HistoricalPA_ExistingCases()
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
        HistoricalPA.HCPCS_Code__c = 'J5678';
        HistoricalPA.NDC__c = '123456792';
        HistoricalPA.Service_Start_Date__c = date.valueOf('2021-10-01');
        HistoricalPA.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalPA.Patient_Email_Address__c = 'lara@test.com';
        HistoricalPA.Patient_First_Name__c = 'Lara';
        HistoricalPA.Patient_Last_Name__c = 'Briyan';
        HistoricalPA.Patient_Middle_Initial__c = 'B';
        HistoricalPA.Patient_Phone_Number__c = '8888888890';
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
        HistoricalPA.Patient_CUMB_ID__c = 'W12345680';
        HistoricalPA.Patient_State__c = 'NY';
        HistoricalPA.Patient_Zip_Code__c = '10153';
        HistoricalPA.CSA_Suffix__c = 'SN0003';
        //HistoricalPA.Total_Copay__c = 72;
        HistoricalPA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert HistoricalPA;

        Historical_Prior_Auth__c HistoricalPA1 = new Historical_Prior_Auth__c();
        HistoricalPA1.CSA_Account__c = 'AN0003';
        HistoricalPA1.Prior_Authorization__c = 'A127';
        //HistoricalPA1.Authorized_Representative__c = 'Dup con';
        //HistoricalPA1.Authorized_Relationship__c = '4';
        //HistoricalPA1.Billing_Provider_City__c = 'New York City';
        //HistoricalPA1.Billing_Provider_PIN__c = '1234570';
        //HistoricalPA1.Billing_Provider_State__c = 'NY';
        //HistoricalPA1.Billing_Provider_Address_Line_1__c = '468 Test Lane';
        //HistoricalPA1.Billing_Provider_Zip_Code__c = '10119';
        HistoricalPA1.CSA_Control__c = 'CN0003';
        HistoricalPA1.Diagnosis_Code__c = '12345678989';
        HistoricalPA1.Drug_Label_Name__c = 'Drug Four';
        HistoricalPA1.HCPCS_Code__c = 'J5678';
        HistoricalPA1.NDC__c = '123456792';
        HistoricalPA1.Service_Start_Date__c = date.valueOf('2021-10-01');
        HistoricalPA1.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalPA1.Patient_Email_Address__c = 'duptest@test.com';
        HistoricalPA1.Patient_First_Name__c = 'sach';
        HistoricalPA1.Patient_Last_Name__c = 'tenafd';
        HistoricalPA1.Patient_Middle_Initial__c = 'R';
        HistoricalPA1.Patient_Phone_Number__c = '8888888444';
        HistoricalPA1.Patient_Gender__c = 'Male';
        HistoricalPA1.Plan_Sponsor_Name__c = 'TCS';
        HistoricalPA1.Service_Provider_Fax__c = '9995555557';
        HistoricalPA1.Service_Provider_Phone__c = '9999777779';
        HistoricalPA1.Service_Provider_Address_Line_1__c = '459 Plane Lane';
        HistoricalPA1.Service_Provider_City__c = 'Chicago';
        HistoricalPA1.Service_Provider_First_Name__c = 'Casd';
        HistoricalPA1.Service_Provider_Last_Name__c = 'Fox';
        HistoricalPA1.Service_Provider_NPI__c = '9998887778';
        HistoricalPA1.Service_Provider_Practice__c = 'NONE';
        HistoricalPA1.Service_Provider_Zip__c = '10125';
        HistoricalPA1.Service_Provider_Specialty_Code__c = '3';
        HistoricalPA1.Service_Provider_State__c = 'NY';
        HistoricalPA1.Patient_Address_Line_1__c = '125 Sesame Street';
        HistoricalPA1.Patient_Address_Line_2__c = 'Apt 4';
        HistoricalPA1.Patient_City__c = 'Los Angeles';
        HistoricalPA1.Patient_CUMB_ID__c = 'W12345680';
        HistoricalPA1.Patient_State__c = 'NY';
        HistoricalPA1.Patient_Zip_Code__c = '10153';
        HistoricalPA1.CSA_Suffix__c = 'SN0003';
        //HistoricalPA1.Total_Copay__c = 72;
        HistoricalPA1.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert HistoricalPA1;

        Test.startTest();
        List<Case> caselst = [SELECT id from Case];
        system.assertequals(1,caselst.size()); //HPAs only create an Enrollment Case & no Reimbursement Case
        Test.stopTest();

    }
/*
    @IsTest
    private static void createTasks_CasesSuccess_UnitTest(){

        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
        Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');
        Schema.RecordTypeInfo reimbursementCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');

        Id mockCaseId = fflib_IDGenerator.generate(Case.SObjectType);

        Set<Id> caseIds = new Set<Id>{mockCaseId};
        List<Case> caseList = new List<Case>{new Case(Id = mockCaseId, Subject = 'Hi', Status = 'New', Origin = 'Email')};

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_SObjectUnitOfWork mockUOW = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        Cases mockCaseDomain = (Cases) mocks.mock(Cases.class);
        CasesSelector mockCaseSelector = (CasesSelector) mocks.mock(CasesSelector.class);

        mocks.startStubbing();
        mocks.when(mockCaseSelector.sObjectType()).thenReturn(Case.SObjectType);
        mocks.when(mockCaseSelector.selectSObjectsById(caseIds)).thenReturn(caseList);
        mocks.when(mockCaseSelector.selectRecordsForTasks()).thenReturn(caseList);
        mocks.when(mockCaseDomain.sObjectType()).thenReturn(Case.SObjectType);
        ((fflib_SObjectUnitOfWork)mocks.doThrowWhen(new DmlException(), mockUOW)).commitWork();
        mocks.stopStubbing();

        //THE MAJOR DIFFERENCE IS HERE! Instead of dependency injection we are using our
        //the setMock method in the fflib_Application class to set our mock class for unit tests.
        PMd_Application.UnitOfWork.setMock(mockUOW);
        PMd_Application.Domain.setMock((fflib_ISObjectDomain) mockCaseDomain);
        PMd_Application.Selector.setMock(mockCaseSelector);


        try{
            Test.startTest();
            //Task_Service.createTasks(caseIds, Case.SObjectType);
            Test.stopTest();
        }
        catch(Exception e){
            System.assert(e instanceof DmlException);
        }


        ((Cases)mocks.verify(mockCaseDomain, mocks.never().description('This method was called but it shouldn\'t have been'))).handleAfterInsert();
        ((Cases)mocks.verify(mockCaseDomain)).createTasks(caseList, mockUOW);

    }
*/
    //This test method to verify case update trigger changes
    @isTest
    public static void CasesTriggerChangesTest()
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
        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Segment__c='0';
        claims.Claim_Line__c='3';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        claims.Source_File_Type__c = 'Historical Claims';
        insert claims;

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
        HistoricalPA.HCPCS_Code__c = 'J5678';
        HistoricalPA.NDC__c = '123456792';
        HistoricalPA.Service_Start_Date__c = date.valueOf('2021-10-01');
        HistoricalPA.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalPA.Patient_Email_Address__c = 'lara@test.com';
        HistoricalPA.Patient_First_Name__c = 'Lara';
        HistoricalPA.Patient_Last_Name__c = 'Briyan';
        HistoricalPA.Patient_Middle_Initial__c = 'B';
        HistoricalPA.Patient_Phone_Number__c = '8888888890';
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
        HistoricalPA.Patient_CUMB_ID__c = 'W12345680';
        HistoricalPA.Patient_State__c = 'NY';
        HistoricalPA.Patient_Zip_Code__c = '10153';
        HistoricalPA.CSA_Suffix__c = 'SN0003';
        //HistoricalPA.Total_Copay__c = 72;
        HistoricalPA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert HistoricalPA;

        Test.startTest();
        List<Case> caselst = [SELECT id, Service_Provider_Fax__c, Contact.Alternative_Phone__c, Contact.Patient_Phone_Number__c FROM Case];
        system.assertequals(1,caselst.size());

        Case caseRecord = caselst[0];
        caseRecord.Status = 'Transfer to Health Plan';
        caseRecord.Send_to_Aetna__c = 'Queued';
        caseRecord.Outreach_Type__c = 'Both';
        caseRecord.Outreach_Comments__c = 'Outreach_Comments__c';
        update caseRecord;

        caseRecord.Status = '1st Attempt Needed';
        update caseRecord;

        caselst = [SELECT id, Send_to_Aetna__c, Service_Provider_Fax__c, Contact.Alternative_Phone__c, Contact.Patient_Phone_Number__c FROM Case];
        caseRecord = caselst[0];

        System.assertEquals(null, caseRecord.Send_to_Aetna__c, 'When the case status is changed from “Transfer to Health Plan” to any other status, the Send to Aetna field should clear out.');

        //system.assertEquals(caseRecord.Contact.Patient_Phone_Number__c, caseRecord.Service_Provider_Fax__c, 'If the Alternative Phone on the Contact Page is blank and the Patient Phone is populated, map the Patient Phone onto the outbound faxes.');

        Test.stopTest();

    }

    //This test method to verify Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
    @isTest
    public static void PrioritizeServiceProviderFaxTest()
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
        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Segment__c='0';
        claims.Claim_Line__c='3';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        claims.Source_File_Type__c = 'Historical Claims';
        insert claims;

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
        HistoricalPA.HCPCS_Code__c = 'J5678';
        HistoricalPA.NDC__c = '123456792';
        HistoricalPA.Service_Start_Date__c = date.valueOf('2021-10-01');
        HistoricalPA.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalPA.Patient_Email_Address__c = 'lara@test.com';
        HistoricalPA.Patient_First_Name__c = 'Lara';
        HistoricalPA.Patient_Last_Name__c = 'Briyan';
        HistoricalPA.Patient_Middle_Initial__c = 'B';
        HistoricalPA.Patient_Phone_Number__c = '8888888890';
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
        HistoricalPA.Patient_CUMB_ID__c = 'W12345680';
        HistoricalPA.Patient_State__c = 'NY';
        HistoricalPA.Patient_Zip_Code__c = '10153';
        HistoricalPA.CSA_Suffix__c = 'SN0003';
        //HistoricalPA.Total_Copay__c = 72;
        HistoricalPA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert HistoricalPA;

        Test.startTest();
        List<Case> caselst = [SELECT id, Service_Provider_Fax__c, Contact.Alternative_Phone__c, Contact.Patient_Phone_Number__c FROM Case];
        system.assertequals(1,caselst.size());

        Case caseRecord = caselst[0];
        //system.assertEquals(caseRecord.Contact.Patient_Phone_Number__c, caseRecord.Service_Provider_Fax__c, 'If the Alternative Phone on the Contact Page is blank and the Patient Phone is populated, map the Patient Phone onto the outbound faxes.');

        Test.stopTest();

    }
    /*@isTest
    static void testValidationOnCaseClose() {
        // Create test Record Types
        *//*RecordType enrollmentRT = new RecordType(Name = 'Enrollment', SObjectType = 'Case');
        RecordType reimbursementRT = new RecordType(Name = 'Reimbursement', SObjectType = 'Case');
        insert new List<Case>{enrollmentRT, reimbursementRT};*//*

        // Create test Cases
        Case enrollmentCase = new Case(Status = 'Outreach Complete', RecordTypeId = 'Enrollment');
        Case reimbursementCase = new Case(Status = 'Outreach Complete', RecordTypeId = 'Reimbursement');
        Case noErrorCase = new Case(Status = 'Outreach Complete', RecordTypeId = 'Enrollment');

        // Insert test Cases
        insert new List<Case>{enrollmentCase, reimbursementCase, noErrorCase};

        // Call the validation method
        Test.startTest();
        CasesTriggerChangesTest().validateCustomPicklistOnClose(new List<Case>{enrollmentCase, reimbursementCase, noErrorCase}, null);
        Test.stopTest();

        // Verify error messages
        System.assertEquals('Please select a Case Close Reason to close this case', enrollmentCase.Enrollment_Case_Close_Reason__c.getErrors()[0].getMessage());
        System.assertEquals('Please select a Case Close Reason to close this case', reimbursementCase.Reimbursement_Case_Close_Reason__c.getErrors()[0].getMessage());

        // Verify that the noErrorCase has no errors
        System.assertEquals(0, noErrorCase.getErrors().size());
    }*/
}