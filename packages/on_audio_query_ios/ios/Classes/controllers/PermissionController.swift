import MediaPlayer

class PermissionController {
    public static func checkPermission() -> Bool {
        let permissionStatus = MPMediaLibrary.authorizationStatus()
        if permissionStatus == MPMediaLibraryAuthorizationStatus.authorized {
            return true
        } else {
            return false
        }
    }
    
    public static func requestPermission(result: @escaping FlutterResult) -> Void {
        Log.type.debug("Requesting permissions.")
        Log.type.debug("iOS Version: \(ProcessInfo().operatingSystemVersion.majorVersion)")
        
        MPMediaLibrary.requestAuthorization { status in
            let isPermissionGranted = status == .authorized
            Log.type.debug("Permission accepted: \(isPermissionGranted)")
            result(isPermissionGranted)
        }
    }
}
