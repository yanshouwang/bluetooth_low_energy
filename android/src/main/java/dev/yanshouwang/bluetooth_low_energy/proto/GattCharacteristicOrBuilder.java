// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: proto/messages.proto

package dev.yanshouwang.bluetooth_low_energy.proto;

public interface GattCharacteristicOrBuilder extends
    // @@protoc_insertion_point(interface_extends:proto.GattCharacteristic)
    com.google.protobuf.MessageOrBuilder {

  /**
   * <code>string id = 1;</code>
   * @return The id.
   */
  java.lang.String getId();
  /**
   * <code>string id = 1;</code>
   * @return The bytes for id.
   */
  com.google.protobuf.ByteString
      getIdBytes();

  /**
   * <code>string uuid = 2;</code>
   * @return The uuid.
   */
  java.lang.String getUuid();
  /**
   * <code>string uuid = 2;</code>
   * @return The bytes for uuid.
   */
  com.google.protobuf.ByteString
      getUuidBytes();

  /**
   * <code>bool can_read = 3;</code>
   * @return The canRead.
   */
  boolean getCanRead();

  /**
   * <code>bool can_write = 4;</code>
   * @return The canWrite.
   */
  boolean getCanWrite();

  /**
   * <code>bool can_write_without_response = 5;</code>
   * @return The canWriteWithoutResponse.
   */
  boolean getCanWriteWithoutResponse();

  /**
   * <code>bool can_notify = 6;</code>
   * @return The canNotify.
   */
  boolean getCanNotify();
}
