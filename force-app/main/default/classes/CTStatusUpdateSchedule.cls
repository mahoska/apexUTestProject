/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 12-01-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class CTStatusUpdateSchedule implements Schedulable{
  
    public static final String CRON = '0 0 3 * * ?';

    public void execute(SchedulableContext sc){
        CTUpdatePersonStatusBatch peopleStatusUpdateBatch = new CTUpdatePersonStatusBatch();
        Database.executeBatch(peopleStatusUpdateBatch, 2000) ;

        CTUpdateLocationStatusBatch locationStatusUpdateBatch = new CTUpdateLocationStatusBatch();
        Database.executeBatch(locationStatusUpdateBatch, 2000) ;
    }
}


/*CTStatusUpdateSchedule dataUpdate = new CTStatusUpdateSchedule();
//String jobId = System.schedule('UpdateStatus Job', CTStatusUpdateSchedule.CRON, dataUpdate);
//System.debug('Job Id: '+jobId);
dataUpdate.execute(null);
*/