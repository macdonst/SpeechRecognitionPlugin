SpeechRecognitionPlugin Extended With Continuous Voice Recognition For Android
=======================

Update 2015/04/04
=================

Basic example is working on iOS and android
```
<script type="text/javascript">

var instructions = ["Cut onions into small cubes", "Fry onions on medium heat", "Add Chicken", "Cook Chicken For Two Minutes",
                      "Add cookeded chiken and onions to rice."];
var i = 0;
var recognition;
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
    recognition = new SpeechRecognition();
    recognition.onresult = function(event) {
        if (event.results.length > 0) {
          var heardValue = event.results[0][0].transcript;
          if(heardValue == "next") {
            i++;
            q.value = instructions[i];
            q.form.submit();
          } else if(heardValue == "previous") {
            i--;
            q.value = instructions[i];
            q.form.submit();
          }
        }
    }
}
</script>
<form action="http://www.example.com/search">
    <input type="search" id="q" name="q" size=60>
    <input type="button" value="Click to Speak" onclick="recognition.start()">
    <input type="button" value="Click to Stop Speech" onclick="recognition.abort()">
</form>
```

Example from section 6.1 Speech Recognition Examples of the W3C page
(https://dvcs.w3.org/hg/speech-api/raw-file/tip/speechapi.html#examples)

To install the plugin use

You must provide the proper permissions in your app's `AndroidManifest.xml` file like this:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

```
cordova plugin add https://github.com/milestester/SpeechRecognitionPlugin.git
```

The iOS version uses iSpeech SDK, an API key is required, get one on https://www.ispeech.org/, it's free.
To provide the key, add this preference inside the config.xml
```
 <preference name="apiKey" value="yourApiKeyHere" />
 ```
 If none is provided it will use the demo key "developerdemokeydeveloperdemokey"

 Added iOS multiple language support, the supported languages are:

English (Canada) (en-CA)
English (United States) (en-US)
Spanish (Spain) (es-ES)
French (France) (fr-FR)
Italian (Italy) (it-IT)
Polish (Poland) (pl-PL)
Portuguese (Portugal) (pt-PT)

Two-character codes can be used too, but for English, "en" will use "en-US"


