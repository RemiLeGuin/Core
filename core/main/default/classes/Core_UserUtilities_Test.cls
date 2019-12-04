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
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1][0].Id;
        Id coreUserPermissionId = [SELECT Id FROM PermissionSet WHERE Name = 'Core_User' LIMIT 1][0].Id;

        User authorizedUserWithRestrictions = (User)TDF.createSObject('User', new Map<String,Object> {
            'FirstName' => 'Authorized User',
            'LastName' => 'With Restrictions',
            'Alias' => 'authwr',
            'Email' => 'authorizeduserwithrestrictions@coreuserutilities.fr',
            'Username' => 'authorizeduserwithrestrictions@coreuserutilities.fr',
            'CommunityNickname' => 'authorizeduserwithrestrictions',
            'ProfileId' => profileId,
            'BypassedObjectRestrictions__c' => 'Account (Read)'
        });
        insert new PermissionSetAssignment (PermissionSetId = coreUserPermissionId, AssigneeId = authorizedUserWithRestrictions.Id);

        User authorizedUserWithNoRestrictions = (User)TDF.createSObject('User', new Map<String,Object> {
            'FirstName' => 'Authorized User',
            'LastName' => 'With No Restrictions',
            'Alias' => 'authwnr',
            'Email' => 'authorizeduserwithnorestrictions@coreuserutilities.fr',
            'Username' => 'authorizeduserwithnorestrictions@coreuserutilities.fr',
            'CommunityNickname' => 'authorizeduserwithnorestrictions',
            'ProfileId' => profileId
        });
        insert new PermissionSetAssignment (PermissionSetId = coreUserPermissionId, AssigneeId = authorizedUserWithNoRestrictions.Id);

        User unauthorizedUserWithRestrictions = (User)TDF.createSObject('User', new Map<String,Object> {
            'FirstName' => 'Unauthorized User',
            'LastName' => 'With Restrictions',
            'Alias' => 'unauth',
            'Email' => 'unauthorizeduserwithrestrictions@coreuserutilities.fr',
            'Username' => 'unauthorizeduserwithrestrictions@coreuserutilities.fr',
            'CommunityNickname' => 'unauthorizeduserwithrestrictions',
            'ProfileId' => profileId,
            'BypassedObjectRestrictions__c' => 'Account (Read)'
        });
    }

    /**
     * @description Test the getUserBypassedObjectRestrictionsById method when user retrieves bypassed object restrictions on a user.
     */
    @IsTest
    private static void getUserBypassedObjectRestrictionsById_TestSuccessWithRestrictions() {
        User authorizedUserWithRestrictions = [SELECT Id FROM User WHERE Username = 'authorizeduserwithrestrictions@coreuserutilities.fr' LIMIT 1];

        String userBypassedObjectRestrictions;
        Test.startTest();
        System.runAs(authorizedUserWithRestrictions) {
            userBypassedObjectRestrictions = Core_UserUtilities.getUserBypassedObjectRestrictionsById(authorizedUserWithRestrictions.Id);
        }
        Test.stopTest();

        System.assertEquals('Account (Read)', userBypassedObjectRestrictions, 'Wrong or no Bypassed object restrictions retrieved');
    }

    /**
     * @description Test the getUserBypassedObjectRestrictionsById method when user does not retrieve any bypassed object restrictions on a user.
     */
    @IsTest
    private static void getUserBypassedObjectRestrictionsById_TestSuccessWithNoRestrictions() {
        User authorizedUserWithNoRestrictions = [SELECT Id FROM User WHERE Username = 'authorizeduserwithnorestrictions@coreuserutilities.fr' LIMIT 1];

        String userBypassedObjectRestrictions;
        Test.startTest();
        System.runAs(authorizedUserWithNoRestrictions) {
            userBypassedObjectRestrictions = Core_UserUtilities.getUserBypassedObjectRestrictionsById(authorizedUserWithNoRestrictions.Id);
        }
        Test.stopTest();

        System.assertEquals(null, userBypassedObjectRestrictions, 'Bypassed object restrictions retrieved while it should not');
    }

    /**
     * @description Test the getUserBypassedObjectRestrictionsById method when user cannot access to the BypassedObjectRestrictions__c field on Users.
     */
    @IsTest
    private static void getUserBypassedObjectRestrictionsById_TestError() {
        User unauthorizedUserWithRestrictions = [SELECT Id FROM User WHERE Username = 'unauthorizeduserwithrestrictions@coreuserutilities.fr' LIMIT 1];

        String userBypassedObjectRestrictions;
        Test.startTest();
        System.runAs(unauthorizedUserWithRestrictions) {
            userBypassedObjectRestrictions = Core_UserUtilities.getUserBypassedObjectRestrictionsById(unauthorizedUserWithRestrictions.Id);
        }
        Test.stopTest();

        System.assertEquals(null, userBypassedObjectRestrictions, 'Bypassed object restrictions retrieved while it should not');
    }

}