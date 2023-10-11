/**
 * @description       : 
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-06-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-06-2021   Ricardy Banks                    Initial Version
 * 
 */

public class PMd_Application {

	// Configure and create the UnitOfWorkFactory for this Application
	public static final fflib_Application.UnitOfWorkFactory UnitOfWork =
			new fflib_Application.UnitOfWorkFactory(
					new List<SObjectType> {
							Daily_Claim__c.SObjectType,
							Historical_Claim__c.SObjectType,
							Prior_Auth__c.SObjectType,
							Historical_Prior_Auth__c.SObjectType,
							Member_Demographic__c..SObjectType,
							Provider_Demographic__c.SObjectType,
							Account.SObjectType,
							Contact.SObjectType,
							Contact_Drug__c.SObjectType,
							Claim_Information__c.SObjectType,
							Case.SObjectType,
							CSA__c.SObjectType,
							Task.SObjectType
							//Error_Log__c.SObjectType
					}
							//Error_Log__c.SObjectType}
			);

	// Configure and create the ServiceFactory for this Application
	public static final fflib_Application.ServiceFactory Service =
			new fflib_Application.ServiceFactory(
					new Map<Type, Type> {
							IDaily_ClaimsService.class => Daily_ClaimsServiceImpl.class,
							IHistorical_ClaimsService.class => Historical_ClaimsServiceImpl.class,
							IRestAPIService.class => RestAPIsServiceceImpl.class,
							ISHA1UtilService.class => SHA1UtilServiceImpl.class,
							IFormatterUtilService.class => FormatterUtilServiceImpl.class,
							ICaseService.class => CaseServiceImpl.class
					});


	// Configure and create the DomainFactory for this Application
	public static final fflib_Application.DomainFactory Domain =
			new fflib_Application.DomainFactory(
					PMd_Application.Selector,
					new Map<SObjectType, Type> {
							Daily_Claim__c.SObjectType => Daily_Claims.Constructor.class,
							Historical_Claim__c.SObjectType => Historical_Claims.Constructor.class,
							Prior_Auth__c.SObjectType => Prior_Auth.Constructor.class,
							Historical_Prior_Auth__c.SObjectType => Historical_Prior_Auth.Constructor.class,
							Member_Demographic__c.SObjectType => Member_Demo.Constructor.class,
							Provider_Demographic__c.SObjectType => Provider_Demographic.Constructor.class,
							Contact_Drug__c.SObjectType => Contact_Drugs.Constructor.class,
							Claim_Information__c.SObjectType => Claim_Informations.Constructor.class,
							Case.SObjectType => Cases.Constructor.class,
							Contact.SObjectType => Contacts.Constructor.class,
							CSA__c.SObjectType => CSAs.Constructor.class
							//Error_Log__c.SObjectType => ErrorLog.Constructor.class

					});

	// Configure and create the SelectorFactory for this Application
	public static final fflib_Application.SelectorFactory Selector =
			new fflib_Application.SelectorFactory(
					new Map<SObjectType, Type> {
							Daily_Claim__c.SObjectType => Daily_ClaimsSelector.class,
							Historical_Claim__c.SObjectType => Historical_ClaimsSelector.class,
							Prior_Auth__c.SObjectType => Prior_AuthSelector.class,
							Historical_Prior_Auth__c.SObjectType => Historical_Prior_AuthSelector.class,
							Account.SObjectType => AccountsSelector.class,
							Contact.SObjectType => ContactsSelector.class,
							Contact_Drug__c.SObjectType => Contact_DrugsSelector.class,
							Claim_Information__c.SObjectType => Claim_InformationsSelector.class,
							Case.SObjectType => CasesSelector.class,
							CSA__c.SObjectType => CSAsSelector.class,
							Drug__c.SObjectType => DrugsSelector.class,
							NDC__c.SObjectType => NDCsSelector.class,
							Error_Log__c.SObjectType => ErrorLogSelector.class
							//User.SObjectType => UsersSelector.class
							//Task.SObjectType => Task_Selector.class
					});
}