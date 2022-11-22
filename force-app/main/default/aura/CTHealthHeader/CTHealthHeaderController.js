/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-22-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    doInit: function (component, event, helper) {
        const scope = component.get("v.scope");
        helper.fetchStatusCount(component, scope);
    },

    createRecord: function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        const scope = component.get("v.scope");
        createRecordEvent.setParams({
            "entityApiName": scope === "person" ? "Person__c" : "Location__c"
        });
        createRecordEvent.fire();
    }
})
