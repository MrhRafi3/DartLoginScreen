import 'package:flutter/widgets.dart';

import 'package:oglet/data/oglet_content.dart';
import 'package:oglet/engine/oglet_animation_engine.dart';
import 'package:oglet/presentation/widgets/design_stage.dart';
import 'package:oglet/presentation/widgets/phone_frame.dart';

class OgletScreen extends StatefulWidget {
  const OgletScreen({super.key});

  @override
  State<OgletScreen> createState() => _OgletScreenState();
}

class _OgletScreenState extends State<OgletScreen>
    with SingleTickerProviderStateMixin {
  OgletAnimationEngine? _engine;
  bool? _lastReducedMotion;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Granular aspect-specific subscription to avoid unnecessary rebuilds
    final bool reducedMotion = MediaQuery.disableAnimationsOf(context);

    if (_engine == null || _lastReducedMotion != reducedMotion) {
      _engine?.dispose();
      _lastReducedMotion = reducedMotion;
      _engine = OgletAnimationEngine(
        vsync: this,
        prefersReducedMotion: reducedMotion,
      );
    }
  }

  @override
  void dispose() {
    _engine?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_engine == null) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: OgletContent.description,
      container: true,
      child: DesignStage(child: PhoneFrame(engine: _engine!)),
    );
  }
}
