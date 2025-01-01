class CompletionParams {
  String prompt;
  int nPredict;
  double temperature;
  int topK;
  double topP;
  double minP;
  double xtcThreshold;
  double xtcProbability;
  double typicalP;
  int penaltyLastN;
  double penaltyRepeat;
  double penaltyFreq;
  double penaltyPresent;
  int mirostat;
  double mirostatTau;
  double mirostatEta;
  int seed;
  int nProbs;
  List<String> stop;

  CompletionParams({
    this.prompt = '',
    this.nPredict = 400,
    this.temperature = 0.7,
    this.topK = 40,
    this.topP = 0.95,
    this.minP = 0.05,
    this.xtcThreshold = 0.1,
    this.xtcProbability = 0.0,
    this.typicalP = 1.0,
    this.penaltyLastN = 64,
    this.penaltyRepeat = 1.0,
    this.penaltyFreq = 0.0,
    this.penaltyPresent = 0.0,
    this.mirostat = 0,
    this.mirostatTau = 5,
    this.mirostatEta = 0.1,
    this.seed = 0,
    this.nProbs = 0,
    this.stop = const ['</s>'],
  });
}
