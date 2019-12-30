/**
 * @author Rémi Le Guin
 * @date 20/12/2019
 * @description Test class for the handler class for the form response sending on case creation whithin the Service package.
 */
@IsTest
private class Core_SirenFormattingHandler_Test {

    /**
     * @description Data setup for the test class.
     */
    @TestSetup
    private static void setup() {
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1][0].Id;
        Id coreAdministratorPermissionId = [SELECT Id FROM PermissionSet WHERE Name = 'Core_Administrator' LIMIT 1][0].Id;

        User authorizedUser = (User)TDF.createSObject('User', new Map<String,Object> {
            'FirstName' => 'Authorized',
            'LastName' => 'User',
            'Alias' => 'auth',
            'Email' => 'authorizeduser@coresirenformattinghandler.fr',
            'Username' => 'authorizeduser@coresirenformattinghandler.fr',
            'CommunityNickname' => 'authorizeduser',
            'ProfileId' => profileId
        });
        insert new PermissionSetAssignment (PermissionSetId = coreAdministratorPermissionId, AssigneeId = authorizedUser.Id);

        System.runAs(authorizedUser) {
            List<Account> accounts = new List<Account> ();
            for (Integer i = 0; i <= 75; i++) {
                String index = String.valueOf(i).leftPad(3, '0');
                accounts.add((Account)TDF.createSObject('Account', new Map<String, Object> {
                    'Name' => 'Updated' + index,
                    'Siren__c' => '000-111-' + index
                }, false));
            }
            for (Integer i = 76; i <= 150; i++) {
                String index = String.valueOf(i).leftPad(3, '0');
                accounts.add((Account)TDF.createSObject('Account', new Map<String, Object> {
                    'Name' => 'Updated' + index,
                    'Siren__c' => '000 111 ' + index
                }, false));
            }
            for (Integer i = 151; i <= 225; i++) {
                String index = String.valueOf(i).leftPad(3, '0');
                accounts.add((Account)TDF.createSObject('Account', new Map<String, Object> {
                    'Name' => 'Updated' + index,
                    'Siren__c' => '000111' + index
                }, false));
            }
            insert accounts;
        }
    }

    /**
     * @description Test the formatSiren method when creating Accounts.
     */
    @IsTest
    private static void formatSiren_InsertTest() {
        List<Account> accounts = new List<Account> ();
        for (Integer i = 0; i <= 75; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            accounts.add((Account)TDF.createSObject('Account', new Map<String, Object> {
                'Name' => 'Inserted' + index,
                'Siren__c' => '000-000-' + index
            }, false));
        }
        for (Integer i = 76; i <= 150; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            accounts.add((Account)TDF.createSObject('Account', new Map<String, Object> {
                'Name' => 'Inserted' + index,
                'Siren__c' => '000 000 ' + index
            }, false));
        }
        for (Integer i = 151; i <= 225; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            accounts.add((Account)TDF.createSObject('Account', new Map<String, Object> {
                'Name' => 'Inserted' + index,
                'Siren__c' => '000000' + index
            }, false));
        }
        User authorizedUser = [SELECT Id FROM User WHERE Username = 'authorizeduser@coresirenformattinghandler.fr' LIMIT 1];

        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'FormatSirenInsert' }, 'Account');
        System.runAs(authorizedUser) {
            insert accounts;
        }
        Test.stopTest();

        accounts = [SELECT Siren__c FROM Account WHERE Name LIKE 'Inserted%' ORDER BY Siren__c];
        for (Integer i = 1; i <= 225; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            System.assertEquals('000000' + index, accounts[i].Siren__c, 'Siren is not formatted');
        }
    }

    /**
     * @description Test the formatSiren method when editing Accounts.
     */
    @IsTest
    private static void formatSiren_UpdateTest() {
        List<Account> accounts = [SELECT Siren__c FROM Account WHERE Name LIKE 'Updated%' ORDER BY Siren__c];
        for (Account acc : accounts) {
            acc.Siren__c = acc.Siren__c.replaceFirst('000', '111');
        }
        User authorizedUser = [SELECT Id FROM User WHERE Username = 'authorizeduser@coresirenformattinghandler.fr' LIMIT 1];

        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'FormatSirenUpdate' }, 'Account');
        System.runAs(authorizedUser) {
            update accounts;
        }
        Test.stopTest();

        accounts = [SELECT Siren__c FROM Account WHERE Name LIKE 'Updated%' ORDER BY Siren__c];
        for (Integer i = 1; i <= 225; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            System.assertEquals('111111' + index, accounts[i].Siren__c, 'Siren is not formatted');
        }
    }

    /**
     * @description Test the call of a non-existing method.
     */
    @IsTest
    private static void testNonImplementedMethod() {
        String exceptionThrown;
        
        Test.startTest();
        try {
            Callable callableClass = (Callable)Type.forName('Core_SirenFormattingHandler').newInstance();
            callableClass.call('nonImplementedMethod', new Map<String, Object>());
        }
        catch (Exception e) {
            exceptionThrown = e.getMessage();
        }
        Test.stopTest();
        
        System.assertEquals('Method not implemented', exceptionThrown, 'No exception thrown for method not implemented');
    }

}