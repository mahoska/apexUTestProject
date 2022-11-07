/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-07-2022
 * @last modified by  : Anna Makhovskaya
**/
trigger PersonTrigger on Person__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            PersonTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        when AFTER_INSERT {}
        when BEFORE_UPDATE {
            PersonTriggerHandler.beforeUpdateHandler(Trigger.oldMap, Trigger.new);
        }
        when AFTER_UPDATE {
            PersonTriggerHandler.afterUpdateHandler(Trigger.oldMap, Trigger.new);
        }
        when BEFORE_DELETE {}
        when AFTER_DELETE {}
        when AFTER_UNDELETE {}
    }
}