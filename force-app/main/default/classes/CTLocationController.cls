/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-02-2022
 * @last modified by  : Anna Makhovskaya
**/
public with sharing class CTLocationController {

    /**
     * get 100 locations with recent  status change
     * @return   List<Location__c>
     */ 
    public static List<Location__c> getRecentStatusChanges() {

        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status__c, Status_Update_Date__c 
                FROM Location__c
                ORDER BY Status_Update_Date__c DESC NULLS LAST
                LIMIT 100];
    }

    /**
     * search a location by name, zipcode or address
     * @param  String searchTerm 
     * @return  List<Location__c> 
     */ 
    public static List<Location__c> searchLocation(String searchTerm) {

        searchTerm = searchTerm + '%';
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status__c, Status_Update_Date__c 
                FROM Location__c
                WHERE Name LIKE :searchTerm OR Pincode__c LIKE :searchTerm OR Address__c LIKE :searchTerm 
                ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    /**
     * search a location by Id
     * @param  String locationId 
     * @return  Location__c 
     */ 
    public static Location__c getLocationById(String locationId) {

        List<Location__c> locationList =  [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status__c, Status_Update_Date__c 
                FROM Location__c
                WHERE Id = :locationId];
                
        if(locationList != NULL && locationList.size() > 0){
            return locationList[0];
        }
        return NULL;
    }

     /**
     * get count of location in each  Status
     * @return  Map<String, Integer>
     */ 
    public static Map<String, Integer> getStatusCount(){ 

        Map<String, Integer> locationByStatusMap = new Map<String, Integer>();

        for(AggregateResult agrRes : [SELECT  Status__c, COUNT(Id) countLocationByStatus FROM Location__c GROUP BY Status__c]){
            locationByStatusMap.put(String.valueOf(agrRes.get('Status__c')),Integer.valueOf(agrRes.get('countLocationByStatus')));
        }

        return locationByStatusMap;
    }


}