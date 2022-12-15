/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 12-07-2022
 * @last modified by  : Anna Makhovskaya
**/
global with sharing class YoutubeVideoDetails {
//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

    webservice static void details(String videoId, String recId){
        String enckey = Youtube_API_Setting__c.getInstance('Youtube API Key').Value__c;
        System.debug('enckey: '+ enckey);
        String endpt = Youtube_API_Setting__c.getInstance('YouTube Endpoints').Value__c;
        System.debug('endpt: '+ endpt);
        endpt = endpt.replace('{API_KEY}', enckey);
        endpt = endpt.replace('{VIDEO_ID}', videoId);
        System.debug('endpt: '+ endpt);

        HttpRequest httpReq=new HttpRequest();
        Http http=new Http();
        HttpResponse httpRes=new HttpResponse();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(endpt);
        httpRes=http.send(httpReq);
        System.debug('httpRes '+httpRes);
        JsonParser j=(JsonParser)JSON.deserialize(httpRes.getBody(),  JsonParser.class );
        System.debug(j);

        Youtube_Video_Detail__c yv = new Youtube_Video_Detail__c();
        yv.Id = recId;
        yv.Number_of_View_Counts__c = j.items[0].Statistics.viewCount;
        yv.Number_of_Likes__c = j.items[0].Statistics.likeCount;
        yv.Number_of_Dislikes__c = j.items[0].Statistics.dislikeCount;
        yv.Number_of_Comments__c = j.items[0].Statistics.commentCount;
        update yv;
    }

    public class JsonParser {
        public String kind;
      public String etag;
      public List<Items> items;
      public PageInfo pageInfo;
      
    }
    
      public class PageInfo {
        public Integer totalResults;
        public Integer resultsPerPage;
      }
    
      public class Items {
        public String kind;
        public String etag;
        public String id;
        public Statistics statistics;
      }
    
      public class Statistics {
        public String viewCount;
        public String likeCount;
        public String dislikeCount;
        public String favoriteCount;
        public String commentCount;
      }
    

}