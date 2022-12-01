/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 12-01-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class CTDataCleanupSchedule implements Schedulable{
  
    public static final String CRON = '0 0 2 * * ?';

    public void execute(SchedulableContext sc){
        CTPeopleTracingDataCleanupBatch peopleTracingBatch = new CTPeopleTracingDataCleanupBatch();
        Database.executeBatch(peopleTracingBatch, 2000) ;

        CTLocationTracingDataCleanupBatch locationTracingBatch = new CTLocationTracingDataCleanupBatch();
        Database.executeBatch(locationTracingBatch, 2000) ;
    }
}


/**
 * CTDataCleanupSchedule dataCleanUp = new CTDataCleanupSchedule();
//can see in Schedule job
//**sometime need check checkbox in Deployment Settings (Allow deployments of components when corresponding Apex jobs are pending or in progress)
//String jobId = System.schedule('CleanUp Data Job', CTDataCleanupSchedule.CRON, dataCleanUp);
//System.debug('Job Id: '+jobId);

//batch start immediately
dataCleanUp.execute(null);
 */
