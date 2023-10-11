/**
 * Created by ricardy.banks on 9/7/2021.
 */

trigger Member_Demographic_Trigger on Member_Demographic__c (
        after delete, after insert, after update, before delete, before insert, before update)
{
    //This trigger handler method eventually calls the Construct inner class of your Domain class to construct a version of your class
    //and implement the logic in it
    fflib_SObjectDomain.triggerHandler(Member_Demo.class);
}