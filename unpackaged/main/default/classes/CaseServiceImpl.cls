/**
 * Created by ricardy.banks on 5/3/2022.
 */

public with sharing class CaseServiceImpl
        implements ICaseService
{
    public static Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([SELECT Id,Name,DeveloperName FROM Group WHERE Type = 'Queue']);
    public Boolean routeCasesNow = false;
    Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
            postGoLiveFaxValidation, postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLiveReimbursementFollowUp;
    public static Integer FollowupDate,Followuphour,CalculateLocalTime,NewTimeofDay;

   private Long milliseconds, seconds, minutes, hours, days;

    //Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
    //public Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');
    //public Schema.RecordTypeInfo reimbursementCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');

    /*
     * General Case Routing Requirements
     * In order for cases to route the “Case Routing” field on the Account Object must = True
     * If the Member Outreach field  is not = to True, cases can only be routed to the “Fax Validation” queue
     * Based on Go-Live Date cases will be routed to the appropriate Pre or postGoLiveQueues
     * Sweep Open Cases every 15 minutes to determine if they need to be moved
     * Assign cases to the appropriate Pre or postGoLiveQueues 2 hours before the follow-up time or if the follow-up time is in the past
     * All open cases for a member must be assigned to the same agent
     * Any case with an HCP enrollment status of “Fax Received” should be routed to the appropriate follow-up queue based on Go Live
     */

//    public Set<Id> routCases(Set<Id> caseIds)
//    {
        /*
        // Create unit of work to capture work and commit it under one transaction
        fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

        // Query Open Cases that need to be routed
        CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
        List<Case> casesToRoutList = casesSelector.selectById(caseIds);
        //reRouteAllowCaseRoutingRecords(casesToRoutList);
		*/
//        return caseIds;
//    }

    public List<Case> reRouteNewCaseRoutingRecords(List<Case> casesToRoutList){

        // Create unit of work to capture work and commit it under one transaction
        //fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance()
        routeCasesNow = true;
        casesToRoutList = reRouteAllowCaseRoutingRecords(casesToRoutList);
        System.debug('new casesToRoutList.size() = '+casesToRoutList.size());
        //uow.registerNew(casesToRoutList);
        //uow.commitWork();

        return casesToRoutList;
    }

    public List<Case> reRouteExistingCaseRoutingRecords(List<Case> casesToRoutList){

        // Create unit of work to capture work and commit it under one transaction
        fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

        casesToRoutList = reRouteAllowCaseRoutingRecords(casesToRoutList);
        System.debug('update casesToRoutList.size() = '+casesToRoutList.size());

        List<Database.SaveResult> updateResults = Database.update(casesToRoutList, false);
        for(Integer i=0;i<updateResults.size();i++){
            if (updateResults.get(i).isSuccess()){
                updateResults.get(i).getId();

            }else if (!updateResults.get(i).isSuccess()){
                // DML operation failed
                Database.Error error = updateResults.get(i).getErrors().get(0);
                String failedDML = error.getMessage();
                casesToRoutList.get(i);//failed record from the list
                system.debug('Failed ID: '+casesToRoutList.get(i).Id);
                ErrorLog.log('CaseServiceImpl.reRouteExistingCaseRoutingRecords', '', '', '', '', 'Failed ID'+casesToRoutList.get(i).Id + ' ' + failedDML, null, null, null, null);
                ErrorLog.commitLogs();
            }

        }

        /*
        uow.registerDirty(casesToRoutList);
        try {
            uow.commitWork();
        }catch(Exception e){
            System.debug('++ ' + e.getMessage());
            ErrorLog.log('CaseServiceImpl.reRouteExistingCaseRoutingRecords', '', '', '', '', e.getLineNumber() + ' ' +  e.getMessage(), null, null, null, null);
            ErrorLog.commitLogs();
            //throw e;
        }
*/
        return casesToRoutList;
    }

    public List<Case> reRouteAllowCaseRoutingRecords(List<Case> casesToRoutList){

        List<Case> casesRoutedList = new  List<Case>();

        Integer Offset;
        DateTime CurrentDate = System.Now();
        String CurrentDateInGMT = CurrentDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        Integer CurrentDayInGMT = CurrentDate.dayGMT();
        Integer CurrentHourInGMT = CurrentDate.hourGMT();
        Date dateToday = System.today();
        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
        Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');
        Schema.RecordTypeInfo reimbursementCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('queue = '+queue);
                System.debug('GroupId = '+GroupId);
                switch on queue {
                    when 'General' { // when queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when queue is Post-Go-Live Enrollment - NEW Queu
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when queue is Post-Go-Live Reimbursement - NEW Queu
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLiveReimbursementFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Fax_Validation' { // when queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLiveFaxValidation = GroupId;
                    }
                }
            }
        }

        System.debug('Start Routing Cases');
        DateTime currentDateTime = DateTime.now();
        //currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        for(Case caseRecord : casesToRoutList){
            //Datetime mbrFollowupTime = caseRecord.Follow_up_Time__c.addHours(-4); //System is using UTC time 4 hours ahead of EST
            //Start of Custom code logic to recalculate the Follow up Date and Time based on Local Time Zone.
            String LocalTimeZone = '';
            String GMTOffset = '';
            Date eopDateAdj;
            Date eopDate = caseRecord.EOP_Date__c;
            System.debug('caseRecord.Claim_Information__c = ' + caseRecord.Claim_Information__c);
            System.debug('eopDate = ' + eopDate);
            if(eopDate != null) {
                eopDateAdj = eopDate.addDays(5);
                DateTime eopDateTime = (DateTime)eopDateAdj;
                Integer weekendDayAdj = 0;
                switch on eopDateTime.format('E') { // dayOfWeek is Sun, Mon, Tue, etc. {
                    when 'Sat' {
                        weekendDayAdj = 2;
                    }
                    when 'Sun' {
                        weekendDayAdj = 1;
                    }
                }
                eopDateAdj = eopDateAdj.addDays(weekendDayAdj);
                System.debug('eopDateAdj = ' + eopDateAdj);
                System.debug('dateToday.daysBetween(eopDateAdj) = ' + dateToday.daysBetween(eopDateAdj));
            }

            if(caseRecord.RecordTypeId == enrollmentCaseInfo.getRecordTypeId()
                || (caseRecord.RecordTypeId == reimbursementCaseInfo.getRecordTypeId()
                    && (eopDate == null || dateToday.daysBetween(eopDateAdj) < 1)) )
            {
                if (caseRecord.Follow_up_Time__c != null && (caseRecord.OwnerId == generalQueue)) {
                    if (Test.isRunningTest()) {
                        System.debug('The Case Number is: ' + caseRecord.CaseNumber);
                        System.debug('Inside the reRouteAllowCaseRoutingRecords method and The Contact Local Time Zone is: ' + LocalTimeZone);
                        System.debug('Inside the reRouteAllowCaseRoutingRecords method and The new Offset value is: ' + Offset);

                        if (caseRecord.Follow_up_Time__c < System.Now()) {
                            System.debug('*****The Follow up Date and Time is in the past*****');
                            caseRecord.Follow_up_Time__c = System.Now();
                            System.debug('******The new Follow up Date and Time is: ' + caseRecord.Follow_up_Time__c);
                        }
                        System.debug('The Follow up Date and Time Before calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);

                        FollowupDate = caseRecord.Follow_up_Time__c.dayGMT();
                        Followuphour = caseRecord.Follow_up_Time__c.hourGMT();

                        System.debug('The Follow up GMT Date(FollowupDate) value is: ' + String.valueof(FollowupDate));
                        System.debug('The Follow up GMT hour(Followuphour) value is: ' + String.valueof(Followuphour));

                        for (integer i = 0; i <= 26; i++) {
                            if (i == 0) {
                                LocalTimeZone = 'America/New_York';
                                Offset = 05;
                                GMTOffset = '-05:00';
                                CalculateLocalTime = 7;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 1) {
                                LocalTimeZone = 'America/Panama';
                                Offset = 05;
                                GMTOffset = '-05:00';
                                CalculateLocalTime = 7;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 2) {
                                LocalTimeZone = 'America/Chicago';
                                Offset = 06;
                                GMTOffset = '-06:00';
                                CalculateLocalTime = 7;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 3) {
                                LocalTimeZone = 'America/Denver';
                                Offset = 07;
                                GMTOffset = '-07:00';
                                CalculateLocalTime = 7;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 4) {
                                LocalTimeZone = 'America/Phoenix';
                                Offset = 07;
                                GMTOffset = '-07:00';
                                CalculateLocalTime = 7;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 5) {
                                LocalTimeZone = 'America/Los_Angeles';
                                Offset = 08;
                                GMTOffset = '-08:00';
                                CalculateLocalTime = 7;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 6) {
                                LocalTimeZone = 'America/Anchorage';
                                Offset = 09;
                                GMTOffset = '-09:00';
                                CalculateLocalTime = 7;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 7) {
                                LocalTimeZone = 'America/Adak';
                                Offset = 10;
                                GMTOffset = '-10:00';
                                CalculateLocalTime = 7;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 8) {
                                LocalTimeZone = 'Pacific/Honolulu';
                                Offset = 10;
                                GMTOffset = '-10:00';
                                CalculateLocalTime = 7;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 9) {
                                LocalTimeZone = 'America/New_York';
                                Offset = 04;
                                GMTOffset = '-04:00';
                                CalculateLocalTime = -2;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 10) {
                                LocalTimeZone = 'America/Panama';
                                Offset = 04;
                                GMTOffset = '-04:00';
                                CalculateLocalTime = -2;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 11) {
                                LocalTimeZone = 'America/Chicago';
                                Offset = 05;
                                GMTOffset = '-05:00';
                                CalculateLocalTime = -2;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 12) {
                                LocalTimeZone = 'America/Denver';
                                Offset = 06;
                                GMTOffset = '-06:00';
                                CalculateLocalTime = -2;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 13) {
                                LocalTimeZone = 'America/Phoenix';
                                Offset = 06;
                                GMTOffset = '-06:00';
                                CalculateLocalTime = -2;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 14) {
                                LocalTimeZone = 'America/Los_Angeles';
                                Offset = 07;
                                GMTOffset = '-07:00';
                                CalculateLocalTime = -2;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 15) {
                                LocalTimeZone = 'America/Anchorage';
                                Offset = 08;
                                GMTOffset = '-08:00';
                                CalculateLocalTime = -2;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 16) {
                                LocalTimeZone = 'America/Adak';
                                Offset = 09;
                                GMTOffset = '-09:00';
                                CalculateLocalTime = -2;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 17) {
                                LocalTimeZone = 'Pacific/Honolulu';
                                Offset = 09;
                                GMTOffset = '-09:00';
                                CalculateLocalTime = -2;
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            }
                            if (i == 18) {
                                LocalTimeZone = 'America/New_York';
                                Offset = 05;
                                GMTOffset = '-05:00';
                                caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.adddays(1);
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 19) {
                                LocalTimeZone = 'America/Panama';
                                Offset = 05;
                                GMTOffset = '-05:00';
                                caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.adddays(1);
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 20) {
                                LocalTimeZone = 'America/Chicago';
                                Offset = 06;
                                GMTOffset = '-06:00';
                                caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.adddays(1);
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 21) {
                                LocalTimeZone = 'America/Denver';
                                Offset = 07;
                                GMTOffset = '-07:00';
                                caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.adddays(1);
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 22) {
                                LocalTimeZone = 'America/Phoenix';
                                Offset = 07;
                                GMTOffset = '-07:00';
                                caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.adddays(1);
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 23) {
                                LocalTimeZone = 'America/Los_Angeles';
                                Offset = 08;
                                GMTOffset = '-08:00';
                                caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.adddays(1);
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 24) {
                                LocalTimeZone = 'America/Anchorage';
                                Offset = 09;
                                GMTOffset = '-09:00';
                                caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.adddays(1);
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 25) {
                                LocalTimeZone = 'America/Adak';
                                Offset = 10;
                                GMTOffset = '-10:00';
                                caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.adddays(1);
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            } else if (i == 26) {
                                LocalTimeZone = 'Pacific/Honolulu';
                                Offset = 10;
                                GMTOffset = '-10:00';
                                caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.adddays(1);
                                RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                                System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                            }
                        }
                    } else {
                        if (caseRecord.Contact.GLOC__Location_Time_Zone__c != null && caseRecord.Contact.GLOC__Location_Time_Zone__c != '' && caseRecord.Contact.MailingState != null && caseRecord.Contact.MailingCountry != null) {
                            LocalTimeZone = caseRecord.Contact.GLOC__Location_Time_Zone__c;
                            if (LocalTimeZone == 'America/Adak' || LocalTimeZone == 'Pacific/Honolulu') {
                                Offset = Integer.valueOf((caseRecord.Contact.GLOC__Location_GMT__c.substring(1, 3)));
                                GMTOffset = caseRecord.Contact.GLOC__Location_GMT__c;
                            } else {
                                Offset = Integer.valueOf((caseRecord.Contact.GLOC__Location_GMT__c.substring(2, 3)));
                                GMTOffset = caseRecord.Contact.GLOC__Location_GMT__c;
                            }
                        } else {
                            LocalTimeZone = 'America/Los_Angeles';
                            Offset = 08;
                            GMTOffset = '-08:00';
                        }
                        System.debug('The Case Number is: ' + caseRecord.CaseNumber);
                        System.debug('Inside the reRouteAllowCaseRoutingRecords method and The Contact Local Time Zone is: ' + LocalTimeZone);
                        System.debug('Inside the reRouteAllowCaseRoutingRecords method and The new Offset value is: ' + Offset);

                        if (caseRecord.Follow_up_Time__c < System.Now()) {
                            System.debug('*****The Follow up Date and Time is in the past*****');
                            caseRecord.Follow_up_Time__c = System.Now();
                            System.debug('******The new Follow up Date and Time is: ' + caseRecord.Follow_up_Time__c);
                        }
                        System.debug('The Follow up Date and Time Before calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);

                        FollowupDate = caseRecord.Follow_up_Time__c.dayGMT();
                        Followuphour = caseRecord.Follow_up_Time__c.hourGMT();

                        System.debug('The Follow up GMT Date(FollowupDate) value is: ' + String.valueof(FollowupDate));
                        System.debug('The Follow up GMT hour(Followuphour) value is: ' + String.valueof(Followuphour));

                        CalculateLocalTime = Followuphour - Offset;
                        caseRecord = RecalculateLocalTime(caseRecord, LocalTimeZone, GMTOffset, Offset, CalculateLocalTime);
                        System.debug('The Follow up Date and Time After calling the RecalculateLocalTime method: ' + caseRecord.Follow_up_Time__c);
                    }
                }//end of if loop to check the Go Local attributes for Case Routing

                Datetime mbrFollowupTime = caseRecord.Follow_up_Time__c;
                System.debug('mbrFollowupTime = ' + mbrFollowupTime);
                System.debug('currentDateTime = ' + currentDateTime);


                System.debug('The Contact related to the Case record is: ' + caseRecord.Contact.Name);
                System.debug('The Case Number is: ' + caseRecord.CaseNumber);

                System.debug('The Member Enrollment Status Outreach on the Case is: ' + caseRecord.Status);
                System.debug('The Member Follow up time on the Case is: ' + mbrFollowupTime);
                if (mbrFollowupTime != null) {
                    FollowupDate = mbrFollowupTime.dayGMT();
                    Followuphour = mbrFollowupTime.hourGMT();
                    System.debug('mbrFollowupTime.addHours(-2) = ' + mbrFollowupTime.addHours(-2));
                    //System.debug('The new Offset value from the GMT Time is: '+Offset);
                    System.debug('The new CalculateLocal Time from the GMT Time is: ' + CalculateLocalTime);
                    System.debug('The Follow up GMT Date value is: ' + String.valueof(FollowupDate));
                    System.debug('The Follow up GMT hour value is: ' + String.valueof(Followuphour));
                    System.debug('------');
                }
                //CalculateLocalTime = Followuphour - Offset;


                //Assign cases to the appropriate Pre or Post-Go-Live Queues 2 hours before the follow-up time or if the follow-up time is in the past
                //if( mbrFollowupTime != null && currentDateTime >= mbrFollowupTime.addHours(-2) || caseRecord.Status != 'Verify Fax Number') {
                if (mbrFollowupTime != null && caseRecord.Status != 'Verify Fax Number') {
                    System.debug('System.today()  = ' + System.today());
                    System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
                    //PRE-Go-Live
                    if (caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c != null) {
                        if (System.today() < caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c) {
                            System.debug('PRE-Go-Live');
                            System.debug('caseRecord.Status = ' + caseRecord.Status);
                            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c);
                            System.debug('caseRecord.OwnerId = ' + caseRecord.OwnerId);
                            //If the Member Outreach field is True
                            if (caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c) {
                                if ((caseRecord.Status == '1st Attempt Needed'
                                        || caseRecord.Status == '2nd Attempt Needed'
                                        || caseRecord.Status == '3rd Attempt Needed'
                                        || caseRecord.Status == '4th Attempt Needed'
                                        || caseRecord.Status == '5th Attempt Needed')
                                        && caseRecord.OwnerId == generalQueue) {
                                    caseRecord.OwnerId = preGoLiveEnrollmentFollowUp;
                                    System.debug('caseRecord.Status = ' + caseRecord.Status);
                                    System.debug('caseRecord.OwnerId = preGoLiveEnrollmentFollowUp');
                                } else if (caseRecord.Status == 'Transfer to Health Plan') {
                                    caseRecord.OwnerId = generalQueue;
                                    System.debug('caseRecord.OwnerId = generalQueue');
                                } else if (caseRecord.OwnerId == generalQueue) {
                                    caseRecord.OwnerId = preGoLiveNewEnrollment;
                                    System.debug('caseRecord.OwnerId = preGoLiveNewEnrollment');
                                }
                                //Any case with an HCP enrollment status of “Fax Received” should be routed to the appropriate follow-up queue based on Go Live
                                if (caseRecord.HCP_Enrollment_Outreach__c == 'Fax Received') {
                                    caseRecord.OwnerId = preGoLiveEnrollmentFollowUp;
                                    System.debug('caseRecord.OwnerId = preGoLiveEnrollmentFollowUp');
                                }
                            } else {
                                //If the Member Outreach field  is not True, cases can only be routed to the “Fax Validation” queue
                                caseRecord.OwnerId = preGoLiveFaxValidation;
                                System.debug('caseRecord.OwnerId = preGoLiveFaxValidation');

                                //Any case with an HCP enrollment status of “Fax Received” should be routed to the appropriate follow-up queue based on Go Live
                                if (caseRecord.HCP_Enrollment_Outreach__c == 'Fax Received') {
                                    caseRecord.OwnerId = preGoLiveEnrollmentFollowUp;
                                    System.debug('caseRecord.OwnerId = preGoLiveEnrollmentFollowUp');
                                } else if (caseRecord.Status != 'Verify Fax Number') {
                                    System.debug('Case Status != Verify Fax Number');
                                    caseRecord.OwnerId = generalQueue;
                                    System.debug('caseRecord.OwnerId = generalQueue');
                                } else if (caseRecord.Status == '1st Attempt Needed'
                                        || caseRecord.Status == '2nd Attempt Needed'
                                        || caseRecord.Status == '3rd Attempt Needed'
                                        || caseRecord.Status == '4th Attempt Needed'
                                        || caseRecord.Status == '5th Attempt Needed'
                                        || caseRecord.Status == 'Transfer to Health Plan') {
                                    caseRecord.OwnerId = generalQueue;
                                    System.debug('caseRecord.OwnerId = generalQueue');
                                } else if (caseRecord.OwnerId == generalQueue) {
                                    caseRecord.OwnerId = preGoLiveFaxValidation;
                                    System.debug('caseRecord.OwnerId = preGoLiveFaxValidation');
                                }
                            }
                            //Any case with an HCP enrollment status of “Fax Received” should be routed to the appropriate follow-up queue based on Go Live
                            //Fax Confirmed?
                            if (caseRecord.HCP_Enrollment_Outreach__c == 'Fax Received') {
                                System.debug('Fax IS Confirmed');
                                caseRecord.OwnerId = preGoLiveEnrollmentFollowUp;
                                System.debug('caseRecord.Status = ' + caseRecord.Status);
                                System.debug('caseRecord.OwnerId = preGoLiveEnrollmentFollowUp');
                            }
                        } else {
                            System.debug('POST-Go-Live');
                            //If Case Type = Enrollment
                            System.debug('caseRecord.RecordType.Name = ' + caseRecord.RecordType.Name);
                            System.debug('caseRecord.Status = ' + caseRecord.Status) ;

                            //If the Member Outreach field  is True
                            if (caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c) {
                                //If case is open
                                if (caseRecord.Status != 'Outreach Completed') {
                                    routePostGoLiveCase(caseRecord);
                                    /*
                                if (caseRecord.Type == 'Enrollment') {
                                    //Any case with an HCP enrollment status of “Fax Received” should be routed to the appropriate follow-up queue based on Go Live
                                    if (caseRecord.HCP_Enrollment_Outreach__c == 'Fax Received') {
                                        caseRecord.OwnerId = postGoLiveEnrollmentFollowUp;
                                        System.debug('caseRecord.OwnerId = postGoLiveEnrollmentFollowUp');
                                    } else if (caseRecord.Status == 'Verify Fax Number') {
                                        caseRecord.OwnerId = postGoLiveNewEnrollment;
                                        System.debug('caseRecord.OwnerId = postGoLiveNewEnrollment');
                                    } else {
                                        caseRecord.OwnerId = postGoLiveEnrollmentFollowUp;
                                        System.debug('caseRecord.OwnerId = postGoLiveEnrollmentFollowUp');
                                    }
                                    //If Case Type = Reimbursement
                                } else {
                                    //Any case with an HCP enrollment status of “Fax Received” should be routed to the appropriate follow-up queue based on Go Live
                                    if (caseRecord.HCP_Enrollment_Outreach__c == 'Fax Received') {
                                        caseRecord.OwnerId = postGoLiveReimbursementFollowUp;
                                        System.debug('caseRecord.OwnerId = postGoLiveReimbursementFollowUp');
                                    } else if (caseRecord.Status == 'Verify Fax Number') {
                                        caseRecord.OwnerId = postGoLiveNewReimbursement;
                                        System.debug('caseRecord.OwnerId = postGoLiveNewReimbursement');
                                    } else {
                                        caseRecord.OwnerId = postGoLiveReimbursementFollowUp;
                                        System.debug('caseRecord.OwnerId = postGoLivReimbursementFollowUp');
                                    }
                                }
                                */
                                    //Case closed
                                } else {
                                    caseRecord.OwnerId = generalQueue;
                                    System.debug('caseRecord.OwnerId = generalQueue');
                                }
                            } else {
                                //If the Member Outreach field  is not True, cases can only be routed to the generalQueue
                                caseRecord.OwnerId = generalQueue;
                                System.debug('caseRecord.OwnerId = generalQueue');
                            }
                        }
                    }
                } else {
                    caseRecord.OwnerId = generalQueue;
                    System.debug('caseRecord.OwnerId = generalQueue');

                    if (System.today() < caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c) {
                        System.debug('PRE-Go-Live');
                        //If the Member Outreach field  is True
                        if (caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c && caseRecord.Status == 'Verify Fax Number') {
                            caseRecord.OwnerId = preGoLiveNewEnrollment;
                            System.debug('caseRecord.OwnerId = preGoLiveNewEnrollment');
                            //TODO: Add case.Status = Transfer to Health Plan
                        } else if (caseRecord.Status == 'Transfer to Health Plan') {
                            caseRecord.OwnerId = generalQueue;
                            System.debug('caseRecord.OwnerId = generalQueue');
                        } else {
                            caseRecord.OwnerId = preGoLiveFaxValidation;
                            System.debug('caseRecord.OwnerId = preGoLiveFaxValidation');
                        }
                    } else {
                        System.debug('POST-Go-Live');
                        System.debug('caseRecord.RecordType.Name = ' + caseRecord.RecordType.Name);
                        //If the Member Outreach field  is True
                        if (caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c && caseRecord.Status == 'Verify Fax Number') {
                            routePostGoLiveCase(caseRecord);
                            /*
                        if (caseRecord.Type == 'Enrollment') {
                            //Any case with an HCP enrollment status of “Fax Received” should be routed to the appropriate follow-up queue based on Go Live
                            if (caseRecord.HCP_Enrollment_Outreach__c == 'Fax Received') {
                                caseRecord.OwnerId = postGoLiveEnrollmentFollowUp;
                                System.debug('caseRecord.OwnerId = postGoLiveEnrollmentFollowUp');
                            } else if (caseRecord.Status == 'Verify Fax Number') {
                                caseRecord.OwnerId = postGoLiveNewEnrollment;
                                System.debug('caseRecord.OwnerId = postGoLiveNewEnrollment');
                            } else {
                                caseRecord.OwnerId = postGoLiveEnrollmentFollowUp;
                                System.debug('caseRecord.OwnerId = postGoLiveEnrollmentFollowUp');
                            }
                            //If Case Type = Reimbursement
                        } else {
                            //Any case with an HCP enrollment status of “Fax Received” should be routed to the appropriate follow-up queue based on Go Live
                            if (caseRecord.HCP_Enrollment_Outreach__c == 'Fax Received') {
                                caseRecord.OwnerId = postGoLiveReimbursementFollowUp;
                                System.debug('caseRecord.OwnerId = postGoLiveReimbursementFollowUp');
                            } else if (caseRecord.Status == 'Verify Fax Number') {
                                caseRecord.OwnerId = postGoLiveNewReimbursement;
                                System.debug('caseRecord.OwnerId = postGoLiveNewReimbursement');
                            } else {
                                caseRecord.OwnerId = postGoLiveReimbursementFollowUp;
                                System.debug('caseRecord.OwnerId = postGoLivReimbursementFollowUp');
                            }
                        }
                        */
                            //TODO: Add case.Status = Transfer to Health Plan
                        } else if (caseRecord.Status == 'Transfer to Health Plan') {
                            caseRecord.OwnerId = generalQueue;
                            System.debug('caseRecord.OwnerId = generalQueue');
                        } else {
                            caseRecord.OwnerId = postGoLiveFaxValidation;
                            System.debug('caseRecord.OwnerId = postGoLiveFaxValidation');
                        }
                    }
                }
            }
            casesRoutedList.add(caseRecord);
            System.debug('new casesRoutedList.size() = '+casesRoutedList.size());
        }
        System.debug('End Routing Cases');

        return casesRoutedList;
    }

    private void routePostGoLiveCase(Case caseRecord) {
        if (caseRecord.RecordType.Name == 'Enrollment'){
            //Any case with an HCP enrollment status of “Fax Received” should be routed to the appropriate follow-up queue based on Go Live
            if (caseRecord.HCP_Enrollment_Outreach__c == 'Fax Received') {
                caseRecord.OwnerId = postGoLiveEnrollmentFollowUp;
                System.debug('caseRecord.OwnerId = postGoLiveEnrollmentFollowUp');
            } else if (caseRecord.Status == 'Verify Fax Number') {
                caseRecord.OwnerId = postGoLiveNewEnrollment;
                System.debug('caseRecord.OwnerId = postGoLiveNewEnrollment');
            } else if (caseRecord.Status == 'Transfer to Health Plan') {
                caseRecord.OwnerId = generalQueue;
                System.debug('caseRecord.OwnerId = generalQueue');
            } else {
                caseRecord.OwnerId = postGoLiveEnrollmentFollowUp;
                System.debug('caseRecord.OwnerId = postGoLiveEnrollmentFollowUp');
            }
            //If Case Type = Reimbursement
        } else {
            //Any case with an HCP enrollment status of “Fax Received” should be routed to the appropriate follow-up queue based on Go Live
            if (caseRecord.HCP_Enrollment_Outreach__c == 'Fax Received') {
                caseRecord.OwnerId = postGoLiveReimbursementFollowUp;
                System.debug('caseRecord.OwnerId = postGoLiveReimbursementFollowUp');
            } else if (caseRecord.Status == 'Verify Fax Number') {
                caseRecord.OwnerId = postGoLiveNewReimbursement;
                System.debug('caseRecord.OwnerId = postGoLiveNewReimbursement');
            } else if (caseRecord.Status == 'Transfer to Health Plan') {
                caseRecord.OwnerId = generalQueue;
                System.debug('caseRecord.OwnerId = generalQueue');
            } else {
                caseRecord.OwnerId = postGoLiveReimbursementFollowUp;
                System.debug('caseRecord.OwnerId = postGoLivReimbursementFollowUp');
            }
        }
    }

    public List<Case> setSendToAetna(List<Case> casesList, String sendToAetnaStatus){

        System.debug('Start setSendToAetna');

        List<Case> casesUpdated = new List<Case>();
        for(Case caseRecord : casesList){
            caseRecord.Send_to_Aetna__c = sendToAetnaStatus;
            System.debug('caseRecord.CaseNumber = ' + caseRecord.CaseNumber);
            System.debug('caseRecord.Send_to_Aetna__c = ' + caseRecord.Send_to_Aetna__c);
            casesUpdated.add(caseRecord);
        }

        System.debug('End setSendToAetna');

        return casesUpdated;
    }

    public Id submitCaseRoutingJob()
    {
        // Submit the job via Batch Apex,
        //   service layer can perform validations and updates such as logging etc on behalf of client
        //   also configure scope size, knowledge of the class to use etc is encapsulated in the service
        return Database.executeBatch(new CaseRoutingJob());
    }

    public Id submitCaseWeeklyUTCFileJob()
    {
        // Submit the job via Batch Apex,
        //   service layer can perform validations and updates such as logging etc on behalf of client
        //   also configure scope size, knowledge of the class to use etc is encapsulated in the service
        return Database.executeBatch(new CaseWeeklyUTCFileJob());
    }

    public static Case RecalculateLocalTime(Case caseRecord,String LocalTimeZone,String GMTOffset,Integer Offset,Integer CalculateLocalTime){
        Integer NewTimeofDay;
        DateTime CurrentDate = System.Now();
        String CurrentDateInGMT = CurrentDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        Integer CurrentDayInGMT = CurrentDate.dayGMT();
        Integer CurrentHourInGMT = CurrentDate.hourGMT();

        System.debug('**********Start of Debug Logs inside the RecalculateLocalTime Method**************************');

        System.debug('The CurrentDateInGMT value is: '+CurrentDateInGMT);
        System.debug('The CurrentDayInGMT value is: '+CurrentDayInGMT);
        System.debug('The CurrentHourInGMT value is: '+CurrentHourInGMT);
        System.debug('The new Offset value from the GMT Time is: '+Offset);
        System.debug('The new CalculateLocal Time(CalculateLocalTime) from the GMT Time is: '+CalculateLocalTime);

        if((LocalTimeZone == 'America/New_York' || LocalTimeZone == 'America/Panama')){
            //Below condition from 12:00 AM - 8:00 AM EST
            if(CalculateLocalTime >= 0 && CalculateLocalTime < 8){
                System.debug('The Follow up time is before the local time start of 8:00 AM in EST');
                if(GMTOffset == '-05:00')
                    NewTimeOfDay = 13 - Followuphour;
                else
                        NewTimeOfDay = 14 - Followuphour;

                if(FollowupDate == CurrentDayInGMT)
                    caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
            }
            else if((CalculateLocalTime < 0)){
                System.debug('The Follow up time is cannot be scheduled in the past during EST hours');
                if(GMTOffset == '-05:00')
                    NewTimeOfDay = 13 - Followuphour;
                else
                        NewTimeOfDay = 14 - Followuphour;

                if((FollowupDate == CurrentDayInGMT))
                    caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
            }
            else if((FollowupDate == CurrentDayInGMT + 1) && (Followuphour >= 1)){
                System.debug('The Follow up time is after the local time end of 8:00 PM EST');
                if(GMTOffset == '-05:00')
                    NewTimeOfDay = Offset + 9;
                else
                        NewTimeOfDay = Offset + 10;
                caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
            }
            System.debug('The EST value of Follow up Date and Time value is: '+caseRecord.Follow_up_Time__c);
        }//end of loop for EST Time zone
        else if(LocalTimeZone == 'America/Chicago'){
            if((CalculateLocalTime >= 0 && CalculateLocalTime < 9)){
                System.debug('The Follow up time is before the local time start of 8:00 AM in CST');
                if(GMTOffset == '-06:00')
                    NewTimeOfDay = 14 - Followuphour;
                else
                        NewTimeOfDay = 15 - Followuphour;
                System.debug('The NewTimeOfDay value is: '+NewTimeOfDay);
                if((FollowupDate == CurrentDayInGMT)){
                    caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
                }
            }
            else if((CalculateLocalTime < 0)){
                System.debug('The Follow up time cannot be scheduled in the past during CST hours');
                if(GMTOffset == '-06:00')
                    NewTimeOfDay = 14 - Followuphour;
                else
                        NewTimeOfDay = 15 - Followuphour;
                System.debug('The NewTimeOfDay value is: '+NewTimeOfDay);
                if(FollowupDate == CurrentDayInGMT){
                    caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
                }
            }
            else if((FollowupDate == CurrentDayInGMT + 1) && (Followuphour >= 2)){
                System.debug('The Follow up time is after the local time end of 8:00 PM CST');
                if(GMTOffset == '-06:00')
                    NewTimeOfDay = Offset + 8;
                else
                        NewTimeOfDay = Offset + 9;
                caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
            }
            System.debug('The CST value of Follow up Date and Time value is: '+caseRecord.Follow_up_Time__c);
        }
        else if((LocalTimeZone == 'America/Denver' || LocalTimeZone == 'America/Phoenix')){
            if((CalculateLocalTime >= 0 && CalculateLocalTime < 10)){
                System.debug('The Follow up time is before the local time start of 8:00 AM in MST');
                if(GMTOffset == '-07:00')
                    NewTimeOfDay = 15 - Followuphour;
                else
                        NewTimeOfDay = 14 - Followuphour;

                if((FollowupDate == CurrentDayInGMT)){
                    if(NewTimeOfDay < 0 || NewTimeOfDay == 0)
                        System.debug('The follow up Date and Time is good AS-Is and there is not need to add anything to the FOllow up Date and Time');
                    else
                            caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
                }
            }
            else if((CalculateLocalTime >= 10)){
                System.debug('The Follow up time cannot be scheduled in the past during MST hours');
                if(GMTOffset == '-07:00')
                    NewTimeOfDay = 15 - Followuphour;
                else
                        NewTimeOfDay = 14 - Followuphour;

                if((FollowupDate == CurrentDayInGMT)){
                    if(NewTimeOfDay < 0 || NewTimeOfDay == 0)
                        System.debug('The follow up Date and Time is good AS-Is and there is not need to add anything to the FOllow up Date and Time');
                    else
                            caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
                }
            }
            else if((CalculateLocalTime < 0)){
                System.debug('The Follow up time is cannot be scheduled in the past during MST hours');
                if(GMTOffset == '-07:00')
                    NewTimeOfDay = 15 - Followuphour;
                else
                        NewTimeOfDay = 14 - Followuphour;

                if((FollowupDate == CurrentDayInGMT)){
                    if(NewTimeOfDay < 0 || NewTimeOfDay == 0){
                        System.debug('The follow up Date and Time is good AS-Is and there is not need to add anything to the FOllow up Date and Time');
                    }
                    else{
                        caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
                    }
                }
            }
            else if((FollowupDate == CurrentDayInGMT + 1) && (Followuphour >= 3)){
                System.debug('The Follow up time is after the local time end of 8:00 PM MST');
                if(GMTOffset == '-07:00')
                    NewTimeOfDay = Offset + 7;
                else
                        NewTimeOfDay = Offset + 8;

                if(NewTimeOfDay < 0 || NewTimeOfDay == 0){
                    System.debug('The follow up Date and Time is good AS-Is and there is not need to add anything to the FOllow up Date and Time');
                }
                else
                        caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
            }
            System.debug('The MST value of Follow up Date and Time value is: '+caseRecord.Follow_up_Time__c);
        }
        else if(LocalTimeZone == 'America/Los_Angeles'){
            if((CalculateLocalTime >= 0 && CalculateLocalTime < 11)){
                System.debug('The Follow up time is before the local time start of 8:00 AM in PST');
                if(GMTOffset== '-08:00')
                    NewTimeOfDay = 16 - Followuphour;
                else
                        NewTimeOfDay = 15 - Followuphour;

                if((FollowupDate == CurrentDayInGMT)){
                    caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
                }
            }
            else if((CalculateLocalTime < 0)){
                System.debug('The Follow up time is cannot be scheduled in the past during PST hours');
                if(GMTOffset == '-08:00')
                    NewTimeOfDay = 16 - Followuphour;
                else
                        NewTimeOfDay = 15 - Followuphour;

                if(NewTimeOfDay < 0 || NewTimeOfDay == 0){
                    System.debug('The follow up Date and Time is good AS-Is and there is not need to add anything to the Follow up Date and Time');
                }
                if((FollowupDate == CurrentDayInGMT)){
                    caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
                }
            }
            else if((FollowupDate == CurrentDayInGMT + 1) && (Followuphour >= 3)){
                System.debug('The Follow up time is after the local time end of 8:00 PM PST');
                if(GMTOffset == '-08:00')
                    NewTimeOfDay = Offset + 6;
                else
                        NewTimeOfDay = Offset + 7;
                if(NewTimeOfDay < 0 || NewTimeOfDay == 0){
                    System.debug('The follow up Date and Time is good AS-Is and there is not need to add anything to the FOllow up Date and Time');
                }
                else
                        caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
            }
            System.debug('The PST value of Follow up Date and Time value is: '+caseRecord.Follow_up_Time__c);
        }
        else if(LocalTimeZone == 'America/Anchorage'){
            if((CalculateLocalTime >= 0 && CalculateLocalTime < 11)){
                System.debug('The Follow up time is before the local time start of 8:00 AM in Alaska');
                if(GMTOffset == '-09:00')
                    NewTimeOfDay = 17 - Followuphour;
                else
                        NewTimeOfDay = 16 - Followuphour;
                if((FollowupDate == CurrentDayInGMT)){
                    if(NewTimeOfDay < 0 || NewTimeOfDay == 0)
                        System.debug('The follow up Date and Time is good AS-Is and there is not need to add anything to the FOllow up Date and Time');
                    else
                            caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
                }
            }
            else if((CalculateLocalTime < 0)){
                System.debug('The Follow up time is cannot be scheduled in the past during Alaska hours');
                if(GMTOffset == '-09:00')
                    NewTimeOfDay = 17 - Followuphour;
                else
                        NewTimeOfDay = 16 - Followuphour;
                if((FollowupDate == CurrentDayInGMT)){
                    if(NewTimeOfDay < 0 || NewTimeOfDay == 0){
                        System.debug('The follow up Date and Time is good AS-Is and there is not need to add anything to the FOllow up Date and Time');
                    }
                    else
                            caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
                }
            }
            else if((FollowupDate == CurrentDayInGMT + 1) && (Followuphour >= 5)){
                System.debug('The Follow up time is after the local time end of 8:00 PM Alaska');
                if(GMTOffset == '-09:00')
                    NewTimeOfDay = Offset + 4;
                else
                        NewTimeOfDay = Offset + 5;

                if(NewTimeOfDay < 0 || NewTimeOfDay == 0){
                    System.debug('The follow up Date and Time is good AS-Is and there is not need to add anything to the FOllow up Date and Time');
                }
                else
                        caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
            }
            System.debug('The Alaska value of Follow up Date and Time value is: '+caseRecord.Follow_up_Time__c);
        }
        else if((LocalTimeZone == 'America/Adak' || LocalTimeZone == 'Pacific/Honolulu')){
            if((CalculateLocalTime >= 0 && CalculateLocalTime < 11)){
                System.debug('The Follow up time is before the local time start of 8:00 AM in Adak/Honolulu');
                if(GMTOffset == '-10:00')
                    NewTimeOfDay = 18 - Followuphour;
                else
                        NewTimeOfDay = 17 - Followuphour;

                if((FollowupDate == CurrentDayInGMT)){
                    if(NewTimeOfDay < 0 || NewTimeOfDay == 0){
                        System.debug('The follow up Date and Time is good AS-Is and there is not need to add anything to the FOllow up Date and Time');
                    }
                    else{
                        caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
                    }
                }
            }
            else if((CalculateLocalTime < 0)){
                System.debug('The Follow up time is cannot be scheduled in the past during Adak/Honolulu hours');
                if(GMTOffset == '-10:00')
                    NewTimeOfDay = 18 - Followuphour;
                else
                        NewTimeOfDay = 17 - Followuphour;

                if(FollowupDate == CurrentDayInGMT){
                    if(NewTimeOfDay < 0 || NewTimeOfDay == 0){
                        System.debug('The follow up Date and Time is good AS-Is and there is not need to add anything to the FOllow up Date and Time');
                    }
                    else
                            caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
                }
            }
            else if((FollowupDate == CurrentDayInGMT + 1) && (Followuphour >= 6)){
                System.debug('The Follow up time is after the local time end of 8:00 PM Adak/Honolulu');
                if(GMTOffset == '-10:00')
                    NewTimeOfDay = Offset + 3;
                else
                        NewTimeOfDay = Offset + 4;
                if(NewTimeOfDay < 0 || NewTimeOfDay == 0){
                    System.debug('The follow up Date and Time is good AS-Is and there is not need to add anything to the Follow up Date and Time');
                }
                else
                        caseRecord.Follow_up_Time__c = caseRecord.Follow_up_Time__c.addhours(NewTimeOfDay);
            }
            System.debug('The Adak/Honolulu value of Follow up Date and Time value is: '+caseRecord.Follow_up_Time__c);
        }
        System.debug('**********End of Debug Logs inside the RecalculateLocalTime Method**************************');
        return caseRecord;
    }//EOM for RecalculateLocalTime method

    //When list of cases are open, capture the open age of the each case
    public List<Case> setOpenCaseAge(List<Case> openCasesList) {
/*
        for(Case caseRecord : openCasesList){
            //When case is open, capture the open age of the case
            captureCaseOpenAge(caseRecord);

        }
*/
        return openCasesList;
    }

    //When list of cases are closed, capture the closed age of the each case
    public List<Case> setClosedCaseAge(List<Case> closedCasesList) {
/*
        CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);

        Set<Id> caseIdset = new Set<Id>();

        for(Case caseRecord : closedCasesList){

            caseIdset.add(caseRecord.Id);
            System.debug('caseRecord.Id = ' + caseRecord.Id);
            //When case is open, capture the open age of the case
            //captureCaseOpenAge(caseRecord);

        }

        //Get CaseHistory list of Status field
        Map<Id, CaseHistory> caseHistoryById; // = casesSelector.selectCaseFieldHistory(caseIdset, 'Status');
        System.debug('caseHistoryById = ' + caseHistoryById);
        System.debug('caseHistoryById.size() = ' + caseHistoryById.size());

        for(Case caseRecord : closedCasesList){
            captureCaseCloseAge(caseRecord, caseHistoryById);
        }
*/
        return closedCasesList;
    }

    //When case is closed, capture the closed age of the case
    public Case captureCaseCloseAge(Case caseRecord, Map<Id, CaseHistory> caseHistoryById) {
/*
        Long dt1Long, dt2Long;
        String caseId = caseRecord.Id;
        System.debug('caseId = ' + caseId);

        CaseHistory caseHistory = caseHistoryById.get(caseId);

        System.debug('caseHistoryById = ' + caseHistoryById);
        System.debug('caseHistory = ' + caseHistory);


        if(caseHistory != null && caseHistory.NewValue == 'Outreach Completed') {

            System.debug('caseHistory.NewValue  = ' + caseHistory.NewValue );
            DateTime createdDate = caseHistory.CreatedDate;
            System.debug('createdDate  = ' + createdDate);

            dt1Long = createdDate.addDays(0).getTime();
            //Long dt1Long = caseRecord.CreatedDate.addDays(0).getTime();
            dt2Long = DateTime.now().getTime();
            dateDiffInHours(dt1Long, dt2Long);
            caseRecord.Closed_claim_age__c = days;
            if (hours <= 25) {
                caseRecord.Closed_claim_age__c = 0;
            }
        }
        */
        return caseRecord;
    }

    //When case is open, capture the open age of the case
    public Case captureCaseOpenAge(Case caseRecord) {
/*
        Long dt1Long = caseRecord.CreatedDate.addDays(0).getTime();
        Long dt2Long = DateTime.now().getTime();
        dateDiffInHours(dt1Long, dt2Long);
        caseRecord.Open_claim_age__c = days;
        if(hours <= 25) {
            caseRecord.Open_claim_age__c = 0;
        }
*/
        return caseRecord;
    }

    //When case is open, capture the open age of the case
    public Case captureCaseClosedAge(Case caseRecord) {
/*
        Long dt1Long = caseRecord.CreatedDate.addDays(0).getTime();
        Long dt2Long = DateTime.now().getTime();
        dateDiffInHours(dt1Long, dt2Long);
        caseRecord.Closed_claim_age__c = days;
        if(hours <= 25) {
            caseRecord.Closed_claim_age__c = 0;
        }
*/
        return caseRecord;
    }

    private void dateDiffInHours(Long dt1Long, Long dt2Long) {

        milliseconds = dt2Long - dt1Long;
        seconds = milliseconds / 1000;
        minutes = seconds / 60;
        hours = minutes / 60;
        days = hours / 24;

    }
}//EOC