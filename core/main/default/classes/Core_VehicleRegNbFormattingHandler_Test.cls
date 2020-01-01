/**
 * @author Rémi Le Guin
 * @date 20/12/2019
 * @description Test class for the handler class for the vehicle registration number formatting.
 */
@IsTest
private class Core_VehicleRegNbFormattingHandler_Test {

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
            'Email' => 'authorizeduser@corevehicleregnbformattinghandler.fr',
            'Username' => 'authorizeduser@corevehicleregnbformattinghandler.fr',
            'CommunityNickname' => 'authorizeduser',
            'ProfileId' => profileId
        });
        insert new PermissionSetAssignment (PermissionSetId = coreAdministratorPermissionId, AssigneeId = authorizedUser.Id);

        System.runAs(authorizedUser) {
            List<Vehicle__c> vehicles = new List<Vehicle__c> ();
            for (Integer i = 0; i < 75; i++) {
                String index = String.valueOf(i).leftPad(3, '0');
                vehicles.add((Vehicle__c)TDF.createSObject('Vehicle__c', new Map<String, Object> {
                    'Name' => 'Updated' + index,
                    'Brand__c' => 'Peugeot',
                    'Engine__c' => 'Gasoline',
                    'Gearbox__c' => 'Manual',
                    'VehicleRegistrationNumber__c' => 'XX-' + index + '-YY',
                    'VIN__c' => index.leftPad(17, '0')
                }, false));
            }
            for (Integer i = 75; i < 150; i++) {
                String index = String.valueOf(i).leftPad(3, '0');
                vehicles.add((Vehicle__c)TDF.createSObject('Vehicle__c', new Map<String, Object> {
                    'Name' => 'Updated' + index,
                    'Brand__c' => 'Peugeot',
                    'Engine__c' => 'Gasoline',
                    'Gearbox__c' => 'Manual',
                    'VehicleRegistrationNumber__c' => 'XX ' + index + ' YY',
                    'VIN__c' => index.leftPad(17, '0')
                }, false));
            }
            for (Integer i = 150; i < 225; i++) {
                String index = String.valueOf(i).leftPad(3, '0');
                vehicles.add((Vehicle__c)TDF.createSObject('Vehicle__c', new Map<String, Object> {
                    'Name' => 'Updated' + index,
                    'Brand__c' => 'Peugeot',
                    'Engine__c' => 'Gasoline',
                    'Gearbox__c' => 'Manual',
                    'VehicleRegistrationNumber__c' => 'XX' + index + 'YY',
                    'VIN__c' => index.leftPad(17, '0')
                }, false));
            }
            insert vehicles;
        }
    }

    /**
     * @description Test the formaformatVehicleRegistrationNumbertSiren method when creating Vehicles.
     */
    @IsTest
    private static void formatVehicleRegistrationNumber_InsertTest() {
        List<Vehicle__c> vehicles = new List<Vehicle__c> ();
        for (Integer i = 0; i < 75; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            vehicles.add((Vehicle__c)TDF.createSObject('Vehicle__c', new Map<String, Object> {
                'Name' => 'Inserted' + index,
                'Brand__c' => 'Peugeot',
                'Engine__c' => 'Gasoline',
                'Gearbox__c' => 'Manual',
                'VehicleRegistrationNumber__c' => 'XX-' + index + '-XX',
                'VIN__c' => '1' + index.leftPad(16, '0')
            }, false));
        }
        for (Integer i = 75; i < 150; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            vehicles.add((Vehicle__c)TDF.createSObject('Vehicle__c', new Map<String, Object> {
                'Name' => 'Inserted' + index,
                'Brand__c' => 'Peugeot',
                'Engine__c' => 'Gasoline',
                'Gearbox__c' => 'Manual',
                'VehicleRegistrationNumber__c' => 'XX ' + index + ' XX',
                'VIN__c' => '1' + index.leftPad(16, '0')
            }, false));
        }
        for (Integer i = 150; i < 225; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            vehicles.add((Vehicle__c)TDF.createSObject('Vehicle__c', new Map<String, Object> {
                'Name' => 'Inserted' + index,
                'Brand__c' => 'Peugeot',
                'Engine__c' => 'Gasoline',
                'Gearbox__c' => 'Manual',
                'VehicleRegistrationNumber__c' => 'XX' + index + 'XX',
                'VIN__c' => '1' + index.leftPad(16, '0')
            }, false));
        }
        User authorizedUser = [SELECT Id FROM User WHERE Username = 'authorizeduser@corevehicleregnbformattinghandler.fr' LIMIT 1];

        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'FormatVehicleRegistrationNumberInsert' }, 'Vehicle__c');
        System.runAs(authorizedUser) {
            insert vehicles;
        }
        Test.stopTest();

        vehicles = [SELECT VehicleRegistrationNumber__c FROM Vehicle__c WHERE Name LIKE 'Inserted%' ORDER BY VehicleRegistrationNumber__c];
        for (Integer i = 0; i < 225; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            System.assertEquals('XX-' + index + '-XX', vehicles[i].VehicleRegistrationNumber__c, 'Vehicle registration number is not formatted');
        }
    }

    /**
     * @description Test the formatVehicleRegistrationNumber method when editing Vehicles with success.
     */
    @IsTest
    private static void formatVehicleRegistrationNumber_UpdateTestSuccess() {
        List<Vehicle__c> vehicles = [SELECT VehicleRegistrationNumber__c FROM Vehicle__c WHERE Name LIKE 'Updated%' ORDER BY VehicleRegistrationNumber__c];
        for (Vehicle__c vehicle : vehicles) {
            vehicle.VehicleRegistrationNumber__c = vehicle.VehicleRegistrationNumber__c.replaceFirst('YY', 'ZZ');
        }
        User authorizedUser = [SELECT Id FROM User WHERE Username = 'authorizeduser@corevehicleregnbformattinghandler.fr' LIMIT 1];

        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'FormatVehicleRegistrationNumberUpdate' }, 'Vehicle__c');
        System.runAs(authorizedUser) {
            update vehicles;
        }
        Test.stopTest();

        vehicles = [SELECT VehicleRegistrationNumber__c FROM Vehicle__c WHERE Name LIKE 'Updated%' ORDER BY VehicleRegistrationNumber__c];
        for (Integer i = 0; i < 225; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            System.assertEquals('XX-' + index + '-ZZ', vehicles[i].VehicleRegistrationNumber__c, 'Vehicle registration number is not formatted');
        }
    }

    /**
     * @description Test the formatVehicleRegistrationNumber method when editing Vehicles with wrong input.
     */
    @IsTest
    private static void formatVehicleRegistrationNumber_UpdateTestFail() {
        List<Vehicle__c> vehicles = [SELECT VehicleRegistrationNumber__c FROM Vehicle__c WHERE Name LIKE 'Updated%' ORDER BY VehicleRegistrationNumber__c];
        for (Integer i = 0; i < 225; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            vehicles[i].VehicleRegistrationNumber__c = '0000' + index;
        }
        User authorizedUser = [SELECT Id FROM User WHERE Username = 'authorizeduser@corevehicleregnbformattinghandler.fr' LIMIT 1];

        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'FormatVehicleRegistrationNumberUpdate' }, 'Vehicle__c');
        Exception error;
        System.runAs(authorizedUser) {
            try {
                update vehicles;
            }
            catch (Exception e) {
                error = e;
            }
        }
        Test.stopTest();

        System.assertNotEquals(null, error, 'No error occurred while input format is wrong');
        vehicles = [SELECT VehicleRegistrationNumber__c FROM Vehicle__c WHERE Name LIKE 'Updated%' ORDER BY VehicleRegistrationNumber__c];
        for (Integer i = 0; i < 225; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            System.assertNotEquals('0000' + index, vehicles[i].VehicleRegistrationNumber__c, 'Vehicle registration number is updated while the update failed');
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
            Callable callableClass = (Callable)Type.forName('Core_VehicleRegNbFormattingHandler').newInstance();
            callableClass.call('nonImplementedMethod', new Map<String, Object>());
        }
        catch (Exception e) {
            exceptionThrown = e.getMessage();
        }
        Test.stopTest();
        
        System.assertEquals('Method not implemented', exceptionThrown, 'No exception thrown for method not implemented');
    }

}