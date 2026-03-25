/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.

import 'package:collection/collection.dart';

/// A single audio visualization frame emitted by [Player.stream].
class AudioVisualizationFrame {
  /// Schema version emitted by the native backend.
  final int version;

  /// Visualization payload mode.
  ///
  /// Suggested values:
  /// * `bands`
  /// * `pcm_window`
  /// * `hybrid`
  /// * `raw_pcm`
  final String mode;

  /// Channel layout of [pcm].
  ///
  /// Suggested values:
  /// * `mono`
  /// * `stereo`
  final String channelMode;

  /// Monotonic sequence number attached by the native backend.
  final int sequence;

  /// Playback position associated with this frame.
  final Duration position;

  /// Native presentation timestamp associated with this frame.
  final Duration? pts;

  /// Source sample rate for [bands] / [pcm].
  final int? sampleRate;

  /// Number of channels represented in this frame.
  final int? channels;

  /// Number of PCM frames per channel in [pcm].
  final int? framesPerChannel;

  /// Normalized visualization peaks in the range `0.0..1.0`.
  final List<double> peaks;

  /// Optional normalized frequency band magnitudes in the range `0.0..1.0`.
  ///
  /// This is intended for FFT / spectral analyzers where each element
  /// represents a frequency bucket.
  final List<double> bands;

  /// Optional root mean square value in the range `0.0..1.0`.
  final double? rms;

  /// Optional PCM payload in the range `-1.0..1.0`.
  ///
  /// If [channelMode] is `stereo`, the values are interleaved as `LRLR...`.
  final List<double> pcm;

  const AudioVisualizationFrame({
    this.version = 1,
    this.mode = 'bands',
    this.channelMode = 'mono',
    this.sequence = 0,
    this.position = Duration.zero,
    this.pts,
    this.sampleRate,
    this.channels,
    this.framesPerChannel,
    this.peaks = const <double>[],
    this.bands = const <double>[],
    this.rms,
    this.pcm = const <double>[],
  });

  static const ListEquality<double> _peaksEquality = ListEquality<double>();
  static const ListEquality<double> _bandsEquality = ListEquality<double>();
  static const ListEquality<double> _pcmEquality = ListEquality<double>();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AudioVisualizationFrame &&
        other.version == version &&
        other.mode == mode &&
        other.channelMode == channelMode &&
        other.sequence == sequence &&
        other.position == position &&
        other.pts == pts &&
        other.sampleRate == sampleRate &&
        other.channels == channels &&
        other.framesPerChannel == framesPerChannel &&
        other.rms == rms &&
        _pcmEquality.equals(other.pcm, pcm) &&
        _bandsEquality.equals(other.bands, bands) &&
        _peaksEquality.equals(other.peaks, peaks);
  }

  @override
  int get hashCode => Object.hash(
        version,
        mode,
        channelMode,
        sequence,
        position,
        pts,
        sampleRate,
        channels,
        framesPerChannel,
        rms,
        _pcmEquality.hash(pcm),
        _bandsEquality.hash(bands),
        _peaksEquality.hash(peaks),
      );
}
