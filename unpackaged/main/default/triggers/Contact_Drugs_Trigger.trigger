/**
 * Created by ricardy.banks on 10/14/2021.
 */

trigger Contact_Drugs_Trigger on Contact_Drug__c  (
        after delete, after insert, after update, before delete, before insert, before update)
{
    //This trigger handler method eventually calls the Construct inner class of your Domain class to construct a version of your class
    //and implement the logic in it
    fflib_SObjectDomain.triggerHandler(Contact_Drugs.class);

}