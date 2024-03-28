@isTest
public class TestDataFactory {
	public static Account createAccount(String name) {
		Account acc = new Account(name = name);
		return acc;
	}
	public static List<Contact> createContact(Account account,Integer noOfContacts) {
        List<Contact> listContacts = new List<Contact>();
        for(Integer i=0;i<noOfContacts;i++)
        {
            Contact c = new Contact(firstName = 'Test', lastName = account.name +i, accountId = account.Id);
            listContacts.add(c);
        }
		
		insert listContacts;
		return listContacts;
	}
	public static List<Opportunity> createOpportunity(Account account, Integer numOpps) {
		List<Opportunity> opps = new List<Opportunity>();
		for(Integer i = 1; i <= numOpps; i++) {
			Opportunity opp = new Opportunity();
			opp.name = 'Opportunity' + account.name + i;
			opp.accountId = account.Id;
			opp.amount = 1000;
			opp.closeDate = Date.today().addDays(5);
			opp.stageName = 'Prospecting';
			opps.add(opp);
		}
        insert opps;
		return opps;
	}
}