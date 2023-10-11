@isTest
private class commentsActivitiesTest {
    @isTest static void mergeFieldsActivity(){
        List<Task> coms = new List<Task>();
        Task com = new Task();
        com.Description = 'Call answered at: Wed Jun 24 2020 16:28:35 GMT Call ended at: Wed Jun 24 2020 16:28:38 GMT Duration of the call: 00:00:03 Tenant: prudentrx19601 Agent: Pitadmin PredictiveIT Call Id: 76296 Transaction Id: 76296 Interaction Guid: int-172e71dad66-pEI9Qq8s3evyBI0JGNMAYxN4y-phone-00-prudentrx19601 Terminate Reason: completed Queued Time: 718 Direction: InboundCall Caller Phone: +14086366025 ChannelName: 18662510640 DirectionNextGen: InboundCall';
        coms.add(com);
        insert coms;
        commentsActivitiesClass.mergeComments(coms);       
    }
}