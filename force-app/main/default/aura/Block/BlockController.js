/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-15-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    blockClickHandler: function (component, event, helper) {
        const open = component.get("v.open");
        if (open === false) {
            component.set("v.open", true);
        }
    }
})
