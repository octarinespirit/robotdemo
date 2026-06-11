from robot.api.deco import keyword

@keyword
def validate_account_response(json_data):
    balance = float(json_data["balance"])
    if balance < 0:
        raise AssertionError("Balance cannot be negative")
    return True

@keyword
def validate_expense_response(expense_json):
    required_fields = ["id", "amount", "date"]
    for field in required_fields:
        if field not in expense_json:
            raise AssertionError(f"Missing field in expense: {field}")
    try:
        float(expense_json["amount"])
    except (ValueError, TypeError):
        raise AssertionError(f"Expense amount not numeric: {expense_json['amount']}")
    return True
