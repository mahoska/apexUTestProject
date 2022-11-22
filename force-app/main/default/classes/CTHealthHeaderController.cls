/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-22-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class CTHealthHeaderController {
    @AuraEnabled
    public static Map<String, Integer> getPersonHealthStatusCount(){
        return CTPersonController.getHealthStatusCount();
    }

    @AuraEnabled
    public static Map<String, Integer> getLocationHealthStatusCount(){
        return CTLocationController.getStatusCount();
    }
}
