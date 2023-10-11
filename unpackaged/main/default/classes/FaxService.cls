/**
 * @description       :
 * @author            : Garrett.Heathcote@PrudentRx.com
 * @group             :
 * @last modified on  : 05-10-2022
 * @last modified by  : Garrett Heathcote
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   05-10-2022   Garrett Heathcote                Initial Version
 *
 **/
public without sharing class FaxService {

    // Refactor into a custom metadata 
    private static String SandboxFaxNumber = Constants.SandboxFaxNumber;
    private static String ProdFaxNumber = Constants.ProdFaxNumber;
    private static String SendFromFaxNumber = Constants.SendFromFaxNumber;/// Look into a custom metadata ?
    private static String BarcodeLeftPixles = Constants.BarcodeLeftPixles; /// Look into a custom metadata ?
    private static String BarcodeTopPixles = Constants.BarcodeTopPixles; /// Look into a custom metadata ?
    private static String BarcodeSize = Constants.BarcodeSize; /// Look into a custom metadata ?
    private static String PRXPhoneNumber = Constants.PRXPhoneNumber; /// Look into a custom metadata ?

    /********************* FAX Template Error Handling ****************/
    //Build Error Message to report to user or log on Case
    public static String checkForNullData(Case c)
    {
        String errorMessage = '';
        errorMessage += String.isBlank(c.CaseNumber) ? 'Case Number, ' : '';
        errorMessage += String.isBlank(c.Contact.Name) ? 'Contact Name, ' : '';
        //errorMessage += String.isBlank(c.Contact.Patient_Phone_Number__c) ? 'Contacts Patient Phone, ' : '';
        errorMessage += c.Contact.Patient_Birth_Date__c == null ? 'Patient Birthdate, ' : '';
        errorMessage += String.isBlank(c.Contact_Drug__r.Drug_Brand_Name__c) ? 'Contact Drugs Drug Brand Name, ' : '';
        //errorMessage += String.isBlank(c.Contact.Patient_CUMB_ID__c) ? 'Contacts Patient CUMB ID, ' : '';

        errorMessage += String.isBlank(c.Account.Health_Plan_Name__c) ? 'Accounts Health Plan Name, ' : '';
        Boolean emptySPAddress = String.isBlank(c.Service_Provider_Address_Line_1__c) &&
                String.isBlank(c.Service_Provider_City__c) &&
                String.isBlank(c.Service_Provider_State__c) &&
                String.isBlank(c.Service_Provider_Zip__c) ? true : false;

        Boolean emptyBPAddress = String.isBlank(c.Claim_Information__r.Billing_Provider_Address_Line_1__c) &&
                String.isBlank(c.Claim_Information__r.Billing_Provider_City__c) &&
                String.isBlank(c.Claim_Information__r.Billing_Provider_State_Code__c) &&
                String.isBlank(c.Claim_Information__r.Billing_Provider_Zip_Code__c) ? true : false;

        //Check Case type for correct Error Messaging
        if(c != null)
        {
            if(c.Contact_Drug__r != null && c.Contact_Drug__r.CPA_Available__c == 'Yes')
            {
                if(c.RecordType.Name == 'Enrollment')
                {
                    errorMessage += String.isBlank(c.Service_Provider_s_Name__c) ? 'Service Provider Name, ' : '';
                    errorMessage += emptySPAddress ? 'Service Provider Address, ' : '';
                    errorMessage += String.isBlank(c.Service_Provider_Fax__c) && String.isBlank(c.Alternate_Fax__c) ? 'Service Provider Fax or Alternate Fax, ' : '';
                    errorMessage += c.Account.Go_Live_Date__c == null ? 'Accounts Go Live Date, ' : '';
                }
                else if(c.RecordType.Name == 'Reimbursement')
                {
                    errorMessage += String.isBlank(c.Billing_Provider_Full_Name__c) ? 'Billing Provider Name, ' : '';
                    errorMessage += emptyBPAddress ? 'Billing Provider Address, ' : '';
                    errorMessage += String.isBlank(c.Billing_Provider_Fax__c) && String.isBlank(c.Billing_Provider_Alternate_Fax__c) ? 'Billing Provider Fax or Alternate Fax, ' : '';
                    errorMessage += c.Date_Of_Service_From__c == null ? 'Date of Service From, ' : '';
                    errorMessage += String.isBlank(c.Contact_Drug__r.HCPCS_Code__c) ? 'Contact Drug HCPCS Code, ' : '';
                }
                else {
                    errorMessage = 'Case Type is Not Enrollment or Reimbursement';
                }
            }
            else
            {
                if(c.RecordType.Name == 'Enrollment' || c.RecordType.Name == 'Reimbursement')
                {
                    errorMessage += String.isBlank(c.Service_Provider_s_Name__c) ? 'Service Provider Name, ' : '';
                    errorMessage += emptySPAddress ? 'Service Provider Address, ' : '';
                    errorMessage += c.Account.Go_Live_Date__c == null ? 'Accounts Go Live Date, ' : '';
                    if (c.RecordType.Name == 'Enrollment')
                    {
                        errorMessage += String.isBlank(c.Service_Provider_Fax__c) && String.isBlank(c.Alternate_Fax__c) ? 'Service Provider Fax or Alternate Fax, ' : '';
                    }
                    else
                    {
                        errorMessage += String.isBlank(c.Billing_Provider_Fax__c) && String.isBlank(c.Billing_Provider_Alternate_Fax__c) ? 'Billing Provider Fax or Alternate Fax, ' : '';
                    }
                }
                else {
                    errorMessage = 'Case Type is Not Enrollment or Reimbursement';
                }
            }
        }
        if(String.isEmpty(errorMessage.trim()))
        {
            return null;
        }

        //Clean message before returning
        return errorMessage.substringBeforeLast(', ');
    }


    /********************* FAX Process ****************/

    //Overload method to handle single case 50023000003syO6AAI
    public static String processFaxOnCase(String cId)
    {
        Case c = new Case();
        c.Id = cId;
        //Only applies to button click and not auto
        String recentlySent = checkForRecentlySent(c);

        return recentlySent == null ? processFaxOnCase(new List<Case>{c}) : recentlySent;
    }

    //Build Error Message to report to user or log on Case
    public static String checkForRecentlySent(Case c)
    {
        AggregateResult[] mostRecentFax = [SELECT efaxapp__Case__c, MAX(CreatedDate) maxDate FROM efaxapp__Sent_Fax__c
        WHERE efaxapp__Case__c =:c.Id GROUP BY efaxapp__Case__c ];
        DateTime mostRecentDate;
        String ErrorText;
        if(mostRecentFax != null && mostRecentFax.size() > 0)
        {
            mostRecentDate = (DateTime)mostRecentFax[0].get('maxDate');

            if(System.now() <= mostRecentDate.addSeconds(30))
            {
                ErrorText = 'Warning: Sorry you just sent out a fax. Please click the button once and wait for a response.';
            }
        }
        return ErrorText;
    }

    //Handle multiple cases that need PDF merged, created, faxed
    // @InvocableMethod(label='Process Faxes on Cases' description='Take a list of cases and send out appropriate faxes')
    public static String processFaxOnCase(List<Case> lstCases)
    {
        //Grab all the data you may need from Case....
        Set<Id> setCaseIds = (new Map<Id,SObject>(lstCases)).keySet();
        //TODO: validate CRUD
        List<Case> lstCasesToCheck =
        [SELECT Id, RecordType.Name, CaseNumber,
                Account.Health_Plan_Name__c, Account.Go_Live_Date__c,
                ContactId, Contact.Name, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c, Contact.Patient_Birth_Date__c,
                Contact_Drug__r.CPA_Available__c, Contact_Drug__r.Drug_Brand_Name__c, Contact_Drug__r.HCPCS_Code__c,
                Service_Provider_s_Name__c, Service_Provider_Address__c, Service_Provider_Fax__c, Alternate_Fax__c, Service_Provider_Practice__c,
                Service_Provider_Address_Line_1__c,Service_Provider_City__c,Service_Provider_State__c,Service_Provider_Zip__c, Service_Provider_Point_of_Contact__c,
                Billing_Provider_Full_Name__c,  Billing_Provider_Fax__c, Billing_Provider_Alternate_Fax__c, Billing_Provider_Point_of_Contact__c,
                Claim_Information__r.Billing_Provider_Address__c, Claim_Information__r.Billing_Provider_Address_Line_1__c,
                Claim_Information__r.Billing_Provider_City__c, Claim_Information__r.Billing_Provider_State_Code__c,Claim_Information__r.Billing_Provider_Zip_Code__c,
                Date_Of_Service_From__c, EOP_Date__c, Status
        FROM Case WHERE id IN:setCaseIds];
        System.debug('GH STEP 1.');
        //Map to hold Case Id and Error Message to log to Case
        Map<String,String> mapCasesToError = new Map<String,String>();
        //List of Cases that need to have a fax sent
        List<Case> lstCasesToSend = new List<Case>();
        List<Organization> org = [SELECT IsSandbox FROM Organization LIMIT 1];
        if(org[0].IsSandbox)
        {
            SendFromFaxNumber = SandboxFaxNumber;
        }

        //Loop through cases to check for errors/null data before building PDFs
        for(Case c : lstCasesToCheck)
        {
            //If we have an error then write to log or send notification
            String errorNotification = checkForNullData(c);
            if(errorNotification != null)
            {
                //TODO:singular case reply to agent
                if(lstCasesToCheck.size() == 1)
                {
                    return 'You are missing the following required fields to be able to send a fax: ' + errorNotification; // or send custom notification?
                }
                //TODO:mass update then add a log on the case
                else
                {
                    //Used to log the error fields to the case Multi Cases
                    // mapCasesToError.put(c.Id, errorNotification);
                }
                //Set<String> users = new Set<String>{'00523000002AYluAAG'};
                //notifyUsers(users,c.Id);
                System.debug('GH STEP ERROR ' + errorNotification);
            }
            else
            {
                lstCasesToSend.add(c);
            }
        }

        System.debug('GH STEP 2.' + lstCasesToSend.size());
        if(mapCasesToError.size() > 0)
        {
            //When processing multiple cases need to update
            //     logCaseFaxErrors(mapCasesToError);
        }

        if(lstCasesToSend.size() > 0)
        {
            //Builds PDF from Template and create sent fax record
            sendFaxes(lstCasesToSend);
        }

        // Or change to a custom success notificaiton...
        if(lstCasesToCheck.size() == 1)
        {
            Case c = lstCasesToCheck[0];

            String faxNumber = chooseFaxNumber(c);

            return 'Success: Fax is on its way to ' + formatPhone(faxNumber); // or send custom notification?
        }
        else if(lstCasesToCheck == null || lstCasesToCheck.size() == 0)
        {
            return 'Error: User does not have valid permissions or case does not exist'; // or send custom notification?
        }
        else
        {
            //Multiple Cases call
            return 'Error: Multiple Cases Returned';
        }

    }

    //Overloaded method for handling the automated batch
    public static String processFaxOnCase(List<Case> lstCases, String faxType)
    {
        String errorMessage = ''; 
        //Grab all the data you may need from Case....
        Set<Id> setCaseIds = (new Map<Id,SObject>(lstCases)).keySet();
        //TODO: validate CRUD
        List<Case> lstCasesToCheck =
        [SELECT Id, RecordType.Name, CaseNumber,
                Account.Health_Plan_Name__c, Account.Go_Live_Date__c,
                ContactId, Contact.Name, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c, Contact.Patient_Birth_Date__c,
                Contact_Drug__r.CPA_Available__c, Contact_Drug__r.Drug_Brand_Name__c, Contact_Drug__r.HCPCS_Code__c,
                Service_Provider_s_Name__c, Service_Provider_Address__c, Service_Provider_Fax__c, Alternate_Fax__c, Service_Provider_Practice__c,
                Service_Provider_Address_Line_1__c,Service_Provider_City__c,Service_Provider_State__c,Service_Provider_Zip__c, Service_Provider_Point_of_Contact__c,
                Billing_Provider_Full_Name__c,  Billing_Provider_Fax__c, Billing_Provider_Alternate_Fax__c, Billing_Provider_Point_of_Contact__c,
                Claim_Information__r.Billing_Provider_Address__c, Claim_Information__r.Billing_Provider_Address_Line_1__c,
                Claim_Information__r.Billing_Provider_City__c, Claim_Information__r.Billing_Provider_State_Code__c,Claim_Information__r.Billing_Provider_Zip_Code__c,
                Date_Of_Service_From__c, EOP_Date__c, Status
        FROM Case WHERE id IN:setCaseIds];
        System.debug('GH STEP 1.');
        //Map to hold Case Id and Error Message to log to Case
        Map<String,String> mapCasesToError = new Map<String,String>();
        //List of Cases that need to have a fax sent
        List<Case> lstCasesToSend = new List<Case>();
        List<Organization> org = [SELECT IsSandbox FROM Organization LIMIT 1];
        if(org[0].IsSandbox)
        {
            SendFromFaxNumber = SandboxFaxNumber;
        }

        //Loop through cases to check for errors/null data before building PDFs
        for(Case c : lstCasesToCheck)
        {
            //If we have an error then write to log or send notification
            String errorNotification = checkForNullData(c);
            if(errorNotification != null)
            {
                //TODO:singular case reply to agent
                if(lstCasesToCheck.size() == 1)
                {
                    errorMessage = 'You are missing the following required fields to be able to send a fax: ' + errorNotification; // or send custom notification?
                }
                //TODO:mass update then add a log on the case
                else
                {
                    //Used to log the error fields to the case Multi Cases
                    // mapCasesToError.put(c.Id, errorNotification);
                }
                //Set<String> users = new Set<String>{'00523000002AYluAAG'};
                //notifyUsers(users,c.Id);
                System.debug('GH STEP ERROR ' + errorNotification);
            }
            else
            {
                lstCasesToSend.add(c);
            }
        }

        System.debug('GH STEP 2.' + lstCasesToSend.size());
        if(mapCasesToError.size() > 0)
        {
            //When processing multiple cases need to update
            //     logCaseFaxErrors(mapCasesToError);
        }

        if(lstCasesToSend.size() > 0)
        {
            //Builds PDF from Template and create sent fax record
            sendFaxes(lstCasesToSend, faxType);
        }
        return errorMessage;
    }

    public static String chooseFaxNumber(Case c)
    {
        return c.RecordType.Name == 'Reimbursement' ?
                !String.isBlank(c.Billing_Provider_Alternate_Fax__c) ? c.Billing_Provider_Alternate_Fax__c : c.Billing_Provider_Fax__c
                : !String.isBlank(c.Alternate_Fax__c) ? c.Alternate_Fax__c : c.Service_Provider_Fax__c;
    }

    public static String getContactNumber(Case c)
    {
        //Prioritize Patient Alternative on Outbound Provider Faxes over Patient Phone
        String contactNumber;
        String patientPhoneNumber = c.Contact.Patient_Phone_Number__c;
        String alternativePhone = c.Contact.Alternative_Phone__c;

        System.debug('getServiceProviderFax: c.Contact.Patient_Phone_Number__c = ' + patientPhoneNumber);
        System.debug('getServiceProviderFax: c.Contact.Alternative_Phone__c = ' + alternativePhone);
        //If the Patient Phone on the Contact Page is blank and the Alternative Phone is populated, map the Alternative Phone onto the outbound faxes.
        //If the Alternative Phone on the Contact Page is blank and the Patient Phone is populated, map the Patient Phone onto the outbound faxes.
        //If both the Patient Phone on the Contact Page and the Alternative Phone are populated, map the Alternative Phone onto the outbound faxes.
        //If both the Patient Phone on the Contact Page and the Alternative Phone are NOT populated, map 'UNKNOWN'

        return !String.isBlank(alternativePhone) ? alternativePhone : !String.isBlank(patientPhoneNumber) ? patientPhoneNumber : 'UNKNOWN';
    }

    public static void sendFaxes(List<Case> lstCases)
    {
        //TODO: validate CRUD
        //Grab the Content from each template
        /*List<String> lstFaxTemplateNames = new List<String>{'Enrollment Fax Template','Final Notice Fax Template','No CPA Fax Template','Reimbursement Fax Template'};
        List<ContentVersion> lstTemplateContent = [SELECT VersionData FROM ContentVersion WHERE Title IN : lstFaxTemplateNames AND IsLatest = true];*/
        ContentVersion enrollmentTemplate = [SELECT VersionData, Title FROM ContentVersion WHERE Title = 'Enrollment Fax Template' AND IsLatest = true];
        ContentVersion reimbursementTemplate = [SELECT VersionData, Title FROM ContentVersion WHERE Title = 'Reimbursement Fax Template' AND IsLatest = true];
        ContentVersion noCPATemplate = [SELECT VersionData, Title FROM ContentVersion WHERE Title = 'No CPA Fax Template' AND IsLatest = true];
        ContentVersion finalNoticeTemplate = [SELECT VersionData, Title FROM ContentVersion WHERE Title = 'Final Notice Fax Template' AND IsLatest = true];
        //Should I just store the Dev versus Prod Ids ??? in custom metadata?

        // TODO: Change to loop and one SOQL call then assign

        //Prepare list of merged files
        List<ContentVersion> lstMergedPDFs = new List<ContentVersion>();

        //Add one PDF for each case
        for(Case c : lstCases)
        {
            // Case is open AND not Transfer to Health Plan AND EOP Date is 75 days ago
            if (c.Status != 'Transfer to Health Plan' && c.Status != 'Outreach Completed' && c.EOP_Date__c == Date.today().addDays(-75)) {
                lstMergedPDFs.add(mergePDF(c, finalNoticeTemplate)); 
            }
            else if(c.Contact_Drug__r.CPA_Available__c == 'Yes')
            {
                if(c.RecordType.Name == 'Enrollment')
                {
                    lstMergedPDFs.add(mergePDF(c, enrollmentTemplate));
                }
                else if(c.RecordType.Name == 'Reimbursement')
                {
                    lstMergedPDFs.add(mergePDF(c, reimbursementTemplate));
                }
            }
            else
            {
                if(c.RecordType.Name == 'Enrollment' || c.RecordType.Name == 'Reimbursement')
                {
                    lstMergedPDFs.add(mergePDF(c, noCPATemplate));
                }
            }
        }

        //TODO: validate CRUD
        Database.SaveResult[] srList = Database.insert(lstMergedPDFs, false);
        Set<Id> pdfsToSend = new Set<Id>();
        //TODO: Multiple cases
        Set<Id> pdfsToLogError = new Set<Id>();
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                pdfsToSend.add(sr.getId());
            }
            else {
                // Operation failed, so get all errors ... Send Notification? Store in Error Log with Notification?
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Case fields that affected this error: ' + err.getFields());
                }
            }
        }

        if(pdfsToSend.size() > 0)
        {
            createSentFaxRecords(pdfsToSend, lstCases);

        }
        //send lst to sent fax method...
    }

    //overloaded method to handle automated batch 
    public static void sendFaxes(List<Case> lstCases, String faxType)
    {
        //TODO: validate CRUD
        //Grab the Content from each template
        /*List<String> lstFaxTemplateNames = new List<String>{'Enrollment Fax Template','Final Notice Fax Template','No CPA Fax Template','Reimbursement Fax Template'};
        List<ContentVersion> lstTemplateContent = [SELECT VersionData FROM ContentVersion WHERE Title IN : lstFaxTemplateNames AND IsLatest = true];*/
        ContentVersion enrollmentTemplate = [SELECT VersionData, Title FROM ContentVersion WHERE Title = 'Enrollment Fax Template' AND IsLatest = true];
        ContentVersion reimbursementTemplate = [SELECT VersionData, Title FROM ContentVersion WHERE Title = 'Reimbursement Fax Template' AND IsLatest = true];
        ContentVersion noCPATemplate = [SELECT VersionData, Title FROM ContentVersion WHERE Title = 'No CPA Fax Template' AND IsLatest = true];
        ContentVersion finalNoticeTemplate = [SELECT VersionData, Title FROM ContentVersion WHERE Title = 'Final Notice Fax Template' AND IsLatest = true];
        //Should I just store the Dev versus Prod Ids ??? in custom metadata?

        // TODO: Change to loop and one SOQL call then assign

        //Prepare list of merged files
        List<ContentVersion> lstMergedPDFs = new List<ContentVersion>();

        //Add one PDF for each case
        for(Case c : lstCases)
        {
            if(faxType != 'No CPA')
            {
                if(faxType == 'Enrollment')
                {
                    lstMergedPDFs.add(mergePDF(c, enrollmentTemplate));
                }
                else if(faxType == 'Reimbursement')
                {
                    lstMergedPDFs.add(mergePDF(c, reimbursementTemplate));
                } 
                else if(faxType == 'Final Notice') {
                    lstMergedPDFs.add(mergePDF(c, finalNoticeTemplate));
                }
            }
            else
            {
                if(c.RecordType.Name == 'Enrollment' || c.RecordType.Name == 'Reimbursement')
                {
                    lstMergedPDFs.add(mergePDF(c, noCPATemplate));
                }
            }
        }

        //TODO: validate CRUD
        Database.SaveResult[] srList = Database.insert(lstMergedPDFs, false);
        Set<Id> pdfsToSend = new Set<Id>();
        //TODO: Multiple cases
        Set<Id> pdfsToLogError = new Set<Id>();
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                pdfsToSend.add(sr.getId());
            }
            else {
                // Operation failed, so get all errors ... Send Notification? Store in Error Log with Notification?
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Case fields that affected this error: ' + err.getFields());
                }
            }
        }

        if(pdfsToSend.size() > 0)
        {
            createSentFaxRecords(pdfsToSend, lstCases);

        }
        //send lst to sent fax method...
    }

    //Create Sent Fax
    public static void createSentFaxRecords(Set<Id> setPDFs, List<Case> lstCases)
    {
        List<ContentVersion> lstPDFsToSend = [SELECT Id, FirstPublishLocationId FROM ContentVersion WHERE Id IN :setPDFs];
        List<efaxapp__Sent_Fax__c> lstSentFaxToInsert = new List<efaxapp__Sent_Fax__c>();
        for(Case c : lstCases)
        {
            for(ContentVersion cv : lstPDFsToSend)
            {
                if(c.Id == cv.FirstPublishLocationId)
                {
                    lstSentFaxToInsert.add(createSentFax(c,cv.Id));
                }
            }
        }

        if(lstSentFaxToInsert.size() > 0)
        {
            //TODO: Check CRUD
            insert lstSentFaxToInsert;
        }
    }

    public static efaxapp__Sent_Fax__c createSentFax(Case c, String fileId)
    {
        //If we have an alternate fax on either an enrollment or reimbursement then we want to use the alternate.
        String faxNumber = chooseFaxNumber(c);

        efaxapp__Sent_Fax__c sf  = new efaxapp__Sent_Fax__c();
        sf.efaxapp__Fax_Number__c = faxNumber;
        sf.efaxapp__Sent_With_Outbound_Message__c = true; //<<-- False
        sf.efaxapp__Cover_Sheet__c = 'None';
        sf.efaxapp__Subject__c = 'Fax sent to ' + faxNumber + ' for case#' + c.CaseNumber + ' on ' + Date.today();
        //sf.efaxapp__Comments__c = '';
        sf.efaxapp__Attachment_ID__c = fileId;
        sf.efaxapp__Org_Fax_Number__c = SendFromFaxNumber;
        sf.efaxapp__Barcode_Position_Left__c = BarcodeLeftPixles;
        sf.efaxapp__Barcode_Position_Top__c = BarcodeTopPixles;
        sf.efaxapp__Barcode_Size_Width__c = BarcodeSize;
        sf.efaxapp__Send_Date__c = Date.today();
        sf.efaxapp__Case__c = c.Id;
        sf.efaxapp__Contact__c = c.ContactId;
        //eXTRA FIELDS
        // efaxapp__Parent_ID__c = 100;
        //   efaxapp__Cover_Sheet_Template__c = ''
        //sf.efaxapp__Status__c = '';//
        //efaxapp__Attachment_ID2__c
        //efaxapp__Attachment_ID3__c
        return sf;
    }

    static public String formatPhone(String s)
    {
        if( s == 'UNKNOWN') {
            return s;
        }
        s = s.replace('(','').replace(')','').replace('-','');
        if(!String.isBlank(s))
        {
            s = '(' + s.substring(0, 3) + ') ' + s.substring(3, 6) + '-' + s.substring(6);
        }
        else {
            s = '';
        }
        return s;
    }

    public static ContentVersion mergePDF(Case c, ContentVersion template)
    {
        String fileContent = template.VersionData.toString();
        String FaxNumber = chooseFaxNumber(c);

        //aDD LOGIC IF THE TEMPLATE IS BAD
        if(fileContent != null)
        {
            //General for all
            fileContent = fileContent
                    .replace('{{DATEFAXSENT}}', System.today().format())
                    .replace('{{HEALTHPLANNAME}}', c.Account.Health_Plan_Name__c)
                    .replace('{{PATIENTNAME}}', c.Contact.Name)
                    .replace('{{MEDICATIONNAME}}', c.Contact_Drug__r.Drug_Brand_Name__c)
                    .replace('{{PATIENTDATEOFBIRTH}}', c.Contact.Patient_Birth_Date__c.format());
            //.replace('{{GROUPID}}', c.Contact.Patient_CUMB_ID__c)

            // Final Notice 
            if (template.Title == 'Final Notice Fax Template') {
                Date todayPlus14 = System.today().addDays(14);
                fileContent = fileContent
                        .replace('{{PRUDENTRXFAXNUMBER}}', formatPhone('(813)200-3905'))
                        .replace('{{DATEFAXSENT_PLUS14CALENDARDAYS}}', todayPlus14.format())
                        .replace('{{EFFECTIVEDATE}}', c.Account.Go_Live_Date__c.format())
                        .replace('{{PHONENUMBER}}', formatPhone(getContactNumber(c)))
                        .replace('{{HCPCSCODE}}', c.Contact_Drug__r.HCPCS_Code__c)
                        .replace('{{BILLINGPROVIDERNAME}}', c.Billing_Provider_Full_Name__c)
                        .replace('{{BILLINGPROVIDERADDRESS}}', c.Claim_Information__r.Billing_Provider_Address__c)
                        .replace('{{BILLINGPROVIDERFAX}}', formatPhone(FaxNumber))
                        .replace('{{CASEID}}', c.CaseNumber)
                        .replace('{{DATEOFSERVICEFROM}}', c.Date_Of_Service_From__c.format());
            }
            else if(c.Contact_Drug__r != null && c.Contact_Drug__r.CPA_Available__c == 'Yes')
            {
                Date todayPlus3 = System.today().addDays(3);
                fileContent = fileContent
                        .replace('{{CASEID}}', c.CaseNumber)
                        .replace('{{PHONENUMBER}}', formatPhone(getContactNumber(c)))
                        .replace('{{DATEFAXSENT_PLUS3DAYS}}', todayPlus3.format());
                //Reimbursment
                if(c.RecordType.Name == 'Reimbursement')
                {
                    Date DOSFPlus60 = c.Date_Of_Service_From__c.addDays(60);
                    if (!String.isBlank(c.Billing_Provider_Point_of_Contact__c)) {
                        fileContent = fileContent
                            .replace('{{POINTOFCONTACT}}', 'ATTN TO: ' + c.Billing_Provider_Point_of_Contact__c);
                    } else {
                        fileContent = fileContent
                            .replace('{{POINTOFCONTACT}}', '');
                    }
                    fileContent = fileContent
                            .replace('{{BILLINGPROVIDERNAME}}', c.Billing_Provider_Full_Name__c)
                            .replace('{{BILLINGPROVIDERADDRESS}}', c.Claim_Information__r.Billing_Provider_Address__c)
                            .replace('{{BILLINGPROVIDERFAX}}', formatPhone(FaxNumber))
                            .replace('{{DATEOFSERVICEFROM}}', c.Date_Of_Service_From__c.format())
                            .replace('{{HCPCSCODE}}', c.Contact_Drug__r.HCPCS_Code__c)
                            .replace('{{DATEOFSERVICE_PLUS60CALENDARDAYS}}', DOSFPlus60.format());
                }
                //Enrollment
                else {
                    if (!String.isBlank(c.Service_Provider_Point_of_Contact__c)) {
                        fileContent = fileContent
                            .replace('{{POINTOFCONTACT}}', 'ATTN TO: ' + c.Service_Provider_Point_of_Contact__c);
                    } else {
                        fileContent = fileContent
                            .replace('{{POINTOFCONTACT}}', '');
                    }
                    fileContent = fileContent
                            .replace('{{SERVICEPROVIDERNAME}}', c.Service_Provider_s_Name__c)
                            .replace('{{SERVICEPROVIDERADDRESS}}', c.Service_Provider_Address__c)
                            .replace('{{SERVICEPROVIDERFAX}}', formatPhone(FaxNumber))
                            .replace('{{EFFECTIVEDATE}}', c.Account.Go_Live_Date__c.format())
                            .replace('{{PRXPROVIDERPHONE}}', formatPhone(PRXPhoneNumber));
                }
            }
            else
            {
                //No CPA
                if(c.RecordType.Name == 'Enrollment' || c.RecordType.Name == 'Reimbursement')
                {
                    String providerOrPracticeName;
                    if (c.Service_Provider_Practice__c != '' && c.Service_Provider_Practice__c != null) {
                        providerOrPracticeName = c.Service_Provider_Practice__c;
                    } else {
                        providerOrPracticeName = c.Service_Provider_s_Name__c;
                    }
                    fileContent = fileContent
                            .replace('{{PROVIDERORPRACTICENAME}}', providerOrPracticeName)
                            .replace('{{SERVICEPROVIDERNAME}}', c.Service_Provider_s_Name__c)
                            .replace('{{SERVICEPROVIDERADDRESS}}', c.Service_Provider_Address__c)
                            .replace('{{SERVICEPROVIDERFAX}}', formatPhone(FaxNumber))
                            .replace('{{HCPCSCODE}}', c.Contact_Drug__r.HCPCS_Code__c)
                            .replace('{{EFFECTIVEDATE}}', c.Account.Go_Live_Date__c.format());
                }
            }
        }

        Blob pdfContent = Blob.toPDF(fileContent);
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Fax for ' + c.CaseNumber;
        cv.PathOnClient = 'Fax_' + c.CaseNumber + '.pdf';
        cv.VersionData = pdfContent;
        cv.FirstPublishLocationId = c.Id;
        cv.IsMajorVersion = true;

        return cv;
    }

    //Handle case without all fax details
    /*   public static void logCaseFaxErrors(Map<String,String> mapCaseIdWithError)
       {
           // TODO: Write Map to logs... maybe update a Case status??? Not sure will need to be defined by business

       }*/

    //TODO: Need to move this into a Utility class
/*
    public static void notifyUsers(Set<String> recipientsIds, String targetId) {

        //Get the Id for our custom notification type
        CustomNotificationType notificationType =
            [SELECT Id, DeveloperName
             FROM CustomNotificationType
             WHERE DeveloperName='Fax_Missing_Data'];

        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();

        // Set the contents for the notification
        notification.setTitle('Apex Custom Notification');
        notification.setBody('The notifications are coming from INSIDE the Apex!');

        // Set the notification type and target
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);

        // Actually send the notification
        try {
            notification.send(recipientsIds);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }*/


}