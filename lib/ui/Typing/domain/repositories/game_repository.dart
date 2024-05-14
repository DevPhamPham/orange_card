import '../../../../core/typedefs.dart';

abstract class TypingGameRepository {
  FutureEither<void> updateUserPoint(String uid, int point);
  FutureEither<void> updateUserGold(String uid, int gold);
}
