/// ద్రిక-సిద్ధాంత ద్విభాషా పంచాంగ డేటా మోడల్ (Bilingual Panchangam Data Model)
class PanchangamData {
  final String samvatsaraTe;
  final String samvatsaraSa;
  final String ayanaTe;
  final String ayanaSa;
  final String rithuTe;
  final String rithuSa;
  final String masaTe;
  final String masaSa;
  final String pakshaTe;
  final String pakshaSa;
  final String tithiTe;
  final String tithiSa;
  final String vasaraTe;
  final String vasaraSa;
  final String nakshatraTe;
  final String nakshatraSa;
  final String rahuKalam;
  final String yamagandam;
  final String varjyam;
  final DateTime calculatedAt;

  PanchangamData({
    required this.samvatsaraTe,
    required this.samvatsaraSa,
    required this.ayanaTe,
    required this.ayanaSa,
    required this.rithuTe,
    required this.rithuSa,
    required this.masaTe,
    required this.masaSa,
    required this.pakshaTe,
    required this.pakshaSa,
    required this.tithiTe,
    required this.tithiSa,
    required this.vasaraTe,
    required this.vasaraSa,
    required this.nakshatraTe,
    required this.nakshatraSa,
    required this.rahuKalam,
    required this.yamagandam,
    required this.varjyam,
    required this.calculatedAt,
  });
}
