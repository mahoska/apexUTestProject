/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-28-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    updateStatus: function (component) {
        const recordId = component.get("v.recordId");
        const action = component.get("c.updateHealthStatus");
        action.setParams({
            personId: recordId
        });

        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                this.showToast("Success", "Person Health Status Updated", "success");
                //----refresh page-----------
                window.location.reload();
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title,
            message,
            type
        });
        toastEvent.fire();
    }
})
