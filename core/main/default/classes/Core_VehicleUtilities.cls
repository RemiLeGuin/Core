/**
 * @author Rémi Le Guin
 * @date 20/12/2019
 * @description Utility class for the Vehicle__c custom object within the Core package.
 */
public with sharing class Core_VehicleUtilities {
    
    /**
     * @description Format a vehicle registration number with dashes around the digits.
     * @param vehicleRegistrationNumber Raw vehicle registration number to be formatted.
     * @return Formatted vehicle registration number with dashes around the digits.
     */
    public static String formatVehicleRegistrationNumber(String vehicleRegistrationNumber) {
        if (validateVehicleRegistrationNumberLazy(vehicleRegistrationNumber)) {
            String formatted = vehicleRegistrationNumber.replaceAll('[^a-zA-Z0-9]', '');
            formatted = formatted.toUpperCase();
            String digits = formatted.replaceAll('[^0-9]', '');
            formatted = formatted.replaceAll(digits, '-' + digits + '-');
            return validateVehicleRegistrationNumberStrict(formatted) ? formatted : null;
        }
        else {
            return null;
        }
    }

    /**
     * @description Check if a vehicle registration number is strictly formatted with dashes around digits.
     * @param vehicleRegistrationNumber Raw vehicle registration number to be validated.
     * @return Boolean asserting if the input is strictly formatted.
     */
    @TestVisible
    private static Boolean validateVehicleRegistrationNumberStrict(String vehicleRegistrationNumber) {
        if (String.isBlank(vehicleRegistrationNumber)) {
            return false;
        }
        else {
            return Pattern.matches('[A-Z]{2}-[0-9]{3}-[A-Z]{2}', vehicleRegistrationNumber);
        }
    }

    /**
     * @description Check if a vehicle registration number is formatted with dashes, whitespaces or no separators.
     * @param vehicleRegistrationNumber Raw vehicle registration number to be validated.
     * @return Boolean asserting if the input is lazily formatted.
     */
    @TestVisible
    private static Boolean validateVehicleRegistrationNumberLazy(String vehicleRegistrationNumber) {
        if (String.isBlank(vehicleRegistrationNumber)) {
            return false;
        }
        else {
            return Pattern.matches('[a-z,A-Z]{2}(-|\\s|\\d*)[0-9]{3}(-|\\s|\\d*)[a-z,A-Z]{2}', vehicleRegistrationNumber);
        }
    }

}