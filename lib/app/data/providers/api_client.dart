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
  Future<UserProfile> getUserProfile(@Header("Authorization") String authToken);

  @PUT("user/profile")
  Future<UserProfile> updateUserProfile(
    @Header("Authorization") String authToken,
    @Body() UpdateUserProfileBody body,
  );

  /// Tontine Endpoints
  @POST("tontines")
  Future<Tontine> createTontine(
    @Header("Authorization") String authToken,
    @Body() CreateTontineBody body,
  );

  @GET("tontines")
  Future<List<Tontine>> getUserTontines(
    @Header("Authorization") String authToken,
    @Query("status") String? status,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("sortBy") String? sortBy,
    @Query("sortDir") String? sortDir,
  );

  @GET("tontines/{id}")
  Future<Tontine> getTontineDetails(
    @Header("Authorization") String authToken,
    @Path("id") int id,
  );

  @PUT("tontines/{id}")
  Future<Tontine> updateTontine(
    @Header("Authorization") String authToken,
    @Path("id") int id,
    @Body() UpdateTontineBody body,
  );

  @DELETE("tontines/{id}")
  Future<void> deleteTontine(
    @Header("Authorization") String authToken,
    @Path("id") int id,
  );

  @POST("tontines/{id}/activate")
  Future<void> activateTontine(
    @Header("Authorization") String authToken,
    @Path("id") int id,
  );

  @POST("tontines/join")
  Future<void> joinTontine(
    @Header("Authorization") String authToken,
    @Body() JoinTontineBody body,
  );

  @DELETE("tontines/{id}/leave")
  Future<void> leaveTontine(
    @Header("Authorization") String authToken,
    @Path("id") int id,
  );

  @POST("tontines/{id}/contribute")
  Future<void> contributeToTontine(
    @Header("Authorization") String authToken,
    @Path("id") int id,
    @Body() ContributeToTontineBody body,
  );

  @GET("tontines/{id}/drawing-order")
  Future<void> getTontineDrawingOrder(
    @Header("Authorization") String authToken,
    @Path("id") int id,
  );

  @POST("tontines/{id}/rounds/start")
  Future<void> startFirstRound(
    @Header("Authorization") String authToken,
    @Path("id") int id,
  );

  @GET("tontines/{id}/rounds/current")
  Future<void> getCurrentRoundStatus(
    @Header("Authorization") String authToken,
    @Path("id") int id,
  );

  @POST("tontines/{id}/rounds/draw")
  Future<void> conductDrawing(
    @Header("Authorization") String authToken,
    @Path("id") int id,
  );

  @POST("tontines/{id}/rounds/force-advance")
  Future<void> forceAdvanceDrawing(
    @Header("Authorization") String authToken,
    @Path("id") int id,
  );
}
