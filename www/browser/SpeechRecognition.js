if (!window.SpeechRecognition && window.webkitSpeechRecognition) {
    window.SpeechRecognition = window.webkitSpeechRecognition;
}

if (!window.SpeechRecognitionError && window.webkitSpeechRecognitionError) {
    window.SpeechRecognitionError = window.webkitSpeechRecognitionError;
}

if (!window.SpeechRecognitionEvent && window.webkitSpeechRecognitionEvent) {
    window.SpeechRecognitionEvent = window.webkitSpeechRecognitionEvent;
}

if (!window.SpeechGrammar && window.webkitSpeechGrammar) {
    window.SpeechGrammar = window.webkitSpeechGrammar;
}

if (!window.SpeechGrammarList && window.webkitSpeechGrammarList) {
    window.SpeechGrammarList = window.webkitSpeechGrammarList;
    SpeechGrammarList.prototype.addFromURI = window.SpeechGrammarList.prototype.addFromUri;
}