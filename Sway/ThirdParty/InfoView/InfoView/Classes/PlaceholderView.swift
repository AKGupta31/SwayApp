//
//  PlaceholderView.swift
//  Pods
//
//  Created by Anatoliy Voropay on 5/12/16.
//
//

import UIKit

/**
 PlaceholderView to draw an area with triangle
 */
internal class PlaceholderView: UIView {

    struct Constants {
        static let TriangleSize = CGSize(width: 25, height: 8)
        static let TriangleRadius: CGFloat = 3
    }

    var color: UIColor? = UIColor.clear
    var triangleOffset: CGPoint = CGPoint.zero

    var arrowPosition: InfoViewArrowPosition = .Automatic {
        didSet { setNeedsDisplay() }
    }

    override internal var frame: CGRect {
        didSet { setNeedsDisplay() }
    }

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }

    private func customize() {
        isOpaque = false
        backgroundColor = .clear
        clipsToBounds = false
        layer.masksToBounds = false
    }

    override func draw(_ rect: CGRect) {
        let corner: CGFloat = layer.cornerRadius
        let triangle = Constants.TriangleSize
        let triangleRadius = Constants.TriangleRadius
        let edges = UIEdgeInsets(top: (arrowPosition == .Top ? triangle.height : 0),
                                 left: (arrowPosition == .Left ? triangle.height : 0),
                                 bottom: (arrowPosition == .Bottom ? triangle.height : 0),
                                 right: (arrowPosition == .Right ? triangle.height : 0))
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.clear(rect)

        if let color = color {
            context.setFillColor(color.cgColor)
        }

//        //
//        // DRAW ROUND CORNER BORDER
//        //
//
//        context.beginPath()
//        context.move(to: CGPoint(x: corner + edges.left, y: edges.top))
//        if arrowPosition == .Top {
//            context.addLine(to: CGPoint(x: (rect.maxX - triangle.width) / 2 + triangleOffset.x, y: edges.top))
//
//            context.addArc(tangent1End: CGPoint(x: rect.maxX / 2 + triangleOffset.x, y: 0), tangent2End: CGPoint(x: (rect.maxX + triangle.width) / 2 + triangleOffset.x, y: edges.top), radius: triangleRadius)
////            CGContextAddArcToPoint(context, rect.maxX / 2 + triangleOffset.x, 0,
////                                   (rect.maxX + triangle.width) / 2 + triangleOffset.x, edges.top,
////                                   triangleRadius)
//
//            context.addLine(to: CGPoint(x: (rect.maxX + triangle.width / 2) + triangleOffset.x , y:edges.top ))
////            CGContextAddLineToPoint(context, (rect.maxX + triangle.width) / 2 + triangleOffset.x, edges.top)
//        }
//
//        CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - corner - edges.right, edges.top)
//        CGContextAddQuadCurveToPoint(context, CGRectGetMaxX(rect) - edges.right, edges.top,
//                                     CGRectGetMaxX(rect) - edges.right, corner + edges.top)
//
//        if arrowPosition == .Right {
//            CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - edges.right, (CGRectGetMaxY(rect) - triangle.width) / 2 + triangleOffset.y)
//            CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) / 2 + triangleOffset.y,
//                                   CGRectGetMaxX(rect) - edges.right, (CGRectGetMaxY(rect) + triangle.width) / 2 + triangleOffset.y,
//                                   triangleRadius)
//            CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - edges.right, (CGRectGetMaxY(rect) + triangle.width) / 2 + triangleOffset.y)
//        }
//
//        CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - edges.right, CGRectGetMaxY(rect) - corner - edges.bottom)
//        CGContextAddQuadCurveToPoint(context, CGRectGetMaxX(rect) - edges.right, CGRectGetMaxY(rect) - edges.bottom,
//                                     CGRectGetMaxX(rect) - corner - edges.right, CGRectGetMaxY(rect) - edges.bottom)
//
//        if arrowPosition == .Bottom {
//            CGContextAddLineToPoint(context, (CGRectGetMaxX(rect) - triangle.width) / 2 + triangleOffset.x, CGRectGetMaxY(rect) - edges.bottom)
//            CGContextAddArcToPoint(context, CGRectGetMaxX(rect) / 2 + triangleOffset.x, CGRectGetMaxY(rect),
//                                   (CGRectGetMaxX(rect) + triangle.width) / 2 + triangleOffset.x, CGRectGetMaxY(rect) - edges.bottom,
//                                   triangleRadius)
//            CGContextAddLineToPoint(context, (CGRectGetMaxX(rect) + triangle.width) / 2 + triangleOffset.x, CGRectGetMaxY(rect) - edges.bottom)
//        }
//
//        CGContextAddLineToPoint(context, corner + edges.left, CGRectGetMaxY(rect) - edges.bottom)
//        CGContextAddQuadCurveToPoint(context, 0 + edges.left, CGRectGetMaxY(rect) - edges.bottom,
//                                     edges.left, CGRectGetMaxY(rect) - corner - edges.bottom)
//
//        if arrowPosition == .Left {
//            CGContextAddLineToPoint(context, edges.left, (CGRectGetMaxY(rect) + triangle.width) / 2 + triangleOffset.y)
//            CGContextAddArcToPoint(context, 0, CGRectGetMaxY(rect) / 2 + triangleOffset.y,
//                                   edges.left, (CGRectGetMaxY(rect) - triangle.width) / 2 + triangleOffset.y,
//                                   triangleRadius)
//            CGContextAddLineToPoint(context, edges.left, (CGRectGetMaxY(rect) - triangle.width) / 2 + triangleOffset.y)
//        }
//
//        CGContextAddLineToPoint(context, edges.left, corner + edges.top)
//        CGContextAddQuadCurveToPoint(context, edges.left, edges.top,
//                                     corner + edges.left, edges.top)
//
//        CGContextClosePath(context)
//        CGContextFillPath(context)
    }
}
