/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-07-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class PersonTriggerHandler {
    public static void beforeInsertHandler(List<Person__c> newRecordsList) {
        if(newRecordsList !=NULL && newRecordsList.size() > 0){
            for(Person__c person : newRecordsList){
                //update person  status to  Green
                person.Health_Status__c = 'Green';
                //generate unique token
                person.Token__c = CTPersonController.getToken(person.Mobile__c);
            }
        }
    }

    public static void beforeUpdateHandler(Map<Id,Person__c> oldRecordsMap, List<Person__c> newRecordsList ){
        if(newRecordsList !=NULL && newRecordsList.size() > 0){
            for(Person__c person : newRecordsList){
                //check if the status changed in this transaction
                //also update Status_Update_Date__c
                if(person.Health_Status__c != oldRecordsMap.get(person.Id).Health_Status__c){
                    person.Status_Update_Date__c = Date.Today();
                }
            }
        }
    }


    public static void afterUpdateHandler(Map<Id,Person__c> oldRecordsMap, List<Person__c> newRecordsList ){

        if(newRecordsList !=NULL && newRecordsList.size() > 0){
            Set<Id> statusChangeIdsSet = new  Set<Id>();
            Set<Id> redStatusIdsSet = new  Set<Id>();

            for(Person__c person : newRecordsList){

                if(person.Health_Status__c != oldRecordsMap.get(person.Id).Health_Status__c){
                    statusChangeIdsSet.add(person.Id);
                }
                if(person.Health_Status__c == 'Red' && oldRecordsMap.get(person.Id).Health_Status__c != 'Red'){
                    redStatusIdsSet.add(person.Id);
                }
            }

            List<Person__c> personToUpdateList = new List<Person__c>();

            Set<Id> orangeStatusSet = new  Set<Id>();
            Set<Id> yellowStatusSet = new  Set<Id>();

            Set<Id> alreadyProcessIdsSet = new Set<Id>();
            alreadyProcessIdsSet.addAll(redStatusIdsSet);

            //lets add cohabitans 
            orangeStatusSet.addAll(CTPersonController.getCohabitans(redStatusIdsSet, alreadyProcessIdsSet));
            //lets add primary contacts
            Set<Id> primaryContactIdsSet = CTPersonController.getPrimaryContacts(redStatusIdsSet,alreadyProcessIdsSet);
            orangeStatusSet.addAll(primaryContactIdsSet);
            //lets add neighbours
            yellowStatusSet.addAll(CTPersonController.getNeighbours(redStatusIdsSet, alreadyProcessIdsSet));
           //lets add secondary contacts
            yellowStatusSet.addAll(CTPersonController.getSecondaryContacts(primaryContactIdsSet, alreadyProcessIdsSet));

            for(Id pid : orangeStatusSet){
                personToUpdateList.add(new Person__c(Id=pid, Health_Status__c='Orange'));
            }

            for(Id pid : yellowStatusSet){
                personToUpdateList.add(new Person__c(Id=pid, Health_Status__c='Yellow'));
            }

            if(personToUpdateList.size() > 0){
                update personToUpdateList;
            }

            List<Location_Tracing__c> locationTracingList = CTLocationTracingController.getLocationsByPersonIds(statusChangeIdsSet);
            if(locationTracingList != NULL && locationTracingList.size() > 0){
                Set<Id> locationIdsSet = new Set<Id>();
                for(Location_Tracing__c lt : locationTracingList){
                    locationIdsSet.add(lt.Location__c);
                }

                CTLocationController.updateRedScore(locationIdsSet);
            }

           
        }
    }
}
