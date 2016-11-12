//
//  TagListView.swift
//  bounceapp
//
//  Created by Anthony Wamunyu Maina on 6/19/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import Foundation
import UIKit
class TagListView:UIScrollView
{
    var numberOfRows = 0
    var currentRow = 0
    var tags = [UILabel]()
    
    var hashtagsOffset:UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
    var rowHeight:CGFloat = 40 //height of rows
    var tagHorizontalPadding:CGFloat = 5.0 // padding between tags horizontally
    var tagVerticalPadding:CGFloat = 5.0 // padding between tags vertically
    var tagCombinedMargin:CGFloat = 10.0 // margin of left and right combined, text in tags are by default centered.
    override init(frame:CGRect)
    {
        super.init(frame: frame)
        numberOfRows = Int(frame.height / rowHeight)
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addTag(text:String,target:AnyObject,tapAction:Selector,backgroundColor:UIColor,textColor:UIColor)
    {
        //instantiate label
        //you can customize your label here! but make sure everything fit. Default row height is 30.
        let label = UILabel()
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textColor = UIColor.white
        label.backgroundColor = backgroundColor
        label.text = text
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: 18)
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.center
        
        self.tags.append(label)
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = UIScreen.main.scale
        //process actions
        if tapAction != nil
        {
            let tap = UITapGestureRecognizer(target: target, action: tapAction)
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tap)
        }
        
        
        //calculate frame
        label.frame = CGRect(label.frame.origin.x,label.frame.origin.y , label.frame.width + tagCombinedMargin, rowHeight - tagVerticalPadding)
        if self.tags.count == 0
        {
            label.frame = CGRect(hashtagsOffset.left, hashtagsOffset.top, label.frame.width, label.frame.height)
            self.addSubview(label)
            
        }
        else
        {
            label.frame = self.generateFrameAtIndex(index: tags.count-1, rowNumber: &currentRow)
            self.addSubview(label)
        }
    }
    
    
    
    private func isOutofBounds(newPoint:CGPoint,labelFrame:CGRect)
    {
        let bottomYLimit = newPoint.y + labelFrame.height
        if bottomYLimit > self.contentSize.height
        {
            self.contentSize = CGSize(self.contentSize.width, self.contentSize.height + rowHeight - tagVerticalPadding)
        }
    }
    
    func getNextPosition() -> CGPoint
    {
        return getPositionForIndex(index: tags.count-1, rowNumber: self.currentRow)
    }
    
    func getPositionForIndex(index:Int,rowNumber:Int) -> CGPoint
    {
        if index == 0
        {
            return CGPoint(hashtagsOffset.left, hashtagsOffset.top)
        }
        let y = CGFloat(rowNumber) * self.rowHeight + hashtagsOffset.top
        let lastTagFrame = tags[index-1].frame
        
        let x = lastTagFrame.origin.x + lastTagFrame.width + tagHorizontalPadding
        return CGPoint(x, y)
    }
    
    func reset()
    {
        for tag in tags
        {
            tag.removeFromSuperview()
        }
        tags = []
        currentRow = 0
        numberOfRows = 0
    }
    
    func removeTagWithName(name:String)
    {
        for (index,tag) in tags.enumerated()
        {
            if tag.text! == name
            {
                removeTagWithIndex(index: index)
            }
        }
    }
    
    func removeTagWithIndex(index:Int)
    {
        if index > tags.count - 1
        {
            print("ERROR: Tag Index \(index) Out of Bounds")
            return
        }
        tags[index].removeFromSuperview()
        tags.remove(at: index)
        layoutTagsFromIndex(index: index)
    }
    
    private func getRowNumber(index:Int) -> Int
    {
        return Int((tags[index].frame.origin.y - hashtagsOffset.top)/rowHeight)
    }
    
    private func layoutTagsFromIndex(index:Int,animated:Bool = true)
    {
        if tags.count == 0
        {
            return
        }
        let animation:()->() =
            {
                var rowNumber = self.getRowNumber(index: index)
                for i in index...self.tags.count - 1
                {
                    self.tags[i].frame = self.generateFrameAtIndex(index: i, rowNumber: &rowNumber)
                }
        }
        UIView.animate(withDuration: 0.3, animations: animation)
    }
    
    private func generateFrameAtIndex(index:Int, rowNumber: inout Int) -> CGRect
    {
        var newPoint = self.getPositionForIndex(index: index, rowNumber: rowNumber)
        if (newPoint.x + self.tags[index].frame.width) >= self.frame.width
        {
            rowNumber += 1
            newPoint = CGPoint(self.hashtagsOffset.left, CGFloat(rowNumber) * rowHeight + self.hashtagsOffset.top)
        }
        self.isOutofBounds(newPoint: newPoint,labelFrame: self.tags[index].frame)
        return CGRect(newPoint.x, newPoint.y, self.tags[index].frame.width, self.tags[index].frame.height)
    }
    
    func removeMultipleTagsWithIndices(indexSet:Set<Int>)
    {
        let sortedArray = Array(indexSet).sorted()
        for index in sortedArray
        {
            if index > tags.count - 1
            {
                print("ERROR: Tag Index \(index) Out of Bounds")
                continue
            }
            tags[index].removeFromSuperview()
            tags.remove(at: index)
        }
        layoutTagsFromIndex(index: sortedArray.first!)
    }
    
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}


