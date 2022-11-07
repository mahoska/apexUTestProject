/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-07-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class CTLocationTracingController {

    /**
      * get last 30 days visitors
      * @param  String locationId
      * @return  List<Location_Tracing__c>
      */
    public static List<Location_Tracing__c> getVisitors(String locationId) {

        return [SELECT Id, Name, Location__c, Person__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c 
                FROM Location_Tracing__c 
                WHERE Location__c = :locationId 
                ORDER BY Visit_Date__c DESC NULLS LAST];
    }

    /**
      * get all visitor ids for visitors
      * @param  Set<Id> personIds 
      * @return  List<Location_Tracing__c>
      */
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds) {
        
        return [SELECT Id, Name, Location__c, Person__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c  
                FROM Location_Tracing__c 
                WHERE Person__c IN :personIds AND Visit_Date__c = LAST_N_DAYS:10 
                ORDER BY Visit_Date__c DESC NULLS LAST];
    }

     /**
      * get all visitor ids for locations
      * @param  Set<Id> locationIds 
      * @return  List<Location_Tracing__c>
      */ 
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds) {
        
        return [SELECT Id, Name, Location__c, Person__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c  
                FROM Location_Tracing__c 
                WHERE Location__c IN :locationIds AND Person__r.Health_Status__c = 'Green' AND Visit_Date__c = LAST_N_DAYS:10 
                ORDER BY Visit_Date__c DESC NULLS LAST];
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){

        //store unique location ids
        Set<Id> locationIdsSet = new Set<Id>();
        //store unique person ids
        Set<Id> personIdsSet = new Set<Id>();

        for(Location_Tracing__c trace : newLocationTraces) {
            locationIdsSet.add(trace.Location__c);
            personIdsSet.add(trace.Person__c);
        }

        //query existing location tracing records
        List<Location_Tracing__c> existLocationTraces = 
                [SELECT Id, Name, Location__c, Person__c  
                FROM Location_Tracing__c 
                WHERE Location__c IN :locationIdsSet AND Person__c IN :personIdsSet];

        //list of duplicate records        
        List<Location_Tracing__c> duplicatesList = new List<Location_Tracing__c>();        

        //map of location Id, set of person Ids
        Map<Id, Set<Id>> exTracesMap = new  Map<Id, Set<Id>>();        

        if(existLocationTraces != NULL && existLocationTraces.size()>0){
            for(Location_Tracing__c trace : existLocationTraces) {
                if(!exTracesMap.containsKey(trace.Location__c)){
                    exTracesMap.put(trace.Location__c, new Set<Id>());
                }
                //add person ids to map set
                exTracesMap.get(trace.Location__c).add(trace.Person__c);
            }

            //loop over new location tracing records
            for(Location_Tracing__c trace : newLocationTraces) {
                //first check for location id
                //if item found in map, then check for person in set    
                if (exTracesMap.containsKey(trace.Location__c) && exTracesMap.get(trace.Location__c).contains(trace.Person__c)){
                    duplicatesList.add(trace);
                }
            } 

        }   
        
        return duplicatesList;      
    }


    public static List<Location_Tracing__c> getPeopleByRedLocation (Set<Id> locationIdsSet){
        return [
            SELECT Person__c
            FROM Location_Tracing__c 
            WHERE Location__r.Status__c = 'Red' AND Visit_Date__c = LAST_N_DAYS:10 AND Location__c IN :locationIdsSet 
            AND Person__r.Health_Status__c = 'Green'
        ];

    }
}