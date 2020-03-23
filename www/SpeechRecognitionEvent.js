var SpeechRecognitionEvent = function () {
    this.type = "result";
    this.resultIndex = 0;
    this.results = new SpeechRecognitionResultList();
    this.interpretation = null;
    this.emma = null;
};

module.exports = SpeechRecognitionEvent;
