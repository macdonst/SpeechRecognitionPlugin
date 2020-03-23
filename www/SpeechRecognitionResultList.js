// A collection of responses (used in continuous mode)
// An extension of the Array object to also operate similarly to Chrome's implementation.
var SpeechRecognitionResultList = function() {};

SpeechRecognitionResultList.prototype = new Array;

SpeechRecognitionResultList.prototype.item = function (item) {
    return this[item];
};

module.exports = SpeechRecognitionResultList;
