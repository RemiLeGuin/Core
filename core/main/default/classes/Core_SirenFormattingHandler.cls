/**
 * @author Rémi Le Guin
 * @date 20/12/2019
 * @description Trigger handler to format accounts' Siren number with no whitespaces or dashes.
 */
public with sharing class Core_SirenFormattingHandler implements Callable {

    /**
     * @description Format accounts' Siren number with no whitespaces or dashes.
     * @param accounts A list of accounts.
     * @return A message stating the method execution.
     */
    @TestVisible
    private static String formatSiren(List<Account> accounts, Map<Id, Account> oldAccountsMap) {
        if (Schema.SObjectType.Account.Fields.Siren__c.isUpdateable()) {
            for (Account acc : accounts) {
                if (!String.isBlank(acc.Siren__c)
                    && (oldAccountsMap == null
                        || (oldAccountsMap != null
                            && oldAccountsMap.get(acc.Id) != null
                            && acc.Siren__c != oldAccountsMap.get(acc.Id).Siren__c))) {
                    acc.Siren__c = acc.Siren__c.remove('-').deleteWhitespace();
                }
            }
        }
        return 'Method executed: Core_SirenFormattingHandler.formatSiren';
    }
    
    /**
     * @description Provides functionality that other classes or packages can utilize and build upon.
     * @param action The behavior for the method to exhibit.
     * @param arguments Arguments to be used by the specified action.
     * @return The result of the method invocation.
     */
    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'formatSiren' {
                return formatSiren((List<Account>)arguments.get('parameter1'),
                                   (Map<Id, Account>)arguments.get('parameter2'));
            }
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    /**
     * @description Throws new exceptions.
     */
    public class ExtensionMalformedCallException extends Exception {}

}