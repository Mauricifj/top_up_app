enum TransactionType {
  deposit('Deposit'),
  withdrawal('Withdrawal');

  final String displayName;
  const TransactionType(this.displayName);
}
