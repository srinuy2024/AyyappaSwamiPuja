import 'package:flutter/material.dart';
import '../models/devotee_profile.dart';
import '../models/panchangam_data.dart';
import '../models/puja_step_model.dart';
import '../services/panchangam_service.dart';
import '../services/dynamic_sankalpam_service.dart';
import '../constants/app_typography.dart';

/// యూజర్ ఫ్రెండ్లీ స్టెప్-బై-స్టెప్ గైడెడ్ పూజా ప్లేయర్ స్క్రీన్
class PujaPlayerScreen extends StatefulWidget {
  final DevoteeProfile devoteeProfile;
  final String deityId;
  final String deityNameTe;
  final String deityNameSa;

  const PujaPlayerScreen({
    Key? key,
    required this.devoteeProfile,
    required this.deityId,
    required this.deityNameTe,
    required this.deityNameSa,
  }) : super(key: key);

  @override
  _PujaPlayerScreenState createState() => _PujaPlayerScreenState();
}

class _PujaPlayerScreenState extends State<PujaPlayerScreen> {
  int _currentStepIndex = 0;
  String _activeScript = 'telugu'; // 'telugu' or 'sanskrit'
  bool _isMeaningExpanded = false;
  int _ashtottaraCounter = 0;
  bool _isPlayingAudio = false;

  late PanchangamData _panchang;
  late List<PujaStepModel> _pujaSteps;

  @override
  void initState() {
    super.initState();
    _panchang = PanchangamService.calculate(DateTime.now());
    _initializeSteps();
  }

  void _initializeSteps() {
    var sankalpaMap = DynamicSankalpamService.generateBilingualSankalpam(
      profile: widget.devoteeProfile,
      panchang: _panchang,
      deityNameTe: widget.deityNameTe,
      deityNameSa: widget.deityNameSa,
    );

    _pujaSteps = [
      PujaStepModel(
        stepNumber: 1,
        stepId: 'deepam',
        titleTe: '1. ప్రథమ దీపారాధన',
        titleSa: '१. प्रथम दीपाराधनम्',
        actionInstructionTe: 'ఆవునెయ్యి లేదా నువ్వుల నూనెతో రెండు ప్రమిదలలో దీపాలను వెలిగించి నమస్కరించండి.',
        actionInstructionSa: 'घृतेन तैलमिश्रितेन वा दीपं प्रज्वाल्य नमस्कुरुत ।',
        slokaTe: 'దీపం జ్యోతిః పరబ్రహ్మ దీపం సర్వతమోపహమ్ |\nదీపేన సాధ్యతే సర్వం సంధ్యాదీప నమోऽస్తు తే ||\nఆజ్ఞాన తిమిరాంధస్య జ్ఞానాంజన శలాకయా |\nచక్షురున్మీలితం యేన తస్మై శ్రీగురవే నమః ||',
        slokaSa: 'दीपं ज्योतिः परब्रह्म दीपं सर्वतमोपहम् ।\nदीपेन साध्यते सर्वं सन्ध्यादीप नमोऽस्तु ते ॥\nअज्ञान तिमिरान्धस्य ज्ञानाञ्जन शलाकया ।\nचक्षुरुन्मीलितं येन तस्मै श्रीगुरवे नमः ॥',
        transliteration: "dīpaṃ jyotiḥ parabrahma dīpaṃ sarvatamopaham...",
        tatparyam: 'దీపము పరబ్రహ్మ స్వరూపము. సకల అంధకారాలను నశింపజేసి సకల శుభాలను చేకూరుస్తుంది.',
        spiritualMeaning: 'రెండు వత్తులు జీవాత్మ, పరమాత్మల ఐక్యతకు ప్రతీక. అంతరంగంలోని అజ్ఞాన చీకట్లను తొలగించి జ్ఞాన దీపాన్ని వెలిగించడమే దీపారాధన అంతరార్థం.',
        audioKey: 'deeparadhana',
      ),
      PujaStepModel(
        stepNumber: 2,
        stepId: 'achamanam',
        titleTe: '2. ఆచమనం (అంతఃశుద్ధి)',
        titleSa: '२. आचमनम् (अन्तःशुद्धिः)',
        actionInstructionTe: 'ఆచమన పాత్ర నుండి మూడు ఉద్ధరిణల పవిత్ర జలమును కుడి అరచేతిలో పోసుకుని క్రమంగా స్వీకరించండి.',
        actionInstructionSa: 'आचमन पात्रात् त्रीणि वारान् हस्ततले जलं स्वीकृत्य प्राशयेत् ।',
        slokaTe: 'ఓం కేశవాయ స్వాహా | (ఒకసారి తీర్థం స్వీకరించండి)\nఓం నారాయణాయ స్వాహా | (రెండవసారి స్వీకరించండి)\nఓం మాధవాయ స్వాహా | (మూడవసారి స్వీకరించండి)\n\nగోవిందాయ నమః, విష్ణవే నమః, మధుసూదనాయ నమః, త్రివిక్రమాయ నమః, వామనాయ నమః, శ్రీధరాయ నమః, హృషీకేశాయ నమః, పద్మనాభాయ నమః, దామోదరాయ నమః...',
        slokaSa: 'ॐ केशवाय स्वाहा । (प्रथमं जलं पिबेत्)\nॐ नारायणाय स्वाहा । (द्वितीयं जलं पिबेत्)\nॐ माधवाय स्वाहा । (तृतीयं जलं पिबेत्)\n\nगोविन्दाय नमः, विष्णवे नमः, मधुसूदनाय नमः, त्रिविक्रमाय नमः, वामनाय नमः, श्रीधराय नमः, हृषीकेशाय नमः, पद्मनाभाय नमः, दामोदराय नमः...',
        transliteration: "oṃ keśavāya svāhā | oṃ nārāyaṇāya svāhā | oṃ mādhavāya svāhā ||",
        tatparyam: 'మూడు పర్యాయములు పవిత్ర జలమును స్వీకరించి, 21 విష్ణు నామములతో శరీర అవయవములను స్పృశించి పవిత్రత చేకూర్చుకొనుట.',
        spiritualMeaning: 'వాత, పిత్త, కఫములనే త్రిదోషాలను శాంతింపజేసి, ఇంద్రియాలను జాగృతం చేసి దైవధ్యానానికి సంసిద్ధం చేయడమే ఆచమన విజ్ఞానం.',
        audioKey: 'achamanam',
      ),
      PujaStepModel(
        stepNumber: 3,
        stepId: 'ghanta',
        titleTe: '3. ఘంటానాదం (దేవతాహ్వానం)',
        titleSa: '३. घण्टानादम् (देवताह्वानम्)',
        actionInstructionTe: 'ఎడమచేత్తో ఘంటను నిదానంగా మోగిస్తూ, కుడిచేతితో అక్షతలను స్వామి పీఠంపై సమర్పించండి.',
        actionInstructionSa: 'वामहस्तेन घण्टां नादयन्, दक्षिणहस्तेन अक्षतान् समर्पयेत् ।',
        slokaTe: 'ఆగమార్థం తు దేవానాం గమనార్థం తు రక్షసామ్ |\nకుర్వే ఘంటారవం తత్ర దేవతాహ్వాన లాంఛనమ్ ||',
        slokaSa: 'आगमार्थं तु देवानां गमनार्थं तु रक्षसाम् ।\nकुर्वे घण्टारवं तत्र देवताव्हान लाञ्छनम् ॥',
        transliteration: "āgamārthaṃ tu devānāṃ gamanārthaṃ tu rakṣasām...",
        tatparyam: 'దేవతలను మన పూజకు ఆహ్వానిస్తూ, ప్రతికూల శక్తులను పారద్రోలుతూ ఈ పవిత్ర నాదాన్ని సమర్పిస్తున్నాను.',
        spiritualMeaning: 'ఘంటానాదం నుండి వెలువడే ఓంకార ధ్వని తరంగాలు మనస్సులోని చంచలత్వాన్ని తొలగించి ఏకాగ్రతను కలిగిస్తాయి.',
        audioKey: 'bell',
      ),
      PujaStepModel(
        stepNumber: 4,
        stepId: 'sankalpam',
        titleTe: '4. లైవ్ డైనమిక్ సంకల్పం',
        titleSa: '४. प्रत्यक्ष सङ्कल्पः',
        actionInstructionTe: 'చేతిలో అక్షతలు, పువ్వు, కొద్దిగా నీరు ఉంచుకుని మీ గోత్ర నామములతో కూడిన సంకల్పం పఠించండి.',
        actionInstructionSa: 'हस्ते अक्षतान्, पुष्पं, जलं च धृत्वा सङ्कल्पं पठेत् ।',
        slokaTe: sankalpaMap['telugu']!,
        slokaSa: sankalpaMap['sanskrit']!,
        transliteration: "śubhe śobhane muhūrte... mama upātta duritakṣaya dvārā...",
        tatparyam: 'నేటి కాలచక్రంలో, నా గోత్రం (${widget.devoteeProfile.gotram}), నా కుటుంబ సభ్యులైన ${widget.devoteeProfile.kartaName}, ${widget.devoteeProfile.spouseName}, ${widget.devoteeProfile.childrenNames} ల ఆయురారోగ్య ఐశ్వర్యాభివృద్ధ్యర్థం శ్రీ ${widget.deityNameTe} పూజను సంకల్పించుచున్నాను.',
        spiritualMeaning: 'సంకల్పం అంటే అనంత విశ్వకాల చైతన్యంతో (Cosmic Space-Time) మన మనస్సును లయం చేసుకుని పూజా లక్ష్యాన్ని నిర్దేశించుకోవడం.',
        audioKey: 'sankalpam',
      ),
      PujaStepModel(
        stepNumber: 5,
        stepId: 'ganapathi',
        titleTe: '5. శ్రీ విఘ్నేశ్వర ప్రార్థన & పూజ',
        titleSa: '५. श्री विघ्नेश्वर पूजा',
        actionInstructionTe: 'పసుపు గణపతికి లేదా విగ్రహానికి గంధం, కుంకుమ, పూలు సమర్పించి విఘ్న నివారణకై ప్రార్థించండి.',
        actionInstructionSa: 'हरिद्रा गणपतये गन्धं, कुङ्कुमं, पुष्पाणि समर्प्य प्रार्थयेत् ।',
        slokaTe: 'శుక్లాంబరధరం విష్ణుం శశివర్ణం చతుర్భుజమ్ |\nప్రసన్నవదనం ధ్యాయేత్ సర్వవిఘ్నోపశాంతయే ||\nఅగజానన పద్మార్కం గజాననమహర్నిశమ్ |\nఅనేకదంతం భక్తానాం ఏకదంతముపాస్మహే ||',
        slokaSa: 'शुक्लाम्बरधरं विष्णुं शशिवर्णं चतुर्भुजम् ।\nप्रसन्नवदनं ध्यायेत् सर्वविघ्नोपशान्तये ॥\nअगजानन पद्मार्कं गजाननमहर्निशम् ।\nअनेकदन्तं भक्तानां एकदन्तमुपास्महे ॥',
        transliteration: "śuklāmbaradharaṃ viṣṇuṃ śaśivarṇaṃ caturbhujam...",
        tatparyam: 'తెల్లని వస్త్రము ధరించి, చంద్రుని వంటి ప్రశాంత కాంతి కలిగిన శ్రీ గణపతిని సకల విఘ్నాలు తొలగిపోవుటకై ధ్యానిస్తున్నాను.',
        spiritualMeaning: 'గణపతి మూలాధార చక్రానికి అధిపతి. అంతర్గత శక్తులు జాగృతమై పూజ నిర్విఘ్నంగా సాగడానికి ప్రథమంగా గణపతిని పూజిస్తారు.',
        audioKey: 'ganapathi',
      ),
      PujaStepModel(
        stepNumber: 6,
        stepId: 'shodasha',
        titleTe: '6. శ్రీ ${widget.deityNameTe} షోడశోపచారాలు',
        titleSa: '६. षोडशोपचार पूजा',
        actionInstructionTe: 'ధ్యానం నుండి నీరాజనం వరకు 16 ఉపచారాలను స్వామికి భక్తితో సమర్పించండి.',
        actionInstructionSa: 'ध्यानात् नीराजन पर्यन्तं षोडशोपचारान् भक्त्या समर्पयेत् ।',
        slokaTe: 'శ్రీ ${widget.deityNameTe} ధ్యాయామి, ఆవాహయామి | ఆసనం సమర్పయామి |\nపాద్యం సమర్పయామి | అర్ఘ్యం సమర్పయామి | ఆచమనీయం సమర్పయామి |\nస్నానం సమర్పయామి | వస్త్రయుగ్మం సమర్పయామి | యజ్ఞోపవీతం సమర్పయామి |\nదివ్య శ్రీచందనం సమర్పయామి | పుష్పమాలాం సమర్పయామి |\nధూపం ఆఘ్రాపయామి | దీపం దర్శయామి | నైవేద్యం సమర్పయామి |\nతాంబూలం సమర్పయామి | ఆనంద కర్పూర నీరాజనం సమర్పయామి ||',
        slokaSa: 'श्री ${widget.deityNameSa} ध्यायामि, आवाहयामि । आसनं समर्पयामि ।\nपाद्यं समर्पयामि । अर्घ्यं समर्पयामि । आचमनीयं समर्पयामि ।\nस्नानं समर्पयामि । वस्त्रयुग्मं समर्पयामि । यज्ञोपवीतं समर्पयामि ।\nदिव्य श्रीचन्दनं समर्पयामि । पुष्पमालां समर्पयामि ।\nधूपं आघ्रापयामि । दीपं दर्शयामि । नैवेद्यं समर्पयामि ।\nताम्बूलं समर्पयामि । आनन्द कर्पूर नीराजनं समर्पयामि ॥',
        transliteration: "dhyāyāmi, āvāhayāmi, āsanaṃ samarpayāmi, pādyaṃ samarpayāmi...",
        tatparyam: 'భగవంతుని మన ఇంటికి విచ్చేసిన పరమ పవిత్ర అతిథిగా భావించి 16 రకాల ఉపచారాలతో సేవించుట.',
        spiritualMeaning: 'మనలోని 16 సంస్కారాలను, భావాలను భగవంతునికి సంపూర్ణంగా అర్పించడమే షోడశోపచారాల ఆంతర్యం.',
        audioKey: 'shodasha',
      ),
      PujaStepModel(
        stepNumber: 7,
        stepId: 'ashtottaram',
        titleTe: '7. 108 దివ్య నామావళి & పుష్పార్చన',
        titleSa: '७. अष्टोत्तर शतनामावलिः (पुष्पार्चनम्)',
        actionInstructionTe: 'ఒక్కొక్క నామం చదువుతూ స్క్రీన్ పై తాకి పువ్వు సమర్పించండి (కౌంటర్ 108 వరకు సాగుతుంది).',
        actionInstructionSa: 'एकैकं नाम उच्चार्य पुष्पं समर्पयेत् (१०८ वारम्) ।',
        slokaTe: 'ఓం శ్రీ స్వామియే శరణమయ్యప్ప నమః 🌸\nఓం మహాశాస్త్రే నమః 🌸\nఓం విశ్వభర్త్రే నమః 🌸\nఓం లోకనాథాయ నమః 🌸\nఓం మహాద్యుతయే నమః 🌸\n(...సమస్త 108 నామాలు పుష్పార్చనతో)',
        slokaSa: 'ॐ श्री स्वामिये शरणमय्यप्प नमः 🌸\nॐ महाशास्त्रे नमः 🌸\nॐ विश्वभर्त्रे नमः 🌸\nॐ लोकनाथाय नमः 🌸\nॐ महाद्युतये नमः 🌸\n(...समस्त १०८ नामानि पुष्पार्चनेन)',
        transliteration: "oṃ śrī svāmiye śaraṇamayyappa namaḥ... oṃ mahāśāstre namaḥ...",
        tatparyam: 'స్వామి దివ్య గుణ నామాలను స్మరిస్తూ 108 సుగంధ పుష్పములతో అర్చన చేయుట.',
        spiritualMeaning: 'విశ్వంలోని 27 నక్షత్రాలు, 4 పాదాలు (27 × 4 = 108). సమస్త బ్రహ్మాండం స్వామి స్వరూపమే అని భావించి చేసే ఆరాధన.',
        audioKey: 'ashtottaram',
        hasInteractiveCounter: true,
        counterTarget: 108,
      ),
      PujaStepModel(
        stepNumber: 8,
        stepId: 'naivedyam',
        titleTe: '8. మహా నైవేద్యం & తాంబూలం',
        titleSa: '८. महानैवेद्यम्',
        actionInstructionTe: 'పంచామృతం, పాయసం లేదా పండ్లను సమర్పిస్తూ చుట్టూ మూడుసార్లు జలమును ప్రోక్షించండి.',
        actionInstructionSa: 'नैवेद्यं समर्प्य त्रीणि वारान् जलं प्रोक्षयेत् ।',
        slokaTe: 'ఓం భూర్భువస్సువః | తత్సవితుర్వరేణ్యం భర్గో దేవస్య ధీమహి ధియో యో నః ప్రచోదయాత్ ||\nసత్యం త్వర్తేన పరిషించామి (ఉదయం: సత్యం త్వర్తేన | సాయంకాలం: ఋతం త్వా సత్యేన) | అమృతమస్తు | అమృతోపస్తరణమసి ||\n\nఓం ప్రాణాయ స్వాహా | ఓం అపానాయ స్వాహా | ఓం వ్యానాయ స్వాహా |\nఓం ఉదానాయ స్వాహా | ఓం సమానాయ స్వాహా | ఓం బ్రహ్మణే స్వాహా ||\nమధ్యే మధ్యే పానీయం సమర్పయామి | అమృతాపిధానమసి ||',
        slokaSa: 'ॐ भूर्भुवस्सुवः । तत्सवितुर्वरेण्यं भर्गो देवस्य धीमहि धियो यो नः प्रचोदयात् ॥\nसत्यं त्वर्तेन परिषञ्चामि (प्रातः: सत्यं त्वर्तेन | सायं: ऋतं त्वा सत्येन) । अमृतमस्तु । अमृतोपस्तरणमसि ॥\n\nॐ प्राणाय स्वाहा । ॐ अपानाय स्वाहा । ॐ व्यानाय स्वाहा ।\nॐ उदानाय स्वाहा । ॐ समानाय स्वाहा । ॐ ब्रह्मणे स्वाहा ॥\nमध्ये मध्ये पानीयं समर्पयामि । अमृतापिधानमसि ॥',
        transliteration: "oṃ prāṇāya svāhā | oṃ apānāya svāhā | oṃ vyānāya svāhā...",
        tatparyam: 'పంచ ప్రాణ స్వరూపుడైన పరమాత్మకు భక్తితో అమృతతుల్యమైన ఆహార నైవేద్యమును సమర్పించుట.',
        spiritualMeaning: 'మనం తినే ఆహారమే మన ఆలోచనలను నిర్దేశిస్తుంది. ఆ ఆహారాన్ని దైవార్పణ చేయడం ద్వారా అది పవిత్ర ప్రసాదంగా మారుతుంది.',
        audioKey: 'naivedyam',
      ),
      PujaStepModel(
        stepNumber: 9,
        stepId: 'harathi',
        titleTe: '9. మంగళ హారతి & లోకవీరం',
        titleSa: '९. मङ्गल नीराजनम् & लोकवीरम्',
        actionInstructionTe: 'కర్పూర హారతిని వెలిగించి స్వామికి నివేదిస్తూ, ఘంట వాయిస్తూ భక్తితో స్తుతించండి.',
        actionInstructionSa: 'कर्पूर नीराजनं प्रज्वाल्य स्वामिने दर्शयेत् ।',
        slokaTe: 'లోకవీరం మహాపూజ్యం సర్వరక్షాకరం విభుమ్ |\nమనోహరం సురశ్రేష్ఠం శాస్తారం ప్రణమామ్యహమ్ ||\nశరణమయ్యప్పా స్వామి శరణమయ్యప్పా...\nహరివరాసనం విశ్వమోహనం హరిదధీశ్వరం ఆరాధ్యపాదుకమ్...',
        slokaSa: 'लोकवीरं महापूज्यं सर्वरक्षाकरं विभुम् ।\nमनोहरं सुरश्रेष्ठं शास्तारं प्रणमाम्यहम् ॥\nशरणमय्यप्पा स्वामि शरणमय्यप्पा...\nहरिवरासनं विश्वमोहनं हरिदधीश्वरं आराध्यपादुकाम्...',
        transliteration: "lokavīraṃ mahāpūjyaṃ sarvarakṣākaraṃ vibhum...",
        tatparyam: 'సకల భయాలను హరించే ధర్మశాస్తా అయ్యప్పస్వామికి భక్తితో మంగళ హారతులను సమర్పిస్తున్నాను.',
        spiritualMeaning: 'కర్పూరం పూర్తిగా కరిగిపోయి ఎటువంటి బూడిదను మిగల్చదు. అలాగే మన అహంకారం కూడా జ్ఞానాగ్నిలో కరిగి పరమాత్మలో లీనం కావాలి.',
        audioKey: 'harathi',
      ),
      PujaStepModel(
        stepNumber: 10,
        stepId: 'udvasana',
        titleTe: '10. ప్రదక్షిణ, క్షమాపణ & ఉద్వాసన',
        titleSa: '१०. प्रदक्षिणा, क्षमापणम् & उद्धासनम्',
        actionInstructionTe: 'కుడివైపుకు మూడుసార్లు ప్రదక్షిణ చేసి, సాష్టాంగ నమస్కారం ఆచరించి తీర్థ ప్రసాదాలు స్వీకరించండి.',
        actionInstructionSa: 'प्रदक्षिणं कृत्वा, साष्टाङ्गं प्रणम्य तीर्थप्रसादं गृह्णीयात् ।',
        slokaTe: 'యానికాని చ పాపాని జన్మాంతరకృతాని చ |\nతాని తాని ప్రణశ్యంతి ప్రదక్షిణ పదే పదే ||\n\nమంత్రహీనం క్రియాహీనం భక్తిహీనం సురేశ్వర |\nయత్పూజితం మయా దేవ పరిపూర్ణం తదస్తు తే ||\nఆవాహనం న జానామి న జానామి విసర్జనమ్ |\nపూజావిధిం న జానామి క్షమస్వ పరమేశ్వర ||',
        slokaSa: 'यानिकानि च पापानि जन्मान्तरकृतानि च ।\nतानि तानि प्रणश्यन्ति प्रदक्षिणे पदे पदे ॥\n\nमन्त्रहीनं क्रियाहीनं भक्तिहीनं सुरेश्वर ।\nयत्पूजितं मया देव परिपूर्णं तदस्तु ते ॥\nआवाहनं न जानामि न जानामि विसर्जनम् ।\nपूजाविधिं न जानामि क्षमस्व परमेश्वर ॥',
        transliteration: "yānikāni ca pāpāni janmāntarakṛtāni ca...",
        tatparyam: 'తెలిసీ తెలియక చేసిన తప్పులను క్షమించి, నా పూజను సంపూర్ణంగా స్వీకరించి సర్వ మంగళాలను ప్రసాదించుము.',
        spiritualMeaning: 'మనలోని అహంకారాన్ని పూర్తిగా తుడిచివేసి, భగవంతుని దివ్య చైతన్యాన్ని తిరిగి మన హృదయ కమలంలో నిలుపుకోవడమే క్షమాపణ, ఉద్వాసనల రహస్యం.',
        audioKey: 'kshama',
      ),
    ];
  }

  void _nextStep() {
    if (_currentStepIndex < _pujaSteps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _isMeaningExpanded = false;
        _ashtottaraCounter = 0;
      });
    }
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
        _isMeaningExpanded = false;
        _ashtottaraCounter = 0;
      });
    }
  }

  void _incrementFlowerCounter() {
    if (_ashtottaraCounter < 108) {
      setState(() {
        _ashtottaraCounter++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var step = _pujaSteps[_currentStepIndex];
    double progress = (_currentStepIndex + 1) / _pujaSteps.length;

    return Scaffold(
      backgroundColor: AppTypography.saffronBackground,
      appBar: AppBar(
        backgroundColor: AppTypography.primaryMaroon,
        elevation: 2,
        title: Text(
          widget.deityNameTe,
          style: AppTypography.teluguSloka(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          // Script Switcher Button (తెలుగు / సంస్కృతం)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(
                _activeScript == 'telugu' ? 'संस्कृतम्' : 'తెలుగు',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              selected: true,
              selectedColor: AppTypography.sacredGold,
              onSelected: (selected) {
                setState(() {
                  _activeScript = _activeScript == 'telugu' ? 'sanskrit' : 'telugu';
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Top Progress Indicator (User-friendly step counter)
          Container(
            color: Colors.amber.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'దశ ${_currentStepIndex + 1} / ${_pujaSteps.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF78350F),
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}% పూర్తయింది',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF78350F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.amber.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTypography.templeDeepOrange),
                  ),
                ),
              ],
            ),
          ),

          // 2. Action Prompt Banner (స్పష్టమైన సూచన)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
            ),
            child: Row(
              children: [
                const Text('👉 ', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(
                    _activeScript == 'telugu' 
                        ? step.actionInstructionTe 
                        : step.actionInstructionSa,
                    style: AppTypography.meaningText(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Scrollable Sacred Sloka & Meaning Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Step Title Card
                  Text(
                    _activeScript == 'telugu' ? step.titleTe : step.titleSa,
                    style: AppTypography.sacredHeader(fontSize: 21),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Main Sloka Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.amber.shade300, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.shade900.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SelectableText(
                          _activeScript == 'telugu' ? step.slokaTe : step.slokaSa,
                          style: _activeScript == 'telugu'
                              ? AppTypography.teluguSloka(fontSize: 18.5)
                              : AppTypography.sanskritSloka(fontSize: 19.0),
                          textAlign: TextAlign.center,
                        ),

                        // Interactive Flower Counter (For 108 Ashtottaram)
                        if (step.hasInteractiveCounter) ...[
                          const Divider(height: 32, thickness: 1),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'సమర్పించిన పుష్పాలు: $_ashtottaraCounter / 108',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF9A3412),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: _incrementFlowerCounter,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTypography.templeDeepOrange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  icon: const Text('🌸', style: TextStyle(fontSize: 20)),
                                  label: const Text('పుష్పం సమర్పించండి (+1)', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 4. Learning Mode Accordion (ఈ దశ యొక్క అంతరార్థం & తాత్పర్యం)
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ExpansionTile(
                      initiallyExpanded: _isMeaningExpanded,
                      onExpansionChanged: (val) {
                        setState(() {
                          _isMeaningExpanded = val;
                        });
                      },
                      leading: const Text('💡', style: TextStyle(fontSize: 22)),
                      title: const Text(
                        'ఈ దశ యొక్క తాత్పర్యం & అంతరార్థం',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppTypography.primaryMaroon),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('📜 తాత్పర్యం:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF78350F))),
                              const SizedBox(height: 4),
                              Text(step.tatparyam, style: AppTypography.meaningText()),
                              const SizedBox(height: 12),
                              const Text('🧘 ఆధ్యాత్మిక అంతరార్థం (Inner Secret):', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF78350F))),
                              const SizedBox(height: 4),
                              Text(step.spiritualMeaning, style: AppTypography.meaningText()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5. Sticky Bottom Navigation Bar (యూజర్ ఫ్రెండ్లీ కంట్రోల్స్)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Previous Step Button
                if (_currentStepIndex > 0)
                  OutlinedButton.icon(
                    onPressed: _previousStep,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      side: const BorderSide(color: AppTypography.primaryMaroon),
                    ),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('వెనుకకు'),
                  ),

                const SizedBox(width: 8),

                // Audio Chanting Button
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isPlayingAudio = !_isPlayingAudio;
                    });
                  },
                  icon: Icon(
                    _isPlayingAudio ? Icons.pause_circle_filled : Icons.volume_up,
                    color: AppTypography.templeDeepOrange,
                    size: 36,
                  ),
                  tooltip: 'మంత్ర శ్రవణం',
                ),

                const Spacer(),

                // Next Step or Finish Button
                ElevatedButton.icon(
                  onPressed: _currentStepIndex < _pujaSteps.length - 1 ? _nextStep : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('🎉 స్వామి కృపతో మీ పూజ సంపూర్ణమైనది! మంగళం భవంతు! 🕉️')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentStepIndex < _pujaSteps.length - 1 
                        ? AppTypography.primaryMaroon 
                        : Colors.green.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: Icon(_currentStepIndex < _pujaSteps.length - 1 ? Icons.arrow_forward : Icons.check_circle),
                  label: Text(
                    _currentStepIndex < _pujaSteps.length - 1 ? 'తర్వాతి దశ ➔' : 'పూజ సంపూర్ణం ✨',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
