/**
 * @author Rémi Le Guin
 * @date 20/12/2019
 * @description Test class for the handler class for the Vehicle Identification Number (VIN) formatting.
 */
@IsTest
private class Core_VinFormattingHandler_Test {

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
            'Email' => 'authorizeduser@corevinformattinghandler.fr',
            'Username' => 'authorizeduser@corevinformattinghandler.fr',
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
                    'VIN__c' => 'VF300000000000' + index
                }, false));
            }
            for (Integer i = 75; i < 150; i++) {
                String index = String.valueOf(i).leftPad(3, '0');
                vehicles.add((Vehicle__c)TDF.createSObject('Vehicle__c', new Map<String, Object> {
                    'Name' => 'Updated' + index,
                    'Brand__c' => 'Peugeot',
                    'Engine__c' => 'Gasoline',
                    'Gearbox__c' => 'Manual',
                    'VehicleRegistrationNumber__c' => 'XX-' + index + '-YY',
                    'VIN__c' => 'VF3 000000 00000' + index
                }, false));
            }
            for (Integer i = 150; i < 225; i++) {
                String index = String.valueOf(i).leftPad(3, '0');
                vehicles.add((Vehicle__c)TDF.createSObject('Vehicle__c', new Map<String, Object> {
                    'Name' => 'Updated' + index,
                    'Brand__c' => 'Peugeot',
                    'Engine__c' => 'Gasoline',
                    'Gearbox__c' => 'Manual',
                    'VehicleRegistrationNumber__c' => 'XX-' + index + '-YY',
                    'VIN__c' => 'VF3-000000-00000' + index
                }, false));
            }
            insert vehicles;
        }
    }

    /**
     * @description Test the formatVin method when creating Vehicles.
     */
    @IsTest
    private static void formatVin_InsertTest() {
        List<Vehicle__c> vehicles = new List<Vehicle__c> ();
        for (Integer i = 0; i < 75; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            vehicles.add((Vehicle__c)TDF.createSObject('Vehicle__c', new Map<String, Object> {
                'Name' => 'Inserted' + index,
                'Brand__c' => 'Peugeot',
                'Engine__c' => 'Gasoline',
                'Gearbox__c' => 'Manual',
                'VehicleRegistrationNumber__c' => 'XX-' + index + '-XX',
                'VIN__c' => 'VF300000000001' + index
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
                'VIN__c' => 'VF3 000000 00001' + index
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
                'VIN__c' => 'VF3-000000-00001' + index
            }, false));
        }
        User authorizedUser = [SELECT Id FROM User WHERE Username = 'authorizeduser@corevinformattinghandler.fr' LIMIT 1];

        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'FormatVinInsert' }, 'Vehicle__c');
        System.runAs(authorizedUser) {
            insert vehicles;
        }
        Test.stopTest();

        vehicles = [SELECT VIN__c FROM Vehicle__c WHERE Name LIKE 'Inserted%' ORDER BY VIN__c];
        for (Integer i = 0; i < 225; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            System.assertEquals('VF300000000001' + index, vehicles[i].VIN__c, 'VIN is not formatted');
        }
    }

    /**
     * @description Test the formatVin method when editing Vehicles.
     */
    @IsTest
    private static void formatVin_UpdateTest() {
        List<Vehicle__c> vehicles = [SELECT VIN__c FROM Vehicle__c WHERE Name LIKE 'Updated%' ORDER BY VIN__c];
        for (Vehicle__c vehicle : vehicles) {
            vehicle.VIN__c = vehicle.VIN__c.replaceFirst('000', '111');
        }
        User authorizedUser = [SELECT Id FROM User WHERE Username = 'authorizeduser@corevinformattinghandler.fr' LIMIT 1];

        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'FormatVinUpdate' }, 'Vehicle__c');
        System.runAs(authorizedUser) {
            update vehicles;
        }
        Test.stopTest();

        vehicles = [SELECT VIN__c FROM Vehicle__c WHERE Name LIKE 'Updated%' ORDER BY VIN__c];
        for (Integer i = 0; i < 225; i++) {
            String index = String.valueOf(i).leftPad(3, '0');
            System.assertEquals('VF311100000000' + index, vehicles[i].VIN__c, 'VIN is not formatted');
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
            Callable callableClass = (Callable)Type.forName('Core_VinFormattingHandler').newInstance();
            callableClass.call('nonImplementedMethod', new Map<String, Object>());
        }
        catch (Exception e) {
            exceptionThrown = e.getMessage();
        }
        Test.stopTest();
        
        System.assertEquals('Method not implemented', exceptionThrown, 'No exception thrown for method not implemented');
    }

}