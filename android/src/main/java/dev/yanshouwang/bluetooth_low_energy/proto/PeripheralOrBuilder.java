// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: proto/messages.proto

package dev.yanshouwang.bluetooth_low_energy.proto;

public interface PeripheralOrBuilder extends
    // @@protoc_insertion_point(interface_extends:proto.Peripheral)
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
   * <code>.proto.UUID uuid = 2;</code>
   * @return Whether the uuid field is set.
   */
  boolean hasUuid();
  /**
   * <code>.proto.UUID uuid = 2;</code>
   * @return The uuid.
   */
  dev.yanshouwang.bluetooth_low_energy.proto.UUID getUuid();
  /**
   * <code>.proto.UUID uuid = 2;</code>
   */
  dev.yanshouwang.bluetooth_low_energy.proto.UUIDOrBuilder getUuidOrBuilder();
}
