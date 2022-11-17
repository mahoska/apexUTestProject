/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-17-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class Game_BoardPanelController {
    @AuraEnabled
    public static String addResult(String result, String mode){
       Word_Shiffle__c gameResult = new Word_Shiffle__c(Result__c = result, Mode__c = mode);
       insert gameResult;
       return 'success';
    }
}
