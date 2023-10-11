/**
 * Created by ricardy.banks on 2/27/2023.
 */

trigger UTCs_Trigger on UTC__c (
        after delete, after insert, after update, before delete, before insert, before update)
{
    //This trigger handler method eventually calls the Construct inner class of your Domain class to construct a version of your class
    //and implement the logic in it
    fflib_SObjectDomain.triggerHandler(UTCs.class);
}