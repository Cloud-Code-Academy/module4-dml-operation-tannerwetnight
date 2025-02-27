/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Tanner Wetnight
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account account = new Account();
        // Set some fields on the Account
        account.name = 'Account' + Math.random();
        // Insert the Account into the database
        insert(account);
        // Return the Id of the newly created Account
        return account.id ;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account newAccount = new Account( name = name, industry = industry);
        // Insert the Account
        insert(newAccount);
    }
   
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact contact = new Contact();
        // Set some fields on the Contact
        // Set the AccountId field to the given accountId
        contact.LastName = 'booker';
        contact.AccountId = accountId;
        // Insert the Contact into the database
        insert contact;
        // Return the Id of the newly created Contact
        return contact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        Contact contact = [SELECT Id 
                           FROM Contact
                           WHERE Id = :contactId];
        // Update the Contact's last name
        contact.LastName = newLastName;
        // Update the Contact in the database
        update(contact);
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        Opportunity oppty = [SELECT Id
                             FROM Opportunity
                             WHERE Id = :oppId
        ];
        // Update the Opportunity's stage
        oppty.StageName = newStage;
        // Update the Opportunity in the database
        update(oppty);
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        Account acc = [SELECT Id
                       FROM Account
                       WHERE Id = :accountId];
        // Update the Account with the given Id with the new name and industry
        acc.Name = newName;
        acc.Industry = newIndustry;

        update(acc);
        //Is there a way to update the accounts field values with the "update" constructor?
        
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
        for(Opportunity oppty : opportunities) {
            // Set the Opportunity's Stage to Qualification
            oppty.StageName = 'Qualification';
            // Set the Opportunity's Close Date to 3 months from today
            oppty.CloseDate = System.today().addMonths(3);
            // Set the Opportunity's Amount to 50000
            oppty.Amount = 50000;
        }
        // Upsert the opportunities List so that records are either updated or created
        upsert(opportunities);
    }

    /**
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * HINT: There should not be duplicate opportunites based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        /*Need to Upsert a list of opportunities
          >Those opportunities need to be associated with a new account named after the accountName string - account needs to be created first
          >one opp for each name in list
          /no dupes, so possibly a set here
        */
        Account newAcc = new Account(Name = accountName);
        upsert(newAcc);
        List<Opportunity> oppsList = new List<Opportunity>();



        // Loop through each Opportunity name
        for (String oppName : oppNames) {
            // Create an Opportunity with the given name
            Opportunity newOpp = new Opportunity();
            newOpp.AccountId = newAcc.Id;
            newOpp.Name = oppname;
            newOpp.StageName = 'Prospecting';
            newOpp.CloseDate = system.today().addmonths(5);
            // Add the Opportunity to the list
            oppsList.add(newOpp);
        }
        upsert(oppsList);

    }//If you are interested in the absolute embarrasment of code I wrote the day before this^ feel free to reach out
    //I dont mind embarrassing myself for a lugh, lol

    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];
        Account accToUpsert;
		// if the Account exists, update the description
        if( accounts.size() > 0) {
            accToUpsert = accounts[0];
            accToUpsert.Description = 'Updated Account';
        }else {
		// otherwise, create a new Account and set the description
            accToUpsert = new Account();
            accToUpsert.Name = accountName;
            accToUpsert.Description = 'New Account';
            
        }
		// Upsert the Account
        upsert(accToUpsert);
		return accToUpsert;
	}

     /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
        /*for each (loop) CONTACT in the list, get the corresponding account name that matches the last name of the contact
          Upsert the account with the proper contact relation
        */

        List<Account> accList = new List<Account>();

		// Loop through each Contact
        for (Contact contact : contactsToUpsert) {
		// Get the account based on the name or create one if it doesn't exist
                Account newAcc = upsertAccount(contact.LastName);
                contact.AccountId = newAcc.Id;
		// Link the Contact to its Account using the Account Id
            accList.add(newAcc);
		// Upsert the Contacts
        
	    }
        upsert(contactsToUpsert);
    }

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        List<Lead> leads = new List<Lead>();
        // Loop through each Lead name
        for(String leadName : leadNames) {
            Lead newLead = new Lead();
            newLead.LastName = leadName;
            newLead.Company = 'Cloud Code';
            leads.add(newLead);
        }
        // Insert the Leads
            insert(leads);
        // Delete the Leads
            delete(leads);
        
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
       
        List<Case> cases = new List<Case>();

        for (Integer i = 0; i <= numOfCases; i++) {
            Case newCase = new Case();
            newCase.AccountId = accountId;
            cases.add(newCase);
        }
       
        // Insert the cases
        insert(cases);
        // Delete the cases
        delete(cases);
    }
}