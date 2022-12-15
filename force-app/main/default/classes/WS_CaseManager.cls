/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 12-15-2022
 * @last modified by  : Anna Makhovskaya
**/
@RestResource(urlMapping='/Cases/*')
global with sharing class WS_CaseManager {
   
    //   /services/apexrest/Cases/caseId
    @HttpGet
    global static Case getCaseById(){
        RestRequest request = RestContext.request;
        String caseId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Case result = [SELECT CaseNumber, Subject, Origin, Priority FROM Case WHERE Id = :caseId];
        return result;
    }

    @HttpPost
    global static Id createCase(String subj, String sta, String pri, String ori){
       Case thisCase = new Case(Subject = subj, Status = sta, Priority = pri, Origin = ori);
       insert thisCase;
       return thisCase.Id;
    }


    @HttpDelete
    global static void deleteCase(){
        RestRequest  request = RestContext.request;
        String caseId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Case thisCase = [SELECT Id FROM Case WHERE Id = :caseId];
        delete thisCase;
    }

    @HttpPut
    global static Id  upsertCase(String subj, String sta, String pri, String ori, String id){
        Case thisCase = new Case(Id=id, Subject=subj,Status=sta,Origin=ori, Priority=pri);
        upsert thisCase;
        return thisCase.Id;
    }

    @HttpPatch
    global static Id updateCase(){
        RestRequest  request = RestContext.request;
        String caseId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Case thisCase = [SELECT Id FROM Case WHERE Id = :caseId];
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());
        for(String fieldName : params.keySet()){
            thisCase.put(fieldName, params.get(fieldName));
        }
        update thisCase;
        return thisCase.Id;
    }
}
