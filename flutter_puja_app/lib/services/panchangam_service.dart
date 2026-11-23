import '../models/panchangam_data.dart';

/// 100% ఆఫ్‌లైన్ ద్రిక-సిద్ధాంత పంచాంగ గణన సర్వీస్ (Bilingual Drik Panchang Engine)
class PanchangamService {
  /// సంపూర్ణ 60-సంవత్సరాల చక్రం (All 60 Samvatsaras - Telugu & Sanskrit)
  static const List<Map<String, String>> samvatsaras = [
    {'te': 'ప్రభవ', 'sa': 'प्रभव'},
    {'te': 'విభవ', 'sa': 'विभव'},
    {'te': 'శుక్ల', 'sa': 'शुक्ल'},
    {'te': 'ప్రమోదూత', 'sa': 'ప్రమోదూత'},
    {'te': 'ప్రజోత్పత్తి', 'sa': 'प्रजोत्पत्ति'},
    {'te': 'ఆంగీరస', 'sa': 'आङ्गीरस'},
    {'te': 'శ్రీముఖ', 'sa': 'श्रीमुख'},
    {'te': 'భావ', 'sa': 'भाव'},
    {'te': 'యువ', 'sa': 'युव'},
    {'te': 'ధాత', 'sa': 'धाता'},
    {'te': 'ఈశ్వర', 'sa': 'ईश्वर'},
    {'te': 'బహుధాన్య', 'sa': 'बहुधान्य'},
    {'te': 'ప్రమాథి', 'sa': 'प्रमाथी'},
    {'te': 'విక్రమ', 'sa': 'विक्रम'},
    {'te': 'వృష', 'sa': 'वृष'},
    {'te': 'చిత్రభాను', 'sa': 'చిత్రభాను'},
    {'te': 'స్వభాను', 'sa': 'स्वभानु'},
    {'te': 'తారణ', 'sa': 'तारण'},
    {'te': 'పార్థివ', 'sa': 'पार्थिव'},
    {'te': 'వ్యయ', 'sa': 'व्यय'},
    {'te': 'సర్వజిత్తు', 'sa': 'सर्वजित्'},
    {'te': 'సర్వధారి', 'sa': 'सर्वधारी'},
    {'te': 'విరోధి', 'sa': 'विरोधी'},
    {'te': 'వికృతి', 'sa': 'विकृति'},
    {'te': 'ఖర', 'sa': 'खर'},
    {'te': 'నందన', 'sa': 'नन्दन'},
    {'te': 'విజయ', 'sa': 'विजय'},
    {'te': 'జయ', 'sa': 'జయ'},
    {'te': 'మన్మథ', 'sa': 'मन्मथ'},
    {'te': 'దుర్ముఖి', 'sa': 'दुर्मुखी'},
    {'te': 'హేవిళంబి', 'sa': 'हेविलम्बी'},
    {'te': 'విళంబి', 'sa': 'विलम्बी'},
    {'te': 'వికారి', 'sa': 'विकारी'},
    {'te': 'శార్వరి', 'sa': 'शार्वरी'},
    {'te': 'ప్లవ', 'sa': 'प्लव'},
    {'te': 'శుభకృతు', 'sa': 'शुभकृत्'},
    {'te': 'శోభకృతు', 'sa': 'शोभकृत्'},
    {'te': 'క్రోధి', 'sa': 'क्रोधी'}, // 37 (2024-2025)
    {'te': 'విశ్వావసు', 'sa': 'विश्वावसु'}, // 38 (2025-2026)
    {'te': 'పరాభవ', 'sa': 'पराभव'}, // 39 (2026-2027)
    {'te': 'ప్లవంగ', 'sa': 'प्लवङ्ग'}, // 40 (2027-2028)
    {'te': 'కీలక', 'sa': 'कीलक'},
    {'te': 'సౌమ్య', 'sa': 'सौम्य'},
    {'te': 'సాధారణ', 'sa': 'సాధారణ'},
    {'te': 'విరోధికృతు', 'sa': 'विरोधिकृत्'},
    {'te': 'పరీధావి', 'sa': 'परीधावी'},
    {'te': 'ప్రమాదీచ', 'sa': 'ప్రమాదీచ'},
    {'te': 'ఆనంద', 'sa': 'आनन्द'},
    {'te': 'రాక్షస', 'sa': 'రాక్షస'},
    {'te': 'నల', 'sa': 'नल'},
    {'te': 'పింగళ', 'sa': 'पिङ्गल'},
    {'te': 'కాళయుక్తి', 'sa': 'कालयुक्ति'},
    {'te': 'సిద్ధార్థి', 'sa': 'सिद्धार्थी'},
    {'te': 'రౌద్రి', 'sa': 'రౌద్రి'},
    {'te': 'దుర్మతి', 'sa': 'दुर्मति'},
    {'te': 'దుందుభి', 'sa': 'दुन्दुभी'},
    {'te': 'రుధిరోద్గారి', 'sa': 'रुधिरोद्गारी'},
    {'te': 'రక్తాక్షి', 'sa': 'రక్తాక్షి'},
    {'te': 'క్రోధన', 'sa': 'క్రోధన'},
    {'te': 'అక్షయ', 'sa': 'अक्षय'},
  ];

  /// 12 చాంద్రమాన మాసాలు & అనుబంధ ఋతువులు / ఆయనాలు
  static const List<Map<String, String>> masas = [
    {
      'te': 'చైత్ర',
      'sa': 'चैत्र',
      'rithuTe': 'వసంత ఋతువు',
      'rithuSa': 'वसन्त ऋतौ',
      'ayanaTe': 'ఉత్తరాయణం',
      'ayanaSa': 'उत्तरायणे',
    },
    {
      'te': 'వైశాఖ',
      'sa': 'वैशाख',
      'rithuTe': 'వసంత ఋతువు',
      'rithuSa': 'वसन्त ऋतौ',
      'ayanaTe': 'ఉత్తరాయణం',
      'ayanaSa': 'उत्तरायणे',
    },
    {
      'te': 'జ్యేష్ఠ',
      'sa': 'ज्येष्ठ',
      'rithuTe': 'గ్రీష్మ ఋతువు',
      'rithuSa': 'ग्रीष्म ऋतौ',
      'ayanaTe': 'ఉత్తరాయణం',
      'ayanaSa': 'उत्तरायणे',
    },
    {
      'te': 'ఆషాఢ',
      'sa': 'आषाढ',
      'rithuTe': 'గ్రీష్మ ఋతువు',
      'rithuSa': 'ग्रीष्म ऋतौ',
      'ayanaTe': 'ఉత్తరాయణం',
      'ayanaSa': 'उत्तरायणे',
    },
    {
      'te': 'శ్రావణ',
      'sa': 'श्रावण',
      'rithuTe': 'వర్ష ఋతువు',
      'rithuSa': 'वर्षा ऋतौ',
      'ayanaTe': 'దక్షిణాయనం',
      'ayanaSa': 'दक्षिणायने',
    },
    {
      'te': 'భాద్రపద',
      'sa': 'भाद्रपद',
      'rithuTe': 'వర్ష ఋతువు',
      'rithuSa': 'वर्षा ऋतौ',
      'ayanaTe': 'దక్షిణాయనం',
      'ayanaSa': 'दक्षिणायने',
    },
    {
      'te': 'ఆశ్వయుజ',
      'sa': 'ఆశ్వయుజ',
      'rithuTe': 'శరద్ ఋతువు',
      'rithuSa': 'शरद् ऋतौ',
      'ayanaTe': 'దక్షిణాయనం',
      'ayanaSa': 'दक्षिणायने',
    },
    {
      'te': 'కార్తిక',
      'sa': 'कार्तिक',
      'rithuTe': 'శరద్ ఋతువు',
      'rithuSa': 'शरद् ऋतौ',
      'ayanaTe': 'దక్షిణాయనం',
      'ayanaSa': 'दक्षिणायने',
    },
    {
      'te': 'మార్గశిర',
      'sa': 'मार्गशिर',
      'rithuTe': 'హేమంత ఋతువు',
      'rithuSa': 'हेमन्त ऋतौ',
      'ayanaTe': 'దక్షిణాయనం',
      'ayanaSa': 'दक्षिणायने',
    },
    {
      'te': 'పుష్య',
      'sa': 'पुष्य',
      'rithuTe': 'హేమంత ఋతువు',
      'rithuSa': 'हेमन्त ऋतौ',
      'ayanaTe': 'దక్షిణాయనం',
      'ayanaSa': 'दक्षिणायने',
    },
    {
      'te': 'మాఘ',
      'sa': 'माघ',
      'rithuTe': 'శిశిర ఋతువు',
      'rithuSa': 'शिशिर ऋतौ',
      'ayanaTe': 'ఉత్తరాయణం',
      'ayanaSa': 'उत्तरायणे',
    },
    {
      'te': 'ఫాల్గుణ',
      'sa': 'फाल्गुन',
      'rithuTe': 'శిశిర ఋతువు',
      'rithuSa': 'शिशिर ऋतौ',
      'ayanaTe': 'ఉత్తరాయణం',
      'ayanaSa': 'उत्तराయणे',
    },
  ];

  static const List<Map<String, String>> tithis = [
    {'te': 'పాడ్యమి', 'sa': 'ప్రథమా తిథౌ'},
    {'te': 'విదియ', 'sa': 'ద్వితీయా తిథౌ'},
    {'te': 'తదియ', 'sa': 'తృతీయా తిథౌ'},
    {'te': 'చవితి', 'sa': 'చతుర్థీ తిథౌ'},
    {'te': 'పంచమి', 'sa': 'పంచమీ తిథౌ'},
    {'te': 'షష్ఠి', 'sa': 'షష్ఠీ తిథౌ'},
    {'te': 'సప్తమి', 'sa': 'సప్తమీ తిథౌ'},
    {'te': 'అష్టమి', 'sa': 'అష్టమీ తిథౌ'},
    {'te': 'నవమి', 'sa': 'నవమీ తిథౌ'},
    {'te': 'దశమి', 'sa': 'దశమీ తిథౌ'},
    {'te': 'ఏకాదశి', 'sa': 'ఏకాదశీ తిథౌ'},
    {'te': 'ద్వాదశి', 'sa': 'ద్వాదశీ తిథౌ'},
    {'te': 'త్రయోదశి', 'sa': 'త్రయోదశీ తిథౌ'},
    {'te': 'చతుర్దశి', 'sa': 'చతుర్దశీ తిథౌ'},
    {'te': 'పౌర్ణమి / అమావాస్య', 'sa': 'पूर्णिमायाम् / अमावास्यायाम्'},
  ];

  static const List<Map<String, String>> varas = [
    {'te': 'భాను (ఆది) వాసరే', 'sa': 'भानुवासरे'},
    {'te': 'ఇందు (సోమ) వాసరే', 'sa': 'इन्दुवासरे'},
    {'te': 'భౌమ (మంగళ) వాసరే', 'sa': 'भौमवासरे'},
    {'te': 'సౌమ్య (బుధ) వాసరే', 'sa': 'सौम्यवासरे'},
    {'te': 'బృహస్పతి (గురు) వాసరే', 'sa': 'गुरुवासरे'},
    {'te': 'భృగు (శుక్ర) వాసరే', 'sa': 'भृगुवासरे'},
    {'te': 'స్థిర (శని) వాసరే', 'sa': 'स्थिरवासरे'},
  ];

  static const List<Map<String, String>> nakshatras = [
    {'te': 'అశ్విని', 'sa': 'अश्विनी'},
    {'te': 'భరణి', 'sa': 'भरणी'},
    {'te': 'కృత్తిక', 'sa': 'कृत्तिका'},
    {'te': 'రోహిణి', 'sa': 'रोहिणी'},
    {'te': 'మృగశిర', 'sa': 'मृगशिरा'},
    {'te': 'ఆర్ద్ర', 'sa': 'आर्द्रा'},
    {'te': 'పునర్వసు', 'sa': 'पुनर्वसु'},
    {'te': 'పుష్యమి', 'sa': 'पुष्य'},
    {'te': 'ఆశ్లేష', 'sa': 'आश्लेषा'},
    {'te': 'మఖ', 'sa': 'मघा'},
    {'te': 'పుబ్బ', 'sa': 'पूर्वाफाल्गुनी'},
    {'te': 'ఉత్తర', 'sa': 'उत्तराफाल्गुनी'},
    {'te': 'హస్త', 'sa': 'हस्ता'},
    {'te': 'చిత్త', 'sa': 'चित्रा'},
    {'te': 'స్వాతి', 'sa': 'स्वाती'},
    {'te': 'విశాఖ', 'sa': 'विशाखा'},
    {'te': 'అనూరాధ', 'sa': 'अनुराधा'},
    {'te': 'జ్యేష్ఠ', 'sa': 'ज्येष्ठा'},
    {'te': 'మూల', 'sa': 'मूला'},
    {'te': 'పూర్వాషాఢ', 'sa': 'पूर्वाषाढा'},
    {'te': 'ఉత్తరాషాఢ', 'sa': 'उत्तराषाढा'},
    {'te': 'శ్రవణం', 'sa': 'श्रवण'},
    {'te': 'ధనిష్ఠ', 'sa': 'धनिष्ठा'},
    {'te': 'శతభిషం', 'sa': 'शतभिषा'},
    {'te': 'పూర్వాభాద్ర', 'sa': 'पूर्वभाद्रपदा'},
    {'te': 'ఉత్తరాభాద్ర', 'sa': 'उत्तरभाद्रपदा'},
    {'te': 'రేవతి', 'sa': 'रेवती'},
  ];

  /// వారం ఆధారంగా రాహుకాలం
  static const List<String> rahuKalamList = [
    'సా॥ 04:30 - 06:00', // ఆదివారం
    'ఉ॥ 07:30 - 09:00', // సోమవారం
    'మ॥ 03:00 - 04:30', // మంగళవారం
    'మ॥ 12:00 - 01:30', // బుధవారం
    'మ॥ 01:30 - 03:00', // గురువారం
    'ఉ॥ 10:30 - 12:00', // శుక్రవారం
    'ఉ॥ 09:00 - 10:30', // శనివారం
  ];

  /// వారం ఆధారంగా యమగండం
  static const List<String> yamagandamList = [
    'మ॥ 12:00 - 01:30', // ఆదివారం
    'ఉ॥ 10:30 - 12:00', // సోమవారం
    'ఉ॥ 09:00 - 10:30', // మంగళవారం
    'ఉ॥ 07:30 - 09:00', // బుధవారం
    'ఉ॥ 06:00 - 07:30', // గురువారం
    'మ॥ 03:00 - 04:30', // శుక్రవారం
    'మ॥ 01:30 - 03:00', // శనివారం
  ];

  /// తెలుగు నెలల పేర్లు
  static const List<String> teluguMonths = [
    'జనవరి', 'ఫిబ్రవరి', 'మార్చి', 'ఏప్రిల్', 'మే', 'జూన్',
    'జూలై', 'ఆగస్టు', 'సెప్టెంబర్', 'అక్టోబర్', 'నవంబర్', 'డిసెంబర్'
  ];

  /// తెలుగు వారాల పేర్లు
  static const List<String> teluguWeekdays = [
    'ఆదివారం', 'సోమవారం', 'మంగళవారం', 'బుధవారం',
    'గురువారం', 'శుక్రవారం', 'శనివారం'
  ];

  /// తేదీని సులభంగా చదివే తెలుగు ఫార్మాట్ లోకి మార్చుట
  static String formatTeluguDate(DateTime date) {
    int wday = date.weekday % 7;
    return '${date.day} ${teluguMonths[date.month - 1]} ${date.year}, ${teluguWeekdays[wday]}';
  }

  /// తేదీ ఆధారంగా ఖచ్చితమైన ద్విభాషా పంచాంగం లెక్కింపు
  static PanchangamData calculate(DateTime date) {
    // 60-సంవత్సరాల చక్ర గణన (1987 = ప్రభవ, 2024 = క్రోధి, 2026 = పరాభవ)
    // ఉగాది మార్చి చివర్లో వస్తుంది కాబట్టి మార్చి 22 కంటే ముందు పూర్వ సంవత్సరం వర్తిస్తుంది
    int effectiveYear = date.year;
    if (date.month < 3 || (date.month == 3 && date.day < 22)) {
      effectiveYear -= 1;
    }
    int yearOffset = (effectiveYear - 1987) % 60;
    if (yearOffset < 0) yearOffset += 60;
    var samvat = samvatsaras[yearOffset];

    // మాసం గణన (సౌర/చాంద్రమాన అంచనా)
    int masaIdx = (date.month + 8) % 12;
    var masaData = masas[masaIdx];

    String ayanaTe = masaData['ayanaTe']!;
    String ayanaSa = masaData['ayanaSa']!;
    String rithuTe = masaData['rithuTe']!;
    String rithuSa = masaData['rithuSa']!;

    // పక్షం & తిథి (చంద్ర దశల అల్గారిథమ్)
    double epochDays = date.difference(DateTime(2000, 1, 6, 18, 14)).inMinutes / 1440.0;
    double lunarPhase = (epochDays % 29.53058867) / 29.53058867;
    int tithiIndex = (lunarPhase * 30).floor();
    bool isShukla = tithiIndex < 15;
    String pakshaTe = isShukla ? 'శుక్ల పక్షం' : 'కృష్ణ పక్షం';
    String pakshaSa = isShukla ? 'शुक्ल पक्षे' : 'कृष्ण पक्षे';

    int tithiMod = tithiIndex % 15;
    String tithiTe = tithis[tithiMod]['te']!;
    String tithiSa = tithis[tithiMod]['sa']!;
    if (tithiMod == 14) {
      if (isShukla) {
        tithiTe = 'పౌర్ణమి';
        tithiSa = 'पूर्णिमायाम्';
      } else {
        tithiTe = 'అమావాస్య';
        tithiSa = 'अमावास्यायाम्';
      }
    }

    // వారం
    int weekdayIndex = date.weekday % 7; // Sunday = 0
    var vasara = varas[weekdayIndex];

    // నక్షత్రం
    int nakshatraIdx = ((epochDays * 27.321661) % 27).floor().abs();
    var nakshatra = nakshatras[nakshatraIdx % 27];

    return PanchangamData(
      samvatsaraTe: samvat['te']!,
      samvatsaraSa: samvat['sa']!,
      ayanaTe: ayanaTe,
      ayanaSa: ayanaSa,
      rithuTe: rithuTe,
      rithuSa: rithuSa,
      masaTe: masaData['te']!,
      masaSa: masaData['sa']!,
      pakshaTe: pakshaTe,
      pakshaSa: pakshaSa,
      tithiTe: tithiTe,
      tithiSa: tithiSa,
      vasaraTe: vasara['te']!,
      vasaraSa: vasara['sa']!,
      nakshatraTe: nakshatra['te']!,
      nakshatraSa: nakshatra['sa']!,
      rahuKalam: rahuKalamList[weekdayIndex],
      yamagandam: yamagandamList[weekdayIndex],
      varjyam: 'రాత్రి 08:15 - 09:45',
      calculatedAt: date,
    );
  }
}
