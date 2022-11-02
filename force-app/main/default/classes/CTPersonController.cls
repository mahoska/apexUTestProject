/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-02-2022
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

        Blob value = Blob.valueOf('mobileNo');
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

}