//
//  VerbalExpressions.swift
//  VerbalExpressions
//
//  Created by Dominique d'Argent on 04/06/14.
//  Copyright (c) 2014 Dominique d'Argent. All rights reserved.
//

import Foundation

func VerEx() -> VerbalExpressions {
    return VerbalExpressions()
}

class VerbalExpressions {
    // stored properties
    var prefixes = ""
    var source = ""
    var suffixes = ""
    var options: NSRegularExpressionOptions = NSRegularExpressionOptions.AnchorsMatchLines

    // computed properties
    var pattern: String { return prefixes + source + suffixes }
    
    var regularExpression: NSRegularExpression! {
    get {
        var error: NSError?
        
        let regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: options)
        } catch let error1 as NSError {
            error = error1
            regex = nil
        }
        
        if (error == nil) {
            return nil
        }
        
        return regex
    }
    }

    // instance methods
    func startOfLine(enabled: Bool = true) -> Self {
        prefixes = enabled ? "^" : ""

        return self
    }

    func endOfLine(enabled: Bool = true) -> Self {
        suffixes = enabled ? "$" : ""

        return self
    }

    func then(string: String) -> Self {
        return add("(?:\(sanitize(string)))")
    }

    // alias for then
    func find(string: String) -> Self {
        return then(string)
    }

    func maybe(string: String) -> Self {
        return add("(?:\(sanitize(string)))?")
    }
    
    func anything() -> Self {
        return add("(?:.*)")
    }
    
    func anythingBut(string: String) -> Self {
        return add("(?:[^\(sanitize(string))]*)")
    }

    func something() -> Self {
        return add("(?:.+)")
    }

    func somethingBut(string: String) -> Self {
        return add("(?:[^\(sanitize(string))]+)")
    }

    func lineBreak() -> Self {
        return add("(?:(?:\n)|(?:\r\n))")
    }

    // alias for lineBreak
    func br() -> Self {
        return lineBreak()
    }

    func tab() -> Self {
        return add("\t")
    }

    func word() -> Self {
        return add("\\w+")
    }
    
    func anyOf(string: String) -> Self {
        return add("(?:[\(sanitize(string))])")
    }
    
    // alias for anyOf
    func any(string: String) -> Self {
        return anyOf(string)
    }

    func withAnyCase(enabled: Bool = true) -> Self {
        if enabled {
            return addModifier("i")
        }
        else {
            return removeModifier("i")
        }
    }
    
    func searchOneLine(enabled: Bool = true) -> Self {
        if enabled {
            return removeModifier("m")
        }
        else {
            return addModifier("m")
        }
    }
    
    func beginCapture() -> Self {
        suffixes += ")"
        
        return add("(")
    }
    
    func endCapture() -> Self {
        suffixes = suffixes.substringToIndex(suffixes.endIndex.advancedBy(1))
        
        return add(")")
    }
    
    func replace(string: String, template: String) -> String {
        let range = NSRange(location: 0, length: string.characters.count)
        
        return regularExpression.stringByReplacingMatchesInString(string, options: [], range: range, withTemplate: template)
    }
    
    func replace(string: String, with: String) -> String {
        let range = NSRange(location: 0, length: string.characters.count)
        let template = NSRegularExpression.escapedTemplateForString(with)
        
        return regularExpression.stringByReplacingMatchesInString(string, options: [], range: range, withTemplate: template)
    }
    
    func test(string: String) -> Bool {
        let range = NSRange(location: 0, length: string.characters.count)
        
        if let result = regularExpression.firstMatchInString(string, options: [], range: range) {
            return result.range.location != NSNotFound
        }

        return false
    }
    
    
    // internal methods
    
    func sanitize(string: String) -> String {
        return NSRegularExpression.escapedPatternForString(string)
    }
    
    func add(string: String) -> Self {
        source += string
        
        return self
    }
    
    func addModifier(modifier: Character) -> Self {
        if let option = option(forModifier: modifier) {
            options = options.union(option)
        }
        
        return self
    }
    
    
    func removeModifier(modifier: Character) -> Self {
        if let option = option(forModifier: modifier) {
            options = options.intersect(option)
        }
        
        return self
    }
    
    func option(forModifier modifier: Character) -> NSRegularExpressionOptions? {
        switch modifier {
        case "d": // UREGEX_UNIX_LINES
            return NSRegularExpressionOptions.UseUnixLineSeparators
        case "i": // UREGEX_CASE_INSENSITIVE
            return NSRegularExpressionOptions.CaseInsensitive
        case "x": // UREGEX_COMMENTS
            return NSRegularExpressionOptions.AllowCommentsAndWhitespace
        case "m": // UREGEX_MULTILINE
            return NSRegularExpressionOptions.AnchorsMatchLines
        case "s": // UREGEX_DOTALL
            return NSRegularExpressionOptions.DotMatchesLineSeparators
        case "u": // UREGEX_UWORD
            return NSRegularExpressionOptions.UseUnicodeWordBoundaries
        case "U": // UREGEX_LITERAL
            return NSRegularExpressionOptions.IgnoreMetacharacters
        default:
            fatalError("Unknown modifier")
        }
    }

}

extension VerbalExpressions: CustomStringConvertible {
    var description: String { return pattern }
}
