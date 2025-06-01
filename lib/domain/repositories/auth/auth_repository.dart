import "../../../data/models/auth/login_response_model.dart";
import "../../../data/models/common_response_model.dart";
import "../../events/register_event.dart";

abstract class AuthRepository {
  Future<LoginResponseModel> login(String email, String password);
  Future<CommonResponseModel> register(RegisterEvent register);
}
