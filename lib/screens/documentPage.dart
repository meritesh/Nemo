import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nemo/screens/video_player_custom.dart';
//E:\Coding\NEmo-main\rtyui
//////////
import 'package:provider/provider.dart';
import 'package:nemo/drivenew/load_document.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nemo/drivenew/googledrive.dart';

final themeMode = ValueNotifier(2);

List<Media> medias = <Media>[];

class DocumentPage extends StatefulWidget {
  List _traits = [];
  var _description;
  var maybeimage;
  String _title;
  var _client;
  var _videoFolder;
  DocumentPage(this._description, this._traits, this._title, this.maybeimage,
      this._client, this._videoFolder);

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  Player player = Player(id: 4);
  MediaType mediaType = MediaType.file;
  CurrentState current = new CurrentState();
  PositionState position = new PositionState();
  PlaybackState playback = new PlaybackState();
  GeneralState general = new GeneralState();
  VideoDimensions videoDimensions = new VideoDimensions(0, 0);
  List<Device> devices = <Device>[];
  TextEditingController controller = new TextEditingController();
  TextEditingController metasController = new TextEditingController();
  Media? metasMedia;
  Playlist playlist =
      Playlist(medias: medias, playlistMode: PlaylistMode.single);
  int currentVideoIndex = 0;
  bool isLoading = false;
  bool _imageload = true;
  var _currentvideo = 0;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //  this.player = await Player.create(id: 0);
    this.player.currentStream.listen((current) {
      this.setState(() => this.current = current);
    });
    this.player.positionStream.listen((position) {
      this.setState(() => this.position = position);
    });
    this.player.playbackStream.listen((playback) {
      this.setState(() => this.playback = playback);
    });
  }

  void refreshplayer1() {
    setState(() {
      this.player.open(
            Playlist(medias: medias, playlistMode: PlaylistMode.single),
          );
    });
  }

  void loadnext(var _temp) {
    Timer(Duration(microseconds: 500), () {
      refreshplayer1();
      _temp = _temp + 1;
      this.player.jump(_temp);
    });
  }

  void refreshplayer() {
    Timer(Duration(seconds: 2), () {
      refreshplayer1();
      if (medias.length > 0) _load = false;
    });

    // print("printed after 4 seconds");
    // setState(() {
    //   this.player.open(
    //         Playlist(medias: medias, playlistMode: PlaylistMode.single),
    //       );
    // });
  }

  // void hardrefreshplayer() {
  //   //print("test 2");
  //   Timer(Duration(seconds: 5), () {
  //     refreshplayer1();
  //     //print("test 3");
  //   });
  //   //print("test 4");
  // }

  void longrefreshplayer() {
    print("Long refresh player called");
    Timer(Duration(seconds: 15), () {
      if (this.player.current.index == null) {
        refreshplayer1();
        if (medias.length > 0) _load = false;
      }
    });
  }

  bool first = true;
  void longlongrefreshplayer() {
    print("Long Long refresh player called");
    Timer(Duration(seconds: 30), () {
      if (this.player.current.index == null) {
        refreshplayer1();
        if (medias.length > 0) _load = false;
      }
      ;
    });
  }

  final drive = GoogleDrive();
  ScrollController controller1 = ScrollController();
  ScrollController controller2 = ScrollController();
  @override
  void initState() {
    DartVLC.initialize();
    _imageload = true;
    _load = true;
    refreshplayer();
    longrefreshplayer();
    longlongrefreshplayer();

    // TODO: implement initState
    super.initState();
    setState(() {
      this.player.open(
            new Playlist(medias: medias, playlistMode: PlaylistMode.single),
          );
    });
  }

  void dispose() {
    super.dispose();
    medias.clear();
    this.player.dispose();
  }

  bool _load = false;
  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? Container(
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0)),
                    width: 300.0,
                    height: 200.0,
                    alignment: AlignmentDirectional.center,
                    child: (widget._videoFolder != null)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    value: null,
                                    strokeWidth: 7.0,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 25.0),
                                child: Center(
                                  child: Text(
                                    "Video is loading.. \n ....wait...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              TextButton(
                                child: Text('Manual Refresh'),
                                onPressed: () {
                                  //Navigator.pop(context);
                                  setState(() {
                                    // if (this.player.current.index != null)
                                    //   _load = false;
                                    this.player.open(
                                          Playlist(
                                              medias: medias,
                                              playlistMode:
                                                  PlaylistMode.single),
                                        );
                                    if (medias.length > 0) _load = false;
                                  });
                                },
                              ),
                            ],
                          )
                        : Text("No video in Database"),
                  ),
                ),
              ],
            ),
          )
        : Container();
    //final myModel = context.watch<MyModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        //color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Description:"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: Text(widget._description),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index1) {
                        var item = widget._traits[index1]; //_list[index];
                        return ListTile(
                          leading: MyBullet(),
                          title: Text(item),
                        );
                      },

                      itemCount: widget._traits.length, //_list.length,
                      padding: const EdgeInsets.all(8.0),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 10,
              height: double.infinity,
              color: Colors.black,
              child: Text(""),
            ),
            Container(
              width: 720,
              child: ListView(
                controller: controller1,
                shrinkWrap: true,
                padding: EdgeInsets.all(4.0),
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Container(
                        color: Colors.black38,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 2.0,
                            //scrollDirection: Axis.vertical,
                            enlargeCenterPage: true,
                          ),
                          items: widget.maybeimage,
                        ),
                      )),
                  (_imageload)
                      ? TextButton(
                          child: Text('Load more Images'),
                          onPressed: () async {
                            final tempList =
                                await getMoreImages(widget._client);
                            setState(() {
                              widget.maybeimage = tempList;
                              _imageload = false;
                            });
                          },
                        )
                      : Container(),
                  Divider(
                    height: 25,
                    indent: 60,
                    endIndent: 60,
                    color: Colors.white,
                  ),
                  //Text("Photos"),
                  // FlatButton(
                  //   child: Text('to video'),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => DartVLCExample()),
                  //     );
                  //   },
                  // ),
                  Container(
                    width: 720,
                    height: 500,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isLoading
                                ? Stack(children: [
                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 2.0,
                                      child: Video(
                                        player: player,
                                        width: 640,
                                        height: 480,
                                        volumeThumbColor: Colors.blue,
                                        volumeActiveColor: Colors.blue,
                                      ),
                                    ),
                                    Positioned(
                                      left: 320,
                                      top: 240,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ])
                                : Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 2.0,
                                    child: Video(
                                      player: player,
                                      width: 640,
                                      height: 480,
                                      volumeThumbColor: Colors.blue,
                                      volumeActiveColor: Colors.blue,
                                    ),
                                  ),
                          ],
                        ),
                        Align(
                          child: loadingIndicator,
                          alignment: FractionalOffset.center,
                        )
                      ],
                    ),
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     isLoading
                  //         ? Stack(children: [
                  //             Card(
                  //               clipBehavior: Clip.antiAlias,
                  //               elevation: 2.0,
                  //               child: Video(
                  //                 player: player,
                  //                 width: 640,
                  //                 height: 480,
                  //                 volumeThumbColor: Colors.blue,
                  //                 volumeActiveColor: Colors.blue,
                  //               ),
                  //             ),
                  //             Positioned(
                  //               left: 320,
                  //               top: 240,
                  //               child: Center(
                  //                 child: CircularProgressIndicator(
                  //                   backgroundColor:
                  //                       Colors.grey.withOpacity(0.5),
                  //                 ),
                  //               ),
                  //             ),
                  //           ])
                  //         : Card(
                  //             clipBehavior: Clip.antiAlias,
                  //             elevation: 2.0,
                  //             child: Video(
                  //               player: player,
                  //               width: 640,
                  //               height: 480,
                  //               volumeThumbColor: Colors.blue,
                  //               volumeActiveColor: Colors.blue,
                  //             ),
                  //           ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (widget._videoFolder != null)
                        TextButton(
                            child: Text('Refresh Player'),
                            onPressed: () => this.setState(() {
                                  this.player.open(
                                        Playlist(
                                            medias: medias,
                                            playlistMode: PlaylistMode.single),
                                      );
                                }))
                      else
                        Text('No Video in Database'),
                      // TextButton(
                      //     child: Text('Get the List length'),
                      //     onPressed: () {
                      //       setState(() {
                      //         _load = true;
                      //       });
                      //       // print(medias.length);
                      //       // print(widget._videoFolder.length);
                      //       // print(videoNumber);
                      //       // print(this.player.current.index);
                      //     }),
                      if (videorendering)
                        Text('Loading')
                      else if (widget._videoFolder != null)
                        if (videoNumber < widget._videoFolder.length)
                          TextButton(
                              child: Text('Load Next video'),
                              onPressed: () async {
                                // setState(() {
                                //   //myModel.
                                //
                                // });
                                getVideo(widget._client, widget._videoFolder);
                                //print("test1");
                                //hardrefreshplayer();
                                loadnext(this.player.current.index);
                              })
                        else
                          Container(),
                      if (this.player.current.index != null)
                        if ((this.player.current.index)! < (medias.length - 1))
                          TextButton(
                              child: Text('Play Next Video'),
                              onPressed: () {
                                // this.player.next();
                                // _currentvideo != this.player.current.index;
                                // print(_currentvideo);
                                // print(this.player.current.index);
                                loadnext(this.player.current.index);
                              })
                        else
                          Container(),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}

/////////////////////////////////////////////
// ListView.builder(
// itemCount: imgList.length,
// itemBuilder: (context, index) {
// return Container(
// child:
// Image.network(imgList[index], fit: BoxFit.cover),
// );
// },
// ),
//////////////////////////
// Future<void> _loadDocument() async {
//   final docsApi = docsV1.DocsApi(widget._client);
//   var document = await docsApi.documents.get(widget.fileId);
//   print('document.title: ${document.body}');
//   _description =
//       document.body!.content![4].paragraph?.elements![0].textRun!.content;
//   for (var i = 7; i < document.body!.content!.length; i++) {
//     _traits.add(
//         document.body!.content![i].paragraph?.elements![0].textRun!.content);
//   }
//   print(_traits);
//   maybeimage = await drive.fileImageFuntion(widget._client);
// }

// class ButtonLoadVideo extends StatefulWidget {
//   const ButtonLoadVideo({Key? key}) : super(key: key);
//
//   @override
//   _ButtonLoadVideoState createState() => _ButtonLoadVideoState();
// }
//
// class _ButtonLoadVideoState extends State<ButtonLoadVideo> {
//   @override
//   Widget build(BuildContext context) {
//     if(videoNumber < widget._videoFolder.length)
//       return TextButton(
//           child: Text('Load Next video'),
//           onPressed: () {
//             setState(() {
//               getVideo(widget._client, widget._videoFolder);
//               //print("test123");
//               //refresh
//               // this.player.open(
//               //       Playlist(
//               //           medias: medias,
//               //           playlistMode: PlaylistMode.single),
//               //     );
//             });
//             //refreshplayer();
//             var _temp = this.player.current.index;
//             loadnext(_temp);
//           })
//     else
//       return Container();
//   }
// }
