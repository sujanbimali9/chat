import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MultiMediaGrid extends MultiChildRenderObjectWidget {
  final double spacing;
  final int maxAllowedPerRow;

  const MultiMediaGrid({
    super.key,
    this.spacing = 1,
    this.maxAllowedPerRow = 3,
    required super.children,
  });

  @override
  MultiMediaGridRenderer createRenderObject(BuildContext context) {
    return MultiMediaGridRenderer(
      spacing: spacing,
      maxAllowedPerRow: maxAllowedPerRow,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant MultiMediaGridRenderer renderObject,
  ) {
    renderObject
      ..spacing = spacing
      ..maxAllowedPerRow = maxAllowedPerRow;
  }
}

class _MultiMediaGridChild extends ContainerBoxParentData<RenderBox>
    with ContainerParentDataMixin<RenderBox> {}

class MultiMediaGridRenderer extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _MultiMediaGridChild>,
        RenderBoxContainerDefaultsMixin<RenderBox, _MultiMediaGridChild> {
  MultiMediaGridRenderer({
    required double spacing,
    required int maxAllowedPerRow,
  }) : _maxAllowedPerRow = maxAllowedPerRow,
       _spacing = spacing;

  double _spacing;

  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  int _maxAllowedPerRow;
  int get maxAllowedPerRow => _maxAllowedPerRow;
  set maxAllowedPerRow(int value) {
    if (_maxAllowedPerRow == value) return;
    _maxAllowedPerRow = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child is! _MultiMediaGridChild) {
      child.parentData = _MultiMediaGridChild();
    }
  }

  @override
  void performLayout() {
    final children = getChildrenAsList();
    final totalChild = children.length;

    if (totalChild == 0) {
      size = Size(constraints.maxWidth, 0);
      return;
    }

    final widthConstraint = constraints.maxWidth;
    final itemPerRow = totalChild < maxAllowedPerRow
        ? totalChild
        : maxAllowedPerRow;
    final totalSpacing = spacing * (itemPerRow - 1);
    final availableWidthAfterSpacing = widthConstraint - totalSpacing;
    final itemWidth = availableWidthAfterSpacing / itemPerRow;
    final itemHeight = itemWidth * 1.5;

    final totalRow = (totalChild / maxAllowedPerRow).ceil();

    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      final column = i % maxAllowedPerRow;
      final row = (i / maxAllowedPerRow).floor();
      final offsetX =
          widthConstraint - (column + 1) * itemWidth - column * spacing;
      final offsetY = row * (itemHeight + spacing);
      final childOffset = Offset(offsetX, offsetY);

      final childConstraint = BoxConstraints.tight(Size(itemWidth, itemHeight));
      child.layout(childConstraint);
      final childParentData = child.parentData! as _MultiMediaGridChild;
      childParentData.offset = childOffset;
    }
    double height = totalRow * itemHeight + (totalRow - 1) * spacing;
    size = Size(widthConstraint, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (var child = firstChild; child != null; child = childAfter(child)) {
      final parentData = child.parentData! as _MultiMediaGridChild;
      context.paintChild(child, offset + parentData.offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final childParentData = child.parentData! as _MultiMediaGridChild;
      if (result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child!.hitTest(result, position: transformed);
        },
      )) {
        return true;
      }
      child = childBefore(child);
    }
    return false;
  }
}
