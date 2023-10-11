/**
 * Created by ricardy.banks on 3/28/2022.
 */

@IsTest
private class BadDataTest {

    private static Implementation__c implementationInstance;
    private static Contract contractInstance;
    private static Account accountInstance;

    private static void badDataTestSetup(Boolean preGoLive, Boolean allowCaseRouting, Boolean allowMBROutreach) {
        system.debug('modelOfficeTestSetup');

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
                Coding_Level__c = 'HCPCS',
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
                Coding_Level__c = 'HCPCS',
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
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                //Go_Live_Date__c = date.valueOf('2021-11-08'),
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '711',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-'
                        + csaInstance.CSA_Suffix__c + '-'
                        + csaInstance.CSA_Account__c
        );
        //insert csaInstance;
        //System.debug('csaInstance.CSA_Number__c = ' + csaInstance.CSA_Number__c);
        csaList.add(csaInstance);

        System.debug('accountInstance.Id = ' + accountInstance.Id);
        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                //Go_Live_Date__c = date.valueOf('2021-11-08'),
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '757',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-'
                        + csaInstance.CSA_Suffix__c + '-'
                        + csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                //Go_Live_Date__c = date.valueOf('2021-11-08'),
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '911',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-'
                        + csaInstance.CSA_Suffix__c + '-'
                        + csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                //Go_Live_Date__c = date.valueOf('2021-11-08'),
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '777',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-'
                        + csaInstance.CSA_Suffix__c + '-'
                        + csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        insert csaList;
        System.Debug(' csaList[0].CSA_Number__c = ' + csaList[0].CSA_Number__c);
    }

    @IsTest
    public static void dailyClaimBadDataTest()
    {
        Test.startTest();

        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        badDataTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: Insert 2 DCs');
        List<Daily_Claim__c> dailyClaimList = new List<Daily_Claim__c>();
        Daily_Claim__c dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 7000;
        //dailyClaim.Prior_Authorization__c = 'A126';
        dailyClaim.Authorized_Representative__c = 'Adam Pawlik';
        dailyClaim.Authorized_Relationship__c = 'Father';
        dailyClaim.Billing_Provider_City__c = 'Manchester';
        dailyClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Billing_Provider_Last_Name__c = 'Allred';
        dailyClaim.Billing_Provider_Specialty__c = '';
        dailyClaim.Billing_Provider_PIN__c = '1417948050';
        dailyClaim.Billing_Provider_State__c = 'MA';
        dailyClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Billing_Provider_Zip_Code__c = '01944';
        dailyClaim.Billing_Provider_Phone__c = '9785268288';
        dailyClaim.Billing_Provider_Fax__c = '6178970801';
        dailyClaim.Primary_Claim_Number__c = 'P2JKS27W5';
        dailyClaim.Claim_Code__c = 'O';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.Claim_Segment__c = '0';
        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.NDC__c = '44087353501';
        //dailyClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaim.Patient_First_Name__c = 'KHALIAH';
        dailyClaim.Patient_Last_Name__c = 'HINGSTON';
        dailyClaim.Patient_Middle_Initial__c = '';
        dailyClaim.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        dailyClaim.Patient_Gender__c = 'M';
        //dailyClaim.Patient_Email_Address__c = 'lara@test.com';

        dailyClaim.Patient_Phone_Number__c = '5083161245';
        dailyClaim.Plan_Sponsor_Name__c = 'TCS';
        dailyClaim.Preferred_Provider__c = 'Y';
        dailyClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Fax__c = '6178970801';
        dailyClaim.Service_Provider_Phone__c = '9785268288';
        dailyClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Service_Provider_City__c = 'Manchester';
        dailyClaim.Service_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Service_Provider_Last_Name__c = 'Allred';
        dailyClaim.Service_Provider_NPI__c = '1417948050';
        //dailyClaim.Service_Provider_Practice__c = 'NONE';
        dailyClaim.Service_Provider_Zip__c = '01944';
        dailyClaim.Service_Provider_Specialty_Code__c = '';
        dailyClaim.Service_Provider_State__c = 'NY';
        dailyClaim.Patient_Address_Line_1__c = '39276 HACE STREET';
        dailyClaim.Patient_Address_Line_2__c = '';
        dailyClaim.Patient_City__c = 'HOLTSVILLE';
        dailyClaim.Patient_State__c = 'NY';
        dailyClaim.Patient_Zip_Code__c = '00501';
        dailyClaim.Total_Coinsurance__c = 0;
        dailyClaim.Total_Copay__c = 3000;
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                                    dailyClaim.CSA_Control__c + '-'
                                            + dailyClaim.CSA_Suffix__c + '-'
                                            + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        dailyClaimList.add(dailyClaim);

        dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494721';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 7000;
        //dailyClaim.Prior_Authorization__c = 'A126';
        dailyClaim.Authorized_Representative__c = 'Adam Pawlik';
        dailyClaim.Authorized_Relationship__c = 'Father';
        dailyClaim.Billing_Provider_City__c = 'Manchester';
        dailyClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Billing_Provider_Last_Name__c = 'Allred';
        dailyClaim.Billing_Provider_Specialty__c = '';
        dailyClaim.Billing_Provider_PIN__c = '1417948050';
        dailyClaim.Billing_Provider_State__c = 'MA';
        dailyClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Billing_Provider_Zip_Code__c = '01944';
        dailyClaim.Billing_Provider_Phone__c = '9785268288';
        dailyClaim.Billing_Provider_Fax__c = '6178970801';
        dailyClaim.Primary_Claim_Number__c = 'PNFATF4D0';
        dailyClaim.Claim_Code__c = '';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.Claim_Segment__c = '0';
        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.NDC__c = '44087353501';
        //dailyClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaim.Patient_First_Name__c = 'VALERIA';
        dailyClaim.Patient_Last_Name__c = 'CYPHERT';
        dailyClaim.Patient_Middle_Initial__c = '';
        dailyClaim.Patient_Birth_Date__c = date.valueOf('1967-09-23');
        dailyClaim.Patient_Gender__c = 'F';
        //dailyClaim.Patient_Email_Address__c = 'lara@test.com';

        dailyClaim.Patient_Phone_Number__c = '9179770046';
        dailyClaim.Plan_Sponsor_Name__c = 'TCS';
        dailyClaim.Preferred_Provider__c = 'Y';
        dailyClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Fax__c = '6178970801';
        dailyClaim.Service_Provider_Phone__c = '9785268288';
        dailyClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Service_Provider_City__c = 'Manchester';
        dailyClaim.Service_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Service_Provider_Last_Name__c = 'Allred';
        dailyClaim.Service_Provider_NPI__c = '1417948050';
        //dailyClaim.Service_Provider_Practice__c = 'NONE';
        dailyClaim.Service_Provider_Zip__c = '01944';
        dailyClaim.Service_Provider_Specialty_Code__c = '';
        dailyClaim.Service_Provider_State__c = 'MA';
        dailyClaim.Patient_Address_Line_1__c = '15858 JODHPUR STREET';
        dailyClaim.Patient_Address_Line_2__c = '';
        dailyClaim.Patient_City__c = 'HOLTSVILLE';
        dailyClaim.Patient_State__c = 'NY';
        dailyClaim.Patient_Zip_Code__c = '00501';
        dailyClaim.Total_Coinsurance__c = 0;
        dailyClaim.Total_Copay__c = 3000;
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                                    dailyClaim.CSA_Control__c + '-'
                                            + dailyClaim.CSA_Suffix__c + '-'
                                            + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByDailyClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByDailyClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(2,claimList.size());
        system.assertequals(1,contactDrugList.size());
        for (Claim_Information__c claim: claimList){
            List<Case> caseList = [SELECT id FROM Case WHERE Claim_Information__c =: claim.id ];
            system.assertequals(2,caseList.size());}

        //system.assertequals(1,contactDrugList.size());

        // Test Scenario:
        System.Debug('Test Scenario: ');
        Historical_Prior_Auth__c historicalPA = new Historical_Prior_Auth__c();
        historicalPA.Prior_Authorization__c = 'M2113213052';
        historicalPA.Service_Start_Date__c = date.valueOf('2021-11-01');
        historicalPA.Service_End_Date__c = date.valueOf('2021-04-30');
        historicalPA.Prescriber_NPI_Number__c = '1295760288';
        historicalPA.Prescriber_First_Name__c = 'RACHEL';
        historicalPA.Prescriber_Last_Name__c = 'HEPPEN';

        Test.stopTest();

    }

    @IsTest
    public static void badDataPATest()
    {
        Test.startTest();

        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        badDataTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: ');
        List<Prior_Auth__c> priorAuthsList = new List<Prior_Auth__c>();
        Prior_Auth__c priorAuth = new Prior_Auth__c();
        priorAuth.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        priorAuth.CSA_Control__c = '865431';
        priorAuth.CSA_Account__c = '711';
        priorAuth.CSA_Suffix__c = '15';
        priorAuth.Patient_CUMB_ID__c = '185494722';
        priorAuth.Relationship_Code__c = 'M';
        //historicalClaim.COB_Indicator__c = 'N';
        //historicalClaim.Prior_Authorization__c = 'A126';
        priorAuth.Authorized_Representative__c = 'Adam Pawlik';
        priorAuth.Authorized_Relationship__c = 'Father';
        priorAuth.Diagnosis_Code__c = 'C4A30';
        priorAuth.Drug_Label_Name__c = 'BAVENCIO';
        priorAuth.HCPCS_Code__c = 'J9023';
        //historicalClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        priorAuth.NDC__c = '44087353501';
        //historicalClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        priorAuth.Patient_First_Name__c = 'KHALIAH';
        priorAuth.Patient_Last_Name__c = 'HINGSTON';
        priorAuth.Patient_Middle_Initial__c = '';
        priorAuth.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        priorAuth.Patient_Gender__c = 'M';
        //priorAuth.Patient_Email_Address__c = 'lara@test.com';

        priorAuth.Patient_Phone_Number__c = '5083161245';
        priorAuth.Plan_Sponsor_Name__c = 'TCS';
        priorAuth.Service_Provider_Fax__c = '6178970801';
        priorAuth.Service_Provider_Phone__c = '9785268288';
        priorAuth.Service_Provider_Address_Line_1__c = '40 Beach Street';
        priorAuth.Service_Provider_City__c = 'Manchester';
        priorAuth.Service_Provider_First_Name__c = 'Rebecca L';
        priorAuth.Service_Provider_Last_Name__c = 'Allred';
        priorAuth.Service_Provider_NPI__c = '1417948050';
        priorAuth.Service_Provider_Practice__c = 'NONE';
        priorAuth.Service_Provider_Zip__c = '01944';
        priorAuth.Service_Provider_Specialty_Code__c = '';
        priorAuth.Service_Provider_State__c = 'NY';
        priorAuth.Patient_Address_Line_1__c = '39276 HACE STREET';
        priorAuth.Patient_Address_Line_2__c = '';
        priorAuth.Patient_City__c = 'HOLTSVILLE';
        priorAuth.Patient_State__c = 'NY';
        priorAuth.Patient_Zip_Code__c = '00501';
        priorAuth.Relationship_Code__c = '01';
        priorAuth.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                                    priorAuth.CSA_Control__c + '-'
                                            + priorAuth.CSA_Suffix__c + '-'
                                            + priorAuth.CSA_Account__c
        );
        System.Debug('priorAuth.CSA_Number__c = '+priorAuth.CSA_Number__c);

        priorAuthsList.add(priorAuth);

        priorAuth = new Prior_Auth__c();
        priorAuth.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        priorAuth.CSA_Control__c = '865431';
        priorAuth.CSA_Account__c = '711';
        priorAuth.CSA_Suffix__c = '15';
        priorAuth.Patient_CUMB_ID__c = '185494721';
        priorAuth.Relationship_Code__c = 'M';
        //historicalClaim.COB_Indicator__c = 'N';
        //historicalClaim.Prior_Authorization__c = 'A126';
        //priorAuth.Authorized_Representative__c = 'Adam Pawlik';
        priorAuth.Authorized_Relationship__c = 'Father';
        priorAuth.Diagnosis_Code__c = 'C4A30';
        priorAuth.Drug_Label_Name__c = 'BAVENCIO';
        priorAuth.HCPCS_Code__c = 'J9023';
        //historicalClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        priorAuth.NDC__c = '44087353501';
        //historicalClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        priorAuth.Patient_First_Name__c = 'VALERIA';
        priorAuth.Patient_Last_Name__c = 'CYPHERT';
        priorAuth.Patient_Middle_Initial__c = '';
        priorAuth.Patient_Birth_Date__c = date.valueOf('1967-09-23');
        priorAuth.Patient_Gender__c = 'F';
        //priorAuth.Patient_Email_Address__c = 'lara@test.com';

        priorAuth.Patient_Phone_Number__c = '9179770046';
        priorAuth.Plan_Sponsor_Name__c = 'TCS';
        priorAuth.Service_Provider_Fax__c = '6178970801';
        priorAuth.Service_Provider_Phone__c = '9785268288';
        priorAuth.Service_Provider_Address_Line_1__c = '40 Beach Street';
        priorAuth.Service_Provider_City__c = 'Manchester';
        priorAuth.Service_Provider_First_Name__c = 'Rebecca L';
        priorAuth.Service_Provider_Last_Name__c = 'Allred';
        priorAuth.Service_Provider_NPI__c = '1417948050';
        priorAuth.Service_Provider_Practice__c = 'NONE';
        priorAuth.Service_Provider_Zip__c = '01944';
        priorAuth.Service_Provider_Specialty_Code__c = '';
        priorAuth.Service_Provider_State__c = 'MA';
        priorAuth.Patient_Address_Line_1__c = '15858 JODHPUR STREET';
        priorAuth.Patient_Address_Line_2__c = '';
        priorAuth.Patient_City__c = 'HOLTSVILLE';
        priorAuth.Patient_State__c = 'NY';
        priorAuth.Patient_Zip_Code__c = '00501';
        priorAuth.Relationship_Code__c = '01';
        priorAuth.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                                    priorAuth.CSA_Control__c + '-'
                                            + priorAuth.CSA_Suffix__c + '-'
                                            + priorAuth.CSA_Account__c
        );
        System.Debug('priorAuth.CSA_Number__c = '+priorAuth.CSA_Number__c);

        priorAuthsList.add(priorAuth);

        insert priorAuthsList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: historicalClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByPAId = contactsDomain.getExistingContactsByPriorAuthId(priorAuthsList);
        Contact existingContact1 = existingContactsByPAId.get(priorAuthsList[0].Id);
        Contact existingContact2 = existingContactsByPAId.get(priorAuthsList[1].Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('priorAuth.CSA_Number__c = '+priorAuth.CSA_Number__c);
        system.assertequals(false,existingContact1==null, 'No Contacts found');
        system.assertequals(false,existingContact2==null, 'No Contacts found');
        // List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: priorAuth.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList1 = [SELECT Id, Prior_Auth__c FROM Contact_Drug__c WHERE Contact__c =:existingContact1.Id ];
        List<Contact_Drug__c> contactDrugList2 = [SELECT Id, Prior_Auth__c FROM Contact_Drug__c WHERE Contact__c =:existingContact2.Id ];
        system.assertequals(1,contactDrugList1.size(),'Member has no Contact Drugs');
        system.assertequals(1,contactDrugList2.size(),'Member has no Contact Drugs');

//        system.assertequals(2,claimList.size());
        system.assertNotEquals(contactDrugList1[0].Prior_Auth__c,contactDrugList2[0].Prior_Auth__c,'Contact Drug for 2 different members linked to same PA record');
        //for (Claim_Information__c claim: claimList){
        //List<Case> caseList = [SELECT Id FROM Case WHERE Claim_Information__c =: claimList[1].id ];
        //system.assertEquals(2, caseList.size());
        //}

        //system.assertequals(1,contactDrugList.size());

        Test.stopTest();

    }
}