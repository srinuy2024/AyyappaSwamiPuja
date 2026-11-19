import '../models/devotee_profile.dart';
import '../models/panchangam_data.dart';

/// భక్తుని ప్రొఫైల్ & దేవత ఆధారంగా లైవ్ ద్విభాషా సంకల్ప జనరేటర్
class DynamicSankalpamService {
  /// సంస్కృత & తెలుగు ద్విభాషా సంకల్ప వాక్యాల నిర్మాణం
  static Map<String, String> generateBilingualSankalpam({
    required DevoteeProfile profile,
    required PanchangamData panchang,
    required String deityNameTe,
    required String deityNameSa,
  }) {
    // క్షేత్రం / నది నిర్ణయం
    String kshetraTe = 'కృష్ణా నదీ దక్షిణ తీరే, గుంటూరు దివ్య క్షేత్రే';
    String kshetraSa = 'कृष्णा नद्याः दक्षिण तीरे, गुन्टूरु दिव्य क्षेत्रे';

    if (profile.pincode.startsWith('533')) {
      kshetraTe = 'గౌతమీ గోదావరీ నదీ తీరే';
      kshetraSa = 'गौतमी गोदावरी नद्याः तीरे';
    } else if (profile.pincode.startsWith('500')) {
      kshetraTe = 'భాగ్యనగర దివ్య క్షేత్రే';
      kshetraSa = 'भाग्यनगर दिव्य क्षेत्रे';
    }

    // తెలుగు సంకల్పం
    String sankalpamTe = '''
శుభే శోభనే ముహూర్తే, శ్రీ మహావిష్ణోరాజ్ఞయా ప్రవర్తమానస్య, అద్య బ్రహ్మణః ద్వితీయ పరార్థే, శ్వేతవరాహ కల్పే, వైవస్వత మన్వంతరే, కలియుగే, ప్రథమ పాదే, జంబూద్వీపే, భరతవర్షే, భరతఖండే, మేరోర్దక్షిణ దిగ్భాగే, $kshetraTe, శోభన గృహే, సమస్త దేవతా బ్రాహ్మణ హరిహర గురు చరణ సన్నిధౌ,

అస్మిన్ వర్తమాన వ్యావహారిక చాంద్రమానేన శ్రీ ${panchang.samvatsaraTe} నామ సంవత్సరే, ${panchang.ayanaTe}, ${panchang.rithuTe}, ${panchang.masaTe} మాసే, ${panchang.pakshaTe}, ${panchang.tithiTe} తిథౌ, ${panchang.vasaraTe}, శుభ నక్షత్ర, శుభ యోగ, శుభ కరణ ఏవంగుణ విశేషణ విశిష్టాయాం శుభ తిథౌ,

శ్రీమతః ${profile.gotram} గోత్రోద్భవస్య, ${profile.kartaName} నామధేయస్య, ధర్మపత్నీ సమేతస్య (${profile.spouseName}), సపుత్రస్య సకుటుంబస్య (${profile.childrenNames}),

మమ ఉపాత్త సమస్త దురితక్షయ ద్వారా, శ్రీ $deityNameTe ముద్దిశ్య, శ్రీ $deityNameTe ప్రీత్యర్థం, ధర్మార్ధ కామ మోక్ష చతుర్విధ పురుషార్థ ఫల సిద్ధ్యర్థం, క్షేమ స్థైర్య ధైర్య విజయ వీర్య ఆయురారోగ్య ఐశ్వర్యాభివృద్ధ్యర్థం, సకల మనోరథ ఫల సిద్ధ్యర్థం, సంభవద్భిః ద్రవ్యైః సంభవితా నియమేన ధ్యానావాహనాది షోడశోపచార నిత్య పూజాం కరిష్యే ||
''';

    // సంస్కృత దేవనాగరి సంకల్పం (Sanskrit Devanagari)
    String sankalpamSa = '''
शुभे शोभने मुहूर्ते, श्री महाविष्णोराज्ञया प्रवर्तमानस्य, अद्य ब्रह्मणः द्वितीय परार्धे, श्वेतवराह कल्पे, वैवस्वत मन्वन्तरे, कलियुगे, प्रथम पादे, जम्बूद्वीपे, भारतवर्षे, भरतखण्डे, मेरोर्दक्षिण दिग्भागे, $kshetraSa, शोभन गृहे, समस्त देवता ब्राह्मण हरिहर गुरु चरण सन्निधौ,

अस्मिन् वर्तमाने व्यावहारिक चान्द्रमानेन श्री ${panchang.samvatsaraSa} नाम संवत्सरे, ${panchang.ayanaSa}, ${panchang.rithuSa}, ${panchang.masaSa} मासे, ${panchang.pakshaSa}, ${panchang.tithiSa} तिथौ, ${panchang.vasaraSa}, शुभ नक्षत्रे, शुभ योगे, शुभ करणे, एवं गुण विशेषण विशिष्टायां शुभ तिथौ,

श्रीमन्तः ${profile.gotram} गोत्रोद्भवस्य, ${profile.kartaName} नामधेयस्य, धर्मपत्नी समेतस्य (${profile.spouseName}), सपुत्रस्य सकुंटुम्बस्य (${profile.childrenNames}),

मम उपात्त समस्त दुरितक्षय द्वारा, श्री $deityNameSa मुद्दिश्य, श्री $deityNameSa प्रीत्यर्थं, धर्मार्थ काम मोक्ष चतुर्विध पुरुषार्थ फल सिद्ध्यर्थं, क्षेम स्थैर्य धैर्य विजय वीर्य आयुरारोग्य ऐश्वर्याभिवृद्ध्यर्थं, सकल मनोरथ फल सिद्ध्यर्थं, सम्भवद्भिः द्रव्यैः सम्भाविता नियमेन ध्यानावाहनादि षोडशोपचार नित्य पूजां करिष्ये ॥
''';

    return {
      'telugu': sankalpamTe.trim(),
      'sanskrit': sankalpamSa.trim(),
    };
  }
}
