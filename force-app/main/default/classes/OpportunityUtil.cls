public class OpportunityUtil {


    public without sharing class RunWithoutSharing
    {
         public List<Opportunity> getOpportunities(String searchKey,Set<Id> accountIds)
         {
             List<Opportunity> opportunityResults = [SELECT Id, Name, StageName, AccountId,Account.Name ,description,closedate
                                                FROM Opportunity 
                                                WHERE StageName LIKE :searchKey 
                                                    OR Account.Name LIKE :searchKey 
                                                    OR AccountId in :accountIds];
         return opportunityResults;
         }
    }

     public with sharing class RunWithSharing
    {
        public List<Opportunity> getOpportunities(String searchKey,Set<Id> accountIds)
         {
             List<Opportunity> opportunityResults = [SELECT Id, Name, StageName, AccountId,Account.Name ,description,closedate
                                                FROM Opportunity 
                                                WHERE StageName LIKE :searchKey 
                                                    OR Account.Name LIKE :searchKey 
                                                    OR AccountId in :accountIds];
         return opportunityResults;
         }
    }

  

}