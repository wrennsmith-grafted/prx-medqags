/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-30-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class SendLetterBatchTest {

    private static Implementation__c implementationInstance;
    private static Contract contractInstance;
    private static Account accountInstance;

    @TestSetup
    public static void setupData(){

        List<CSA__c> csaList = new List<CSA__c>();
        Date goLiveDate = Date.newInstance(2023,1, 17);

        Account a = new Account();
        a.Name='Test Account';
        a.Go_Live_Date__c = Date.newInstance(2023,1, 17);
        insert a;

        //Adding the below section of code to create a new CSA record to resolve a test class issue
        system.debug('Setup Contracts');
        contractInstance = new Contract(
                Name = 'Model Office Test-Integration Contract',
                Go_Live_Date__c = goLiveDate,
                AccountId = a.Id
        );
        insert contractInstance;

        system.debug('Setup Implementation__c');
        implementationInstance =  new Implementation__c(
                Account__c = a.Id,
                Contract__c = contractInstance.Id
        );
        insert implementationInstance;
        
        CSA__c csaInstance = new CSA__c(
                Account__c = a.Id,
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

        Drug__c d = new Drug__c(); 
        d.Drug_Brand_Name__c = 'Test';
        d.Name = 'Test'; 
        d.Coding_Level__c = 'HCPCS'; 
        d.J_Code__c = '123456';
        d.Copay_Assistance_Available__c = 'Yes';
        insert d; 

        List<Contact> lstContactsTobeCreated = new List<Contact>(); 

        Contact c = new Contact();
        c.FirstName='TestHello';
        c.LastName = 'ContactHello';
        c.Birthdate= Date.newInstance(1990,1, 11);
        c.Gender__c = 'Male';
        c.MailingStreet = 'address line 1\n addressline2';
        c.MailingCity = 'Raleigh';
        c.MailingState = 'NC';
        c.MailingPostalCode = '27616';
        c.AccountId = a.Id;
        c.CSA__c = csaList[0].Id;
        lstContactsTobeCreated.add(c);

        Contact c1 = new Contact();
        c1.FirstName='Test';
        c1.LastName = 'TestHello';
        c1.Birthdate= Date.newInstance(1986,10, 18);
        c1.Gender__c = 'Female';
        c1.MailingStreet = 'address line 1\n addressline2';
        c1.MailingCity = 'Charleston';
        c1.MailingState = 'SC';
        c1.MailingPostalCode = '29420';
        c1.AccountId = a.Id;
        c1.CSA__c = csaList[0].Id;
        lstContactsTobeCreated.add(c1);

        Contact c2 = new Contact();
        c2.FirstName='TestThree';
        c2.LastName = 'Three';
        c2.Birthdate= Date.newInstance(1996,10, 18);
        c2.Gender__c = 'Male';
        c2.MailingStreet = 'address line 1\n addressline2';
        c2.MailingCity = 'Charleston';
        c2.MailingState = 'SC';
        c2.MailingPostalCode = '29420';
        c2.AccountId = a.Id;
        c2.CSA__c = csaList[0].Id;
        lstContactsTobeCreated.add(c2);

        Contact c3 = new Contact();
        c3.FirstName='TestFour';
        c3.LastName = 'Three';
        c3.Birthdate= Date.newInstance(1996,10, 18);
        c3.Gender__c = 'Male';
        c3.MailingStreet = 'address line 1\n addressline2';
        c3.MailingCity = 'Charleston';
        c3.MailingState = 'SC';
        c3.MailingPostalCode = '29420';
        c3.AccountId = a.Id;
        c3.CSA__c = csaList[0].Id;
        lstContactsTobeCreated.add(c3);        

        insert lstContactsTobeCreated; 

        List<Case> lstCasesToAdd = new List<Case>(); 

        Case case1 = new Case(); 
        case1.RecordTypeId = '0125e000000mHQ7AAM'; 
        case1.ContactId = c.Id; 
        case1.Outreach_Type__c = 'Both'; 
        case1.Outreach_Comments__c = 'TEST'; 
        case1.Status = 'Transfer to Health Plan'; 
        case1.Latest_PRx_Outreach_Attempt__c = Date.today().addDays(-1); 
        lstCasesToAdd.add(case1); 

        Case case2 = new Case(); 
        case2.RecordTypeId = '0125e000000mHQ7AAM'; 
        case2.ContactId = c1.Id; 
        case2.Outreach_Type__c = 'Both'; 
        case2.Outreach_Comments__c = 'TEST'; 
        case2.Status = 'Transfer to Health Plan'; 
        case2.Latest_PRx_Outreach_Attempt__c = Date.today().addDays(-7); 
        lstCasesToAdd.add(case2); 

        Case case3 = new Case(); 
        case3.RecordTypeId = '0125e000000mHQ7AAM'; 
        case3.ContactId = c2.Id; 
        case3.Outreach_Type__c = 'Both'; 
        case3.Outreach_Comments__c = 'TEST'; 
        case3.Status = 'Transfer to Health Plan'; 
        case3.Latest_PRx_Outreach_Attempt__c = Date.today(); 
        lstCasesToAdd.add(case3); 

        Case case4 = new Case(); 
        case4.RecordTypeId = '0125e000000mHQ7AAM'; 
        case4.ContactId = c3.Id; 
        case4.Outreach_Type__c = 'Both'; 
        case4.Outreach_Comments__c = 'TEST'; 
        case4.Status = 'Transfer to Health Plan'; 
        case4.Latest_PRx_Outreach_Attempt__c = Date.today().addDays(-1); 
        lstCasesToAdd.add(case4); 

        insert(lstCasesToAdd); 

        Contact_Drug__c cd = new Contact_Drug__c(); 
        cd.Drug_Name__c = d.Id; 
        cd.Copay_Enrollment_Status__c = 'Pending'; 
        cd.Related_Case__c = case2.Id; 
        insert cd; 

    }

    @isTest
    public static void testFinalNoticeBatch() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new LetterServiceMock('testSendFinalNoticeSuccess'));
        SendLetterBatch batch = new SendLetterBatch('Send Final Notice', null); 
        try {
            Database.executeBatch(batch);
        } catch (Exception ex) {
            System.assertEquals(ex.getMessage(), 'You have uncommitted work pending. Please commit or rollback before calling out');
        }
        Test.stopTest(); 
    }

    @isTest
    public static void testFinalNoticeWithdate() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new LetterServiceMock('testSendFinalNoticeSuccess'));
        SendLetterBatch batch = new SendLetterBatch('Send Final Notice', Date.today().format()); 
        Database.executeBatch(batch);
        Test.stopTest(); 
    }

    @isTest 
    public static void testFinalNoticeNoCasesFound() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new LetterServiceMock('testSendFinalNoticeSuccess'));
        SendLetterBatch batch = new SendLetterBatch('Send Final Notice', date.newInstance(2022, 2, 10).format()); 
        Database.executeBatch(batch);
        Test.stopTest(); 
    }

    @isTest
    public static void testWelcomeLetterBatch() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new LetterServiceMock('testWelcomeLetterSuccess'));
        SendLetterBatch batch = new SendLetterBatch('Send Welcome', '');
        Database.executeBatch(batch); 
        Test.stopTest(); 
    }
}