/**
 * @author Rémi Le Guin
 * @date 03/12/2019
 * @description Test class for the utility class for the User standard object whithin the Core package.
 */
@IsTest
private class Core_UserUtilities_Test {

    /**
     * @description Data setup for the test class.
     */
    @TestSetup
    private static void setup() {
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1][0].Id;

        User authorizedUser = (User)TDF.createSObject('User', new Map<String,Object> {
            'FirstName' => 'Authorized',
            'LastName' => 'User',
            'Alias' => 'authu',
            'Email' => 'authorizeduser@coreuserutilities.fr',
            'Username' => 'authorizeduser@coreuserutilities.fr',
            'CommunityNickname' => 'authorizeduser',
            'ProfileId' => profileId
        });
        Id coreUserPermissionId = [SELECT Id FROM PermissionSet WHERE Name = 'Core_User' LIMIT 1][0].Id;
        insert new PermissionSetAssignment (PermissionSetId = coreUserPermissionId, AssigneeId = authorizedUser.Id);

        User unauthorizedUser = (User)TDF.createSObject('User', new Map<String,Object> {
            'FirstName' => 'Unauthorized',
            'LastName' => 'User',
            'Alias' => 'unauthu',
            'Email' => 'unauthorizeduser@coreuserutilities.fr',
            'Username' => 'unauthorizeduser@coreuserutilities.fr',
            'CommunityNickname' => 'unauthorizeduser',
            'ProfileId' => profileId
        });

        User userWithRestrictions = (User)TDF.createSObject('User', new Map<String,Object> {
            'FirstName' => 'With Restrictions',
            'LastName' => 'User',
            'Alias' => 'rest',
            'Email' => 'userwithrestrictions@coreuserutilities.fr',
            'Username' => 'userwithrestrictions@coreuserutilities.fr',
            'CommunityNickname' => 'userwithrestrictions',
            'ProfileId' => profileId,
            'BypassedObjectRestrictions__c' => 'Account (Read)'
        });

        User userWithNoRestrictions = (User)TDF.createSObject('User', new Map<String,Object> {
            'FirstName' => 'With No Restrictions',
            'LastName' => 'User',
            'Alias' => 'norest',
            'Email' => 'userwithnorestrictions@coreuserutilities.fr',
            'Username' => 'userwithnorestrictions@coreuserutilities.fr',
            'CommunityNickname' => 'userwithnorestrictions',
            'ProfileId' => profileId
        });
    }

    /**
     * @description Test the getUserBypassedObjectRestrictionsById method when user retrieves bypassed object restrictions on a user.
     */
    @IsTest
    private static void getUserBypassedObjectRestrictionsById_TestSuccessWithRestrictions() {
        User authorizedUser = [SELECT Id FROM User WHERE Username = 'authorizeduser@coreuserutilities.fr' LIMIT 1];
        User userWithRestrictions = [SELECT Id FROM User WHERE Username = 'userwithrestrictions@coreuserutilities.fr' LIMIT 1];

        String userBypassedObjectRestrictions;
        Test.startTest();
        System.runAs(authorizedUser) {
            userBypassedObjectRestrictions = Core_UserUtilities.getUserBypassedObjectRestrictionsById(userWithRestrictions.Id);
        }
        Test.stopTest();

        System.assertEquals('Account (Read)', userBypassedObjectRestrictions, 'Wrong or no Bypassed object restrictions retrieved');
    }

    /**
     * @description Test the getUserBypassedObjectRestrictionsById method when user does not retrieve any bypassed object restrictions on a user.
     */
    @IsTest
    private static void getUserBypassedObjectRestrictionsById_TestSuccessWithNoRestrictions() {
        User authorizedUser = [SELECT Id FROM User WHERE Username = 'authorizeduser@coreuserutilities.fr' LIMIT 1];
        User userWithNoRestrictions = [SELECT Id FROM User WHERE Username = 'userwithnorestrictions@coreuserutilities.fr' LIMIT 1];

        String userBypassedObjectRestrictions;
        Test.startTest();
        System.runAs(authorizedUser) {
            userBypassedObjectRestrictions = Core_UserUtilities.getUserBypassedObjectRestrictionsById(userWithNoRestrictions.Id);
        }
        Test.stopTest();

        System.assertEquals(null, userBypassedObjectRestrictions, 'Bypassed object restrictions retrieved while it should not');
    }

    /**
     * @description Test the getUserBypassedObjectRestrictionsById method when user cannot access to the BypassedObjectRestrictions__c field on Users.
     */
    @IsTest
    private static void getUserBypassedObjectRestrictionsById_TestError() {
        User unauthorizedUser = [SELECT Id FROM User WHERE Username = 'unauthorizeduser@coreuserutilities.fr' LIMIT 1];
        User userWithRestrictions = [SELECT Id FROM User WHERE Username = 'userwithrestrictions@coreuserutilities.fr' LIMIT 1];

        String userBypassedObjectRestrictions;
        Test.startTest();
        System.runAs(unauthorizedUser) {
            userBypassedObjectRestrictions = Core_UserUtilities.getUserBypassedObjectRestrictionsById(userWithRestrictions.Id);
        }
        Test.stopTest();

        System.assertEquals(null, userBypassedObjectRestrictions, 'Bypassed object restrictions retrieved while it should not');
    }

}