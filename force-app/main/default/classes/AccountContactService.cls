/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-04-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class AccountContactService {
    
    public static void updateActiveContacts(Set<Id> accountIdsSet) {
        //build final list of account for update
        Map<Id, Account> updAccountMap = new Map<Id,Account>();

        for(AggregateResult res : [SELECT COUNT(Id) actContacts, AccountId FROM Contact WHERE Active__c = TRUE  AND AccountId IN : accountIdsSet GROUP BY AccountId ]){
            //get account id and number of active contacts for it
            String accId = String.valueOf(res.get('AccountId'));
            Integer actContacts = Integer.valueOf(res.get('actContacts'));
            //make sure that we used Id field in our account to update it
            Account acc = new Account(Id=accId, ActiveContacts__c=actContacts);
            updAccountMap.put(accId, acc);
        }

        //update account with zero active account
        for(Id accId : accountIdsSet){
            if(!updAccountMap.containsKey(accId)){
                Account acc = new Account(Id=accId, ActiveContacts__c=0);
                updAccountMap.put(accId, acc);
            }
        }

        update updAccountMap.values();
    }

    public static Set<Id> getAccountIdFromContact(List<Contact> contactsList){
        //get all account Id
        Set<Id> accountIdsSet = new Set<Id>();
        for(Contact con : contactsList){
            if(String.isNotBlank(con.AccountId)){
                accountIdsSet.add(con.AccountId);
            }
        }

        return accountIdsSet;
    }
}
