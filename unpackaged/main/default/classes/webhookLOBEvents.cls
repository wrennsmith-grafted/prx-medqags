/**
 * @description       :
 * @author            : Garrett.Heathcote@PrudentRx.com
 * @group             :
 * @last modified on  : 05-15-2023
 * @last modified by  : Travis Sturdivant
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   05-10-2022   Garrett Heathcote                Initial Version
 * 2.0   05-15-2023   Travis Sturdivant                Updating to use Communication__c object instead of Contact
 *
 **/
@RestResource(urlMapping='/api/Webhooks/LOBEvents/*')
global without sharing class webhookLOBEvents {
    @HttpPost
    global static void handleNotification() {
        RestRequest request = RestContext.request;
        
        String ltrId, responseCode,responseMessage;
        try{
            Blob b = request.requestBody;
            String requestString = RestContext.request.requestBody.toString();
            
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(requestString);
            String referenceId = (String) results.get('reference_id');
            //Currently only tracking mailed date so we would want to build this out later if we capture more events
            Map<String, Object> body = (Map<String, Object>) results.get('body');
            String templateId = (String) body.get('template_id');

            //TODO check secret 
//test 8e5c6936805d281dac5fd2144a24b67a9be088ec
//prod 394453af2b86e18eabfe53c509e33705bf707a21
            if(String.isBlank(referenceId))
            {
                String message = 'Reference Id is blank';
                responseCode = '422';
                responseMessage = '{success:false,event:"Empty Reference Id","message:"' + message + '"}';
            }
            else 
            {
                //Use the reference_id from LOB to find the Communication__c record in Salesforce 
                List<Communication__c> lstComm = [SELECT Id FROM Communication__c WHERE Letter_ID__c = :referenceId]; 
                if(lstComm.size() <= 0)
                {
                    String message = 'No communication found for Id:' + referenceId;
                    responseCode = '422';
                    responseMessage = '{success:false,event:"Bad Reference Id","message:"' + message + '"}';
                }
                else
                {          
                    String successMessage = '';
                    //Set the Mailed_Date__c on the Communication__c record to today's date
                    lstComm[0].Mailed_Date__c = system.today(); 
                    successMessage = 'Successfully updated Communication Mailed Date'; 

                    //Update the communication record
                    update lstComm;
                    
                    responseCode = '200';
                    responseMessage = '{success:true,event:"Update","message:"' + successMessage + '"}';
                }
            }
        }
        catch(Exception e)
        {
            System.debug('Rest Exception: ' + e.getMessage());            
            responseCode = '422';
            responseMessage = '{success:false,event:"Unknown","message:"' + e.getMessage() + '"}';      
        }
        
        RestResponse response = RestContext.response;
        if(response != null)
        {
            response.addHeader('Content-Type', 'application/json');
            response.responseBody = Blob.valueOf(responseMessage);
            response.statusCode = Integer.valueOf(responseCode);
        }
    }
   /* @HttpGet
    global static String handleGet() {
        String message = 'Nothing';
    /*    try{
            Contact c = [SELECT Id,Welcome_Letter_Id__c FROM Contact WHERE Id = '0032300000TbEr2AAF' LIMIT 1];// Welcome_Letter_Id__c =:ltrId];
            // lstContactsToCheck[0].Welcome_Letter_Id__c = 'Yay';
            //Contact c = new Contact();
            c.Welcome_Letter_Mailed_Date__c = system.now();
            c.Welcome_Letter_Id__c = 'Yay';
            update c;
        }
        catch(Exception e)
        {
            message = e.getMessage();
        }
       // return '{"message":"' + message + '"}';
    }*/
}

//https://dev1-lobevents.cs28.force.com/services/apexrest/api/Webhooks/LOBEvents/