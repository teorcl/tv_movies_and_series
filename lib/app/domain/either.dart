class Either<Left, Right> {
  final Left? _left;
  final Right? _right;
  final bool isLeft;

  Either._(this._left, this._right, this.isLeft);

  factory Either.left(Left left) {
    return Either._(left, null, true);
  }

  factory Either.right(Right right) {
    return Either._(null, right, false);
  }

  // Podria llamarse fold
  T when<T>(T Function(Left) left, T Function(Right) right) {
    if (isLeft) {
      return left(_left as Left);
    } else {
      return right(_right as Right);
    }
  }
}
