//
//  Data+Helpers.swift
//  MemoryChain
//
//  Created by Marc Zhao on 2018/8/4.
//  Copyright © 2018年 Memory Chain technology(China) co,LTD. All rights reserved.
//

import Foundation

public extension Data {
    
    /// raw bytes
    var rawBytes: [UInt8] {
        let count = self.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        (self as NSData).getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
        return bytesArray
    }
    //MARK: - init method to define here 
    init(bytes: [UInt8]) {
        self.init(bytes:bytes, count: bytes.count)
    }
    
    /// append bytes
    /// - Parameter bytes: data append bytes
    mutating func append(_ bytes: [UInt8]) {
        self.append(bytes, count: bytes.count)
    }
}

public extension Data {
    /// A convenience method to append string to `Data` using specified encoding.
    ///
    /// - Parameters:
    ///   - string: The string to be added to the `Data`.
    ///   - encoding: The encoding to use for representing the specified string.
    ///               The default value is `.utf8`.
    ///   - allowLossyConversion: A boolean value to determine lossy conversion.
    ///                           The default value is `false`.
     mutating func append(_ string: String, encoding: String.Encoding = .utf8, allowLossyConversion: Bool = false) {
        guard let newData = string.data(using: encoding, allowLossyConversion: allowLossyConversion) else { return }
        append(newData)
    }
}

public extension Data {
    
    /// bytes- convert data to bytes
    var bytes:[UInt8] {
        return [UInt8](self)
    }
}


public extension Data {
    
    /// hex to encoded string
    /// - Returns: return string
    func hexToEncodedString() ->String {
        let hexDigits = Array("0123456789abcdef".utf16)
               var hexChars = [UTF16.CodeUnit]()
               hexChars.reserveCapacity(count * 2)

               for byte in self {
                   let (index1, index2) = Int(byte).quotientAndRemainder(dividingBy: 16)
                   hexChars.insert(hexDigits[index2], at: 0)
                   hexChars.insert(hexDigits[index1], at: 0)
               }
               return String(utf16CodeUnits: hexChars, count: hexChars.count)
           }
    }





public extension Data {
    
    var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            self.copyBytes(to:&number, count: MemoryLayout<UInt8>.size)
            return number
        }
    }
    
    var uint16: UInt16 {
        get {
            let i16array = self.withUnsafeBytes { $0.load(as: UInt16.self) }
            return i16array
        }
    }
    
    var uint32: UInt32 {
        get {
            let i32array = self.withUnsafeBytes { $0.load(as: UInt32.self) }
            return i32array
        }
    }
    
    var uuid: NSUUID? {
        get {
            var bytes = [UInt8](repeating: 0, count: self.count)
            self.copyBytes(to:&bytes, count: self.count * MemoryLayout<UInt32>.size)
            return NSUUID(uuidBytes: bytes)
        }
    }
    var stringASCII: String? {
        get {
            return NSString(data: self, encoding: String.Encoding.ascii.rawValue) as String?
        }
    }
    
    var stringUTF8: String? {
        get {
            return NSString(data: self, encoding: String.Encoding.utf8.rawValue) as String?
        }
    }

    struct HexEncodingOptions: OptionSet {
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        public let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
    
}


public extension Data {
    var stringValue: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
    var base64EncodedString: String? {
        return self.base64EncodedString(options: .lineLength64Characters)
    }

    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.

    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }


}
//https://stackoverflow.com/questions/33145798/how-to-get-mac-address-from-cbperipheral-and-cbcenter
public extension Data{
    func hexEncodedString() -> String {
            let hexDigits = Array("0123456789abcdef".utf16)
            var hexChars = [UTF16.CodeUnit]()
            hexChars.reserveCapacity(count * 2)

            for byte in self {
                let (index1, index2) = Int(byte).quotientAndRemainder(dividingBy: 16)
                hexChars.insert(hexDigits[index2], at: 0)
                hexChars.insert(hexDigits[index1], at: 0)
            }
            return String(utf16CodeUnits: hexChars, count: hexChars.count)
        }
}
