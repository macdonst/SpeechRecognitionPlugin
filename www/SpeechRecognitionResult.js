// A complete one-shot simple response
// An extension of the Array object to also operate similarly to Chrome's implementation.
var SpeechRecognitionResult = function () {
    Array.call(this);

    this.isFinal = false;
};

SpeechRecognitionResult.prototype = new Array;
SpeechRecognitionResult.prototype.constructor = SpeechRecognitionResult;

SpeechRecognitionResult.prototype.item = function (item) {
    return this[item];
};

module.exports = SpeechRecognitionResult;
