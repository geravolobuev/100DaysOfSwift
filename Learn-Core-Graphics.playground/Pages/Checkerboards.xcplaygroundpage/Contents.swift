//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # Rectangles in a loop
//: Drawing rectangles inside two loops lets us create a checkerboard pattern. The image already has a white background color, so we need to draw black rectangles in an odd-even pattern to get the desired result.
//:
//: - Experiment: The code below makes a checkerboard, but it doesn't fill the image correctly. Try adjusting the grid size, number of rows, and number of columns so that you get a 10x10 checkerboard across the entire image.
import UIKit


let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
let img = renderer.image { ctx in
    ctx.cgContext.setFillColor(UIColor.red.cgColor)
    ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
    ctx.cgContext.setLineWidth(10)

    let size = 100

    for row in 0 ..< 4 {
        for col in 0 ..< 3 {

            ctx.cgContext.addRect(CGRect(x: col * size, y: row * size, width: size, height: size))
            ctx.cgContext.drawPath(using: .fillStroke)
        }
    }
}



showOutput(img)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
