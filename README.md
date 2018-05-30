SpeechRecognitionPlugin
=======================

W3C Web Speech API - Speech Recognition plugin for Cordova/PhoneGap

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

Installation
============

To install the plugin, use 

```
cordova plugin add phonegap-plugin-speech-recognition --variable MICROPHONE_USAGE_DESCRIPTION="your usage message"
```

To install the plugin from Github, use

```
cordova plugin add https://github.com/macdonst/SpeechRecognitionPlugin --variable MICROPHONE_USAGE_DESCRIPTION="your usage message"
```

iOS Quirks
==========

Since iOS 10 it's mandatory to add a `NSMicrophoneUsageDescription` in the info.plist to access the microphone.
To add this entry you can pass the `MICROPHONE_USAGE_DESCRIPTION` variable on plugin install.

If the variable is not provided it will use an empty message, but a usage description string is mandatory to submit your app to the Apple Store.

iOS 10 and Newer
----------------

On iOS 10 and greater it uses the native SFSpeechRecognizer (same as Siri).

Supported locales for SFSpeechRecognizer are:
* ar-SA
* ca-ES
* cs-CZ
* da-DK
* de-AT
* de-CH
* de-DE
* el-GR
* en-AE
* en-AU
* en-CA
* en-GB
* en-ID
* en-IE
* en-IN
* en-NZ
* en-PH
* en-SA
* en-SG
* en-US
* en-ZA
* es-CL
* es-CO
* es-ES
* es-MX
* es-US
* fi-FI
* fr-BE
* fr-CA
* fr-CH
* fr-FR
* he-IL
* hr-HR
* hu-HU
* id-ID
* it-CH
* it-IT
* ja-JP
* ko-KR
* ms-MY
* nb-NO
* nl-BE
* nl-NL
* pl-PL
* pt-BR
* pt-PT
* ro-RO
* ru-RU
* sk-SK
* sv-SE
* th-TH
* tr-TR
* uk-UA
* vi-VN
* yue-CN
* zh-CN
* zh-HK
* zh-TW
* possibly others

Two-character codes can be used as well.

iOS 9 and Older
---------------

On iOS 9 and older it uses iSpeech SDK, an API key is required, get one from https://www.ispeech.org/.
To provide the key, add this preference inside the config.xml:
```
 <preference name="speechRecognitionApiKey" value="yourApiKeyHere" />
```

If none is provided it will use the demo key "developerdemokeydeveloperdemokey"

To disable the use of the iSpeech SDK, pass `disable` as the key value:
```
 <preference name="speechRecognitionApiKey" value="disable" />
```

iSpeech supported languages are:
 
* English (Canada) (en-CA)
* English (United States) (en-US)
* French (France) (fr-FR)
* Italian (Italy) (it-IT)
* Polish (Poland) (pl-PL)
* Portuguese (Portugal) (pt-PT)
* Spanish (Spain) (es-ES)
* possibly others

Two-character codes can be used too, but for English, "en" will use "en-US" 
