import "../../events/register_event.dart";
import "../../../data/models/common_response_model.dart";

abstract class UserRepository {
  Future<CommonResponseModel> register(RegisterEvent register);
}
