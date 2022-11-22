/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-22-2022
 * @last modified by  : Anna Makhovskaya
**/
({
    fetchStatusCount: function (component, scope) {

        var action = scope === 'person' ? component.get("c.getPersonHealthStatusCount") : component.get("c.getLocationHealthStatusCount");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let healthStatusMap = [];
                let respHealthStatusMap = response.getReturnValue();
                for (let key in respHealthStatusMap) {
                    healthStatusMap.push({ value: respHealthStatusMap[key], key: key });
                }
                component.set("v.healthStatusMap", healthStatusMap);
                component.set("v.showStatus", true);
            }
        });
        $A.enqueueAction(action);
    }
})
