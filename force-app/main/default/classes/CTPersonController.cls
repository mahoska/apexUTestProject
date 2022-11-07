/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-07-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class CTPersonController {

    /**
    * generate unique token using mobile number
    * use md5 algorithm to generate one-way hash
    * @param mobile
    * @return string token
    */
    public static String getToken(String mobileNo) {

        Blob value = Blob.valueOf(mobileNo);
        Blob hash = Crypto.generateDigest('MD5', value);

        //get the string value of hash blob
        return EncodingUtil.base64Encode(hash);
    }

    /**
     * get 100 contacts with recent health status change
     * @return   List<Person__c>
     */ 
    public static List<Person__c> getRecentHealthChanges(){
        
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                            FROM Person__c 
                            ORDER BY Status_Update_Date__c DESC 
                            LIMIT 100];
    }

    /**
     * search a person by name, token or mobile 
     * @param  String searchTerm
     * @return  List<Person__c>
     */ 
    public static List<Person__c> searchPeople(String searchTerm){
        
        searchTerm = searchTerm + '%';

        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                            FROM Person__c 
                            WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm
                            ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    /**
     * search a person by Id
     * @param  String personId
     * @return  Person__c
     */ 
    public static Person__c getPersonById(String personId){
        
        List<Person__c> personList = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                            FROM Person__c 
                            WHERE Id = :personId];

        if(personList != NULL && personList.size() > 0){
            return personList[0];
        }

        return NULL;
    }

    /**
     * get count of people in each Health Status
     * @return  Map<String, Integer>
     */ 
    public static Map<String, Integer> getHealthStatusCount(){ 

        Map<String, Integer> peopleByStatusMap = new Map<String, Integer>();

        for(AggregateResult agrRes : [SELECT  Health_Status__c, COUNT(Id) countPeopleByStatus FROM Person__c GROUP BY Health_Status__c]){
            peopleByStatusMap.put(String.valueOf(agrRes.get('Health_Status__c')),Integer.valueOf(agrRes.get('countPeopleByStatus')));
        }

        return peopleByStatusMap;
    }

    /*
    //template previous version
    public static Set<Id> getCohabitans(Set<Id> personIdsSet, Set<Id> alreadyProcessIdsSet){
        List<String> healthStatusList = new List<String>{'Green', 'Yellow'};
        List<People_Tracing__c> peopleTracingList =  
                    [SELECT Id, Person_1__c, Person_2__c 
                    FROM People_Tracing__c 
                    WHERE (Person_1__c IN :personIdsSet OR Person_2__c IN :personIdsSet) AND
                    Contact_Type__c = 'Cohabitant' AND
                    (Person_1__r.Health_Status__c IN :healthStatusList OR Person_2__r.Health_Status__c IN :healthStatusList)];

        Set<Id> cohabitantsSet = new Set<Id>();
        for(People_Tracing__c pt : peopleTracingList)  {
            if(!alreadyProcessIdsSet.contains(pt.Person_1__c)){
                cohabitantsSet.add(pt.Person_1__c);
                alreadyProcessIdsSet.add(pt.Person_1__c);
            }
            if(!alreadyProcessIdsSet.contains(pt.Person_2__c)){
                cohabitantsSet.add(pt.Person_2__c);
                alreadyProcessIdsSet.add(pt.Person_2__c);
            }
        }
        return cohabitantsSet;
    }*/

    public static Set<Id> getCohabitans(Set<Id> personIdsSet, Set<Id> alreadyProcessIdsSet){
        List<String> healthStatusList = new List<String>{'Green', 'Yellow'};
        List<People_Tracing__c> peopleTracingList = CTPersonHelper.getContactsByTypeList(healthStatusList, personIdsSet, 'Cohabitant', FALSE);

        Set<Id> cohabitantsSet = CTPersonHelper.getContactsByTypeSet(peopleTracingList, alreadyProcessIdsSet);  
        return cohabitantsSet;
    }

    public static Set<Id> getNeighbours(Set<Id> personIdsSet, Set<Id> alreadyProcessIdsSet){
        List<String> healthStatusList = new List<String>{'Green'};
        List<People_Tracing__c> peopleTracingList = CTPersonHelper.getContactsByTypeList(healthStatusList, personIdsSet, 'Neighbour', FALSE);

        Set<Id> neighboursSet = CTPersonHelper.getContactsByTypeSet(peopleTracingList, alreadyProcessIdsSet);  
        return neighboursSet;
    }

    public static Set<Id> getPrimaryContacts(Set<Id> personIdsSet, Set<Id> alreadyProcessIdsSet){
        List<String> healthStatusList = new List<String>{'Green', 'Yellow'};
        List<People_Tracing__c> peopleTracingList = CTPersonHelper.getContactsByTypeList(healthStatusList, personIdsSet, 'Other', TRUE);

        Set<Id> primaryContactsSet = CTPersonHelper.getContactsByTypeSet(peopleTracingList, alreadyProcessIdsSet);
        return primaryContactsSet;
    }

    public static Set<Id> getSecondaryContacts(Set<Id> primaryContactIdsSet, Set<Id> alreadyProcessIdsSet){
        List<String> healthStatusList = new List<String>{'Green'};
        List<People_Tracing__c> peopleTracingList = CTPersonHelper.getContactsByTypeList(healthStatusList, primaryContactIdsSet, 'Other', TRUE);
         
        Set<Id> secondaryContactsSet = CTPersonHelper.getContactsByTypeSet(peopleTracingList, alreadyProcessIdsSet);
        return secondaryContactsSet;
    }


    public static void updateRedStatusByLocation(Set<Id> locationIdsSet){

        List<Person__c> personToUpdateList = new List<Person__c>();

        List<Location_Tracing__c> locationTracingList = CTLocationTracingController.getPeopleByRedLocation(locationIdsSet);

        for(Location_Tracing__c lt : locationTracingList){
            personToUpdateList.add(new Person__c(Id=lt.Person__c, Health_Status__c='Yellow'));
        } 
        
        if(personToUpdateList != NUll && personToUpdateList.size() > 0){
            update personToUpdateList;
        }
    }

}