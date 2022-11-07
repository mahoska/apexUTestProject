/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-07-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class LocationTracingTriggerHandler {
    
    public static void beforeInsertHandler(List<Location_Tracing__c> newRecordsList) {

        //if duplicates found, add an error
        //if no duplicates found, add the records
        List<Location_Tracing__c> duplicates = CTLocationTracingController.checkDuplicates(newRecordsList);

        if(duplicates != NULL && duplicates.size() > 0){
            for(Location_Tracing__c trace : duplicates){
                trace.addError('Duplicate record found. Person Id: '+ trace.Person__c + ' Location Id: '+ trace.Location__c);
            }
        }
    }
}
