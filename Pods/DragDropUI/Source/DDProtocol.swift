//
//  DDProtocol.swift
//  DragDropUI
//
//  Created by Abdullah Selek on 30/11/2016.
//  Copyright © 2016 Abdullah Selek. All rights reserved.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

public protocol DDViewDelegate {

    func viewWasDragged(view: UIView, draggedPoint: CGPoint)

    func viewWasDropped(view: UIView, droppedPoint: CGPoint)

}

public protocol DDProtocol: class {

    var ddDelegate: DDViewDelegate? { get set }

    var view: UIView { get }
    var draggedPoint: CGPoint { get set }

    func registerGesture() -> Void
    func removeGesture() -> Void
    func didPress(pressGesture: UILongPressGestureRecognizer) -> Void
    func handlePan(panGesture: UIPanGestureRecognizer) -> Void

}
