/// పూజా దశ మోడల్ (Step-by-Step Guided Puja Step Model)
class PujaStepModel {
  final int stepNumber;
  final String stepId;
  final String titleTe;
  final String titleSa;
  final String actionInstructionTe; // యూజర్ చేయవలసిన స్పష్టమైన చర్య (e.g. "చేతిలో అక్షతలు ఉంచుకోండి")
  final String actionInstructionSa;
  final String slokaTe;
  final String slokaSa;
  final String transliteration;
  final String tatparyam;
  final String spiritualMeaning;
  final String audioKey;
  final bool hasInteractiveCounter; // 108 నామాలు మొదలైనవాటికి
  final int counterTarget;

  PujaStepModel({
    required this.stepNumber,
    required this.stepId,
    required this.titleTe,
    required this.titleSa,
    required this.actionInstructionTe,
    required this.actionInstructionSa,
    required this.slokaTe,
    required this.slokaSa,
    required this.transliteration,
    required this.tatparyam,
    required this.spiritualMeaning,
    required this.audioKey,
    this.hasInteractiveCounter = false,
    this.counterTarget = 1,
  });
}
