library scaled_box;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ScaledBox extends SingleChildRenderObjectWidget {
  ScaledBox({
    Key key,
    @required this.scale,
    Widget child,
  }) : super(key: key, child: child);

  final double scale;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderScaledBox(scale: scale);
  }

  @override
  void updateRenderObject(BuildContext context, RenderScaledBox renderObject) {
    renderObject.scale = scale;
  }
}

class RenderScaledBox extends RenderProxyBox {
  RenderScaledBox({
    @required double scale,
    RenderBox child,
  }) : this._scale = scale {
    this.child = child;
  }

  double _scale;
  double get scale => _scale;
  set scale(double value) {
    if (value == _scale) return;
    _scale = value;
    markNeedsLayout();
  }

  Matrix4 get _effectiveTransform => Matrix4.diagonal3Values(scale, scale, 1);

  @override
  double computeMinIntrinsicWidth(double height) {
    return super.computeMinIntrinsicWidth(height) * scale;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return super.computeMaxIntrinsicWidth(height) * scale;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return super.computeMinIntrinsicHeight(width) * scale;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return super.computeMaxIntrinsicHeight(width) * scale;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child != null) {
      return child.getDryLayout(constraints) * scale;
    }
    return computeSizeForNoChild(constraints);
  }

  @override
  void performLayout() {
    if (child != null) {
      child.layout(constraints, parentUsesSize: true);
      this.size = child.size * scale;
    } else {
      this.size = constraints.smallest;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {@required Offset position}) {
    assert(_effectiveTransform != null);
    return result.addWithPaintTransform(
      transform: _effectiveTransform,
      position: position,
      hitTest: (BoxHitTestResult result, Offset position) {
        return super.hitTestChildren(result, position: position);
      },
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final Matrix4 transform = _effectiveTransform;
      layer = context.pushTransform(
        needsCompositing,
        offset,
        transform,
        super.paint,
        oldLayer: layer as TransformLayer,
      );
    }
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(_effectiveTransform);
  }
}
