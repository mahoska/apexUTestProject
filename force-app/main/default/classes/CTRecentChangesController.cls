/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-28-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class CTRecentChangesController {

    @AuraEnabled
    public static List<Person__c> getRecentPersonHealthChanges(){
        return  CTPersonController.getRecentHealthChanges();
    }

    @AuraEnabled
    public static List<Location__c> getRecentLocationHealthChanges(){
        return  CTLocationController.getRecentStatusChanges();
    }

    @AuraEnabled
    public static List<Person__c> searchPeople(String searchTerm){
        return  CTPersonController.searchPeople(searchTerm);
    }

    @AuraEnabled
    public static List<Location__c> searchLocation(String searchTerm){
        return  CTLocationController.searchLocation(searchTerm);
    }
}
