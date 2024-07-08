//
//  NSNumberExtension.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2023/10/18.
//

import UIKit

public extension IntegerLiteralType {
    var f: CGFloat {
        return CGFloat(self)
    }
    
    var d: Double {
        return Double(self)
    }
    
    var string: String {
        return String(self)
    }
    
    var scaled: CGFloat {
        return (self.f * kPortraitScreenW / 375).rounded(.towardZero)
    }
    
    func scaledBy(_ ratio: CGFloat) -> CGFloat {
        return (self.f * ratio).rounded(.towardZero)
    }
    
    func shorten(threshold: Int? = nil, multiplier: Int = 10000, postFix: String = "w", roundPostion: Int = 2) -> String {
        let t = threshold ?? multiplier
        if self < t {
            return self.description
        } else {
            return (Double(self) / Double(multiplier)).roundTo(position: roundPostion) + postFix
        }
    }
    
    var ratio: CGFloat {
        return self.f * kPortraitScreenW / 375
    }
}

public extension FloatLiteralType {
    var f: CGFloat {
        return CGFloat(self)
    }
    
    var scaled: CGFloat {
        return (self.f * kPortraitScreenW / 375).rounded(.towardZero)
    }
    
    func scaledBy(_ ratio: CGFloat) -> CGFloat {
        return (self.f * kPortraitScreenW / 375).rounded(.towardZero)
    }
    
    var ratio: CGFloat {
        return self.f * kPortraitScreenW / 375
    }
}

extension CGFloat {
    func scaleToFit() -> CGFloat {
        return (CGFloat(self) * kPortraitScreenW / 375).rounded(.towardZero)
    }
    
    var scaled: CGFloat {
        return (self * kPortraitScreenW / 375).rounded(.towardZero)
    }
    
    var ratio: CGFloat {
        return self * kPortraitScreenW / 375
    }
}

extension Int {
    func scaleToFit() -> CGFloat {
        return (CGFloat(self) * kPortraitScreenW / 375).rounded(.towardZero)
    }
    
    var double:Double{
        return Double(self)
    }
}


extension Double {
    func scaleToFit() -> CGFloat {
        return (CGFloat(self) * kPortraitScreenW / 375).rounded(.towardZero)
    }
    
    func roundTo(position: Int) -> String {
        return String(format: "%.\(position)f", self)
    }
    
    var minutesAndSeconds: String {
        guard self >= 0 && self.isFinite else {
            return "--:--"
        }
        let seconds = Int(self)
        //        return String(format: "%02.0f:%02.0f", floor(self / 60), self.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
    
    var timeString: String {
        guard self >= 0 && self.isFinite else {
            return "--:--"
        }
        let seconds = Int(self)
        //        return String(format: "%02.0f:%02.0f", floor(self / 60), self.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d‘%02d”", seconds / 60, seconds % 60)
    }
    
    
    var hoursAndMinutes: String {
        guard self >= 0 && self.isFinite else {
            return "--:--"
        }
        let minutes = Int(ceil(self / 60))
        //        return String(format: "%02.0f:%02.0f", floor(self / 3600), floor(self.truncatingRemainder(dividingBy: 3600) / 60))
        return String(format: "%02d:%02d", minutes / 60, minutes % 60)
    }
    
    var countDownHoursAndMinutesAndSeconds: String {
        guard self >= 0 && self.isFinite else {
            return "00:00:00"
        }
        let total = Int(ceil(self))
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    

    var moneyStr:NSAttributedString {
        let attributedStr = NSMutableAttributedString(string: "¥\(self.roundTo(position: 2))")
        attributedStr.addAttributes([.font: UIFont.systemFont(ofSize: 16)], range: NSRange.init(location: 0, length: 1))
        attributedStr.addAttributes([.font: UIFont.systemFont(ofSize: 13)], range: NSRange.init(location: attributedStr.length - 2, length: 2))
        return attributedStr
    }

    func formatWith(prefix: String, prefixFontSize: CGFloat, wholeFontSize: CGFloat, fractionFontSize: CGFloat, color: UIColor) -> NSAttributedString {
        let text = NSMutableAttributedString(string: prefix,
                                             attributes: [.foregroundColor: color,
                                                          .font: UIFont.systemFont(ofSize: prefixFontSize)])
        let priceString = self.roundWith(maxDigits: 2, minDigits: 0)
        let pointIndex = priceString.firstIndex(of: ".") ?? priceString.endIndex
        text.append(NSAttributedString(string: String(priceString[priceString.startIndex..<pointIndex]),
                                       attributes: [.foregroundColor: color,
                                                    .font: UIFont.systemFont(ofSize: wholeFontSize)]))
        if pointIndex != priceString.endIndex {
            text.append(NSAttributedString(string: String(priceString[pointIndex..<priceString.endIndex]),
                                           attributes: [.foregroundColor: color,
                                                        .font: UIFont.systemFont(ofSize: fractionFontSize)]))
        }
        return text
    }
    
    func roundWith(maxDigits: Int, minDigits: Int) -> String {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = maxDigits
        nf.minimumFractionDigits = minDigits
        nf.minimumIntegerDigits = 1
        nf.roundingMode = .halfUp
        return nf.string(from: NSNumber(value: self)) ?? String(self)
    }
    
    var conversion:String {
        return self.roundTo(position: 2)
    }
    
    var judge:Bool {
        return self == 0
    }
    
}

private let _wordSize = __WORDSIZE

public func arc4random<T: ExpressibleByIntegerLiteral>(_ type: T.Type) -> T {
    var r: T = 0
    arc4random_buf(&r, MemoryLayout<T>.size)
    return r
}

//public extension Bool {
//    static func random() -> Bool {
//        return Int.random() % 2 == 0
//    }
//}

public extension UInt64 {
    static func random(lower: UInt64 = min, upper: UInt64 = max) -> UInt64 {
        var m: UInt64
        let u = upper - lower
        var r = arc4random(UInt64.self)
        
        if u > UInt64(Int64.max) {
            m = 1 + ~u
        } else {
            m = ((max - (u * 2)) + 1) % u
        }
        
        while r < m {
            r = arc4random(UInt64.self)
        }
        
        return (r % u) + lower
    }
}

public extension Int64 {
    static func random(lower: Int64 = min, upper: Int64 = max) -> Int64 {
        let (s, overflow) = upper.subtractingReportingOverflow(lower)//Int64.subtractWithOverflow(upper, lower)
        let u = overflow ? UInt64.max - UInt64(~s) : UInt64(s)
        let r = UInt64.random(upper: u)
        
        if r > UInt64(Int64.max)  {
            return Int64(r - (UInt64(~lower) + 1))
        } else {
            return Int64(r) + lower
        }
    }
}

public extension UInt32 {
    static func random(lower: UInt32 = min, upper: UInt32 = max) -> UInt32 {
        return arc4random_uniform(upper - lower) + lower
    }
}

public extension Int32 {
    static func random(lower: Int32 = min, upper: Int32 = max) -> Int32 {
        let r = arc4random_uniform(UInt32(Int64(upper) - Int64(lower)))
        return Int32(Int64(r) + Int64(lower))
    }
}

public extension UInt {
    static func random(lower: UInt = min, upper: UInt = max) -> UInt {
        switch (_wordSize) {
        case 32: return UInt(UInt32.random(lower: UInt32(lower), upper: UInt32(upper)))
        case 64: return UInt(UInt64.random(lower: UInt64(lower), upper: UInt64(upper)))
        default: return lower
        }
    }
}

public extension Int {
    static func random(lower: Int = min, upper: Int = max) -> Int {
        switch (_wordSize) {
        case 32: return Int(Int32.random(lower: Int32(lower), upper: Int32(upper)))
        case 64: return Int(Int64.random(lower: Int64(lower), upper: Int64(upper)))
        default: return lower
        }
    }
}



extension BinaryInteger {
    var f: CGFloat {
        return CGFloat(self)
    }
}

extension BinaryFloatingPoint {
    var f: CGFloat {
        return CGFloat(self)
    }
    
    var isInt: Bool {
        return self == rounded()
    }
}

protocol Scalable {
    var rc: CGFloat { get }
    var rf: CGFloat { get }
    var r: CGFloat { get }
}

extension CGFloat: Scalable {
    var rc: CGFloat {
        return ceil(self * ScaledRatio) * InvertedScale
    }
    
    var rf: CGFloat {
        return floor(self * ScaledRatio) * InvertedScale
    }
    
    var r: CGFloat {
        return self * Ratio
    }
}

extension CGFloat {
    var pixelCeil: CGFloat {
        return ceil(self * Scale) * InvertedScale
    }
    
    var pixelFloor: CGFloat {
        return floor(self * Scale) * InvertedScale
    }
    
    func interpolate(from a: CGFloat, to b: CGFloat) -> CGFloat {
        return a + (b - a) * self
    }
    
    func clamp(by lowerBound: CGFloat = 0, and upperBound: CGFloat = 1) -> CGFloat {
        return CGFloat.minimum(upperBound, CGFloat.maximum(lowerBound, self))
    }
}

extension Scalable where Self: BinaryInteger {
    var rc: CGFloat {
        return self.f.rc
    }
    
    var rf: CGFloat {
        return self.f.rf
    }
    
    var r: CGFloat {
        return self.f.r
    }
}

extension Scalable where Self: BinaryFloatingPoint {
    var rc: CGFloat {
        return self.f.rc
    }
    
    var rf: CGFloat {
        return self.f.rf
    }
    
    var r: CGFloat {
        return self.f.r
    }
}

extension Int: Scalable {}
extension Double: Scalable {}

