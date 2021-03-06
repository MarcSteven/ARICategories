//
//  Array+RemoveIndex.swift
//  MemoryChainKit
//
//  Created by Marc Zhao on 2019/1/5.
//  Copyright © 2019 Memory Chain technology(China) co,LTD. All rights reserved.
//

import Foundation
//Remove multiple indexes from Array
public extension Array {
    
    /// remove the element via index
    /// - Parameter indexs: index of the element 
     mutating func remove(at indexs:Set<Int>) {
        for i in Array<Int>(indexs).sorted(by: >) {
            self.remove(at: i)
        }
    }
    
    //Array方法扩展，支持根据索引数组删除
    
     mutating func removeAtIndexes(indexs: [Int]) {
        let sorted = indexs.sorted(by: { $1 < $0 })
        for index in sorted {
            self.remove(at: index)
        }
    }
}
public extension Array {
//    subscript method to get the element
    subscript(guarded index:Int) ->Element? {
        guard (startIndex..<endIndex).contains(index) else {
            return nil
        }
        return self[index]
    }
}



public extension Array {
    /// Returns a random subarray of given length.
    ///
    /// - Parameter count: Number of random elements to return.
    /// - Returns: Random subarray of length n.
     func randomElements(count: Int = 1) -> Self {
        let size = count
        let count = self.count

        if size >= count {
            return shuffled()
        }

        let index = Int.random(in: 0..<(count - size))
        return self[index..<(size + index)].shuffled()
    }

    /// Returns a random element from `self`.
     func randomElement() -> Element {
        let randomIndex = Int(arc4random()) % count
        return self[randomIndex]
    }

    /// Split array by chunks of given size.
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    /// let chunks = array.splitBy(5)
    /// print(chunks) // [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12]]
    /// ```
    /// - seealso: https://gist.github.com/ericdke/fa262bdece59ff786fcb
     func splitBy(_ subSize: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: subSize).map { startIndex in
            let endIndex = index(startIndex, offsetBy: subSize, limitedBy: count) ?? startIndex + (count - startIndex)
            return Array(self[startIndex..<endIndex])
        }
    }

     func firstElement<T>(type: T.Type) -> T? {
        for element in self {
            if let element = element as? T {
                return element
            }
        }

        return nil
    }

     func lastElement<T>(type: T.Type) -> T? {
        for element in reversed() {
            if let element = element as? T {
                return element
            }
        }

        return nil
    }
}

public extension Array where Element: NSObjectProtocol {
    /// Returns the first index where the specified value appears in the
    /// collection.
    ///
    /// After using `firstIndex(of:)` to find the position of a particular element in
    /// a collection, you can use it to access the element by subscripting. This
    /// example shows how you can pop one of the view controller from the `UINavigationController`.
    ///
    /// ```swift
    /// let navigationController = UINavigationController()
    /// if let index = navigationController.viewControllers.firstIndex(of: SearchViewController.self) {
    ///     navigationController.popToViewController(at: index, animated: true)
    /// }
    /// ```
    ///
    /// - Parameter elementType: An element type to search for in the collection.
    /// - Returns: The first index where `element` is found. If `element` is not
    ///   found in the collection, returns `nil`.
     func firstIndex(of elementType: Element.Type) -> Int? {
        firstIndex { $0.isKind(of: elementType) }
    }

    /// Returns the last index where the specified value appears in the
    /// collection.
    ///
    /// After using `lastIndex(of:)` to find the position of a particular element in
    /// a collection, you can use it to access the element by subscripting. This
    /// example shows how you can pop one of the view controller from the `UINavigationController`.
    ///
    /// ```swift
    /// let navigationController = UINavigationController()
    /// if let index = navigationController.viewControllers.lastIndex(of: SearchViewController.self) {
    ///     navigationController.popToViewController(at: index, animated: true)
    /// }
    /// ```
    ///
    /// - Parameter elementType: An element type to search for in the collection.
    /// - Returns: The last index where `element` is found. If `element` is not
    ///   found in the collection, returns `nil`.
    func lastIndex(of elementType: Element.Type) -> Int? {
        lastIndex { $0.isKind(of: elementType) }
    }

    /// Returns a boolean value indicating whether the sequence contains an element
    /// that exists in the given parameter.
    ///
    /// ```swift
    /// let navigationController = UINavigationController()
    /// if navigationController.viewControllers.contains(any: [SearchViewController.self, HomeViewController.self]) {
    ///     _ = navigationController?.popToRootViewController(animated: true)
    /// }
    /// ```
    ///
    /// - Parameter any: An array of element types to search for in the collection.
    /// - Returns: `true` if the sequence contains an element; otherwise, `false`.
    func contains(any elementTypes: [Element.Type]) -> Bool {
        for element in self {
            if elementTypes.contains(where: { element.isKind(of: $0) }) {
                return true
            }
        }

        return false
    }
}

public extension Array where Element: Equatable {
    /// Sorts the collection in place, using the given preferred order as the comparison between elements.
    ///
    /// ```swift
    /// let preferredOrder = ["Z", "A", "B", "C", "D"]
    /// var alphabets = ["D", "C", "B", "A", "Z", "W"]
    /// alphabets.sort(by: preferredOrder)
    /// print(alphabets)
    /// // Prints ["Z", "A", "B", "C", "D", "W"]
    /// ```
    ///
    /// - Parameter preferredOrder: The ordered elements, which will be used to sort the sequence’s elements.
     mutating func sort(by preferredOrder: Self) {
        sort { (a, b) -> Bool in
            guard
                let first = preferredOrder.firstIndex(of: a),
                let second = preferredOrder.firstIndex(of: b)
            else {
                return false
            }

            return first < second
        }
    }

    // Credit: https://stackoverflow.com/a/51683055

    /// Returns the elements of the sequence, sorted using the given preferred order as the
    /// comparison between elements.
    ///
    /// ```swift
    /// let preferredOrder = ["Z", "A", "B", "C", "D"]
    /// let alphabets = ["D", "C", "B", "A", "Z", "W"]
    /// let sorted = alphabets.sorted(by: preferredOrder)
    /// print(sorted)
    /// // Prints ["Z", "A", "B", "C", "D", "W"]
    /// ```
    ///
    /// - Parameter preferredOrder: The ordered elements, which will be used to sort the sequence’s elements.
    /// - Returns: A sorted array of the sequence’s elements.
     func sorted(by preferredOrder: Self) -> Self {
        sorted { (a, b) -> Bool in
            guard
                let first = preferredOrder.firstIndex(of: a),
                let second = preferredOrder.firstIndex(of: b)
            else {
                return false
            }

            return first < second
        }
    }
}

public extension Array where Element: RawRepresentable {
    /// Return an array containing all corresponding `rawValue`s of `self`.
     var rawValues: [Element.RawValue] {
        map { $0.rawValue }
    }
}


public extension Array {
    
    /// binary search
    /// - Parameters:
    ///   - target: target
    ///   - transform: transform
    ///   - comparison: comparisipon
    /// - Returns: return the data
     func binarySearch<T>(target: T, transform: (Element) -> T, _ comparison: (T, T) -> ComparisonResult) -> Int? {
        var localRange = 0..<count

        while localRange.startIndex < localRange.endIndex {
            // Find the middle point in the array within the given range
            let midIndex: Int = localRange.startIndex + (localRange.endIndex - localRange.startIndex) / 2
            let comparableObject = transform(self[midIndex])
            let result = comparison(comparableObject, target)
            switch result {
                case .orderedSame:
                    // If we found our search key, return the index
                    return midIndex
                case .orderedAscending:
                    // If the middle value is less than the target, look at the right half
                    localRange = (midIndex + 1)..<localRange.endIndex
                case .orderedDescending:
                    // If the midle value is greater than the target, look at the left half
                    localRange = localRange.startIndex..<midIndex
            }
        }
        return nil
    }
}


public extension Array where Element  == UInt8 {
    
    /// data
    var data:Data {
        return Data(self)
    }
}

public extension Array where Element == UInt8 {
    
    /// convert bytes to hex
    /// - Parameter spacing: space
    /// - Returns: return hex string
 func bytesToHex(spacing: String) -> String {
   var hexString: String = ""
   var count = self.count
   for byte in self
   {
       hexString.append(String(format:"%02X", byte))
       count = count - 1
       if count > 0
       {
           hexString.append(spacing)
       }
   }
   return hexString
}

}

//https://stackoverflow.com/questions/29727618/find-duplicate-elements-in-array-using-swift
public extension Array where Element: Hashable {
    func duplicates() -> Array {
        let groups = Dictionary(grouping: self, by: {$0})
        let duplicateGroups = groups.filter {$1.count > 1}
        let duplicates = Array(duplicateGroups.keys)
        return duplicates
    }
}
