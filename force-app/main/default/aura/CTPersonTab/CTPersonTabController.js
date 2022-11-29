/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-29-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    userSearchHandler: function (component, event, helper) {
        helper.fetchUserInformation(component);
    },

    doInit: function (component, event, helper) {
        component.set('v.columns', [
            { label: 'Name', fieldName: 'name', type: 'text' },
            { label: 'Token', fieldName: 'token', type: 'text' },
            { label: 'Status', fieldName: 'status', type: 'text' },
            { label: 'Contact Day', fieldName: 'contactDate', type: 'date' },
        ]);
    }
})
