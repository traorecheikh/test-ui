// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestOtpBody _$RequestOtpBodyFromJson(Map<String, dynamic> json) =>
    RequestOtpBody(identifier: json['identifier'] as String);

Map<String, dynamic> _$RequestOtpBodyToJson(RequestOtpBody instance) =>
    <String, dynamic>{'identifier': instance.identifier};

RegisterUserBody _$RegisterUserBodyFromJson(Map<String, dynamic> json) =>
    RegisterUserBody(
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      otpCode: json['otpCode'] as String,
      fullName: json['fullName'] as String,
      preferredLanguage: json['preferredLanguage'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );

Map<String, dynamic> _$RegisterUserBodyToJson(RegisterUserBody instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'otpCode': instance.otpCode,
      'fullName': instance.fullName,
      'preferredLanguage': instance.preferredLanguage,
      'profilePictureUrl': instance.profilePictureUrl,
    };

LoginUserBody _$LoginUserBodyFromJson(Map<String, dynamic> json) =>
    LoginUserBody(
      identifier: json['identifier'] as String,
      otpCode: json['otpCode'] as String,
    );

Map<String, dynamic> _$LoginUserBodyToJson(LoginUserBody instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'otpCode': instance.otpCode,
    };

RefreshTokenBody _$RefreshTokenBodyFromJson(Map<String, dynamic> json) =>
    RefreshTokenBody(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$RefreshTokenBodyToJson(RefreshTokenBody instance) =>
    <String, dynamic>{'refreshToken': instance.refreshToken};

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: (json['id'] as num).toInt(),
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  email: json['email'] as String?,
  preferredLanguage: json['preferredLanguage'] as String?,
  city: json['city'] as String?,
  region: json['region'] as String?,
  country: json['country'] as String?,
  profilePictureUrl: json['profilePictureUrl'] as String?,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'preferredLanguage': instance.preferredLanguage,
      'city': instance.city,
      'region': instance.region,
      'country': instance.country,
      'profilePictureUrl': instance.profilePictureUrl,
    };

UpdateUserProfileBody _$UpdateUserProfileBodyFromJson(
  Map<String, dynamic> json,
) => UpdateUserProfileBody(
  fullName: json['fullName'] as String?,
  email: json['email'] as String?,
  preferredLanguage: json['preferredLanguage'] as String?,
  city: json['city'] as String?,
  region: json['region'] as String?,
  country: json['country'] as String?,
);

Map<String, dynamic> _$UpdateUserProfileBodyToJson(
  UpdateUserProfileBody instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'email': instance.email,
  'preferredLanguage': instance.preferredLanguage,
  'city': instance.city,
  'region': instance.region,
  'country': instance.country,
};

CreateTontineBody _$CreateTontineBodyFromJson(Map<String, dynamic> json) =>
    CreateTontineBody(
      name: json['name'] as String,
      description: json['description'] as String,
      contributionAmount: (json['contributionAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      frequency: json['frequency'] as String,
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      maxHandsPerParticipant: (json['maxHandsPerParticipant'] as num).toInt(),
      drawingOrderType: json['drawingOrderType'] as String,
      category: json['category'] as String,
      organizerParticipates: json['organizerParticipates'] as bool,
      organizerNumberOfHands: (json['organizerNumberOfHands'] as num).toInt(),
      penaltySettings: PenaltySettings.fromJson(
        json['penaltySettings'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CreateTontineBodyToJson(CreateTontineBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'contributionAmount': instance.contributionAmount,
      'currency': instance.currency,
      'frequency': instance.frequency,
      'maxParticipants': instance.maxParticipants,
      'maxHandsPerParticipant': instance.maxHandsPerParticipant,
      'drawingOrderType': instance.drawingOrderType,
      'category': instance.category,
      'organizerParticipates': instance.organizerParticipates,
      'organizerNumberOfHands': instance.organizerNumberOfHands,
      'penaltySettings': instance.penaltySettings,
    };

PenaltySettings _$PenaltySettingsFromJson(Map<String, dynamic> json) =>
    PenaltySettings(
      gracePeriodDays: (json['gracePeriodDays'] as num).toInt(),
      penaltyRate: (json['penaltyRate'] as num).toDouble(),
      maxPenaltyPercent: (json['maxPenaltyPercent'] as num).toInt(),
    );

Map<String, dynamic> _$PenaltySettingsToJson(PenaltySettings instance) =>
    <String, dynamic>{
      'gracePeriodDays': instance.gracePeriodDays,
      'penaltyRate': instance.penaltyRate,
      'maxPenaltyPercent': instance.maxPenaltyPercent,
    };

Tontine _$TontineFromJson(Map<String, dynamic> json) => Tontine(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  joinCode: json['joinCode'] as String,
  status: json['status'] as String,
  contributionAmount: (json['contributionAmount'] as num).toDouble(),
  currency: json['currency'] as String,
  frequency: json['frequency'] as String,
  numberOfRounds: (json['numberOfRounds'] as num).toInt(),
  currentRound: (json['currentRound'] as num).toInt(),
  maxParticipants: (json['maxParticipants'] as num).toInt(),
  maxHandsPerParticipant: (json['maxHandsPerParticipant'] as num).toInt(),
  drawingOrderType: json['drawingOrderType'] as String,
  category: json['category'] as String,
  currentParticipants: (json['currentParticipants'] as num).toInt(),
  designatedWinner: json['designatedWinner'] == null
      ? null
      : UserProfile.fromJson(json['designatedWinner'] as Map<String, dynamic>),
  nextDrawingDate: json['nextDrawingDate'] == null
      ? null
      : DateTime.parse(json['nextDrawingDate'] as String),
  organizer: UserProfile.fromJson(json['organizer'] as Map<String, dynamic>),
  participants: (json['participants'] as List<dynamic>)
      .map((e) => Participant.fromJson(e as Map<String, dynamic>))
      .toList(),
  penaltyConfiguration: PenaltyConfiguration.fromJson(
    json['penaltyConfiguration'] as Map<String, dynamic>,
  ),
  financialSummary: FinancialSummary.fromJson(
    json['financialSummary'] as Map<String, dynamic>,
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TontineToJson(Tontine instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'joinCode': instance.joinCode,
  'status': instance.status,
  'contributionAmount': instance.contributionAmount,
  'currency': instance.currency,
  'frequency': instance.frequency,
  'numberOfRounds': instance.numberOfRounds,
  'currentRound': instance.currentRound,
  'maxParticipants': instance.maxParticipants,
  'maxHandsPerParticipant': instance.maxHandsPerParticipant,
  'drawingOrderType': instance.drawingOrderType,
  'category': instance.category,
  'currentParticipants': instance.currentParticipants,
  'designatedWinner': instance.designatedWinner,
  'nextDrawingDate': instance.nextDrawingDate?.toIso8601String(),
  'organizer': instance.organizer,
  'participants': instance.participants,
  'penaltyConfiguration': instance.penaltyConfiguration,
  'financialSummary': instance.financialSummary,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  numberOfHands: (json['numberOfHands'] as num).toInt(),
  status: json['status'] as String,
  totalContributed: (json['totalContributed'] as num).toDouble(),
  totalReceived: (json['totalReceived'] as num).toDouble(),
  missedPayments: (json['missedPayments'] as num).toInt(),
  joinedAt: DateTime.parse(json['joinedAt'] as String),
);

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'numberOfHands': instance.numberOfHands,
      'status': instance.status,
      'totalContributed': instance.totalContributed,
      'totalReceived': instance.totalReceived,
      'missedPayments': instance.missedPayments,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };

PenaltyConfiguration _$PenaltyConfigurationFromJson(
  Map<String, dynamic> json,
) => PenaltyConfiguration(
  enabled: json['enabled'] as bool,
  gracePeriodDays: (json['gracePeriodDays'] as num).toInt(),
  penaltyRate: (json['penaltyRate'] as num).toDouble(),
  maxPenaltyPercent: (json['maxPenaltyPercent'] as num).toInt(),
);

Map<String, dynamic> _$PenaltyConfigurationToJson(
  PenaltyConfiguration instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'gracePeriodDays': instance.gracePeriodDays,
  'penaltyRate': instance.penaltyRate,
  'maxPenaltyPercent': instance.maxPenaltyPercent,
};

FinancialSummary _$FinancialSummaryFromJson(Map<String, dynamic> json) =>
    FinancialSummary(
      totalExpected: (json['totalExpected'] as num).toDouble(),
      totalCollected: (json['totalCollected'] as num).toDouble(),
      totalDistributed: (json['totalDistributed'] as num).toDouble(),
      totalPenalties: (json['totalPenalties'] as num).toDouble(),
      currentBalance: (json['currentBalance'] as num).toDouble(),
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$FinancialSummaryToJson(FinancialSummary instance) =>
    <String, dynamic>{
      'totalExpected': instance.totalExpected,
      'totalCollected': instance.totalCollected,
      'totalDistributed': instance.totalDistributed,
      'totalPenalties': instance.totalPenalties,
      'currentBalance': instance.currentBalance,
      'completionPercentage': instance.completionPercentage,
    };

UpdateTontineBody _$UpdateTontineBodyFromJson(Map<String, dynamic> json) =>
    UpdateTontineBody(
      name: json['name'] as String?,
      description: json['description'] as String?,
      maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
      drawingOrderType: json['drawingOrderType'] as String?,
    );

Map<String, dynamic> _$UpdateTontineBodyToJson(UpdateTontineBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'maxParticipants': instance.maxParticipants,
      'drawingOrderType': instance.drawingOrderType,
    };

JoinTontineBody _$JoinTontineBodyFromJson(Map<String, dynamic> json) =>
    JoinTontineBody(
      joinCode: json['joinCode'] as String,
      numberOfHands: (json['numberOfHands'] as num).toInt(),
    );

Map<String, dynamic> _$JoinTontineBodyToJson(JoinTontineBody instance) =>
    <String, dynamic>{
      'joinCode': instance.joinCode,
      'numberOfHands': instance.numberOfHands,
    };

ContributeToTontineBody _$ContributeToTontineBodyFromJson(
  Map<String, dynamic> json,
) => ContributeToTontineBody(amount: (json['amount'] as num).toDouble());

Map<String, dynamic> _$ContributeToTontineBodyToJson(
  ContributeToTontineBody instance,
) => <String, dynamic>{'amount': instance.amount};
