// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: proto/messages.proto

package dev.yanshouwang.bluetooth_low_energy.proto;

/**
 * Protobuf type {@code proto.GattCharacteristic}
 */
public final class GattCharacteristic extends
    com.google.protobuf.GeneratedMessageV3 implements
    // @@protoc_insertion_point(message_implements:proto.GattCharacteristic)
    GattCharacteristicOrBuilder {
private static final long serialVersionUID = 0L;
  // Use GattCharacteristic.newBuilder() to construct.
  private GattCharacteristic(com.google.protobuf.GeneratedMessageV3.Builder<?> builder) {
    super(builder);
  }
  private GattCharacteristic() {
    id_ = "";
  }

  @java.lang.Override
  @SuppressWarnings({"unused"})
  protected java.lang.Object newInstance(
      UnusedPrivateParameter unused) {
    return new GattCharacteristic();
  }

  @java.lang.Override
  public final com.google.protobuf.UnknownFieldSet
  getUnknownFields() {
    return this.unknownFields;
  }
  private GattCharacteristic(
      com.google.protobuf.CodedInputStream input,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws com.google.protobuf.InvalidProtocolBufferException {
    this();
    if (extensionRegistry == null) {
      throw new java.lang.NullPointerException();
    }
    com.google.protobuf.UnknownFieldSet.Builder unknownFields =
        com.google.protobuf.UnknownFieldSet.newBuilder();
    try {
      boolean done = false;
      while (!done) {
        int tag = input.readTag();
        switch (tag) {
          case 0:
            done = true;
            break;
          case 10: {
            java.lang.String s = input.readStringRequireUtf8();

            id_ = s;
            break;
          }
          case 18: {
            dev.yanshouwang.bluetooth_low_energy.proto.UUID.Builder subBuilder = null;
            if (uuid_ != null) {
              subBuilder = uuid_.toBuilder();
            }
            uuid_ = input.readMessage(dev.yanshouwang.bluetooth_low_energy.proto.UUID.parser(), extensionRegistry);
            if (subBuilder != null) {
              subBuilder.mergeFrom(uuid_);
              uuid_ = subBuilder.buildPartial();
            }

            break;
          }
          case 24: {

            canRead_ = input.readBool();
            break;
          }
          case 32: {

            canWrite_ = input.readBool();
            break;
          }
          case 40: {

            canWriteWithoutResponse_ = input.readBool();
            break;
          }
          case 48: {

            canNotify_ = input.readBool();
            break;
          }
          default: {
            if (!parseUnknownField(
                input, unknownFields, extensionRegistry, tag)) {
              done = true;
            }
            break;
          }
        }
      }
    } catch (com.google.protobuf.InvalidProtocolBufferException e) {
      throw e.setUnfinishedMessage(this);
    } catch (com.google.protobuf.UninitializedMessageException e) {
      throw e.asInvalidProtocolBufferException().setUnfinishedMessage(this);
    } catch (java.io.IOException e) {
      throw new com.google.protobuf.InvalidProtocolBufferException(
          e).setUnfinishedMessage(this);
    } finally {
      this.unknownFields = unknownFields.build();
      makeExtensionsImmutable();
    }
  }
  public static final com.google.protobuf.Descriptors.Descriptor
      getDescriptor() {
    return dev.yanshouwang.bluetooth_low_energy.proto.Messages.internal_static_proto_GattCharacteristic_descriptor;
  }

  @java.lang.Override
  protected com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
      internalGetFieldAccessorTable() {
    return dev.yanshouwang.bluetooth_low_energy.proto.Messages.internal_static_proto_GattCharacteristic_fieldAccessorTable
        .ensureFieldAccessorsInitialized(
            dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic.class, dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic.Builder.class);
  }

  public static final int ID_FIELD_NUMBER = 1;
  private volatile java.lang.Object id_;
  /**
   * <code>string id = 1;</code>
   * @return The id.
   */
  @java.lang.Override
  public java.lang.String getId() {
    java.lang.Object ref = id_;
    if (ref instanceof java.lang.String) {
      return (java.lang.String) ref;
    } else {
      com.google.protobuf.ByteString bs = 
          (com.google.protobuf.ByteString) ref;
      java.lang.String s = bs.toStringUtf8();
      id_ = s;
      return s;
    }
  }
  /**
   * <code>string id = 1;</code>
   * @return The bytes for id.
   */
  @java.lang.Override
  public com.google.protobuf.ByteString
      getIdBytes() {
    java.lang.Object ref = id_;
    if (ref instanceof java.lang.String) {
      com.google.protobuf.ByteString b = 
          com.google.protobuf.ByteString.copyFromUtf8(
              (java.lang.String) ref);
      id_ = b;
      return b;
    } else {
      return (com.google.protobuf.ByteString) ref;
    }
  }

  public static final int UUID_FIELD_NUMBER = 2;
  private dev.yanshouwang.bluetooth_low_energy.proto.UUID uuid_;
  /**
   * <code>.proto.UUID uuid = 2;</code>
   * @return Whether the uuid field is set.
   */
  @java.lang.Override
  public boolean hasUuid() {
    return uuid_ != null;
  }
  /**
   * <code>.proto.UUID uuid = 2;</code>
   * @return The uuid.
   */
  @java.lang.Override
  public dev.yanshouwang.bluetooth_low_energy.proto.UUID getUuid() {
    return uuid_ == null ? dev.yanshouwang.bluetooth_low_energy.proto.UUID.getDefaultInstance() : uuid_;
  }
  /**
   * <code>.proto.UUID uuid = 2;</code>
   */
  @java.lang.Override
  public dev.yanshouwang.bluetooth_low_energy.proto.UUIDOrBuilder getUuidOrBuilder() {
    return getUuid();
  }

  public static final int CAN_READ_FIELD_NUMBER = 3;
  private boolean canRead_;
  /**
   * <code>bool can_read = 3;</code>
   * @return The canRead.
   */
  @java.lang.Override
  public boolean getCanRead() {
    return canRead_;
  }

  public static final int CAN_WRITE_FIELD_NUMBER = 4;
  private boolean canWrite_;
  /**
   * <code>bool can_write = 4;</code>
   * @return The canWrite.
   */
  @java.lang.Override
  public boolean getCanWrite() {
    return canWrite_;
  }

  public static final int CAN_WRITE_WITHOUT_RESPONSE_FIELD_NUMBER = 5;
  private boolean canWriteWithoutResponse_;
  /**
   * <code>bool can_write_without_response = 5;</code>
   * @return The canWriteWithoutResponse.
   */
  @java.lang.Override
  public boolean getCanWriteWithoutResponse() {
    return canWriteWithoutResponse_;
  }

  public static final int CAN_NOTIFY_FIELD_NUMBER = 6;
  private boolean canNotify_;
  /**
   * <code>bool can_notify = 6;</code>
   * @return The canNotify.
   */
  @java.lang.Override
  public boolean getCanNotify() {
    return canNotify_;
  }

  private byte memoizedIsInitialized = -1;
  @java.lang.Override
  public final boolean isInitialized() {
    byte isInitialized = memoizedIsInitialized;
    if (isInitialized == 1) return true;
    if (isInitialized == 0) return false;

    memoizedIsInitialized = 1;
    return true;
  }

  @java.lang.Override
  public void writeTo(com.google.protobuf.CodedOutputStream output)
                      throws java.io.IOException {
    if (!com.google.protobuf.GeneratedMessageV3.isStringEmpty(id_)) {
      com.google.protobuf.GeneratedMessageV3.writeString(output, 1, id_);
    }
    if (uuid_ != null) {
      output.writeMessage(2, getUuid());
    }
    if (canRead_ != false) {
      output.writeBool(3, canRead_);
    }
    if (canWrite_ != false) {
      output.writeBool(4, canWrite_);
    }
    if (canWriteWithoutResponse_ != false) {
      output.writeBool(5, canWriteWithoutResponse_);
    }
    if (canNotify_ != false) {
      output.writeBool(6, canNotify_);
    }
    unknownFields.writeTo(output);
  }

  @java.lang.Override
  public int getSerializedSize() {
    int size = memoizedSize;
    if (size != -1) return size;

    size = 0;
    if (!com.google.protobuf.GeneratedMessageV3.isStringEmpty(id_)) {
      size += com.google.protobuf.GeneratedMessageV3.computeStringSize(1, id_);
    }
    if (uuid_ != null) {
      size += com.google.protobuf.CodedOutputStream
        .computeMessageSize(2, getUuid());
    }
    if (canRead_ != false) {
      size += com.google.protobuf.CodedOutputStream
        .computeBoolSize(3, canRead_);
    }
    if (canWrite_ != false) {
      size += com.google.protobuf.CodedOutputStream
        .computeBoolSize(4, canWrite_);
    }
    if (canWriteWithoutResponse_ != false) {
      size += com.google.protobuf.CodedOutputStream
        .computeBoolSize(5, canWriteWithoutResponse_);
    }
    if (canNotify_ != false) {
      size += com.google.protobuf.CodedOutputStream
        .computeBoolSize(6, canNotify_);
    }
    size += unknownFields.getSerializedSize();
    memoizedSize = size;
    return size;
  }

  @java.lang.Override
  public boolean equals(final java.lang.Object obj) {
    if (obj == this) {
     return true;
    }
    if (!(obj instanceof dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic)) {
      return super.equals(obj);
    }
    dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic other = (dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic) obj;

    if (!getId()
        .equals(other.getId())) return false;
    if (hasUuid() != other.hasUuid()) return false;
    if (hasUuid()) {
      if (!getUuid()
          .equals(other.getUuid())) return false;
    }
    if (getCanRead()
        != other.getCanRead()) return false;
    if (getCanWrite()
        != other.getCanWrite()) return false;
    if (getCanWriteWithoutResponse()
        != other.getCanWriteWithoutResponse()) return false;
    if (getCanNotify()
        != other.getCanNotify()) return false;
    if (!unknownFields.equals(other.unknownFields)) return false;
    return true;
  }

  @java.lang.Override
  public int hashCode() {
    if (memoizedHashCode != 0) {
      return memoizedHashCode;
    }
    int hash = 41;
    hash = (19 * hash) + getDescriptor().hashCode();
    hash = (37 * hash) + ID_FIELD_NUMBER;
    hash = (53 * hash) + getId().hashCode();
    if (hasUuid()) {
      hash = (37 * hash) + UUID_FIELD_NUMBER;
      hash = (53 * hash) + getUuid().hashCode();
    }
    hash = (37 * hash) + CAN_READ_FIELD_NUMBER;
    hash = (53 * hash) + com.google.protobuf.Internal.hashBoolean(
        getCanRead());
    hash = (37 * hash) + CAN_WRITE_FIELD_NUMBER;
    hash = (53 * hash) + com.google.protobuf.Internal.hashBoolean(
        getCanWrite());
    hash = (37 * hash) + CAN_WRITE_WITHOUT_RESPONSE_FIELD_NUMBER;
    hash = (53 * hash) + com.google.protobuf.Internal.hashBoolean(
        getCanWriteWithoutResponse());
    hash = (37 * hash) + CAN_NOTIFY_FIELD_NUMBER;
    hash = (53 * hash) + com.google.protobuf.Internal.hashBoolean(
        getCanNotify());
    hash = (29 * hash) + unknownFields.hashCode();
    memoizedHashCode = hash;
    return hash;
  }

  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parseFrom(
      java.nio.ByteBuffer data)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data);
  }
  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parseFrom(
      java.nio.ByteBuffer data,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data, extensionRegistry);
  }
  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parseFrom(
      com.google.protobuf.ByteString data)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data);
  }
  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parseFrom(
      com.google.protobuf.ByteString data,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data, extensionRegistry);
  }
  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parseFrom(byte[] data)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data);
  }
  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parseFrom(
      byte[] data,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws com.google.protobuf.InvalidProtocolBufferException {
    return PARSER.parseFrom(data, extensionRegistry);
  }
  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parseFrom(java.io.InputStream input)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input);
  }
  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parseFrom(
      java.io.InputStream input,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input, extensionRegistry);
  }
  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parseDelimitedFrom(java.io.InputStream input)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseDelimitedWithIOException(PARSER, input);
  }
  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parseDelimitedFrom(
      java.io.InputStream input,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseDelimitedWithIOException(PARSER, input, extensionRegistry);
  }
  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parseFrom(
      com.google.protobuf.CodedInputStream input)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input);
  }
  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parseFrom(
      com.google.protobuf.CodedInputStream input,
      com.google.protobuf.ExtensionRegistryLite extensionRegistry)
      throws java.io.IOException {
    return com.google.protobuf.GeneratedMessageV3
        .parseWithIOException(PARSER, input, extensionRegistry);
  }

  @java.lang.Override
  public Builder newBuilderForType() { return newBuilder(); }
  public static Builder newBuilder() {
    return DEFAULT_INSTANCE.toBuilder();
  }
  public static Builder newBuilder(dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic prototype) {
    return DEFAULT_INSTANCE.toBuilder().mergeFrom(prototype);
  }
  @java.lang.Override
  public Builder toBuilder() {
    return this == DEFAULT_INSTANCE
        ? new Builder() : new Builder().mergeFrom(this);
  }

  @java.lang.Override
  protected Builder newBuilderForType(
      com.google.protobuf.GeneratedMessageV3.BuilderParent parent) {
    Builder builder = new Builder(parent);
    return builder;
  }
  /**
   * Protobuf type {@code proto.GattCharacteristic}
   */
  public static final class Builder extends
      com.google.protobuf.GeneratedMessageV3.Builder<Builder> implements
      // @@protoc_insertion_point(builder_implements:proto.GattCharacteristic)
      dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristicOrBuilder {
    public static final com.google.protobuf.Descriptors.Descriptor
        getDescriptor() {
      return dev.yanshouwang.bluetooth_low_energy.proto.Messages.internal_static_proto_GattCharacteristic_descriptor;
    }

    @java.lang.Override
    protected com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
        internalGetFieldAccessorTable() {
      return dev.yanshouwang.bluetooth_low_energy.proto.Messages.internal_static_proto_GattCharacteristic_fieldAccessorTable
          .ensureFieldAccessorsInitialized(
              dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic.class, dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic.Builder.class);
    }

    // Construct using dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic.newBuilder()
    private Builder() {
      maybeForceBuilderInitialization();
    }

    private Builder(
        com.google.protobuf.GeneratedMessageV3.BuilderParent parent) {
      super(parent);
      maybeForceBuilderInitialization();
    }
    private void maybeForceBuilderInitialization() {
      if (com.google.protobuf.GeneratedMessageV3
              .alwaysUseFieldBuilders) {
      }
    }
    @java.lang.Override
    public Builder clear() {
      super.clear();
      id_ = "";

      if (uuidBuilder_ == null) {
        uuid_ = null;
      } else {
        uuid_ = null;
        uuidBuilder_ = null;
      }
      canRead_ = false;

      canWrite_ = false;

      canWriteWithoutResponse_ = false;

      canNotify_ = false;

      return this;
    }

    @java.lang.Override
    public com.google.protobuf.Descriptors.Descriptor
        getDescriptorForType() {
      return dev.yanshouwang.bluetooth_low_energy.proto.Messages.internal_static_proto_GattCharacteristic_descriptor;
    }

    @java.lang.Override
    public dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic getDefaultInstanceForType() {
      return dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic.getDefaultInstance();
    }

    @java.lang.Override
    public dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic build() {
      dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic result = buildPartial();
      if (!result.isInitialized()) {
        throw newUninitializedMessageException(result);
      }
      return result;
    }

    @java.lang.Override
    public dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic buildPartial() {
      dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic result = new dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic(this);
      result.id_ = id_;
      if (uuidBuilder_ == null) {
        result.uuid_ = uuid_;
      } else {
        result.uuid_ = uuidBuilder_.build();
      }
      result.canRead_ = canRead_;
      result.canWrite_ = canWrite_;
      result.canWriteWithoutResponse_ = canWriteWithoutResponse_;
      result.canNotify_ = canNotify_;
      onBuilt();
      return result;
    }

    @java.lang.Override
    public Builder clone() {
      return super.clone();
    }
    @java.lang.Override
    public Builder setField(
        com.google.protobuf.Descriptors.FieldDescriptor field,
        java.lang.Object value) {
      return super.setField(field, value);
    }
    @java.lang.Override
    public Builder clearField(
        com.google.protobuf.Descriptors.FieldDescriptor field) {
      return super.clearField(field);
    }
    @java.lang.Override
    public Builder clearOneof(
        com.google.protobuf.Descriptors.OneofDescriptor oneof) {
      return super.clearOneof(oneof);
    }
    @java.lang.Override
    public Builder setRepeatedField(
        com.google.protobuf.Descriptors.FieldDescriptor field,
        int index, java.lang.Object value) {
      return super.setRepeatedField(field, index, value);
    }
    @java.lang.Override
    public Builder addRepeatedField(
        com.google.protobuf.Descriptors.FieldDescriptor field,
        java.lang.Object value) {
      return super.addRepeatedField(field, value);
    }
    @java.lang.Override
    public Builder mergeFrom(com.google.protobuf.Message other) {
      if (other instanceof dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic) {
        return mergeFrom((dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic)other);
      } else {
        super.mergeFrom(other);
        return this;
      }
    }

    public Builder mergeFrom(dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic other) {
      if (other == dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic.getDefaultInstance()) return this;
      if (!other.getId().isEmpty()) {
        id_ = other.id_;
        onChanged();
      }
      if (other.hasUuid()) {
        mergeUuid(other.getUuid());
      }
      if (other.getCanRead() != false) {
        setCanRead(other.getCanRead());
      }
      if (other.getCanWrite() != false) {
        setCanWrite(other.getCanWrite());
      }
      if (other.getCanWriteWithoutResponse() != false) {
        setCanWriteWithoutResponse(other.getCanWriteWithoutResponse());
      }
      if (other.getCanNotify() != false) {
        setCanNotify(other.getCanNotify());
      }
      this.mergeUnknownFields(other.unknownFields);
      onChanged();
      return this;
    }

    @java.lang.Override
    public final boolean isInitialized() {
      return true;
    }

    @java.lang.Override
    public Builder mergeFrom(
        com.google.protobuf.CodedInputStream input,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws java.io.IOException {
      dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic parsedMessage = null;
      try {
        parsedMessage = PARSER.parsePartialFrom(input, extensionRegistry);
      } catch (com.google.protobuf.InvalidProtocolBufferException e) {
        parsedMessage = (dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic) e.getUnfinishedMessage();
        throw e.unwrapIOException();
      } finally {
        if (parsedMessage != null) {
          mergeFrom(parsedMessage);
        }
      }
      return this;
    }

    private java.lang.Object id_ = "";
    /**
     * <code>string id = 1;</code>
     * @return The id.
     */
    public java.lang.String getId() {
      java.lang.Object ref = id_;
      if (!(ref instanceof java.lang.String)) {
        com.google.protobuf.ByteString bs =
            (com.google.protobuf.ByteString) ref;
        java.lang.String s = bs.toStringUtf8();
        id_ = s;
        return s;
      } else {
        return (java.lang.String) ref;
      }
    }
    /**
     * <code>string id = 1;</code>
     * @return The bytes for id.
     */
    public com.google.protobuf.ByteString
        getIdBytes() {
      java.lang.Object ref = id_;
      if (ref instanceof String) {
        com.google.protobuf.ByteString b = 
            com.google.protobuf.ByteString.copyFromUtf8(
                (java.lang.String) ref);
        id_ = b;
        return b;
      } else {
        return (com.google.protobuf.ByteString) ref;
      }
    }
    /**
     * <code>string id = 1;</code>
     * @param value The id to set.
     * @return This builder for chaining.
     */
    public Builder setId(
        java.lang.String value) {
      if (value == null) {
    throw new NullPointerException();
  }
  
      id_ = value;
      onChanged();
      return this;
    }
    /**
     * <code>string id = 1;</code>
     * @return This builder for chaining.
     */
    public Builder clearId() {
      
      id_ = getDefaultInstance().getId();
      onChanged();
      return this;
    }
    /**
     * <code>string id = 1;</code>
     * @param value The bytes for id to set.
     * @return This builder for chaining.
     */
    public Builder setIdBytes(
        com.google.protobuf.ByteString value) {
      if (value == null) {
    throw new NullPointerException();
  }
  checkByteStringIsUtf8(value);
      
      id_ = value;
      onChanged();
      return this;
    }

    private dev.yanshouwang.bluetooth_low_energy.proto.UUID uuid_;
    private com.google.protobuf.SingleFieldBuilderV3<
        dev.yanshouwang.bluetooth_low_energy.proto.UUID, dev.yanshouwang.bluetooth_low_energy.proto.UUID.Builder, dev.yanshouwang.bluetooth_low_energy.proto.UUIDOrBuilder> uuidBuilder_;
    /**
     * <code>.proto.UUID uuid = 2;</code>
     * @return Whether the uuid field is set.
     */
    public boolean hasUuid() {
      return uuidBuilder_ != null || uuid_ != null;
    }
    /**
     * <code>.proto.UUID uuid = 2;</code>
     * @return The uuid.
     */
    public dev.yanshouwang.bluetooth_low_energy.proto.UUID getUuid() {
      if (uuidBuilder_ == null) {
        return uuid_ == null ? dev.yanshouwang.bluetooth_low_energy.proto.UUID.getDefaultInstance() : uuid_;
      } else {
        return uuidBuilder_.getMessage();
      }
    }
    /**
     * <code>.proto.UUID uuid = 2;</code>
     */
    public Builder setUuid(dev.yanshouwang.bluetooth_low_energy.proto.UUID value) {
      if (uuidBuilder_ == null) {
        if (value == null) {
          throw new NullPointerException();
        }
        uuid_ = value;
        onChanged();
      } else {
        uuidBuilder_.setMessage(value);
      }

      return this;
    }
    /**
     * <code>.proto.UUID uuid = 2;</code>
     */
    public Builder setUuid(
        dev.yanshouwang.bluetooth_low_energy.proto.UUID.Builder builderForValue) {
      if (uuidBuilder_ == null) {
        uuid_ = builderForValue.build();
        onChanged();
      } else {
        uuidBuilder_.setMessage(builderForValue.build());
      }

      return this;
    }
    /**
     * <code>.proto.UUID uuid = 2;</code>
     */
    public Builder mergeUuid(dev.yanshouwang.bluetooth_low_energy.proto.UUID value) {
      if (uuidBuilder_ == null) {
        if (uuid_ != null) {
          uuid_ =
            dev.yanshouwang.bluetooth_low_energy.proto.UUID.newBuilder(uuid_).mergeFrom(value).buildPartial();
        } else {
          uuid_ = value;
        }
        onChanged();
      } else {
        uuidBuilder_.mergeFrom(value);
      }

      return this;
    }
    /**
     * <code>.proto.UUID uuid = 2;</code>
     */
    public Builder clearUuid() {
      if (uuidBuilder_ == null) {
        uuid_ = null;
        onChanged();
      } else {
        uuid_ = null;
        uuidBuilder_ = null;
      }

      return this;
    }
    /**
     * <code>.proto.UUID uuid = 2;</code>
     */
    public dev.yanshouwang.bluetooth_low_energy.proto.UUID.Builder getUuidBuilder() {
      
      onChanged();
      return getUuidFieldBuilder().getBuilder();
    }
    /**
     * <code>.proto.UUID uuid = 2;</code>
     */
    public dev.yanshouwang.bluetooth_low_energy.proto.UUIDOrBuilder getUuidOrBuilder() {
      if (uuidBuilder_ != null) {
        return uuidBuilder_.getMessageOrBuilder();
      } else {
        return uuid_ == null ?
            dev.yanshouwang.bluetooth_low_energy.proto.UUID.getDefaultInstance() : uuid_;
      }
    }
    /**
     * <code>.proto.UUID uuid = 2;</code>
     */
    private com.google.protobuf.SingleFieldBuilderV3<
        dev.yanshouwang.bluetooth_low_energy.proto.UUID, dev.yanshouwang.bluetooth_low_energy.proto.UUID.Builder, dev.yanshouwang.bluetooth_low_energy.proto.UUIDOrBuilder> 
        getUuidFieldBuilder() {
      if (uuidBuilder_ == null) {
        uuidBuilder_ = new com.google.protobuf.SingleFieldBuilderV3<
            dev.yanshouwang.bluetooth_low_energy.proto.UUID, dev.yanshouwang.bluetooth_low_energy.proto.UUID.Builder, dev.yanshouwang.bluetooth_low_energy.proto.UUIDOrBuilder>(
                getUuid(),
                getParentForChildren(),
                isClean());
        uuid_ = null;
      }
      return uuidBuilder_;
    }

    private boolean canRead_ ;
    /**
     * <code>bool can_read = 3;</code>
     * @return The canRead.
     */
    @java.lang.Override
    public boolean getCanRead() {
      return canRead_;
    }
    /**
     * <code>bool can_read = 3;</code>
     * @param value The canRead to set.
     * @return This builder for chaining.
     */
    public Builder setCanRead(boolean value) {
      
      canRead_ = value;
      onChanged();
      return this;
    }
    /**
     * <code>bool can_read = 3;</code>
     * @return This builder for chaining.
     */
    public Builder clearCanRead() {
      
      canRead_ = false;
      onChanged();
      return this;
    }

    private boolean canWrite_ ;
    /**
     * <code>bool can_write = 4;</code>
     * @return The canWrite.
     */
    @java.lang.Override
    public boolean getCanWrite() {
      return canWrite_;
    }
    /**
     * <code>bool can_write = 4;</code>
     * @param value The canWrite to set.
     * @return This builder for chaining.
     */
    public Builder setCanWrite(boolean value) {
      
      canWrite_ = value;
      onChanged();
      return this;
    }
    /**
     * <code>bool can_write = 4;</code>
     * @return This builder for chaining.
     */
    public Builder clearCanWrite() {
      
      canWrite_ = false;
      onChanged();
      return this;
    }

    private boolean canWriteWithoutResponse_ ;
    /**
     * <code>bool can_write_without_response = 5;</code>
     * @return The canWriteWithoutResponse.
     */
    @java.lang.Override
    public boolean getCanWriteWithoutResponse() {
      return canWriteWithoutResponse_;
    }
    /**
     * <code>bool can_write_without_response = 5;</code>
     * @param value The canWriteWithoutResponse to set.
     * @return This builder for chaining.
     */
    public Builder setCanWriteWithoutResponse(boolean value) {
      
      canWriteWithoutResponse_ = value;
      onChanged();
      return this;
    }
    /**
     * <code>bool can_write_without_response = 5;</code>
     * @return This builder for chaining.
     */
    public Builder clearCanWriteWithoutResponse() {
      
      canWriteWithoutResponse_ = false;
      onChanged();
      return this;
    }

    private boolean canNotify_ ;
    /**
     * <code>bool can_notify = 6;</code>
     * @return The canNotify.
     */
    @java.lang.Override
    public boolean getCanNotify() {
      return canNotify_;
    }
    /**
     * <code>bool can_notify = 6;</code>
     * @param value The canNotify to set.
     * @return This builder for chaining.
     */
    public Builder setCanNotify(boolean value) {
      
      canNotify_ = value;
      onChanged();
      return this;
    }
    /**
     * <code>bool can_notify = 6;</code>
     * @return This builder for chaining.
     */
    public Builder clearCanNotify() {
      
      canNotify_ = false;
      onChanged();
      return this;
    }
    @java.lang.Override
    public final Builder setUnknownFields(
        final com.google.protobuf.UnknownFieldSet unknownFields) {
      return super.setUnknownFields(unknownFields);
    }

    @java.lang.Override
    public final Builder mergeUnknownFields(
        final com.google.protobuf.UnknownFieldSet unknownFields) {
      return super.mergeUnknownFields(unknownFields);
    }


    // @@protoc_insertion_point(builder_scope:proto.GattCharacteristic)
  }

  // @@protoc_insertion_point(class_scope:proto.GattCharacteristic)
  private static final dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic DEFAULT_INSTANCE;
  static {
    DEFAULT_INSTANCE = new dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic();
  }

  public static dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic getDefaultInstance() {
    return DEFAULT_INSTANCE;
  }

  private static final com.google.protobuf.Parser<GattCharacteristic>
      PARSER = new com.google.protobuf.AbstractParser<GattCharacteristic>() {
    @java.lang.Override
    public GattCharacteristic parsePartialFrom(
        com.google.protobuf.CodedInputStream input,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws com.google.protobuf.InvalidProtocolBufferException {
      return new GattCharacteristic(input, extensionRegistry);
    }
  };

  public static com.google.protobuf.Parser<GattCharacteristic> parser() {
    return PARSER;
  }

  @java.lang.Override
  public com.google.protobuf.Parser<GattCharacteristic> getParserForType() {
    return PARSER;
  }

  @java.lang.Override
  public dev.yanshouwang.bluetooth_low_energy.proto.GattCharacteristic getDefaultInstanceForType() {
    return DEFAULT_INSTANCE;
  }

}

