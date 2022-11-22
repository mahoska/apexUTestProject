/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-22-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    tabSelectHandler: function (component, event, helper) {
        const selectedTabId = event.getParam("id");
        if (selectedTabId === 'person') {
            component.set("v.headerTitle", "Person View");
        } else if (selectedTabId === 'location') {
            component.set("v.headerTitle", "Location View");
        }
        component.set("v.scope", selectedTabId);
    }
})
