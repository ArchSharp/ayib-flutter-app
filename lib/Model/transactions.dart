class AyibPayload {
  String beneficiary;
  String accountNumber;
  String narration;
  String amount;
  String email;
  String currency;

  AyibPayload({
    required this.beneficiary,
    required this.accountNumber,
    required this.narration,
    required this.amount,
    required this.currency,
    required this.email,
  });
}
