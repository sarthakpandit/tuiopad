The TuioPad is an open source TUIO tracker for iOS devices such as the iPad, iPhone and iPod touch, which allows multi-touch remote control based on the <a href='http://www.tuio.org/'>TUIO protocol</a>. This application is available free of charge on the App Store and can be used in conjunction with any TUIO enabled client application. Its source code is also available under the terms of the GPL and therefore can be freely used for the creation of open source TUIO enabled mobile applications. Apart from that the TuioPad is also a useful tool for the development and testing of TUIO 1.1 client implementations.

<b>Notice</b>: To support the further development of the TUIO platform, we are looking for hardware donations of iOS and Android tablet devices. We are planning object tracking support along with the according TUIO object profile implementation. Please get in touch with martin\_at\_tuio\_dot\_org for further information.

The application binary can be installed directly from the <a href='http://itunes.apple.com/us/app/tuiopad/id412446962'>iTunes App Store</a>. If you are looking for a TUIO tracker on Android devices please check out <a href='https://code.google.com/p/tuiodroid'>TUIOdroid</a> instead.

<a href='http://www.youtube.com/watch?feature=player_embedded&v=8BGawz_It8Y' target='_blank'><img src='http://img.youtube.com/vi/8BGawz_It8Y/0.jpg' width='425' height=344 /></a>

<b>Features and Configuration:</b>
TuioPad implements the TUIO 1.1 Cursor profile and is capable of sending multi-touch events to TUIO clients on other devices via a WIFI or 3G network connection. Apart from the standard TUIO/UDP transport via port 3333 this application can also use alternative TUIO/TCP connections and alternative ports. The verbosity of the TUIO messages can be configured in order to improve the protocol robustness for unreliable network connections.<p>

The binary provided on the App Store requires iOS 3.1 or later. In order to compile this application you will need a working installation of OpenFrameworks 0.62 for iPhone.<p>

<img src='http://modin.yuri.at/extern/TuioPadSettings.png' />
<img src='http://modin.yuri.at/extern/TuioPadActive.png' />

<b>Acknowledgments:</b>
This application is based on <a href='http://www.openframeworks.cc'>OpenFrameworks</a> and has been created by <a href='http://www.memo.tv/'>Mehmet Akten</a> and <a href='http://modin.yuri.at'>Martin Kaltenbrunner</a>. The included C++ TUIO reference implementation is using the <a href='http://code.google.com/p/oscpack/'>oscpack</a> library by <a href='http://www.audiomulch.com/~rossb/'>Ross Bencina</a>. Please note that the GPL demands the publication of the full source code of any derived work. If you are planning to develop a proprietary application based on this code, we may be able to provide an alternative commercial license option.<p>

