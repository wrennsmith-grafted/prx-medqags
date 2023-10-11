/**
 * Created by gerry on 4/6/2021.
 */

/**
 * Created by gerry on 3/21/2021.
 */

trigger Cases on Case (
		after delete, after insert, after update, before delete, before insert, before update)
{
	//This trigger handler method eventually calls the Construct inner class of your Domain class to construct a version of your class
	//and implement the logic in it
	fflib_SObjectDomain.triggerHandler(Cases.class);
}