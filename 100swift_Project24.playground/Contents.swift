import UIKit

let name = "Taylor"
for letter in name {
    print("Give me a \(letter)")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[3]

let password = "12345"
password.hasPrefix("123")
password.hasSuffix("456")

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

password.deletingPrefix("123")

let weather = "Its going to rain"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return ""}
        return firstLetter.uppercased() + self.dropFirst()
    }
}

let input = "Swift is like Obj C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        
        return false
    }
}

input.containsAny(of: languages)

languages.contains(where: input.contains)


let string = "This is a test string"

let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

let mutableAttributedString = NSMutableAttributedString(string: string)

mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


// Challenge

//Create a String extension that adds a withPrefix() method. If the string already contains the prefix it should return itself; if it doesn’t contain the prefix, it should return itself with the prefix added. For example: "pet".withPrefix("car") should return “carpet”.

extension String {
    func withPrefix(_ string: String) -> String {
        if !self.hasPrefix(string) {
            return string + self
        } else {
            return self
        }
    }
}

let car = "pet"
print(car.withPrefix("car"))


//Create a String extension that adds an isNumeric property that returns true if the string holds any sort of number. Tip: creating a Double from a String is a failable initializer.

extension String {
    func isNumeric() -> Bool {
        for item in ["1","2","3","4","5","6","7","8","9","0"] {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

let numStr = "gdag3.5"
print(numStr.isNumeric())


// Create a String extension that adds a lines property that returns an array of all the lines in a string. So, “this\nis\na\ntest” should return an array with four elements.

extension String {
    func linesArray() -> [String] {
        let array = [String]()
        if self.contains("\n") {
            array = self.components(separatedBy: "\n")
        }
        return array
    }
}

let arrayStr = "this\nis\na\ntest"
print(arrayStr.linesArray())
