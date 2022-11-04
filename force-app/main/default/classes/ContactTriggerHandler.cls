/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-04-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class ContactTriggerHandler {
    
            public static void  afterInsertHandler(List<Contact> newRecords){
                
                if(newRecords != NULL && newRecords.size()>0){
                    Set<Id> accountIdsSet = AccountContactService.getAccountIdFromContact(newRecords);
                    AccountContactService.updateActiveContacts(accountIdsSet);
                }

            }

            public static void  afterUpdateHandler(List<Contact> newRecords, Map<Id, Contact> oldContactMap ){
                
                if(newRecords != NULL && newRecords.size()>0){
                    //get all account Id
                    Set<Id> accountIdsSet = new Set<Id>();
                    for(Contact con : newRecords){
                        //capture the account id only if active checkbox value is flipped
                        if(String.isNotBlank(con.AccountId) && oldContactMap.get(con.Id).Active__c != con.Active__c){
                            accountIdsSet.add(con.AccountId);
                        }else if(oldContactMap.get(con.Id).AccountId != con.AccountId){
                            accountIdsSet.add(con.AccountId);
                            accountIdsSet.add(oldContactMap.get(con.Id).AccountId);
                        }
                    }

                    AccountContactService.updateActiveContacts(accountIdsSet);
                }

            }

            public static void  afterDeleteHandler(List<Contact> oldRecords){
                
                if(oldRecords != NULL && oldRecords.size()>0){
                    Set<Id> accountIdsSet = AccountContactService.getAccountIdFromContact(oldRecords);
                    AccountContactService.updateActiveContacts(accountIdsSet);
                }

            }

            public static void  afterUndeleteHandler(List<Contact> newRecords){
                
                if(newRecords != NULL && newRecords.size()>0){
                    Set<Id> accountIdsSet = AccountContactService.getAccountIdFromContact(newRecords);
                    AccountContactService.updateActiveContacts(accountIdsSet);
                }

            }
}
