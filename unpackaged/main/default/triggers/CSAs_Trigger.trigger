/**
 * Created by ricardy.banks on 8/19/2021.
 */

trigger CSAs_Trigger on CSA__c (
        after delete, after insert, after update, before delete, before insert, before update)
{
    //This trigger handler method eventually calls the Construct inner class of your Domain class to construct a version of your class
    //and implement the logic in it
    fflib_SObjectDomain.triggerHandler(CSAs.class);
}