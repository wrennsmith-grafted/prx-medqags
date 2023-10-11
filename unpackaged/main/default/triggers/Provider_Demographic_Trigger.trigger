/**
 * Created by ricardy.banks on 9/7/2021.
 */

trigger Provider_Demographic_Trigger on Provider_Demographic__c (
after delete, after insert, after update, before delete, before insert, before update)
{
    //This trigger handler method eventually calls the Construct inner class of your Domain class to construct a version of your class
    //and implement the logic in it
    fflib_SObjectDomain.triggerHandler(Provider_Demographic.class);
}