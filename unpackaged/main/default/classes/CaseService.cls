/**
 * @description       :
 * @author            : Garrett.Heathcote@PrudentRx.com
 * @group             :
 * @last modified on  : 04-27-2022
 * @last modified by  : Garrett Heathcote
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   04-27-2022   Garrett Heathcote                Initial Version
 * 1.1   05-03-2022   Ricard Banks                     MBP-399 Case Routing Business Logic
 * 1.2   05-03-2022   Garrett Heathcote                MBP-378 Fixing Phone numbers
 * 1.3   05-12-2022   Garrett Heathcote                Refactored Fax into FaxService and removed from CaseService
 **/
global without sharing class CaseService {
/*
    global static Set<Id> routCases(Set<Id> caseIds)
    {
        return service().routCases(caseIds);
    }
*/
    global static List<Case> reRouteNewCaseRoutingRecords(List<Case> casesList)
    {
        return service().reRouteNewCaseRoutingRecords(casesList);
    }

    global static List<Case> reRouteExistingCaseRoutingRecords(List<Case> casesList)
    {
        return service().reRouteExistingCaseRoutingRecords(casesList);
    }

    global static List<Case> setSendToAetna(List<Case> casesList, String sendToAetna)
    {
        return service().setSendToAetna(casesList, sendToAetna);
    }

    global static Id submitCaseRoutingJob()
    {
        return service().submitCaseRoutingJob();
    }

    global static List<Case> setOpenCaseAge(List<Case> casesList)
    {
        return service().setOpenCaseAge(casesList);
    }

    global static List<Case> setClosedCaseAge(List<Case> casesList)
    {
        return service().setClosedCaseAge(casesList);
    }

    global static Case captureCaseOpenAge(Case caseRecord)
    {
        return service().captureCaseOpenAge(caseRecord);
    }

    global static Case captureCaseClosedAge(Case caseRecord)
    {
        return service().captureCaseClosedAge(caseRecord);
    }

    private static ICaseService service()
    {
        return (ICaseService) PMD_Application.Service.newInstance(ICaseService.class);
    }

}