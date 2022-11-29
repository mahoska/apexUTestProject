/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-29-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    locationSearchHandler: function (component, event, helper) {
        console.log("IN CONTROLLER");
        helper.fetchLocationInformation(component);
    },

    doInit: function (component, event, helper) {
        component.set('v.columns', [
            { label: 'Contact name', fieldName: 'name', type: 'text' },
            { label: 'Token', fieldName: 'token', type: 'text' },
            { label: 'Contact status', fieldName: 'status', type: 'text' },
            { label: 'Visit Day', fieldName: 'visitDate', type: 'date' },
        ]);
    }
})
