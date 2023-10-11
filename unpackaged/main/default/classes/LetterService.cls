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
public without sharing class LetterService {

    /// Refactor into a custom metadata 
    private static String apiKey = Constants.apiKey;
    private static String endPoint = Constants.endPoint; /// Look into a custom metadata ?
    private static String fromAddressId = Constants.fromAddressId; //Test PrudentRx
    private static String welcomeTemplateId = Constants.welcomeTemplateId; //Test Welcome template
    private static String welcomePostGoLIveId = Constants.welcomePostGoLIveTemplateTestId; //Test Post Go-Live Welcome template
    private static String finalNoticeTemplateId = Constants.finalNoticeTemplateId;

    //public static Constants Constants = new Constants();
    //Overload method to handle single case 50023000003syO6AAI
    public static String processLetterForContact(String cId, String letterType)
    {
        Contact c = new Contact();
        c.Id = cId;
        //Contact c = [SELECT Id, AccountId, CSA__r.Implementation__r.Contract__r.Go_Live_Date__c FROM Contact WHERE Id =: cId LIMIT 1];
        //Only applies to button click and not auto
        // String recentlySent = checkForRecentlySent(c);

        //return recentlySent == null ? processFaxOnCase(new List<Contact>{c}) : recentlySent;
        return processLetterForContact(new List<Contact>{c}, letterType);
    }

    public static String displayLetterButtonStatus(String cId)
    {
        List<Contact> lstContactsToCheck = [SELECT Id, Welcome_Letter_Id__c, disableLetterButton__c, Final_Notice_Id__c, AccountId, CSA__r.Implementation__r.Contract__r.Go_Live_Date__c FROM Contact WHERE id =:cId];

        if(lstContactsToCheck.size() > 0 )
        {
            List<Case> lstMostRecentCase = [SELECT Id FROM Case
            WHERE RecordType.Name = 'Enrollment' AND Status = 'Transfer to Health Plan' AND ContactId =:lstContactsToCheck[0].Id
            ORDER BY CreatedDate DESC LIMIT 1];

            List<Communication__c> lstRelatedComm = [SELECT Id, Communication_Type__c, Disable_Letter_Button__c FROM Communication__c
            WHERE Contact__c = :lstContactsToCheck[0].Id];

            List<Communication__c> lstMostRecentComm = [SELECT Id, Communication_Type__c, Disable_Letter_Button__c FROM Communication__c
            WHERE Contact__c = :lstContactsToCheck[0].Id
            ORDER BY Name DESC LIMIT 1];

            //Return Stage of letters
            if(lstRelatedComm.size() > 1 || (!lstMostRecentComm.isEmpty() && lstMostRecentComm[0].Communication_Type__c == 'Final Notice Letter'))
            {
                String pId = UserInfo.getProfileId();
                String profileName = [Select Name FROM Profile Where Id =:pId].Name;
                if(profileName == 'Call Center Management')
                {
                    return lstMostRecentComm[0].Communication_Type__c == 'Welcome Letter' && lstMostRecentCase.size() > 0 ? 'FinalNotice' : 'FinalNoticeDisabled';
                    // return String.isBlank(lstContactsToCheck[0].Final_Notice_Id__c) && lstMostRecentCase.size() > 0 ? 'FinalNotice' : 'FinalNoticeDisabled';
                }
                else
                {
                    return 'WelcomeDisabled';
                }
            }
            else
            {
                return lstMostRecentComm.size() == 0 || lstMostRecentComm[0].Communication_Type__c != 'Welcome Letter' ? 'Welcome' : 'Welcome2nd';
                // return String.isBlank(lstContactsToCheck[0].Welcome_Letter_Id__c) ? 'Welcome' : 'Welcome2nd';
            }

        }
        else
        {
            return 'Error: Could not find Contact';
        }
    }

    public static String processLetterForCommunication(String contactId, String letterType) {
        List<Contact> lstContacts = [
                SELECT Id,
                        AccountId,
                        FirstName,
                        LastName,
                        Account.Contract__c,
                        Alternative_Mailing_Address_City__c,
                        Alternative_Mailing_Address_State__c,
                        Alternative_Mailing_Address_Street__c, 
                        Alternative_Mailing_Address_Zip_Code__c,
                        Account.Go_Live_Date__c,
                        MailingCity,
                        MailingCountry,
                        MailingPostalcode,
                        MailingStreet,
                        MailingState
                FROM Contact
                WHERE Id = :contactId
        ];
        return processLetterForContact(lstContacts, letterType);
    }

    public static String processLetterForContact(List<Contact> lstContacts, String letterType)
    {
        String method = 'processLetterForContacts';
        Boolean invalidAddress = false;
        List<Communication__c> lstCommunications = new List<Communication__c>();
        String templateId = '';
        String templateVersionId = '';
        String errorMessage = '';
        DateTime goLiveDate;
        //TODO: for when named credential is set up
        // String namedCredential = 'callout:LOB_Letters_Test_Environment'; 

        //If we are in Production, then overwrite the dcev values with Production ones
        List<Organization> org = [SELECT IsSandbox FROM Organization LIMIT 1];
        if(!org[0].IsSandbox)
        {
            apiKey = Constants.apiKeyProduction;
            welcomeTemplateId = Constants.welcomeTemplateIdProduction; //Pre go-live
            welcomePostGoLIveId = Constants.welcomePostGoLIveTemplateProductionId; //Post go-live

            finalNoticeTemplateId = Constants.finalNoticeTemplateIdProduction;
            fromAddressId = Constants.fromAddressIdProduction;
            //TODO: for when named credential is set up
            // namedCredential = 'callout:LOB_Letters_Prod_Environment';
        }

        Set<Id> setContactIds = (new Map<Id,SObject>(lstContacts)).keySet();

        List<Contact> lstContactsToCheck = [SELECT Id, Alternative_Mailing_Address_City__c, Alternative_Mailing_Address_State__c, 
                Alternative_Mailing_Address_Street__c, Alternative_Mailing_Address_Zip_Code__c, 
                MailingCity, MailingStreet, MailingState, MailingPostalCode, Welcome_Letter_Id__c,
                Final_Notice_Id__c, FirstName, LastName, CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, AccountId
        FROM Contact WHERE id IN:setContactIds];

        for (Contact objContact : lstContactsToCheck) {

            goLiveDate = objContact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c;

            //Look into a Named Credential here
            Blob headerValue = Blob.valueOf(apiKey + ':' + '');
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            Http http = new Http();
            //TODO Remove this block when switching to Named Credential
            HttpRequest request = new HttpRequest();
            request.setHeader('Authorization', authorizationHeader);
            request.setHeader('Content-Type', 'application/json');
            request.setEndpoint(Constants.endPoint);
            request.setMethod('POST');
            request.setBody(getLetterBody(objContact,letterType));

            /*
            TODO: use this code when a Named Credential has been set up for letters
            HttpRequest request = new HttpRequest();
            request.setHeader('Authorization', authorizationHeader);
            request.setHeader('Content-Type', 'application/json');
            request.setEndpoint(namedCredential);
            request.setMethod('POST');
            */

            System.debug('CreateLetter request Header:  ' + authorizationHeader);
            System.debug('CreateLetter request EndPoint: ' + request.getEndpoint());
            System.debug('CreateLetter request Method: ' + request.getMethod());
            System.debug('CreateLetter request Body: ' + request.getBody());
            System.debug('CreateLetter Request WHOLE: ' + request);
            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.
            if(response != null)
            {
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('Error Body ' + response.getBody());
                System.debug('Results ' + results);
                if (response.getStatusCode() == 200) {
                    // Deserialize the JSON string into collections of primitive data types.
                    // Cast the values in the 'animals' key as a list
                    String letterId = (String) results.get('id');
                    String expected_delivery_date = (String)results.get('expected_delivery_date');
                    templateId = (String) results.get('template_id');
                    templateVersionId = (String) results.get('template_version_id');

                    System.debug('Expected Delivery Date: ' + expected_delivery_date);
                    System.debug('Letter Id : ' + letterId);
                    if(letterType == Constants.FINALNOTICELETTER)
                    {
                        objContact.Final_Notice_Id__c = letterId;
                        objContact.Final_Notice_Mailed_Date__c = system.now();
                        lstCommunications.add(createCommunicationRecord(objContact, letterId, false, 'Final Notice Letter', templateVersionId, templateId));
                    }
                    else {
                        objContact.disableLetterButton__c = true;
                        objContact.Welcome_Letter_Id__c = letterId;
                        objContact.Welcome_Letter_Mailed_Date__c = system.now();
                        objContact.Invalid_Address__c = false;
                        lstCommunications.add(createCommunicationRecord(objContact, letterId, false, 'Welcome Letter', templateVersionId, templateId));

                        //update lstContactsToCheck;
                        //will need to call createCommunicationRecord method here for welcome letters
                    }

                    //errorMessage = 'Success: Letter sent to vendor for processing, Expected Delivery Date: ' + letterId + ' ' + expected_delivery_date;
                    errorMessage = 'Success: Letter sent to vendor for processing';//, Expected Delivery Date: ' + expected_delivery_date;

                }
                //Bad Address
                else if (response.getStatusCode() == 422) {
                    Map<String, Object> error = (Map<String, Object>) results.get('error');
                    //Do this in the future?
                    System.debug('Error Body ' + response.getBody());
                    errorMessage = 'Error: Invalid USPS Address. Please review Contact\'s address.';//' vendor:' + (String) error.get('message');
                    objContact.Invalid_Address__c = true;
                    if (letterType == Constants.FINALNOTICELETTER) {
                        lstCommunications.add(createCommunicationRecord(objContact, '', true, 'Final Notice Letter', templateVersionId, templateId));
                    } else {
                        // Welcome Letter invalid address here 
                        // need to create Communication for Welcome Letter in future
                        lstCommunications.add(createCommunicationRecord(objContact, '', true, 'Welcome Letter', templateVersionId, templateId));
                        // update lstContactsToCheck;
                    }

                }
                else {
                    errorMessage = 'Error: ' + response.getStatusCode() + ' ' + response.getBody();
                }
            }
        }
        if (lstCommunications.size() > 0) {
            System.debug('@YES Communications Created');

            Database.SaveResult[] saveResultList = Database.insert(lstCommunications, false);

            // Iterate through saveResultList based on isSuccess capture the failed records
            for (Database.SaveResult sr : saveResultList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Communications Successfully inserted' + sr.getId());
                } else {
                    // Operation failed, so get all errors
                    for (Database.Error err : sr.getErrors()) {
                        errorMessage += '\n ' + err.getMessage();
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Communications fields that affected this error: ' + err.getFields());
                        String emailBody = method + '<p>Communications fields that affected this error:  ' + errorMessage;
                        ErrorLog.sendErrorLogEmail('Error processing ' + method, emailBody);
                    }
                }
            }
        } else {
            System.debug('@No Communications Created');
        }
        return errorMessage;
    }

    /**
     * @param mailingStreet String value of the mailing street address to be used in the toAddress
     * @param toAddress toAddress that the letter is being delivered to
     * Splits the address on newline character and sets the toAddress line1 and line2 values as provided
     */
    public static LetterCreateRequest.AddressClass getToAddressLines(String mailingStreet, LetterCreateRequest.AddressClass toAddress) {
        String[] splitAddress = new String[2];
        splitAddress = mailingStreet.split('\n');

        if(splitAddress.size() > 0 && !(splitAddress[0] == '')){
            toAddress.address_line1 = splitAddress[0];
        }
        if (splitAddress.size() > 1 && !(splitAddress[1] == '')){
            toAddress.address_line2 = splitAddress[1];
        }

        return toAddress; 
    }

    public static String getLetterBody(Contact c, String letterType)
    {
        DateTime goLiveDate = c.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c;
        LetterCreateRequest r = new LetterCreateRequest();
        LetterCreateRequest.AddressClass address1 = new LetterCreateRequest.AddressClass();

        /**
         * Check if Alternative Address info is filled out. 
         *      - If populated: use Alternative Address
         *      - If not: use main address 
         */
        LetterCreateRequest.AddressClass toAddress = new LetterCreateRequest.AddressClass();
        if(!string.isBlank(c.Alternative_Mailing_Address_City__c) && 
                        !string.isBlank(c.Alternative_Mailing_Address_State__c) && 
                        !string.isBlank(c.Alternative_Mailing_Address_Street__c) && 
                        !string.isBlank(c.Alternative_Mailing_Address_Zip_Code__c)) 
        {
            // alternative address
            toAddress.address_city = c.Alternative_Mailing_Address_City__c;
            toAddress.address_state = c.Alternative_Mailing_Address_State__c;
            toAddress.address_zip = c.Alternative_Mailing_Address_Zip_Code__c;
            toAddress = getToAddressLines(c.Alternative_Mailing_Address_Street__c, toAddress);
        } else {
            // standard address
            toAddress.address_city = c.MailingCity;
            toAddress.address_state = c.MailingState;
            toAddress.address_zip = c.MailingPostalCode;
            toAddress = getToAddressLines(c.MailingStreet, toAddress);
        }       
        
        toAddress.name = c.FirstName + ' ' + c.LastName;   

        r.toAddress = toAddress; //To address should be anything we want
        r.fromAddress = fromAddressId;
        r.color = 'true';
        r.double_sided = 'true';
        r.address_placement = 'top_first_page';
        r.mail_type = 'usps_first_class';
        //TODO: method to figure out which template to use ... need business requirements first
        if(letterType == Constants.FINALNOTICELETTER)
        {
            r.file = finalNoticeTemplateId;
        }
        else
        {
            //r.file = welcomeTemplateId;
            if (System.today() < goLiveDate) {
                r.file = welcomeTemplateId; //Pre go-live
            } else {
                r.file = welcomePostGoLIveId; //Post go-live
            }

        }

        r.merge_variables = getMergeVariables(c,letterType);
        String cleanReq = JSON.serialize(r);

        //Clean request body for LOB
        cleanReq = cleanReq.replace('fromAddress','from');
        cleanReq = cleanReq.replace('toAddress','to');
        cleanReq = cleanReq.replace('"true"','true');
        cleanReq = cleanReq.replace('"false"','false');
        return cleanReq;
    }

    public static Map<String,String> getMergeVariables(Contact c, String letterType)
    {
        DateTime goLiveDate = c.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c;
        Map<String,String> mergeVars = new Map<String,String>();
        mergeVars.put('GoLiveDate',goLiveDate.addHours(6).format('MMMM d,  yyyy'));
        mergeVars.put('DateSent',System.now().format('MMMM d,  yyyy'));
        mergeVars.put('PatientFirstName',c.FirstName);
        mergeVars.put('ClientSignOff','The PrudentMed Team');

        if(letterType != Constants.FINALNOTICELETTER)
        {
            DateTime todayPlus5 = System.now().addDays(5);
            mergeVars.put('DSPlus5',todayPlus5.format('MMMM d,  yyyy')); //System.TOday plus 5 formatted like January 6th, 2022
        }

        return mergeVars;
    }

    public static Communication__c createCommunicationRecord(Contact objContact, String letterId, Boolean invalidAddress, String communicationType, String versionId, String templateId) {
        Communication__c objCommunication = new Communication__c();
        objCommunication.Account_Name__c = objContact.AccountId;
        objCommunication.Communication_Type__c = communicationType;
        objCommunication.Contact__c = objContact.Id;
        objCommunication.Send_Date__c = System.Today();
        /**
         * Check if Alternative Address info is filled out on Contact
         *      - If populated: populate Communication with Alternate Address info from Contact
         *      - If not: populate Communication with standard Address info from Contact 
         */
        if(!string.isBlank(objContact.Alternative_Mailing_Address_City__c) && 
                    !string.isBlank(objContact.Alternative_Mailing_Address_State__c) && 
                    !string.isBlank(objContact.Alternative_Mailing_Address_Street__c) && 
                    !string.isBlank(objContact.Alternative_Mailing_Address_Zip_Code__c)) 
        {
            // alternative mailing address
            objCommunication.Mailing_City__c = objContact.Alternative_Mailing_Address_City__c;
            objCommunication.Mailing_State__c = objContact.Alternative_Mailing_Address_State__c;
            objCommunication.Mailing_Postal_Code__c = objContact.Alternative_Mailing_Address_Zip_Code__c;
            objCommunication.Mailing_Street__c = objContact.Alternative_Mailing_Address_Street__c;
        } else {
            // standard mailing address 
            objCommunication.Mailing_City__c = objContact.MailingCity;
            objCommunication.Mailing_State__c = objContact.MailingState;
            objCommunication.Mailing_Postal_Code__c = objContact.MailingPostalCode;
            objCommunication.Mailing_Street__c = objContact.MailingStreet;
        }
        
        objCommunication.Letter_ID__c = letterId;
        objCommunication.Template_ID__c = templateId;
        objCommunication.LOB_Version_ID__c = versionId;
        objCommunication.Invalid_Address__c = invalidAddress;

        return objCommunication;
    }

    //Process webhook 
    /*  public static void processMailedLetter(String letterId)
      {
          Contact c = [SELECT Id,Welcome_Letter_Id__c FROM Contact WHERE Welcome_Letter_Id__c =: letterId LIMIT 1];// Welcome_Letter_Id__c =:ltrId];
          // lstContactsToCheck[0].Welcome_Letter_Id__c = 'Yay';
          //Contact c = new Contact();
          c.Welcome_Letter_Mailed_Date__c = system.now();
          c.Welcome_Letter_Id__c = 'Yay';
          update c;
      }*/

}