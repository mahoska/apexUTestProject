/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-29-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    fetchUserInformation: function (component) {
        console.log("In helper");
        const recordId = component.get("v.recordId");
        console.log("In helper--" + recordId);
        const action = component.get("c.getPersonDetails");
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
                    component.set("v.userFound", false);
                    this.showToast("ERROR", "Please enter valid use id", "error");
                } else {
                    //user found
                    component.set("v.userFound", true);
                    component.set("v.userInfo", resp);
                    console.log("RESP--: " + resp);
                }
            } else {
                component.set("v.userFound", false);
                this.showToast("ERROR", "Please enter valid use id", "error");
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
