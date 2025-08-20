class AppConstants {
  // App Info
  static const String appName = 'SunuTontine';
  static const String appVersion = '1.0.0 "Teranga"';
  static const String appDescription = 
      'Tontines digitales avec transparence totale et automatisation complète';
  
  // Limits
  static const int maxTontineParticipants = 50;
  static const int minTontineParticipants = 2;
  static const double maxContributionAmount = 1000000; // 1M FCFA
  static const double minContributionAmount = 1000; // 1K FCFA
  static const int inviteCodeLength = 6;
  
  // Penalties
  static const double defaultPenaltyPercentage = 5.0;
  static const double maxPenaltyPercentage = 20.0;
  
  // SunuPoints
  static const int dailyConnectionPoints = 5;
  static const int paymentOnTimePoints = 10;
  static const int inviteFriendPoints = 100;
  static const int completeCyclePoints = 200;
  static const int helpCommunityPoints = 25;
  
  // URLs
  static const String supportEmail = 'support@sunutontine.sn';
  static const String supportPhone = '+221 77 123 4567';
  static const String websiteUrl = 'https://sunutontine.sn';
  static const String privacyPolicyUrl = 'https://sunutontine.sn/privacy';
  static const String termsOfServiceUrl = 'https://sunutontine.sn/terms';
  
  // Sample Data
  static const List<String> sampleParticipantNames = [
    'Aminata Diallo',
    'Moussa Seck',
    'Fatou Ndiaye',
    'Cheikh Sarr',
    'Awa Ba',
    'Ousmane Fall',
    'Mariam Cissé',
    'Ibrahima Diop',
    'Khady Gueye',
    'Mamadou Sy',
    'Astou Thiam',
    'Babacar Kane'
  ];
  
  static const List<String> motivationalQuotes = [
    'Ensemble, nous construisons notre prospérité',
    'L\'épargne collective, notre force traditionnelle',
    'La teranga au service de nos économies',
    'Unis dans l\'effort, récompensés ensemble',
    'La tontine, un héritage qui nous enrichit'
  ];
  
  static const List<String> tontineRules = [
    'Respecter les dates de paiement',
    'Maintenir un comportement courtois',
    'Payer les pénalités en cas de retard',
    'Participer activement aux discussions',
    'Signaler tout problème à l\'organisateur'
  ];
  
  // Colors (hex codes for reference)
  static const String primaryColorHex = '#2E7D4A'; // Green
  static const String secondaryColorHex = '#E4A853'; // Gold
  static const String tertiaryColorHex = '#D4391F'; // Red
}