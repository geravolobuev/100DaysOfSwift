import UIKit

// Extend UIView so that it has a bounceOut(duration:) method that uses animation to scale its size down to 0.0001 over a specified number of seconds.

extension UIView {
    func bounceOut(duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        })
    }
}

// Extend Int with a times() method that runs a closure as many times as the number is high. For example, 5.times { print("Hello!") } will print “Hello” five times.


extension Int {
    func times(closure: () -> Void) {
        for i in 0..<self {
            closure()
        }
    }
}

5.times {
    print("Hi there!")
}

// Extend Array so that it has a mutating remove(item:) method. If the item exists more than once, it should remove only the first instance it finds. Tip: you will need to add the Comparable constraint to make this work!

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        let repeatedItemArray = self.filter { $0 == item }
        if repeatedItemArray.count >= 2 {
            if let repeatedItem = self.firstIndex(of: item) {
                self.remove(at: repeatedItem)
            }
        }
    }
}


var customArray = ["one", "two", "three", "two"]
customArray.remove(item: "one")
print(customArray)

