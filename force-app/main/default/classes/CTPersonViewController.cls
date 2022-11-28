/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-28-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class CTPersonViewController {
    @AuraEnabled
    public static void updateHealthStatus(String personId){
        Person__c person = new Person__c(Id=personId);
        person.Health_Status__c = 'Red';
        update person;
    }
}
