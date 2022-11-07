/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-07-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class LocationTriggerHandler {
    
    public static void beforeInsertHandler(List<Location__c> newRecordsList) {
        //Make sure the location status is Green before inserting the record
        if(newRecordsList !=NULL && newRecordsList.size() > 0){
            for(Location__c loc : newRecordsList){
                loc.Status__c = 'Green';
            }
        }
    }

    public static void beforeUpdateHandler(List<Location__c> newRecordsList, Map<Id, Location__c> oldRecordsMap) {
        if(newRecordsList !=NULL && newRecordsList.size() > 0){
            //check if the status changed in this transaction
            //also update Status_Update_Date__c
            for(Location__c loc : newRecordsList){
                if(loc.Status__c != oldRecordsMap.get(loc.Id).Status__c){
                    loc.Status_Update_Date__c = Date.Today();
                }
            }
        }
    }
}
