# Change Log

Update 2013/08/05
=================

Hi, you are all probably wondering where the code is after seeing my PhoneGap Day US presentation or reading the slides.
Well, I've been dealing with an illness in the family and have not had as much spare time as I would have hoped to update this project.
However, things are working out better than I could have hoped for and I should have time to concentrate on this very soon.

Update 2013/09/05
=================

Back to work on this but it's not ready yet so don't try to use.

Update 2015/04/04
=================

Basic example is working on iOS and android
```
<script type="text/javascript">
var recognition;
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
    recognition = new SpeechRecognition();
    recognition.onresult = function(event) {
        if (event.results.length > 0) {
            q.value = event.results[0][0].transcript;
            q.form.submit();
        }
    }
}
</script>
<form action="http://www.example.com/search">
    <input type="search" id="q" name="q" size=60>
    <input type="button" value="Click to Speak" onclick="recognition.start()">
</form>
```

Example from section 6.1 Speech Recognition Examples of the W3C page
(https://dvcs.w3.org/hg/speech-api/raw-file/tip/speechapi.html#examples)

Update 2018/05/30
=================

Improved compatibility with the W3C specification (https://w3c.github.io/speech-api/webspeechapi.html) and other improvements.
* Result events are returned as `SpeechRecognitionResult` objects with the content matching the spec.
* Error events are returned as `SpeechRecognitionError` objects.
* Improved error reporting for Android.
* Added support for interim results for Android.
* Added support for more of the speech recognition events for iOS.
* Added support for the `config.xml` preference, `speechRecognitionAllowAudioOutput` to allow iOS apps to also output audio when using this plugin.
* Added ability to disable use of the iSpeech SDK for iOS using `speechRecognitionApiKey` preference.
* The `speechRecognitionApiKey` preference now replaces the original `apiKey` preference.


Update 2019/01/21
=================

* Improvements to error handling for Android
* Added support for "local" serviceURI for Android indicate a preference for offline (local) recognition.
* Fix to iOS support to allow for use of a Bluetooth Headset.
* Removed support for iSpeechSDK for iOS. Now requires iOS 10 or newer.

Update 2019/03/13
=================

* Fixed exception in iOS from divide by zero due to no transcripts being available.

Update 2020/03.23
=================

* Fixed issue with double results on some Android devices (LG G7 ThinQ for example; API 28)
