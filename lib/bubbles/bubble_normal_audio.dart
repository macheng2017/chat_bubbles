import 'package:flutter/material.dart';

const double BUBBLE_RADIUS_AUDIO = 16;

///basic chat bubble type audio message widget
///
/// [onSeekChanged] double pass function to take actions on seek changes
/// [onPlayPauseButtonClick] void function to handle play pause button click
/// [isPlaying],[isPause] parameters to handle playing state
///[duration] is the duration of the audio message in seconds
///[position is the current position of the audio message playing in seconds
///[isLoading] is the loading state of the audio
///ex:- fetching from internet or loading from local storage
///chat bubble [BorderRadius] can be customized using [bubbleRadius]
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///message sender can be changed using [isSender]
///[sent],[delivered] and [seen] can be used to display the message state
///chat bubble [TextStyle] can be customized using [textStyle]

class BubbleNormalAudio extends StatefulWidget {
  final void Function(double value) onSeekChanged;
  final void Function() onPlayPauseButtonClick;
  final String? text;
  final bool isPlaying;
  final bool isPause;
  final double? duration;
  final double? position;
  final bool isLoading;
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle textStyle;
  final BoxConstraints? constraints;

  @override
  State<StatefulWidget> createState() => _BubbleNormalAudioState();

  BubbleNormalAudio(
      {Key? key,
      required this.onSeekChanged,
      required this.onPlayPauseButtonClick,
      this.isPlaying = false,
      this.constraints,
      this.isPause = false,
      this.duration,
      this.position,
      this.isLoading = true,
      this.bubbleRadius = BUBBLE_RADIUS_AUDIO,
      this.isSender = true,
      this.color = Colors.white70,
      this.tail = true,
      this.sent = false,
      this.delivered = false,
      this.seen = false,
      this.text,
      this.textStyle = const TextStyle(
        color: Colors.black87,
        fontSize: 12,
      )})
      : super(key: key);
}

class _BubbleNormalAudioState extends State<BubbleNormalAudio> {
  bool _isTextVisible = false;

  bool get sent => widget.sent;

  bool get delivered => widget.delivered;

  bool get seen => widget.seen;

  get isSender => widget.isSender;

  get constraints => widget.constraints;

  get color => widget.color;

  double get bubbleRadius => widget.bubbleRadius;

  get tail => widget.tail;

  get onPlayPauseButtonClick => widget.onPlayPauseButtonClick;

  bool get isPlaying => widget.isPlaying;

  get isLoading => widget.isLoading;

  get isPause => widget.isPause;

  get duration => widget.duration;

  get position => widget.position;

  get onSeekChanged => widget.onSeekChanged;

  get textStyle => widget.textStyle;
  get text => widget.text;
  get _showText => text != null ? Text(text) : Container();

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;

    // 是否在气泡下面显示文本
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Column(
      children: [
        Row(
          children: <Widget>[
            isSender
                ? Expanded(
                    child: SizedBox(
                      width: 5,
                    ),
                  )
                : Container(),
            Container(
              color: Colors.transparent,
              constraints: constraints ??
                  BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .8,
                      maxHeight: 70),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(bubbleRadius),
                      topRight: Radius.circular(bubbleRadius),
                      bottomLeft: Radius.circular(tail
                          ? isSender
                              ? bubbleRadius
                              : 0
                          : BUBBLE_RADIUS_AUDIO),
                      bottomRight: Radius.circular(tail
                          ? isSender
                              ? 0
                              : bubbleRadius
                          : BUBBLE_RADIUS_AUDIO),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          RawMaterialButton(
                            onPressed: onPlayPauseButtonClick,
                            elevation: 1.0,
                            fillColor: Colors.white,
                            child: !isPlaying
                                ? Icon(
                                    Icons.play_arrow,
                                    size: 30.0,
                                  )
                                : isLoading
                                    ? CircularProgressIndicator()
                                    : isPause
                                        ? Icon(
                                            Icons.play_arrow,
                                            size: 30.0,
                                          )
                                        : Icon(
                                            Icons.pause,
                                            size: 30.0,
                                          ),
                            padding: EdgeInsets.all(0.0),
                            shape: CircleBorder(),
                          ),
                          Expanded(
                            child: Slider(
                              min: 0.0,
                              max: duration ?? 0.0,
                              value: position ?? 0.0,
                              onChanged: onSeekChanged,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 8,
                        right: 25,
                        child: Text(
                          '${audioTimer(duration ?? 0.0, position ?? 0.0)}',
                          style: textStyle,
                        ),
                      ),
                      stateIcon != null && stateTick
                          ? Positioned(
                              bottom: 4,
                              right: 6,
                              child: stateIcon,
                            )
                          : SizedBox(
                              width: 1,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            isSender
                ? Container()
                : IconButton(
                    onPressed: () => setState(() {
                          _isTextVisible = !_isTextVisible;
                        }),
                    icon: Icon(Icons.remove_red_eye)),
            Padding(padding: EdgeInsets.only(right: 100)),
          ],
        ),
        _isTextVisible ? _showText : Container(),
      ],
    );
  }

  String audioTimer(double duration, double position) {
    return '${(duration ~/ 60).toInt()}:${(duration % 60).toInt().toString().padLeft(2, '0')}/${position ~/ 60}:${(position % 60).toInt().toString().padLeft(2, '0')}';
  }
}
