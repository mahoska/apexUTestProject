/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-07-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class CTPersonHelper {

    public static List<People_Tracing__c> getContactsByTypeList(List<String> healthStatusList, Set<Id> personIdsSet, String contactType, Boolean last10Days) {
        
        String query = 'SELECT Id, Person_1__c, Person_2__c '+
                    'FROM People_Tracing__c  '+
                    'WHERE (Person_1__c IN :personIdsSet OR Person_2__c IN :personIdsSet) AND '+
                    'Contact_Type__c = :contactType  ';
        if(last10Days == TRUE){
            query += 'AND Contact_Date__c = LAST_N_DAYS:10 ';
        }
        query +='AND (Person_1__r.Health_Status__c IN :healthStatusList OR Person_2__r.Health_Status__c IN :healthStatusList)';
        
        List<People_Tracing__c> peopleTracingList =  Database.query(query);

        return peopleTracingList;
    }


    public static Set<Id> getContactsByTypeSet(List<People_Tracing__c> peopleTracingList, Set<Id> alreadyProcessIdsSet){

        Set<Id> contactsByTypeSet = new Set<Id>();
        for(People_Tracing__c pt : peopleTracingList)  {
            if(!alreadyProcessIdsSet.contains(pt.Person_1__c)){
                contactsByTypeSet.add(pt.Person_1__c);
                alreadyProcessIdsSet.add(pt.Person_1__c);
            }
            if(!alreadyProcessIdsSet.contains(pt.Person_2__c)){
                contactsByTypeSet.add(pt.Person_2__c);
                alreadyProcessIdsSet.add(pt.Person_2__c);
            }
        }   
        
        return contactsByTypeSet;
    }

}
