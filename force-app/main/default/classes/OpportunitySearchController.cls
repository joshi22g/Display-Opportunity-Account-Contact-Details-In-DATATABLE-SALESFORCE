public without sharing class OpportunitySearchController {
    @AuraEnabled(cacheable=true)
    public static List<OpportunityWrapper> searchOpportunities(String searchKey) {
         List<OpportunityWrapper> wrapperList = new List<OpportunityWrapper>();
        try{
        searchKey = '%' + searchKey + '%';
        List<Contact> contactResults = [SELECT Id, AccountId 
                                        FROM Contact 
                                        WHERE Name LIKE :searchKey 
                                        ];
        
        Set<Id> accountIds = new Set<Id>();
        for (Contact contact : contactResults) {
            accountIds.add(contact.AccountId);
        }
        OpportunityUtil.RunWithoutSharing objWithoutSharing= new OpportunityUtil.RunWithoutSharing();
        List<Opportunity> opportunityResults = objWithoutSharing.getOpportunities(searchKey,accountIds);
        OpportunityUtil.RunWithSharing objWithSharing= new OpportunityUtil.RunWithSharing();
        List<Opportunity> opportunityResultsUser = objWithSharing.getOpportunities(searchKey,accountIds);
        for(Opportunity oppRecord :opportunityResults)
        {
            accountIds.add(oppRecord.accountId);
        }

        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>(opportunityResults);
        Map<Id,Opportunity> opportunityMapUser = new Map<Id,Opportunity>(opportunityResultsUser);
       
        OpportunityWrapper wrapper ; 
        Map<Id,UserRecordAccess> userRecordAccessMap = new Map<Id,UserRecordAccess>();
        Boolean hasUserAccess;
        List<Account> accountDetails = new  List<Account>();
        Map<Id,OpportunityWrapper> accountContactMap = new Map<Id,OpportunityWrapper>();
        if(accountIds.size()>0)
        {
        accountDetails=[select id,name,(select id,name,phone,email from contacts order by createddate desc limit 1 ) from account where id in :accountIds];
        for(Account account: accountDetails)
        {
            if(account.contacts !=null  && account.contacts.size()>0)
            {
                wrapper= new  OpportunityWrapper();
                wrapper.contactName = account.contacts.get(0).name;
                wrapper.contactNumber = account.contacts.get(0).phone;
                wrapper.contactEmail = account.contacts.get(0).email;
                accountContactMap.put(account.Id,wrapper);
            }
        }
        }

        for(Opportunity opportunity: opportunityMap.values())
        {
            wrapper = new OpportunityWrapper();
            hasUserAccess = opportunityMapUser.containsKey(opportunity.Id);
            wrapper.Id=opportunity.Id;
            wrapper.name=hasUserAccess?opportunity.name:maskString(opportunity.name);
            wrapper.description = hasUserAccess?opportunity.description:maskString(opportunity.description);
            wrapper.accountName=hasUserAccess?opportunity.account.name:maskString(opportunity.account.name);
            wrapper.closeDate=hasUserAccess?opportunity.closedate.format():maskString(opportunity.closedate.format());
            wrapper.contactName=accountContactMap.containsKey(opportunity.accountId)?
                                hasUserAccess? accountContactMap.get(opportunity.accountId).contactName 
                                :maskString(accountContactMap.get(opportunity.accountId).contactName) : '-';
            wrapper.contactNumber=accountContactMap.containsKey(opportunity.accountId)?
                                hasUserAccess? accountContactMap.get(opportunity.accountId).contactNumber 
                                :maskString(accountContactMap.get(opportunity.accountId).contactNumber) : '-';
            
            wrapper.contactEmail=accountContactMap.containsKey(opportunity.accountId)?
                                hasUserAccess? accountContactMap.get(opportunity.accountId).contactEmail 
                                :maskString(accountContactMap.get(opportunity.accountId).contactEmail) : '-';
            wrapperList.add(wrapper);

        }
        
        }
        catch(Exception e)
        {
           throw new AuraHandledException(e.getMessage());
        }
        return wrapperList;
    }
    
     @AuraEnabled(cacheable=true)
     public static String maskString(String input) {
        if (String.isNotBlank(input) && input.length() > 3) {
            return input.substring(0, 3) + '***';
        }
        return input;
    }

   public class OpportunityWrapper{
        @AuraEnabled
           public Id id ;
           @AuraEnabled
           public String name ;
           @AuraEnabled
           public String description;
           @AuraEnabled
           public String closeDate;
           @AuraEnabled
           public String accountName;
           @AuraEnabled
           public String contactName;
           @AuraEnabled
           public String contactNumber;
           @AuraEnabled
           public String contactEmail;

    }

}