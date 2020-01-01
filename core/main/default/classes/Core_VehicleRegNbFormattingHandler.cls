/**
 * @author Rémi Le Guin
 * @date 20/12/2019
 * @description Trigger handler to format vehicle registration numbers with dashes.
 */
public with sharing class Core_VehicleRegNbFormattingHandler implements Callable {

    /**
     * @description Format vehicle registration numbers with dashes.
     * @param vehicles A list of vehicles.
     * @param oldVehiclesMap A map of vehicles in their previous version.
     * @return A message stating the method execution.
     */
    private static String formatVehicleRegistrationNumber(List<Vehicle__c> vehicles, Map<Id, Vehicle__c> oldVehiclesMap) {
        if (Schema.SObjectType.Vehicle__c.Fields.VehicleRegistrationNumber__c.isUpdateable()) {
            for (Vehicle__c vehicle : vehicles) {
                if (String.isNotBlank(vehicle.VehicleRegistrationNumber__c)
                    && (oldVehiclesMap == null
                        || (oldVehiclesMap != null
                            && oldVehiclesMap.get(vehicle.Id) != null
                            && vehicle.VehicleRegistrationNumber__c != oldVehiclesMap.get(vehicle.Id).VehicleRegistrationNumber__c))) {
                    String vehicleRegistrationNumber = Core_VehicleUtilities.formatVehicleRegistrationNumber(vehicle.VehicleRegistrationNumber__c);
                    if (vehicleRegistrationNumber == null) {
                        vehicle.VehicleRegistrationNumber__c.addError(Label.Core_VehicleRegistrationNumberFormatError);
                    }
                    else {
                        vehicle.VehicleRegistrationNumber__c = vehicleRegistrationNumber;
                    }
                }
            }
        }
        return 'Method executed: Core_VehicleRegNbFormattingHandler.formatVehicleRegistrationNumber';
    }
    
    /**
     * @description Provides functionality that other classes or packages can utilize and build upon.
     * @param action The behavior for the method to exhibit.
     * @param arguments Arguments to be used by the specified action.
     * @return The result of the method invocation.
     */
    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'formatVehicleRegistrationNumber' {
                return formatVehicleRegistrationNumber((List<Vehicle__c>)arguments.get('parameter1'),
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