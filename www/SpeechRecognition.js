var exec = require("cordova/exec");

/** 
    attribute SpeechGrammarList grammars;
    attribute DOMString lang;
    attribute boolean continuous;
    attribute boolean interimResults;
    attribute unsigned long maxAlternatives;
    attribute DOMString serviceURI;
 */
var SpeechRecognition = function () {
    this.grammars = null;
    this.lang = "en";
    this.continuous = false;
    this.interimResults = false;
    this.maxAlternatives = 1;
    this.serviceURI = "";
    
    // event methods
    this.onaudiostart = null;
    this.onsoundstart = null;
    this.onspeechstart = null;
    this.onspeechend = null;
    this.onsoundend = null;
    this.onaudioend = null;
    this.onresult = null;
    this.onnomatch = null;
    this.onerror = null;
    this.onstart = null;
    this.onend = null;
};

SpeechRecognition.prototype.start = function() {
    exec(null, null, "SpeechRecognition", "start", []);
};

SpeechRecognition.prototype.stop = function() {
    exec(null, null, "SpeechRecognition", "stop", []);
};

SpeechRecognition.prototype.abort = function() {
    exec(null, null, "SpeechRecognition", "abort", []);
};

module.exports = SpeechRecognition;
