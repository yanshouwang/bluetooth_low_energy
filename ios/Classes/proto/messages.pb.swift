// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: proto/messages.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Proto_Advertisement {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var peripheral: Proto_Peripheral {
    get {return _peripheral ?? Proto_Peripheral()}
    set {_peripheral = newValue}
  }
  /// Returns true if `peripheral` has been explicitly set.
  var hasPeripheral: Bool {return self._peripheral != nil}
  /// Clears the value of `peripheral`. Subsequent reads from it will return its default value.
  mutating func clearPeripheral() {self._peripheral = nil}

  var data: Dictionary<Int32,Data> = [:]

  var rssi: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _peripheral: Proto_Peripheral? = nil
}

struct Proto_Peripheral {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var id: String = String()

  var uuid: String = String()

  var connectable: Bool = false

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Proto_GattService {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var id: String = String()

  var uuid: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Proto_GattCharacteristic {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var id: String = String()

  var uuid: String = String()

  var canRead: Bool = false

  var canWrite: Bool = false

  var canWriteWithoutResponse: Bool = false

  var canNotify: Bool = false

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Proto_GattDescriptor {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var id: String = String()

  var uuid: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Proto_Advertisement: @unchecked Sendable {}
extension Proto_Peripheral: @unchecked Sendable {}
extension Proto_GattService: @unchecked Sendable {}
extension Proto_GattCharacteristic: @unchecked Sendable {}
extension Proto_GattDescriptor: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "proto"

extension Proto_Advertisement: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Advertisement"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "peripheral"),
    2: .same(proto: "data"),
    3: .same(proto: "rssi"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._peripheral) }()
      case 2: try { try decoder.decodeMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufInt32,SwiftProtobuf.ProtobufBytes>.self, value: &self.data) }()
      case 3: try { try decoder.decodeSingularInt32Field(value: &self.rssi) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._peripheral {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    if !self.data.isEmpty {
      try visitor.visitMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufInt32,SwiftProtobuf.ProtobufBytes>.self, value: self.data, fieldNumber: 2)
    }
    if self.rssi != 0 {
      try visitor.visitSingularInt32Field(value: self.rssi, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Proto_Advertisement, rhs: Proto_Advertisement) -> Bool {
    if lhs._peripheral != rhs._peripheral {return false}
    if lhs.data != rhs.data {return false}
    if lhs.rssi != rhs.rssi {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Proto_Peripheral: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Peripheral"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "uuid"),
    4: .same(proto: "connectable"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.id) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.uuid) }()
      case 4: try { try decoder.decodeSingularBoolField(value: &self.connectable) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.id.isEmpty {
      try visitor.visitSingularStringField(value: self.id, fieldNumber: 1)
    }
    if !self.uuid.isEmpty {
      try visitor.visitSingularStringField(value: self.uuid, fieldNumber: 2)
    }
    if self.connectable != false {
      try visitor.visitSingularBoolField(value: self.connectable, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Proto_Peripheral, rhs: Proto_Peripheral) -> Bool {
    if lhs.id != rhs.id {return false}
    if lhs.uuid != rhs.uuid {return false}
    if lhs.connectable != rhs.connectable {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Proto_GattService: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".GattService"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "uuid"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.id) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.uuid) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.id.isEmpty {
      try visitor.visitSingularStringField(value: self.id, fieldNumber: 1)
    }
    if !self.uuid.isEmpty {
      try visitor.visitSingularStringField(value: self.uuid, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Proto_GattService, rhs: Proto_GattService) -> Bool {
    if lhs.id != rhs.id {return false}
    if lhs.uuid != rhs.uuid {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Proto_GattCharacteristic: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".GattCharacteristic"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "uuid"),
    3: .standard(proto: "can_read"),
    4: .standard(proto: "can_write"),
    5: .standard(proto: "can_write_without_response"),
    6: .standard(proto: "can_notify"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.id) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.uuid) }()
      case 3: try { try decoder.decodeSingularBoolField(value: &self.canRead) }()
      case 4: try { try decoder.decodeSingularBoolField(value: &self.canWrite) }()
      case 5: try { try decoder.decodeSingularBoolField(value: &self.canWriteWithoutResponse) }()
      case 6: try { try decoder.decodeSingularBoolField(value: &self.canNotify) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.id.isEmpty {
      try visitor.visitSingularStringField(value: self.id, fieldNumber: 1)
    }
    if !self.uuid.isEmpty {
      try visitor.visitSingularStringField(value: self.uuid, fieldNumber: 2)
    }
    if self.canRead != false {
      try visitor.visitSingularBoolField(value: self.canRead, fieldNumber: 3)
    }
    if self.canWrite != false {
      try visitor.visitSingularBoolField(value: self.canWrite, fieldNumber: 4)
    }
    if self.canWriteWithoutResponse != false {
      try visitor.visitSingularBoolField(value: self.canWriteWithoutResponse, fieldNumber: 5)
    }
    if self.canNotify != false {
      try visitor.visitSingularBoolField(value: self.canNotify, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Proto_GattCharacteristic, rhs: Proto_GattCharacteristic) -> Bool {
    if lhs.id != rhs.id {return false}
    if lhs.uuid != rhs.uuid {return false}
    if lhs.canRead != rhs.canRead {return false}
    if lhs.canWrite != rhs.canWrite {return false}
    if lhs.canWriteWithoutResponse != rhs.canWriteWithoutResponse {return false}
    if lhs.canNotify != rhs.canNotify {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Proto_GattDescriptor: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".GattDescriptor"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "uuid"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.id) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.uuid) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.id.isEmpty {
      try visitor.visitSingularStringField(value: self.id, fieldNumber: 1)
    }
    if !self.uuid.isEmpty {
      try visitor.visitSingularStringField(value: self.uuid, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Proto_GattDescriptor, rhs: Proto_GattDescriptor) -> Bool {
    if lhs.id != rhs.id {return false}
    if lhs.uuid != rhs.uuid {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
