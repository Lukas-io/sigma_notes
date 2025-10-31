import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/core/colors.dart';

class HomeSearchBar extends StatefulWidget {
  final Function(String)? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onLayoutPressed;

  const HomeSearchBar({
    super.key,
    this.onChanged,
    this.onClear,
    this.onLayoutPressed,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final TextEditingController _controller = TextEditingController();

  bool get hasText => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: SigmaColors.card,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 12,
            cornerSmoothing: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          /// 🔍 Leading search icon
          SvgPicture.asset(
            SigmaAssets.searchSvg,
            height: 20,
            colorFilter: ColorFilter.mode(SigmaColors.gray, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),

          /// ✏️ Text field (no borders)
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              cursorColor: SigmaColors.black,
              decoration: const InputDecoration(
                hintText: 'Search note...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          /// 🔁 Animated trailing button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: hasText
                ? GestureDetector(
                    key: const ValueKey('clear'),
                    onTap: () {
                      _controller.clear();
                      widget.onClear?.call();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: SvgPicture.asset(
                        SigmaAssets.xSvg,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                          SigmaColors.gray,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                : true
                ? GestureDetector(
                    key: const ValueKey('horizontal-layout'),
                    onTap: widget.onLayoutPressed,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: SvgPicture.asset(
                        SigmaAssets.layoutRowSvg,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          SigmaColors.gray,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    key: const ValueKey('vertical-layout'),
                    onTap: widget.onLayoutPressed,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: SvgPicture.asset(
                        SigmaAssets.layoutColumnSvg,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          SigmaColors.gray,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
