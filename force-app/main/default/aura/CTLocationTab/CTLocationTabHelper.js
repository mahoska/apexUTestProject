/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-29-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    fetchLocationInformation: function (component) {
        const recordId = component.get("v.recordId");
        console.log("In helper--" + recordId);
        const action = component.get("c.getLocationDetails");
        action.setParams({
            "recordId": recordId
        });
        action.setCallback(this, function (response) {
            const state = response.getState();
            console.log("RESPONSE: " + state);
            if (state === "SUCCESS") {
                const resp = response.getReturnValue();
                if (!resp && !resp.name) {
                    //user not found
                    component.set("v.locationFound", false);
                    this.showToast("ERROR", "Please enter valid location id", "error");
                } else {
                    //user found
                    component.set("v.locationFound", true);
                    component.set("v.locationInfo", resp);
                }
            } else {
                component.set("v.locationFound", false);
                this.showToast("ERROR", "Please enter valid location id", "error");
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
