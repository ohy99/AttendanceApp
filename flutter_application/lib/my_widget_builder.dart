import 'package:flutter/material.dart';

class MyWidgetBuilder
{
  static Widget build_circle_topleft(double _w, double _h, double _x, double _y, Color _c)
  {
    return Positioned(
      left: _x,
      top: _y,
      child: Container(
        width: _w,
        height: _h,
        
        decoration: new BoxDecoration(
          color: _c,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
  static Widget build_circle_bottomright(double _w, double _h, double _x, double _y, Color _c)
  {
    return Positioned(
      bottom: _y,
      right: _x,
      child: Container(
        width: _w,
        height: _h,
        
        decoration: new BoxDecoration(
          color: _c,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
    static Widget build_circle_topright(double _w, double _h, double _x, double _y, Color _c)
  {
    return Positioned(
      
      //alignment: Alignment(_x,_y),
      top: _y,
      right: _x,

      child: Container(
        width: _w,
        height: _h,
        
        decoration: new BoxDecoration(
          color: _c,
          shape: BoxShape.circle,
        ),
      ),
    );

    
  }
}