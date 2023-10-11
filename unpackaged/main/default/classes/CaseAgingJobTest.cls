/**
 * Created by ricardy.banks on 1/27/2023.
 */

@IsTest
private class CaseAgingJobTest {

    private static Implementation__c implementationInstance;
    private static Contract contractInstance;
    private static Account accountInstance;
    private static Datetime mbrFollowupTime;
    private static List<Case> followUpCaseList = new List<Case>();

    private static void caseAgingJobTestSetup(Boolean preGoLive, Boolean allowCaseRouting, Boolean allowMBROutreach) {
        system.debug('caseRoutingTestSetup');

        List<Drug__c> testDrugList = new List<Drug__c>();
        List<CSA__c> csaList = new List<CSA__c>();
        Date goLiveDate;

        if(preGoLive) {
            goLiveDate = date.today().addDays(60);
        } else {
            goLiveDate = date.today().addDays(-60);
        }

        system.debug('Setup Accounts');
        accountInstance = new Account(
                Name = 'Model Office Test-Integration',
                Medical_Drug_List__c = 'PRUDENTMED'
                //Go_Live_Date__c = goLiveDate
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
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                //Go_Live_Date__c = goLiveDate,
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '711',
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

        insert csaList;
        System.Debug(' csaList[0].CSA_Number__c = ' + csaList[0].CSA_Number__c);
    }

    @IsTest
    public static void postGoLiveOpenCaseTest()
    {
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
                postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLivReimbursementFollowUp;
        CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String Queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('Queue = '+Queue);
                System.debug('GroupId = '+GroupId);
                switch on Queue {
                    when 'General' { // when Queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when Queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when Queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when Queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when Queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when Queue is Post-Go-Live Enrollment - NEW Queue
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when Queue is Post-Go-Live Reimbursement - NEW Queue
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLivReimbursementFollowUp = GroupId;
                    }
                }
            }
        }

        //Test.startTest();
        Date goLiveDate;
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        caseAgingJobTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);


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
        for(Claim_Information__c claimRecord: claimList) {
            claimRecord.CPA_Indicator__c = 'Opt-in - Paid in full';
            claimRecord.CPA_Funds_Paid__c = 0.0;
        }
        update claimList;
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        List<Case> caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        System.debug('Start Routing Cases');
        DateTime currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        Datetime mbrFollowupTime = null;
        List<Case> followUpCaseList = new List<Case>();
        //Case Status != Verify Fax Number
        //mbrFollowupTime = null
        for(Case caseRecord: caseList) {
            system.assertEquals(generalQueue, caseRecord.OwnerId);
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Verify Fax Number';
            caseRecord.Follow_up_Time__c = null;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        mbrFollowupTime = currentDateTime;
        followUpCaseList = new List<Case>();
        //Case Status == Verify Fax Number
        for(Case caseRecord: caseList) {
            system.assertEquals(generalQueue, caseRecord.OwnerId);
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Verify Fax Number';
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Verify Fax Number
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(preGoLiveFaxValidation, caseRecord.OwnerId);
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(postGoLiveNewReimbursement, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = preGoLiveFaxValidation;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = '1st Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        Test.startTest();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId);
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = '1st Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //accountInstance.Allow_MBR_Outreach__c = True;
        //update accountInstance;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(2, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(preGoLiveEnrollmentFollowUp, caseRecord.OwnerId);
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = preGoLiveEnrollmentFollowUp;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = 'Verify Fax Number';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //Run CaseAgingJob
        CaseAgingJob job = new CaseAgingJob();
        Id jobid= Database.executeBatch(job, 200);

        Test.stopTest();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c, CreatedDate, Open_claim_age__c, Closed_claim_age__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(2, caseList.size());

        //caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();

        // Commented the below code section for US-539 as the underlying code is commented and moved to a formula field on Case Object.
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.Debug('caseRecord.RecordTypeId = '+caseRecord.RecordTypeId);
            //if(caseRecord.RecordTypeId == casesSelector.getCaseRecordTypeId('Enrollement'))
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);
            if(caseRecord.RecordTypeId == casesSelector.getCaseRecordTypeId('Reimbursement')) {
                //system.assertEquals(generalQueue, caseRecord.OwnerId);
                //When case is closed, capture the age of the case
                Long caseAge;
                Long dt1Long = caseRecord.CreatedDate.addDays(0).getTime();
                Long dt2Long = DateTime.now().getTime();
                Long milliseconds = dt2Long - dt1Long;
                Long seconds = milliseconds / 1000;
                Long minutes = seconds / 60;
                Long hours = minutes / 60;
                Long days = hours / 24;
                caseAge = days;
                if(hours <= 25) {
                    caseAge = 0;
                }
                //System.assertEquals(caseAge, caseRecord.Open_claim_age__c);
                System.Debug('caseRecord.Open_claim_age__c = '+caseRecord.Open_claim_age__c);
            }

        }


    }
/*
    @IsTest
    public static void postGoLiveClosedCaseTest()
    {
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
                postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLivReimbursementFollowUp;
        CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
        Set<Id> caseIdset = new Set<Id>();

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String Queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('Queue = '+Queue);
                System.debug('GroupId = '+GroupId);
                switch on Queue {
                    when 'General' { // when Queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when Queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when Queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when Queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when Queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when Queue is Post-Go-Live Enrollment - NEW Queue
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when Queue is Post-Go-Live Reimbursement - NEW Queue
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLivReimbursementFollowUp = GroupId;
                    }
                }
            }
        }

        //Test.startTest();
        Date goLiveDate;
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        caseAgingJobTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);


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
        for(Claim_Information__c claimRecord: claimList) {
            claimRecord.CPA_Indicator__c = 'Opt-in - Paid in full';
        }
        update claimList;
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        List<Case> caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        System.debug('Start Routing Cases');
        DateTime currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        Datetime mbrFollowupTime = null;
        List<Case> followUpCaseList = new List<Case>();
        //Case Status != Verify Fax Number
        //mbrFollowupTime = null
        for(Case caseRecord: caseList) {
            system.assertEquals(generalQueue, caseRecord.OwnerId);
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Verify Fax Number';
            caseRecord.Follow_up_Time__c = null;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;
        System.Debug('followUpCaseList.size() = '+followUpCaseList.size());

        currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        mbrFollowupTime = currentDateTime;
        followUpCaseList = new List<Case>();
        //Case Status == Verify Fax Number
        for(Case caseRecord: caseList) {
            system.assertEquals(generalQueue, caseRecord.OwnerId);
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Verify Fax Number';
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;
        System.Debug('followUpCaseList.size() = '+followUpCaseList.size());

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Verify Fax Number
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Reimbursement')
                system.assertEquals(preGoLiveFaxValidation, caseRecord.OwnerId);
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(postGoLiveNewReimbursement, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = preGoLiveFaxValidation;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = '1st Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;
        System.Debug('followUpCaseList.size() = '+followUpCaseList.size());

        Test.startTest();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Reimbursement')
                system.assertEquals(generalQueue, caseRecord.OwnerId);
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = '1st Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;
        System.Debug('followUpCaseList.size() = '+followUpCaseList.size());

        accountInstance.Allow_MBR_Outreach__c = True;
        update accountInstance;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Reimbursement')
                system.assertEquals(preGoLiveEnrollmentFollowUp, caseRecord.OwnerId);
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = preGoLiveEnrollmentFollowUp;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = 'Outreach Complete'; //Close the case
            caseRecord.HCP_Enrollment_Outreach__c = 'Outreach Complete';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;
        System.Debug('followUpCaseList.size() = '+followUpCaseList.size());

        for(Case caseRecord : followUpCaseList){
            caseIdset.add(caseRecord.Id);
        }

        //Get CaseHistory list of Status field
        Map<Id, CaseHistory> caseHistoryById = casesSelector.selectCaseFieldHistory(caseIdset, 'Status');
        System.Debug('caseHistoryById = '+caseHistoryById);

        //Run CaseClosedAgeJobCaseClosedAgeJob
        CaseClosedAgeJob job = new CaseClosedAgeJob();
        Id jobid= Database.executeBatch(job, 200);

        Test.stopTest();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c, CreatedDate, Open_claim_age__c, Closed_claim_age__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        followUpCaseList = new List<Case>();

        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.Debug('caseRecord.RecordTypeId = '+caseRecord.RecordTypeId);
            //if(caseRecord.RecordTypeId == casesSelector.getCaseRecordTypeId('Enrollement'))
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);
            if(caseRecord.RecordTypeId == casesSelector.getCaseRecordTypeId('Reimbursement')) {
                //system.assertEquals(generalQueue, caseRecord.OwnerId);
                //When case is closed, capture the age of the case
                Long caseAge;
                if(caseHistoryById.get(caseRecord.Id) != null) {
                    Long dt1Long = caseHistoryById.get(caseRecord.Id).CreatedDate.addDays(0).getTime();
                    //Long dt1Long = caseRecord.CreatedDate.addDays(0).getTime();
                    Long dt2Long = DateTime.now().getTime();
                    Long milliseconds = dt2Long - dt1Long;
                    Long seconds = milliseconds / 1000;
                    Long minutes = seconds / 60;
                    Long hours = minutes / 60;
                    Long days = hours / 24;
                    caseAge = days;
                    System.assertEquals(caseAge, caseRecord.Closed_claim_age__c);
                }
                System.Debug('caseRecord.Closed_claim_age__c = '+caseRecord.Closed_claim_age__c);
            }

        }

    }
*/
    @IsTest
    public static void postGoLiveCloseCaseTest()
    {
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
                postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLivReimbursementFollowUp;
        CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String Queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('Queue = '+Queue);
                System.debug('GroupId = '+GroupId);
                switch on Queue {
                    when 'General' { // when Queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when Queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when Queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when Queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when Queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when Queue is Post-Go-Live Enrollment - NEW Queue
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when Queue is Post-Go-Live Reimbursement - NEW Queue
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLivReimbursementFollowUp = GroupId;
                    }
                }
            }
        }

        //Test.startTest();
        Date goLiveDate;
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        caseAgingJobTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);


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
        for(Claim_Information__c claimRecord: claimList) {
            claimRecord.CPA_Indicator__c = 'Opt-in - Paid in full';
            claimRecord.CPA_Funds_Paid__c =  0.0;
        }
        update claimList;
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        List<Case> caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(2, caseList.size());

        System.debug('Start Routing Cases');
        DateTime currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        Datetime mbrFollowupTime = null;
        List<Case> followUpCaseList = new List<Case>();
        //Case Status != Verify Fax Number
        //mbrFollowupTime = null
        for(Case caseRecord: caseList) {
            //system.assertEquals(generalQueue, caseRecord.OwnerId);
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Verify Fax Number';
            caseRecord.Follow_up_Time__c = null;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        mbrFollowupTime = currentDateTime;
        followUpCaseList = new List<Case>();
        //Case Status == Verify Fax Number
        for(Case caseRecord: caseList) {
            //system.assertEquals(generalQueue, caseRecord.OwnerId);
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Verify Fax Number';
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(2, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Verify Fax Number
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(preGoLiveFaxValidation, caseRecord.OwnerId);
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(postGoLiveNewReimbursement, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = preGoLiveFaxValidation;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = '1st Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        Test.startTest();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(2, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement'){
                system.assertEquals(generalQueue, caseRecord.OwnerId);
                
            }
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = 'Outreach Completed';
            caseRecord.HCP_Enrollment_Outreach__c = 'Outreach Complete';
            Id enrollment_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
            Id reimbursement_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reimbursement').getRecordTypeId();
            if(caseRecord.RecordTypeId == enrollment_RecordTypeId){
                caseRecord.Enrollment_Case_Close_Reason__c = 'CPA obtained';
            }else if(caseRecord.RecordTypeId == reimbursement_RecordTypeId){
                caseRecord.Reimbursement_Case_Close_Reason__c = 'No CPA available';
            }
            
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //accountInstance.Allow_MBR_Outreach__c = True;
        //update accountInstance;

        Test.stopTest();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c, CreatedDate, Open_claim_age__c, Closed_claim_age__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(2, caseList.size());

        //caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();

        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.Debug('caseRecord.RecordTypeId = '+caseRecord.RecordTypeId);
            //if(caseRecord.RecordTypeId == casesSelector.getCaseRecordTypeId('Enrollement'))
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);
            if(caseRecord.RecordTypeId == casesSelector.getCaseRecordTypeId('Reimbursement')) {

                //When case is closed, capture the age of the case
                Long caseAge;
                Long dt1Long = caseRecord.CreatedDate.addDays(0).getTime();
                Long dt2Long = DateTime.now().getTime();
                Long milliseconds = dt2Long - dt1Long;
                Long seconds = milliseconds / 1000;
                Long minutes = seconds / 60;
                Long hours = minutes / 60;
                Long days = hours / 24;
                caseAge = days;
                if(hours <= 25) {
                    caseAge = 0;
                }

                //System.assertEquals(caseAge, caseRecord.Closed_claim_age__c);
                System.Debug('caseRecord.Closed_claim_age__c = '+caseRecord.Closed_claim_age__c);
            }

        }

    }

}