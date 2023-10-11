@isTest
public class Claim_InformationsTest {

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
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
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
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
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
        dailyClaims.Service_Provider_Fax__c = '8888888888';
        dailyClaims.Service_Provider_Phone__c = '9999999999';
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

        Test.startTest();

        //Contact conList = [SELECT CSA_Account__c from Contact where id =: conRec.id];
        //Claim_Information__c claimList = [SELECT CSA_Account__c from Claim_Information__c where id =:Claims.id ];
        List<Claim_Information__c> claimListCheck = [SELECT id from Claim_Information__c where CSA_Account__c =: dailyClaims.CSA_Account__c];
        system.assertequals(1,claimListCheck.size());
        List<Claim_Information__c> claimList = [SELECT Id, Amount_Paid_By_Primary__c from Claim_Information__c WHERE Claim_Number__c =:'E11111111111111'];
        for(Claim_Information__c claim:claimList){
            system.assertequals(100,claim.Amount_Paid_By_Primary__c);
        }

    }
    @isTest
    public static void testmissingClaimHCPC(){

        Drug__c testDrug = new Drug__c();
        testDrug.J_Code__c = 'J5679';
        testDrug.Drug_Brand_Name__c = 'Drug Two';
        insert testDrug;
        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = '11';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100.11;
        dailyClaims.Prior_Authorization__c = 'A124';
        dailyClaims.Authorized_Representative__c = 'Sam Ank';
        dailyClaims.Authorized_Relationship__c = '2';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'two';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 2';
        dailyClaims.Billing_Provider_PIN__c = '1234568';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '457 Test Lane';
        dailyClaims.Billing_Provider_Zip_Code__c = '10116';
        dailyClaims.Billing_Provider_Phone__c = '3333333333';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'E11111111111112';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '2';
        dailyClaims.Claim_Segment__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = '900988';
        dailyClaims.Days_Supply__c = 31;
        dailyClaims.Diagnosis_Code__c = '12345678988';
        dailyClaims.Drug_Label_Name__c = 'Drug Two';
        dailyClaims.HCPCS_Code__c = 'J5678';
        dailyClaims.NDC__c = '123456790';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-08-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //dailyClaims.Patient_Email_Address__c = 'Samm@test.com';
        dailyClaims.Patient_First_Name__c = 'Sammy';
        dailyClaims.Patient_Last_Name__c = 'andry';
        dailyClaims.Patient_Middle_Initial__c = 'j';
        dailyClaims.Patient_Phone_Number__c = '8888888889';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Infy';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2022-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555556';
        dailyClaims.Service_Provider_Phone__c = '7777777778';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2022-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '457 Plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'samy';
        dailyClaims.Service_Provider_Last_Name__c = 'Aoe';
        dailyClaims.Service_Provider_NPI__c = '9998887777';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10124';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '124 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345679';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10152';
        dailyClaims.CSA_Suffix__c = '27';
        dailyClaims.Total_Coinsurance__c = 31;
        dailyClaims.Total_Copay__c = 32;
        dailyClaims.Total_Deductible__c = 501;
        dailyClaims.Previous_Claim__c = '';
        dailyClaims.Relationship_Code__c = '01';

        insert dailyClaims;
        //Test.startTest();

        List<Daily_Claim__c> ClaimsList = [Select id,Status__c,Error_Log__c from Daily_Claim__c];
        system.assertEquals('Error', ClaimsList.get(0).Status__c);
        system.assertEquals('HCPCS Mismatch', ClaimsList.get(0).Error_Log__c);

        // Test.stopTest();

    }
    @isTest
    public static void testMissingCSA(){

        // Given
        Account accountInstance = new Account(
                Name = 'Test Account'
        );
        insert accountInstance;

        Drug__c testDrug = new Drug__c();
        testDrug.J_Code__c = 'J5679';
        testDrug.Coding_Level__c = 'HCPCS';
        testDrug.Drug_Brand_Name__c = 'Drug Two';
        insert testDrug;

        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                CSA_Control__c = 'CN0001',
                CSA_Suffix__c = 'SN0001',
                CSA_Account__c = 'AN0001'
        );
        insert csaInstance;
        Daily_Claim__c dailyClaimInstance = new Daily_Claim__c(
                HCPCS_Code__c = 'J5679',
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

        Claim_Information__c claims = new Claim_Information__c();
        //insert claims;

        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = 'AN0003';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 103;
        dailyClaims.Prior_Authorization__c = 'A126';
        dailyClaims.Authorized_Representative__c = 'Ras And';
        dailyClaims.Authorized_Relationship__c = '4';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'Four';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 4';
        dailyClaims.Billing_Provider_PIN__c = '1234570';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        dailyClaims.Billing_Provider_Zip_Code__c = '10118';
        dailyClaims.Billing_Provider_Phone__c = '3333333333';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'E11111111111114';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '3';
        dailyClaims.Claim_Segment__c = '00';
        dailyClaims.Coverage_Code_Indicator__c = 'O';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = 'CN0003';
        dailyClaims.Days_Supply__c = 32;
        dailyClaims.Diagnosis_Code__c = '12345678989';
        dailyClaims.Drug_Label_Name__c = 'Drug Four';
        dailyClaims.HCPCS_Code__c = 'J5678';
        //dailyClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaims.NDC__c = '123456792';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaims.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //dailyClaims.Patient_Email_Address__c = 'lara@test.com';
        dailyClaims.Patient_First_Name__c = 'Lara jean';
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
        List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Claim_Information__c =: claims.id ];
        List<Case> caseList = [SELECT id from Case where Claim_Information__c =: claims.id ];

        system.assertequals(1,claimList.size());
        system.assertequals(1,conList.size());
        //system.assertequals(1,contactDrugList.size());
        //system.assertequals(1,caseList.size());



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
                Go_Live_Date__c = date.valueOf('2021-09-09'),
                CSA_Control__c = 'CN0004',
                CSA_Suffix__c = 'SN0004',
                CSA_Account__c = 'AN0004'
        );
        insert csaInstance;

        Claim_Information__c claims = new Claim_Information__c();
        //insert claims;


        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = 'AN0004';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 103;
        dailyClaims.Prior_Authorization__c = 'A127';
        dailyClaims.Authorized_Representative__c = 'Ras And';
        dailyClaims.Authorized_Relationship__c = '4';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'Four';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 4';
        dailyClaims.Billing_Provider_PIN__c = '1234570';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        dailyClaims.Billing_Provider_Zip_Code__c = '10118';
        dailyClaims.Billing_Provider_Phone__c = '3333333333';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'E11111111111114';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '3';
        dailyClaims.Claim_Segment__c = '00';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = 'CN0004';
        dailyClaims.Days_Supply__c = 32;
        dailyClaims.Diagnosis_Code__c = '12345678989';
        dailyClaims.Drug_Label_Name__c = 'Drug Four';
        dailyClaims.HCPCS_Code__c = 'J5678';
        //dailyClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaims.NDC__c = '123456792';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
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
        dailyClaims.CSA_Suffix__c = 'SN0004';
        dailyClaims.Total_Coinsurance__c = 33;
        dailyClaims.Total_Copay__c = 72;
        dailyClaims.Total_Deductible__c = 502;
        dailyClaims.Previous_Claim__c = '';
        dailyClaims.Relationship_Code__c = '01';
        dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0004' + '-' + 'SN0004' + '-' +'AN0004');

        insert dailyClaims;

        Test.startTest();
        List<Contact> conList = [SELECT id from Contact where CSA_Account__c =: dailyClaims.CSA_Account__c];
        List<Claim_Information__c> claimList = [SELECT id from Claim_Information__c where CSA_Account__c =: dailyClaims.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c where Claim_Information__c =: claims.id ];
        List<Case> caseList = [SELECT id from Case where Claim_Information__c =: claims.id ];

        system.assertequals(1,claimList.size());
        system.assertequals(1,conList.size());
        // system.assertequals(1,contactDrugList.size());
        // system.assertequals(1,caseList.size());



        Test.stopTest();

    }
}