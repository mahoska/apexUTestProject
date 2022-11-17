/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-17-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    fetchResult: function (component) {
        const action = component.get("c.getResults");
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === 'SUCCESS') {
                const resp = response.getReturnValue();
                component.set("v.data", resp);
            }
        });
        $A.enqueueAction(action);
    }
})
