from robot.api.deco import keyword
import random

@keyword
def generate_random_expense():
    """Return a random expense amount between 1 and 100."""
    descriptions = ["Coffee", "Lunch", "Book", "Taxi", "Dinner", "Snack", "Movie", "Gym", "Gift", "Subscription"]
    location = random.choice(["Helsinki","Espoo","Tampere"])
    expense = {"amount": random.randint(-100, -1), "type": random.choice(descriptions), "location": location}
    print(f"Generated random expense: {expense}, {expense['amount'], expense['type'], expense['location']}")
    return expense
