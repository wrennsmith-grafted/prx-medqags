/**
 * Created by ricardy.banks on 5/3/2022.
 */

public interface ICaseService
{
    //Set<Id> routCases(Set<Id> caseIds);
    List<Case> reRouteNewCaseRoutingRecords(List<Case> casesList);
    List<Case> reRouteExistingCaseRoutingRecords(List<Case> casesList);
    //List<Case> reRouteAllowCaseRoutingRecords(List<Case> casesList);
    List<Case> setSendToAetna(List<Case> casesList, String sendToAetna);
    List<Case> setOpenCaseAge(List<Case> casesList);
    List<Case> setClosedCaseAge(List<Case> casesList);
    Case captureCaseOpenAge(Case caseRecord);
    Case captureCaseClosedAge(Case caseRecord);

    Id submitCaseRoutingJob();
    Id submitCaseWeeklyUTCFileJob();
}