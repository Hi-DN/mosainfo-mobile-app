import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/view/text_style.dart';
import 'package:settings_ui/settings_ui.dart';

import '../types/channel.dart';
import '../types/params.dart';
import '../types/resolution.dart';
import '../types/sample_rate.dart';

class StreamerSettingsView extends StatefulWidget {
  const StreamerSettingsView({Key? key, required this.params}) : super(key: key);
  final Params params;

  @override
  // ignore: library_private_types_in_public_api
  _StreamerSettingsViewState createState() => _StreamerSettingsViewState();
}

class _StreamerSettingsViewState extends State<StreamerSettingsView> {
  int resultAlert = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streamer Settings', style: styleBGreyNavy),
        backgroundColor: white,
        leading: _arrowBackLeadingIcon()
      ),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SettingsList(
            sections: [
              SettingsSection(
                title: const Text('Video'),
                tiles: [
                  SettingsTile(
                    title: const Text('Resolution'),
                    value: Text(widget.params.getResolutionToString()),
                    onPressed: (BuildContext context) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PickerScreen(
                                title: "Pick a resolution",
                                initialValue: widget.params.video.resolution,
                                values: getResolutionsMap());
                          }).then((value) {
                        if (value != null) {
                          setState(() {
                            widget.params.video.resolution = value;
                          });
                        }
                      });
                    },
                  ),
                  // SettingsTile(
                  //   title: Text('Framerate'),
                  //   value: Text(widget.params.video.fps.toString()),
                  //   onPressed: (BuildContext context) {
                  //     showDialog(
                  //         context: context,
                  //         builder: (context) {
                  //           return PickerScreen(
                  //               title: "Pick a frame rate",
                  //               initialValue:
                  //                   widget.params.video.fps.toString(),
                  //               values: fpsList.toMap());
                  //         }).then((value) {
                  //       if (value != null) {
                  //         setState(() {
                  //           widget.params.video.fps = value;
                  //         });
                  //       }
                  //     });
                  //   },
                  // ),
                  CustomSettingsTile(
                    child: Column(
                      children: [
                        SettingsTile(
                          title: const Text('Bitrate'),
                        ),
                        Row(
                          children: [
                            Slider(
                              value: (widget.params.video.bitrate / 1024)
                                  .toDouble(),
                              onChanged: (newValue) {
                                setState(() {
                                  widget.params.video.bitrate =
                                      (newValue.roundToDouble() * 1024)
                                          .toInt();
                                });
                              },
                              min: 500,
                              max: 10000,
                            ),
                            Text('${widget.params.video.bitrate}')
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Audio'),
                tiles: [
                  SettingsTile(
                    title: const Text("Number of channels"),
                    value: Text(widget.params.getChannelToString()),
                    onPressed: (BuildContext context) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PickerScreen(
                                title: "Pick the number of channels",
                                initialValue:
                                    widget.params.getChannelToString(),
                                values: getChannelsMap());
                          }).then((value) {
                        if (value != null) {
                          setState(() {
                            widget.params.audio.channel = value;
                          });
                        }
                      });
                    },
                  ),
                  // SettingsTile(
                  //   title: Text('Bitrate'),
                  //   value: Text(widget.params.getBitrateToString()),
                  //   onPressed: (BuildContext context) {
                  //     showDialog(
                  //         context: context,
                  //         builder: (context) {
                  //           return PickerScreen(
                  //               title: "Pick a bitrate",
                  //               initialValue:
                  //                   widget.params.getChannelToString(),
                  //               values: audioBitrateList.toMap(
                  //                   valueTransformation: (int e) =>
                  //                       bitrateToPrettyString(e)));
                  //         }).then((value) {
                  //       if (value != null) {
                  //         setState(() {
                  //           widget.params.audio.bitrate = value;
                  //         });
                  //       }
                  //     });
                  //   },
                  // ),
                  SettingsTile(
                    title: const Text('Sample rate'),
                    value: Text(widget.params.getSampleRateToString()),
                    onPressed: (BuildContext context) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PickerScreen(
                                title: "Pick a sample rate",
                                initialValue:
                                    widget.params.getSampleRateToString(),
                                values: getSampleRatesMap());
                          }).then((value) {
                        if (value != null) {
                          setState(() {
                            widget.params.audio.sampleRate = value;
                          });
                        }
                      });
                    },
                  ),
                  SettingsTile.switchTile(
                    title: const Text('Enable echo canceler'),
                    initialValue: widget.params.audio.enableEchoCanceler,
                    onToggle: (bool value) {
                      setState(() {
                        widget.params.audio.enableEchoCanceler = value;
                      });
                    },
                  ),
                  SettingsTile.switchTile(
                    title: const Text('Enable noise suppressor'),
                    initialValue: widget.params.audio.enableNoiseSuppressor,
                    onToggle: (bool value) {
                      setState(() {
                        widget.params.audio.enableNoiseSuppressor = value;
                      });
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Endpoint'),
                tiles: [
                  SettingsTile(
                      title: const Text('RTMP endpoint'),
                      value: Text(widget.params.rtmpUrl),
                      onPressed: (BuildContext context) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return EditTextScreen(
                                  title: "Enter RTMP endpoint URL",
                                  initialValue: widget.params.rtmpUrl,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.params.rtmpUrl = value;
                                    });
                                  });
                            });
                      }),
                  SettingsTile(
                      title: const Text('Stream key'),
                      value: Text(widget.params.streamKey),
                      onPressed: (BuildContext context) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return EditTextScreen(
                                  title: "Enter stream key",
                                  initialValue: widget.params.streamKey,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.params.streamKey = value;
                                    });
                                  });
                            });
                      }),
                ],
              )
            ],
          )),
    );
  }

  Widget _arrowBackLeadingIcon() {
    return Padding(
          padding: const EdgeInsets.only(left: 14),
          child: GestureDetector(
              onTap: () {
                  Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: greyNavy)),
    );
  }
}

class PickerScreen extends StatelessWidget {
  const PickerScreen({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.values,
  }) : super(key: key);

  final String title;
  final dynamic initialValue;
  final Map<dynamic, String> values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(title),
            tiles: values.keys.map((e) {
              final value = values[e];

              return SettingsTile(
                title: Text(value!),
                onPressed: (_) {
                  Navigator.of(context).pop(e);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class EditTextScreen extends StatelessWidget {
  const EditTextScreen(
      {Key? key,
      required this.title,
      required this.initialValue,
      required this.onChanged})
      : super(key: key);

  final String title;
  final String initialValue;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        sections: [
          SettingsSection(title: Text(title), tiles: [
            CustomSettingsTile(
              child: TextField(
                  controller: TextEditingController(text: initialValue),
                  onChanged: onChanged),
            ),
          ]),
        ],
      ),
    );
  }
}
