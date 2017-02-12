SpeechRecognitionPlugin
=======================

W3C Web Speech API - Speech Recognition plugin for PhoneGap

Update 2013/09/05
=================

Back to work on this but it's not ready yet so don't try to use.

Update 2013/08/05
=================

Hi, you are all probably wondering where the code is after seeing my PhoneGap Day US presentation or reading the slides. Well, I've been dealing with an illness in the family and have not has as much spare time as I would have hoped to update this project. However, things are working out better than I could have hoped for and I should have time to concentrate on this very soon.

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

To install the plugin use 

```
cordova plugin add https://github.com/macdonst/SpeechRecognitionPlugin
```

Since iOS 10 it's mandatory to add a `NSMicrophoneUsageDescription` in the info.plist to access the microphone.


To add this entry you can pass the `MICROPHONE_USAGE_DESCRIPTION` variable on plugin install.


Example:

`cordova plugin add https://github.com/macdonst/SpeechRecognitionPlugin --variable MICROPHONE_USAGE_DESCRIPTION="your usage message"`

If the variable is not provided it will use an empty message, but a usage description string is mandatory to submit your app to the Apple Store.


On iOS 10 and greater it uses the native SFSpeechRecognizer (same as Siri).

Supported locales for SFSpeechRecognizer are:
ro-RO, en-IN, he-IL, tr-TR, en-NZ, sv-SE, fr-BE, it-CH, de-CH, pl-PL, pt-PT, uk-UA, fi-FI, vi-VN, ar-SA, zh-TW, es-ES, en-GB, yue-CN, th-TH, en-ID, ja-JP, en-SA, en-AE, da-DK, fr-FR, sk-SK, de-AT, ms-MY, hu-HU, ca-ES, ko-KR, fr-CH, nb-NO, en-AU, el-GR, ru-RU, zh-CN, en-US, en-IE, nl-BE, es-CO, pt-BR, es-US, hr-HR, fr-CA, zh-HK, es-MX, id-ID, it-IT, nl-NL, cs-CZ, en-ZA, es-CL, en-PH, en-CA, en-SG, de-DE

Two-character codes can be used too.

On iOS 9 and older it uses iSpeech SDK, an API key is required, get one on https://www.ispeech.org/, it's free.
To provide the key, add this preference inside the config.xml
```
 <preference name="apiKey" value="yourApiKeyHere" />
 ```
 If none is provided it will use the demo key "developerdemokeydeveloperdemokey"
 
iSpeech supported languages are:
 
English (Canada) (en-CA) 	
English (United States) (en-US) 	
Spanish (Spain) (es-ES) 	
French (France) (fr-FR) 	
Italian (Italy) (it-IT) 	
Polish (Poland) (pl-PL) 	
Portuguese (Portugal) (pt-PT)


Two-character codes can be used too, but for English, "en" will use "en-US" 
 
 
