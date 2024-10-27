import 'package:monetar_ia/models/transaction.dart';

double calculateTotalRevenues(List<Transaction> revenues) {
  return revenues.fold(0.0, (sum, revenue) => sum + revenue.amount);
}

double calculateTotalExpenses(List<Transaction> expenses) {
  return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
}
