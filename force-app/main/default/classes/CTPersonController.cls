/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 10-31-2022
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
        
        List<Person__c> listPerson = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                            FROM Person__c 
                            WHERE Id = :personId];

        if(listPerson != NULL && listPerson.size() > 0){
            return listPerson[0];
        }

        return NULL;
    }

}