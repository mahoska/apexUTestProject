/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-07-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class PeopleTracingTriggerHandler {
    
    public static void beforeInsertHandler(List<People_Tracing__c> newRecordsList) {

        //if duplicates found, add an error
        //if no duplicates found, add the records
        List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(newRecordsList);

        if(duplicates != NULL && duplicates.size() > 0){
            for(People_Tracing__c trace : duplicates){
                trace.addError('Duplicate record found. Person 1: '+ trace.Person_1__c + ' Person 2: '+ trace.Person_2__c);
            }
        }
    }
}
