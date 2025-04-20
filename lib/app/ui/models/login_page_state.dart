class LoginPageState {
  final bool isProcessing;
  final bool hidePassword;

  LoginPageState({required this.isProcessing, required this.hidePassword});
  factory LoginPageState.initial() {
    return LoginPageState(isProcessing: false, hidePassword: true);
  }
  LoginPageState copyWith({bool? isProcessing, bool? hidePassword}) {
    return LoginPageState(
      isProcessing: isProcessing ?? this.isProcessing,
      hidePassword: hidePassword ?? this.hidePassword,
    );
  }
}
