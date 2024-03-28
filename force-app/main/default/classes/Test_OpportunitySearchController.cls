@isTest
public class Test_OpportunitySearchController {
     @testSetup static void setup() {
     Account account = TestDataFactory.createAccount('testAccount1');
     TestDataFactory.createContact(account,5);
     TestDataFactory.createOpportunity(account,2);
     }

     @isTest static void testSystemContext() {
        List<OpportunitySearchController.OpportunityWrapper> wrapperReturned=  OpportunitySearchController.searchOpportunities('test');
         Integer maskedCount =0;
         Integer unmaskedCount=0;
         for(OpportunitySearchController.OpportunityWrapper wrapper:wrapperReturned)
         {
             if(wrapper.name.contains('**'))
             {
                 maskedCount++;
             }
             else
             {
                 unmaskedCount++;
             }
         }
         Assert.areEqual(0,maskedCount , 'No masked records to be displayed as user has access to all records');
     	 Assert.areEqual(2,unmaskedCount , 'All records should be visible to user as user is owner of records and are unmasked ');
     	 
     }
      @isTest static void testUserContext() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.salesforce');
			insert u;
        	System.runAs(u) {
            PermissionSet ps = [SELECT Id 
                    FROM PermissionSet 
                    WHERE Name = 'Custom_Opportunity_Search_Access'];
			insert new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id);
             Account account = TestDataFactory.createAccount('testAccount5');
             TestDataFactory.createContact(account,1);
             TestDataFactory.createOpportunity(account,1);
               List<OpportunitySearchController.OpportunityWrapper> wrapperReturned=  OpportunitySearchController.searchOpportunities('test');
       	     Integer maskedCount =0;
         Integer unmaskedCount=0;
         for(OpportunitySearchController.OpportunityWrapper wrapper:wrapperReturned)
         {
             if(wrapper.name.contains('**'))
             {
                 maskedCount++;
             }
             else
             {
                 unmaskedCount++;
             }
         }
         Assert.areEqual(2,maskedCount , '2 masked records to be displayed as user doesnt have access to these records ');
     	 Assert.areEqual(1,unmaskedCount , '1 unmasked records to be displayed as user created one record and have access ');
     	
        }
         }

}