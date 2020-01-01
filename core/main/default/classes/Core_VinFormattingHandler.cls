/**
 * @author Rémi Le Guin
 * @date 20/12/2019
 * @description Trigger handler to format Vehicle Identification Number (VIN).
 */
public with sharing class Core_VinFormattingHandler implements Callable {

    /**
     * @description Format Vehicle Identification Number (VIN) with no whitespaces or dashes.
     * @param vehicles A list of vehicles.
     * @param oldVehiclesMap A map of vehicles in their previous version.
     * @return A message stating the method execution.
     */
    private static String formatVin(List<Vehicle__c> vehicles, Map<Id, Vehicle__c> oldVehiclesMap) {
        if (Schema.SObjectType.Vehicle__c.Fields.VIN__c.isUpdateable()) {
            for (Vehicle__c vehicle : vehicles) {
                if (String.isNotBlank(vehicle.VIN__c)
                    && (oldVehiclesMap == null
                        || (oldVehiclesMap != null
                            && oldVehiclesMap.get(vehicle.Id) != null
                            && vehicle.VIN__c != oldVehiclesMap.get(vehicle.Id).VIN__c))) {
                    vehicle.VIN__c = vehicle.VIN__c.replaceAll('[^a-zA-Z0-9]', '').toUpperCase();
                }
            }
        }
        return 'Method executed: Core_VinFormattingHandler.formatVin';
    }
    
    /**
     * @description Provides functionality that other classes or packages can utilize and build upon.
     * @param action The behavior for the method to exhibit.
     * @param arguments Arguments to be used by the specified action.
     * @return The result of the method invocation.
     */
    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'formatVin' {
                return formatVin((List<Vehicle__c>)arguments.get('parameter1'),
                                 (Map<Id, Vehicle__c>)arguments.get('parameter2'));
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