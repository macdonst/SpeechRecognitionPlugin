var SpeechRecognitionError = function () {
    this.type = "error";
    this.error = null;
    this.message = null;
};

SpeechRecognitionError['no-speech'] = 0;
SpeechRecognitionError['aborted'] = 1;
SpeechRecognitionError['audio-capture'] = 2;
SpeechRecognitionError['network'] = 3;
SpeechRecognitionError['not-allowed'] = 4;
SpeechRecognitionError['service-not-allowed'] = 5;
SpeechRecognitionError['bad-grammar'] = 6;
SpeechRecognitionError['language-not-supported'] = 7;

SpeechRecognitionError._errorCodes = [
    'no-speech',
    'aborted',
    'audio-capture',
    'network',
    'not-allowed',
    'service-not-allowed',
    'bad-grammar',
    'language-not-supported'
];

module.exports = SpeechRecognitionError;
