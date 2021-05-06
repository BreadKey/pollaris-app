part of strings;

class _KoStrings extends Strings {
  @override
  String get id => "아이디";
  @override
  String get nickname => "닉네임";
  @override
  String get password => "패스워드";
  @override
  String get confirmPassword => "패스워드 확인";
  @override
  String get signIn => "로그인";
  @override
  String get signOut => "로그아웃";
  @override
  String get enterId => "아이디를 입력해주세요!";
  @override
  String get enterNickname => "닉네임을 입력해주세요!";
  @override
  String get enterPasword => "패스워드를 입력해주세요!";
  @override
  String get notMatchPassword => "패스워드가 일치하지 않습니다!";
  @override
  String get signInFailed => "아이디나 패스워드가 일치하지 않습니다!";
  @override
  String get signUp => "회원가입";
  @override
  String get verifyIdentity => "본인인증";
  @override
  String get requestVerificationCode => "인증번호 요청";
  @override
  String get invalidCode => "코드가 일치하지 않습니다!";
  const _KoStrings() : super._();
}
