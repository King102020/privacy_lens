/// A sensitive device capability, grouped from Android runtime permissions.
enum Capability {
  camera,
  microphone,
  preciseLocation,
  approximateLocation,
  backgroundLocation,
  contacts,
  sms,
  callLog,
  phone,
  calendar,
  bodySensors,
  physicalActivity,
  mediaAndFiles,
  nearbyDevices;

  bool get isLocation =>
      this == preciseLocation ||
      this == approximateLocation ||
      this == backgroundLocation;

  static const Map<String, Capability> _byPermission = {
    'android.permission.CAMERA': camera,
    'android.permission.RECORD_AUDIO': microphone,
    'android.permission.ACCESS_FINE_LOCATION': preciseLocation,
    'android.permission.ACCESS_COARSE_LOCATION': approximateLocation,
    'android.permission.ACCESS_BACKGROUND_LOCATION': backgroundLocation,
    'android.permission.READ_CONTACTS': contacts,
    'android.permission.READ_SMS': sms,
    'android.permission.RECEIVE_SMS': sms,
    'android.permission.SEND_SMS': sms,
    'android.permission.RECEIVE_MMS': sms,
    'android.permission.READ_CALL_LOG': callLog,
    'android.permission.WRITE_CALL_LOG': callLog,
    'android.permission.READ_PHONE_STATE': phone,
    'android.permission.READ_PHONE_NUMBERS': phone,
    'android.permission.CALL_PHONE': phone,
    'android.permission.READ_CALENDAR': calendar,
    'android.permission.BODY_SENSORS': bodySensors,
    'android.permission.BODY_SENSORS_BACKGROUND': bodySensors,
    'android.permission.ACTIVITY_RECOGNITION': physicalActivity,
    'android.permission.READ_EXTERNAL_STORAGE': mediaAndFiles,
    'android.permission.READ_MEDIA_IMAGES': mediaAndFiles,
    'android.permission.READ_MEDIA_VIDEO': mediaAndFiles,
    'android.permission.READ_MEDIA_AUDIO': mediaAndFiles,
    'android.permission.BLUETOOTH_SCAN': nearbyDevices,
    'android.permission.BLUETOOTH_CONNECT': nearbyDevices,
    'android.permission.NEARBY_WIFI_DEVICES': nearbyDevices,
    'android.permission.UWB_RANGING': nearbyDevices,
  };

  static Capability? fromAndroidPermission(String permission) =>
      _byPermission[permission];

  static Set<Capability> fromGrantedPermissions(Iterable<String> permissions) =>
      {
        for (final permission in permissions)
          if (_byPermission[permission] case final capability?) capability,
      };
}

/// Capabilities that make a combination worth explaining.
const Set<Capability> sensitiveDataCapabilities = {
  Capability.camera,
  Capability.microphone,
  Capability.preciseLocation,
  Capability.backgroundLocation,
  Capability.contacts,
  Capability.sms,
  Capability.callLog,
  Capability.mediaAndFiles,
};
