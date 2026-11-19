/// భక్తుని కుటుంబ వివరాల మోడల్ (Devotee Profile Model)
class DevoteeProfile {
  String gotram;
  String kartaName;
  String spouseName;
  String childrenNames;
  String pincode;
  String city;
  String janmaNakshatra;
  String selectedDeityId;
  String preferredScript; // 'telugu' or 'sanskrit' or 'both'

  DevoteeProfile({
    this.gotram = 'పైడిపూండ్ల',
    this.kartaName = 'శ్రీనివాసరావు',
    this.spouseName = 'వాణి',
    this.childrenNames = 'హర్ష, అఖిల్',
    this.pincode = '522034',
    this.city = 'గుంటూరు',
    this.janmaNakshatra = 'ఉత్తరాషాఢ',
    this.selectedDeityId = 'ayyappa',
    this.preferredScript = 'both',
  });

  Map<String, dynamic> toJson() => {
    'gotram': gotram,
    'kartaName': kartaName,
    'spouseName': spouseName,
    'childrenNames': childrenNames,
    'pincode': pincode,
    'city': city,
    'janmaNakshatra': janmaNakshatra,
    'selectedDeityId': selectedDeityId,
    'preferredScript': preferredScript,
  };

  factory DevoteeProfile.fromJson(Map<String, dynamic> json) {
    return DevoteeProfile(
      gotram: json['gotram'] ?? 'పైడిపూండ్ల',
      kartaName: json['kartaName'] ?? 'శ్రీనివాసరావు',
      spouseName: json['spouseName'] ?? 'వాణి',
      childrenNames: json['childrenNames'] ?? 'హర్ష, అఖిల్',
      pincode: json['pincode'] ?? '522034',
      city: json['city'] ?? 'గుంటూరు',
      janmaNakshatra: json['janmaNakshatra'] ?? 'ఉత్తరాషాఢ',
      selectedDeityId: json['selectedDeityId'] ?? 'ayyappa',
      preferredScript: json['preferredScript'] ?? 'both',
    );
  }
}
