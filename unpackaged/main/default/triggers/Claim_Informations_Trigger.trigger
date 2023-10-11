/**
 * Created by ricardy.banks on 8/29/2021.
 */

trigger Claim_Informations_Trigger on Claim_Information__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    //This trigger handler method eventually calls the Construct inner class of your Domain class to construct a version of your class
    //and implement the logic in it
    fflib_SObjectDomain.triggerHandler(Claim_Informations.class);
}