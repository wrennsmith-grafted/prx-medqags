/**
 * Created by ricardy.banks on 3/8/2022.
 */

@IsTest
private class ModelOfficeTest {

    private static Implementation__c implementationInstance;
    private static Contract contractInstance;

    private static void modelOfficeTestSetup() {
        system.debug('modelOfficeTestSetup');

        List<Drug__c> testDrugList = new List<Drug__c>();
        List<CSA__c> csaList = new List<CSA__c>();
        Date goLiveDate = date.valueOf('2021-11-08');

        system.debug('Setup Accounts');
        Account accountInstance = new Account(
                Name = 'Model Office Test-Integration',
                Medical_Drug_List__c = 'PRUDENTMED',
                Go_Live_Date__c = date.valueOf('2021-11-08')
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
                Coding_Level__c = 'HCPCS',
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
                Coding_Level__c = 'HCPCS',
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

        testDrug = new Drug__c(
                J_Code__c = 'J9271',
                Coding_Level__c = 'HCPCS',
                Name = 'IMFINZI-2',
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
                Go_Live_Date__c = date.valueOf('2021-11-08'),
                Medical_Drug_List__c = 'PRUDENTMED',
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '711',
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
                Go_Live_Date__c = date.valueOf('2021-11-08'),
                Medical_Drug_List__c = 'PRUDENTMED',
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '757',
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
                Go_Live_Date__c = date.valueOf('2021-11-08'),
                Medical_Drug_List__c = 'PRUDENTMED',
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '911',
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
                Go_Live_Date__c = date.valueOf('2021-11-08'),
                Medical_Drug_List__c = 'PRUDENTMED',
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '777',
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

    //Model Office
    // Test Scenario: 'Existing patient taking same Drug' but the member will be created instead of updated
    // Test Scenario: Adjudicating Claim when CPA Funds fully available
    @IsTest
    public static void existingPatientTakingSameDrug()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        modelOfficeTestSetup();

        // Test Scenario: 'Existing patient taking same Drug' but the member will be created instead of updated
        System.Debug('Test Scenario: \'Existing patient taking same Drug\' but the member will be created instead of updated');
        Historical_Claim__c historicalClaims = new Historical_Claim__c();
        historicalClaims.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        historicalClaims.CSA_Control__c = '865431';
        historicalClaims.CSA_Account__c = '711';
        historicalClaims.CSA_Suffix__c = '15';
        historicalClaims.Patient_CUMB_ID__c = '185494721';
        historicalClaims.Relationship_Code__c = 'M';
        //historicalClaims.COB_Indicator__c = 'N';
        historicalClaims.Units_Billed__c = 30;
        historicalClaims.Amount_Paid_By_Primary__c = 7000;
        //historicalClaims.Prior_Authorization__c = 'A126';
        //historicalClaims.Authorized_Representative__c = 'Adam Pawlik';
        //historicalClaims.Authorized_Relationship__c = 'Father';
        historicalClaims.Billing_Provider_City__c = 'Manchester';
        historicalClaims.Billing_Provider_First_Name__c = 'Rebecca L';
        historicalClaims.Billing_Provider_Last_Name__c = 'Allred';
        historicalClaims.Billing_Provider_Specialty__c = '';
        historicalClaims.Billing_Provider_PIN__c = '1417948050';
        historicalClaims.Billing_Provider_State__c = 'MA';
        historicalClaims.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        historicalClaims.Billing_Provider_Zip_Code__c = '01944';
        historicalClaims.Billing_Provider_Phone__c = '9785268288';
        historicalClaims.Billing_Provider_Fax__c = '6178970801';
        historicalClaims.Primary_Claim_Number__c = 'PNFATF4D0';
        //historicalClaims.Claim_Code__c = '';
        historicalClaims.Claim_Line__c = '1';
        //historicalClaims.Claim_Segment__c = '0';
        historicalClaims.COB_Code__c = 'Secondary';
        //historicalClaims.Days_Supply__c = 30;
        historicalClaims.Diagnosis_Code__c = 'C4A30';
        historicalClaims.Drug_Label_Name__c = 'BAVENCIO';
        historicalClaims.HCPCS_Code__c = 'J9023';
        //historicalClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        historicalClaims.NDC__c = '44087353501';
        //historicalClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        historicalClaims.Patient_First_Name__c = 'VALERIA';
        historicalClaims.Patient_Last_Name__c = 'CYPHERT';
        historicalClaims.Patient_Middle_Initial__c = '';
        historicalClaims.Patient_Birth_Date__c = date.valueOf('1967-09-23');
        historicalClaims.Patient_Gender__c = 'F';
        //historicalClaims.Patient_Email_Address__c = 'lara@test.com';

        historicalClaims.Patient_Phone_Number__c = '9179770046';
        historicalClaims.Plan_Sponsor_Name__c = 'TCS';
        historicalClaims.Preferred_Provider__c = 'Y';
        historicalClaims.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        historicalClaims.Service_Provider_Fax__c = '6178970801';
        historicalClaims.Service_Provider_Phone__c = '9785268288';
        historicalClaims.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        historicalClaims.Service_Provider_Address_Line_1__c = '40 Beach Street';
        historicalClaims.Service_Provider_City__c = 'Manchester';
        historicalClaims.Service_Provider_First_Name__c = 'Rebecca L';
        historicalClaims.Service_Provider_Last_Name__c = 'Allred';
        historicalClaims.Service_Provider_NPI__c = '1417948050';
        historicalClaims.Service_Provider_Practice__c = 'NONE';
        historicalClaims.Service_Provider_Zip__c = '01944';
        historicalClaims.Service_Provider_Specialty_Code__c = '';
        historicalClaims.Service_Provider_State__c = 'MA';
        historicalClaims.Patient_Address_Line_1__c = '15858 JODHPUR STREET';
        historicalClaims.Patient_Address_Line_2__c = '';
        historicalClaims.Patient_City__c = 'HOLTSVILLE';
        historicalClaims.Patient_State__c = 'NY';
        historicalClaims.Patient_Zip_Code__c = '00501';
        historicalClaims.Total_Coinsurance__c = 0;
        historicalClaims.Total_Copay__c = 3000;
        historicalClaims.Total_Deductible__c = 0;
        //historicalClaims.Previous_Claim__c = '';
        historicalClaims.Relationship_Code__c = '01';
        //historicalClaims.Claim_Adjustment_Amount__c = null;
        //historicalClaims.Coverage_Code_Indicator__c = null;
        historicalClaims.Place_of_Service__c = '11';
        historicalClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(historicalClaims.CSA_Control__c + '-'
                                                                            + historicalClaims.CSA_Suffix__c + '-'
                                                                            + historicalClaims.CSA_Account__c
        );
        System.Debug('historicalClaims.CSA_Number__c = '+historicalClaims.CSA_Number__c);

        insert historicalClaims;
        historicalClaimsList.add(historicalClaims);

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: historicalClaims.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByHistoricalClaimId(historicalClaimsList);
        system.debug('historicalClaims.Id = ' + historicalClaims.Id);
        system.debug('existingContactsByHistoricalClaimId.size() = ' + existingContactsByHistoricalClaimId.size());
        system.debug('existingContactsByHistoricalClaimId = ' + existingContactsByHistoricalClaimId);
        Contact existingContact = existingContactsByHistoricalClaimId.get(historicalClaims.Id);
        system.debug('existingContact = ' + existingContact);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('historicalClaims.CSA_Number__c = '+historicalClaims.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: historicalClaims.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        Set<Id> claimIdSet = new Set<Id>();
        for(Claim_Information__c claimRecord: claimList){
            claimIdSet.add(claimRecord.Id);
        }
        List<Case> caseList = [SELECT id FROM Case WHERE Claim_Information__c IN :claimIdSet];
        system.assertequals(1,caseList.size());

        //system.assertequals(1,contactDrugList.size());
        Test.startTest();
        // Test Scenario: Adjudicating Claim when CPA Funds fully available
        System.Debug('Test Scenario: Adjudicating Claim when CPA Funds fully available');
        historicalClaims = new Historical_Claim__c();
        historicalClaims.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        historicalClaims.CSA_Control__c = '865431';
        historicalClaims.CSA_Account__c = '711';
        historicalClaims.CSA_Suffix__c = '15';
        historicalClaims.Patient_CUMB_ID__c = '185494721';
        historicalClaims.Relationship_Code__c = 'M';
        //historicalClaims.COB_Indicator__c = 'N';
        historicalClaims.Units_Billed__c = 30;
        historicalClaims.Amount_Paid_By_Primary__c = 7000;
        //historicalClaims.Prior_Authorization__c = 'A126';
        //historicalClaims.Authorized_Representative__c = 'Adam Pawlik';
        //historicalClaims.Authorized_Relationship__c = 'Father';
        historicalClaims.Billing_Provider_City__c = 'Manchester';
        historicalClaims.Billing_Provider_First_Name__c = 'Rebecca L';
        historicalClaims.Billing_Provider_Last_Name__c = 'Allred';
        historicalClaims.Billing_Provider_Specialty__c = '';
        historicalClaims.Billing_Provider_PIN__c = '1417948050';
        historicalClaims.Billing_Provider_State__c = 'MA';
        historicalClaims.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        historicalClaims.Billing_Provider_Zip_Code__c = '01944';
        historicalClaims.Billing_Provider_Phone__c = '9785268288';
        historicalClaims.Billing_Provider_Fax__c = '6178970801';
        historicalClaims.Primary_Claim_Number__c = 'PNFATF4D0';
        //historicalClaims.Claim_Code__c = 'O';
        historicalClaims.Claim_Line__c = '1';
        //historicalClaims.Claim_Segment__c = '0';
        historicalClaims.COB_Code__c = 'Secondary';
        //historicalClaims.Days_Supply__c = 30;
        historicalClaims.Diagnosis_Code__c = 'C4A30';
        historicalClaims.Drug_Label_Name__c = 'BAVENCIO';
        historicalClaims.HCPCS_Code__c = 'J9023';
        //historicalClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        historicalClaims.NDC__c = '44087353501';
        //historicalClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        historicalClaims.Patient_First_Name__c = 'VALERIA';
        historicalClaims.Patient_Last_Name__c = 'CYPHERT';
        historicalClaims.Patient_Middle_Initial__c = '';
        historicalClaims.Patient_Birth_Date__c = date.valueOf('1967-09-23');
        historicalClaims.Patient_Gender__c = 'F';
        //historicalClaims.Patient_Email_Address__c = 'lara@test.com';

        historicalClaims.Patient_Phone_Number__c = '9179770046';
        historicalClaims.Plan_Sponsor_Name__c = 'TCS';
        historicalClaims.Preferred_Provider__c = 'Y';
        historicalClaims.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        historicalClaims.Service_Provider_Fax__c = '6178970801';
        historicalClaims.Service_Provider_Phone__c = '9785268288';
        historicalClaims.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        historicalClaims.Service_Provider_Address_Line_1__c = '40 Beach Street';
        historicalClaims.Service_Provider_City__c = 'Manchester';
        historicalClaims.Service_Provider_First_Name__c = 'Rebecca L';
        historicalClaims.Service_Provider_Last_Name__c = 'Allred';
        historicalClaims.Service_Provider_NPI__c = '1417948050';
        historicalClaims.Service_Provider_Practice__c = 'NONE';
        historicalClaims.Service_Provider_Zip__c = '01944';
        historicalClaims.Service_Provider_Specialty_Code__c = '';
        historicalClaims.Service_Provider_State__c = 'MA';
        historicalClaims.Patient_Address_Line_1__c = '15858 JODHPUR STREET';
        historicalClaims.Patient_Address_Line_2__c = '';
        historicalClaims.Patient_City__c = 'HOLTSVILLE';
        historicalClaims.Patient_State__c = 'NY';
        historicalClaims.Patient_Zip_Code__c = '00501';
        historicalClaims.Total_Coinsurance__c = 0;
        historicalClaims.Total_Copay__c = 3000;
        historicalClaims.Total_Deductible__c = 0;
        //historicalClaims.Previous_Claim__c = '';
        historicalClaims.Relationship_Code__c = '01';
        //historicalClaims.Claim_Adjustment_Amount__c = null;
        //historicalClaims.Coverage_Code_Indicator__c = null;
        historicalClaims.Place_of_Service__c = '11';
        historicalClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(historicalClaims.CSA_Control__c + '-'
                                                                            + historicalClaims.CSA_Suffix__c + '-'
                                                                            + historicalClaims.CSA_Account__c
        );
        System.Debug('historicalClaims.CSA_Number__c = '+historicalClaims.CSA_Number__c);

        insert historicalClaims;

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
    public static void dailyClaimTest()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        Test.startTest();
        modelOfficeTestSetup();

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
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
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
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                                                                        + dailyClaim.CSA_Suffix__c + '-'
                                                                        + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(2,claimList.size());
        system.assertequals(1,contactDrugList.size());
        List<Case> caseList = [SELECT id FROM Case WHERE Claim_Information__c =: claimList[1].id ];
        system.assertEquals(2, caseList.size());
        //for (Claim_Information__c claim: claimList){
        //    List<Case> caseList = [SELECT id FROM Case WHERE Claim_Information__c =: claim.id ];
        //    system.assertequals(2,caseList.size());}

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
    public static void historicalClaimTest()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        Test.startTest();
        modelOfficeTestSetup();

        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: Insert 2 DCs');
        List<Historical_Claim__c> historicalClaimList = new List<Historical_Claim__c>();
        Historical_Claim__c historicalClaim = new Historical_Claim__c();
        historicalClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        historicalClaim.CSA_Control__c = '865431';
        historicalClaim.CSA_Account__c = '711';
        historicalClaim.CSA_Suffix__c = '15';
        historicalClaim.Patient_CUMB_ID__c = '185494722';
        historicalClaim.Relationship_Code__c = 'M';
        //historicalClaim.COB_Indicator__c = 'N';
        historicalClaim.Units_Billed__c = 30;
        historicalClaim.Amount_Paid_By_Primary__c = 7000;
        //historicalClaim.Prior_Authorization__c = 'A126';
        //historicalClaim.Authorized_Representative__c = 'Adam Pawlik';
        //historicalClaim.Authorized_Relationship__c = 'Father';
        historicalClaim.Billing_Provider_City__c = 'Manchester';
        historicalClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        historicalClaim.Billing_Provider_Last_Name__c = 'Allred';
        historicalClaim.Billing_Provider_Specialty__c = '';
        historicalClaim.Billing_Provider_PIN__c = '1417948050';
        historicalClaim.Billing_Provider_State__c = 'MA';
        historicalClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        historicalClaim.Billing_Provider_Zip_Code__c = '01944';
        historicalClaim.Billing_Provider_Phone__c = '9785268288';
        historicalClaim.Billing_Provider_Fax__c = '6178970801';
        historicalClaim.Primary_Claim_Number__c = 'P2JKS27W5';
        //historicalClaim.Claim_Code__c = 'O';
        historicalClaim.Claim_Line__c = '1';
        //historicalClaim.Claim_Segment__c = '0';
        historicalClaim.COB_Code__c = 'Secondary';
        //historicalClaim.Days_Supply__c = 30;
        historicalClaim.Diagnosis_Code__c = 'C4A30';
        historicalClaim.Drug_Label_Name__c = 'BAVENCIO';
        historicalClaim.HCPCS_Code__c = 'J9023';
        //historicalClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        historicalClaim.NDC__c = '44087353501';
        //historicalClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        historicalClaim.Patient_First_Name__c = 'KHALIAH';
        historicalClaim.Patient_Last_Name__c = 'HINGSTON';
        historicalClaim.Patient_Middle_Initial__c = '';
        historicalClaim.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        historicalClaim.Patient_Gender__c = 'Male';
        //historicalClaim.Patient_Email_Address__c = 'lara@test.com';

        historicalClaim.Patient_Phone_Number__c = '5083161245';
        historicalClaim.Plan_Sponsor_Name__c = 'TCS';
        historicalClaim.Preferred_Provider__c = 'Y';
        historicalClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        historicalClaim.Service_Provider_Fax__c = '6178970801';
        historicalClaim.Service_Provider_Phone__c = '9785268288';
        historicalClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        historicalClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        historicalClaim.Service_Provider_City__c = 'Manchester';
        historicalClaim.Service_Provider_First_Name__c = 'Rebecca L';
        historicalClaim.Service_Provider_Last_Name__c = 'Allred';
        historicalClaim.Service_Provider_NPI__c = '1417948050';
        historicalClaim.Service_Provider_Practice__c = 'NONE';
        historicalClaim.Service_Provider_Zip__c = '01944';
        historicalClaim.Service_Provider_Specialty_Code__c = '';
        historicalClaim.Service_Provider_State__c = 'NY';
        historicalClaim.Patient_Address_Line_1__c = '39276 HACE STREET';
        historicalClaim.Patient_Address_Line_2__c = '';
        historicalClaim.Patient_City__c = 'HOLTSVILLE';
        historicalClaim.Patient_State__c = 'NY';
        historicalClaim.Patient_Zip_Code__c = '00501';
        historicalClaim.Total_Coinsurance__c = 0;
        historicalClaim.Total_Copay__c = 3000;
        historicalClaim.Total_Deductible__c = 0;
        //historicalClaim.Previous_Claim__c = '';
        historicalClaim.Relationship_Code__c = '01';
        //historicalClaim.Claim_Adjustment_Amount__c = null;
        //historicalClaim.Coverage_Code_Indicator__c = null;
        historicalClaim.Place_of_Service__c = '11';
        historicalClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(historicalClaim.CSA_Control__c + historicalClaim.CSA_Suffix__c + historicalClaim.CSA_Account__c);
        System.Debug('historicalClaim.CSA_Number__c = '+historicalClaim.CSA_Number__c);

        historicalClaimList.add(historicalClaim);

        historicalClaim = new Historical_Claim__c();
        historicalClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        historicalClaim.CSA_Control__c = '865431';
        historicalClaim.CSA_Account__c = '711';
        historicalClaim.CSA_Suffix__c = '15';
        historicalClaim.Patient_CUMB_ID__c = '185494721';
        historicalClaim.Relationship_Code__c = 'M';
        //historicalClaim.COB_Indicator__c = 'N';
        historicalClaim.Units_Billed__c = 30;
        historicalClaim.Amount_Paid_By_Primary__c = 7000;
        //historicalClaim.Prior_Authorization__c = 'A126';
        //historicalClaim.Authorized_Representative__c = 'Adam Pawlik';
        //historicalClaim.Authorized_Relationship__c = 'Father';
        historicalClaim.Billing_Provider_City__c = 'Manchester';
        historicalClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        historicalClaim.Billing_Provider_Last_Name__c = 'Allred';
        historicalClaim.Billing_Provider_Specialty__c = '';
        historicalClaim.Billing_Provider_PIN__c = '1417948050';
        historicalClaim.Billing_Provider_State__c = 'MA';
        historicalClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        historicalClaim.Billing_Provider_Zip_Code__c = '01944';
        historicalClaim.Billing_Provider_Phone__c = '9785268288';
        historicalClaim.Billing_Provider_Fax__c = '6178970801';
        historicalClaim.Primary_Claim_Number__c = 'PNFATF4D0';
        //historicalClaim.Claim_Code__c = '';
        historicalClaim.Claim_Line__c = '1';
        //historicalClaim.Claim_Segment__c = '0';
        historicalClaim.COB_Code__c = 'Secondary';
        //historicalClaim.Days_Supply__c = 30;
        historicalClaim.Diagnosis_Code__c = 'C4A30';
        historicalClaim.Drug_Label_Name__c = 'BAVENCIO';
        historicalClaim.HCPCS_Code__c = 'J9023';
        //historicalClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        historicalClaim.NDC__c = '44087353501';
        //historicalClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        historicalClaim.Patient_First_Name__c = 'VALERIA';
        historicalClaim.Patient_Last_Name__c = 'CYPHERT';
        historicalClaim.Patient_Middle_Initial__c = '';
        historicalClaim.Patient_Birth_Date__c = date.valueOf('1967-09-23');
        historicalClaim.Patient_Gender__c = 'Female';
        //historicalClaim.Patient_Email_Address__c = 'lara@test.com';

        historicalClaim.Patient_Phone_Number__c = '9179770046';
        historicalClaim.Plan_Sponsor_Name__c = 'TCS';
        historicalClaim.Preferred_Provider__c = 'Y';
        historicalClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        historicalClaim.Service_Provider_Fax__c = '6178970801';
        historicalClaim.Service_Provider_Phone__c = '9785268288';
        historicalClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        historicalClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        historicalClaim.Service_Provider_City__c = 'Manchester';
        historicalClaim.Service_Provider_First_Name__c = 'Rebecca L';
        historicalClaim.Service_Provider_Last_Name__c = 'Allred';
        historicalClaim.Service_Provider_NPI__c = '1417948050';
        historicalClaim.Service_Provider_Practice__c = 'NONE';
        historicalClaim.Service_Provider_Zip__c = '01944';
        historicalClaim.Service_Provider_Specialty_Code__c = '';
        historicalClaim.Service_Provider_State__c = 'MA';
        historicalClaim.Patient_Address_Line_1__c = '15858 JODHPUR STREET';
        historicalClaim.Patient_Address_Line_2__c = '';
        historicalClaim.Patient_City__c = 'HOLTSVILLE';
        historicalClaim.Patient_State__c = 'NY';
        historicalClaim.Patient_Zip_Code__c = '00501';
        historicalClaim.Total_Coinsurance__c = 0;
        historicalClaim.Total_Copay__c = 3000;
        historicalClaim.Total_Deductible__c = 0;
        //historicalClaim.Previous_Claim__c = '';
        historicalClaim.Relationship_Code__c = '01';
        //historicalClaim.Claim_Adjustment_Amount__c = null;
        //historicalClaim.Coverage_Code_Indicator__c = null;
        historicalClaim.Place_of_Service__c = '11';
        historicalClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(historicalClaim.CSA_Control__c + historicalClaim.CSA_Suffix__c + historicalClaim.CSA_Account__c);
        System.Debug('historicalClaim.CSA_Number__c = '+historicalClaim.CSA_Number__c);

        historicalClaimList.add(historicalClaim);

        insert historicalClaimList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: historicalClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByHistoricalClaimId(historicalClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(historicalClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('historicalClaim.CSA_Number__c = '+historicalClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: historicalClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(2,claimList.size());
        system.assertequals(1,contactDrugList.size());
        //for (Claim_Information__c claim: claimList){
        List<Case> caseList = [SELECT id FROM Case WHERE Claim_Information__c =: claimList[1].id ];
        system.assertEquals(2, caseList.size());
        //}

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
    public static void priorAuth2MembersSameHCPICSTest()
    {
        Test.startTest();
        modelOfficeTestSetup();

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
        priorAuth.Patient_Gender__c = 'Male';
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
        priorAuth.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(priorAuth.CSA_Control__c + priorAuth.CSA_Suffix__c + priorAuth.CSA_Account__c);
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
        priorAuth.Authorized_Representative__c = 'Adam Pawlik';
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
        priorAuth.Patient_Gender__c = 'Female';
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
        priorAuth.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(priorAuth.CSA_Control__c + priorAuth.CSA_Suffix__c + priorAuth.CSA_Account__c);
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

//****************************************************************************************
    //Model Office Test
    //
    // Overview
    // Goal is to reduce the members co-pay to $0 by getting the manufacture to pay using Co-Pay Assistance Funds or the provider to pay any outstanding balance.
    // Step 1: Prudent gets original claim from Aetna
    // Step 2: Prudent works claim (Out reach via fax, letters, phone to members/health car providers ...) in hopes of securing co-pay
    // Step 3: If co-pay secured, we send response back to Aetna to let them know we secured the co-pay
    // Step 4: If co-apy not secured, we send response back to Aetna to let them know we didn't secure the co-pay
    //          Aetna will issue additional payment to provide so that the member is taken care of.
    //
    // Test Scenario: Scenario 1a: No rework occurred on the original claim within ACAS(Aetna's system)
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            Full funds available. Full Co-Pay Assistance Funds available from manufacturer so they will pay $30, Plan Paid $70 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void noReworkFullFundsAvailableTest()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        modelOfficeTestSetup();

        // Original Claim
        // Pre-prudent picture of adjudication & file transfer to Prudent
        System.Debug('Test Scenario: Scenario 1:  No rework occurred on the original claim within ACAS');
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E11111111';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        //dailyClaimList.add(dailyClaim);
        insert dailyClaim;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];

        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        if(claimList != null) {
            claimList[0].CPA_Indicator__c = 'Opt-in - Paid in full';
            claimList[0].CPA_Funds_Paid__c = 30;
        }
        update claimList;

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E11111111';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 30;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;


        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        claimList = [SELECT Id, Send_to_ACAS__c, CPA_Funds_Paid__c, Amount_Paid_By_Primary__c FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        system.assertequals(1,claimList.size());
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        system.assertequals(30,claimList[0].CPA_Funds_Paid__c, '30$ should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c');
        system.assertequals(70,claimList[0].Amount_Paid_By_Primary__c, '70$ should be Plan Paid (amount applied by Aetna)');
        system.assertequals('Queued',claimList[0].Send_to_ACAS__c,'Send to ACAS(Aetna) field should be set to Queued');

        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c,
                                RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
                                FROM Case
                                WHERE Claim_Information__c =: claimList[0].id
        ];
        system.assertEquals(2, caseList.size(), '1 Enrollment case & 1 Rembursement should be created.');
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            //contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                //system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
            }
            //Claim adjustment will be triggered, original seg will be changed to status 91, new claim segment will be created to
            // Override Copay to 0 and 30$ will be captured in some other field in ACAS (Copay adjustment bucket), so that we balance out from ACAS perse
            if(caseRec.RecordType.Name == 'Rembursement') {
                system.assertEquals(0, caseRec.Copay_Card_amount_Paid__c, 'Should be 0. Adjusted claim with the Prudent should applied copay assist dollars)');
                //system.assertEquals(30, caseRec.Copay_Card_amount_Paid__c, '');
            }
        }

        Test.stopTest();
    }

    // Test Scenario: Scenario 1b: No rework occurred on the original claim within ACAS(Aetna's system)
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            Partial funds available. Not enough Co-Pay Assistance Funds available from manufacturer so they will pay $20, Plan Paid $80 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void noReworkPartialFundsAvailableTest()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        modelOfficeTestSetup();

        // Original Claim
        // Pre-prudent picture of adjudication & file transfer to Prudent
        System.Debug('Test Scenario: Scenario 1:  No rework occurred on the original claim within ACAS');
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E11111111';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        //dailyClaimList.add(dailyClaim);
        insert dailyClaim;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];

        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        if(claimList != null) {
            claimList[0].CPA_Indicator__c = 'Opt-in - Partial payment';
            claimList[0].CPA_Funds_Paid__c = 20;
        }
        update claimList;

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E11111111';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 20;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 80;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;


        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        claimList = [SELECT Id, Send_to_ACAS__c, CPA_Funds_Paid__c, Amount_Paid_By_Primary__c FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        system.assertequals(1,claimList.size());
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        system.assertequals(20,claimList[0].CPA_Funds_Paid__c, '20$ should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c');
        //system.assertequals(80,claimList[0].Amount_Paid_By_Primary__c, '80$ should be Plan Paid (amount applied by Aetna). Underpayment will be issued for 10$');
        system.assertequals('Queued',claimList[0].Send_to_ACAS__c,'Send to ACAS(Aetna) field should be set to Queued');

        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c,
                RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
        FROM Case
        WHERE Claim_Information__c =: claimList[0].id
        ];
        system.assertEquals(2, caseList.size(), '1 Enrollment case & 1 Rembursement should be created.');
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            //contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                //system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
            }
            //Claim adjustment will be triggered, original seg will be changed to status 91, new claim segment will be created to
            // Override Copay to 0 and 30$ will be captured in some other field in ACAS (Copay adjustment bucket), so that we balance out from ACAS perse
            if(caseRec.RecordType.Name == 'Rembursement') {
                system.assertEquals(0, caseRec.Copay_Card_amount_Paid__c, 'Should be 0. Adjusted claim with the Prudent should applied copay assist dollars)');
                //system.assertEquals(30, caseRec.Copay_Card_amount_Paid__c, '');
            }
        }

        Test.stopTest();
    }

    // Test Scenario: Scenario 1c: No rework occurred on the original claim within ACAS(Aetna's system)
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            No funds available. No Co-Pay Assistance Funds available from manufacturer so they will pay $0, Plan Paid $100 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void noReworkNoFundsAvailableTest()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        modelOfficeTestSetup();

        // Original Claim
        // Pre-prudent picture of adjudication & file transfer to Prudent
        System.Debug('Test Scenario: Scenario 1:  No rework occurred on the original claim within ACAS');
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E11111111';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        //dailyClaimList.add(dailyClaim);
        insert dailyClaim;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];

        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        if(claimList != null) {
            claimList[0].CPA_Indicator__c = 'Opt-in - Funds exhausted';
            claimList[0].CPA_Funds_Paid__c = 0;
        }
        update claimList;

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E11111111';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 0;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 100;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;


        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        claimList = [SELECT Id, Send_to_ACAS__c, CPA_Funds_Paid__c, Amount_Paid_By_Primary__c FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        system.assertequals(1,claimList.size());
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        system.assertequals(0,claimList[0].CPA_Funds_Paid__c, '0$ should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c. Copay funds exhausted.');
        system.assertequals(100,claimList[0].Amount_Paid_By_Primary__c, '100$ should be Plan Paid (amount applied by Aetna). Underpayment will be issued for 30$');
        system.assertequals('Queued',claimList[0].Send_to_ACAS__c,'Send to ACAS(Aetna) field should be set to Queued');

        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c,
                RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
        FROM Case
        WHERE Claim_Information__c =: claimList[0].id
        ];
        system.assertEquals(2, caseList.size(), '1 Enrollment case & 1 Rembursement should be created.');
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            //contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                //system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
            }
            //Claim adjustment will be triggered, original seg will be changed to status 91, new claim segment will be created to
            // Override Copay to 0 and 30$ will be captured in some other field in ACAS (Copay adjustment bucket), so that we balance out from ACAS perse
            if(caseRec.RecordType.Name == 'Rembursement') {
                system.assertEquals(0, caseRec.Copay_Card_amount_Paid__c, 'Should be 0. Adjusted claim with the Prudent should applied copay assist dollars)');
                //system.assertEquals(30, caseRec.Copay_Card_amount_Paid__c, '');
            }
        }

        Test.stopTest();

    }

    // Test Scenario: Scenario 2: Single claim ID with multiple expense lines - various flavors - different eligible J-Codes on it or same J-Code with different NDCs on these expense lines or same jcode with same NDCs
    //                            Original claim 1 $30 Copay/$70 Plan Paid. Exp Line # 1(Drug 1), J-Code J9023
    //                            Original claim 2 $30 Copay/$70 Plan Paid. Exp Line # 2(Drug 2), J-Code J9023
    //                                One Contact_Drug with 2 Claims will be created
    //                            Full funds available. Full Co-Pay Assistance Funds available from manufacturer so they will pay $30, Plan Paid $70 and Copay $0 for Drug 1
    //                            Full funds available. Full Co-Pay Assistance Funds available from manufacturer so they will pay $30, Plan Paid $70 and Copay $0 for Drug 2
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    //
    //                            Expectation is that all of these will be handled on an expense line level as per scenario 1 documented above
    @IsTest
    public static void singleClaimIDMultiExpLinesSameJCodeFundsAvailableTest()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        modelOfficeTestSetup();

        // Original Claim
        // Pre-prudent picture of adjudication & file transfer to Prudent
        System.Debug('Test Scenario: Scenario 2: Single claim ID with multiple expense lines - various flavors - different eligible J-Codes on it or same J-Code with different NDCs on these expense lines or same jcode with same NDCs');
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E22222221';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E22222221';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '2';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];

        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        List<Claim_Information__c> adjustedClaims = new List<Claim_Information__c>();
        for(Claim_Information__c claimRecord: claimList) {
            claimRecord.CPA_Indicator__c = 'Opt-in - Paid in full';
            claimRecord.CPA_Funds_Paid__c = 30;
            adjustedClaims.add(claimRecord);
        }
        update adjustedClaims;

        dailyClaimList = new List<Daily_Claim__c>();
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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E22222221';
        dailyClaim.Claim_Segment__c = '01';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 30;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E22222221';
        dailyClaim.Claim_Segment__c = '01';
        dailyClaim.Claim_Line__c = '2';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 30;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;


        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        claimList = [SELECT Id, Send_to_ACAS__c, CPA_Funds_Paid__c, Amount_Paid_By_Primary__c FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        system.assertequals(4,claimList.size());
        Set<Id> claimIdSet = new Set<Id>();
        for(Claim_Information__c claimRecord: claimList){
            claimIdSet.add(claimRecord.Id);
        }
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        system.assertequals(30,claimList[0].CPA_Funds_Paid__c, '30$ should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c');
        system.assertequals(70,claimList[0].Amount_Paid_By_Primary__c, '70$ should be Plan Paid (amount applied by Aetna)');
        system.assertequals('Queued',claimList[0].Send_to_ACAS__c,'Send to ACAS(Aetna) field should be set to Queued');
        system.assertequals(30,claimList[1].CPA_Funds_Paid__c, '30$ should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c');
        system.assertequals(70,claimList[1].Amount_Paid_By_Primary__c, '70$ should be Plan Paid (amount applied by Aetna)');
        system.assertequals('Queued',claimList[1].Send_to_ACAS__c,'Send to ACAS(Aetna) field should be set to Queued');

        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c,
                RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
                                FROM Case
                                WHERE Claim_Information__c IN :claimIdSet
        ];
        system.assertEquals(7, caseList.size(), '2 Enrollment cases with 5 Rembursement Cases should be create');
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            //contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                //system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
            }
            //Claim adjustment will be triggered, original seg will be changed to status 91, new claim segment will be created to
            // Override Copay to 0 and 30$ will be captured in some other field in ACAS (Copay adjustment bucket), so that we balance out from ACAS perse
            if(caseRec.RecordType.Name == 'Rembursement') {
                system.assertEquals(0, caseRec.Copay_Card_amount_Paid__c, 'Should be 0. Adjusted claim with the Prudent should applied copay assist dollars)');
                //system.assertEquals(30, caseRec.Copay_Card_amount_Paid__c, '');
            }
        }

        Test.stopTest();

    }

    // Question: Why are there different Seg for each drug?
    // Test Scenario: Scenario 3: Segmented claim - no rework but multiple segments for the same claim
    //                            Original claim 1 $30 Copay/$70 Plan Paid. Exp Line # 1(Drug 1), J-Code J9023
    //                            Original claim 2 $30 Copay/$70 Plan Paid. Exp Line # 2(Drug 2), J-Code J0178
    //                                2 Contact_Drug with 1 Claims each will be created
    //                            Full funds available. Full Co-Pay Assistance Funds available from manufacturer so they will pay $30, Plan Paid $70 and Copay $0 for Drug 1
    //                            Full funds available. Full Co-Pay Assistance Funds available from manufacturer so they will pay $30, Plan Paid $70 and Copay $0 for Drug 2
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void singleClaimIDMultiExpLinesDiffJCodeFundsAvailableTest()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        modelOfficeTestSetup();

        // Original Claim
        // Pre-prudent picture of adjudication & file transfer to Prudent
        System.Debug('Test Scenario: Scenario 3: Segmented claim - no rework but multiple segments for the same claim');
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J1234'; //Should case a HCPCS Missmatch & nothing processed.
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '2';
        dailyClaim.HCPCS_Code__c = 'J1234'; //Should case a HCPCS Missmatch & nothing processed.
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '3';
        dailyClaim.HCPCS_Code__c = 'J1234'; //Should case a HCPCS Missmatch & nothing processed.
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '4';
        dailyClaim.HCPCS_Code__c = 'J1234'; //Should case a HCPCS Missmatch & nothing processed.
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '5';
        dailyClaim.HCPCS_Code__c = 'J1234'; //Should case a HCPCS Missmatch & nothing processed.
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E22222221';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '6';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 30;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '01';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J1234'; //Should case a HCPCS Missmatch & nothing processed.
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '01';
        dailyClaim.Claim_Line__c = '2';
        dailyClaim.HCPCS_Code__c = 'J0178';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 30;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];

        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        List<Claim_Information__c> adjustedClaims = new List<Claim_Information__c>();
        for(Claim_Information__c claimRecord: claimList) {
            claimRecord.CPA_Indicator__c = 'Opt-in - Paid in full';
            claimRecord.CPA_Funds_Paid__c = 30;
            adjustedClaims.add(claimRecord);
        }
        update adjustedClaims;

        dailyClaimList = new List<Daily_Claim__c>();
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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '02';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J1234';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = null;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '02';
        dailyClaim.Claim_Line__c = '2';
        dailyClaim.HCPCS_Code__c = 'J1234';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = null;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '02';
        dailyClaim.Claim_Line__c = '3';
        dailyClaim.HCPCS_Code__c = 'J1234';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = null;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '02';
        dailyClaim.Claim_Line__c = '4';
        dailyClaim.HCPCS_Code__c = 'J1234';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = null;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '02';
        dailyClaim.Claim_Line__c = '5';
        dailyClaim.HCPCS_Code__c = 'J1234';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = null;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '02';
        dailyClaim.Claim_Line__c = '6';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 0;
        dailyClaim.Claim_Adjustment_Amount__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '03';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J1234';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = null;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = null;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E33333333';
        dailyClaim.Claim_Segment__c = '02';
        dailyClaim.Claim_Line__c = '2';
        dailyClaim.HCPCS_Code__c = 'J0178';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 0;
        dailyClaim.Claim_Adjustment_Amount__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;


        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        claimList = [SELECT Id, Send_to_ACAS__c, CPA_Funds_Paid__c, Amount_Paid_By_Primary__c FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        system.assertequals(4,claimList.size());
        Set<Id> claimIdSet = new Set<Id>();
        for(Claim_Information__c claimRecord: claimList){
            claimIdSet.add(claimRecord.Id);
        }
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        system.assertequals(30,claimList[0].CPA_Funds_Paid__c, '30$ should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c');
        system.assertequals(70,claimList[0].Amount_Paid_By_Primary__c, '70$ should be Plan Paid (amount applied by Aetna)');
        system.assertequals('Queued',claimList[0].Send_to_ACAS__c,'Send to ACAS(Aetna) field should be set to Queued');
        system.assertequals(30,claimList[1].CPA_Funds_Paid__c, '30$ should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c');
        system.assertequals(70,claimList[1].Amount_Paid_By_Primary__c, '70$ should be Plan Paid (amount applied by Aetna)');
        system.assertequals('Queued',claimList[1].Send_to_ACAS__c,'Send to ACAS(Aetna) field should be set to Queued');

        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c,
                RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
        FROM Case
        WHERE Claim_Information__c IN :claimIdSet
        ];
        system.assertEquals(7, caseList.size(), '2 Enrollment cases with 5 Rembursement Cases should be create');
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            //contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                //system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
            }
            //Claim adjustment will be triggered, original seg will be changed to status 91, new claim segment will be created to
            // Override Copay to 0 and 30$ will be captured in some other field in ACAS (Copay adjustment bucket), so that we balance out from ACAS perse
            if(caseRec.RecordType.Name == 'Rembursement') {
                system.assertEquals(0, caseRec.Copay_Card_amount_Paid__c, 'Should be 0. Adjusted claim with the Prudent should applied copay assist dollars)');
                //system.assertEquals(30, caseRec.Copay_Card_amount_Paid__c, '');
            }
        }

        Test.stopTest();
    }

    // Test Scenario: Scenario 4: No provider response - Send over a claim from ACAS to Prudent and Prudent doesn't hear back from the provider
    //                            Original claim 1 $30 Copay/$70 Plan Paid. Exp Line #1(Drug 1), J-Code J9023
    //                                2 Contact_Drug with 1 Claims each will be created
    //                            No provider response, no Co-Pay Assistance Funds from manufacturer so they will pay $0, Plan Paid $70 and Copay $30 for Drug 1
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void noProviderResponseTest()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        modelOfficeTestSetup();

        // Original Claim
        // Pre-prudent picture of adjudication & file transfer to Prudent
        System.Debug('Test Scenario: Scenario 4: No provider response - Send over a claim from ACAS to Prudent and Prudent doesn\'t hear back from the provider');
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E12111111';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 30;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        //dailyClaimList.add(dailyClaim);
        insert dailyClaim;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];

        //No provider response - Send over a claim from ACAS to Prudent and Prudent doesn't hear back from the provider
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        if(claimList != null) {
            claimList[0].CPA_Indicator__c = 'Opt-in - Reimbursement not Confirmed';
            claimList[0].CPA_Funds_Paid__c = 0;
        }
        update claimList;

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E12111111';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 0;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;


        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        claimList = [SELECT Id, Send_to_ACAS__c, CPA_Funds_Paid__c, Amount_Paid_By_Primary__c FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        system.assertequals(1,claimList.size());
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        system.assertequals(0,claimList[0].CPA_Funds_Paid__c, '30$ should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c');
        system.assertequals(70,claimList[0].Amount_Paid_By_Primary__c, '70$ should be Plan Paid (amount applied by Aetna)');
        system.assertequals('Queued',claimList[0].Send_to_ACAS__c,'Send to ACAS(Aetna) field should be set to Queued');

        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c,
                RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
        FROM Case
        WHERE Claim_Information__c =: claimList[0].id
        ];
        system.assertEquals(2, caseList.size(), '1 Enrollment case & 1 Rembursement should be created.');
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            //contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                //system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
            }
            //Claim adjustment will be triggered, original seg will be changed to status 91, new claim segment will be created to
            // Override Copay to 0 and 30$ will be captured in some other field in ACAS (Copay adjustment bucket), so that we balance out from ACAS perse
            if(caseRec.RecordType.Name == 'Rembursement') {
                system.assertEquals(30, caseRec.Copay_Card_amount_Paid__c, 'Should be 0. No Provider Response');
                //system.assertEquals(30, caseRec.Copay_Card_amount_Paid__c, '');
            }
        }

        Test.stopTest();
    }

    // Test Scenario: Scenario 5: Member opt out
    //                            Original claim 1 $30 Copay/$70 Plan Paid. Exp Line #1(Drug 1), J-Code J9023
    //                            Member opt out, no Co-Pay Assistance Funds from manufacturer so they will pay $0, Plan Paid $70 and Copay $30 for Drug 1
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void memberOptOutTest()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        modelOfficeTestSetup();

        // Original Claim
        // Pre-prudent picture of adjudication & file transfer to Prudent
        System.Debug('Test Scenario: Scenario 5: Member opt out');
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E12121212';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 30;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        //dailyClaimList.add(dailyClaim);
        insert dailyClaim;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];

        //No provider response - Send over a claim from ACAS to Prudent and Prudent doesn't hear back from the provider
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        if(claimList != null) {
            claimList[0].CPA_Indicator__c = 'Opt-out - Member not Enrolled';
            claimList[0].CPA_Funds_Paid__c = 0;
        }
        update claimList;

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E12121212';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 0;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;


        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        claimList = [SELECT Id, Send_to_ACAS__c, CPA_Funds_Paid__c, Amount_Paid_By_Primary__c FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        system.assertequals(1,claimList.size());
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        system.assertequals(0,claimList[0].CPA_Funds_Paid__c, '30$ should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c');
        system.assertequals(70,claimList[0].Amount_Paid_By_Primary__c, '70$ should be Plan Paid (amount applied by Aetna)');
        system.assertequals('Queued',claimList[0].Send_to_ACAS__c,'Send to ACAS(Aetna) field should be set to Queued');

        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c,
                RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
        FROM Case
        WHERE Claim_Information__c =: claimList[0].id
        ];
        system.assertEquals(2, caseList.size(), '1 Enrollment case & 1 Rembursement should be created.');
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            //contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                //system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
            }
            //Claim adjustment will be triggered, original seg will be changed to status 91, new claim segment will be created to
            // Override Copay to 0 and 30$ will be captured in some other field in ACAS (Copay adjustment bucket), so that we balance out from ACAS perse
            if(caseRec.RecordType.Name == 'Rembursement') {
                system.assertEquals(30, caseRec.Copay_Card_amount_Paid__c, 'Should be 0. No Provider Response');
                //system.assertEquals(30, caseRec.Copay_Card_amount_Paid__c, '');
            }
        }

        Test.stopTest();
    }

    // Test Scenario: Scenario 6a: KEYTRUDA - Minimum member pay per fill - 25$ min mbr pay per fill;
    //                            Original claim $300 Copay/$700 Plan Paid.
    //                            Full funds available. Partial Co-Pay Assistance Funds available from manufacturer so they will pay $275, Plan Paid $725 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void minMemberPayFullFundsAvailableTest()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        modelOfficeTestSetup();

        // Original Claim
        // Pre-prudent picture of adjudication & file transfer to Prudent
        System.Debug('Test Scenario: Scenario 6a: KEYTRUDA - Minimum member pay per fill - 25$ min mbr pay per fill');
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E13131313';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9271';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 300;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 700;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        dailyClaim.EOP_Date__c = System.today().addDays(-10);
        //Deductible Accum Updated
        //MOOP Updated

        //dailyClaimList.add(dailyClaim);
        insert dailyClaim;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];

        //No provider response - Send over a claim from ACAS to Prudent and Prudent doesn't hear back from the provider
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        if(claimList != null) {
            claimList[0].CPA_Indicator__c = 'Opt-in - Partial payment';
            claimList[0].CPA_Funds_Paid__c = 275;
        }
        update claimList;

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E13131313';
        dailyClaim.Claim_Segment__c = '01';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9271';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 0;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 725;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        dailyClaim.EOP_Date__c = System.today().addDays(-10);
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;


        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        claimList = [SELECT Id, Send_to_ACAS__c, CPA_Funds_Paid__c, Amount_Paid_By_Primary__c FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        system.assertequals(2,claimList.size());
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        system.assertequals(275,claimList[0].CPA_Funds_Paid__c, '275$ should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c');
        system.assertequals(725,claimList[1].Amount_Paid_By_Primary__c, '725$ should be Plan Paid (amount applied by Aetna). "Underpayment process will be initiated for 25$');
        system.assertequals('Queued',claimList[0].Send_to_ACAS__c,'Send to ACAS(Aetna) field should be set to Queued');

        Set<Id> claimIds = new Set<Id>();
        for(Claim_Information__c claim: claimList) {
            claimIds.add(claim.Id);
        }

        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c,
                                RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
                                FROM Case
                                WHERE Claim_Information__c IN : claimIds
                                ];
        system.assertEquals(3, caseList.size(), '1 Enrollment case & 2 Rembursement should be created.');
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            //contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                //system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
            }
            //Claim adjustment will be triggered, original seg will be changed to status 91, new claim segment will be created to
            // Override Copay to 0 and 30$ will be captured in some other field in ACAS (Copay adjustment bucket), so that we balance out from ACAS perse
            if(caseRec.RecordType.Name == 'Rembursement') {
                system.assertEquals(0, caseRec.Copay_Card_amount_Paid__c, 'Should be 0. Adjusted claim with the Prudent applied copay assist dollars');
                //system.assertEquals(30, caseRec.Copay_Card_amount_Paid__c, '');
            }
        }

        Test.stopTest();
    }

    // Test Scenario: Scenario 6b: KEYTRUDA - Minimum member pay per fill - 25$ min mbr pay per fill;
    //                            Original claim $300 Copay/$700 Plan Paid.
    //                            Partial funds available - assume $100 CPA funds available. Partial Co-Pay Assistance Funds available from manufacturer so they will pay $100, Plan Paid $900 underpayment for $200 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void minMemberPayPartialFundsAvailableTest()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        modelOfficeTestSetup();

        // Original Claim
        // Pre-prudent picture of adjudication & file transfer to Prudent
        System.Debug('Test Scenario: Scenario 6b: KEYTRUDA - Minimum member pay per fill - 25$ min mbr pay per fill');
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E13333333';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9271';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 300;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 700;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        dailyClaim.EOP_Date__c = System.today().addDays(-10);
        //Deductible Accum Updated
        //MOOP Updated

        //dailyClaimList.add(dailyClaim);
        insert dailyClaim;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];

        //No provider response - Send over a claim from ACAS to Prudent and Prudent doesn't hear back from the provider
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        if(claimList != null) {
            claimList[0].CPA_Indicator__c = 'Opt-in - Partial payment';
            claimList[0].CPA_Funds_Paid__c = 100;
        }
        update claimList;

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E13333333';
        dailyClaim.Claim_Segment__c = '01';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9271';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 0;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 900;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        dailyClaim.EOP_Date__c = System.today().addDays(-10);
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;


        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        claimList = [SELECT Id, Send_to_ACAS__c, CPA_Funds_Paid__c, Amount_Paid_By_Primary__c FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        system.assertequals(2,claimList.size());
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        system.assertequals(100,claimList[0].CPA_Funds_Paid__c, '100$ should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c');
        system.assertequals(900,claimList[1].Amount_Paid_By_Primary__c, '900$ should be Plan Paid (amount applied by Aetna). "Underpayment process will be initiated for 25$ \n' +
                '"');
        system.assertequals('Queued',claimList[0].Send_to_ACAS__c,'Send to ACAS(Aetna) field should be set to Queued');

        Set<Id> claimIds = new Set<Id>();
        for(Claim_Information__c claim: claimList) {
            claimIds.add(claim.Id);
        }

        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c,
                RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
                                FROM Case
                                WHERE Claim_Information__c IN : claimIds
        ];
        system.assertEquals(3, caseList.size(), '1 Enrollment case & 2 Rembursement should be created.');
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            //contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                //system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
            }
            //Claim adjustment will be triggered, original seg will be changed to status 91, new claim segment will be created to
            // Override Copay to 0 and 30$ will be captured in some other field in ACAS (Copay adjustment bucket), so that we balance out from ACAS perse
            if(caseRec.RecordType.Name == 'Rembursement') {
                system.assertEquals(0, caseRec.Copay_Card_amount_Paid__c, 'Should be 0. Adjusted claim with the Prudent applied copay assist dollars');
                //system.assertEquals(30, caseRec.Copay_Card_amount_Paid__c, '');
            }
        }

        Test.stopTest();
    }

    // Test Scenario: Scenario 6c: KEYTRUDA - Minimum member pay per fill - 25$ min mbr pay per fill;
    //                            Original claim $300 Copay/$700 Plan Paid.
    //                            No funds available. No Co-Pay Assistance Funds available from manufacturer so they will pay $0, Plan Paid $1000 underpayment for $300 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void minMemberPayNoFundsAvailableTest()
    {
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        modelOfficeTestSetup();

        // Original Claim
        // Pre-prudent picture of adjudication & file transfer to Prudent
        System.Debug('Test Scenario: Scenario 6c: KEYTRUDA - Minimum member pay per fill - 25$ min mbr pay per fill');
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E13333331';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9271';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 300;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 700;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        dailyClaim.EOP_Date__c = System.today().addDays(-10);
        //Deductible Accum Updated
        //MOOP Updated

        //dailyClaimList.add(dailyClaim);
        insert dailyClaim;

        Test.startTest();

        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];

        //No provider response - Send over a claim from ACAS to Prudent and Prudent doesn't hear back from the provider
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        if(claimList != null) {
            claimList[0].CPA_Indicator__c = 'Opt-in - Funds exhausted';
            claimList[0].CPA_Funds_Paid__c = 0;
        }
        update claimList;

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
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        //Post-prudent picture of adjudication for adjustment
        dailyClaim.Primary_Claim_Number__c = 'E13333331';
        dailyClaim.Claim_Segment__c = '01';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9271';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 0;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 1000;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        dailyClaim.EOP_Date__c = System.today().addDays(-10);
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;


        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        claimList = [SELECT Id, Send_to_ACAS__c, CPA_Funds_Paid__c, Amount_Paid_By_Primary__c FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        system.assertequals(2,claimList.size());
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        system.assertequals(0,claimList[0].CPA_Funds_Paid__c, '100$ should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c');
        system.assertequals(1000,claimList[1].Amount_Paid_By_Primary__c, '900$ should be Plan Paid (amount applied by Aetna). "Underpayment process will be initiated for 25$ \n' +
                '"');
        system.assertequals('Queued',claimList[0].Send_to_ACAS__c,'Send to ACAS(Aetna) field should be set to Queued');

        Set<Id> claimIds = new Set<Id>();
        for(Claim_Information__c claim: claimList) {
            claimIds.add(claim.Id);
        }

        List<Case> caseList = [SELECT Id, Most_Recent_Service_From_Date__c, Status, Contact_Drug__r.Copay_Enrollment_Status__c,
                RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
                    FROM Case
                    WHERE Claim_Information__c IN : claimIds
        ];
        system.assertEquals(3, caseList.size(), '1 Enrollment case & 2 Rembursement should be created.');
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            //contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                //system.assertEquals(date.valueOf('2022-07-21'),caseRec.Most_Recent_Service_From_Date__c, 'Case.Most_Recent_Service_From_Date__c is not correct');
            }
            //Claim adjustment will be triggered, original seg will be changed to status 91, new claim segment will be created to
            // Override Copay to 0 and 30$ will be captured in some other field in ACAS (Copay adjustment bucket), so that we balance out from ACAS perse
            if(caseRec.RecordType.Name == 'Rembursement') {
                system.assertEquals(0, caseRec.Copay_Card_amount_Paid__c, 'Should be 0. Adjusted claim with the Prudent applied copay assist dollars');
                //system.assertEquals(30, caseRec.Copay_Card_amount_Paid__c, '');
            }
        }

        Test.stopTest();
    }

    // Test Scenario: Scenario 7: Rework occurred on the original claim within ACAS(Aetna's system)
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            Prudent sent response on Seg 00 for the $30 Co-Pay Assistance Funds but Seg 01 is the latest change by Member cost share.
    //                            ACAS sends Rework claim as Seg 01 indicating a $20 Co-pay/$80 Plan Paid
    //                            ACAS sends Reject claim on Seg 00 the Original claim because Prudent had responded on the rejected claim
    //                            Prudent works rework claim
    //                            Full funds available. Full Co-Pay Assistance Funds available from manufacturer so they will pay $20, Plan Pad $80 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void reworkResponseSentFullFundsAvailableTest()
    {

        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        modelOfficeTestSetup();

        // Original Claim
        // Pre-prudent picture of adjudication & file transfer to Prudent
        System.Debug('Test Scenario: Scenario 7: Rework occurred on the original claim within ACAS(Aetna\'s system)');
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.HCPCS_Code__c = 'J9023';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        insert dailyClaim;

        Test.startTest();

        dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
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
        dailyClaim.Claim_Code__c = 'O';

        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.HCPCS_Code__c = 'J9023';
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

        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        //Key fields that change to create scenario
        dailyClaim.Primary_Claim_Number__c = 'E44444444';
        dailyClaim.Claim_Segment__c = '00';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.Total_Deductible__c =
        dailyClaim.Total_Copay__c = 30;
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Amount_Paid_By_Primary__c = 70;
        dailyClaim.Coverage_Code_Indicator__c = 'Y'; //Med Copay Ind at Exp line level from ACAS
        dailyClaim.Funding_Indicator__c = 'O'; //Original: Claim level Indicator from ACAS
        //dailyClaim. //PRx Indicator (Prudent Ind at Exp Line level)
        dailyClaim.Previous_Segment__c =  null;
        //Deductible Accum Updated
        //MOOP Updated

        dailyClaimList.add(dailyClaim);
        insert dailyClaim;

        //List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE Primary_Claim_Number__c = 'E44444444'];
        List<Claim_Information__c> claimList = [SELECT Id, Send_to_ACAS__c, CPA_Funds_Paid__c, Amount_Paid_By_Primary__c FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        system.assertequals(2,claimList.size());

        //Rework Occurs within ACAS and member resposibility changes; file sent to Prudent for rework segment
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        if(claimList != null) {
            claimList[0].CPA_Indicator__c = 'Opt-in - Partial payment';//old value is: Opt-in - Funds exhausted
            claimList[0].CPA_Funds_Paid__c = 30;
        }
        update claimList;

        if(claimList != null) {
            claimList[0].CPA_Indicator__c = null;
            claimList[0].CPA_Funds_Paid__c = null;
        }
        update claimList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        claimList = [SELECT Id, Send_to_ACAS__c, CPA_Funds_Paid__c, Amount_Paid_By_Primary__c, Claim_Status__c
                    FROM Claim_Information__c
                    WHERE CSA_Account__c =: dailyClaim.CSA_Account__c
        ];
        system.assertequals(2,claimList.size());
        //if Prudent response is received on an old segment, then ACAS needs to reject this transaction and send to Prudent
        //Patient Advocate will work & update the case & claim
        //  The Send to ACAS(Aetna) field will be set to “Queued”
        //Jittbit will generate the claim response file
        system.assertequals(null,claimList[0].CPA_Funds_Paid__c, 'null should be captured in new ACAS copay adjustment bucket field, CPA_Funds_Paid__c because Prudent has not responded yet.');
        system.assertequals(null,claimList[0].Send_to_ACAS__c,'Send to ACAS(Aetna) field was not set so should be null');

        Test.stopTest();

    }

    // Test Scenario: Scenario 8: Rework occurred on the original claim within ACAS(Aetna's system)
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            Prudent did not respond yet.
    //                            ACAS sends Rework claim as Seg 01 indicating a $20 Co-pay/$80 Plan Paid
    //                            Prudent works rework claim
    //                            Full funds available. Full Co-Pay Assistance Funds available from manufacturer so they will pay $20, Plan Pad $80 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void reworkNoResponseSentFullFundsAvailableTest()
    {

    }

    // Test Scenario: Scenario 9a: RWK 3: Mem resp decreases - Copay dollars are already paid by manufacturer and accounted in ACAS processing for Segment 00.
    //                                After this transaction is completed and closed, Rework occurred on the original claim within ACAS creating new segment.
    //                                Seg 01 has change in Member cost share. Assume J9023 has 50$ Max CPO
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            Prudent did not respond yet.
    //                            ACAS sends Rework claim as Seg 01 indicating a $20 Co-pay(already paid by manufacturer)/$80 Plan Paid
    //                            Prudent works rework claim
    //                            Full funds available(same process for No funds & Partial). Full Co-Pay Assistance Funds already paid by manufacturer so they will pay $20, Plan Pad $80 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void rework3MemRespDecreasesFullFundsAvailableTest()
    {

    }

    // Test Scenario: Scenario 9b: RWK 3: Mem resp decreases - Copay dollars are already paid by manufacturer and accounted in ACAS processing for Segment 00.
    //                                After this transaction is completed and closed, Rework occurred on the original claim within ACAS creating new segment.
    //                                Seg 01 has change in Member cost share. Assume J9023 has 50$ Max CPO
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            Prudent did not respond yet.
    //                            ACAS sends Rework claim as Seg 01 indicating a $20 Co-pay(already paid by manufacturer)/$80 Plan Paid
    //                            Prudent works rework claim
    //                            Partial funds available(same process for No funds & Partial). Partial Co-Pay Assistance Funds already paid by manufacturer so they will pay $20, Plan Pad $80 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void rework3MemRespDecreasesPartialFundsAvailableTest()
    {

    }

    // Test Scenario: Scenario 9c: RWK 3: Mem resp decreases - Copay dollars are already paid by manufacturer and accounted in ACAS processing for Segment 00.
    //                                After this transaction is completed and closed, Rework occurred on the original claim within ACAS creating new segment.
    //                                Seg 01 has change in Member cost share. Assume J9023 has 50$ Max CPO
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            Prudent did not respond yet.
    //                            ACAS sends Rework claim as Seg 01 indicating a $20 Co-pay(already paid by manufacturer)/$80 Plan Paid
    //                            Prudent works rework claim
    //                            No funds available(same process for No funds & Partial). No Co-Pay Assistance Funds already paid by manufacturer so they will pay $20, Plan Pad $80 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void rework3MemRespDecreasesNoFundsAvailableTest()
    {

    }

    // Test Scenario: Scenario 10a: RWK 4: Mem Resp Increases -Copay dollars are already paid by manufacturer and accounted in ACAS processing for Segment 00.
    //                                After this transaction is completed and closed, Rework occurred on the original claim within ACAS creating new segment.
    //                                Seg 01 has change in Member cost share. Assume J9023 has 50$ Max CPO
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            Prudent did not respond yet.
    //                            ACAS sends Rework claim as Seg 01 indicating a $40 Co-pay(already paid by manufacturer)/$60 Plan Paid
    //                            Prudent works rework claim
    //                            Full funds available(same process for No funds & Partial). Full Co-Pay Assistance Funds already paid by manufacturer so they will pay $40, Plan Pad $60 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void rework4MemRespIncreaseFullFundsAvailableTest()
    {

    }

    // Test Scenario: Scenario 10b: RWK 4: Mem Resp Increases -Copay dollars are already paid by manufacturer and accounted in ACAS processing for Segment 00.
    //                                After this transaction is completed and closed, Rework occurred on the original claim within ACAS creating new segment.
    //                                Seg 01 has change in Member cost share. Assume J9023 has 50$ Max CPO
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            Prudent did not respond yet.
    //                            ACAS sends Rework claim as Seg 01 indicating a $40 Co-pay(already paid by manufacturer)/$60 Plan Paid
    //                            Prudent works rework claim
    //                            Partial funds available(same process for No funds & Partial). Partial Co-Pay Assistance Funds already paid by manufacturer so they will pay $40, Plan Pad $60 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void rework4MemRespIncreasePartialFundsAvailableTest()
    {

    }

    // Test Scenario: Scenario 10c: RWK 4: Mem Resp Increases -Copay dollars are already paid by manufacturer and accounted in ACAS processing for Segment 00.
    //                                After this transaction is completed and closed, Rework occurred on the original claim within ACAS creating new segment.
    //                                Seg 01 has change in Member cost share. Assume J9023 has 50$ Max CPO
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            Prudent did not respond yet.
    //                            ACAS sends Rework claim as Seg 01 indicating a $40 Co-pay(already paid by manufacturer)/$60 Plan Paid
    //                            Prudent works rework claim
    //                            No funds available(same process for No funds & Partial). No Co-Pay Assistance Funds already paid by manufacturer so they will pay $40, Plan Pad $60 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void rework4MemRespIncreaseNoFundsAvailableTest()
    {

    }

    //**** Question: How is this different from scenario 1?
    // Test Scenario: Scenario 11: RWK 5: Rework and new seg created with no change in Mem cost share for any of the CPO eligible expense lines
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            Prudent works claim
    //                            Full funds available(same process for No funds & Partial). Full Co-Pay Assistance Funds already paid by manufacturer so they will pay $30, Plan Pad $70 and Copay $0
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void rework5MultiSegFullFundsAvailableTest()
    {

    }

    //**** Question: Why did ACAS send a rework for Seg 2 when there was no change?
    // Test Scenario: Scenario 12: RWK 6 - Single claim ID with multiple eligible CPO expense lines on it;  only one of those lines has change in mem copay
    //                              2 CPO applicable Expense lines - same jcode and same NDC
    //                            Original claim 1 $30 Copay/$70 Plan Paid. Exp Line # 1(Drug 1), J-Code J9023
    //                            Original claim 2 $30 Copay/$70 Plan Paid. Exp Line # 2(Drug 2), J-Code J9023
    //                                One Contact_Drug with 2 Claims will be created
    //                            7/22 ACAS team proposes this approach to send all the applicable expense lines if atleast one applicable expense lines has  change in mem copay amounts
    //                            7/23 - When we rework, copay dollars will be reset though it is same as the prior segment. Both the expense lines will be sent to Prudent. Prudent will respond back with the same dollars that were applied during the prior response
    //                            ACAS sends Rework claim as Exp Line 01 indicating a $20 Co-pay(already paid by manufacturer)/$80 Plan Paid
    //                            ACAS sends Rework claim as Exp LIne 02 indicating a $30 Co-pay(already paid by manufacturer)/$70 Plan Paid
    //                            Full funds available. Full Co-Pay Assistance Funds available from manufacturer so they will pay $20, Plan Paid $80 and Copay $0 for Drug 1
    //                            Full funds available. Full Co-Pay Assistance Funds available from manufacturer so they will pay $30, Plan Paid $70 and Copay $0 for Drug 2
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void rework6SingleClaimIdMultiExpLine1LineMinCopayFullFundsAvailableTest()
    {

    }

    // Test Scenario: Scenario 14: RWK 7: Original claim, jcode that applies; we do a rework and jcode that was on original got removed - Very unlikely to occur - ACAS/CBoR workflow
    //                                Final Resolution is to have these claim segments flagged with "V(Void)" MCPO Claim status on ACAS end. ACAS/ORS interface
    //                                Proposal is to send the void claim, so that Prudent can backout the copay dollars that were collected. No response expected from Prudent on this void claim
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            Prudent did not respond yet.
    //                            ACAS sends Rework claim with Claim level indicator = Void(V)
    //                            Prudent backout the copay dollars that were collected but does not respond.
    //                            Full funds available (same process for No funds and Partial).
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void rework7JCodeRemovedFullFundsAvailableTest()
    {

    }

    //Question: What is a preferred benefit level claim?
    // Test Scenario: Scenario 15: RWK 8: preferred benefit level claim gets reworked to a non-preferred benefit level (Same as scenario 14)
    //                                Final Resolution is to have these claim segments flagged with "V(Void)" MCPO Claim status on ACAS end. ACAS/ORS interface
    //                                Proposal is to send the void claim, so that Prudent can backout the copay dollars that were collected. No response expected from Prudent on this void claim
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            ACAS sends Rework claim with Claim level indicator = Void(V)
    //                            Prudent backout the copay dollars that were collected but does not respond.
    //                            Full funds available (same process for No funds and Partial).
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void rework8PreferredBenefitFullFundsAvailableTest()
    {

    }


    // Test Scenario: Scenario 17 - scenario for a claim that changed from 02 to 99 status (Same as scenario 14) - ACAS/ORS workflow
    //                                Final Resolution is to have these claim segments flagged with "C(Closeout)" MCPO Claim status on ACAS end. ACAS/ORS interface
    //                                Proposal is to send the void claim, so that Prudent can backout the copay dollars that were collected. No response expected from Prudent on this void claim
    //                            Original claim $30 Copay/$70 Plan Paid.
    //                            ACAS sends Rework claim with Claim level indicator = Closed out claim(C)
    //                            Prudent backout the copay dollars that were collected but does not respond.
    //                            Full funds available (same process for No funds and Partial).
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void cloaseOutClaimFullFundsAvailableTest()
    {

    }

    // Test Scenario: Scenario 19 - Replacement Claim scenario - ACAS/CBoR workflow
    //                            Prudent did not respond yet.
    //                            ACAS sends $0 void claim with Claim level indicator = Void(V)
    //                            Prudent backout the copay dollars that were collected but does not respond.
    //                            Full funds available (same process for No funds and Partial).  Full Co-Pay Assistance Funds available from manufacturer so they will pay $30, Plan Paid $70 and Copay $0
    //                            ACAS sends new Original Replacement Claim that will be linked to the voided claim.
    //                            Assume BAVENCIO drug is administered and max Co-Pay Assistance funds is 50$
    @IsTest
    public static void  replacementClaimFullFundsAvailableTest()
    {

    }

}