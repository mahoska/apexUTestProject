/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-17-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    addResultRecord: function (component, gameResult) {
        //create apex method call action
        const action = component.get("c.addResult");
        const modeValue = component.get("v.selectedMode").toUpperCase();
        console.log('Mode: ' + modeValue);
        //set parameters
        action.setParams({
            result: gameResult.toUpperCase(),
            mode: modeValue
        });
        //define a callback
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state !== 'SUCCESS') {
                console.error("Error in saving record");
            }
        });
        //call apex method
        $A.enqueueAction(action);
    },

    showToast: function (titleValue, messageValue, typeValue) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": titleValue,
            "message": messageValue,
            "type": typeValue
        });
        toastEvent.fire();
    }
})
