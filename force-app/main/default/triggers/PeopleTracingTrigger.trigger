/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-07-2022
 * @last modified by  : Anna Makhovskaya
**/
trigger PeopleTracingTrigger on People_Tracing__c (before insert, after insert, before update, after update, before delete, after delete, after undelete){

    switch on Trigger.operationType{
        when BEFORE_INSERT {
            PeopleTracingTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        when AFTER_INSERT {}
        when BEFORE_UPDATE {}
        when AFTER_UPDATE {}
        when BEFORE_DELETE {}
        when AFTER_DELETE {}
        when AFTER_UNDELETE {}
    }
}