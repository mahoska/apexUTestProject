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

    //if location's Status changes to RED
    //Mark all people Yellow who have visited the location in last 10 days - Except the Red and Orang ones
    public static void afterUpdateHandler(List<Location__c> newRecordsList, Map<Id, Location__c> oldRecordsMap) {

        if(newRecordsList !=NULL && newRecordsList.size() > 0){

            Set<Id> redStatusLocationsSet = new Set<Id>();

            for(Location__c loc : newRecordsList){
                if(loc.Status__c != oldRecordsMap.get(loc.Id).Status__c && loc.Status__c == 'Red' && oldRecordsMap.get(loc.Id).Status__c != 'Red'){
                    redStatusLocationsSet.add(loc.Id);
                }
            }

            if(redStatusLocationsSet !=NULL && redStatusLocationsSet.size() > 0){
                CTPersonController.updateRedStatusByLocation(redStatusLocationsSet);
            }
        }
        
    }
}
