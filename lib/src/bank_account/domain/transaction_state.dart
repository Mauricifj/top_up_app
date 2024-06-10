class TransactionState {
  const TransactionState();
}

class TransactionInitialState extends TransactionState {
  const TransactionInitialState() : super();
}

class TransactionCompleted extends TransactionState {
  const TransactionCompleted() : super();
}

class TransactionFailed extends TransactionState {
  final String errorMessage;

  const TransactionFailed(this.errorMessage) : super();
}

class TransactionInProgress extends TransactionState {
  const TransactionInProgress() : super();
}
