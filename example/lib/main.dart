import 'package:flutter/material.dart';
import 'package:unity_ads_flutter/unity_ads_flutter.dart';

//TODO use your own ids from the Unity Ads Dashboard
const String bannerPlacementId='banner';
const String videoPlacementId='video';
const String rewardedVideoPlacementId='rewardedVideo';
const String gameIdIOS='3201412';
const String gameIdAndroid='3201413';

void main() async {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with UnityAdsListener{

  UnityAdsError _error;
  String _errorMessage;
  bool _vidReady;
  bool _rewVidReady;
  bool _banReady;
  int _rewardVid;

  @override
  initState() {
    UnityAdsFlutter.prepareBanner(bannerPlacementId);
    UnityAdsFlutter.initialize(gameIdAndroid, gameIdIOS, this, true);
    UnityAdsFlutter.loadBanner(bannerPlacementId);
    _vidReady = false;
    _rewVidReady = false;
    _banReady = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
      if(_error!=null){
        body = new Center(
            child: new Text('$_error: $_errorMessage')
        );
      } else if(_banReady && _rewVidReady && _vidReady){
        UnityAdsFlutter.show(bannerPlacementId);
        body=new Center(
          child:new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                onPressed: () {
                  setState((){
                    _vidReady=false;
                  });
                  UnityAdsFlutter.show(videoPlacementId);
                },
                child: const Text('Video'),
              ),
              new RaisedButton(
                onPressed: () {
                  setState((){
                    _rewVidReady=false;
                  });
                  UnityAdsFlutter.show(rewardedVideoPlacementId);
                },
                child: const Text('Rewarded Video'),
              ),
            ],
          ),
        );
      } else {
        body = new Center(
            child:const Text('Waiting for an ad...')
        );
      }
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Unity Ads Flutter Example'),
        ),
        body: body,
      ),
    );
  }

  ///VIDEOS
  @override
  void onUnityAdsError(UnityAdsError error, String message) {
    print('$error occurred: $message');
    setState((){
      _error=error;
      _errorMessage=message;
    });
  }

  @override
  void onUnityAdsFinish(String placementId, FinishState result) {
    print('Finished $placementId with $result');
    switch(result) {
      case FinishState.error:
        _rewardVid=-1;
        break;
      case FinishState.skipped:
        _rewardVid=0;
        break;
      case FinishState.completed:
        _rewardVid=1;
        break;
      default:
        _rewardVid=-1;
        break;
    }
  }

  @override
  void onUnityAdsReady(String placementId) {
    print('Ready: $placementId');
    if (placementId == videoPlacementId){
      setState(() {
        _vidReady = true;
      });
    } else if(placementId == rewardedVideoPlacementId){
      setState(() {
        _rewVidReady = true;
      });
    } else if(placementId == bannerPlacementId){
      setState(() {
        _banReady = true;
      });
    }
  }

  @override
  void onUnityAdsStart(String placementId) {
    print('Start: $placementId');
    if(placementId == videoPlacementId){
      setState(() {
        _vidReady = false;
      });
    } else if(placementId == rewardedVideoPlacementId){
      setState(() {
        _rewVidReady = false;
      });
    }
  }


  ///BANNERS
  @override
  void onUnityBannerLoaded(String placementId, View view){
    print('Loaded $placementId at $view');
  }

  @override
  void onUnityBannerUnloaded(String placementId){
    print('Unloaded $placementId');
  }

  @override
  void onUnityBannerShow(String placementId){
    print('Show $placementId');
  }

  @override
  void onUnityBannerClick(String placementId){
    print('$placementId clicked');
  }

  @override
  void onUnityBannerHide(String placementId){
    print('$placementId hidden');
  }

  @override
  void onUnityBannerError(String message){
    print('error: $message');
  }
}
