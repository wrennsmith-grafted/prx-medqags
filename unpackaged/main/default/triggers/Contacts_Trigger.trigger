/**
 * Created by ricardy.banks on 8/20/2021.
 */

trigger Contacts_Trigger on Contact (
    after delete, after insert, after update, before delete, before insert, before update)
{
    String profileName = [select Name from profile where id = :UserInfo.getProfileId()].Name;
    //This trigger handler method eventually calls the Construct inner class of your Domain class to construct a version of your class
    //and implement the logic in it
    if(profileName != 'getlobNotification Profile')
    {
        fflib_SObjectDomain.triggerHandler(Contacts.class);
    }

}