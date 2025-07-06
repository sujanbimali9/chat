import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReplyChat extends MultiChildRenderObjectWidget {
  final CrossAxisAlignment crossAxisAlignment;
  final double overlapOffset;

  ReplyChat({
    super.key,
    required Widget reply,
    required Widget chat,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.overlapOffset = 20,
  }) : super(children: [reply, chat]);

  @override
  RenderReplyChat createRenderObject(BuildContext context) {
    return RenderReplyChat(
        crossAxisAlignment: crossAxisAlignment, overlapOffset: overlapOffset);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderReplyChat renderObject) {
    renderObject
      ..crossAxisAlignment = crossAxisAlignment
      ..overlapOffset = overlapOffset;
  }
}

class _ReplyChatChild extends ContainerBoxParentData<RenderBox>
    with ContainerParentDataMixin<RenderBox> {}

class RenderReplyChat extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ReplyChatChild>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ReplyChatChild> {
  CrossAxisAlignment _crossAxisAlignment;
  CrossAxisAlignment get crossAxisAlignment => _crossAxisAlignment;
  double _overlapOffset;
  double get overlapOffset => _overlapOffset;

  set crossAxisAlignment(CrossAxisAlignment value) {
    if (_crossAxisAlignment == value) return;
    _crossAxisAlignment = value;
    markNeedsLayout();
  }

  set overlapOffset(double value) {
    if (_overlapOffset == value) return;
    _overlapOffset = value;
    markNeedsLayout();
  }

  RenderReplyChat(
      {required CrossAxisAlignment crossAxisAlignment,
      required double overlapOffset})
      : _crossAxisAlignment = crossAxisAlignment,
        _overlapOffset = overlapOffset;

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! _ReplyChatChild) {
      child.parentData = _ReplyChatChild();
    }
  }

  @override
  void performLayout() {
    Offset childOffset = const Offset(0, 0);
    double availableWidth = constraints.maxWidth;

    for (var child = firstChild; child != null; child = childAfter(child)) {
      final childParentData = child.parentData! as _ReplyChatChild;
      child.layout(constraints.loosen(), parentUsesSize: true);
      double childWidth = child.size.width;

      double offsetX = switch (crossAxisAlignment) {
        CrossAxisAlignment.start => 0,
        CrossAxisAlignment.center => (availableWidth - childWidth) / 2,
        CrossAxisAlignment.end => availableWidth - childWidth,
        _ => 0
      };

      childOffset = Offset(offsetX, childOffset.dy);
      childParentData.offset = childOffset;
      childOffset = childOffset.translate(0, child.size.height - overlapOffset);
    }
    size = Size(constraints.maxWidth, childOffset.dy + overlapOffset);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as _ReplyChatChild;
      context.paintChild(child, offset + childParentData.offset);
      child = childAfter(child);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final childParentData = child.parentData! as _ReplyChatChild;
      if (result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            return child!.hitTest(result, position: transformed);
          })) {
        return true;
      }
      child = childBefore(child);
    }
    return false;
  }
}
