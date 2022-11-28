/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-28-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    locationSelectHandler: function (component, event, helper) {
        const recordId = event.getParam("recordId");
        const status = event.getParam("status");
        component.set("v.recordId", recordId);
        component.set("v.status", status);
    }
})
