import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final List<Color>? color;
  final String? text;
  final Function()? onPress;
  final Color? textColor;
  final double? width;
  CustomButton(
      {@required this.color,
      @required this.text,
      required this.onPress,
      @required this.textColor,
      this.width=double.infinity});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  double? _scale;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller!.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: widget.onPress,
      child: Transform.scale(
        scale: _scale!,
        child: Container(
         padding: const EdgeInsets.all(10),
          width: widget.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [widget.color![0], widget.color![1]]),

              borderRadius: BorderRadius.circular(20.0)),
          child: Center(
            child: Text(
              widget.text!,
              textAlign: TextAlign.center,
              style: TextStyle(color: widget.textColor, fontSize: 14.0),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller!.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller!.reverse();
  }
}
