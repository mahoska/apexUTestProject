/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 11-07-2022
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


    public static void updateRedScore(Set<Id> locationIdsSet){

        List<Location__c> locationToUpdateList = new List<Location__c>();

        AggregateResult[] redPeoplePerLocation = [
                    SELECT Location__c, COUNT(Id) total  
                    FROM Location_Tracing__c 
                    WHERE Person__r.Health_Status__c = 'Red' AND Visit_Date__c = LAST_N_DAYS:10 AND Location__c IN :locationIdsSet
                    GROUP BY Location__c];

        for(AggregateResult ar : redPeoplePerLocation){
            String locationId = String.valueOf(ar.get('Location__c'));
            Integer redScore = Integer.valueOf(ar.get('total'));
            String status = getStatus(redScore);

            locationToUpdateList.add(new Location__c(Id=locationId, Red_Score__c=redScore, Status__c=status));
        } 
        
        if(locationToUpdateList != NUll && locationToUpdateList.size() > 0){
            update locationToUpdateList;
        }
    }


    public static String getStatus(Integer redScore){
        if(redScore == 0){
            return 'Green';
        }else if(redScore <= 5){
            return 'Yellow';
        }else if(redScore <=10){
            return 'Orange';
        }else{
            return 'Red';
        }
    }




}