//
//  GraphView.swift
//  MOBI
//
//  Created by Michele Bigi on 24/09/17.
//  Copyright © 2017 Michele Bigi. All rights reserved.
//

import Cocoa
import Foundation

@IBDesignable
class GraphView: NSView {
    
    let NodoTipo0   = 0             // Nodo virtuale
    let NodoTipo1   = 1             // Fermata
    let NodoTipo2   = 2             // Stazione minore
    let NodoTipo3   = 3             // Stazione media
    let NodoTipo4   = 4             // Stazione principale
    let NodoTipo5   = 5             // Stazione di testa

    var maxHor : Int = 0
    var minHor : Int = 0
    var maxVer : Int = 0
    var minVer : Int = 0
    var wx     : CGFloat = 0.0
    var wy     : CGFloat = 0.0
    var px     : CGFloat = 0.0
    var py     : CGFloat = 0.0

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        NSColor.white.setFill()
        __NSRectFill(bounds)
        
        prepareForInterfaceBuilder()
        let context = NSGraphicsContext.current?.cgContext
        drawLinea(context: context )
        drawNodi( context: context )
        
        
    }
    
    override func prepareForInterfaceBuilder() {
        var idNodo = AppDelegate.mobiData.NodiDict[0]
        maxHor = idNodo["x"] as! Int
        minHor = idNodo["x"] as! Int
        
        for idNodo in AppDelegate.mobiData.NodiDict {
            var nodoXVal : Int = idNodo["x"] as! Int
            var nodoYVal : Int = idNodo["y"] as! Int
            
            maxHor = ( maxHor > nodoXVal ) ? maxHor : nodoXVal
            minHor = ( minHor < nodoXVal ) ? minHor : nodoXVal
            maxVer = ( maxVer > nodoYVal ) ? maxVer : nodoYVal
            minVer = ( minVer < nodoYVal ) ? minVer : nodoYVal
        }
        maxHor += 1
        minHor -= 1
        maxVer += 1
        minVer -= 1
        
        let deltaX : CGFloat = CGFloat( maxHor - minHor )
        let deltaY : CGFloat = CGFloat( maxVer - minVer )
        
        wx = ( bounds.size.width  / deltaX )
        wy = ( bounds.size.height / -deltaY )
        
        px = wx * CGFloat( minHor )
        py = wy * CGFloat( minVer ) - bounds.size.height
        
    }
    
    func xCoord( x :Float ) -> CGFloat {
        return CGFloat( x ) * wx - px
    }
    
    func yCoord( y :Float ) -> CGFloat {
        return CGFloat( y ) * wy - py
    }
    
    func drawRoundedRect(rect: CGRect, inContext context: CGContext?,
                         radius: CGFloat, borderColor: CGColor, fillColor: CGColor) {
        let path = CGMutablePath()
        
        path.move( to: CGPoint(x:  rect.midX, y:rect.minY ))
        path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.minY ),
                     tangent2End: CGPoint(x: rect.maxX, y: rect.maxY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.maxY ),
                     tangent2End: CGPoint(x: rect.minX, y: rect.maxY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.maxY ),
                     tangent2End: CGPoint(x: rect.minX, y: rect.minY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.minY ),
                     tangent2End: CGPoint(x: rect.maxX, y: rect.minY), radius: radius)
        path.closeSubpath()
        
        context?.setLineWidth(1.0)
        context?.setFillColor(fillColor)
        context?.setStrokeColor(borderColor)
        
        context?.addPath(path)
        context?.drawPath(using: .fillStroke)
    }
    
    func nodoRectangle( center :CGPoint , radius :CGFloat ) -> CGRect {
        let rect = CGRect( x: center.x - radius , y: center.y - radius , width: radius * 2 , height: radius * 2 )
        
        return rect
    }
    
    func drawNodoCerchio( context: CGContext?, posizione : CGRect, borderColor: CGColor, fillColor: CGColor ) {
        let circle = NSBezierPath(ovalIn: posizione)
        context?.setFillColor(fillColor)
        context?.setStrokeColor(borderColor)
        
        circle.stroke()
        circle.fill()
    }
    
    func drawNodoRettangolo( context: CGContext?, posizione : CGRect , borderColor: CGColor, fillColor: CGColor) {
        drawRoundedRect(rect: posizione, inContext: context,
                        radius: 4,
                        borderColor: borderColor,
                        fillColor: fillColor )
        
    }
    
    func drawNodo( context: CGContext?, x :Float, y :Float, tipo :Int ) {
        let radius :CGFloat = 0
        let xCGF = xCoord(x: x )
        let yCGF = yCoord(y: y )
        let center = CGPoint( x:xCGF , y:yCGF )
        let red = CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0 )
        let blue = CGColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0 )
        
        let ts = String( format: "\t%f\t%f\t%i", xCGF  , yCGF , tipo )
        print( ts )
        switch tipo {
        case NodoTipo0:
            // Segmento Linea
            let pos = nodoRectangle(center: center, radius: 2)
            drawNodoCerchio(context: context, posizione: pos, borderColor: CGColor.black, fillColor: blue )
            break
            
        case NodoTipo1:
            // Fermata
            let pos = nodoRectangle(center: center, radius: 5 )
            drawNodoCerchio(context: context, posizione: pos, borderColor: CGColor.black, fillColor: blue )
            break
            
        case NodoTipo2:
            // Stazione minore
            let pos = nodoRectangle(center: center, radius: 10 )
            drawNodoCerchio(context: context, posizione: pos, borderColor: CGColor.black, fillColor: blue )
            break
            
        case NodoTipo3:
            // Stazione media
            let pos = nodoRectangle(center: center, radius: 15 )
            drawNodoCerchio(context: context, posizione: pos, borderColor: CGColor.black, fillColor: blue )
            break
            
        case NodoTipo4:
            // Stazione principale
            let pos = nodoRectangle(center: center, radius: 20 )
            drawNodoCerchio(context: context, posizione: pos, borderColor: CGColor.black, fillColor: blue )
            break
            
        case NodoTipo5:
            // Stazione di testa
            let pos = nodoRectangle(center: center, radius: 20 )
            drawNodoRettangolo(context: context, posizione: pos, borderColor: CGColor.black, fillColor: blue)
            break
            
        default:
            break
        }
        
    }
    
    func drawSingleLine( context: CGContext?, start : CGPoint, end: CGPoint, borderColor: CGColor ) {
        let path = NSBezierPath()
        path.move(to: start)
        path.line(to: end )
        path.close()

        context?.setStrokeColor(borderColor)
        path.stroke()
    }
    
    func getLabelElement ( label: String) -> Dictionary<String,Any> {
        for iNodo in  AppDelegate.mobiData.NodiDict {
            if ( (iNodo["label"] as! String) == label ){
                return iNodo
            }
        }
        return AppDelegate.mobiData.NodiDict[0]
    }
    
    func drawDoubleLine(context: CGContext?,start : CGPoint, end: CGPoint, borderColor: CGColor ) {
        var lineaH = 0 as Int
        
        if( start.x != end.x ) {
            var p_s1 = CGPoint( x:start.x , y:(start.y - 2) )
            var p_e1 = CGPoint( x:end.x , y:(end.y - 2 ))
            var p_s2 = CGPoint( x:start.x , y:(start.y + 2) )
            var p_e2 = CGPoint( x:end.x , y:(end.y + 2 ))
            drawSingleLine(context: context, start: p_s1, end: p_e1, borderColor: borderColor )
            drawSingleLine(context: context, start: p_s2, end: p_e2, borderColor: borderColor )
            
        }
        else {
            var p_s1 = CGPoint( x:(start.x - 2 ) , y:start.y )
            var p_e1 = CGPoint( x:(end.x - 2 ) , y:end.y )
            var p_s2 = CGPoint( x:(start.x + 2 )  , y:start.y  )
            var p_e2 = CGPoint( x:(end.x + 2 ), y:end.y)
            drawSingleLine(context: context, start: p_s1, end: p_e1, borderColor: borderColor )
            drawSingleLine(context: context, start: p_s2, end: p_e2, borderColor: borderColor )
            
        }
        
    }
    
    func drawLinea(context: CGContext? ) {
        let red = CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0 )
        
        for iRete in AppDelegate.mobiData.ReteDict {
            var nS = iRete["start"] as! String
            var nE = iRete["end"] as! String
            var rTipo  = iRete["type"] as! Int
            
            print( rTipo )
            var iNodoS = getLabelElement(label: nS )
            var iNodoE = getLabelElement(label: nE )
            
            var nodoXS = iNodoS["x"] as! Float
            var nodoYS = iNodoS["y"] as! Float
            var nodoXE = iNodoE["x"] as! Float
            var nodoYE = iNodoE["y"] as! Float
            
            var p_start = CGPoint( x:xCoord(x: nodoXS ), y:yCoord(y: nodoYS ) )
            var p_end   = CGPoint( x:xCoord(x: nodoXE ) , y:yCoord(y: nodoYE ) )
            
            if( rTipo == 1) {
                drawSingleLine(context: context, start: p_start, end: p_end, borderColor: red )
            } else {
                drawDoubleLine(context: context, start: p_start, end: p_end, borderColor: red )
                
            }
        }
    }
    
    func drawNodi( context: CGContext? ) {
        for iNodo in  AppDelegate.mobiData.NodiDict {
            var nodoX : Float = iNodo["x"] as! Float
            var nodoY : Float = iNodo["y"] as! Float
            var nodoTipo : Int   = iNodo["type"] as! Int
            
            let ts = String( format: "%2.2i\t%f\t%f\t%i", iNodo["id"] as! Int , nodoX, nodoY, nodoTipo )
            print( ts )
            drawNodo( context: context , x: nodoX , y: nodoY, tipo: nodoTipo )
        }
    }
}
