/**
 * Created by ricardy.banks on 9/30/2021.
 */

trigger Prior_Auth_Trigger on Prior_Auth__c (
        after delete, after insert, after update, before delete, before insert, before update)
{
    //This trigger handler method eventually calls the Construct inner class of your Domain class to construct a version of your class
    //and implement the logic in it
    fflib_SObjectDomain.triggerHandler(Prior_Auth.class);
}