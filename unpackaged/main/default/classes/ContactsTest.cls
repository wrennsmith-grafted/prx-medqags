/**
 * @description       : Test Daily Claims Domain
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks             Initial Version
 *
 **/
@IsTest
private class ContactsTest {
    @IsTest
    private static void insertDaily_Claims_NewContact_UnitTest() {
        Daily_Claim_JSONRequest requestDailyClaims;

        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork) mocks.mock(fflib_ISObjectUnitOfWork.class);
        Contacts mockContactsDomain = (Contacts) mocks.mock(Contacts.class);

        // Given
        Account accountInstance = new Account(
                //Id = mockAccountId,
                Name = 'Test Account'
        );
        insert accountInstance;

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
                Patient_Birth_Date__c = Date.today(),
                Patient_First_Name__c = 'Person First',
                Patient_Last_Name__c = 'Person Last',
                HCPCS_Code__c = 'IPC02',
                CSA_Control__c = 'CN0001',
                CSA_Suffix__c = 'SN0001',
                CSA_Account__c = 'AN0001'
        );

        Test.startTest();

        List<Daily_Claim__c> testDaily_ClaimList = new List<Daily_Claim__c>{dailyClaimInstance};
        insert testDaily_ClaimList;
        Map<Id, Contact> existingContactsByDailyClaimId = new Map<Id, Contact>();

        //Use the setMock method in the fflib_Application class to set our mock class for unit tests.
        PMd_Application.UnitOfWork.setMock(uowMock);
        PMd_Application.domain.setMock((fflib_ISObjectDomain) mockContactsDomain);

        mocks.startStubbing();
        //mocks.when(mockContactsDomain.getContacts()).thenReturn(existingContacts);
        //mocks.when(mockContactsDomain.mapContactsByDailyClaimId(existingContacts, testDaily_ClaimList)).thenReturn(existingContactsByDailyClaimId);
        mocks.stopStubbing();

        List<Contact> contactList = [SELECT id from Contact];
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c];
        List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c];

        // When

        System.assertEquals(1, contactList.size());
        System.assertEquals(1, claimList.size());
        System.assertEquals(1, contactDrugList.size());

        Test.stopTest();
    }

    @IsTest
    private static void insertDaily_Claims_ExistingContact_UnitTest() {
        Daily_Claim_JSONRequest requestDailyClaims;

        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork) mocks.mock(fflib_ISObjectUnitOfWork.class);
        Contacts mockContactsDomain = (Contacts) mocks.mock(Contacts.class);
        // Given
        Account accountInstance = new Account(
                //Id = mockAccountId,
                Name = 'Test Account'
        );
        insert accountInstance;

        String Subscriber_CUMB_ID = '123';
        Date contactBirthdate = Date.today();
        String contactFirstName = 'CoolFirstName';
        String contactLastName = 'CoolLastName';
        String sha1Hash_Id = SHA1UtilService.getBase64SHA1Hash(
                Subscriber_CUMB_ID + '-'
                        + contactBirthdate + '-'
                        + contactFirstName + '-'
                        + contactLastName
        );

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

        Daily_Claim__c initialDailyClaimInstance = new Daily_Claim__c(
                Patient_Birth_Date__c = contactBirthdate,
                Patient_First_Name__c = contactFirstName,
                Patient_Last_Name__c = contactLastName,
                HCPCS_Code__c = 'IPC02',
                CSA_Control__c = 'CN0001',
                CSA_Suffix__c = 'SN0001',
                CSA_Account__c = 'AN0001',
                Patient_CUMB_ID__c = '12345',
                Primary_Claim_Number__c = '4321'
        );

        insert initialDailyClaimInstance;

        Daily_Claim__c dailyClaimInstance = new Daily_Claim__c(
                Patient_Birth_Date__c = contactBirthdate,
                Patient_First_Name__c = contactFirstName,
                Patient_Last_Name__c = contactLastName,
                HCPCS_Code__c = 'IPC02',
                CSA_Control__c = 'CN0001',
                CSA_Suffix__c = 'SN0001',
                CSA_Account__c = 'AN0001',
                Patient_CUMB_ID__c = '12345',
                Primary_Claim_Number__c = '4321'

        );

        List<Daily_Claim__c> testDaily_ClaimList = new List<Daily_Claim__c>{dailyClaimInstance};
        //insert testDaily_ClaimList;
        Map<Id, Contact> existingContactsByDailyClaimId = new Map<Id, Contact>();

        //Use the setMock method in the fflib_Application class to set our mock class for unit tests.
        PMd_Application.UnitOfWork.setMock(uowMock);
        PMd_Application.domain.setMock((fflib_ISObjectDomain) mockContactsDomain);

        mocks.startStubbing();
        //mocks.when(mockContactsDomain.getContacts()).thenReturn(existingContacts);
        //mocks.when(mockContactsDomain.mapContactsByDailyClaimId(existingContacts, testDaily_ClaimList)).thenReturn(existingContactsByDailyClaimId);
        mocks.stopStubbing();
        List<Contact> contactList = [SELECT id from Contact];

        // When
        Test.startTest();
        System.assertEquals(contactList.size(), 1);
        //mockContactsDomain.process(testDaily_ClaimList, uowMock);

        Test.stopTest();
    }
    //This test method is to test Create Contacts from Historical Claim scenario
    @isTest
    public static void HistoricalClaim_NewContact()
    {
        Account accountInstance = new Account(
                Name = 'Test Account'

        );

        insert accountInstance;

        Drug__c testDrug = new Drug__c();
        testDrug.Coding_Level__c = 'HCPCS';
        testDrug.J_Code__c = 'J5678';
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
        //HistoricalClaims.Billing_Provider_PIN__c = '1234570';
        //HistoricalClaims.Billing_Provider_State__c = 'NY';
        //HistoricalClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        // HistoricalClaims.Billing_Provider_Zip_Code__c = '10118';
        //HistoricalClaims.Billing_Provider_Phone__c = '3333333333';
        // HistoricalClaims.Billing_Provider_Fax__c = '9999999999';
        HistoricalClaims.Primary_Claim_Number__c = 'E11111111111114';
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
        //HistoricalClaims.NDC__c = '123456792';
        // HistoricalClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
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
        List<Drug__c> drugList =[SELECT id from Drug__c where J_Code__c =: 'J5678' ];
        List<Contact_Drug__c> contactDrugList = [SELECT id,Drug_Name__c,Contact__c from Contact_Drug__c where Contact__c =: conList[0].id ];

        Set<Id>  contactDrugIdSet = new Set<Id>();
        for(Contact_Drug__c conDrug: contactDrugList){
            system.assertEquals(conList[0].id, conDrug.Contact__c);
            system.assertEquals(drugList[0].id, conDrug.Drug_Name__c);
            contactDrugIdSet.add(conDrug.Id);
        }

        system.assertequals(1,contactDrugList.size());
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        // List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Claim_Information__c =: claims.id ];

        system.assertequals(1,claimList.size());
        system.assertequals(1,conList.size());
        Set<Id>  claimIdSet = new Set<Id>();
        for (Claim_Information__c claim: claimList) {
            claimIdSet.add(claim.Id);
        }
        List<Case> caseList = [SELECT Id FROM Case WHERE Contact_Drug__c IN :contactDrugIdSet];
        system.assertequals(1,caseList.size());

        Test.stopTest();

    }
    //This test method is to test Existing Contacts from Historical Claim scenario
    @isTest
    public static void HistoricalClaim_ExistingContact()
    {
        Drug__c testDrug = new Drug__c();
        testDrug.Coding_Level__c = 'HCPCS';
        testDrug.J_Code__c = 'J5678';
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
        Historical_Claim__c HistoricalClaims = new Historical_Claim__c();
        HistoricalClaims.CSA_Account__c = 'AN0003';
        HistoricalClaims.Units_Billed__c = 2;
        HistoricalClaims.Amount_Paid_By_Primary__c = 100;
        //HistoricalClaims.Prior_Authorization__c = 'A123';
        //HistoricalClaims.Authorized_Representative__c = 'Jane Smith';
        //HistoricalClaims.Authorized_Relationship__c = '1';
        /*HistoricalClaims.Billing_Provider_City__c = 'New York City';
        HistoricalClaims.Billing_Provider_First_Name__c = 'Test';
        HistoricalClaims.Billing_Provider_Last_Name__c = 'one';
        HistoricalClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        HistoricalClaims.Billing_Provider_PIN__c = '1234567';
        HistoricalClaims.Billing_Provider_State__c = 'NY';
        HistoricalClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        HistoricalClaims.Billing_Provider_Zip_Code__c = '10123';
        HistoricalClaims.Billing_Provider_Phone__c = '5555555555';
        HistoricalClaims.Billing_Provider_Fax__c = '9999999999';*/
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
        //HistoricalClaims.NDC__c = '123456789';
        //HistoricalClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
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
        HistoricalClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert HistoricalClaims;

        Test.startTest();

        Historical_Claim__c HistoricalClaims1 = new Historical_Claim__c();
        HistoricalClaims1.CSA_Account__c = 'AN0003';
        HistoricalClaims1.Units_Billed__c = 2;
        HistoricalClaims1.Amount_Paid_By_Primary__c = 100;
        //HistoricalClaims1.Prior_Authorization__c = 'A124';
        // HistoricalClaims1.Authorized_Representative__c = 'Ravi Raghu';
        //HistoricalClaims1.Authorized_Relationship__c = '1';
        /*HistoricalClaims1.Billing_Provider_City__c = 'New York City';
        HistoricalClaims1.Billing_Provider_First_Name__c = 'Test2';
        HistoricalClaims1.Billing_Provider_Last_Name__c = 'one2';
        HistoricalClaims1.Billing_Provider_Specialty__c = 'Specialty 2';
        HistoricalClaims1.Billing_Provider_PIN__c = '1234568';
        HistoricalClaims1.Billing_Provider_State__c = 'NY';
        HistoricalClaims1.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        HistoricalClaims1.Billing_Provider_Zip_Code__c = '10123';
        HistoricalClaims1.Billing_Provider_Phone__c = '6666666666';
        HistoricalClaims1.Billing_Provider_Fax__c = '9999999988';*/
        HistoricalClaims1.Primary_Claim_Number__c = 'E11111111111111';
        //HistoricalClaims1.Claim_Code__c = 'Initial Claim';
        HistoricalClaims1.Claim_Line__c = '1';
        //HistoricalClaims1.Claim_Segment__c = '01';
        HistoricalClaims1.COB_Code__c = 'Secondary';
        HistoricalClaims1.CSA_Control__c = 'CN0003';
        //HistoricalClaims1.Days_Supply__c = 30;
        HistoricalClaims1.Diagnosis_Code__c = '12345678987';
        HistoricalClaims1.Drug_Label_Name__c = 'Drug One';
        HistoricalClaims1.HCPCS_Code__c = 'J5678';
        //HistoricalClaims1.NDC__c = '123456789';
        //HistoricalClaims1.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        HistoricalClaims1.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //HistoricalClaims1.Patient_Email_Address__c = 'jsmith@test.com';
        HistoricalClaims1.Patient_First_Name__c = 'Joe';
        HistoricalClaims1.Patient_Last_Name__c = 'Smith';
        HistoricalClaims1.Patient_Middle_Initial__c = 'H';
        HistoricalClaims1.Patient_Phone_Number__c = '8888888888';
        HistoricalClaims1.Patient_Gender__c = 'Male';
        HistoricalClaims1.Plan_Sponsor_Name__c = 'Sample Company';
        HistoricalClaims1.Preferred_Provider__c = 'Preferred';
        HistoricalClaims1.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        HistoricalClaims1.Service_Provider_Fax__c = '5555555555';
        HistoricalClaims1.Service_Provider_Phone__c = '7777777777';
        HistoricalClaims1.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        HistoricalClaims1.Service_Provider_Address_Line_1__c = '456 plane Lane';
        HistoricalClaims1.Service_Provider_City__c = 'Chicago';
        HistoricalClaims1.Service_Provider_First_Name__c = 'Kane';
        HistoricalClaims1.Service_Provider_Last_Name__c = 'william';
        HistoricalClaims1.Service_Provider_NPI__c = '9998887776';
        HistoricalClaims1.Service_Provider_Practice__c = 'NONE';
        HistoricalClaims1.Service_Provider_Zip__c = '10123';
        HistoricalClaims1.Service_Provider_State__c = 'NY';
        HistoricalClaims1.Patient_Address_Line_1__c = '123 Sesame Street';
        HistoricalClaims1.Patient_Address_Line_2__c = '0';
        HistoricalClaims1.Patient_City__c = 'Los Angeles';
        HistoricalClaims1.Patient_CUMB_ID__c = 'W12345678';
        HistoricalClaims1.Patient_State__c = 'NY';
        HistoricalClaims1.Patient_Zip_Code__c = '10151';
        HistoricalClaims1.CSA_Suffix__c = 'SN0003';
        HistoricalClaims1.Total_Coinsurance__c = 30;
        HistoricalClaims1.Total_Copay__c = 30;
        HistoricalClaims1.Total_Deductible__c = 500;
        //HistoricalClaims1.Previous_Claim__c = '';
        HistoricalClaims1.Relationship_Code__c = '01';
        HistoricalClaims1.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert HistoricalClaims1;

        List<Contact> newcon= [SELECT id,FirstName,lastname from Contact where CSA_Account__c =: HistoricalClaims.CSA_Account__c];
        List<Contact> existcon= [SELECT id,FirstName,lastname from Contact where CSA_Account__c =: HistoricalClaims1.CSA_Account__c];
        system.assertEquals(newcon[0].lastname, existcon[0].lastname);
        Test.stopTest();
    }
    //This test method is to test Create Contacts from Historical PA scenario
    @isTest
    public static void HistoricalPA_NewContact()
    {
        Account accountInstance = new Account(
                Name = 'Test Account'

        );

        insert accountInstance;

        Drug__c testDrug = new Drug__c();
        testDrug.Coding_Level__c = 'HCPCS';
        testDrug.J_Code__c = 'J5678';
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
        //HistoricalPA.NDC__c = '123456792';
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
        HistoricalPA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert HistoricalPA;

        Test.startTest();
        List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: HistoricalPA.CSA_Account__c];
        system.assertequals(1,conList.size());
        Test.stopTest();

    }
    //This test method is to test Existing Contacts from Historical PA scenario
    //Whichever is processed first creates the Contact, the other stands down
    @isTest
    public static void HistoricalPA_ExistingContact()
    {
        Account accountInstance = new Account(
                Name = 'Test Account'

        );

        insert accountInstance;

        Drug__c testDrug = new Drug__c();
        testDrug.Coding_Level__c = 'HCPCS';
        testDrug.J_Code__c = 'J5678';
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
        //istoricalPA.Authorized_Relationship__c = '4';
        //HistoricalPA.Billing_Provider_City__c = 'New York City';
        //HistoricalPA.Billing_Provider_PIN__c = '1234570';
        //HistoricalPA.Billing_Provider_State__c = 'NY';
        //HistoricalPA.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        //HistoricalPA.Billing_Provider_Zip_Code__c = '10118';
        HistoricalPA.CSA_Control__c = 'CN0003';
        HistoricalPA.Diagnosis_Code__c = '12345678989';
        HistoricalPA.Drug_Label_Name__c = 'Drug Four';
        HistoricalPA.HCPCS_Code__c = 'J5678';
        //HistoricalPA.NDC__c = '123456792';
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
        HistoricalPA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

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
        //HistoricalPA1.NDC__c = '123456792';
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
        HistoricalPA1.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

        insert HistoricalPA1;

        Test.startTest();
        List<Contact> newcon= [SELECT id,FirstName,lastname from Contact where CSA_Account__c =: HistoricalPA.CSA_Account__c];
        List<Contact> existcon= [SELECT id,FirstName,lastname from Contact where CSA_Account__c =: HistoricalPA1.CSA_Account__c];
        system.assertEquals(newcon[0].lastname, existcon[0].lastname);
        Test.stopTest();

    }
    //This test method is to test Existing Duplicate Contacts from Historical Prior Auth scenario
    @isTest
    public static void HistoricalPA_DuplicateContactException() {
        {
            Account accountInstance = new Account(
                    Name = 'Test Account-001'

            );

            insert accountInstance;

            Drug__c testDrug = new Drug__c();
            testDrug.Coding_Level__c = 'HCPCS';
            testDrug.J_Code__c = 'J5678';
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
            //istoricalPA.Authorized_Relationship__c = '4';
            //HistoricalPA.Billing_Provider_City__c = 'New York City';
            //HistoricalPA.Billing_Provider_PIN__c = '1234570';
            //HistoricalPA.Billing_Provider_State__c = 'NY';
            //HistoricalPA.Billing_Provider_Address_Line_1__c = '459 Test Lane';
            //HistoricalPA.Billing_Provider_Zip_Code__c = '10118';
            HistoricalPA.CSA_Control__c = 'CN0003';
            HistoricalPA.Diagnosis_Code__c = '12345678989';
            HistoricalPA.Drug_Label_Name__c = 'Drug Four';
            HistoricalPA.HCPCS_Code__c = 'J5678';
            //HistoricalPA.NDC__c = '123456792';
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
            HistoricalPA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

            insert HistoricalPA;

            HistoricalPA.Id = null;
            HistoricalPA.Patient_CUMB_ID__c = 'W123456801';
            insert HistoricalPA;

            Test.startTest();

            List<Error_Log__c> errorLogs = [SELECT id, Method__c, Daily_Claim__c, Historical_Claim__c, Prior_Auth__c, Historical_Prior_Auth__c FROM Error_Log__c];
            system.assertequals(3, errorLogs.size(), 'Expected 3 exception error because a duplicate Contact should have been created.');
            system.assertequals('Cases.process.processHistoricalPriorAuthsAfterInsert.processHistoricalPriorAuthContacts', errorLogs[0].Method__c, 'processHistoricalPriorAuthContacts has thrown an exception');
            system.assertequals('Cases.process.processHistoricalPriorAuthsAfterInsert.processHistoricalPriorAuthContactDrugs', errorLogs[1].Method__c, 'processHistoricalPriorAuthContactDrugs has thrown an exception');
            system.assertequals('Cases.process.processHistoricalPriorAuthsAfterInsert.processHistoricalPriorAuthCases', errorLogs[2].Method__c, 'processHistoricalPriorAuthCases has thrown an exception');
            system.assertequals( HistoricalPA.Id, errorLogs[2].Historical_Prior_Auth__c,'Link to Historical_PA is incorrect');

            ErrorLog.log('method', 'endpoint', 'requestBody', 'responseBody', 'errorCode', 'errorMessage', HistoricalPA.Id);
            //ErrorLog.commitLogs();
            ErrorLog.log('method', 'endpoint', 'requestBody', 'responseBody', 'errorCode', 'errorMessage',
                         HistoricalPA.Id, HistoricalPA.Id, HistoricalPA.Id, HistoricalPA.Id);
            //ErrorLog.commitLogs();
            //Daily_ClaimsServiceImpl.doRestAPIPost(null, null);
            //Historical_ClaimsServiceImpl.doRestAPIPost(null, null);

            // Run ErrorLogJob
            ErrorLogJob job = new ErrorLogJob();
            Id jobid= Database.executeBatch(job, 200);

            Test.stopTest();

            List<Historical_Prior_Auth__c> testHistoricalPAs = [SELECT Id, Status__c, Error_Log__c FROM Historical_Prior_Auth__c WHERE Id =: errorLogs[0].Historical_Prior_Auth__c LIMIT 1];
            System.debug('testHistoricalPAs[0].Id = ' + testHistoricalPAs[0].Id);
            system.assertequals('Error', testHistoricalPAs[0].Status__c);
            system.assertequals('Unable to create record due to duplicate.', testHistoricalPAs[0].Error_Log__c);

        }
    }
    //This test method is to test Existing Duplicate Contacts from Daily Claim scenario
    @isTest
    public static void DailyClaim_DuplicateContactException() {
        {
            Account accountInstance = new Account(
                    Name = 'Test Account-002'

            );

            insert accountInstance;

            Drug__c testDrug = new Drug__c();
            testDrug.Coding_Level__c = 'HCPCS';
            testDrug.J_Code__c = 'J5678';
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
            dailyClaims1.HCPCS_Code__c = 'J5678';
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
            dailyClaims2.Primary_Claim_Number__c = 'JG123801'; //Change the Primary_Claim_Number__c to generate a duplicate contact
            dailyClaims2.Claim_Code__c = 'Initial Claim';
            dailyClaims2.Claim_Line__c = '1';
            dailyClaims2.Claim_Segment__c = '00';
            dailyClaims2.Previous_Segment__c = ''; //The claim is the original claim
            dailyClaims2.COB_Code__c = 'Secondary';
            dailyClaims2.CSA_Control__c = 'CN0003';
            dailyClaims2.Days_Supply__c = 30;
            dailyClaims2.Diagnosis_Code__c = '12345678987';
            dailyClaims2.Drug_Label_Name__c = 'Drug One';
            dailyClaims2.HCPCS_Code__c = 'J5678';
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
            dailyClaims2.Patient_Address_Line_2__c = '';
            dailyClaims2.Patient_City__c = 'Los Angeles';
            dailyClaims2.Patient_CUMB_ID__c = 'W123456781'; //Change the CUMB_ID to generate a duplicate contact
            dailyClaims2.Patient_State__c = 'NY';
            dailyClaims2.Patient_Zip_Code__c = '10151';
            dailyClaims2.CSA_Suffix__c = 'SN0003';
            dailyClaims2.Total_Coinsurance__c = 30;
            dailyClaims2.Total_Copay__c = 30;
            dailyClaims2.Total_Deductible__c = 500;
            dailyClaims2.Previous_Claim__c = '';
            dailyClaims2.Relationship_Code__c = 'M';
            //dailyClaims2.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

            insert dailyClaims2;

            Test.startTest();

            List<Error_Log__c> errorLogs = [SELECT Id, Method__c, Daily_Claim__c, Historical_Claim__c, Prior_Auth__c, Historical_Prior_Auth__c FROM Error_Log__c];
            system.assertequals(3, errorLogs.size(), 'Expected 3 exception error because a duplicate Contact should have been created.');
            system.assertequals('Daily_Claims.ProcessDailyClaimsAfterInsert.processDailyClaimContacts', errorLogs[0].Method__c, 'processDailyClaimContacts has thrown an exception');
            system.assertequals('Daily_Claims.ProcessDailyClaimsAfterInsert.processDailyClaimContactDrugs', errorLogs[1].Method__c, 'processDailyClaimContactDrugs has thrown an exception');
            //system.assertequals('Cases.process.ProcessDailyClaimsAfterInsert.processDailyClaimCases', errorLogs[2].Method__c, 'processDailyClaimCases has thrown an exception');
            system.assertequals( dailyClaims2.Id, errorLogs[1].Daily_Claim__c,'Link to DailyClaim is incorrect');

            //ErrorLog.log('method', 'endpoint', 'requestBody', 'responseBody', 'errorCode', 'errorMessage', dailyClaims2.Id);
            //ErrorLog.commitLogs();
            //ErrorLog.log('method', 'endpoint', 'requestBody', 'responseBody', 'errorCode', 'errorMessage',
            //        dailyClaims2.Id, dailyClaims2.Id, dailyClaims2.Id, dailyClaims2.Id);
            //ErrorLog.commitLogs();
            //Daily_ClaimsServiceImpl.doRestAPIPost(null, null);
            //Historical_ClaimsServiceImpl.doRestAPIPost(null, null);

            // Run ErrorLogJob
            ErrorLogJob job = new ErrorLogJob();
            Id jobid= Database.executeBatch(job, 200);

            Test.stopTest();

            List<Daily_Claim__c> dailyClaimsList = [SELECT Id, Status__c, Error_Log__c FROM Daily_Claim__c WHERE Id =: errorLogs[0].Daily_Claim__c LIMIT 1];
            System.debug('dailyClaimsList[0].Id = ' + dailyClaimsList[0].Id);
            system.assertequals('Error', dailyClaimsList[0].Status__c);
            system.assertequals('Unable to create record due to duplicate.', dailyClaimsList[0].Error_Log__c);

        }
    }

    //This test method is to test Existing Duplicate Contacts from Historical Prior Auth scenario
    @isTest
    public static void PA_DuplicateContactException() {
        {
            Account accountInstance = new Account(
                    Name = 'Test Account-001'

            );

            insert accountInstance;

            Drug__c testDrug = new Drug__c();
            testDrug.Coding_Level__c = 'HCPCS';
            testDrug.J_Code__c = 'J5678';
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

            Prior_Auth__c PA = new Prior_Auth__c();
            PA.CSA_Account__c = 'AN0003';
            PA.Prior_Authorization__c = 'A126';
            //PA.Authorized_Representative__c = 'Ras And';
            //istoricalPA.Authorized_Relationship__c = '4';
            //PA.Billing_Provider_City__c = 'New York City';
            //PA.Billing_Provider_PIN__c = '1234570';
            //PA.Billing_Provider_State__c = 'NY';
            //PA.Billing_Provider_Address_Line_1__c = '459 Test Lane';
            //PA.Billing_Provider_Zip_Code__c = '10118';
            PA.CSA_Control__c = 'CN0003';
            PA.Diagnosis_Code__c = '12345678989';
            PA.Drug_Label_Name__c = 'Drug Four';
            PA.HCPCS_Code__c = 'J5678';
            //PA.NDC__c = '123456792';
            PA.Service_Start_Date__c = date.valueOf('2021-10-01');
            PA.Patient_Birth_Date__c = date.valueOf('1991-01-11');
            //PA.Patient_Email_Address__c = 'lara@test.com';
            PA.Patient_First_Name__c = 'Lara';
            PA.Patient_Last_Name__c = 'Briyan';
            PA.Patient_Middle_Initial__c = 'B';
            PA.Patient_Phone_Number__c = '8888888890';
            PA.Patient_Gender__c = 'Male';
            PA.Plan_Sponsor_Name__c = 'TCS';
            PA.Service_Provider_Fax__c = '5555555557';
            PA.Service_Provider_Phone__c = '7777777779';
            PA.Service_Provider_Address_Line_1__c = '458 Plane Lane';
            PA.Service_Provider_City__c = 'Chicago';
            PA.Service_Provider_First_Name__c = 'Dave';
            PA.Service_Provider_Last_Name__c = 'Dle';
            PA.Service_Provider_NPI__c = '9998887778';
            PA.Service_Provider_Practice__c = 'NONE';
            PA.Service_Provider_Zip__c = '10125';
            PA.Service_Provider_Specialty_Code__c = '3';
            PA.Service_Provider_State__c = 'NY';
            PA.Patient_Address_Line_1__c = '125 Sesame Street';
            PA.Patient_Address_Line_2__c = 'Apt 4';
            PA.Patient_City__c = 'Los Angeles';
            PA.Patient_CUMB_ID__c = 'W12345680';
            PA.Patient_State__c = 'NY';
            PA.Patient_Zip_Code__c = '10153';
            PA.CSA_Suffix__c = 'SN0003';
            //PA.Total_Copay__c = 72;
            PA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');

            insert PA;

            PA.Id = null;
            PA.Patient_CUMB_ID__c = 'W123456801';
            insert PA;

            Test.startTest();

            List<Error_Log__c> errorLogs = [SELECT id, Method__c, Daily_Claim__c, Historical_Claim__c, Prior_Auth__c, Historical_Prior_Auth__c FROM Error_Log__c];
            system.assertequals(3, errorLogs.size(), 'Expected 3 exception error because a duplicate Contact should have been created.');
            system.assertequals('Cases.process.processPriorAuthsAfterInsert.processPriorAuthContacts', errorLogs[0].Method__c, 'processPriorAuthContacts has thrown an exception');
            system.assertequals('Cases.process.processPriorAuthsAfterInsert.processPriorAuthContactDrugs', errorLogs[1].Method__c, 'processPriorAuthContactDrugs has thrown an exception');
            system.assertequals('Cases.process.processPriorAuthsAfterInsert.processPriorAuthCases', errorLogs[2].Method__c, 'processPriorAuthCases has thrown an exception');
            system.assertequals( PA.Id, errorLogs[2].Prior_Auth__c,'Link to Prior_Auth is incorrect');

            ErrorLog.log('method', 'endpoint', 'requestBody', 'responseBody', 'errorCode', 'errorMessage', PA.Id);
            //ErrorLog.commitLogs();
            ErrorLog.log('method', 'endpoint', 'requestBody', 'responseBody', 'errorCode', 'errorMessage',
                    PA.Id, PA.Id, PA.Id, PA.Id);
            //ErrorLog.commitLogs();
            //Daily_ClaimsServiceImpl.doRestAPIPost(null, null);
            //Historical_ClaimsServiceImpl.doRestAPIPost(null, null);

            // Run ErrorLogJob
            ErrorLogJob job = new ErrorLogJob();
            Id jobid= Database.executeBatch(job, 200);

            Test.stopTest();

            List<Prior_Auth__c> testPAs = [SELECT Id, Status__c, Error_Log__c FROM Prior_Auth__c WHERE Id =: errorLogs[0].Prior_Auth__c LIMIT 1];
            System.debug('testPAs[0].Id = ' + testPAs[0].Id);
            system.assertequals('Error', testPAs[0].Status__c);
            system.assertequals('Unable to create record due to duplicate.', testPAs[0].Error_Log__c);

        }
    }

}