/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-17-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class Game_GameResultController {
    @AuraEnabled
    public static List<Word_Shiffle__c> getResults(){
        //get current user Id
        String userId = UserInfo.getUserId();
        List<Word_Shiffle__c> results = [SELECT Id, Mode__c, Result__c, Name, CreatedDate 
            FROM Word_Shiffle__c 
            WHERE CreatedById = :userId 
            ORDER BY CreatedDate DESC];

            return results;
    }
}
