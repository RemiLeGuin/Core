/**
 * @author Rémi Le Guin
 * @date 20/11/2019
 * @description Utility class for the User standard object whithin the Core package.
 */
public with sharing class Core_UserUtilities {

    /**
     * @description Get the objects and the permission the user shall bypass.
     * @param userId User's Salesforce ID.
     * @return Concatenated Object (Permission) in a string.
     */
    public static String getUserBypassedObjectRestrictionsById(Id userId) {
        if (Schema.SObjectType.User.isAccessible()
            && User.BypassedObjectRestrictions__c.getDescribe().isAccessible()) {
            User u = [SELECT BypassedObjectRestrictions__c FROM User WHERE Id = :userId LIMIT 1];
            if (u != null && !String.isBlank(u.BypassedObjectRestrictions__c)) {
                return u.BypassedObjectRestrictions__c;
            }
        }
        return null;
    }

}