// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: proto/messages.proto

package dev.yanshouwang.bluetooth_low_energy.proto;

public final class Messages {
  private Messages() {}
  public static void registerAllExtensions(
      com.google.protobuf.ExtensionRegistryLite registry) {
  }

  public static void registerAllExtensions(
      com.google.protobuf.ExtensionRegistry registry) {
    registerAllExtensions(
        (com.google.protobuf.ExtensionRegistryLite) registry);
  }
  static final com.google.protobuf.Descriptors.Descriptor
    internal_static_proto_Advertisement_descriptor;
  static final 
    com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
      internal_static_proto_Advertisement_fieldAccessorTable;
  static final com.google.protobuf.Descriptors.Descriptor
    internal_static_proto_Peripheral_descriptor;
  static final 
    com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
      internal_static_proto_Peripheral_fieldAccessorTable;
  static final com.google.protobuf.Descriptors.Descriptor
    internal_static_proto_GattService_descriptor;
  static final 
    com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
      internal_static_proto_GattService_fieldAccessorTable;
  static final com.google.protobuf.Descriptors.Descriptor
    internal_static_proto_GattCharacteristic_descriptor;
  static final 
    com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
      internal_static_proto_GattCharacteristic_fieldAccessorTable;
  static final com.google.protobuf.Descriptors.Descriptor
    internal_static_proto_GattDescriptor_descriptor;
  static final 
    com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
      internal_static_proto_GattDescriptor_fieldAccessorTable;
  static final com.google.protobuf.Descriptors.Descriptor
    internal_static_proto_BluetoothState_descriptor;
  static final 
    com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
      internal_static_proto_BluetoothState_fieldAccessorTable;

  public static com.google.protobuf.Descriptors.FileDescriptor
      getDescriptor() {
    return descriptor;
  }
  private static  com.google.protobuf.Descriptors.FileDescriptor
      descriptor;
  static {
    java.lang.String[] descriptorData = {
      "\n\024proto/messages.proto\022\005proto\"N\n\rAdverti" +
      "sement\022\014\n\004uuid\030\001 \001(\t\022\014\n\004data\030\002 \001(\014\022\014\n\004rs" +
      "si\030\003 \001(\005\022\023\n\013connectable\030\004 \001(\010\"6\n\nPeriphe" +
      "ral\022\n\n\002id\030\001 \001(\t\022\034\n\024maximum_write_length\030" +
      "\002 \001(\005\"\'\n\013GattService\022\n\n\002id\030\001 \001(\t\022\014\n\004uuid" +
      "\030\002 \001(\t\"\213\001\n\022GattCharacteristic\022\n\n\002id\030\001 \001(" +
      "\t\022\014\n\004uuid\030\002 \001(\t\022\020\n\010can_read\030\003 \001(\010\022\021\n\tcan" +
      "_write\030\004 \001(\010\022\"\n\032can_write_without_respon" +
      "se\030\005 \001(\010\022\022\n\ncan_notify\030\006 \001(\010\"*\n\016GattDesc" +
      "riptor\022\n\n\002id\030\001 \001(\t\022\014\n\004uuid\030\002 \001(\t\" \n\016Blue" +
      "toothState\022\016\n\006number\030\001 \001(\005B.\n*dev.yansho" +
      "uwang.bluetooth_low_energy.protoP\001b\006prot" +
      "o3"
    };
    descriptor = com.google.protobuf.Descriptors.FileDescriptor
      .internalBuildGeneratedFileFrom(descriptorData,
        new com.google.protobuf.Descriptors.FileDescriptor[] {
        });
    internal_static_proto_Advertisement_descriptor =
      getDescriptor().getMessageTypes().get(0);
    internal_static_proto_Advertisement_fieldAccessorTable = new
      com.google.protobuf.GeneratedMessageV3.FieldAccessorTable(
        internal_static_proto_Advertisement_descriptor,
        new java.lang.String[] { "Uuid", "Data", "Rssi", "Connectable", });
    internal_static_proto_Peripheral_descriptor =
      getDescriptor().getMessageTypes().get(1);
    internal_static_proto_Peripheral_fieldAccessorTable = new
      com.google.protobuf.GeneratedMessageV3.FieldAccessorTable(
        internal_static_proto_Peripheral_descriptor,
        new java.lang.String[] { "Id", "MaximumWriteLength", });
    internal_static_proto_GattService_descriptor =
      getDescriptor().getMessageTypes().get(2);
    internal_static_proto_GattService_fieldAccessorTable = new
      com.google.protobuf.GeneratedMessageV3.FieldAccessorTable(
        internal_static_proto_GattService_descriptor,
        new java.lang.String[] { "Id", "Uuid", });
    internal_static_proto_GattCharacteristic_descriptor =
      getDescriptor().getMessageTypes().get(3);
    internal_static_proto_GattCharacteristic_fieldAccessorTable = new
      com.google.protobuf.GeneratedMessageV3.FieldAccessorTable(
        internal_static_proto_GattCharacteristic_descriptor,
        new java.lang.String[] { "Id", "Uuid", "CanRead", "CanWrite", "CanWriteWithoutResponse", "CanNotify", });
    internal_static_proto_GattDescriptor_descriptor =
      getDescriptor().getMessageTypes().get(4);
    internal_static_proto_GattDescriptor_fieldAccessorTable = new
      com.google.protobuf.GeneratedMessageV3.FieldAccessorTable(
        internal_static_proto_GattDescriptor_descriptor,
        new java.lang.String[] { "Id", "Uuid", });
    internal_static_proto_BluetoothState_descriptor =
      getDescriptor().getMessageTypes().get(5);
    internal_static_proto_BluetoothState_fieldAccessorTable = new
      com.google.protobuf.GeneratedMessageV3.FieldAccessorTable(
        internal_static_proto_BluetoothState_descriptor,
        new java.lang.String[] { "Number", });
  }

  // @@protoc_insertion_point(outer_class_scope)
}
