/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-29-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class CTPeopleTracingController {
    
    public static List<People_Tracing__c> getTracing(String personId) {

        return [SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, Person_2__c, Person_1__r.Health_Status__c, Person_1__r.Token__c, Person_2__r.Health_Status__c, Person_2__r.Token__c, Person_1__r.Name, Person_2__r.Name 
                FROM People_Tracing__c 
                WHERE (Person_1__c = :personId OR Person_2__c = :personId) AND Contact_Date__c = LAST_N_DAYS:30 
                ORDER BY Contact_Date__c DESC];
    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPeopleTraces) {

        //unique person Ids
        Set<Id> personIdsSet= new Set<Id>();

        for(People_Tracing__c trace : newPeopleTraces){
            personIdsSet.add(trace.Person_1__c);
            personIdsSet.add(trace.Person_2__c);
        }

        // list duplicate records
        List<People_Tracing__c> duplicatesList = new List<People_Tracing__c>();

        // map person id and set<id>
        Map<Id, Set<Id>> existingPeopleTraceMap = new Map<Id, Set<Id>>();

        //query existing records
        List<People_Tracing__c> existingPeopleTraceList = [SELECT Id, Person_1__c, Person_2__c 
                                                            FROM People_Tracing__c 
                                                            WHERE Person_1__c IN :personIdsSet OR Person_2__c IN :personIdsSet];

        if(existingPeopleTraceList != NULL && existingPeopleTraceList.size() > 0){                                                
            for(People_Tracing__c trace : existingPeopleTraceList){
                if(!existingPeopleTraceMap.containsKey(trace.Person_1__c)){
                    existingPeopleTraceMap.put(trace.Person_1__c, new Set<Id>());
                }
                existingPeopleTraceMap.get(trace.Person_1__c).add(trace.Person_2__c);

                // build map for person 2
                if(!existingPeopleTraceMap.containsKey(trace.Person_2__c)){
                    existingPeopleTraceMap.put(trace.Person_2__c, new Set<Id>());
                }
                existingPeopleTraceMap.get(trace.Person_2__c).add(trace.Person_1__c);
            }

            //loop over existing records to find duplicates
            for(People_Tracing__c trace : newPeopleTraces){
                //check duplicates in map
                if(
                    (existingPeopleTraceMap.containsKey(trace.Person_1__c) && existingPeopleTraceMap.get(trace.Person_1__c).contains(trace.Person_2__c))
                    || 
                    (existingPeopleTraceMap.containsKey(trace.Person_2__c) && existingPeopleTraceMap.get(trace.Person_2__c).contains(trace.Person_1__c))
                ){
                    duplicatesList.add(trace);
                }
            }
        }

        return duplicatesList;
    }


    
}