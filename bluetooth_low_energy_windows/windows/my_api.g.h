// Autogenerated from Pigeon (v15.0.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#ifndef PIGEON_MY_API_G_H_
#define PIGEON_MY_API_G_H_
#include <flutter/basic_message_channel.h>
#include <flutter/binary_messenger.h>
#include <flutter/encodable_value.h>
#include <flutter/standard_message_codec.h>

#include <map>
#include <optional>
#include <string>

namespace bluetooth_low_energy_windows {


// Generated class from Pigeon.

class FlutterError {
 public:
  explicit FlutterError(const std::string& code)
    : code_(code) {}
  explicit FlutterError(const std::string& code, const std::string& message)
    : code_(code), message_(message) {}
  explicit FlutterError(const std::string& code, const std::string& message, const flutter::EncodableValue& details)
    : code_(code), message_(message), details_(details) {}

  const std::string& code() const { return code_; }
  const std::string& message() const { return message_; }
  const flutter::EncodableValue& details() const { return details_; }

 private:
  std::string code_;
  std::string message_;
  flutter::EncodableValue details_;
};

template<class T> class ErrorOr {
 public:
  ErrorOr(const T& rhs) : v_(rhs) {}
  ErrorOr(const T&& rhs) : v_(std::move(rhs)) {}
  ErrorOr(const FlutterError& rhs) : v_(rhs) {}
  ErrorOr(const FlutterError&& rhs) : v_(std::move(rhs)) {}

  bool has_error() const { return std::holds_alternative<FlutterError>(v_); }
  const T& value() const { return std::get<T>(v_); };
  const FlutterError& error() const { return std::get<FlutterError>(v_); };

 private:
  friend class MyCentralManagerHostApi;
  friend class MyCentralManagerFlutterApi;
  friend class MyPeripheralManagerHostApi;
  friend class MyPeripheralManagerFlutterApi;
  ErrorOr() = default;
  T TakeValue() && { return std::get<T>(std::move(v_)); }

  std::variant<T, FlutterError> v_;
};


enum class MyBluetoothLowEnergyStateArgs {
  unknown = 0,
  unsupported = 1,
  unauthorized = 2,
  poweredOff = 3,
  poweredOn = 4
};

enum class MyGattCharacteristicPropertyArgs {
  read = 0,
  write = 1,
  writeWithoutResponse = 2,
  notify = 3,
  indicate = 4
};

enum class MyGattCharacteristicWriteTypeArgs {
  withResponse = 0,
  withoutResponse = 1
};

enum class MyGattCharacteristicNotifyStateArgs {
  none = 0,
  notify = 1,
  indicate = 2
};

// Generated class from Pigeon that represents data sent in messages.
class MyManufacturerSpecificDataArgs {
 public:
  // Constructs an object setting all fields.
  explicit MyManufacturerSpecificDataArgs(
    int64_t id_args,
    const std::vector<uint8_t>& data_args);

  int64_t id_args() const;
  void set_id_args(int64_t value_arg);

  const std::vector<uint8_t>& data_args() const;
  void set_data_args(const std::vector<uint8_t>& value_arg);


 private:
  static MyManufacturerSpecificDataArgs FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class MyAdvertisementArgs;
  friend class MyCentralManagerHostApi;
  friend class MyCentralManagerHostApiCodecSerializer;
  friend class MyCentralManagerFlutterApi;
  friend class MyCentralManagerFlutterApiCodecSerializer;
  friend class MyPeripheralManagerHostApi;
  friend class MyPeripheralManagerHostApiCodecSerializer;
  friend class MyPeripheralManagerFlutterApi;
  friend class MyPeripheralManagerFlutterApiCodecSerializer;
  int64_t id_args_;
  std::vector<uint8_t> data_args_;

};


// Generated class from Pigeon that represents data sent in messages.
class MyAdvertisementArgs {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit MyAdvertisementArgs(
    const flutter::EncodableList& service_u_u_i_ds_args,
    const flutter::EncodableMap& service_data_args);

  // Constructs an object setting all fields.
  explicit MyAdvertisementArgs(
    const std::string* name_args,
    const flutter::EncodableList& service_u_u_i_ds_args,
    const flutter::EncodableMap& service_data_args,
    const MyManufacturerSpecificDataArgs* manufacturer_specific_data_args);

  const std::string* name_args() const;
  void set_name_args(const std::string_view* value_arg);
  void set_name_args(std::string_view value_arg);

  const flutter::EncodableList& service_u_u_i_ds_args() const;
  void set_service_u_u_i_ds_args(const flutter::EncodableList& value_arg);

  const flutter::EncodableMap& service_data_args() const;
  void set_service_data_args(const flutter::EncodableMap& value_arg);

  const MyManufacturerSpecificDataArgs* manufacturer_specific_data_args() const;
  void set_manufacturer_specific_data_args(const MyManufacturerSpecificDataArgs* value_arg);
  void set_manufacturer_specific_data_args(const MyManufacturerSpecificDataArgs& value_arg);


 private:
  static MyAdvertisementArgs FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class MyCentralManagerHostApi;
  friend class MyCentralManagerHostApiCodecSerializer;
  friend class MyCentralManagerFlutterApi;
  friend class MyCentralManagerFlutterApiCodecSerializer;
  friend class MyPeripheralManagerHostApi;
  friend class MyPeripheralManagerHostApiCodecSerializer;
  friend class MyPeripheralManagerFlutterApi;
  friend class MyPeripheralManagerFlutterApiCodecSerializer;
  std::optional<std::string> name_args_;
  flutter::EncodableList service_u_u_i_ds_args_;
  flutter::EncodableMap service_data_args_;
  std::optional<MyManufacturerSpecificDataArgs> manufacturer_specific_data_args_;

};


// Generated class from Pigeon that represents data sent in messages.
class MyCentralArgs {
 public:
  // Constructs an object setting all fields.
  explicit MyCentralArgs(int64_t address_args);

  int64_t address_args() const;
  void set_address_args(int64_t value_arg);


 private:
  static MyCentralArgs FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class MyCentralManagerHostApi;
  friend class MyCentralManagerHostApiCodecSerializer;
  friend class MyCentralManagerFlutterApi;
  friend class MyCentralManagerFlutterApiCodecSerializer;
  friend class MyPeripheralManagerHostApi;
  friend class MyPeripheralManagerHostApiCodecSerializer;
  friend class MyPeripheralManagerFlutterApi;
  friend class MyPeripheralManagerFlutterApiCodecSerializer;
  int64_t address_args_;

};


// Generated class from Pigeon that represents data sent in messages.
class MyPeripheralArgs {
 public:
  // Constructs an object setting all fields.
  explicit MyPeripheralArgs(int64_t address_args);

  int64_t address_args() const;
  void set_address_args(int64_t value_arg);


 private:
  static MyPeripheralArgs FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class MyCentralManagerHostApi;
  friend class MyCentralManagerHostApiCodecSerializer;
  friend class MyCentralManagerFlutterApi;
  friend class MyCentralManagerFlutterApiCodecSerializer;
  friend class MyPeripheralManagerHostApi;
  friend class MyPeripheralManagerHostApiCodecSerializer;
  friend class MyPeripheralManagerFlutterApi;
  friend class MyPeripheralManagerFlutterApiCodecSerializer;
  int64_t address_args_;

};


// Generated class from Pigeon that represents data sent in messages.
class MyGattDescriptorArgs {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit MyGattDescriptorArgs(
    int64_t handle_args,
    const std::string& uuid_args);

  // Constructs an object setting all fields.
  explicit MyGattDescriptorArgs(
    int64_t handle_args,
    const std::string& uuid_args,
    const std::vector<uint8_t>* value_args);

  int64_t handle_args() const;
  void set_handle_args(int64_t value_arg);

  const std::string& uuid_args() const;
  void set_uuid_args(std::string_view value_arg);

  const std::vector<uint8_t>* value_args() const;
  void set_value_args(const std::vector<uint8_t>* value_arg);
  void set_value_args(const std::vector<uint8_t>& value_arg);


 private:
  static MyGattDescriptorArgs FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class MyCentralManagerHostApi;
  friend class MyCentralManagerHostApiCodecSerializer;
  friend class MyCentralManagerFlutterApi;
  friend class MyCentralManagerFlutterApiCodecSerializer;
  friend class MyPeripheralManagerHostApi;
  friend class MyPeripheralManagerHostApiCodecSerializer;
  friend class MyPeripheralManagerFlutterApi;
  friend class MyPeripheralManagerFlutterApiCodecSerializer;
  int64_t handle_args_;
  std::string uuid_args_;
  std::optional<std::vector<uint8_t>> value_args_;

};


// Generated class from Pigeon that represents data sent in messages.
class MyGattCharacteristicArgs {
 public:
  // Constructs an object setting all fields.
  explicit MyGattCharacteristicArgs(
    int64_t handle_args,
    const std::string& uuid_args,
    const flutter::EncodableList& property_numbers_args,
    const flutter::EncodableList& descriptors_args);

  int64_t handle_args() const;
  void set_handle_args(int64_t value_arg);

  const std::string& uuid_args() const;
  void set_uuid_args(std::string_view value_arg);

  const flutter::EncodableList& property_numbers_args() const;
  void set_property_numbers_args(const flutter::EncodableList& value_arg);

  const flutter::EncodableList& descriptors_args() const;
  void set_descriptors_args(const flutter::EncodableList& value_arg);


 private:
  static MyGattCharacteristicArgs FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class MyCentralManagerHostApi;
  friend class MyCentralManagerHostApiCodecSerializer;
  friend class MyCentralManagerFlutterApi;
  friend class MyCentralManagerFlutterApiCodecSerializer;
  friend class MyPeripheralManagerHostApi;
  friend class MyPeripheralManagerHostApiCodecSerializer;
  friend class MyPeripheralManagerFlutterApi;
  friend class MyPeripheralManagerFlutterApiCodecSerializer;
  int64_t handle_args_;
  std::string uuid_args_;
  flutter::EncodableList property_numbers_args_;
  flutter::EncodableList descriptors_args_;

};


// Generated class from Pigeon that represents data sent in messages.
class MyGattServiceArgs {
 public:
  // Constructs an object setting all fields.
  explicit MyGattServiceArgs(
    int64_t handle_args,
    const std::string& uuid_args,
    const flutter::EncodableList& characteristics_args);

  int64_t handle_args() const;
  void set_handle_args(int64_t value_arg);

  const std::string& uuid_args() const;
  void set_uuid_args(std::string_view value_arg);

  const flutter::EncodableList& characteristics_args() const;
  void set_characteristics_args(const flutter::EncodableList& value_arg);


 private:
  static MyGattServiceArgs FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class MyCentralManagerHostApi;
  friend class MyCentralManagerHostApiCodecSerializer;
  friend class MyCentralManagerFlutterApi;
  friend class MyCentralManagerFlutterApiCodecSerializer;
  friend class MyPeripheralManagerHostApi;
  friend class MyPeripheralManagerHostApiCodecSerializer;
  friend class MyPeripheralManagerFlutterApi;
  friend class MyPeripheralManagerFlutterApiCodecSerializer;
  int64_t handle_args_;
  std::string uuid_args_;
  flutter::EncodableList characteristics_args_;

};

class MyCentralManagerHostApiCodecSerializer : public flutter::StandardCodecSerializer {
 public:
  MyCentralManagerHostApiCodecSerializer();
  inline static MyCentralManagerHostApiCodecSerializer& GetInstance() {
    static MyCentralManagerHostApiCodecSerializer sInstance;
    return sInstance;
  }

  void WriteValue(
    const flutter::EncodableValue& value,
    flutter::ByteStreamWriter* stream) const override;

 protected:
  flutter::EncodableValue ReadValueOfType(
    uint8_t type,
    flutter::ByteStreamReader* stream) const override;

};

// Generated interface from Pigeon that represents a handler of messages from Flutter.
class MyCentralManagerHostApi {
 public:
  MyCentralManagerHostApi(const MyCentralManagerHostApi&) = delete;
  MyCentralManagerHostApi& operator=(const MyCentralManagerHostApi&) = delete;
  virtual ~MyCentralManagerHostApi() {}
  virtual void SetUp(std::function<void(std::optional<FlutterError> reply)> result) = 0;
  virtual ErrorOr<int64_t> GetState() = 0;
  virtual std::optional<FlutterError> StartDiscovery() = 0;
  virtual std::optional<FlutterError> StopDiscovery() = 0;
  virtual void Connect(
    int64_t address_args,
    std::function<void(std::optional<FlutterError> reply)> result) = 0;
  virtual std::optional<FlutterError> Disconnect(int64_t address_args) = 0;
  virtual void DiscoverServices(
    int64_t address_args,
    std::function<void(ErrorOr<flutter::EncodableList> reply)> result) = 0;
  virtual void DiscoverCharacteristics(
    int64_t address_args,
    int64_t handle_args,
    std::function<void(ErrorOr<flutter::EncodableList> reply)> result) = 0;
  virtual void DiscoverDescriptors(
    int64_t address_args,
    int64_t handle_args,
    std::function<void(ErrorOr<flutter::EncodableList> reply)> result) = 0;
  virtual void ReadCharacteristic(
    int64_t address_args,
    int64_t handle_args,
    std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result) = 0;
  virtual void WriteCharacteristic(
    int64_t address_args,
    int64_t handle_args,
    const std::vector<uint8_t>& value_args,
    int64_t type_number_args,
    std::function<void(std::optional<FlutterError> reply)> result) = 0;
  virtual void SetCharacteristicNotifyState(
    int64_t address_args,
    int64_t handle_args,
    int64_t state_number_args,
    std::function<void(std::optional<FlutterError> reply)> result) = 0;
  virtual void ReadDescriptor(
    int64_t address_args,
    int64_t handle_args,
    std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result) = 0;
  virtual void WriteDescriptor(
    int64_t address_args,
    int64_t handle_args,
    const std::vector<uint8_t>& value_args,
    std::function<void(std::optional<FlutterError> reply)> result) = 0;

  // The codec used by MyCentralManagerHostApi.
  static const flutter::StandardMessageCodec& GetCodec();
  // Sets up an instance of `MyCentralManagerHostApi` to handle messages through the `binary_messenger`.
  static void SetUp(
    flutter::BinaryMessenger* binary_messenger,
    MyCentralManagerHostApi* api);
  static flutter::EncodableValue WrapError(std::string_view error_message);
  static flutter::EncodableValue WrapError(const FlutterError& error);

 protected:
  MyCentralManagerHostApi() = default;

};
class MyCentralManagerFlutterApiCodecSerializer : public flutter::StandardCodecSerializer {
 public:
  MyCentralManagerFlutterApiCodecSerializer();
  inline static MyCentralManagerFlutterApiCodecSerializer& GetInstance() {
    static MyCentralManagerFlutterApiCodecSerializer sInstance;
    return sInstance;
  }

  void WriteValue(
    const flutter::EncodableValue& value,
    flutter::ByteStreamWriter* stream) const override;

 protected:
  flutter::EncodableValue ReadValueOfType(
    uint8_t type,
    flutter::ByteStreamReader* stream) const override;

};

// Generated class from Pigeon that represents Flutter messages that can be called from C++.
class MyCentralManagerFlutterApi {
 public:
  MyCentralManagerFlutterApi(flutter::BinaryMessenger* binary_messenger);
  static const flutter::StandardMessageCodec& GetCodec();
  void OnStateChanged(
    int64_t state_number_args,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error);
  void OnDiscovered(
    const MyPeripheralArgs& peripheral_args,
    int64_t rssi_args,
    const MyAdvertisementArgs& advertisement_args,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error);
  void OnConnectionStateChanged(
    int64_t address_args,
    bool state_args,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error);
  void OnCharacteristicNotified(
    int64_t address_args,
    int64_t handle_args,
    const std::vector<uint8_t>& value_args,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error);

 private:
  flutter::BinaryMessenger* binary_messenger_;
};

class MyPeripheralManagerHostApiCodecSerializer : public flutter::StandardCodecSerializer {
 public:
  MyPeripheralManagerHostApiCodecSerializer();
  inline static MyPeripheralManagerHostApiCodecSerializer& GetInstance() {
    static MyPeripheralManagerHostApiCodecSerializer sInstance;
    return sInstance;
  }

  void WriteValue(
    const flutter::EncodableValue& value,
    flutter::ByteStreamWriter* stream) const override;

 protected:
  flutter::EncodableValue ReadValueOfType(
    uint8_t type,
    flutter::ByteStreamReader* stream) const override;

};

// Generated interface from Pigeon that represents a handler of messages from Flutter.
class MyPeripheralManagerHostApi {
 public:
  MyPeripheralManagerHostApi(const MyPeripheralManagerHostApi&) = delete;
  MyPeripheralManagerHostApi& operator=(const MyPeripheralManagerHostApi&) = delete;
  virtual ~MyPeripheralManagerHostApi() {}
  virtual void SetUp(std::function<void(std::optional<FlutterError> reply)> result) = 0;
  virtual ErrorOr<int64_t> GetState() = 0;
  virtual void AddService(
    const MyGattServiceArgs& service_args,
    std::function<void(std::optional<FlutterError> reply)> result) = 0;
  virtual std::optional<FlutterError> RemoveService(int64_t handle_args) = 0;
  virtual std::optional<FlutterError> ClearServices() = 0;
  virtual void StartAdvertising(
    const MyAdvertisementArgs& advertisement_args,
    std::function<void(std::optional<FlutterError> reply)> result) = 0;
  virtual std::optional<FlutterError> StopAdvertising() = 0;
  virtual std::optional<FlutterError> SendReadCharacteristicReply(
    int64_t address_args,
    int64_t handle_args,
    bool status_args,
    const std::vector<uint8_t>& value_args) = 0;
  virtual std::optional<FlutterError> SendWriteCharacteristicReply(
    int64_t address_args,
    int64_t handle_args,
    bool status_args) = 0;
  virtual void NotifyCharacteristic(
    int64_t address_args,
    int64_t handle_args,
    const std::vector<uint8_t>& value_args,
    std::function<void(std::optional<FlutterError> reply)> result) = 0;

  // The codec used by MyPeripheralManagerHostApi.
  static const flutter::StandardMessageCodec& GetCodec();
  // Sets up an instance of `MyPeripheralManagerHostApi` to handle messages through the `binary_messenger`.
  static void SetUp(
    flutter::BinaryMessenger* binary_messenger,
    MyPeripheralManagerHostApi* api);
  static flutter::EncodableValue WrapError(std::string_view error_message);
  static flutter::EncodableValue WrapError(const FlutterError& error);

 protected:
  MyPeripheralManagerHostApi() = default;

};
class MyPeripheralManagerFlutterApiCodecSerializer : public flutter::StandardCodecSerializer {
 public:
  MyPeripheralManagerFlutterApiCodecSerializer();
  inline static MyPeripheralManagerFlutterApiCodecSerializer& GetInstance() {
    static MyPeripheralManagerFlutterApiCodecSerializer sInstance;
    return sInstance;
  }

  void WriteValue(
    const flutter::EncodableValue& value,
    flutter::ByteStreamWriter* stream) const override;

 protected:
  flutter::EncodableValue ReadValueOfType(
    uint8_t type,
    flutter::ByteStreamReader* stream) const override;

};

// Generated class from Pigeon that represents Flutter messages that can be called from C++.
class MyPeripheralManagerFlutterApi {
 public:
  MyPeripheralManagerFlutterApi(flutter::BinaryMessenger* binary_messenger);
  static const flutter::StandardMessageCodec& GetCodec();
  void OnStateChanged(
    int64_t state_number_args,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error);
  void OnReadCharacteristicCommandReceived(
    const MyCentralArgs& central_args,
    int64_t handle_args,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error);
  void OnWriteCharacteristicCommandReceived(
    const MyCentralArgs& central_args,
    int64_t handle_args,
    const std::vector<uint8_t>& value_args,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error);
  void OnCharacteristicNotifyStateChanged(
    const MyCentralArgs& central_args,
    int64_t handle_args,
    bool state_args,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error);

 private:
  flutter::BinaryMessenger* binary_messenger_;
};

}  // namespace bluetooth_low_energy_windows
#endif  // PIGEON_MY_API_G_H_
