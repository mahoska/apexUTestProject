/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-07-2022
 * @last modified by  : Anna Makhovskaya
**/
trigger LocationTrigger on Location__c (before insert, after insert, before update, after update, before delete, after delete, after undelete){

    switch on Trigger.operationType{
        when BEFORE_INSERT {
            LocationTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        when AFTER_INSERT {}
        when BEFORE_UPDATE {
            LocationTriggerHandler.beforeUpdateHandler(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            LocationTriggerHandler.afterUpdateHandler(Trigger.new, Trigger.oldMap);
        }
        when BEFORE_DELETE {}
        when AFTER_DELETE {}
        when AFTER_UNDELETE {}
    }
}