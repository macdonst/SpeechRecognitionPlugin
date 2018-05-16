var SpeechRecognitionAlternative = function() {
    this.transcript = null;
    this.confidence = 0.0;
    // this.final may be present for backwards compatibility with v0.3.0 of this plugin.
};

module.exports = SpeechRecognitionAlternative;
