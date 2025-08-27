import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/api_models.dart';
import 'auth_interceptor.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "http://localhost:8080/api/v1/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  factory ApiClient.withInterceptors(Dio dio, {required String baseUrl}) {
    final client = _ApiClient(dio, baseUrl: baseUrl);
    dio.interceptors.add(AuthInterceptor(dio));
    return client;
  }

  /// Authentication Endpoints
  @POST("auth/request-registration-otp-sms")
  Future<void> requestRegistrationOtpSms(@Body() RequestOtpBody body);

  @POST("auth/request-registration-otp-email")
  Future<void> requestRegistrationOtpEmail(@Body() RequestOtpBody body);

  @POST("auth/register")
  Future<void> registerUser(@Body() RegisterUserBody body);

  @POST("auth/request-login-otp-sms")
  Future<void> requestLoginOtpSms(@Body() RequestOtpBody body);

  @POST("auth/request-login-otp-email")
  Future<void> requestLoginOtpEmail(@Body() RequestOtpBody body);

  @POST("auth/login")
  Future<void> loginUser(@Body() LoginUserBody body);

  @POST("auth/refresh")
  Future<TokenResponse> refreshAccessToken(@Body() RefreshTokenBody body);

  @GET("auth/health")
  Future<void> healthCheck();

  /// User Endpoints
  @GET("user/profile")
  Future<UserProfile> getUserProfile();

  @PUT("user/profile")
  Future<UserProfile> updateUserProfile(@Body() UpdateUserProfileBody body);

  /// Tontine Endpoints
  @POST("tontines")
  Future<Tontine> createTontine(@Body() CreateTontineBody body);

  @GET("tontines")
  Future<List<Tontine>> getUserTontines(
    @Query("status") String? status,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sortBy") String? sortBy,
    @Query("sortDir") String? sortDir,
  );

  @GET("tontines/{id}")
  Future<Tontine> getTontineDetails(@Path("id") int id);

  @PUT("tontines/{id}")
  Future<Tontine> updateTontine(
    @Path("id") int id,
    @Body() UpdateTontineBody body,
  );

  @DELETE("tontines/{id}")
  Future<void> deleteTontine(@Path("id") int id);

  @POST("tontines/{id}/activate")
  Future<void> activateTontine(@Path("id") int id);

  @POST("tontines/join")
  Future<void> joinTontine(@Body() JoinTontineBody body);

  @DELETE("tontines/{id}/leave")
  Future<void> leaveTontine(@Path("id") int id);

  @POST("tontines/{id}/contribute")
  Future<void> contributeToTontine(
    @Path("id") int id,
    @Body() ContributeToTontineBody body,
  );

  @GET("tontines/{id}/drawing-order")
  Future<void> getTontineDrawingOrder(@Path("id") int id);

  @POST("tontines/{id}/rounds/start")
  Future<void> startFirstRound(@Path("id") int id);

  @GET("tontines/{id}/rounds/current")
  Future<void> getCurrentRoundStatus(@Path("id") int id);

  @POST("tontines/{id}/rounds/draw")
  Future<void> conductDrawing(@Path("id") int id);

  @POST("tontines/{id}/rounds/force-advance")
  Future<void> forceAdvanceDrawing(@Path("id") int id);
}
