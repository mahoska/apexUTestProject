/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-16-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    blockClickHandler: function (component, event, helper) {
        const open = component.get("v.open");
        if (open === false) {
            component.set("v.open", true);
            //get label value
            let label = component.get('v.label');
            //fire the block event
            let compEvent = component.getEvent("onclick");
            compEvent.setParams({ value: label });
            compEvent.fire();
        }
    },

    scriptsLoaded: function (component, event, helper) {
        console.log('Library Loaded!!!');
        const divElement = component.getElement(".board-block");
        fitText(divElement);
    }
})
