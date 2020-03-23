SpeechRecognitionPlugin
=======================

W3C Web Speech API - Speech Recognition plugin for Cordova/PhoneGap

Basic Example
=============

Basic example is working on iOS, Android, and some Browsers.
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

Installation
============

To install the plugin from Github, use

```
cordova plugin add https://github.com/wifisher/SpeechRecognitionPlugin --variable MICROPHONE_USAGE_DESCRIPTION="your usage message" --variable SPEECH_RECOGNITION_USAGE_DESCRIPTION="your usage message"
```

iOS Quirks
==========

By default, this plugin sets up the app to only allow for audio input.
As such, after the first recognition request, the app will no longer allow for audio output.

If you need to also support audio output, for example with the `phonegap-plugin-speech-synthesis` plugin,
enable audio output with the `speechRecognitionAllowAudioOutput` preference in the `config.xml` file:
```
 <preference name="speechRecognitionAllowAudioOutput" value="true" />
```


iOS 10 and Newer
----------------

On iOS 10 and greater it uses the native SFSpeechRecognizer (same as Siri).

Since iOS 10 it's mandatory to add `NSMicrophoneUsageDescription` and `NSSpeechRecognitionUsageDescription` in the info.plist to access the microphone and speech recognition.
To add this entry you can pass the `MICROPHONE_USAGE_DESCRIPTION` and `SPEECH_RECOGNITION_USAGE_DESCRIPTION` variables on plugin install.

If the variable is not provided it will use an empty message, but a usage description string is mandatory to submit your app to the Apple Store.

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

On iOS 9 and older are not supported.
