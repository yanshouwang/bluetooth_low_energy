//
//  L2CAPChannelHandler.swift
//  bluetooth_low_energy_darwin
//
//  Pumps bytes over a CBL2CAPChannel's input/output streams.
//

import Foundation
import CoreBluetooth

// Owns a single CBL2CAPChannel and bridges its NSStream pair to byte callbacks.
//
// The streams are scheduled on the main run loop: the package creates its
// CBCentralManager with no dispatch queue, so CoreBluetooth delegate callbacks
// (including didOpen) run on the main thread - handling the streams there keeps
// everything single-threaded and avoids cross-thread access to the channel.
class L2CAPChannelHandler: NSObject, StreamDelegate {
    private let mChannel: CBL2CAPChannel
    private let mOnReceived: (Data) -> Void
    private let mOnClosed: (Error?) -> Void

    private let mInput: InputStream
    private let mOutput: OutputStream
    private var mWriteQueue: [(data: Data, offset: Int, completion: (Result<Void, Error>) -> Void)] = []
    private var mClosed = false
    private let mReadBufferSize = 8192

    init(channel: CBL2CAPChannel,
         onReceived: @escaping (Data) -> Void,
         onClosed: @escaping (Error?) -> Void) {
        self.mChannel = channel
        self.mOnReceived = onReceived
        self.mOnClosed = onClosed
        self.mInput = channel.inputStream
        self.mOutput = channel.outputStream
        super.init()
        self.mInput.delegate = self
        self.mOutput.delegate = self
        self.mInput.schedule(in: .main, forMode: .default)
        self.mOutput.schedule(in: .main, forMode: .default)
        self.mInput.open()
        self.mOutput.open()
    }

    func write(_ data: Data, completion: @escaping (Result<Void, Error>) -> Void) {
        if self.mClosed {
            completion(.failure(BluetoothLowEnergyError.unknown))
            return
        }
        self.mWriteQueue.append((data: data, offset: 0, completion: completion))
        self.flush()
    }

    func close() {
        self.closeWith(error: nil)
    }

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            self.readAvailable()
        case .hasSpaceAvailable:
            self.flush()
        case .endEncountered:
            self.closeWith(error: nil)
        case .errorOccurred:
            self.closeWith(error: aStream.streamError ?? BluetoothLowEnergyError.unknown)
        default:
            break
        }
    }

    private func readAvailable() {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: self.mReadBufferSize)
        defer { buffer.deallocate() }
        while self.mInput.hasBytesAvailable {
            let read = self.mInput.read(buffer, maxLength: self.mReadBufferSize)
            if read > 0 {
                self.mOnReceived(Data(bytes: buffer, count: read))
            } else {
                break
            }
        }
    }

    private func flush() {
        while !self.mWriteQueue.isEmpty, self.mOutput.hasSpaceAvailable {
            var item = self.mWriteQueue[0]
            let remaining = item.data.count - item.offset
            if remaining <= 0 {
                item.completion(.success(()))
                self.mWriteQueue.removeFirst()
                continue
            }
            let written = item.data.withUnsafeBytes { (raw: UnsafeRawBufferPointer) -> Int in
                guard let base = raw.bindMemory(to: UInt8.self).baseAddress else { return 0 }
                return self.mOutput.write(base + item.offset, maxLength: remaining)
            }
            if written > 0 {
                item.offset += written
                if item.offset >= item.data.count {
                    item.completion(.success(()))
                    self.mWriteQueue.removeFirst()
                } else {
                    self.mWriteQueue[0] = item
                    break
                }
            } else {
                break
            }
        }
    }

    private func closeWith(error: Error?) {
        if self.mClosed { return }
        self.mClosed = true
        self.mInput.close()
        self.mOutput.close()
        self.mInput.remove(from: .main, forMode: .default)
        self.mOutput.remove(from: .main, forMode: .default)
        self.mInput.delegate = nil
        self.mOutput.delegate = nil
        let failure = error ?? BluetoothLowEnergyError.unknown
        for item in self.mWriteQueue {
            item.completion(.failure(failure))
        }
        self.mWriteQueue.removeAll()
        self.mOnClosed(error)
    }
}
