/**************************************************************************************************
 * Created By: Wise Wolves Consulting
 * Created Date:
 * Description: This class is used to parse the blob from 8x8 into individual custom fields on the Task record.
 * ****************************************Modification History************************************
 * 
 * Oct 5, 2022	Arvind Mahadevan	Included comments for this specific class.
 * 
 * 
 * 
 * *************************************************************************************************/
public class commentsActivitiesClass {
    @InvocableMethod(label='Merge Comments To Fields Activities' description='Merge information from comments to fields.')
    public static void mergeComments(List<Task> tasks){        
        try{            
            List<String> fields = new List<String>{'Call answered at:','Call ended at:','Duration of the call:','Tenant:','Agent:','Call Id:','Transaction Id:','Interaction Guid:','Terminate Reason:','Queued Time:','Direction:','Caller Name:','Caller Record Id:','Caller Phone:','ChannelName:','DirectionNextGen:'};                
            List<Task> coms = new List<Task>();
            Task com = new Task();             
            if(tasks.Size() > 0){                
                Id taskId = tasks[0].Id;                
                for(Task task: [SELECT Id, Description FROM Task WHERE Id = :taskId]){
                    com.Id = task.Id;
                    com.Type = 'Call Monitoring';
                    
                    for(String field : fields){
                        String data = '';
                        switch on field {
                            when 'Call answered at:'{
                                data = task.Description.substringAfter(field);                                
                                for(String fieldComments : fields){                                      
                                    if(data.Contains(fieldComments)){  
                                        com.Call_Answered_At__c = data.substringBefore(fieldComments);										
                                        break;
                                    }
                                }
                            }
                            when 'Duration of the call:'{
								data = task.Description.substringAfter(field);
                                for(String fieldComments : fields){                                      
                                    if(data.Contains(fieldComments)){  
                                        com.Call_Duration__c = data.substringBefore(fieldComments);										                                       
                                        break;
                                    }
                                }                                
                            }
                            when 'Call Id:'{
								data = task.Description.substringAfter(field).substringBefore(field);
                                for(String fieldComments : fields){                                      
                                    if(data.Contains(fieldComments)){  
                                        com.Call_Record_ID__c = data.substringBefore(fieldComments);										
                                        break;
                                    }
                                }                                
                            }
                            when 'Transaction Id:'{
								data = task.Description.substringAfter(field);
                                for(String fieldComments : fields){                                      
                                    if(data.Contains(fieldComments)){  
                                        com.Transaction_ID__c = data.substringBefore(fieldComments);										                                     
                                        break;
                                    }
                                }                                
                            }
                            when 'Direction:'{                                
								data = task.Description.substringAfter(field);
                                for(String fieldComments : fields){                                                                             
                                    if(data.Contains(fieldComments) && fieldComments != 'DirectionNextGen:'){                                          
                                        com.Direction__c = data.substringBefore(fieldComments);										                                                                                
                                        break;
                                    }
                                }                                
                            }
                            when 'Caller Phone:'{
								data = task.Description.substringAfter(field);
                                for(String fieldComments : fields){                                      
                                    if(data.Contains(fieldComments)){  
                                        com.Contact_Phone__c = data.substringBefore(fieldComments);										                                        
                                        break;
                                    }
                                }                                
                            }
                            //New set of code to retrieve and store Agent Name
                            when 'Agent:'{
								data = task.Description.substringAfter(field);
                                for(String fieldComments : fields){                                      
                                    if(data.Contains(fieldComments)){  
                                        com.Agent_Name__c = data.substringBefore(fieldComments);										                                        
                                        break;
                                    }
                                }                                
                            }
                            //New set of code to retrtieve and store Terminate Reason
                            when 'Terminate Reason:'{
								data = task.Description.substringAfter(field);
                                for(String fieldComments : fields){                                      
                                    if(data.Contains(fieldComments)){  
                                        com.Terminate_Reason__c = data.substringBefore(fieldComments);										                                        
                                        break;
                                    }
                                }                                
                            }
                        }
                    }                    
                    coms.add(com);
                }                                
                update coms;                
            }            
        } catch (Exception e ) {
            
        }        
    }          
}