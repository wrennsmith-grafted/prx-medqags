/**
 * Created by ricardy.banks on 8/13/2021.
 */

trigger Daily_Claims_Trigger on Daily_Claim__c (
        after delete, after insert, after update, before delete, before insert, before update)
{
    //This trigger handler method eventually calls the Construct inner class of your Domain class to construct a version of your class
    //and implement the logic in it
    fflib_SObjectDomain.triggerHandler(Daily_Claims.class);
}