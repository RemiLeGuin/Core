/**
 * @author Rémi Le Guin
 * @date 20/12/2019
 * @description Test class for the utility class for the Vehicle__c custom object within the Core package.
 */
@IsTest
private class Core_VehicleUtilities_Test {

    /**
     * @description Test the formatVehicleRegistrationNumber method when input is already formatted.
     */
    @IsTest
    private static void formatVehicleRegistrationNumber_TestFormatted() {
        Test.startTest();
        String vehicleRegistrationNumber = Core_VehicleUtilities.formatVehicleRegistrationNumber('XX-000-YY');
        Test.stopTest();
        System.assertEquals('XX-000-YY', vehicleRegistrationNumber, 'Input has been corrupted');
    }

    /**
     * @description Test the formatVehicleRegistrationNumber method when input is not formatted.
     */
    @IsTest
    private static void formatVehicleRegistrationNumber_TestNotFormatted() {
        Test.startTest();
        String vehicleRegistrationNumber = Core_VehicleUtilities.formatVehicleRegistrationNumber('XX 000 YY');
        Test.stopTest();
        System.assertEquals('XX-000-YY', vehicleRegistrationNumber, 'Input has not been formatted');
    }

    /**
     * @description Test the formatVehicleRegistrationNumber method when input has no digit.
     */
    @IsTest
    private static void formatVehicleRegistrationNumber_TestNoDigit() {
        Test.startTest();
        String vehicleRegistrationNumber = Core_VehicleUtilities.formatVehicleRegistrationNumber('XX YYY ZZ');
        Test.stopTest();
        System.assertEquals(null, vehicleRegistrationNumber, 'Input has been formatted while it has no digit');
    }

    /**
     * @description Test the formatVehicleRegistrationNumber method when input exceeds max length.
     */
    @IsTest
    private static void formatVehicleRegistrationNumber_TestTooLongInput() {
        Test.startTest();
        String vehicleRegistrationNumber = Core_VehicleUtilities.formatVehicleRegistrationNumber('XXXXYYYYZZZZ');
        Test.stopTest();
        System.assertEquals(null, vehicleRegistrationNumber, 'Input has been formatted while it has no digit');
    }

    /**
     * @description Test the formatVehicleRegistrationNumber method with empty input.
     */
    @IsTest
    private static void formatVehicleRegistrationNumber_TestEmptyInput() {
        Test.startTest();
        String vehicleRegistrationNumber = Core_VehicleUtilities.formatVehicleRegistrationNumber('');
        Test.stopTest();
        System.assertEquals(null, vehicleRegistrationNumber, 'Input has been formatted while it is empty');
    }

    /**
     * @description Test the formatVehicleRegistrationNumber method with null input.
     */
    @IsTest
    private static void formatVehicleRegistrationNumber_TestNullInput() {
        Test.startTest();
        String vehicleRegistrationNumber = Core_VehicleUtilities.formatVehicleRegistrationNumber(null);
        Test.stopTest();
        System.assertEquals(null, vehicleRegistrationNumber, 'Input has been formatted while it is null');
    }

    /**
     * @description Test the validateVehicleRegistrationNumberStrict method when input valid.
     */
    @IsTest
    private static void validateVehicleRegistrationNumberStrict_TestValidInput() {
        Test.startTest();
        Boolean isValidated = Core_VehicleUtilities.validateVehicleRegistrationNumberStrict('XX-000-YY');
        Test.stopTest();
        System.assertEquals(true, isValidated, 'Input is not validated while it has the correct format');
    }

    /**
     * @description Test the validateVehicleRegistrationNumberStrict method when input is not valid.
     */
    @IsTest
    private static void validateVehicleRegistrationNumberStrict_TestInvalidInput() {
        Test.startTest();
        Boolean isValidated = Core_VehicleUtilities.validateVehicleRegistrationNumberStrict('XX 000 YY');
        Test.stopTest();
        System.assertEquals(false, isValidated, 'Input is validated while it contains whitespaces');
    }

    /**
     * @description Test the validateVehicleRegistrationNumberStrict method with null empty.
     */
    @IsTest
    private static void validateVehicleRegistrationNumberStrict_TestEmptyInput() {
        Test.startTest();
        Boolean isValidated = Core_VehicleUtilities.validateVehicleRegistrationNumberStrict('');
        Test.stopTest();
        System.assertEquals(false, isValidated, 'Input is validated while it is empty');
    }

    /**
     * @description Test the validateVehicleRegistrationNumberStrict method with null input.
     */
    @IsTest
    private static void validateVehicleRegistrationNumberStrict_TestNullInput() {
        Test.startTest();
        Boolean isValidated = Core_VehicleUtilities.validateVehicleRegistrationNumberStrict(null);
        Test.stopTest();
        System.assertEquals(false, isValidated, 'Input is validated while it is null');
    }

    /**
     * @description Test the validateVehicleRegistrationNumberLazy method when input valid.
     */
    @IsTest
    private static void validateVehicleRegistrationNumberLazy_TestFormattedInput() {
        Test.startTest();
        Boolean isValidated = Core_VehicleUtilities.validateVehicleRegistrationNumberLazy('XX-000-YY');
        Test.stopTest();
        System.assertEquals(true, isValidated, 'Input is not validated while it has the correct format');
    }

    /**
     * @description Test the validateVehicleRegistrationNumberLazy method when input is unformatted.
     */
    @IsTest
    private static void validateVehicleRegistrationNumberLazy_TestUnformattedInput() {
        Test.startTest();
        Boolean isValidated = Core_VehicleUtilities.validateVehicleRegistrationNumberLazy('XX 000 YY');
        Test.stopTest();
        System.assertEquals(true, isValidated, 'Input is not validated while its format is acceptable');
    }

    /**
     * @description Test the validateVehicleRegistrationNumberLazy method when input is wrong.
     */
    @IsTest
    private static void validateVehicleRegistrationNumberLazy_TestWrongInput() {
        Test.startTest();
        Boolean isValidated = Core_VehicleUtilities.validateVehicleRegistrationNumberLazy('Wrong input!');
        Test.stopTest();
        System.assertEquals(false, isValidated, 'Input is validated while its format is wrong');
    }

    /**
     * @description Test the validateVehicleRegistrationNumberLazy method with null empty.
     */
    @IsTest
    private static void validateVehicleRegistrationNumberLazy_TestEmptyInput() {
        Test.startTest();
        Boolean isValidated = Core_VehicleUtilities.validateVehicleRegistrationNumberLazy('');
        Test.stopTest();
        System.assertEquals(false, isValidated, 'Input is validated while it is empty');
    }

    /**
     * @description Test the validateVehicleRegistrationNumberLazy method with null input.
     */
    @IsTest
    private static void validateVehicleRegistrationNumberLazy_TestNullInput() {
        Test.startTest();
        Boolean isValidated = Core_VehicleUtilities.validateVehicleRegistrationNumberLazy(null);
        Test.stopTest();
        System.assertEquals(false, isValidated, 'Input is validated while it is null');
    }

}