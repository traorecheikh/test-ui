import 'package:json_annotation/json_annotation.dart';

part 'api_models.g.dart';

// Authentication Models

@JsonSerializable()
class RequestOtpBody {
  final String identifier;

  RequestOtpBody({required this.identifier});

  factory RequestOtpBody.fromJson(Map<String, dynamic> json) =>
      _$RequestOtpBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RequestOtpBodyToJson(this);
}

@JsonSerializable()
class RegisterUserBody {
  final String phoneNumber;
  final String email;
  final String otpCode;
  final String fullName;
  final String preferredLanguage;
  final String? profilePictureUrl;

  RegisterUserBody({
    required this.phoneNumber,
    required this.email,
    required this.otpCode,
    required this.fullName,
    required this.preferredLanguage,
    this.profilePictureUrl,
  });

  factory RegisterUserBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserBodyToJson(this);
}

@JsonSerializable()
class LoginUserBody {
  final String identifier;
  final String otpCode;

  LoginUserBody({required this.identifier, required this.otpCode});

  factory LoginUserBody.fromJson(Map<String, dynamic> json) =>
      _$LoginUserBodyFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUserBodyToJson(this);
}

@JsonSerializable()
class RefreshTokenBody {
  final String refreshToken;

  RefreshTokenBody({required this.refreshToken});

  factory RefreshTokenBody.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenBodyToJson(this);
}

@JsonSerializable()
class TokenResponse {
  final String accessToken;
  final String refreshToken;

  TokenResponse({required this.accessToken, required this.refreshToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}

// User Models

@JsonSerializable()
class UserProfile {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? preferredLanguage;
  final String? city;
  final String? region;
  final String? country;
  final String? profilePictureUrl;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.preferredLanguage,
    this.city,
    this.region,
    this.country,
    this.profilePictureUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

@JsonSerializable()
class UpdateUserProfileBody {
  final String? fullName;
  final String? email;
  final String? preferredLanguage;
  final String? city;
  final String? region;
  final String? country;

  UpdateUserProfileBody({
    this.fullName,
    this.email,
    this.preferredLanguage,
    this.city,
    this.region,
    this.country,
  });

  factory UpdateUserProfileBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserProfileBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserProfileBodyToJson(this);
}

// Tontine Models

@JsonSerializable()
class CreateTontineBody {
  final String name;
  final String description;
  final double contributionAmount;
  final String currency;
  final String frequency;
  final int maxParticipants;
  final int maxHandsPerParticipant;
  final String drawingOrderType;
  final String category;
  final bool organizerParticipates;
  final int organizerNumberOfHands;
  final PenaltySettings penaltySettings;

  CreateTontineBody({
    required this.name,
    required this.description,
    required this.contributionAmount,
    required this.currency,
    required this.frequency,
    required this.maxParticipants,
    required this.maxHandsPerParticipant,
    required this.drawingOrderType,
    required this.category,
    required this.organizerParticipates,
    required this.organizerNumberOfHands,
    required this.penaltySettings,
  });

  factory CreateTontineBody.fromJson(Map<String, dynamic> json) =>
      _$CreateTontineBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTontineBodyToJson(this);
}

@JsonSerializable()
class PenaltySettings {
  final int gracePeriodDays;
  final double penaltyRate;
  final int maxPenaltyPercent;

  PenaltySettings({
    required this.gracePeriodDays,
    required this.penaltyRate,
    required this.maxPenaltyPercent,
  });

  factory PenaltySettings.fromJson(Map<String, dynamic> json) =>
      _$PenaltySettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PenaltySettingsToJson(this);
}

@JsonSerializable()
class Tontine {
  final int id;
  final String name;
  final String description;
  final String joinCode;
  final String status;
  final double contributionAmount;
  final String currency;
  final String frequency;
  final int numberOfRounds;
  final int currentRound;
  final int maxParticipants;
  final int maxHandsPerParticipant;
  final String drawingOrderType;
  final String category;
  final int currentParticipants;
  final UserProfile? designatedWinner;
  final DateTime? nextDrawingDate;
  final UserProfile organizer;
  final List<Participant> participants;
  final PenaltyConfiguration penaltyConfiguration;
  final FinancialSummary financialSummary;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tontine({
    required this.id,
    required this.name,
    required this.description,
    required this.joinCode,
    required this.status,
    required this.contributionAmount,
    required this.currency,
    required this.frequency,
    required this.numberOfRounds,
    required this.currentRound,
    required this.maxParticipants,
    required this.maxHandsPerParticipant,
    required this.drawingOrderType,
    required this.category,
    required this.currentParticipants,
    this.designatedWinner,
    this.nextDrawingDate,
    required this.organizer,
    required this.participants,
    required this.penaltyConfiguration,
    required this.financialSummary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tontine.fromJson(Map<String, dynamic> json) =>
      _$TontineFromJson(json);

  Map<String, dynamic> toJson() => _$TontineToJson(this);
}

@JsonSerializable()
class Participant {
  final int id;
  final int userId;
  final String fullName;
  final String phoneNumber;
  final int numberOfHands;
  final String status;
  final double totalContributed;
  final double totalReceived;
  final int missedPayments;
  final DateTime joinedAt;

  Participant({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.numberOfHands,
    required this.status,
    required this.totalContributed,
    required this.totalReceived,
    required this.missedPayments,
    required this.joinedAt,
  });

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}

@JsonSerializable()
class PenaltyConfiguration {
  final bool enabled;
  final int gracePeriodDays;
  final double penaltyRate;
  final int maxPenaltyPercent;

  PenaltyConfiguration({
    required this.enabled,
    required this.gracePeriodDays,
    required this.penaltyRate,
    required this.maxPenaltyPercent,
  });

  factory PenaltyConfiguration.fromJson(Map<String, dynamic> json) =>
      _$PenaltyConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$PenaltyConfigurationToJson(this);
}

@JsonSerializable()
class FinancialSummary {
  final double totalExpected;
  final double totalCollected;
  final double totalDistributed;
  final double totalPenalties;
  final double currentBalance;
  final double completionPercentage;

  FinancialSummary({
    required this.totalExpected,
    required this.totalCollected,
    required this.totalDistributed,
    required this.totalPenalties,
    required this.currentBalance,
    required this.completionPercentage,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) =>
      _$FinancialSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$FinancialSummaryToJson(this);
}

@JsonSerializable()
class UpdateTontineBody {
  final String? name;
  final String? description;
  final int? maxParticipants;
  final String? drawingOrderType;

  UpdateTontineBody({
    this.name,
    this.description,
    this.maxParticipants,
    this.drawingOrderType,
  });

  factory UpdateTontineBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateTontineBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTontineBodyToJson(this);
}

@JsonSerializable()
class JoinTontineBody {
  final String joinCode;
  final int numberOfHands;

  JoinTontineBody({required this.joinCode, required this.numberOfHands});

  factory JoinTontineBody.fromJson(Map<String, dynamic> json) =>
      _$JoinTontineBodyFromJson(json);

  Map<String, dynamic> toJson() => _$JoinTontineBodyToJson(this);
}

@JsonSerializable()
class ContributeToTontineBody {
  final double amount;

  ContributeToTontineBody({required this.amount});

  factory ContributeToTontineBody.fromJson(Map<String, dynamic> json) =>
      _$ContributeToTontineBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ContributeToTontineBodyToJson(this);
}
